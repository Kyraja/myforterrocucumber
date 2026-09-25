@persistent
Feature: Zugangscharge_Fertigung.feature

Background:
And I set the fake date to "16.01.1995"

# **********************************************************************************
#  Name             : Zugangscharge_Fertigung.feature
#  Autor            : bschiga
#  Verantwortlich   : bschiga
#  Kontrolle        : carue
#  Funktion         : Testet Chargen-/Seriennummernverwaltung
#  ref              : ref_chargen_seriennr_cu
#
# **********************************************************************************


Scenario: ZT01 Zugangscharge in der Fertigung - im Fertigungsvorschlag Zugangscharge in der AFL angeben, Plausi dass zum Fertigteil passt und Test der Icon

Given I create a Lot "C1ZT01ZU" for Product "BG03_CHARGE"
Given I create a Lot "C2ZT01ZU" for Product "BG02_CHARGE"
Given I create a Lot "C1ZT01AB1" for Product "EK01_CHARGE"
Given I create a Lot "C1ZT01AB2" for Product "EK02_CHARGE"

# Fertigungsvorschlag anlegen
Given I open an editor "FVZT01" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
And I append rows
    | artikel       | verw   |netmge | mfreig   |
    | BG03_CHARGE   | ZT01   |20     | ja       |
And I press button "absteig" to open a subeditor for "AFL" in row !lastRow
And I modify table
    | !row | charge     | zcharge   |
    | 1    | C1ZT01AB1  | C1ZT01ZU  |
# 3166  Artikel stimmt nicht mit dem Artikel der Charge überein
Then setting field "zcharge" to "C2ZT01ZU" in row 3 throws the exception "3166"
And I modify table
    | !row | charge     | zcharge   |
    | 3    | C1ZT01AB2  | C1ZT01ZU  |
And I press button "mzsubm" to open a subeditor for "EntnahmeMZ" in row 3
And I create a new row at position 1
Then setting field "zcharge" to "C2ZT01ZU" in row 1 throws the exception "3166"
And I modify table
    | !row | lpsuch | zuomge    | charge     | zcharge   |
    | 1    | F1     | 10        | C1ZT01AB2  | C1ZT01ZU  |
#    | +2   | F2     | 10        | C1ZT01AB2  | C1ZT01ZU  |
And I save the current editor
And I switch the current editor to editor "AFL"
And I save the current editor
And I switch the current editor to editor "FVZT01"
And I save the current editor

Given I open an editor "FVZT01" from table "(Purchasing)" with command "UPDATE" for search criteria "$,,artikel=BG03_CHARGE;verw=ZT01;@gruppe=5"
Then field "chzuordnung" has value "icon:barcode_cross_red"
And I set field "charge" to "C1ZT01ZU"
Then field "chzuordnung" has value "icon:barcode_exclamationmark_triangle_yellow"
And I press button "mzabsm" to open a subeditor for "EntnahmeMZ"
And I press button for next product
And I append rows
    | lpsuch | zuomge    | charge     |
    | F2     | 10        | C1ZT01AB2  |
And I save the current editor
And I switch the current editor to editor "FVZT01"
Then field "chzuordnung" has value "icon:barcode_tick_green"
And I save the current editor

Given I open an editor "FVZT02" from table "(Purchasing)" with command "RELEASE" for search criteria "$,,artikel=BG03_CHARGE;verw=ZT01;@gruppe=5"
And I set field "bisuch" to "ZT01_"
And I set field "mfreig" to "ja"
And I save the current editor


Scenario: ZT03 Im Fertigungsvorschlag Zugangscharge in der AFL bei Koppelprodukt nicht aenderbar und gebucht wird tcharge aus MZ, statt charge aus Kopf der FBU

Given I create a Lot "C1ZT03ZU" for Product "BG_CHARGE_KOPPEL"

# Fertigungsvorschlag anlegen, Schreibschutz pruefen, auch in der EntnahmeMZ
Given I open an editor "FVZT03" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
And I append rows
    | artikel           | netmge | mfreig   |
    | BG_CHARGE_KOPPEL  | 20     | ja       |
And I press button "absteig" to open a subeditor for "AFL" in row !lastRow
Then field "kompeig" has value "Koppelprodukt" in row 2
Then field "zcharge" is not modifiable in row 2
Then field "ztcharge" is not modifiable in row 2
Then field "kompeig" is empty in row 1
Then field "zcharge" is modifiable in row 1
Then field "ztcharge" is modifiable in row 1
And I press button "mzsubm" to open a subeditor for "EntnahmeMZ" in row 2
And I create a new row at position 1
Then field "zcharge" is not modifiable in row 1
Then field "ztcharge" is not modifiable in row 1
And I close the current editor
And I switch the current editor to editor "AFL"
And I press button "mzsubm" to open a subeditor for "EntnahmeMZ" in row 1
And I create a new row at position 1
Then field "zcharge" is modifiable in row 1
Then field "ztcharge" is modifiable in row 1
And I close the current editor
And I switch the current editor to editor "AFL"
And I close the current editor
And I switch the current editor to editor "FVZT03"
And I press button "mzabsm" to open a subeditor for "EntnahmeMZ" in row 1
And I press button for next product
Then field "artikel" has value "KOPPELCHARGE"
And I create a new row at position 1
Then field "zcharge" is not modifiable in row 1
Then field "ztcharge" is not modifiable in row 1
And I close the current editor
And I switch the current editor to editor "FVZT03"
And I set field "bisuch" to "ZT03_" in row 1
And I press button "freig" to open a subeditor for "BA_freigeben"
And I save the current subeditor to switch back to the parent editor
And I save the current editor

# bei Materialentnahme sind reszcharge und treszcharge als zugehende Charge auch schreibgeschuetzt, ebenfalls zcharge und ztcharge in der MZ
# zugehende Charge fuer Koppelprodukt in tcharge angeben
Given I open an editor "MATENT1" for tip command "Fbuchung" and arguments ""
And I set fields
    | auftrag   | ZT03_001      |
    | bem       | EntnahmeZT03  |
    | autorment | ja            |
    | charge    | !C1ZT03ZU^id  |
And I press button "stlvblad"
Then table has values
    | elex              | bumge |
    | EK01_CHARGE       | 0     |
    | KOPPELCHARGE      | 20    |
Then field "reszcharge" is not modifiable in row 2
Then field "treszcharge" is not modifiable in row 2
Then field "kompeig" is empty in row 1
Then field "reszcharge" is modifiable in row 1
Then field "treszcharge" is modifiable in row 1
And I press button "mzsubm" to open a subeditor for "EntnahmeMZ" in row 2
Then field "zcharge" is not modifiable in row 1
Then field "ztcharge" is not modifiable in row 1
And I set field "tcharge" to "CH1_KOPPELZU" in row 1
And I save the current editor
And I switch the current editor to editor "MATENT1"
And I set field "manbu" to "ja" in row 1
And I set field "bumge" to "20" in row 1
And I set field "tvcharge" to "C1ZT03AB" in row 1
And I set field "ljtext1" to "MATENT1" in row 1
And I save the current editor

# gebuchte Materialentnahme oeffnen um Zugriff auf Belegnummer barmex zu haben
Given I open an editor "FBUBELEG" from table "(Workorder):(CompletionConfirmations)" with command "VIEW" for search criteria "$,,such=ZT03_001;bem=EntnahmeZT03;@ablage=abgelegt;@richtung=rückwärts;@maxordtreffer=1"
And I save value from field "barmex" in row 0
And I close the current editor

# Buchungen im LJ pruefen, zugehende Charge fuer Koppelprodukt aus tcharge der MZ, NICHT aus Kopf der FBU
And I open the infosystem "LJ"
And I set field "adatum" to "."
And I set field "beleg" in row 0 to saved value
And I set field "artikel" to "KOPPELCHARGE"
And I press start
Then table has values
    | zmge | amge     | tvcharge  | tncharge     |
    | 20   |          |           | CH1_KOPPELZU |
And I set field "artikel" to "EK01_CHARGE"
And I press start
Then table has values
    | zmge | amge     | tvcharge  | tncharge  | ncharge^id   |
    |      | 20       | C1ZT03AB  | C1ZT03ZU  | !C1ZT03ZU^id |
And I close the current editor


Scenario: ZT02 Zugangscharge in der Fertigung - EntnahmeMZ fuer retrogrades Material erfassen
# Zugangscharge im Kopf der Rueckmeldung, entsprechende Zeile der EntnahmeMZ wird gebucht

Given I create a work order "ZT02" for Product "BG01_CHARGE" with quantity "20" and search word "ZT02_"

Given I create a Lot "C1ZT02ZU" for Product "BG01_CHARGE"
Given I create a Lot "C2ZT02ZU" for Product "BG01_CHARGE"
Given I create a Lot "C3ZT02ZU" for Product "BG01_CHARGE"
Given I create a Lot "C1ZT02AB1" for Product "EK01_CHARGE"
Given I create a Lot "C2ZT02AB1" for Product "EK01_CHARGE"
Given I create a Lot "C3ZT02AB1" for Product "EK01_CHARGE"
Given I create a Lot "C1ZT02AB2" for Product "EK02_CHARGE"
Given I create a Lot "C2ZT02AB2" for Product "EK02_CHARGE"
Given I create a Lot "C3ZT02AB2" for Product "EK02_CHARGE"

Given I open an editor "BAZT02" from table "(Workorder):(WorkOrders)" with command "UPDATE" for record "ZT02_000"
And I press button "absteig" to open a subeditor for "AFL"
And I save value from field "id" in row 1
And I press button "mzsubm" to open a subeditor for "EntnahmeMZ" in row 1
And I modify table
    | !row  | lpsuch | zuomge   | charge    | zcharge      |
    | +1    | F1     | 10       | C1ZT02AB1 | !C1ZT02ZU^id |
    | +2    | F1     | 5        | C2ZT02AB1 | !C2ZT02ZU^id |
    | +3    | F1     | 5        | C3ZT02AB1 | !C3ZT02ZU^id |
And I press button for next product
And I modify table
    | !row  | lpsuch | zuomge   | charge    | zcharge      |
    | +1    | F1     | 10       | C1ZT02AB2 | !C1ZT02ZU^id |
    | +2    | F1     | 5        | C2ZT02AB2 | !C2ZT02ZU^id |
    | +3    | F1     | 5        | C3ZT02AB2 | !C3ZT02ZU^id |
And I save the current editor
And I switch the current editor to editor "AFL"
And I save the current editor
And I switch the current editor to editor "BAZT02"
And I save the current editor

# Rueckmeldung Teilmenge auf Arbeitsschein 2, Zugangscharge aus der zweiten Zeile der MZ
Given I open an editor "RM1_ZT02" from table "(Workorder):(WorkOrders)" with command "DONE" for search criteria "$,,such=ZT02_002;@richtung=rückwärts;@maxordtreffer=1"
And I set fields
    | sofort    | ja            |
    | kcharge   | !C2ZT02ZU^id  |
    | bem       | RM1_ZT02      |
And I set field "gutmge" to "5" in row 1
And I set field "erbtext1" to "RM1_ZT02" in row 1
And I save the current editor

Given I open LotTracking "chverfobjekt" for receipt Lot "C2ZT02ZU" and issue Lot "C2ZT02AB1" and product list element "EK01_CHARGE" and receipt movement "ZT02" with command "VIEW"
Then field "reserv^id" in row 0 equals saved value
And I close the current editor

Given I open an editor "BAZT02" from table "(Workorder):(WorkOrders)" with command "VIEW" for record "ZT02_000"
And I press button "absteig" to open a subeditor for "AFL"
And I save value from field "id" in row 3
And I close the current editor
And I switch the current editor to editor "BAZT02"
And I close the current editor

Given I open LotTracking "chverfobjekt" for receipt Lot "C2ZT02ZU" and issue Lot "C2ZT02AB2" and product list element "EK02_CHARGE" and receipt movement "ZT02" with command "VIEW"
Then field "reserv^id" in row 0 equals saved value
And I close the current editor

# die Chargen aus der zweiten Zeile der MZ wurden gebucht fuer das Entnahmematerial
Given I open an editor "RM1Pruef" via ID from editor "RM1_ZT02" from field "id" in row 0 for table "(Workorder):(CompletionConfirmations)" with command "VIEW"
Then the table has 3 rows
Then table has values
    | artikel     | mge   | gutmge    | charge^id       |
    | BG01_CHARGE | 20    | 5         | !C2ZT02ZU^id    |
    | EK02_CHARGE | 5     | 0         | (0,0,0)         |
    | EK01_CHARGE | 5     | 0         | (0,0,0)         |
And I press button "mzabsm" to open a subeditor for "EntnahmeMZ" in row 2
Then table has values
    | lpsuch | zuomge   | charge^id         |
    | F1     | 5        | !C2ZT02AB2^id     |
And I press button for next product
Then table has values
    | lpsuch | zuomge   | charge^id         |
    | F1     | 5        | !C2ZT02AB1^id     |
And I close the current editor
And I switch the current editor to editor "RM1Pruef"
And I close the current editor

# Rueckmeldung Teilmenge auf Arbeitsschein 2, Zugangscharge aus der ersten Zeile der MZ
Given I open an editor "RM2_ZT02" from table "(Workorder):(WorkOrders)" with command "DONE" for search criteria "$,,such=ZT02_002;@richtung=rückwärts;@maxordtreffer=1"
And I set fields
    | sofort    | ja            |
    | kcharge   | !C1ZT02ZU^id  |
    | bem       | RM2_ZT02      |
And I set field "gutmge" to "5" in row 1
And I set field "erbtext1" to "RM2_ZT02" in row 1
And I save the current editor

# die Chargen aus der ersten Zeile der MZ wurden gebucht fuer das Entnahmematerial
Given I open an editor "RM2Pruef" via ID from editor "RM2_ZT02" from field "id" in row 0 for table "(Workorder):(CompletionConfirmations)" with command "VIEW"
Then the table has 3 rows
Then table has values
    | artikel     | mge   | gutmge    | charge^id       |
    | BG01_CHARGE | 15    | 5         | !C1ZT02ZU^id    |
    | EK02_CHARGE | 5     | 0         | (0,0,0)         |
    | EK01_CHARGE | 5     | 0         | (0,0,0)         |
And I press button "mzabsm" to open a subeditor for "EntnahmeMZ" in row 2
Then table has values
    | lpsuch | zuomge   | charge^id         |
    | F1     | 5        | !C1ZT02AB2^id     |
And I press button for next product
Then table has values
    | lpsuch | zuomge   | charge^id         |
    | F1     | 5        | !C1ZT02AB1^id     |
And I close the current editor
And I switch the current editor to editor "RM2Pruef"
And I close the current editor

# Rueckmeldung Teilmenge auf Arbeitsschein 2, Zugangscharge aus der dritten Zeile der MZ
Given I open an editor "RM3_ZT02" from table "(Workorder):(WorkOrders)" with command "DONE" for search criteria "$,,such=ZT02_002;@richtung=rückwärts;@maxordtreffer=1"
And I set fields
    | sofort    | ja            |
    | kcharge   | !C3ZT02ZU^id  |
    | bem       | RM3_ZT02      |
And I set field "gutmge" to "10" in row 1
And I set field "erbtext1" to "RM3_ZT02" in row 1
And I save the current editor

# die Chargen aus der dritten Zeile der MZ wurden gebucht fuer das Entnahmematerial, aber nur 5 Stk., da nur 5 Stk in der EntnahmeMZ mit passender Charge
Given I open an editor "RM3Pruef" via ID from editor "RM3_ZT02" from field "id" in row 0 for table "(Workorder):(CompletionConfirmations)" with command "VIEW"
Then the table has 3 rows
Then table has values
    | artikel     | mge   | gutmge    | charge^id       |
    | BG01_CHARGE | 10    | 10        | !C3ZT02ZU^id    |
    | EK02_CHARGE | 5     | 0         | (0,0,0)         |
    | EK01_CHARGE | 5     | 0         | (0,0,0)         |
And I press button "mzabsm" to open a subeditor for "EntnahmeMZ" in row 2
Then table has values
    | lpsuch | zuomge   | charge^id         |
    | F1     | 5        | !C3ZT02AB2^id     |
And I press button for next product
Then table has values
    | lpsuch | zuomge   | charge^id         |
    | F1     | 5        | !C3ZT02AB1^id     |
And I close the current editor
And I switch the current editor to editor "RM3Pruef"
And I close the current editor

# der BA ist noch offen, da fuer 5 Stk die Entnahmebuchungen fehlen
Given I open an editor "BAZT02PRUEF" from table "(Workorder):(WorkOrders)" with command "VIEW" for record "ZT02_000"
And I press button "absteig" to open a subeditor for "AFL"
Then field "limge" has value "5" in row 1
Then field "limge" has value "5" in row 3
And I close the current editor
And I switch the current editor to editor "BAZT02PRUEF"
And I close the current editor

# Zugangsbuchungen ueber 5 Stk, 5 Stk und 10 Stk
And I open the infosystem "LJ"
And I set field "adatum" to "."
And I set field "beleg" to "!RM3_ZT02^barmex"
And I set field "artikel" to "BG01_CHARGE"
And I press start
Then table has values
    | zmge | amge     | tvcharge  | vcharge  | vplatz    | tncharge  | ncharge^id    | nplatz    |
    | 5    |          |           |          |           | C2ZT02ZU  | !C2ZT02ZU^id  | F1        |
    | 5    |          |           |          |           | C1ZT02ZU  | !C1ZT02ZU^id  | F1        |
    | 10   |          |           |          |           | C3ZT02ZU  | !C3ZT02ZU^id  | F1        |
And I close the current editor

# Abgangsbuchungen nur ueber 5 Stk, 5 Stk und 5 Stk, da nicht genug passende AbgangsMZ mit passenden Chargen => BA bleibt offen
And I open the infosystem "LJ"
And I set field "adatum" to "."
And I set field "beleg" to "!RM3_ZT02^barmex"
And I set field "artikel" to "EK02_CHARGE"
And I press start
Then table has values
    | zmge | amge     | tvcharge    | vcharge^id     | tncharge  | ncharge^id    |
    |      | 5        | C2ZT02AB2   | !C2ZT02AB2^id  | C2ZT02ZU  | !C2ZT02ZU^id  |
    |      | 5        | C1ZT02AB2   | !C1ZT02AB2^id  | C1ZT02ZU  | !C1ZT02ZU^id  |
    |      | 5        | C3ZT02AB2   | !C3ZT02AB2^id  | C3ZT02ZU  | !C3ZT02ZU^id  |
And I close the current editor

And I open the infosystem "LJ"
And I set field "adatum" to "."
And I set field "beleg" to "!RM3_ZT02^barmex"
And I set field "artikel" to "EK01_CHARGE"
And I press start
Then table has values
    | zmge | amge     | tvcharge    | vcharge^id     | tncharge  | ncharge^id    |
    |      | 5        | C2ZT02AB1   | !C2ZT02AB1^id  | C2ZT02ZU  | !C2ZT02ZU^id  |
    |      | 5        | C1ZT02AB1   | !C1ZT02AB1^id  | C1ZT02ZU  | !C1ZT02ZU^id  |
    |      | 5        | C3ZT02AB1   | !C3ZT02AB1^id  | C3ZT02ZU  | !C3ZT02ZU^id  |
And I close the current editor


Scenario: ZT04 Zugangscharge in der Fertigung - EntnahmeMZ fuer manbu Material erfassen, ohne Zugangscharge
# Angabe Zugangscharge im Kopf der FBU, EntnahmeMZ wird der Reihe nach gebucht

Given I create a work order "ZT04" for Product "BG01_CHARGE" with quantity "20" and search word "ZT04_"

Given I create a Lot "C1ZT04ZU" for Product "BG01_CHARGE"
Given I create a Lot "C2ZT04ZU" for Product "BG01_CHARGE"
Given I create a Lot "C3ZT04ZU" for Product "BG01_CHARGE"

# EntnahmeMZ anlegen, Zugangscharge ist schreibgeschuetzt bei manbu-Material
Given I open an editor "BAZT04" from table "(Workorder):(WorkOrders)" with command "UPDATE" for record "ZT04_000"
And I press button "absteig" to open a subeditor for "AFL"
And I press button "setmanbu"
And I press button "mzsubm" to open a subeditor for "EntnahmeMZ" in row 1
And I modify table
    | !row  | lpsuch | zuomge   | tcharge   |
    | +1    | F1     | 10       | 01ZT04AB1 |
    | +2    | F1     | 5        | 02ZT04AB1 |
    | +3    | F1     | 5        | 03ZT04AB1 |
Then fields in table are modifiable
    | !row  | zcharge   |
    | 1     | ja        |
    | 2     | ja        |
    | 3     | ja        |
And I press button for next product
And I modify table
    | !row  | lpsuch | zuomge   | tcharge   |
    | +1    | F1     | 10       | 01ZT04AB2 |
    | +2    | F1     | 5        | 02ZT04AB2 |
    | +3    | F1     | 5        | 03ZT04AB2 |
And I save the current editor
And I switch the current editor to editor "AFL"
And I save the current editor
And I switch the current editor to editor "BAZT04"
And I save the current editor

Given I open an editor "MATENT1" for tip command "Fbuchung" and arguments ""
And I set fields
    | auftrag   | ZT04_001      |
    | bem       | Entnahme      |
    | charge    | !C2ZT04ZU^id  |
And I press button "stlvblad"
Then table has values
    | elex          | bumge | manbu |
    | EK01_CHARGE   | 20    | ja    |
And I set field "ljtext1" to "MATENT1" in row 1
And I save the current editor

Given I open an editor "01ZT04AB1" from table "(Lots):(Lots)" with command "VIEW" for search criteria "$,,exnum=01ZT04AB1;@maxtreffer=1;@ablageart=lebendig"
And I close the current editor

Given I open an editor "02ZT04AB1" from table "(Lots):(Lots)" with command "VIEW" for search criteria "$,,exnum=02ZT04AB1;@maxtreffer=1;@ablageart=lebendig"
And I close the current editor

Given I open an editor "03ZT04AB1" from table "(Lots):(Lots)" with command "VIEW" for search criteria "$,,exnum=03ZT04AB1;@maxtreffer=1;@ablageart=lebendig"
And I close the current editor

Given I open an editor "BAZT04" from table "(Workorder):(WorkOrders)" with command "VIEW" for record "ZT04_000"
And I press button "absteig" to open a subeditor for "AFL"
And I save value from field "id" in row 1
And I close the current editor
And I switch the current editor to editor "BAZT04"
And I close the current editor

Given I open LotTracking "chverfobjekt1" for receipt Lot "C2ZT04ZU" and issue Lot "01ZT04AB1" and product list element "EK01_CHARGE" and receipt movement "ZT04" with command "VIEW"
Then field "reserv^id" in row 0 equals saved value
And I close the current editor

Given I open LotTracking "chverfobjekt2" for receipt Lot "C2ZT04ZU" and issue Lot "02ZT04AB1" and product list element "EK01_CHARGE" and receipt movement "ZT04" with command "VIEW"
Then field "reserv^id" in row 0 equals saved value
And I close the current editor

Given I open LotTracking "chverfobjekt3" for receipt Lot "C2ZT04ZU" and issue Lot "03ZT04AB1" and product list element "EK01_CHARGE" and receipt movement "ZT04" with command "VIEW"
Then field "reserv^id" in row 0 equals saved value
And I close the current editor

# gebuchte Materialentnahme oeffnen um Zugriff auf Belegnummer barmex zu haben
Given I open an editor "FBUBELEG" from table "(Workorder):(CompletionConfirmations)" with command "VIEW" for search criteria "$,,such=ZT04_001;bem=Entnahme;@ablage=abgelegt;@richtung=rückwärts;@maxordtreffer=1"
And I save value from field "barmex" in row 0
And I close the current editor

And I open the infosystem "LJ"
And I set field "adatum" to "."
And I set field "beleg" in row 0 to saved value
And I set field "artikel" to "EK01_CHARGE"
And I press start
Then table has values
    | zmge | amge     | tvcharge    | vcharge^id     | vplatz    | tncharge  | ncharge^id    | chverfobj^id         |
    |      | 10       | 01ZT04AB1   | !01ZT04AB1^id  | F1        | C2ZT04ZU  | !C2ZT04ZU^id  | !chverfobjekt1^id    |
    |      | 5        | 02ZT04AB1   | !02ZT04AB1^id  | F1        | C2ZT04ZU  | !C2ZT04ZU^id  | !chverfobjekt2^id    |
    |      | 5        | 03ZT04AB1   | !03ZT04AB1^id  | F1        | C2ZT04ZU  | !C2ZT04ZU^id  | !chverfobjekt3^id    |
And I close the current editor


Scenario: ZT05 Zugangs- und Abgangscharge in der Fertigung - Retrograd Buchen - Nur Teilmenge in EntnahmeMZ Charge vorhanden

Given I create a work order "ZT05" for Product "BG01_CHARGE" with quantity "20" and search word "ZT05_"

Given I create a Lot "C1ZT05ZU" for Product "BG01_CHARGE"

Given I create a Lot "C1ZT05AB" for Product "EK01_CHARGE"
Given I create a Lot "C2ZT05AB" for Product "EK02_CHARGE"

Given I open an editor "BAZT05" from table "(Workorder):(WorkOrders)" with command "UPDATE" for record "ZT05_000"
And I press button "mzsubm" to open a subeditor for "ZugangsMZ"
And I modify table
    | !row  | lpsuch | zuomge   | tcharge   |
    | +1    | F1     | 20       | C1ZT05ZU  |
And I save the current editor
And I switch the current editor to editor "BAZT05"
And I press button "absteig" to open a subeditor for "AFL"
And I press button "resetmanbu"
And I press button "mzsubm" to open a subeditor for "EntnahmeMZ" in row 1
And I modify table
    | !row  | lpsuch | zuomge   | tcharge   | zcharge   |
    | +1    | F1     | 9        | C1ZT05AB  | C1ZT05ZU  |
And I press button for next product
And I modify table
    | !row  | lpsuch | zuomge   | tcharge   | zcharge   |
    | +1    | F1     | 11       | C2ZT05AB  | C1ZT05ZU  |
And I save the current editor
And I switch the current editor to editor "AFL"
And I save the current editor
And I switch the current editor to editor "BAZT05"
And I save the current editor

Given I open an editor "Rückmeldung1" from table "(Workorder):(WorkOrders)" with command "DONE" for record "ZT05_000"
And I set field "sofort" to "ja"
And I set field "mgr" to "101"
And I set field "gutmge" to "10" in row 1
And I save the current editor


Scenario: ZT06 Zugangs- und Abgangscharge in der Fertigung - Manuell Buchen - Nur Teilmenge in EntnahmeMZ Charge vorhanden

Given I create a work order "ZT06" for Product "BG01_CHARGE" with quantity "20" and search word "ZT06_"

Given I create a Lot "C1ZT06ZU" for Product "BG01_CHARGE"

Given I create a Lot "C1ZT06AB" for Product "EK01_CHARGE"
Given I create a Lot "C2ZT06AB" for Product "EK02_CHARGE"

Given I open an editor "BAZT06" from table "(Workorder):(WorkOrders)" with command "UPDATE" for record "ZT06_000"
And I press button "mzsubm" to open a subeditor for "ZugangsMZ"
And I modify table
    | !row  | lpsuch | zuomge   | tcharge   |
    | +1    | F1     | 20       | C1ZT06ZU  |
And I save the current editor
And I switch the current editor to editor "BAZT06"
And I press button "absteig" to open a subeditor for "AFL"
And I press button "setmanbu"
And I press button "mzsubm" to open a subeditor for "EntnahmeMZ" in row 1
And I modify table
    | !row  | lpsuch | zuomge   | tcharge   |
    | +1    | F1     | 9        | C1ZT06AB  |
And I press button for next product
And I modify table
    | !row  | lpsuch | zuomge   | tcharge   |
    | +1    | F1     | 11       | C2ZT06AB  |
And I save the current editor
And I switch the current editor to editor "AFL"
And I save the current editor
And I switch the current editor to editor "BAZT06"
And I save the current editor

# Vorschlagsmenge ist größer als Mengenangabe in der MZ für Teil EK01_CHARGE
Given I open an editor "MATENT1" for tip command "Fbuchung" and arguments ""
And I set fields
    | auftrag     | ZT06_000  |
    | gmgevorschl | 10        |
    | mgr         | 101       |
    | charge      | C1ZT06ZU  |
    | bem         | Entnahme  |
And I press button "stllad"
Then table has values
    | elex          | bumge | manbu |
    | EK01_CHARGE   | 10    | ja    |
    | EK02_CHARGE   | 10    | ja    |
# Charge/SN in Vorgang und MZ fehlt oder ist unvollständig, obwohl Chargen- oder Seriennummernverfolgung im Artikel eingetragen ist.
Then saving the current editor throws the exception "1490"
And I press button "mzsubm" to open a subeditor for "MZ" in row 1
Then field "zuomge" has value "9" in row 1
And I set field "zuomge" to "10" in row 1
And I save the current subeditor to switch back to the parent editor
And I save the current editor


Scenario: ZT07 ZugangsMZ und EntnahmeMZ in der Fertigung

Given I create a work order "ZT07" for Product "BG01_CHARGE" with quantity "100" and search word "ZT07_"

Given I create a Lot "C1ZT07ZU" for Product "BG01_CHARGE"
Given I create a Lot "C2ZT07ZU" for Product "BG01_CHARGE"
Given I create a Lot "C3ZT07ZU" for Product "BG01_CHARGE"

Given I create a Lot "C1ZT07AB1" for Product "EK01_CHARGE"
Given I create a Lot "C2ZT07AB1" for Product "EK01_CHARGE"
Given I create a Lot "C3ZT07AB1" for Product "EK01_CHARGE"

Given I create a Lot "C1ZT07AB2" for Product "EK02_CHARGE"
Given I create a Lot "C2ZT07AB2" for Product "EK02_CHARGE"
Given I create a Lot "C3ZT07AB2" for Product "EK02_CHARGE"

Given I open an editor "BAZT07" from table "(Workorder):(WorkOrders)" with command "UPDATE" for record "ZT07_000"
And I press button "mzsubm" to open a subeditor for "ZugangsMZ"
And I modify table
    | !row  | lpsuch | zuomge   | tcharge   |
    | +1    | F1     | 7        | C2ZT07ZU  |
    | +2    | F1     | 1        | C3ZT07ZU  |
    | +3    | F1     | 2        | C1ZT07ZU  |
    | +4    | F1     | 4        | C3ZT07ZU  |
And I save the current editor
And I switch the current editor to editor "BAZT07"
And I press button "absteig" to open a subeditor for "AFL"
And I press button "mzsubm" to open a subeditor for "EntnahmeMZ" in row 1
And I modify table
    | !row  | lpsuch | zuomge   | tcharge   | zcharge   |
    | +1    | F1     | 1        | C1ZT07AB1 | C1ZT07ZU  |
    | +2    | F1     | 96       | C2ZT07AB1 |           |
    | +3    | F1     | 3        | C3ZT07AB1 | C3ZT07ZU  |
And I press button for next product
And I modify table
    | !row  | lpsuch | zuomge   | tcharge   | zcharge   |
    | +1    | F1     | 1        | C1ZT07AB2 | C1ZT07ZU  |
    | +2    | F1     | 96       | C2ZT07AB2 |           |
    | +3    | F1     | 3        | C3ZT07AB2 | C3ZT07ZU  |
And I save the current editor
And I switch the current editor to editor "AFL"
And I save the current editor
And I switch the current editor to editor "BAZT07"
And I save the current editor

# keine Angabe Zugangscharge im Vorgang, wird aus ZugangsMZ genommen aus mehreren Zeilen, RM auf AG2, damit Zugang gebucht wird
Given I open an editor "RM1_ZT07" from table "(Workorder):(WorkOrders)" with command "DONE" for search criteria "$,,such=ZT07_002;@richtung=rückwärts;@maxordtreffer=1"
And I set fields
    | sofort    | ja            |
    | bem       | RM1_ZT07      |
And I set field "gutmge" to "14" in row 1
And I set field "erbtext1" to "RM1_ZT07" in row 1
And I save the current editor

And I open the infosystem "LJ"
And I set field "adatum" to "."
And I set field "beleg" to "!RM1_ZT07^barmex"
And I set field "artikel" to "BG01_CHARGE"
And I press start
Then table has values
    | zmge | tncharge  | ncharge^id    |
    | 7    | C2ZT07ZU  | !C2ZT07ZU^id  |
    | 1    | C3ZT07ZU  | !C3ZT07ZU^id  |
    | 2    | C1ZT07ZU  | !C1ZT07ZU^id  |
    | 4    | C3ZT07ZU  | !C3ZT07ZU^id  |
And I close the current editor

And I open the infosystem "LJ"
And I set field "adatum" to "."
And I set field "beleg" to "!RM1_ZT07^barmex"
And I set field "artikel" to "EK01_CHARGE"
And I press start
Then table has values
    | zmge | amge     | tvcharge    | vcharge^id     | vplatz    | tncharge  | ncharge^id    |
    |      | 7        | C2ZT07AB1   | !C2ZT07AB1^id  | F1        | C2ZT07ZU  | !C2ZT07ZU^id  |
    |      | 2        | C2ZT07AB1   | !C2ZT07AB1^id  | F1        | C3ZT07ZU  | !C3ZT07ZU^id  |
    |      | 3        | C3ZT07AB1   | !C3ZT07AB1^id  | F1        | C3ZT07ZU  | !C3ZT07ZU^id  |
    |      | 1        | C1ZT07AB1   | !C1ZT07AB1^id  | F1        | C1ZT07ZU  | !C1ZT07ZU^id  |
    |      | 1        | C2ZT07AB1   | !C2ZT07AB1^id  | F1        | C1ZT07ZU  | !C1ZT07ZU^id  |
And I close the current editor

And I open the infosystem "LJ"
And I set field "adatum" to "."
And I set field "beleg" to "!RM1_ZT07^barmex"
And I set field "artikel" to "EK02_CHARGE"
And I press start
Then table has values
    | zmge | amge     | tvcharge    | vcharge^id     | vplatz    | tncharge  | ncharge^id    |
    |      | 7        | C2ZT07AB2   | !C2ZT07AB2^id  | F1        | C2ZT07ZU  | !C2ZT07ZU^id  |
    |      | 2        | C2ZT07AB2   | !C2ZT07AB2^id  | F1        | C3ZT07ZU  | !C3ZT07ZU^id  |
    |      | 3        | C3ZT07AB2   | !C3ZT07AB2^id  | F1        | C3ZT07ZU  | !C3ZT07ZU^id  |
    |      | 1        | C1ZT07AB2   | !C1ZT07AB2^id  | F1        | C1ZT07ZU  | !C1ZT07ZU^id  |
    |      | 1        | C2ZT07AB2   | !C2ZT07AB2^id  | F1        | C1ZT07ZU  | !C1ZT07ZU^id  |
And I close the current editor


Scenario: ZT08 Zugangs- und Abgangscharge in der Fertigung - Retrograd Buchen - hoehere Menge buchen als geplant

Given I create a work order "ZT08" for Product "BG01_CHARGE" with quantity "20" and search word "ZT08_"

Given I create a Lot "C1ZT08ZU" for Product "BG01_CHARGE"

Given I create a Lot "C1ZT08AB" for Product "EK01_CHARGE"
Given I create a Lot "C2ZT08AB" for Product "EK02_CHARGE"

Given I open an editor "BAZT08" from table "(Workorder):(WorkOrders)" with command "UPDATE" for record "ZT08_000"
And I press button "mzsubm" to open a subeditor for "ZugangsMZ"
And I modify table
    | !row  | lpsuch | zuomge   | tcharge   |
    | +1    | F1     | 20       | C1ZT08ZU  |
And I save the current editor
And I switch the current editor to editor "BAZT08"
And I press button "absteig" to open a subeditor for "AFL"
And I press button "resetmanbu"
And I press button "mzsubm" to open a subeditor for "EntnahmeMZ" in row 1
And I modify table
    | !row  | lpsuch | zuomge   | tcharge   | zcharge   |
    | +1    | F1     | 20       | C1ZT08AB  | C1ZT08ZU  |
And I press button for next product
And I modify table
    | !row  | lpsuch | zuomge   | tcharge   | zcharge   |
    | +1    | F1     | 20       | C2ZT08AB  | C1ZT08ZU  |
And I save the current editor
And I switch the current editor to editor "AFL"
And I save the current editor
And I switch the current editor to editor "BAZT08"
And I save the current editor

# es gibt nur MZ mit Charge fuer 20 Stueck, fuer zusaetzliches 1 Stueck muss zumindest Zugangscharge angegeben werden
Given I open an editor "RM1_ZT08" from table "(Workorder):(WorkOrders)" with command "DONE" for record "ZT08_000"
And I set field "sofort" to "ja"
And I set field "mgr" to "101"
And I set field "gutmge" to "21" in row 1
# Charge im Vorgang und in MZ fehlt oder ist unvollständig, obwohl Chargenpflicht in Konfiguration und Artikel gesetzt ist.
Then saving the current editor throws the exception "1490"
And I press button "mzsubm" to open a subeditor for "ZugangsMZ" in row 1
And I set field "zuomge" to "21" in row 1
And I save the current editor
And I switch the current editor to editor "RM1_ZT08"
And I save the current editor

And I open the infosystem "LJ"
And I set field "adatum" to "."
And I set field "beleg" to "!RM1_ZT08^barmex"
And I set field "artikel" to "BG01_CHARGE"
And I press start
Then table has values
    | zmge | amge     | tvcharge    | vcharge   | tncharge  | ncharge^id    | nplatz    |
    | 21   |          |             |           | C1ZT08ZU  | !C1ZT08ZU^id  | F1        |
And I close the current editor

And I open the infosystem "LJ"
And I set field "adatum" to "."
And I set field "beleg" to "!RM1_ZT08^barmex"
And I set field "artikel" to "EK01_CHARGE"
And I press start
Then table has values
    | zmge | amge     | tvcharge    | vcharge^id     | vplatz    | tncharge  | ncharge^id    |
    |      | 20       | C1ZT08AB    | !C1ZT08AB^id   | F1        | C1ZT08ZU  | !C1ZT08ZU^id  |
And I close the current editor

## wird dann 1 Stueck zu wenig vom Material abgebucht? wird Loeschschutz gesetzt? Reservierung aber nur 20 und die wurden gebucht?

# Loeschschutz wurde gesetzt und kann nicht entfernt werden, da zu wenig Material abgebucht wurde (Menge aus der Reservierung wurde vollstaendig abgebucht)

Given I open an editor "ZT08_000" from table "(Workorder):(WorkOrders)" with command "UPDATE" for search criteria "$,,such=ZT08_000;@richtung=rückwärts;@maxordtreffer=1"
Then field "noloesch" has value "ja"
# 1697 TX=de   |Löschschutz kann nicht entfernt werden, da noch Restmengen vorhanden.
Then setting field "noloesch" to "nein" throws the exception "1697"
And I close the current editor

# Restmengen ueber FBU buchen und BA abschliessen
Given I open an editor "MATENT1" for tip command "Fbuchung" and arguments ""
And I set fields
    | auftrag   | ZT08_000      |
    | bem       | EntnahmeZT08  |
    | autorment | ja            |
    | charge    | !C1ZT08ZU^id  |
    | mgr       | 101           |
And I press button "stllad"

Then table has values
    | elex          | bumge |
    | EK01_CHARGE   | 1     |
    | EK02_CHARGE   | 1     |
And I modify table
    | !row  |  tvcharge  |
    | 1     |  C1ZT08AB  |
    | 2     |  C2ZT08AB  |
And I save the current editor

Given I open an editor "ZT08_000" from table "(Workorder):(WorkOrders)" with command "UPDATE" for search criteria "$,,such=ZT08_000;@richtung=rückwärts;@maxordtreffer=1"
And I set field "noloesch" to "nein"
And I save the current editor

And I open the infosystem "LJ"
And I set field "adatum" to "."
And I set field "beleg" to "!RM1_ZT08^barmex"
And I set field "artikel" to "EK01_CHARGE"
And I press start
Then table has values
    | zmge | amge     | tvcharge    | vcharge^id     | vplatz    | tncharge  | ncharge^id    |
    |      | 20       | C1ZT08AB    | !C1ZT08AB^id   | F1        | C1ZT08ZU  | !C1ZT08ZU^id  |
    |      | 1        | C1ZT08AB    | !C1ZT08AB^id   | F1        | C1ZT08ZU  | !C1ZT08ZU^id  |
And I set field "artikel" to "EK02_CHARGE"
And I press start

Then table has values
    | zmge | amge     | tvcharge    | vcharge^id     | vplatz    | tncharge  | ncharge^id    |
    |      | 20       | C2ZT08AB    | !C2ZT08AB^id   | F1        | C1ZT08ZU  | !C1ZT08ZU^id  |
    |      | 1        | C2ZT08AB    | !C2ZT08AB^id   | F1        | C1ZT08ZU  | !C1ZT08ZU^id  |
And I close the current editor


Scenario: ZT09 Bei Materialrueckgabe retro ueber FBU zcharge in LJ


Given I create a work order "ZT09" for Product "BG01_CHARGE" with quantity "12" and search word "ZT09_"

Given I open an editor "BAZT09" from table "(Workorder):(WorkOrders)" with command "UPDATE" for record "ZT09_000"
And I press button "absteig" to open a subeditor for "AFL"
And I press button "mzsubm" to open a subeditor for "EntnahmeMZ" in row 1
And I modify table
    | !row  | lpsuch | zuomge   | tcharge   | ztcharge  |
    | +1    | F1     | 12       | C1ZT09AB1 | C1ZT09ZU  |
And I press button for next product
And I modify table
    | !row  | lpsuch | zuomge   | tcharge   | ztcharge  |
    | +1    | F1     | 12       | C1ZT09AB2 | C1ZT09ZU  |
And I save the current editor
And I switch the current editor to editor "AFL"
And I save the current editor
And I switch the current editor to editor "BAZT09"
And I save the current editor

# Rueckmeldung Teilmenge auf Arbeitsschein 1
Given I open an editor "RM1_ZT09" from table "(Workorder):(WorkOrders)" with command "DONE" for record "ZT09_001"
And I set fields
    | sofort    | ja            |
    | bem       | RM1_ZT09      |
And I set field "gutmge" to "10" in row 1
And I save the current editor

# Charge oeffnen um Zugriff auf die ID zu haben
Given I open an editor "C1ZT09ZU" from table "(Lots):(Lots)" with command "VIEW" for search criteria "$,,exnum=C1ZT09ZU;@maxtreffer=1;@ablageart=lebendig"
And I close the current editor

Given I open an editor "C1ZT09AB1" from table "(Lots):(Lots)" with command "VIEW" for search criteria "$,,exnum=C1ZT09AB1;@maxtreffer=1;@ablageart=lebendig"
And I close the current editor

Given I open an editor "FBU_ZT09" for tip command "Fbuchung" and arguments ""
And I set fields
    | auftrag       | ZT09_001  |
    | autorment     | ja        |
    | bem           | Rueckgabe |
    | gmgevorschl   | -6        |
And I press button "stlvblad"
Then table has values
    | elex          | bumge |
    | EK01_CHARGE   | -6    |
And I set field "rescharge" to "!C1ZT09AB1^id" in row 1
And I press button "mzsubm" to open a subeditor for "MZ" in row 1
And I modify table
    | !row  | zcharge       |
    | 1     | !C1ZT09ZU^id  |
And I save the current subeditor to switch back to the parent editor
And I set field "ljtext1" to "FBU_ZT09" in row 1
And I save the current editor

# Buchungen im LJ pruefen
And I open the infosystem "LJ"
And I set field "adatum" to "."
And I set field "beleg" to "!RM1_ZT09^barmex"
And I press start
Then table has values
    | zmge | amge     | vcharge^id      | ncharge^id      |
    |      | 10       | !C1ZT09AB1^id   | !C1ZT09ZU^id    |
    |      | -6       | !C1ZT09AB1^id   | !C1ZT09ZU^id    |
And I close the current editor


## FDA-5716
Scenario: ZT10 Zugangscharge in der Fertigung - Angabe zcharge in der Zeile der FBU kommt im LJ an und uebersteuert Angabe im Kopf

Given I create a work order "ZT10" for Product "BG01_CHARGE" with quantity "20" and search word "ZT10_"

Given I create a Lot "C1ZT10ZU" for Product "BG01_CHARGE"

Given I create a Lot "C2ZT10ZU" for Product "BG01_CHARGE"

Given I create a Lot "C3ZT10ZU" for Product "BG01_CHARGE"

# EntnahmeMZ anlegen ohne Zugangscharge
Given I open an editor "BAZT10" from table "(Workorder):(WorkOrders)" with command "UPDATE" for record "ZT10_000"
And I press button "absteig" to open a subeditor for "AFL"
And I press button "setmanbu"
And I press button "mzsubm" to open a subeditor for "EntnahmeMZ" in row 1
And I modify table
    | !row  | lpsuch | zuomge   | tcharge   |
    | +1    | F1     | 10       | 01ZT10AB1 |
    | +2    | F1     | 5        | 02ZT10AB1 |
    | +3    | F1     | 5        | 03ZT10AB1 |
And I press button for next product
And I modify table
    | !row  | lpsuch | zuomge   | tcharge   |
    | +1    | F1     | 10       | 01ZT10AB2 |
    | +2    | F1     | 5        | 02ZT10AB2 |
    | +3    | F1     | 5        | 03ZT10AB2 |
And I save the current editor
And I switch the current editor to editor "AFL"
And I save the current editor
And I switch the current editor to editor "BAZT10"
And I save the current editor

Given I open an editor "MATENT1" for tip command "Fbuchung" and arguments ""
And I set fields
    | auftrag   | ZT10_001      |
    | bem       | MATENT1       |
    | charge    | !C1ZT10ZU^id  |
And I press button "stlvblad"
Then table has values
    | elex          | bumge | manbu | reszcharge^id |
    | EK01_CHARGE   | 20    | ja    | !C1ZT10ZU^id  |
And I set field "bumge" to "10" in row 1
And I save the current editor

Given I open an editor "MATENT2" for tip command "Fbuchung" and arguments ""
And I set fields
    | auftrag   | ZT10_001      |
    | bem       | MATENT2       |
And I press button "stlvblad"
And I set field "bumge" to "2" in row 1
And I set field "reszcharge" to "!C2ZT10ZU^id" in row 1
And I save the current editor

Given I open an editor "MATENT3" for tip command "Fbuchung" and arguments ""
And I set fields
    | auftrag   | ZT10_001      |
    | bem       | MATENT3       |
    | charge    | !C3ZT10ZU^id  |
And I press button "stlvblad"
And I set field "bumge" to "3" in row 1
And I save the current editor


# gebuchte Materialentnahme oeffnen um Zugriff auf Belegnummer barmex zu haben
Given I open an editor "FBUBELEG" from table "(Workorder):(CompletionConfirmations)" with command "VIEW" for search criteria "$,,such=ZT10_001;bem=MATENT1;@ablage=abgelegt;@richtung=rückwärts;@maxordtreffer=1"
And I save value from field "barmex" in row 0
And I close the current editor

Given I open an editor "01ZT10AB1" from table "(Lots):(Lots)" with command "VIEW" for search criteria "$,,exnum=01ZT10AB1;@maxtreffer=1;@ablageart=lebendig"
And I close the current editor

Given I open an editor "02ZT10AB1" from table "(Lots):(Lots)" with command "VIEW" for search criteria "$,,exnum=02ZT10AB1;@maxtreffer=1;@ablageart=lebendig"
And I close the current editor

Given I open an editor "03ZT10AB1" from table "(Lots):(Lots)" with command "VIEW" for search criteria "$,,exnum=03ZT10AB1;@maxtreffer=1;@ablageart=lebendig"
And I close the current editor

And I open the infosystem "LJ"
And I set field "adatum" to "."
And I set field "beleg" in row 0 to saved value
And I set field "artikel" to "EK01_CHARGE"
And I press start
Then table has values
    | zmge | amge     | tvcharge    | vcharge^id     | tncharge  | ncharge^id    |
    |      | 10       | 01ZT10AB1   | !01ZT10AB1^id  | C1ZT10ZU  | !C1ZT10ZU^id  |
    |      | 2        | 02ZT10AB1   | !02ZT10AB1^id  | C2ZT10ZU  | !C2ZT10ZU^id  |
    |      | 3        | 02ZT10AB1   | !02ZT10AB1^id  | C3ZT10ZU  | !C3ZT10ZU^id  |
And I close the current editor


## FDA-5715
Scenario: ZT11 Zugangscharge in der Fertigung - Angabe zcharge aus der Reservierung wird in die MZ uebernommen

Given I create a work order "ZT11" for Product "BG01_CHARGE" with quantity "20" and search word "ZT11_"

Given I create a Lot "C1ZT11ZU" for Product "BG01_CHARGE"

Given I create a Lot "C2ZT11AB" for Product "EK02_CHARGE"

# zcharge in der Reservierung eintragen
Given I open an editor "BAZT11" from table "(Workorder):(WorkOrders)" with command "UPDATE" for record "ZT11_000"
And I press button "absteig" to open a subeditor for "AFL"
And I set field "zcharge" to "!C1ZT11ZU^id" in row 1
And I press button "schreib"
And I press button "mzsubm" to open a subeditor for "EntnahmeMZ" in row 1
Then table has values
    | !row  | zuomge   | zcharge^id     |
    | 1     | 20       | !C1ZT11ZU^id   |
And I save the current editor
And I switch the current editor to editor "AFL"
And I set field "charge" to "!C2ZT11AB^id" in row 3
And I set field "zcharge" to "!C1ZT11ZU^id" in row 3
And I press button "schreib"
And I press button "mzsubm" to open a subeditor for "EntnahmeMZ" in row 3
Then table has values
    | !row  | zuomge   | charge^id      | zcharge^id    |
    | 1     | 20       | !C2ZT11AB^id   | !C1ZT11ZU^id  |
And I save the current editor
And I switch the current editor to editor "AFL"
And I save the current editor
And I switch the current editor to editor "BAZT11"
And I save the current editor

# wenn MZ vorhanden, sind die Chargenfelder in der Reservierung schreibgeschuetzt, MZ bearbeiten oder loeschen und neu eintragen
Given I open an editor "BAZT11" from table "(Workorder):(WorkOrders)" with command "UPDATE" for record "ZT11_000"
And I press button "absteig" to open a subeditor for "AFL"
Then field "charge" is not modifiable in row 3
Then field "zcharge" is not modifiable in row 3
And I press button "mzsubm" to open a subeditor for "EntnahmeMZ" in row 3
And I delete all rows
And I save the current editor
And I switch the current editor to editor "AFL"
And I set field "charge" to "!C2ZT11AB^id" in row 3
And I set field "zcharge" to "!C1ZT11ZU^id" in row 3
And I press button "schreib"
And I press button "mzsubm" to open a subeditor for "EntnahmeMZ" in row 3
Then table has values
    | !row  | zuomge   | charge^id      | zcharge^id    |
    | 1     | 20       | !C2ZT11AB^id   | !C1ZT11ZU^id  |
And I save the current editor
And I switch the current editor to editor "AFL"
And I save the current editor
And I switch the current editor to editor "BAZT11"
And I save the current editor


Scenario: ZT12 Zugangscharge in der Fertigung - Fertigteil ohne chargenpflicht - Rückbau nimmt eingetragene Charge

Given I create a work order "ZT12" for Product "BG1" with quantity "10" and search word "ZT12_"

Given I create a Lot "C1ZT12ZU" for Product "BG1"
Given I create a Lot "C2ZT12ZU" for Product "BG1"
Given I create a Lot "C3ZT12ZU" for Product "BG1"
Given I create a Lot "C4ZT12ZU" for Product "BG1"
Given I create a Lot "C5ZT12ZU" for Product "BG1"
Given I create a Lot "C6ZT12ZU" for Product "BG1"
Given I create a Lot "C7ZT12ZU" for Product "BG1"
Given I create a Lot "C8ZT12ZU" for Product "BG1"

Given I open an editor "BAZT12" from table "(Workorder):(WorkOrders)" with command "UPDATE" for record "ZT12_000"
And I press button "mzsubm" to open a subeditor for "ZugangsMZ"
And I modify table
    | !row  | lpsuch | zuomge   | tcharge   |
    | +1    | F1     | 1        | C1ZT12ZU  |
    | +2    | F1     | 1        | C2ZT12ZU  |
    | +3    | F1     | 1        | C3ZT12ZU  |
    | +4    | F1     | 1        | C4ZT12ZU  |
    | +5    | F1     | 1        | C5ZT12ZU  |
    | +6    | F1     | 3        | C6ZT12ZU  |
    | +7    | F1     | 1        | C7ZT12ZU  |
    | +8    | F1     | 1        | C8ZT12ZU  |
And I save the current editor
And I switch the current editor to editor "BAZT12"
And I save the current editor

# Rueckmeldung Teilmenge (5 von 10) auf Arbeitsschein 2
Given I open an editor "RM1AS2_ZT12" from table "(Workorder):(WorkOrders)" with command "DONE" for search criteria "$,,such=ZT12_002;@richtung=rückwärts;@maxordtreffer=1"
And I set fields
    | sofort    | ja            |
    | bem       | RM1AS2_ZT12   |
And I set field "gutmge" to "5" in row 1
And I set field "erbtext1" to "RM1AS2_ZT12" in row 1
And I save the current editor

# Zugangsbuchungen überprüfen
And I open the infosystem "LJ"
And I set field "adatum" to "."
And I set field "beleg" to "!RM1AS2_ZT12^barmex"
And I set field "artikel" to "BG1"
And I press start
Then the table has 5 rows
Then table has values
    | zmge | amge     | tvcharge  | vcharge  | vplatz    | tncharge  | ncharge^id    | nplatz    |
    | 1    |          |           |          |           | C1ZT12ZU  | !C1ZT12ZU^id  | F1        |
    | 1    |          |           |          |           | C2ZT12ZU  | !C2ZT12ZU^id  | F1        |
    | 1    |          |           |          |           | C3ZT12ZU  | !C3ZT12ZU^id  | F1        |
    | 1    |          |           |          |           | C4ZT12ZU  | !C4ZT12ZU^id  | F1        |
    | 1    |          |           |          |           | C5ZT12ZU  | !C5ZT12ZU^id  | F1        |
And I close the current editor

# Rueckmeldung Teilmenge (4 von 5) auf Arbeitsschein 2
Given I open an editor "RM2AS2_ZT12" from table "(Workorder):(WorkOrders)" with command "DONE" for search criteria "$,,such=ZT12_002;@richtung=rückwärts;@maxordtreffer=1"
And I set fields
    | sofort    | ja            |
    | bem       | RM2AS2_ZT12   |
And I set field "gutmge" to "4" in row 1
And I set field "erbtext1" to "RM2AS2_ZT12" in row 1
And I save the current editor

# Zugangsbuchungen überprüfen
And I open the infosystem "LJ"
And I set field "adatum" to "."
And I set field "beleg" to "!RM2AS2_ZT12^barmex"
And I set field "artikel" to "BG1"
And I press start
Then the table has 7 rows
Then table has values
    | zmge | amge     | tvcharge  | vcharge  | vplatz    | tncharge  | ncharge^id    | nplatz    |
    | 1    |          |           |          |           | C1ZT12ZU  | !C1ZT12ZU^id  | F1        |
    | 1    |          |           |          |           | C2ZT12ZU  | !C2ZT12ZU^id  | F1        |
    | 1    |          |           |          |           | C3ZT12ZU  | !C3ZT12ZU^id  | F1        |
    | 1    |          |           |          |           | C4ZT12ZU  | !C4ZT12ZU^id  | F1        |
    | 1    |          |           |          |           | C5ZT12ZU  | !C5ZT12ZU^id  | F1        |
    | 3    |          |           |          |           | C6ZT12ZU  | !C6ZT12ZU^id  | F1        |
    | 1    |          |           |          |           | C7ZT12ZU  | !C7ZT12ZU^id  | F1        |
And I close the current editor

# Rückbau auf Arbeitsschein 2, 1 St. Charge C6ZT12ZU
Given I open an editor "RB1AS2_ZT12" from table "(Workorder):(WorkOrders)" with command "RETURN" for record "ZT12_002"
And I set field "sofort" to "ja"
And I set field "kcharge" to "C3ZT12ZU"
And I set field "gutmge" to "-1" in row 1
And I set field "erbtext1" to "RB1AS2_ZT12" in row 1
And I save the current editor

# Rückbau auf Arbeitsschein 2, 1 St. Charge C3ZT12ZU
Given I open an editor "RB2AS2_ZT12" from table "(Workorder):(WorkOrders)" with command "RETURN" for record "ZT12_002"
And I set field "sofort" to "ja"
And I set field "kcharge" to "C6ZT12ZU"
And I set field "gutmge" to "-4" in row 1
And I set field "erbtext1" to "RB2AS2_ZT12" in row 1
Then saving the current editor throws the exception "1395"
And I set field "gutmge" to "-3" in row 1
And I save the current editor

# Zugangsbuchungen überprüfen - auf Charge C3ZT12ZU wurde 1 St, auf Charge C6ZT12ZU 3 St zurückgelegt
And I open the infosystem "LJ"
And I set field "adatum" to "."
And I set field "beleg" to "!RM1AS2_ZT12^barmex"
And I set field "artikel" to "BG1"
And I press start
Then the table has 9 rows
Then table has values
    | zmge | amge     | tvcharge  | vcharge  | vplatz    | tncharge  | ncharge^id    | nplatz    |
    | 1    |          |           |          |           | C1ZT12ZU  | !C1ZT12ZU^id  | F1        |
    | 1    |          |           |          |           | C2ZT12ZU  | !C2ZT12ZU^id  | F1        |
    | 1    |          |           |          |           | C3ZT12ZU  | !C3ZT12ZU^id  | F1        |
    | 1    |          |           |          |           | C4ZT12ZU  | !C4ZT12ZU^id  | F1        |
    | 1    |          |           |          |           | C5ZT12ZU  | !C5ZT12ZU^id  | F1        |
    | 3    |          |           |          |           | C6ZT12ZU  | !C6ZT12ZU^id  | F1        |
    | 1    |          |           |          |           | C7ZT12ZU  | !C7ZT12ZU^id  | F1        |
    | -1   |          |           |          |           | C3ZT12ZU  | !C3ZT12ZU^id  | F1        |
    | -3   |          |           |          |           | C6ZT12ZU  | !C6ZT12ZU^id  | F1        |
And I close the current editor
