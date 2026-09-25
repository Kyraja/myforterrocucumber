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

Scenario: 01 Chargen automatisch anlegen bei der manuellen Lagerbuchung

Given I open an editor "Lagerbuchung" for tip command "(Stockadjustment)" and arguments ""
And I set fields
    | artikel   | EK01_CHARGE   |
    | buart     | Zugang        |
    | beleg     | LBU_01        |
    | beldat    | .             |
    | wert      | 10.0000       |
And I delete all rows
And I append rows
    | mge    | platz2   | tcharge2  |
    | 10     | F1       | 01        |
And I save the current editor

Given I open an editor "Charge" via ID from editor "Lagerbuchung" from field "charge2" in row 1 for table "(Lots):(Lots)" with command "VIEW"
Then fields have values
    | artikel   | EK01_CHARGE   |
    | exnum     | 01            |
    | eigcharge | nein          |
    | lief      |               |
And I close the current editor

Given I open an editor "ChargeKopie" from table "(Lots):(Lots)" with command "COPY" for record from editor "Charge"
# 10549 Eine Charge ohne Lieferant mit dieser externen Chargennummer / Seriennummer existiert schon für diesen Artikel
Then saving the current editor throws the exception "10549"
And I set field "exnum" to "01A"
And I save the current editor


Scenario: 02 Chargen automatisch anlegen in EK-Belegen, Bestellung, Lieferschein, Rechnung mit Lagerbewegung

Given I open an editor "EKBE" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set fields
    | lief | LIEFCHA2   |
    | such | EKBE0201   |
    | vom  | .          |
And I append rows
    | artikel       | mge | tcharge | einplan |
    | EK02_CHARGE   | 100 | 222     | ja      |
And I save the current editor

Given I open an editor "Charge222" via ID from editor "EKBE" from field "charge" in row 1 for table "(Lots):(Lots)" with command "VIEW"
Then fields have values
    | artikel   | EK02_CHARGE   |
    | exnum     | 222           |
    | eigcharge | nein          |
    | lief^such | LIEFCHA2      |
And I close the current editor

Given I open an editor "ChargeKopie1" from table "(Lots):(Lots)" with command "COPY" for record from editor "Charge222"
# 10546 Eine Charge mit dieser externen Chargennummer / Seriennummer existiert schon für diesen Lieferanten.
Then saving the current editor throws the exception "10546"
# ohne Lieferant kann die Charge angelegt werden, gleiche exnum darf mit abweichenden Lieferant vorhanden sein
And I set field "lief" to ""
And I save the current editor

Given I open an editor "ChargeKopie2" from table "(Lots):(Lots)" with command "COPY" for record from editor "Charge222"
# 10546 Eine Charge mit dieser externen Chargennummer / Seriennummer existiert schon für diesen Lieferanten.
Then saving the current editor throws the exception "10546"
And I set field "exnum" to "222A"
And I save the current editor

Given I open an editor "EKLS" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set fields
    | lief   | LIEFCHA2 |
    | such   | LS1_02   |
    | ebeleg | LS1_02   |
    | vom    | .        |
    | ueb    | ja       |
And I append rows
    | artikel       | mge |
    | EK02_CHARGE   | 15  |
# gibt es bereits eine Charge mit dieser externen Chargennummer, für diesen Artikel und Lieferant, dann wird die vorhandene Charge eingetragen
# mit dieser exnum gibt es eine Charge mit Lieferant und eine Charge ohne Lieferant, es wird die Charge mit diesem Lieferant selektiert
And I set field "tcharge" to "222" in row 1
Then field "charge^id" has value "!Charge222^id" in row 1
# gibt es noch keine Charge mit dieser externen Chargennummer, für diesen Artikel und Lieferant, dann wird eine neue Charge angelegt
And I set field "tcharge" to "223" in row 1
And I save the current editor

Given I open an editor "Charge223" via ID from editor "EKLS" from field "charge" in row 1 for table "(Lots):(Lots)" with command "VIEW"
    Then fields have values
    | artikel   | EK02_CHARGE   |
    | exnum     | 223           |
    | eigcharge | nein          |
    | lief^such | LIEFCHA2      |
And I close the current editor

Given I open an editor "EKRE" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set fields
    | lief   | LIEFCHA2 |
    | such   | RE1_02   |
    | ebeleg | RE1_02   |
    | vom    | .        |
    | tterm  | .        |
    | ueb    | ja       |
    | fakt   | ja       |
And I append rows
    | artikel       | mge |
    | EK02_CHARGE   | 10  |
# gibt es bereits eine Charge mit dieser externen Chargennummer, für diesen Artikel und Lieferant, dann wird die vorhandene Charge eingetragen
# mit dieser exnum gibt es eine Charge mit Lieferant und eine Charge ohne Lieferant, es wird die Charge mit diesem Lieferant selektiert
And I set field "tcharge" to "222" in row 1
Then field "charge^id" has value "!Charge222^id" in row 1
# gibt es noch keine Charge mit dieser externen Chargennummer, für diesen Artikel und Lieferant, dann wird eine neue Charge angelegt
And I set field "tcharge" to "224" in row 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

Given I open an editor "Charge224" via ID from editor "EKRE" from field "charge" in row 1 for table "(Lots):(Lots)" with command "VIEW"
Then fields have values
    | artikel   | EK02_CHARGE   |
    | exnum     | 224           |
    | eigcharge | nein          |
    | lief^such | LIEFCHA2      |
And I close the current editor


Scenario: 03 Chargen automatisch anlegen in VK-Belegen, Auftrag, Lieferschein, Rechnung mit Lagerbewegung

Given I open an editor "VKAUF" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set fields
    | kunde | KUNDECH1   |
    | such  | VKAUF03    |
    | vom   | .          |
And I append rows
    | artikel       | mge | tcharge | einplan |
    | EK02_CHARGE   | 20  | 333     | ja      |
And I save the current editor

Given I open an editor "Charge333" via ID from editor "VKAUF" from field "charge" in row 1 for table "(Lots):(Lots)" with command "VIEW"
Then fields have values
    | artikel   | EK02_CHARGE   |
    | exnum     | 333           |
    | eigcharge | nein          |
    | lief^such |               |
And I close the current editor

Given I open an editor "VKLS" from table "(Sales):(PackingSlip)" with command "NEW" for record ""
And I set fields
    | kunde  | KUNDECH1 |
    | such   | VKLS_03  |
    | vom    | .        |
    | ueb    | ja       |
And I append rows
    | artikel       | mge |
    | EK02_CHARGE   | 15  |
# gibt es bereits eine eindeutige Charge mit dieser externen Chargennummer, für diesen Artikel, dann wird die vorhandene Charge eingetragen
And I set field "tcharge" to "333" in row 1
Then field "charge^id" has value "!Charge333^id" in row 1
# gibt es noch keine Charge mit dieser externen Chargennummer, für diesen Artikel, dann wird eine neue Charge angelegt
And I set field "tcharge" to "334" in row 1
And I save the current editor

Given I open an editor "Charge334" via ID from editor "VKLS" from field "charge" in row 1 for table "(Lots):(Lots)" with command "VIEW"
Then fields have values
    | artikel   | EK02_CHARGE   |
    | exnum     | 334           |
    | eigcharge | nein          |
    | lief^such |               |
And I close the current editor

    # Charge oeffnen um Zugriff auf die ID zu haben
Given I open an editor "Charge222" from table "(Lots):(Lots)" with command "VIEW" for search criteria "$,,exnum=222;@maxtreffer=1;@ablageart=lebendig"
Then fields have values
    | exnum     | 222       |
    | eigcharge | nein      |
And I close the current editor

Given I open an editor "VKRE" from table "(Sales):(Invoice)" with command "NEW" for record ""
And I set fields
    | kunde  | KUNDECH1 |
    | such   | VKRE_03  |
    | vom    | .        |
    | tterm  | .        |
    | ueb    | ja       |
    | fakt   | ja       |
And I append rows
    | artikel       | mge | preis   |
    | EK02_CHARGE   | 10  | 10      |
# gibt es mit dieser exnum eine Charge mit Lieferant und eine Charge ohne Lieferant, dann muss eine Charge selektiert werden ueber Feld charge, (Objektauswahl geht nicht in Cucumber)
And I set field "charge" to "!Charge222^id" in row 1
# gibt es noch keine Charge mit dieser externen Chargennummer, für diesen Artikel, dann wird eine neue Charge angelegt
And I set field "tcharge" to "335" in row 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

Given I open an editor "Charge335" via ID from editor "VKRE" from field "charge" in row 1 for table "(Lots):(Lots)" with command "VIEW"
Then fields have values
    | artikel   | EK02_CHARGE   |
    | exnum     | 335           |
    | eigcharge | nein          |
    | lief^such |               |
And I close the current editor


Scenario: 04 Chargen automatisch anlegen in EK-Belegen mit MZ, Bestellung, Lieferschein, Rechnung mit Lagerbewegung

Given I open an editor "EKBE04" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set fields
    | lief | LIEFCHA1   |
    | such | EKBE0401   |
    | vom  | .          |
And I append rows
    | artikel       | mge | tcharge | einplan |
    | EK01_CHARGE   | 100 | 444     | ja      |
And I press button "mzsubm" to open a subeditor for "Materialzuordnung" in row 1
And I modify table
    | !row  | lpsuch | zuomge | tcharge     |
    | 1     | F1     | 70     | !dontChange |
    | +2    | F2     | 30     | 444_1       |
And I save the current editor
And I switch the current editor to editor "EKBE04"
And I save the current editor

Given I open an editor "Charge444" from table "(Lots):(Lots)" with command "VIEW" for search criteria "$,,exnum=444;@maxtreffer=1;@ablageart=lebendig"
Then fields have values
    | artikel   | EK01_CHARGE   |
    | exnum     | 444           |
    | eigcharge | nein          |
    | lief^such | LIEFCHA1      |
And I close the current editor

Given I open an editor "Charge444_1" from table "(Lots):(Lots)" with command "VIEW" for search criteria "$,,exnum=444_1;@maxtreffer=1;@ablageart=lebendig"
Then fields have values
    | artikel   | EK01_CHARGE   |
    | exnum     | 444_1         |
    | eigcharge | nein          |
    | lief^such | LIEFCHA1      |
And I close the current editor

Given I open an editor "EKBE04" from table "(Purchasing):(PurchaseOrder)" with command "DELIVERY" for record "EKBE0401"
And I set fields
    | such   | LS1_04   |
    | ebeleg | LS1_04   |
    | vom    | .        |
    | ueb    | ja       |
And I set field "mge" to "80" in row 1
And I press button "mzsubm" to open a subeditor for "Materialzuordnung" in row 1
Then table has values
    | !row  | lpsuch | zuomge | tcharge     |
    | 1     | F1     | 70     | 444         |
    | 2     | F2     | 30     | 444_1       |
And I modify table
    | !row  | lpsuch | zuomge       | tcharge       |
    | 1     | F1     | !dontChange  | !dontChange   |
    | 2     | F2     | 5            | !dontChange   |
    | +3    | F3     | 5            | 444_2         |
And I save the current editor
And I switch the current editor to editor "EKBE04"
And I save the current editor

Given I open an editor "Charge444_2" from table "(Lots):(Lots)" with command "VIEW" for search criteria "$,,exnum=444_2;@maxtreffer=1;@ablageart=lebendig"
Then fields have values
    | artikel   | EK01_CHARGE   |
    | exnum     | 444_2         |
    | eigcharge | nein          |
    | lief^such | LIEFCHA1      |
And I close the current editor

Given I open an editor "EKBE04" from table "(Purchasing):(PurchaseOrder)" with command "INVOICE" for record "EKBE0401"
And I set fields
    | such   | RE1_04   |
    | ebeleg | RE1_04   |
    | vom    | .        |
    | tterm  | .        |
    | ueb    | ja       |
    | fakt   | ja       |
And I set field "mge" to "10" in row 1
And I press button "mzsubm" to open a subeditor for "Materialzuordnung" in row 1
Then table has values
    | !row  | lpsuch | zuomge | tcharge     |
    | 1     | F2     | 20     | 444_1       |
And I modify table
    | !row  | lpsuch | zuomge       | tcharge       |
    | 1     | F2     | 7            | !dontChange   |
    | +2    | F3     | 3            | 444_3         |
And I save the current editor
And I switch the current editor to editor "EKBE04"
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

Given I open an editor "Charge444_3" from table "(Lots):(Lots)" with command "VIEW" for search criteria "$,,exnum=444_3;@maxtreffer=1;@ablageart=lebendig"
Then fields have values
    | artikel   | EK01_CHARGE   |
    | exnum     | 444_3         |
    | eigcharge | nein          |
    | lief^such | LIEFCHA1      |
And I close the current editor


Scenario: 05 Chargen automatisch anlegen in VK-Belegen mit MZ, Auftrag, Lieferschein, Rechnung mit Lagerbewegung

Given I open an editor "VKAUF05" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set fields
    | kunde | KUNDECH1   |
    | such  | VKAUF05    |
    | vom   | .          |
And I append rows
    | artikel       | mge | tcharge | einplan |
    | EK01_CHARGE   | 100 | 555     | ja      |
And I press button "mzsubm" to open a subeditor for "Materialzuordnung" in row 1
And I modify table
    | !row  | lpsuch | zuomge | tcharge     |
    | 1     | F1     | 25     | !dontChange |
    | +2    | F2     | 75     | 555_1       |
And I save the current editor
And I switch the current editor to editor "VKAUF05"
And I save the current editor

Given I open an editor "Charge555" from table "(Lots):(Lots)" with command "VIEW" for search criteria "$,,exnum=555;@maxtreffer=1;@ablageart=lebendig"
Then fields have values
    | artikel   | EK01_CHARGE   |
    | exnum     | 555           |
    | eigcharge | nein          |
    | lief^such |               |
And I close the current editor

Given I open an editor "Charge555_1" from table "(Lots):(Lots)" with command "VIEW" for search criteria "$,,exnum=555_1;@maxtreffer=1;@ablageart=lebendig"
Then fields have values
    | artikel   | EK01_CHARGE   |
    | exnum     | 555_1         |
    | eigcharge | nein          |
    | lief^such |               |
And I close the current editor

Given I open an editor "VKAUF05" from table "(Sales):(SalesOrder)" with command "DELIVERY" for record "VKAUF05"
And I set fields
    | such   | VKLS_05  |
    | vom    | .        |
    | ueb    | ja       |
And I set field "mge" to "40" in row 1
And I press button "mzsubm" to open a subeditor for "Materialzuordnung" in row 1
Then table has values
    | !row  | lpsuch | zuomge | tcharge     |
    | 1     | F1     | 25     | 555         |
    | 2     | F2     | 75     | 555_1       |
And I modify table
    | !row  | lpsuch | zuomge       | tcharge       |
    | 1     | F1     | !dontChange  | !dontChange   |
    | 2     | F2     | 5            | !dontChange   |
    | +3    | F3     | 10           | 555_2         |
And I save the current editor
And I switch the current editor to editor "VKAUF05"
And I save the current editor

Given I open an editor "Charge555_2" from table "(Lots):(Lots)" with command "VIEW" for search criteria "$,,exnum=555_2;@maxtreffer=1;@ablageart=lebendig"
Then fields have values
    | artikel   | EK01_CHARGE   |
    | exnum     | 555_2         |
    | eigcharge | nein          |
    | lief^such |               |
And I close the current editor

Given I open an editor "VKAUF05" from table "(Sales):(SalesOrder)" with command "INVOICE" for record "VKAUF05"
And I set fields
    | such   | VKRE_05  |
    | vom    | .        |
    | tterm  | .        |
    | ueb    | ja       |
    | fakt   | ja       |
And I set field "mge" to "10" in row 1
And I press button "mzsubm" to open a subeditor for "Materialzuordnung" in row 1
Then table has values
    | !row  | lpsuch | zuomge | tcharge     |
    | 1     | F2     | 60     | 555_1       |
And I modify table
    | !row  | lpsuch | zuomge       | tcharge       |
    | 1     | F2     | 7            | !dontChange   |
    | +2    | F3     | 3            | 555_3         |
And I save the current editor
And I switch the current editor to editor "VKAUF05"
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

Given I open an editor "Charge555_3" from table "(Lots):(Lots)" with command "VIEW" for search criteria "$,,exnum=555_3;@maxtreffer=1;@ablageart=lebendig"
Then fields have values
    | artikel   | EK01_CHARGE   |
    | exnum     | 555_3         |
    | eigcharge | nein          |
    | lief^such |               |
And I close the current editor


Scenario: P01 Chargenpflichtangabe bei der manuellen Lagerbuchung

Given I open an editor "Lagerbuchung" for tip command "(Stockadjustment)" and arguments ""
And I set fields
    | artikel   | EK03_CHARGE   |
    | buart     | Zugang        |
    | beleg     | LBUZU_P01     |
    | beldat    | .             |
    | wert      | 10.0000       |
And I delete all rows
And I append rows
    | mge    | platz2   |
    | 10     | F1       |
# 1164 TX=de |Charge fehlt, obwohl Chargenpflicht in Konfiguration und Artikel markiert ist.
Then saving the current editor throws the exception "1164"
And I set field "tcharge2" to "1234" in row 1
And I save the current editor

Given I open an editor "Charge1234" from table "(Lots):(Lots)" with command "VIEW" for search criteria "$,,exnum=1234;@maxtreffer=1;@ablageart=lebendig"
Then fields have values
    | artikel   | EK03_CHARGE   |
    | exnum     | 1234          |
    | eigcharge | nein          |
    | lief^such |               |
And I close the current editor

Given I open an editor "Lagerbuchung" for tip command "(Stockadjustment)" and arguments ""
And I set fields
    | artikel   | EK03_CHARGE   |
    | buart     | Abgang        |
    | beleg     | LBUAB_P01     |
    | beldat    | .             |
And I delete all rows
And I append rows
    | mge    | platz    |
    | 2      | F1       |
# 1164 TX=de |Charge fehlt, obwohl Chargenpflicht in Konfiguration und Artikel markiert ist.
Then saving the current editor throws the exception "1164"
And I set field "charge1" to "!Charge1234^id" in row 1
And I save the current editor

Given I open an editor "Lagerbuchung" for tip command "(Stockadjustment)" and arguments ""
And I set fields
    | artikel   | EK03_CHARGE   |
    | buart     | Umbuchung     |
    | beleg     | LBUUM_P01     |
    | beldat    | .             |
And I delete all rows
And I append rows
    | mge    | platz    | platz2   |
    | 1      | F1       | F3       |
# 1164 TX=de |Charge fehlt, obwohl Chargenpflicht in Konfiguration und Artikel markiert ist.
Then saving the current editor throws the exception "1164"
# nur die Zugangscharge ist erforderlich, Abgangscharge nicht
And I set field "charge2" to "!Charge1234^id" in row 1
And I save the current editor

Given I open an editor "JournalZu1" from table "(Journal):(Journal)" with command "VIEW" for record "$,,artikel==EK03_CHARGE;buarta==Zugang;platz==F1;such==LLBUZU_P01"
Then fields have values
    | artikel       | EK03_CHARGE       |
    | platz         | F1                |
    | lgruppe       | KARLSRUHE         |
    | mge           | 10                |
    | buart         | 1                 |
    | buarta        | Zugang            |
    | ursache       | erfasst           |
    | detursache    | Manueller Zugang  |
Then field "tncharge" has value "1234" in row 1
And I close the current editor

Given I open an editor "JournalAb1" from table "(Journal):(Journal)" with command "VIEW" for record "$,,artikel==EK03_CHARGE;buarta==Abgang;platz==F1;such==LLBUAB_P01"
Then fields have values
    | artikel       | EK03_CHARGE       |
    | platz         | F1                |
    | lgruppe       | KARLSRUHE         |
    | mge           | 2                 |
    | buart         | 2                 |
    | buarta        | Abgang            |
    | ursache       | erfasst           |
    | detursache    | Manueller Abgang  |
Then field "tvcharge" has value "1234" in row 1
And I close the current editor

Given I open an editor "JournalUmZu1" from table "(Journal):(Journal)" with command "VIEW" for record "$,,artikel==EK03_CHARGE;buarta==Zugang;platz==F3;such==LLBUUM_P01"
Then fields have values
    | artikel       | EK03_CHARGE           |
    | platz         | F3                    |
    | lgruppe       | KARLSRUHE             |
    | mge           | 1                     |
    | buart         | 1                     |
    | buarta        | Zugang                |
    | ursache       | erfasst               |
    | detursache    | Manuelle Umbuchung    |
Then field "tncharge" has value "1234" in row 1
And I close the current editor

Given I open an editor "JournalUmAb1" from table "(Journal):(Journal)" with command "VIEW" for record "$,,artikel==EK03_CHARGE;buarta==Abgang;platz==F1;such==LLBUUM_P01"
Then fields have values
    | artikel       | EK03_CHARGE           |
    | platz         | F1                    |
    | lgruppe       | KARLSRUHE             |
    | mge           | 1                     |
    | buart         | 2                     |
    | buarta        | Abgang                |
    | ursache       | erfasst               |
    | detursache    | Manuelle Umbuchung    |
Then field "tvcharge" has value "" in row 1
And I close the current editor


Scenario: P02 Chargenpflichtangabe bei der Bestandskorrektur

Given I open an editor "Korrektur" for tip command "(SInventory)" and arguments ""
And I set fields
    | artikel   | EK03_CHARGE |
    | beleg     | KORR_P02    |
    | beldat    | .           |
And I set field "platz" to "F3" in row 1
Then the table has 1 rows
Then table has values
    | mge   | tcharge1  |
    | 1     | 1234      |
And I set field "mge" to "5" in row 1
# neue Zeile ohne Charge bringt Fehler
And I append rows
    | platz  | mge   | ze       | tcharge1  |
    | F3     | 1     | Stück    |           |
# 1164 TX=de |Charge fehlt, obwohl Chargenpflicht in Konfiguration und Artikel markiert ist.
Then saving the current editor throws the exception "1164"
And I set field "tcharge1" to "12345" in row 2
And I save the current editor

Given I open an editor "JournalZu1" from table "(Journal):(Journal)" with command "VIEW" for record "$,,artikel==EK03_CHARGE;buarta==Bestandskorrektur;mge==4;platz==F3;such==LKORR_P02"
Then fields have values
    | artikel       | EK03_CHARGE                   |
    | platz         | F3                            |
    | lgruppe       | KARLSRUHE                     |
    | mge           | 4                             |
    | buart         | 3                             |
    | buarta        | Bestandskorrektur             |
    | ursache       | erfasst                       |
    | detursache    | Manuelle Bestandskorrektur    |
Then field "tncharge" has value "1234" in row 1
And I close the current editor

Given I open an editor "JournalZu2" from table "(Journal):(Journal)" with command "VIEW" for record "$,,artikel==EK03_CHARGE;buarta==Bestandskorrektur;mge==1;platz==F3;such==LKORR_P02"
Then fields have values
    | artikel       | EK03_CHARGE                   |
    | platz         | F3                            |
    | lgruppe       | KARLSRUHE                     |
    | mge           | 1                             |
    | buart         | 3                             |
    | buarta        | Bestandskorrektur             |
    | ursache       | erfasst                       |
    | detursache    | Manuelle Bestandskorrektur    |
Then field "tncharge" has value "12345" in row 1
And I close the current editor


# chimlager = nein, gleich oder reduzieren für vorhandene Bestände ohne Charge erlaubt
# ohne chimlager haben geladene Bestände aus Platzelementen nie eine charge
Scenario: P03 Chargenpflichtangabe bei der Bestandskorrektur und chimlager=nein

Given I open an editor "Korrektur" for tip command "(SInventory)" and arguments ""
And I set fields
    | artikel   | CHIMLAGERNEIN |
    | beleg     | KORR_P03_1    |
    | beldat    | .             |
And I set field "platz" to "F1" in row 1
And I modify table
    | !row  | platz  | mge   | ze       |
    | 1     | F1     | 10    | Stück    |
# 1434 Zusätzlicher Bestand darf nur in neuer Zeile mit Charge gebucht werden, auch wenn Charge nicht im Lager geführt wird.
Then saving the current editor throws the exception "1434"
And I set field "tcharge1" to "789" in row 1
And I save the current editor

Given I open an editor "Korrektur" for tip command "(SInventory)" and arguments ""
And I set fields
    | artikel   | CHIMLAGERNEIN |
    | beleg     | KORR_P03_2    |
    | beldat    | .             |
And I set field "platz" to "F1" in row 1
Then the table has 1 rows
Then table has values
    | mge   | tcharge1  |
    | 10    |           |
And I set field "mge" to "12" in row 1
# 1434 Zusätzlicher Bestand darf nur in neuer Zeile mit Charge gebucht werden, auch wenn Charge nicht im Lager geführt wird.
Then saving the current editor throws the exception "1434"
And I set field "mge" to "10" in row 1
And I append rows
    | platz  | mge   | ze       | tcharge1  |
    | F1     | 2     | Stück    |           |
# 6633 de      |Einheit mit gleichem Faktor, gleichem Behälter, gleicher Charge, gleichem Projekt oder gleicher Verwendung gibt es schon.
Then saving the current editor throws the exception "6633"
And I set field "tcharge1" to "789" in row 2
And I save the current editor

# vorhandene Menge laden und reduzieren kann ohne Charge gebucht werden
Given I open an editor "Korrektur" for tip command "(SInventory)" and arguments ""
And I set fields
    | artikel   | CHIMLAGERNEIN |
    | beleg     | KORR_P03_3    |
    | beldat    | .             |
And I set field "platz" to "F1" in row 1
Then the table has 1 rows
Then table has values
    | mge   | tcharge1  |
    | 12    |           |
And I set field "mge" to "11" in row 1
And I save the current editor

Given I open an editor "Journal1" from table "(Journal):(Journal)" with command "VIEW" for record "$,,artikel==CHIMLAGERNEIN;buarta==Bestandskorrektur;platz==F1;such==LKORR_P03_1"
Then fields have values
    | artikel       | CHIMLAGERNEIN                 |
    | platz         | F1                            |
    | lgruppe       | KARLSRUHE                     |
    | mge           | 10                            |
    | buart         | 3                             |
    | buarta        | Bestandskorrektur             |
    | ursache       | erfasst                       |
    | detursache    | Manuelle Bestandskorrektur    |
# Chargenangabe wird aus Beleg immer ins LJ uebernommen, auch bei chimlager=nein
Then field "tncharge" has value "789" in row 1
And I close the current editor

Given I open an editor "Journal2" from table "(Journal):(Journal)" with command "VIEW" for record "$,,artikel==CHIMLAGERNEIN;buarta==Bestandskorrektur;platz==F1;mge==2;such==LKORR_P03_2"
Then fields have values
    | artikel       | CHIMLAGERNEIN                 |
    | platz         | F1                            |
    | lgruppe       | KARLSRUHE                     |
    | mge           | 2                             |
    | buart         | 3                             |
    | buarta        | Bestandskorrektur             |
    | ursache       | erfasst                       |
    | detursache    | Manuelle Bestandskorrektur    |
# Chargenangabe wird aus Beleg immer ins LJ uebernommen, auch bei chimlager=nein
Then field "tncharge" has value "789" in row 1
And I close the current editor

Given I open an editor "Journal3" from table "(Journal):(Journal)" with command "VIEW" for record "$,,artikel==CHIMLAGERNEIN;buarta==Bestandskorrektur;platz==F1;such==LKORR_P03_3"
Then fields have values
    | artikel       | CHIMLAGERNEIN                 |
    | platz         | F1                            |
    | lgruppe       | KARLSRUHE                     |
    | mge           | -1                            |
    | buart         | 3                             |
    | buarta        | Bestandskorrektur             |
    | ursache       | erfasst                       |
    | detursache    | Manuelle Bestandskorrektur    |
# vorhandene Menge laden und reduzieren kann ohne Charge gebucht werden
Then field "tncharge" is empty in row 1
Then field "tvcharge" is empty in row 1
And I close the current editor


Scenario: P04 Chargenpflichtangabe bei manueller Lagerbuchung Zugang bzw. Abgang bei chimlager=nein

Given I open an editor "Lagerbuchung" for tip command "(Stockadjustment)" and arguments ""
And I set fields
    | artikel   | CHIMLAGERNEIN |
    | buart     | Zugang        |
    | beleg     | LBUZU_P04     |
    | beldat    | .             |
    | wert      | 10.0000       |
And I delete all rows
And I append rows
    | mge    | platz2   |
    | 10     | F1       |
# 1164 TX=de |Charge fehlt, obwohl Chargenpflicht in Konfiguration und Artikel markiert ist.
Then saving the current editor throws the exception "1164"
# vorhandene exnum eintragen
And I set field "tcharge2" to "789" in row 1
And I save the current editor

Given I open an editor "Charge789" from table "(Lots):(Lots)" with command "VIEW" for search criteria "$,,exnum=789;@maxtreffer=1;@ablageart=lebendig"
Then fields have values
    | artikel   | CHIMLAGERNEIN |
    | exnum     | 789           |
    | eigcharge | nein          |
    | lief^such |               |
And I close the current editor

Given I open an editor "Lagerbuchung" for tip command "(Stockadjustment)" and arguments ""
And I set fields
    | artikel   | CHIMLAGERNEIN |
    | buart     | Abgang        |
    | beleg     | LBUAB_P04     |
    | beldat    | .             |
And I delete all rows
And I append rows
    | mge    | platz    |
    | 2      | F1       |
# 1164 TX=de |Charge fehlt, obwohl Chargenpflicht in Konfiguration und Artikel markiert ist.
Then saving the current editor throws the exception "1164"
And I set field "charge1" to "!Charge789^id" in row 1
And I save the current editor

Given I open an editor "JournalZu1" from table "(Journal):(Journal)" with command "VIEW" for record "$,,artikel==CHIMLAGERNEIN;buarta==Zugang;platz==F1;such==LLBUZU_P04"
Then fields have values
    | artikel       | CHIMLAGERNEIN     |
    | platz         | F1                |
    | lgruppe       | KARLSRUHE         |
    | mge           | 10                |
    | buart         | 1                 |
    | buarta        | Zugang            |
    | ursache       | erfasst           |
    | detursache    | Manueller Zugang  |
# Chargenangabe wird aus Beleg immer ins LJ uebernommen, auch bei chimlager=nein
Then field "tncharge" has value "789" in row 1
And I close the current editor

Given I open an editor "JournalAb1" from table "(Journal):(Journal)" with command "VIEW" for record "$,,artikel==CHIMLAGERNEIN;buarta==Abgang;platz==F1;such==LLBUAB_P04"
Then fields have values
    | artikel       | CHIMLAGERNEIN     |
    | platz         | F1                |
    | lgruppe       | KARLSRUHE         |
    | mge           | 2                 |
    | buart         | 2                 |
    | buarta        | Abgang            |
    | ursache       | erfasst           |
    | detursache    | Manueller Abgang  |
Then field "tvcharge" has value "789" in row 1
And I close the current editor


Scenario: P05 Manuelle Lagerbuchung Umbuchung bei chimlager=nein OHNE Chargenangabe moeglich

Given I open an editor "Lagerbuchung" for tip command "(Stockadjustment)" and arguments ""
And I set fields
    | artikel   | CHIMLAGERNEIN |
    | buart     | Umbuchung     |
    | beleg     | LBUUM_P05     |
    | beldat    | .             |
And I delete all rows
And I append rows
    | mge    | platz    | platz2   |
    | 1      | F1       | F3       |
Then field "charge2" is empty in row 1
Then field "charge1" is empty in row 1
And I save the current editor


Scenario: P06 Chargenpflichtangabe in EK-Belegen beim Buchen von Lieferschein oder Rechnung mit Lagerbewegung

Given I open an editor "EKBEP06" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set fields
    | lief | LIEFCHA1   |
    | such | EKBEP06    |
    | vom  | .          |
And I append rows
    | artikel       | mge | einplan |
    | EK01_CHARGE   | 100 | ja      |
# Charge ist noch keine Pflichtangabe in der EK-Bestellung
Then field "tcharge" is empty in row 1
And I save the current editor

# Charge ist noch keine Pflichtangabe beim Erstellen des Lieferscheins
Given I open an editor "EKBEP06" from table "(Purchasing):(PurchaseOrder)" with command "DELIVERY" for record "EKBEP06"
And I set fields
    | such   | LS1_P06  |
    | ebeleg | LS1_P06  |
    | vom    | .        |
    | ueb    | nein     |
And I set field "mge" to "80" in row 1
Then field "tcharge" is empty in row 1
And I save the current editor

# Charge ist noch keine Pflichtangabe beim Erstellen einer Rechnung mit Lagerbewegung
Given I open an editor "EKBEP06" from table "(Purchasing):(PurchaseOrder)" with command "INVOICE" for record "EKBEP06"
And I set fields
    | such   | RE1_P06  |
    | ebeleg | RE1_P06  |
    | vom    | .        |
    | tterm  | .        |
    | ueb    | nein     |
    | fakt   | ja       |
And I set field "mge" to "20" in row 1
Then field "tcharge" is empty in row 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# Charge ist Pflichtangabe beim Buchen des EK-Lieferscheins
Given I open an editor "EKLSP06" from table "(Purchasing):(PackingSlip)" with command "UPDATE" for record "LS1_P06"
And I set field "ueb" to "ja"
Then field "tcharge" is empty in row 1
# 1164 TX=de |Charge fehlt, obwohl Chargenpflicht in Konfiguration und Artikel markiert ist.
Then saving the current editor throws the exception "1164"
And I set field "tcharge" to "0606" in row 1
And I save the current editor

# Charge ist Pflichtangabe beim Buchen der EK-Rechnung mit Lagerbewegung
Given I open an editor "EKREP06" from table "(Purchasing):(Invoice)" with command "UPDATE" for record "RE1_P06"
And I set field "ueb" to "ja"
Then field "tcharge" is empty in row 1
# 1164 TX=de |Charge fehlt, obwohl Chargenpflicht in Konfiguration und Artikel markiert ist.
Then saving the current editor throws the exception "1164"
And I set field "tcharge" to "0606" in row 1
And I save the current editor

Given I open an editor "JournalZu1" from table "(Journal):(Journal)" with command "VIEW" for record "$,,artikel==EK01_CHARGE;buarta==Zugang;platz==F1;ebeleg==LS1_P06"
Then fields have values
    | artikel       | EK01_CHARGE           |
    | platz         | F1                    |
    | lgruppe       | KARLSRUHE             |
    | mge           | 80                    |
    | buart         | 1                     |
    | buarta        | Zugang                |
    | ursache       | Lieferschein          |
    | detursache    | Lieferschein Einkauf  |
Then field "tncharge" has value "0606" in row 1
And I close the current editor

Given I open an editor "JournalZu2" from table "(Journal):(Journal)" with command "VIEW" for record "$,,artikel==EK01_CHARGE;buarta==Zugang;platz==F1;ebeleg==RE1_P06"
Then fields have values
    | artikel       | EK01_CHARGE           |
    | platz         | F1                    |
    | lgruppe       | KARLSRUHE             |
    | mge           | 20                    |
    | buart         | 1                     |
    | buarta        | Zugang                |
    | ursache       | Rechnung              |
    | detursache    | Rechnung              |
Then field "tncharge" has value "0606" in row 1
And I close the current editor


Scenario: P07 Chargenpflichtangabe beim Buchen von VK-Belegen, Lieferschein, Rechnung mit Lagerbewegung

Given I open an editor "VKAUFP07" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set fields
    | kunde | KUNDECH1   |
    | such  | VKAUFP07   |
    | vom   | .          |
And I append rows
    | artikel       | mge | einplan |
    | EK01_CHARGE   | 50  | ja      |
# Charge ist noch keine Pflichtangabe im VK-Auftrag
Then field "tcharge" is empty in row 1
And I save the current editor

# Charge ist noch keine Pflichtangabe beim Erstellen des VK-Lieferschein
Given I open an editor "VKAUFP07" from table "(Sales):(SalesOrder)" with command "DELIVERY" for record "VKAUFP07"
And I set fields
    | such   | VKLS_P07 |
    | vom    | .        |
    | ueb    | nein     |
And I set field "mge" to "20" in row 1
Then field "tcharge" is empty in row 1
And I save the current editor

# Charge ist noch keine Pflichtangabe beim Erstellen einer VK-Rechnung mit Lagerbewegung
Given I open an editor "VKAUFP07" from table "(Sales):(SalesOrder)" with command "INVOICE" for record "VKAUFP07"
And I set fields
    | such   | VKRE_P07 |
    | vom    | .        |
    | tterm  | .        |
    | ueb    | nein     |
    | fakt   | ja       |
And I set field "mge" to "30" in row 1
Then field "tcharge" is empty in row 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# Charge oeffnen um Zugriff auf die ID zu haben
Given I open an editor "Charge0606" from table "(Lots):(Lots)" with command "VIEW" for search criteria "$,,exnum=0606;@maxtreffer=1;@ablageart=lebendig"
Then fields have values
    | exnum     | 0606      |
    | eigcharge | nein      |
    | lief^such | LIEFCHA1  |
And I close the current editor

# Charge ist Pflichtangabe beim Buchen des VK-Lieferscheins
# vorhandene Charge nehmen, die vorher durch EK-Beleg zugebucht wurde, es darf keine neue Charge automatisch erstellt werden
Given I open an editor "VKLSP07" from table "(Sales):(PackingSlip)" with command "UPDATE" for record "VKLS_P07"
And I set field "ueb" to "ja"
Then field "tcharge" is empty in row 1
# 1164 TX=de |Charge fehlt, obwohl Chargenpflicht in Konfiguration und Artikel markiert ist.
Then saving the current editor throws the exception "1164"
And I set field "tcharge" to "0606" in row 1
Then field "charge^id" has value "!Charge0606^id" in row 1
And I set field "ljtext1" to "VKLS_P07" in row 1
And I save the current editor

# Charge ist Pflichtangabe beim Buchen der VK-Rechnung mit Lagerbewegung
Given I open an editor "VKREP07" from table "(Sales):(Invoice)" with command "UPDATE" for record "VKRE_P07"
And I set field "ueb" to "ja"
Then field "tcharge" is empty in row 1
# 1164 TX=de |Charge fehlt, obwohl Chargenpflicht in Konfiguration und Artikel markiert ist.
Then saving the current editor throws the exception "1164"
And I set field "tcharge" to "0606" in row 1
Then field "charge^id" has value "!Charge0606^id" in row 1
And I set field "ljtext1" to "VKRE_P07" in row 1
And I save the current editor

Given I open an editor "JournalAb1" from table "(Journal):(Journal)" with command "VIEW" for record "$,,artikel==EK01_CHARGE;buarta==Abgang;platz==F1;erbtext1==VKLS_P07"
Then fields have values
    | artikel       | EK01_CHARGE           |
    | platz         | F1                    |
    | lgruppe       | KARLSRUHE             |
    | mge           | 20                    |
    | buart         | 2                     |
    | buarta        | Abgang                |
    | ursache       | Lieferschein          |
    | detursache    | Lieferschein Verkauf  |
Then field "tvcharge" has value "0606" in row 1
And I close the current editor

Given I open an editor "JournalAb2" from table "(Journal):(Journal)" with command "VIEW" for record "$,,artikel==EK01_CHARGE;buarta==Abgang;platz==F1;erbtext1==VKRE_P07"
Then fields have values
    | artikel       | EK01_CHARGE           |
    | platz         | F1                    |
    | lgruppe       | KARLSRUHE             |
    | mge           | 30                    |
    | buart         | 2                     |
    | buarta        | Abgang                |
    | ursache       | Rechnung              |
    | detursache    | Rechnung              |
Then field "tvcharge" has value "0606" in row 1
And I close the current editor


Scenario: P08 Chargenpflichtangabe in EK-Belegen mit MZ beim Buchen von Lieferschein oder Rechnung mit Lagerbewegung

Given I open an editor "EKBEP08" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set fields
    | lief | LIEFCHA2   |
    | such | EKBEP08    |
    | vom  | .          |
And I append rows
    | artikel       | mge | einplan |
    | EK02_CHARGE   | 100 | ja      |
# Charge ist noch keine Pflichtangabe in der EK-Bestellung
Then field "tcharge" is empty in row 1
And I press button "mzsubm" to open a subeditor for "Materialzuordnung" in row 1
And I modify table
    | !row  | lpsuch | zuomge   | tcharge   |
    | 1     | F1     | 70       |           |
    | +2    | F2     | 30       |           |
And I save the current editor
And I switch the current editor to editor "EKBEP08"
And I save the current editor

# Charge ist noch keine Pflichtangabe beim Erstellen des Lieferscheins
Given I open an editor "EKBEP08" from table "(Purchasing):(PurchaseOrder)" with command "DELIVERY" for record "EKBEP08"
And I set fields
    | such   | LS1_P08  |
    | ebeleg | LS1_P08  |
    | vom    | .        |
    | ueb    | nein     |
And I set field "mge" to "80" in row 1
Then field "tcharge" is empty in row 1
And I press button "mzsubm" to open a subeditor for "Materialzuordnung" in row 1
Then table has values
    | !row  | lpsuch | zuomge | tcharge |
    | 1     | F1     | 70     |         |
    | 2     | F2     | 30     |         |
And I modify table
    | !row  | lpsuch | zuomge       | tcharge       |
    | 1     | F1     | !dontChange  | !dontChange   |
    | 2     | F2     | 5            | !dontChange   |
    | +3    | F3     | 5            | !dontChange   |
And I save the current editor
And I switch the current editor to editor "EKBEP08"
And I save the current editor

# Charge ist noch keine Pflichtangabe beim Erstellen einer Rechnung mit Lagerbewegung
Given I open an editor "EKBEP08" from table "(Purchasing):(PurchaseOrder)" with command "INVOICE" for record "EKBEP08"
And I set fields
    | such   | RE1_P08  |
    | ebeleg | RE1_P08  |
    | vom    | .        |
    | tterm  | .        |
    | ueb    | nein     |
    | fakt   | ja       |
And I set field "mge" to "20" in row 1
Then field "tcharge" is empty in row 1
And I press button "mzsubm" to open a subeditor for "Materialzuordnung" in row 1
Then table has values
    | !row  | lpsuch | zuomge | tcharge |
    | 1     | F2     | 20     |         |
And I modify table
    | !row  | lpsuch | zuomge   | tcharge       |
    | 1     | F1     | 10       | !dontChange   |
    | +2    | F2     | 10       | !dontChange   |
And I save the current editor
And I switch the current editor to editor "EKBEP08"
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# Charge ist Pflichtangabe beim Buchen des EK-Lieferscheins
Given I open an editor "EKLSP08" from table "(Purchasing):(PackingSlip)" with command "UPDATE" for record "LS1_P08"
And I set field "ueb" to "ja"
Then field "tcharge" is empty in row 1
# Charge im Vorgang und in MZ fehlt oder ist unvollständig, obwohl Chargenpflicht in Konfiguration und Artikel gesetzt ist.
Then saving the current editor throws the exception "1490"
And I press button "mzsubm" to open a subeditor for "Materialzuordnung" in row 1
And I modify table
    | !row  | tcharge   |
    | 1     | 0808      |
    | 2     | 0808      |
    | 3     |           |
And I save the current editor
And I switch the current editor to editor "EKLSP08"
# in einer Zeile der MZ fehlt die Chargenangabe
# Charge im Vorgang und in MZ fehlt oder ist unvollständig, obwohl Chargenpflicht in Konfiguration und Artikel gesetzt ist.
Then saving the current editor throws the exception "1490"
And I press button "mzsubm" to open a subeditor for "Materialzuordnung" in row 1
And I modify table
    | !row  | tcharge   |
    | 3     | 0808_1    |
And I save the current editor
And I switch the current editor to editor "EKLSP08"
And I save the current editor

# Charge ist Pflichtangabe beim Buchen der EK-Rechnung mit Lagerbewegung
Given I open an editor "EKREP08" from table "(Purchasing):(Invoice)" with command "UPDATE" for record "RE1_P08"
And I set field "ueb" to "ja"
Then field "tcharge" is empty in row 1
# Charge im Vorgang und in MZ fehlt oder ist unvollständig, obwohl Chargenpflicht in Konfiguration und Artikel gesetzt ist.
Then saving the current editor throws the exception "1490"
And I press button "mzsubm" to open a subeditor for "Materialzuordnung" in row 1
And I modify table
    | !row  | tcharge   |
    | 1     | 0808      |
    | 2     |           |
And I save the current editor
And I switch the current editor to editor "EKREP08"
# in einer Zeile der MZ fehlt die Chargenangabe
# Charge im Vorgang und in MZ fehlt oder ist unvollständig, obwohl Chargenpflicht in Konfiguration und Artikel gesetzt ist.
Then saving the current editor throws the exception "1490"
And I press button "mzsubm" to open a subeditor for "Materialzuordnung" in row 1
And I modify table
    | !row  | tcharge   |
    | 2     | 0808_1    |
And I save the current editor
And I switch the current editor to editor "EKREP08"
And I save the current editor

Given I open an editor "JournalZu1" from table "(Journal):(Journal)" with command "VIEW" for record "$,,artikel==EK02_CHARGE;buarta==Zugang;platz==F1;ebeleg==LS1_P08"
Then fields have values
    | artikel       | EK02_CHARGE           |
    | platz         | F1                    |
    | lgruppe       | KARLSRUHE             |
    | mge           | 70                    |
    | buart         | 1                     |
    | buarta        | Zugang                |
    | ursache       | Lieferschein          |
    | detursache    | Lieferschein Einkauf  |
Then field "tncharge" has value "0808" in row 1
And I close the current editor

Given I open an editor "JournalZu2" from table "(Journal):(Journal)" with command "VIEW" for record "$,,artikel==EK02_CHARGE;buarta==Zugang;platz==F2;ebeleg==LS1_P08"
Then fields have values
    | artikel       | EK02_CHARGE           |
    | platz         | F2                    |
    | lgruppe       | KARLSRUHE             |
    | mge           | 5                     |
    | buart         | 1                     |
    | buarta        | Zugang                |
    | ursache       | Lieferschein          |
    | detursache    | Lieferschein Einkauf  |
Then field "tncharge" has value "0808" in row 1
And I close the current editor

Given I open an editor "JournalZu3" from table "(Journal):(Journal)" with command "VIEW" for record "$,,artikel==EK02_CHARGE;buarta==Zugang;platz==F3;ebeleg==LS1_P08"
Then fields have values
    | artikel       | EK02_CHARGE           |
    | platz         | F3                    |
    | lgruppe       | KARLSRUHE             |
    | mge           | 5                     |
    | buart         | 1                     |
    | buarta        | Zugang                |
    | ursache       | Lieferschein          |
    | detursache    | Lieferschein Einkauf  |
Then field "tncharge" has value "0808_1" in row 1
And I close the current editor

Given I open an editor "JournalZu4" from table "(Journal):(Journal)" with command "VIEW" for record "$,,artikel==EK02_CHARGE;buarta==Zugang;platz==F1;ebeleg==RE1_P08"
Then fields have values
    | artikel       | EK02_CHARGE           |
    | platz         | F1                    |
    | lgruppe       | KARLSRUHE             |
    | mge           | 10                    |
    | buart         | 1                     |
    | buarta        | Zugang                |
    | ursache       | Rechnung              |
    | detursache    | Rechnung              |
Then field "tncharge" has value "0808" in row 1
And I close the current editor

Given I open an editor "JournalZu5" from table "(Journal):(Journal)" with command "VIEW" for record "$,,artikel==EK02_CHARGE;buarta==Zugang;platz==F2;ebeleg==RE1_P08"
Then fields have values
    | artikel       | EK02_CHARGE           |
    | platz         | F2                    |
    | lgruppe       | KARLSRUHE             |
    | mge           | 10                    |
    | buart         | 1                     |
    | buarta        | Zugang                |
    | ursache       | Rechnung              |
    | detursache    | Rechnung              |
Then field "tncharge" has value "0808_1" in row 1
And I close the current editor


Scenario: P08A Chargenpflichtangabe in EK-Belegen mit MZ, Chargenangabe in Positon und in MZ

#2023039311164
# in der MZ der Bestellung mzueb=nein setzen (Vorgangssumme <> Tabellensumme)
Given I open an editor "EKBEP08A" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set fields
    | lief | LIEFCHA1   |
    | such | EKBEP08A   |
    | vom  | .          |
And I append rows
    | artikel       | mge | einplan | tcharge   |
    | EK03_CHARGE   | 100 | ja      | 88888     |
And I press button "mzsubm" to open a subeditor for "Materialzuordnung" in row 1
And I set field "mzueb" to "nein"
And I modify table
    | !row  | lpsuch | zuomge   | tcharge       |
    | 1     | F1     | 50       | !dontChange   |
    | +2    | F2     | 20       | 88888_1       |
And I save the current editor
And I switch the current editor to editor "EKBEP08A"
And I save the current editor

# Charge ist noch keine Pflichtangabe beim Erstellen des Lieferscheins, in der MZ gibt es Menge ohne Charge
Given I open an editor "EKBEP08A" from table "(Purchasing):(PurchaseOrder)" with command "DELIVERY" for record "EKBEP08A"
And I set fields
    | such   | LS1_P08A |
    | ebeleg | LS1_P08A |
    | vom    | .        |
    | ueb    | nein     |
And I set field "mge" to "80" in row 1
Then field "tcharge" has value "88888" in row 1
And I press button "mzsubm" to open a subeditor for "Materialzuordnung" in row 1
Then table has values
    | !row  | lpsuch | zuomge | tcharge |
    | 1     | F1     | 50     | 88888   |
    | 2     | F2     | 20     | 88888_1 |
And I modify table
    | !row  | lpsuch | zuomge       | tcharge       |
    | 1     | F1     | !dontChange  | !dontChange   |
    | 2     | F2     | !dontChange  | !dontChange   |
    | +3    | F3     | 10           |               |
And I save the current editor
And I switch the current editor to editor "EKBEP08A"
And I save the current editor

# Charge ist noch keine Pflichtangabe beim Erstellen einer Rechnung mit Lagerbewegung
Given I open an editor "EKBEP08A" from table "(Purchasing):(PurchaseOrder)" with command "INVOICE" for record "EKBEP08A"
And I set fields
    | such   | RE1_P08A |
    | ebeleg | RE1_P08A |
    | vom    | .        |
    | tterm  | .        |
    | ueb    | nein     |
    | fakt   | ja       |
And I set field "mge" to "20" in row 1
Then field "tcharge" has value "88888" in row 1
# Charge wurde aus der Position in die MZ uebernommen
And I press button "mzsubm" to open a subeditor for "Materialzuordnung" in row 1
Then table has values
    | !row  | lpsuch | zuomge | tcharge |
    | 1     |        | 20     | 88888   |
And I modify table
    | !row  | lpsuch | zuomge   | tcharge   |
    | 1     | F1     | 10       | 88888_1   |
    | +2    | F2     | 10       |           |
And I save the current editor
And I switch the current editor to editor "EKBEP08A"
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# Charge ist Pflichtangabe beim Buchen des EK-Lieferscheins
Given I open an editor "EKLSP08A" from table "(Purchasing):(PackingSlip)" with command "UPDATE" for record "LS1_P08A"
And I set field "ueb" to "ja"
Then field "tcharge" has value "88888" in row 1
# Charge in MZ zu Vorgang fehlt, obwohl Chargenpflicht in Konfiguration und Artikel markiert ist.
Then saving the current editor throws the exception "1470"
And I press button "mzsubm" to open a subeditor for "Materialzuordnung" in row 1
And I modify table
    | !row  | tcharge       |
    | 1     | !dontChange   |
    | 2     | !dontChange   |
    | 3     | 88888_2       |
And I save the current editor
And I switch the current editor to editor "EKLSP08A"
And I save the current editor

# Charge ist Pflichtangabe beim Buchen der EK-Rechnung mit Lagerbewegung
Given I open an editor "EKREP08A" from table "(Purchasing):(Invoice)" with command "UPDATE" for record "RE1_P08A"
And I set field "ueb" to "ja"
Then field "tcharge" has value "88888" in row 1
# Charge in MZ zu Vorgang fehlt, obwohl Chargenpflicht in Konfiguration und Artikel markiert ist.
Then saving the current editor throws the exception "1470"
And I press button "mzsubm" to open a subeditor for "Materialzuordnung" in row 1
And I modify table
    | !row  | tcharge       |
    | 1     | !dontChange   |
    | 2     | 88888_2       |
And I save the current editor
And I switch the current editor to editor "EKREP08A"
And I save the current editor

Given I open an editor "JournalZu1" from table "(Journal):(Journal)" with command "VIEW" for record "$,,artikel==EK03_CHARGE;buarta==Zugang;platz==F1;ebeleg==LS1_P08A"
Then fields have values
    | artikel       | EK03_CHARGE           |
    | platz         | F1                    |
    | lgruppe       | KARLSRUHE             |
    | mge           | 50                    |
    | buart         | 1                     |
    | buarta        | Zugang                |
    | ursache       | Lieferschein          |
    | detursache    | Lieferschein Einkauf  |
Then field "tncharge" has value "88888" in row 1
And I close the current editor

Given I open an editor "JournalZu2" from table "(Journal):(Journal)" with command "VIEW" for record "$,,artikel==EK03_CHARGE;buarta==Zugang;platz==F2;ebeleg==LS1_P08A"
Then fields have values
    | artikel       | EK03_CHARGE           |
    | platz         | F2                    |
    | lgruppe       | KARLSRUHE             |
    | mge           | 20                    |
    | buart         | 1                     |
    | buarta        | Zugang                |
    | ursache       | Lieferschein          |
    | detursache    | Lieferschein Einkauf  |
Then field "tncharge" has value "88888_1" in row 1
And I close the current editor

Given I open an editor "JournalZu3" from table "(Journal):(Journal)" with command "VIEW" for record "$,,artikel==EK03_CHARGE;buarta==Zugang;platz==F3;ebeleg==LS1_P08A"
Then fields have values
    | artikel       | EK03_CHARGE           |
    | platz         | F3                    |
    | lgruppe       | KARLSRUHE             |
    | mge           | 10                    |
    | buart         | 1                     |
    | buarta        | Zugang                |
    | ursache       | Lieferschein          |
    | detursache    | Lieferschein Einkauf  |
Then field "tncharge" has value "88888_2" in row 1
And I close the current editor

Given I open an editor "JournalZu4" from table "(Journal):(Journal)" with command "VIEW" for record "$,,artikel==EK03_CHARGE;buarta==Zugang;platz==F1;ebeleg==RE1_P08A"
Then fields have values
    | artikel       | EK03_CHARGE           |
    | platz         | F1                    |
    | lgruppe       | KARLSRUHE             |
    | mge           | 10                    |
    | buart         | 1                     |
    | buarta        | Zugang                |
    | ursache       | Rechnung              |
    | detursache    | Rechnung              |
Then field "tncharge" has value "88888_1" in row 1
And I close the current editor

Given I open an editor "JournalZu5" from table "(Journal):(Journal)" with command "VIEW" for record "$,,artikel==EK03_CHARGE;buarta==Zugang;platz==F2;ebeleg==RE1_P08A"
Then fields have values
    | artikel       | EK03_CHARGE           |
    | platz         | F2                    |
    | lgruppe       | KARLSRUHE             |
    | mge           | 10                    |
    | buart         | 1                     |
    | buarta        | Zugang                |
    | ursache       | Rechnung              |
    | detursache    | Rechnung              |
Then field "tncharge" has value "88888_2" in row 1
And I close the current editor


Scenario: P09 Chargenpflichtangabe beim Buchen von VK-Belegen mit MZ, Lieferschein, Rechnung mit Lagerbewegung

Given I open an editor "VKAUFP09" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set fields
    | kunde | KUNDECH1   |
    | such  | VKAUFP09   |
    | vom   | .          |
And I append rows
    | artikel       | mge | einplan |
    | EK02_CHARGE   | 100 | ja      |
# Charge ist noch keine Pflichtangabe im VK-Auftrag
Then field "tcharge" is empty in row 1
And I press button "mzsubm" to open a subeditor for "Materialzuordnung" in row 1
And I modify table
    | !row  | lpsuch | zuomge   | tcharge   |
    | 1     | F1     | 70       |           |
    | +2    | F2     | 30       |           |
And I save the current editor
And I switch the current editor to editor "VKAUFP09"
And I save the current editor

# Charge ist noch keine Pflichtangabe beim Erstellen des VK-Lieferschein
Given I open an editor "VKAUFP09" from table "(Sales):(SalesOrder)" with command "DELIVERY" for record "VKAUFP09"
And I set fields
    | such   | VKLS_P09 |
    | vom    | .        |
    | ueb    | nein     |
And I set field "mge" to "40" in row 1
Then field "tcharge" is empty in row 1
And I press button "mzsubm" to open a subeditor for "Materialzuordnung" in row 1
Then table has values
    | !row  | lpsuch | zuomge | tcharge |
    | 1     | F1     | 70     |         |
    | 2     | F2     | 30     |         |
And I modify table
    | !row  | lpsuch | zuomge   | tcharge       |
    | 1     | F1     | 30       | !dontChange   |
    | 2     | F2     | 5        | !dontChange   |
    | +3    | F3     | 5        | !dontChange   |
And I save the current editor
And I switch the current editor to editor "VKAUFP09"
And I save the current editor

    # Charge ist noch keine Pflichtangabe beim Erstellen einer VK-Rechnung mit Lagerbewegung
Given I open an editor "VKAUFP09" from table "(Sales):(SalesOrder)" with command "INVOICE" for record "VKAUFP09"
And I set fields
    | such   | VKRE_P09 |
    | vom    | .        |
    | tterm  | .        |
    | ueb    | nein     |
    | fakt   | ja       |
And I set field "mge" to "60" in row 1
Then field "tcharge" is empty in row 1
    And I press button "mzsubm" to open a subeditor for "Materialzuordnung" in row 1
Then table has values
    | !row  | lpsuch | zuomge | tcharge |
    | 1     | F1     | 40     |         |
    | 2     | F2     | 20     |         |
And I modify table
    | !row  | lpsuch | zuomge       | tcharge       |
    | 1     | F1     | !dontChange  | !dontChange   |
    | 2     | F2     | 10           | !dontChange   |
    | +3    | F3     | 10           | !dontChange   |
And I save the current editor
And I switch the current editor to editor "VKAUFP09"
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# Charge ist Pflichtangabe beim Buchen des VK-Lieferscheins
Given I open an editor "VKLSP09" from table "(Sales):(PackingSlip)" with command "UPDATE" for record "VKLS_P09"
And I set field "ueb" to "ja"
Then field "tcharge" is empty in row 1
# Charge im Vorgang und in MZ fehlt oder ist unvollständig, obwohl Chargenpflicht in Konfiguration und Artikel gesetzt ist.
Then saving the current editor throws the exception "1490"
And I press button "mzsubm" to open a subeditor for "Materialzuordnung" in row 1
And I modify table
    | !row  | tcharge   | ljtext1       |
    | 1     | 0909      | VKLS_P09_1    |
    | 2     | 0909      | VKLS_P09_2    |
    | 3     |           | VKLS_P09_3    |
And I save the current editor
And I switch the current editor to editor "VKLSP09"
# in einer Zeile der MZ fehlt die Chargenangabe
# Charge im Vorgang und in MZ fehlt oder ist unvollständig, obwohl Chargenpflicht in Konfiguration und Artikel gesetzt ist.
Then saving the current editor throws the exception "1490"
And I press button "mzsubm" to open a subeditor for "Materialzuordnung" in row 1
And I modify table
    | !row  | tcharge   |
    | 3     | 0909_1    |
And I save the current editor
And I switch the current editor to editor "VKLSP09"
And I save the current editor

# Charge ist Pflichtangabe beim Buchen der VK-Rechnung mit Lagerbewegung
Given I open an editor "VKREP09" from table "(Sales):(Invoice)" with command "UPDATE" for record "VKRE_P09"
And I set field "ueb" to "ja"
Then field "tcharge" is empty in row 1
# Charge im Vorgang und in MZ fehlt oder ist unvollständig, obwohl Chargenpflicht in Konfiguration und Artikel gesetzt ist.
Then saving the current editor throws the exception "1490"
And I press button "mzsubm" to open a subeditor for "Materialzuordnung" in row 1
And I modify table
    | !row  | tcharge   | ljtext1       |
    | 1     | 0909      | VKRE_P09_1    |
    | 2     | 0909      | VKRE_P09_2    |
    | 3     |           | VKRE_P09_3    |
And I save the current editor
And I switch the current editor to editor "VKREP09"
# in einer Zeile der MZ fehlt die Chargenangabe
# Charge im Vorgang und in MZ fehlt oder ist unvollständig, obwohl Chargenpflicht in Konfiguration und Artikel gesetzt ist.
Then saving the current editor throws the exception "1490"
And I press button "mzsubm" to open a subeditor for "Materialzuordnung" in row 1
And I modify table
    | !row  | tcharge   |
    | 3     | 0909_1    |
And I save the current editor
And I switch the current editor to editor "VKREP09"
And I save the current editor

Given I open an editor "JournalAb1" from table "(Journal):(Journal)" with command "VIEW" for record "$,,artikel==EK02_CHARGE;buarta==Abgang;platz==F1;erbtext1==VKLS_P09_1"
Then fields have values
    | artikel       | EK02_CHARGE           |
    | platz         | F1                    |
    | lgruppe       | KARLSRUHE             |
    | mge           | 30                    |
    | buart         | 2                     |
    | buarta        | Abgang                |
    | ursache       | Lieferschein          |
    | detursache    | Lieferschein Verkauf  |
Then field "tvcharge" has value "0909" in row 1
And I close the current editor

Given I open an editor "JournalAb2" from table "(Journal):(Journal)" with command "VIEW" for record "$,,artikel==EK02_CHARGE;buarta==Abgang;platz==F2;erbtext1==VKLS_P09_2"
Then fields have values
    | artikel       | EK02_CHARGE           |
    | platz         | F2                    |
    | lgruppe       | KARLSRUHE             |
    | mge           | 5                     |
    | buart         | 2                     |
    | buarta        | Abgang                |
    | ursache       | Lieferschein          |
    | detursache    | Lieferschein Verkauf  |
Then field "tvcharge" has value "0909" in row 1
And I close the current editor

Given I open an editor "JournalAb3" from table "(Journal):(Journal)" with command "VIEW" for record "$,,artikel==EK02_CHARGE;buarta==Abgang;platz==F3;erbtext1==VKLS_P09_3"
Then fields have values
    | artikel       | EK02_CHARGE           |
    | platz         | F3                    |
    | lgruppe       | KARLSRUHE             |
    | mge           | 5                     |
    | buart         | 2                     |
    | buarta        | Abgang                |
    | ursache       | Lieferschein          |
    | detursache    | Lieferschein Verkauf  |
Then field "tvcharge" has value "0909_1" in row 1
And I close the current editor

Given I open an editor "JournalAb4" from table "(Journal):(Journal)" with command "VIEW" for record "$,,artikel==EK02_CHARGE;buarta==Abgang;platz==F1;erbtext1==VKRE_P09_1"
Then fields have values
    | artikel       | EK02_CHARGE           |
    | platz         | F1                    |
    | lgruppe       | KARLSRUHE             |
    | mge           | 40                    |
    | buart         | 2                     |
    | buarta        | Abgang                |
    | ursache       | Rechnung              |
    | detursache    | Rechnung              |
Then field "tvcharge" has value "0909" in row 1
    And I close the current editor

Given I open an editor "JournalAb5" from table "(Journal):(Journal)" with command "VIEW" for record "$,,artikel==EK02_CHARGE;buarta==Abgang;platz==F2;erbtext1==VKRE_P09_2"
Then fields have values
    | artikel       | EK02_CHARGE           |
    | platz         | F2                    |
    | lgruppe       | KARLSRUHE             |
    | mge           | 10                    |
    | buart         | 2                     |
    | buarta        | Abgang                |
    | ursache       | Rechnung              |
    | detursache    | Rechnung              |
Then field "tvcharge" has value "0909" in row 1
And I close the current editor

Given I open an editor "JournalAb6" from table "(Journal):(Journal)" with command "VIEW" for record "$,,artikel==EK02_CHARGE;buarta==Abgang;platz==F3;erbtext1==VKRE_P09_3"
Then fields have values
    | artikel       | EK02_CHARGE           |
    | platz         | F3                    |
    | lgruppe       | KARLSRUHE             |
    | mge           | 10                    |
    | buart         | 2                     |
    | buarta        | Abgang                |
    | ursache       | Rechnung              |
    | detursache    | Rechnung              |
Then field "tvcharge" has value "0909_1" in row 1
And I close the current editor


Scenario: P12 Ruecklieferschein im EK nicht mit neuer Charge moeglich, ist auch ohne Charge moeglich

# neue Charge nicht moeglich, ohne Charge moeglich
Given I open an editor "EKRLS" from table "(Purchasing):(PackingSlip)" with command "RETURN" for record "LS1_P06"
And I set fields
    | such      | RLS1_P06  |
    | ebeleg    | RLS1_P06  |
    | ueb       | ja        |
Then table has values
    | artikel       | tcharge   |
    | EK01_CHARGE   | 0606      |
And I set field "mge" to "-1" in row 1
# Neue Charge wird nicht für Rücklieferung / Rückbau generiert.
#Then setting field "tcharge" to "12345" in row 1 throws the exception "7036"
## kann nicht abgefragt werden, da ACK anstatt NAK
And I set field "tcharge" to "12345" in row 1
# nach der Fehlermeldung wird das Feld geleert
Then field "tcharge" has value "0606" in row 1
# vorhandene, aber abweichende Charge geht auch nicht
And I set field "tcharge" to "0707" in row 1
# ohne Charge kann gebucht werden
And I set field "tcharge" to "" in row 1
And I save the current editor

# mit vorhandener Charge buchen
Given I open an editor "EKRLS" from table "(Purchasing):(PackingSlip)" with command "RETURN" for record "LS1_P06"
And I set fields
    | such      | RLS2_P06  |
    | ebeleg    | RLS2_P06  |
    | ueb       | ja        |
Then table has values
    | artikel       | tcharge   |
    | EK01_CHARGE   | 0606      |
And I set field "mge" to "-2" in row 1
And I save the current editor

Given I open an editor "JournalZu1" from table "(Journal):(Journal)" with command "VIEW" for record "$,,artikel==EK01_CHARGE;buarta==Zugang;platz==F1;ebeleg==RLS1_P06"
Then fields have values
    | artikel       | EK01_CHARGE           |
    | platz         | F1                    |
    | lgruppe       | KARLSRUHE             |
    | mge           | -1                    |
    | buart         | 1                     |
    | buarta        | Zugang                |
    | ursache       | Lieferschein          |
    | detursache    | Rücklieferung Einkauf |
# es wird die Charge aus dem vorher gebuchten Lieferschein genommen, zu dem die Rueckieferung erstellt wurde
Then field "tncharge" has value "0606" in row 1
And I close the current editor

Given I open an editor "JournalZu2" from table "(Journal):(Journal)" with command "VIEW" for record "$,,artikel==EK01_CHARGE;buarta==Zugang;platz==F1;ebeleg==RLS2_P06"
Then fields have values
    | artikel       | EK01_CHARGE           |
    | platz         | F1                    |
    | lgruppe       | KARLSRUHE             |
    | mge           | -2                    |
    | buart         | 1                     |
    | buarta        | Zugang                |
    | ursache       | Lieferschein          |
    | detursache    | Rücklieferung Einkauf |
Then field "tncharge" has value "0606" in row 1
And I close the current editor


Scenario: P13 Ruecklieferschein im VK nicht mit neuer Charge moeglich, ist auch ohne Charge moeglich

# neue Charge nicht moeglich, ohne Charge moeglich
Given I open an editor "VKRLS" from table "(Sales):(PackingSlip)" with command "RETURN" for record "VKLS_P07"
And I set fields
    | such      | RLS1_P07  |
    | ueb       | ja        |
Then table has values
    | artikel       | tcharge   |
    | EK01_CHARGE   | 0606      |
And I set field "mge" to "-1" in row 1
# Neue Charge wird nicht für Rücklieferung / Rückbau generiert.
#Then setting field "tcharge" to "12345" in row 1 throws the exception "7036"
    ## kann nicht abgefragt werden, da ACK anstatt NAK
And I set field "tcharge" to "12345" in row 1
# nach der Fehlermeldung wird die vorhandene Charge wieder eingetragen
Then field "tcharge" has value "0606" in row 1
And I set field "tcharge" to "" in row 1
And I set field "ljtext1" to "RLS1_P07" in row 1
And I save the current editor

# mit vorhandener Charge buchen
Given I open an editor "VKRLS" from table "(Sales):(PackingSlip)" with command "RETURN" for record "VKLS_P07"
And I set fields
    | such      | RLS2_P07  |
    | ueb       | ja        |
Then table has values
    | artikel       | tcharge   |
    | EK01_CHARGE   | 0606      |
And I set field "mge" to "-2" in row 1
And I set field "ljtext1" to "RLS2_P07" in row 1
And I save the current editor

Given I open an editor "JournalAb1" from table "(Journal):(Journal)" with command "VIEW" for record "$,,artikel==EK01_CHARGE;buarta==Abgang;platz==F3;mge==-1;erbtext1==RLS1_P07"
Then fields have values
    | artikel       | EK01_CHARGE           |
    | platz         | F3                    |
    | lgruppe       | KARLSRUHE             |
    | mge           | -1                    |
    | buart         | 2                     |
    | buarta        | Abgang                |
    | ursache       | Lieferschein          |
    | detursache    | Rücklieferung Verkauf |
# es wird die Charge aus dem vorher gebuchten Lieferschein genommen, zu dem die Ruecklieferung erstellt wurde
Then field "tvcharge" has value "0606" in row 1
And I close the current editor

Given I open an editor "JournalAb2" from table "(Journal):(Journal)" with command "VIEW" for record "$,,artikel==EK01_CHARGE;buarta==Abgang;platz==F3;mge==-2;erbtext1==RLS2_P07"
Then fields have values
    | artikel       | EK01_CHARGE           |
    | platz         | F3                    |
    | lgruppe       | KARLSRUHE             |
    | mge           | -2                    |
    | buart         | 2                     |
    | buarta        | Abgang                |
    | ursache       | Lieferschein          |
    | detursache    | Rücklieferung Verkauf |
Then field "tvcharge" has value "0606" in row 1
And I close the current editor


# Rücklieferschein und Storno auch ohne Charge möglich
# zubuchen und liefern ohne Charge, dann Chargenpflicht im Artikel einschalten, dann Bestand umbuchen auch Charge, dann Storno bzw. Rücklieferung
Scenario: P14 EK und VK - Ruecklieferschein oder Storno ist auch ohne Charge moeglich

Given I create a PurchaseOrder "EKBE1" for Vendor "TEST" with Product "NOCHARGE" and quantity "50"

And I deliver the PurchaseOrder "EKBE1" with PackingSlip "EKLS1"

Given I create a SalesOrder "AUF1" for Customer "TEST" with Product "NOCHARGE" and quantity "30"

And I deliver the SalesOrder "AUF1" with PackingSlip "VKLS1"

# Chargenpflicht im Artikel einschalten
Given I open an editor "NOCHARGE" from table "(Part):(Product)" with command "UPDATE" for record "NOCHARGE"
And I set field "chverfolgung" to "Chargenverfolgung"
And I set field "chimlager" to "ja"
And I save the current editor

# vorhandenen Bestand auf Charge umbuchen
Given I open an editor "Lagerbuchung" for tip command "(Stockadjustment)" and arguments ""
And I set fields
    | artikel   | NOCHARGE  |
    | buart     | Umbuchung |
    | beleg     | UM_Charge |
    | beldat    | .         |
And I delete all rows
And I append rows
    | mge    | platz    | platz2    | tcharge2  |
    | 20     | F1       | F1        | 1414      |
And I save the current editor

Given I open an editor "VKRLS" from table "(Sales):(PackingSlip)" with command "RETURN" for record "VKLS1"
And I set fields
    | such      | VKRLS_P14 |
    | ueb       | ja        |
And I set field "mge" to "-2" in row 1
Then field "charge" is empty in row 1
    And I set field "platz" to "F1" in row 1
And I save the current editor

Given I open an editor "STORNOVKRLS" from table "(Sales):(PackingSlip)" with command "REVERSAL" for record from editor "VKRLS"
And I save the current editor

Given I open an editor "STORNOVKLS" from table "(Sales):(PackingSlip)" with command "REVERSAL" for record "VKLS1"
And I save the current editor

Given I open an editor "EKRLS" from table "(Purchasing):(PackingSlip)" with command "RETURN" for record "EKLS1"
And I set fields
    | such      | RLS1_P14  |
    | ueb       | ja        |
And I set field "mge" to "-10" in row 1
Then field "charge" is empty in row 1
    And I set field "platz" to "F1" in row 1
And I save the current editor

Given I open an editor "STORNOEKRLS" from table "(Purchasing):(PackingSlip)" with command "REVERSAL" for record from editor "EKRLS"
And I save the current editor

Given I open an editor "STORNOEKLS" from table "(Purchasing):(PackingSlip)" with command "REVERSAL" for record "EKLS1"
And I save the current editor

Given I open an editor "JournalZu1" from table "(Journal):(Journal)" with command "VIEW" for record "$,,artikel==NOCHARGE;buarta==Zugang;platz==F1;detursache==Rücklieferung Einkauf"
Then fields have values
    | artikel       | NOCHARGE              |
    | platz         | F1                    |
    | lgruppe       | KARLSRUHE             |
    | mge           | -10                   |
    | buart         | 1                     |
    | buarta        | Zugang                |
    | ursache       | Lieferschein          |
    | detursache    | Rücklieferung Einkauf |
# Es gibt keine Chargenangabe und keine Tabellenzeilen
Then the table has 0 rows
And I close the current editor

Given I open an editor "JournalAb2" from table "(Journal):(Journal)" with command "VIEW" for record "$,,artikel==NOCHARGE;buarta==Zugang;platz==F1;detursache==Storno-Lieferung Einkauf"
Then fields have values
    | artikel       | NOCHARGE                  |
    | platz         | F1                        |
    | lgruppe       | KARLSRUHE                 |
    | mge           | -50                       |
    | buart         | 1                         |
    | buarta        | Zugang                    |
    | ursache       | Lieferschein              |
    | detursache    | Storno-Lieferung Einkauf  |
# Es gibt keine Chargenangabe und keine Tabellenzeilen
Then the table has 0 rows
And I close the current editor

Given I open an editor "JournalAb1" from table "(Journal):(Journal)" with command "VIEW" for record "$,,artikel==NOCHARGE;buarta==Abgang;platz==F1;detursache==Rücklieferung Verkauf"
Then fields have values
    | artikel       | NOCHARGE              |
    | platz         | F1                    |
    | lgruppe       | KARLSRUHE             |
    | mge           | -2                    |
    | buart         | 2                     |
    | buarta        | Abgang                |
    | ursache       | Lieferschein          |
    | detursache    | Rücklieferung Verkauf |
# Es gibt keine Chargenangabe und keine Tabellenzeilen
Then the table has 0 rows
And I close the current editor

Given I open an editor "JournalAb2" from table "(Journal):(Journal)" with command "VIEW" for record "$,,artikel==NOCHARGE;buarta==Abgang;platz==F1;detursache==Storno-Lieferung Verkauf"
Then fields have values
    | artikel       | NOCHARGE                  |
    | platz         | F1                        |
    | lgruppe       | KARLSRUHE                 |
    | mge           | -30                       |
    | buart         | 2                         |
    | buarta        | Abgang                    |
    | ursache       | Lieferschein              |
    | detursache    | Storno-Lieferung Verkauf  |
# Es gibt keine Chargenangabe und keine Tabellenzeilen
Then the table has 0 rows
And I close the current editor


Scenario: P15 Kundenanlieferung anlegen ohne Charge moeglich, buchen nur mit Charge

# Kundenanlieferung anlegen ohne Charge und noch nicht buchen
Given I open an editor "Kundenanliefer" from table "(Sales):(PackingSlip)" with command "NEW" for record ""
And I set fields
    | kunde | 1                 |
    | such  | KUNDEAN           |
    | lsart | Kundenanlieferung |
And I append rows
    | artikel       | mge  | preis |platz   |
    | EK-UMLAGER    | -10  | 5     |KONSI1  |
Then field "lsart" has value "Kundenanlieferung"
Then field "tcharge" is empty in row 1
And I save the current editor

# beim Buchen der Kundenanlieferung wird die Chargenpflicht geprüft
Given I open an editor "Kundenanliefer" from table "(Sales):(PackingSlip)" with command "UPDATE" for record "KUNDEAN"
Then field "tcharge" is empty in row 1
And I set field "ueb" to "ja"
# 1164 TX=de |Charge fehlt, obwohl Chargenpflicht in Konfiguration und Artikel markiert ist.
Then saving the current editor throws the exception "1164"
And I set field "tcharge" to "151515" in row 1
And I save the current editor

Given I open an editor "JournalZu1" from table "(Journal):(Journal)" with command "VIEW" for record "$,,artikel==EK-UMLAGER;buarta==Zugang;platz==KONSI1;detursache==Kundenanlieferung"
Then fields have values
    | artikel       | EK-UMLAGER            |
    | platz         | KONSI1                |
    | lgruppe       | KONSI                 |
    | mge           | 10                    |
    | buart         | 1                     |
    | buarta        | Zugang                |
    | ursache       | Lieferschein          |
    | detursache    | Kundenanlieferung     |
## soll das Feld zugehende Charge oder abgehende Charge gefüllt sein?
Then field "tncharge" has value "151515" in row 1
And I close the current editor


Scenario: P16 Umlagerungslieferschein im Verkauf anlegen ohne Charge moeglich, buchen nur mit Charge

Given I open an editor "VKLS-UMLAGER" from table "(Sales):(PackingSlip)" with command "NEW" for record ""
And I set fields
    | kunde | KUNDECH2          |
    | such  | VKLS-UML          |
Then field "umplatz" has value "KONSI2"
    And I append rows
    | artikel       | mge  |
    | EK-UMLAGER    | 20   |
Then field "tcharge" is empty in row 1
And I save the current editor

Given I open an editor "VKLS-UMLAGER" from table "(Sales):(PackingSlip)" with command "UPDATE" for record "VKLS-UML"
Then field "tcharge" is empty in row 1
And I set field "ueb" to "ja"
# 1164 TX=de |Charge fehlt, obwohl Chargenpflicht in Konfiguration und Artikel markiert ist.
Then saving the current editor throws the exception "1164"
And I set field "tcharge" to "161616" in row 1
And I save the current editor

Given I open an editor "JournalUmZu1" from table "(Journal):(Journal)" with command "VIEW" for record "$,,artikel==EK-UMLAGER;buarta==Zugang;platz==KONSI2"
Then fields have values
    | artikel       | EK-UMLAGER                        |
    | platz         | KONSI2                            |
    | lgruppe       | KONSI                             |
    | mge           | 20                                |
    | buart         | 1                                 |
    | buarta        | Zugang                            |
    | ursache       | Lieferschein                      |
    | detursache    | Kommissionslieferschein Verkauf   |
## soll beide Felder zugehende Charge und abgehende Charge gefüllt sein?
Then field "tncharge" has value "161616" in row 1
Then field "tvcharge" has value "161616" in row 1
And I close the current editor

Given I open an editor "JournalUmAb1" from table "(Journal):(Journal)" with command "VIEW" for record "$,,artikel==EK-UMLAGER;buarta==Abgang;platz==F1"
Then fields have values
    | artikel       | EK-UMLAGER                        |
    | platz         | F1                                |
    | lgruppe       | KARLSRUHE                         |
    | mge           | 20                                |
    | buart         | 2                                 |
    | buarta        | Abgang                            |
    | ursache       | Lieferschein                      |
    | detursache    | Kommissionslieferschein Verkauf   |
## soll beide Felder zugehende Charge und abgehende Charge gefüllt sein?
Then field "tncharge" has value "161616" in row 1
Then field "tvcharge" has value "161616" in row 1
And I close the current editor


Scenario: P17 Umlagerungsvorschlag

Given I open an editor "EK-UMLAGER" from table "(Part):(Product)" with command "UPDATE" for record "EK-UMLAGER"
And I press button "alge" to open a subeditor for "Lagergruppeneigenschaften"
And I delete all rows
And I append rows
    | lgruppe   | efrist    | mindest   | bsart     | dispoa            | zuplatz    | abplatz   | umllg        |
    | BERLIN    | 5         | 200       | Umlagern  | bedarfsbezogen    | L3F1       | L3F1      | KARLSRUHE    |
And I save the current subeditor to switch back to the parent editor
And I save the current editor

And I run Scheduling

# Umlagerungsvorschlag direkt umbuchen
Given I open an editor "UML_INT_EXT" from table "(Purchasing):(RelocationSuggestions)" with command "UPDATE" for record ""
And I set field "artikel" to "EK-UMLAGER"
And I set field "lgruppe" to ""
And I press button "ladetab"
Then the table has 1 rows
Then table has values
    | ablgruppe | lgruppe   | mge   | fix   |
    | KARLSRUHE | BERLIN    | 200   | nein  |
And I set field "mfreig" to "ja" in row 1
And I set field "beleg" to "UMLSP17"
And I set field "beldat" to "."
# 1164 TX=de |Charge fehlt, obwohl Chargenpflicht in Konfiguration und Artikel markiert ist.
Then pressing button "umbuchen" in row 0 to open a subeditor throws the exception "1164"
And I set field "tcharge" to "171717" in row 1
And I press button "umbuchen" to open a subeditor for "direktumbuchen"
And I save the current subeditor to switch back to the parent editor
And I close the current editor

Given I open an editor "JournalUmZu1" from table "(Journal):(Journal)" with command "VIEW" for record "$,,artikel==EK-UMLAGER;buarta==Zugang;platz==L3F1;such==LUMLSP17"
Then fields have values
    | artikel       | EK-UMLAGER            |
    | platz         | L3F1                  |
    | lgruppe       | BERLIN                |
    | mge           | 200                   |
    | buart         | 1                     |
    | buarta        | Zugang                |
    | ursache       | erfasst               |
    | detursache    | Umlagerungsvorschlag  |
Then field "tncharge" has value "171717" in row 1
Then field "tvcharge" has value "171717" in row 1
And I close the current editor

Given I open an editor "JournalUmAb1" from table "(Journal):(Journal)" with command "VIEW" for record "$,,artikel==EK-UMLAGER;buarta==Abgang;platz==F1;such==LUMLSP17"
Then fields have values
    | artikel       | EK-UMLAGER            |
    | platz         | F1                    |
    | lgruppe       | KARLSRUHE             |
    | mge           | 200                   |
    | buart         | 2                     |
    | buarta        | Abgang                |
    | ursache       | erfasst               |
    | detursache    | Umlagerungsvorschlag  |
Then field "tncharge" has value "171717" in row 1
Then field "tvcharge" has value "171717" in row 1
And I close the current editor






Scenario: P19 Inventur fuer Artikel mit Chargenpflicht, chimlager=ja und chimlager=nein

Given I post a receipt via ManualStockAdjustment "LBU01" for Product "INVCHIMLAGERNO" and quantity "20" on StorageLocation "F1" with document "LBU01"
Given I post a receipt via ManualStockAdjustment "LBU02" for Product "INVCHIMLAGERNO" and quantity "15" on StorageLocation "F2" with document "LBU02"
Given I post a receipt via ManualStockAdjustment "LBU03" for Product "INVCHIMLAGERYES" and quantity "20" on StorageLocation "F1" with document "LBU03"
Given I post a receipt via ManualStockAdjustment "LBU04" for Product "INVCHIMLAGERYES" and quantity "15" on StorageLocation "F2" with document "LBU04"

# Chargenpflicht einschalten bei beiden Artikeln
Given I open an editor "INVCHIMLAGERNO" from table "(Part):(Product)" with command "UPDATE" for record "INVCHIMLAGERNO"
And I set field "chverfolgung" to "Chargenverfolgung"
And I set field "chimlager" to "nein"
And I save the current editor

Given I open an editor "INVCHIMLAGERYES" from table "(Part):(Product)" with command "UPDATE" for record "INVCHIMLAGERYES"
And I set field "chverfolgung" to "Chargenverfolgung"
And I set field "chimlager" to "ja"
And I save the current editor

Given I open an editor "Lagerbuchung" for tip command "(Stockadjustment)" and arguments ""
And I set fields
    | artikel   | INVCHIMLAGERNO    |
    | buart     | Zugang            |
    | beleg     | LBU_05            |
    | beldat    | .                 |
    | wert      | 10.0000           |
And I delete all rows
And I append rows
    | mge    | platz2   | tcharge2  | verw      |
    | 10     | F1       | 191901    | verw01    |
    | 15     | F1       | 191901    | verw02    |
    | 20     | F2       | 191901    | verw01    |
    | 25     | F2       | 191901    | verw02    |
    | 10     | F1       | 191902    | verw01    |
    | 15     | F1       | 191902    | verw02    |
    | 20     | F2       | 191902    | verw01    |
    | 25     | F2       | 191902    | verw02    |
And I save the current editor

Given I open an editor "Lagerbuchung" for tip command "(Stockadjustment)" and arguments ""
And I set fields
    | artikel   | INVCHIMLAGERYES   |
    | buart     | Zugang            |
    | beleg     | LBU_06            |
    | beldat    | .                 |
    | wert      | 10.0000           |
And I delete all rows
And I append rows
    | mge    | platz2   | tcharge2  | verw      |
    | 10     | F1       | 191903    | verw03    |
    | 15     | F1       | 191903    | verw04    |
    | 20     | F2       | 191903    | verw03    |
    | 25     | F2       | 191903    | verw04    |
    | 10     | F1       | 191904    | verw03    |
    | 15     | F1       | 191904    | verw04    |
    | 20     | F2       | 191904    | verw03    |
    | 25     | F2       | 191904    | verw04    |
And I save the current editor

# Zaehlliste anlegen fuer INVCHIMLAGERNO und INVCHIMLAGERYES
Given I open an editor "Zaehlliste_CHARGE" from table "(Stocktaking):(EnterQuantitiesCounted)" with command "NEW" for record ""
And I set field "such" to "P19_CHARGE"
And I append rows
    | artikel           | platz |
    | INVCHIMLAGERYES   | F1    |
    | INVCHIMLAGERYES   | F2    |
    | INVCHIMLAGERNO    | F1    |
    | INVCHIMLAGERNO    | F2    |
And I save the current editor

# Zaehlliste pruefen
Given I open an editor "Zaehllistepruefen" from table "(Stocktaking):(EnterQuantitiesCounted)" with command "VIEW" for record "P19_CHARGE"
Then table has values
    | artikel            | tcharge   | verw     | platz    | gebeinh |
    | INVCHIMLAGERNO     |           |          | F2       | Stück   |
    | INVCHIMLAGERNO     |           | verw01   | F2       | Stück   |
    | INVCHIMLAGERNO     |           | verw02   | F2       | Stück   |
    | INVCHIMLAGERNO     |           |          | F1       | Stück   |
    | INVCHIMLAGERNO     |           | verw01   | F1       | Stück   |
    | INVCHIMLAGERNO     |           | verw02   | F1       | Stück   |
    | INVCHIMLAGERYES    |           |          | F2       | Stück   |
    | INVCHIMLAGERYES    | 191903    | verw03   | F2       | Stück   |
    | INVCHIMLAGERYES    | 191903    | verw04   | F2       | Stück   |
    | INVCHIMLAGERYES    | 191904    | verw03   | F2       | Stück   |
    | INVCHIMLAGERYES    | 191904    | verw04   | F2       | Stück   |
    | INVCHIMLAGERYES    |           |          | F1       | Stück   |
    | INVCHIMLAGERYES    | 191903    | verw03   | F1       | Stück   |
    | INVCHIMLAGERYES    | 191903    | verw04   | F1       | Stück   |
    | INVCHIMLAGERYES    | 191904    | verw03   | F1       | Stück   |
    | INVCHIMLAGERYES    | 191904    | verw04   | F1       | Stück   |
And I close the current editor

# Zaehlliste bearbeiten und Charge eintragen bei zwei Zeilen ohne Charge
Given I open an editor "Zaehllistepruefen" from table "(Stocktaking):(EnterQuantitiesCounted)" with command "UPDATE" for record "P19_CHARGE"
And I set field "tcharge" to "191901" in row 1
And I set field "tcharge" to "191903" in row 7
And I save the current editor

# Inventur eroeffnen
Given I open an editor "Invbearb" from table "(Stocktaking)" with command "RELEASE" for record "P19_CHARGE" and menu choice "Ja"
And I save the current editor

# Zaehlmengen erfassen und Fehlermeldungen pruefen
Given I open an editor "Invbearb" from table "(Stocktaking):(EnterQuantitiesCounted)" with command "UPDATE" for record "P19_CHARGE"
Then table has values
    | artikel            | tcharge   | verw     | platz    | gebeinh | ibest    |
    | INVCHIMLAGERNO     | 191901    |          | F2       | Stück   | 0        |
    | INVCHIMLAGERNO     |           | verw01   | F2       | Stück   | 40       |
    | INVCHIMLAGERNO     |           | verw02   | F2       | Stück   | 50       |
    | INVCHIMLAGERNO     |           |          | F1       | Stück   | 20       |
    | INVCHIMLAGERNO     |           | verw01   | F1       | Stück   | 20       |
    | INVCHIMLAGERNO     |           | verw02   | F1       | Stück   | 30       |
    | INVCHIMLAGERYES    | 191903    |          | F2       | Stück   | 0        |
    | INVCHIMLAGERYES    | 191903    | verw03   | F2       | Stück   | 20       |
    | INVCHIMLAGERYES    | 191903    | verw04   | F2       | Stück   | 25       |
    | INVCHIMLAGERYES    | 191904    | verw03   | F2       | Stück   | 20       |
    | INVCHIMLAGERYES    | 191904    | verw04   | F2       | Stück   | 25       |
    | INVCHIMLAGERYES    |           |          | F1       | Stück   | 20       |
    | INVCHIMLAGERYES    | 191903    | verw03   | F1       | Stück   | 10       |
    | INVCHIMLAGERYES    | 191903    | verw04   | F1       | Stück   | 15       |
    | INVCHIMLAGERYES    | 191904    | verw03   | F1       | Stück   | 10       |
    | INVCHIMLAGERYES    | 191904    | verw04   | F1       | Stück   | 15       |
    | INVCHIMLAGERNO     |           |          | F2       | Stück   | 15       |
    | INVCHIMLAGERYES    |           |          | F2       | Stück   | 15       |
And I modify table
    | !row | nbest |
    |  1   | 5     |
    |  2   | 10    |
    |  3   | 55    |
    |  4   | 20    |
    |  5   | 20    |
    |  6   | 32    |
    |  7   | 7     |
    |  8   | 15    |
    |  9   | 30    |
    | 10   | 25    |
    | 11   | 20    |
    | 12   | 22    |
    | 13   | 12    |
    | 14   | 20    |
    | 15   | 10    |
    | 16   | 14    |
    | 17   | 13    |
    | 18   | 16    |
Then saving the current editor throws the exception "1164"
# Charge erfassen in der vorhandenen Zeile geht nicht, da der vorhandene Bestand geladen ist
# wenn nbest = ibest, dann auch ohne Charge moeglich
And I set field "nbest" to "20" in row 12
# fuer Differenz eine neue Zeile erfassen, nur mit Charge moeglich
And I create a new row at the end of the table
And I set field "artikel" to "INVCHIMLAGERYES" in row !lastRow
And I set field "platz" to "F1" in row !lastRow
And I set field "tcharge" to "191903" in row !lastRow
And I set field "gebeinh" to "Stück" in row !lastRow
And I set field "gebf" to "1" in row !lastRow
And I set field "nbest" to "2" in row !lastRow
Then saving the current editor throws the exception "1164"
# wenn nbest kleiner als ibest, dann ohne Charge moeglich
And I set field "nbest" to "14" in row 18
# 1434 Zusätzlicher Bestand darf nur in neuer Zeile mit Charge gebucht werden, auch wenn Charge nicht im Lager geführt wird.
Then saving the current editor throws the exception "1434"
## Zeile 3 und 6 anpassen, nbest reduzieren und 1 neue Zeile mit 7
# fuer Artikel mit chimlager=nein darf nbest nur gleich oder kleiner als ibest sein, fuer zusaetzliche Menge muss neue Zeile mit Charge erfasst werden
And I set field "nbest" to "50" in row 3
And I set field "addmge" to "5" in row 3
And I set field "nbest" to "30" in row 6
Then saving the current editor throws the exception "1434"
And I set field "addmge" to "0" in row 3
And I create a new row at the end of the table
And I set field "artikel" to "INVCHIMLAGERNO" in row !lastRow
And I set field "platz" to "F2" in row !lastRow
And I set field "verw" to "verw02" in row !lastRow
And I set field "tcharge" to "191902" in row !lastRow
And I set field "gebeinh" to "Stück" in row !lastRow
And I set field "gebf" to "1" in row !lastRow
And I set field "nbest" to "7" in row !lastRow
And I save the current editor

# Bestandsabschluss PROJEKT, ACHARGE, EINHEIT
Given I open an editor "BestAbschluss" from table "(Stocktaking)" with command "DONE" for record "P19_CHARGE" and menu choice "Ja"
And I save the current editor

# Inventurkorrekturbuchungen im Infosystem LJ pruefen
And I open the infosystem "LJ"
And I set field "adatum" to "."
And I set field "kursache" to "Inventur"
And I set field "artikel" to "INVCHIMLAGERNO"
And I press start
Then table has values
    | kmge | mei    | verw     | tvcharge  | tncharge  | vplatz    |
    | 5    | Stück  |          |           | 191901    | F2        |
    | -30  | Stück  | verw01   |           |           | F2        |
    |      | Stück  | verw02   |           |           | F2        |
    |      | Stück  |          |           |           | F1        |
    |      | Stück  | verw01   |           |           | F1        |
    |      | Stück  | verw02   |           |           | F1        |
    | -2   | Stück  |          |           |           | F2        |
    | 7    | Stück  | verw02   |           | 191902    | F2        |
And I set field "artikel" to "INVCHIMLAGERYES"
And I press start
Then table has values
    | kmge | mei    | verw     | tvcharge  | tncharge  | vplatz    |
    | 7    | Stück  |          |           | 191903    | F2        |
    | -5   | Stück  | verw03   | 191903    |           | F2        |
    | 5    | Stück  | verw04   |           | 191903    | F2        |
    | 5    | Stück  | verw03   |           | 191904    | F2        |
    | -5   | Stück  | verw04   | 191904    |           | F2        |
    |      | Stück  |          |           |           | F1        |
    | 2    | Stück  | verw03   |           | 191903    | F1        |
    | 5    | Stück  | verw04   |           | 191903    | F1        |
    |      | Stück  | verw03   | 191904    | 191904    | F1        |
    | -1   | Stück  | verw04   | 191904    |           | F1        |
    | -1   | Stück  |          |           |           | F2        |
    | 2    | Stück  |          |           | 191903    | F1        |
And I close the current editor

# Inventurabschluss
Given I open an editor "Invbearb" from table "(Stocktaking)" with command "TRANSFER" for record "P19_CHARGE" and menu choice "Ja"
And I save the current editor


Scenario: P20 Inventur fuer Artikel ohne Chargenpflicht, vor Bestandsabschluss umstellen auf Chargenpflicht

Given I post a receipt via ManualStockAdjustment "LBU21" for Product "INVNOCHARGE" and quantity "10" on StorageLocation "F1" with document "LBU21"
Given I post a receipt via ManualStockAdjustment "LBU22" for Product "INVNOCHARGE" and quantity "20" on StorageLocation "F2" with document "LBU22"

# Zaehlliste anlegen und Inventur eroeffnen
Given I open an editor "Zaehlliste_CHARGE" from table "(Stocktaking):(EnterQuantitiesCounted)" with command "NEW" for record ""
And I set field "such" to "P20_CHARGE"
And I append rows
    | artikel       | platz |
    | INVNOCHARGE   | F1    |
    | INVNOCHARGE   | F2    |
And I save the current editor

Given I open an editor "Invbearb" from table "(Stocktaking)" with command "RELEASE" for record "P20_CHARGE" and menu choice "Ja"
And I save the current editor

# Zaehlmengen erfassen
Given I open an editor "Invbearb" from table "(Stocktaking):(EnterQuantitiesCounted)" with command "UPDATE" for record "P20_CHARGE"
Then table has values
    | artikel       | tcharge   | verw  | platz    | gebeinh | ibest    |
    | INVNOCHARGE   |           |       | F2       | Stück   | 20       |
    | INVNOCHARGE   |           |       | F1       | Stück   | 10       |
And I modify table
    | !row | nbest |
    |  1   | 25    |
    |  2   | 15    |
And I save the current editor

# Chargenpflicht einschalten
Given I open an editor "INVNOCHARGE" from table "(Part):(Product)" with command "UPDATE" for record "INVNOCHARGE"
And I set field "chverfolgung" to "Chargenverfolgung"
And I set field "chimlager" to "nein"
And I save the current editor

# Bestandsabschluss nicht moeglich, da Chargen fehlen
Given I open an editor "BestAbschluss" from table "(Stocktaking)" with command "DONE" for record "P20_CHARGE" and menu choice "Ja"
# 1463 TX=de |Chargen in Zeilen fehlen, Inventur muss erneut editiert werden. Bestandsabschluss nicht durchgeführt.
Then saving the current editor throws the exception "1463"
And I close the current editor

# Zaehlliste bearbeiten, nbest anpassen, kleiner oder gleich ibest ist moeglich ohne Charge
Given I open an editor "Invbearb" from table "(Stocktaking):(EnterQuantitiesCounted)" with command "UPDATE" for record "P20_CHARGE"
And I modify table
    | !row | nbest |
    |  1   | 19    |
    |  2   | 10    |
And I save the current editor

Given I open an editor "BestAbschluss" from table "(Stocktaking)" with command "DONE" for record "P20_CHARGE" and menu choice "Ja"
And I save the current editor

# Inventurkorrekturbuchungen im Infosystem LJ pruefen
And I open the infosystem "LJ"
And I set field "adatum" to "."
And I set field "kursache" to "Inventur"
And I set field "artikel" to "INVNOCHARGE"
And I press start
Then table has values
    | kmge | mei    | verw     | tvcharge  | tncharge  | vplatz    |
    | -1   | Stück  |          |           |           | F2        |
    |      | Stück  |          |           |           | F1        |
And I close the current editor

# Inventurabschluss
Given I open an editor "Invbearb" from table "(Stocktaking)" with command "TRANSFER" for record "P20_CHARGE" and menu choice "Ja"
And I save the current editor


Scenario: P21 Chargenpflicht bei Buchung von Setartikeln und Test der Icon

Given I open an editor "VKAUFP21" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set fields
    | kunde | KUNDECH1   |
    | such  | VKAUFP21   |
    | vom   | .          |
And I append rows
    | artikel       | mge | einplan |
    | SET-CHARGE    | 12  | ja      |
# Charge ist noch keine Pflichtangabe im VK-Auftrag
Then field "tcharge" is empty in row 1
And I save the current editor

Given I create a Lot "C21CHSET" for Product "SET-CHARGE"

Given I open an editor "VKAUFP21" from table "(Sales):(SalesOrder)" with command "DELIVERY" for record "VKAUFP21"
And I set fields
    | such   | VKLS_P21 |
    | vom    | .        |
    | ueb    | ja       |
And I set field "mge" to "10" in row 1
Then field "tcharge" is empty in row 1
Then field "chzuordnung" has value "icon:barcode_cross_red" in row 1
# 1164 TX=de |Charge fehlt, obwohl Chargenpflicht in Konfiguration und Artikel markiert ist.
Then saving the current editor throws the exception "1164"
And I set field "charge" to "!C21CHSET^id" in row 1
Then field "chzuordnung" has value "icon:barcode_exclamationmark_triangle_yellow" in row 1
# 10883 TX=de   |Charge für Beistellung oder Setartikel fehlt, obwohl Chargenpflicht in Konfiguration und Beistell-/Setartikel markiert ist.
Then saving the current editor throws the exception "10883"
And I set field "ueb" to "nein"
And I press button "mzabsm" to open a subeditor for "SetartikelMZ" in row 1
And I modify table
    | !row  | lpsuch | zuomge   | tcharge       |
    | +1    | F1     | 10       | C1SETKOMP1    |
And I press button for next product
And I modify table
    | !row  | lpsuch | zuomge   | tcharge       |
    | +1    | F1     | 20       | C2SETKOMP2    |
And I save the current editor
And I switch the current editor to editor "VKAUFP21"
Then field "chzuordnung" has value "icon:barcode_tick_green" in row 1
And I set field "ljtext1" to "VKLS_P21" in row 1
And I set field "ueb" to "ja"
And I save the current editor

Given I open an editor "VKAUFP21" from table "(Sales):(SalesOrder)" with command "VIEW" for record "VKAUFP21"
And I press button "absteig" to open a subeditor for "AFL" in row 1
And I save value from field "id" in row 1
And I close the current subeditor to switch back to the parent editor
And I close the current editor

Given I open an editor "chverfobjekt1" from table "(Lots):(LotTracking)" with command "VIEW" for search criteria "$,,ncharge^exnum==C21CHSET;vcharge^exnum==C1SETKOMP1;elex==SET_KOMP01_CH;"
Then field "reserv^id" in row 0 equals saved value
And I close the current editor

Given I open an editor "VKAUFP21" from table "(Sales):(SalesOrder)" with command "VIEW" for record "VKAUFP21"
And I press button "absteig" to open a subeditor for "AFL" in row 1
And I save value from field "id" in row 2
And I close the current subeditor to switch back to the parent editor
And I close the current editor

Given I open an editor "chverfobjekt2" from table "(Lots):(LotTracking)" with command "VIEW" for search criteria "$,,ncharge^exnum==C21CHSET;vcharge^exnum==C2SETKOMP2;elex==SET_KOMP02_CH;"
Then field "reserv^id" in row 0 equals saved value
And I close the current editor

Given I open an editor "VKAUFP21" from table "(Sales):(SalesOrder)" with command "DELIVERY" for record "VKAUFP21"
And I set fields
    | such   | VKLS2_P21    |
    | vom    | .            |
    | ueb    | nein         |
And I set field "mge" to "2" in row 1
And I set field "charge" to "!C21CHSET^id" in row 1
And I press button "mzabsm" to open a subeditor for "SetartikelMZ" in row 1
And I modify table
    | !row  | lpsuch | zuomge   | tcharge       |
    | +1    | F1     | 2        | C1SETKOMP1    |
And I press button for next product
And I modify table
    | !row  | lpsuch | zuomge   | tcharge       |
    | +1    | F1     | 4        | C2SETKOMP2    |
And I save the current editor
And I switch the current editor to editor "VKAUFP21"
And I set field "ljtext1" to "VKLS2_P21" in row 1
And I set field "ueb" to "ja"
And I save the current editor

Given I open an editor "JournalAb1" from table "(Journal):(Journal)" with command "VIEW" for record "$,,artikel==SET_KOMP01_CH;buarta==Abgang;platz==F1;erbtext1==VKLS_P21"
Then fields have values
    | artikel       | SET_KOMP01_CH         |
    | platz         | F1                    |
    | lgruppe       | KARLSRUHE             |
    | mge           | 10                    |
    | buart         | 2                     |
    | buarta        | Abgang                |
    | ursache       | Lieferschein          |
    | detursache    | Lieferschein Verkauf  |
Then field "tvcharge" has value "C1SETKOMP1" in row 1
Then field "ncharge^id" has value "!C21CHSET^id" in row 1
Then field "chverfobj^id" has value "!chverfobjekt1^id" in row 1
And I close the current editor

Given I open an editor "JournalAb2" from table "(Journal):(Journal)" with command "VIEW" for record "$,,artikel==SET_KOMP02_CH;buarta==Abgang;platz==F1;erbtext1==VKLS_P21"
Then fields have values
    | artikel       | SET_KOMP02_CH         |
    | platz         | F1                    |
    | lgruppe       | KARLSRUHE             |
    | mge           | 20                    |
    | buart         | 2                     |
    | buarta        | Abgang                |
    | ursache       | Lieferschein          |
    | detursache    | Lieferschein Verkauf  |
Then field "tvcharge" has value "C2SETKOMP2" in row 1
Then field "ncharge^id" has value "!C21CHSET^id" in row 1
Then field "chverfobj^id" has value "!chverfobjekt2^id" in row 1
And I close the current editor

Given I open an editor "JournalAb3" from table "(Journal):(Journal)" with command "VIEW" for record "$,,artikel==SET_KOMP01_CH;buarta==Abgang;platz==F1;erbtext1==VKLS2_P21"
Then fields have values
    | artikel       | SET_KOMP01_CH         |
    | platz         | F1                    |
    | lgruppe       | KARLSRUHE             |
    | mge           | 2                     |
    | buart         | 2                     |
    | buarta        | Abgang                |
    | ursache       | Lieferschein          |
    | detursache    | Lieferschein Verkauf  |
Then field "tvcharge" has value "C1SETKOMP1" in row 1
Then field "ncharge^id" has value "!C21CHSET^id" in row 1
Then field "chverfobj^id" has value "!chverfobjekt1^id" in row 1
And I close the current editor

Given I open an editor "JournalAb4" from table "(Journal):(Journal)" with command "VIEW" for record "$,,artikel==SET_KOMP02_CH;buarta==Abgang;platz==F1;erbtext1==VKLS2_P21"
Then fields have values
    | artikel       | SET_KOMP02_CH         |
    | platz         | F1                    |
    | lgruppe       | KARLSRUHE             |
    | mge           | 4                     |
    | buart         | 2                     |
    | buarta        | Abgang                |
    | ursache       | Lieferschein          |
    | detursache    | Lieferschein Verkauf  |
Then field "tvcharge" has value "C2SETKOMP2" in row 1
Then field "ncharge^id" has value "!C21CHSET^id" in row 1
Then field "chverfobj^id" has value "!chverfobjekt2^id" in row 1
And I close the current editor


Scenario: P22 Verwenden von Dummychargen im EK

Given I create a Lot "CH_P22" for Product "EK01_CHARGE"

Given I open an editor "EKBEP06" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set fields
    | lief | LIEFCHA1   |
    | such | EKBEP06    |
    | vom  | .          |
And I append rows
    | artikel       | mge | einplan |
    | EK01_CHARGE   | 100 | ja      |
And I set field "tcharge" to "CH_P22" in row 1
Then field "charge^id" has value "!CH_P22^id" in row 1
And I save the current editor



