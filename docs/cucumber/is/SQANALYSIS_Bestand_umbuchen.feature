@persistent
Feature: SQANALYSIS_Bestand_umbuchen.feature

# *****************************************************************************
#  Name             : SQANALYSIS_Bestand_umbuchen.feature
#  Autor            : bschiga
#  Verantwortlich   : teaminfosysteme
#  Kontrolle        : bschiga
#  Funktion         : Testet IS SQANALYSIS Bestaende selektieren und umbuchen
#                     zu Vorgaengen fuer Entnahme oder Zugang
#  ref              : ref_la_sqanalysis_cu
# *****************************************************************************

Background:
Given I set the fake date to "01.03.95"

Scenario Outline: Lagerplaetze
Given I open an editor "<editor>" from table "<table>" with command "STORE" for record "<such>"
And I set fields
    | such     | <such>     |
    | namebspr | <namebspr> |
    | lager    | <lager>    |
    | abplatz  | ja         |
And I save the current editor

Examples: Lagerplaetze
    | editor     | table                 | such      | namebspr                         | lager |
    | Lagerplatz | (Location):(Location) | LP_ZU_1   | Neuer Zugangslagerplatz          | L1    |
    | Lagerplatz | (Location):(Location) | LP_AB_1   | Neuer Abgangslagerplatz          | L1    |


Scenario Outline: Artikel anlegen
Given I open an editor "<such>" from table "(Part):(Product)" with command "STORE" for record "<such>"
And I set fields
    | such         | <such>            |
    | namebspr     | <namebspr>        |
    | dispoa       | <dispoa>          |
    | zuplatz      | <zuplatz>         |
    | abplatz      | <abplatz>         |
And I save the current editor

Examples: Artikel
    | such            | namebspr                         | dispoa          | zuplatz    | abplatz   |
    | SQANA_1         | Artikel 1 SQANALYSIS             | auftragsbezogen | LP_ZU_1    | LP_AB_1   |
    | SQANA_2         | Artikel 2 SQANALYSIS             | auftragsbezogen | LP_ZU_1    | LP_AB_1   |
    | SQANA_ENTMAT_1  | Entnahmematerial SQANALYSIS      | auftragsbezogen | LP_ZU_1    | LP_AB_1   |
    | SETKOMP_SQA_1   | Setkomponente 1 SQANALYSIS       | auftragsbezogen | LP_ZU_1    | LP_AB_1   |
    | SETKOMP_SQA_2   | Setkomponente 2 SQANALYSIS       | auftragsbezogen | LP_ZU_1    | LP_AB_1   |


Scenario: Eigenfertigungsartikel und Setartikel anlegen

Given I open an editor "BG_SQANA" from table "(Part):(Product)" with command "STORE" for record "BG_SQANA"
And I set fields
    | such         | BG_SQANA               |
    | namebspr     | Baugruppe SQANALYSIS   |
    | dispoa       | auftragsbezogen        |
    | bsart        | Eigenfertigung         |
And I delete all rows
And I append rows
    | elex              | elanzahl |
    | SQANA_ENTMAT_1    | 1        |
    | A AG1             | 1        |
And I save the current editor

Given I open an editor "SET_SQANA" from table "(Part):(Product)" with command "STORE" for record "SET_SQANA"
And I set fields
    | such          | SET_SQANA             |
    | namebspr      | Setartikel SQANALYSIS |
    | earta         | über Stückliste       |
    | dispoa        | auftragsbezogen        |
And I delete all rows
And I append rows
    | elex          | elanzahl  |
    | SETKOMP_SQA_1 | 1         |
    | SETKOMP_SQA_2 | 2         |
And I save the current editor


Scenario: 01 Selektion nach Betriebsauftrag zeigt benoetigtes Material an, Teile werden umgebucht

#Given I set the fake date to "08.03.95"

Given I open an editor "Lagerbuchung" for tip command "(Stockadjustment)" and arguments ""
And I set fields
    | artikel   | SQANA_ENTMAT_1    |
    | buart     | Zugang            |
    | beleg     | LBU_SCEN01        |
    | beldat    | .                 |
    | wert      | 10.0000           |
And I delete all rows
And I append rows
    | mge    | platz2   | verw      |
    | 20     | LP_AB_1  | SCEN01    |
And I save the current editor

Given I create a work order "SCEN01A" for Product "BG_SQANA" with quantity "20" and search word "SCEN01A_"

Given I open an editor "RM1_SCEN01A" from table "(Workorder):(WorkOrders)" with command "DONE" for search criteria "$,,such=SCEN01A_001;@richtung=rückwärts;@maxordtreffer=1"
And I set fields
    | sofort    | ja            |
    | bem       | RM1_SCEN01    |
And I set field "gutmge" to "5" in row 1
And I save the current editor

Given I open the infosystem "SQANALYSIS"
And I set fields
    | ba        | SCEN01A_000    |
And I press start
Then table has values
    | gebmge    | tlplatzzu | tverw     |
    | -5        | LP_AB_1   |           |
    | 20        | LP_AB_1   | SCEN01    |
Then fields in table are modifiable
    | tmge  | tverwzu | tchargezu |
    | nein  | nein    | nein      |
    | ja    | ja      | ja        |
And I modify table
    | !row  | tmge  | tverwzu   |
    | 2     |  5    |           |
And I set field "tmark" to "ja" in row 2
And I press button "umbuch"
And I press start
Then table has values
    | gebmge    | tlplatzzu | tverw     |
    | 15        | LP_AB_1   | SCEN01    |
And I close the current editor

# BA loeschen, Material auf 0 setzen
Given I open an editor "Betriebsauftrag" from table "(Workorder):(WorkOrders)" with command "UPDATE" for record "SCEN01A_000"
And I respond with answer "JA" to the dialog with id "345"
And I set field "status" to "s"
And I save the current editor

Given I set StorageQuantity to zero for Product "SQANA_ENTMAT_1" on StorageLocation "LP_AB_1"


Scenario: 02 Selektion nach Auftrag zeigt benoetigtes Material an, Teile werden umgebucht

#Given I set the fake date to "09.03.95"

Given I open an editor "Lagerbuchung" for tip command "(Stockadjustment)" and arguments ""
And I set fields
    | artikel   | SQANA_1       |
    | buart     | Zugang        |
    | beleg     | LBU_SCEN01    |
    | beldat    | .             |
    | wert      | 10.0000       |
And I delete all rows
And I append rows
    | mge    | platz2   | verw          |
    | 30     | LP_AB_1  | LBU_SCEN02    |
And I save the current editor

Given I create a SalesOrder "Auftrag1" for Customer "TEST" with Product "SQANA_1" and quantity "20"

Given I open an editor "Auftrag1_LS" from table "(Sales):(SalesOrder)" with command "DELIVERY" for record from editor "Auftrag1"
And I set fields
    | such   | LS_SCEN02    |
    | vom    | .            |
    | ueb    | ja           |
And I set field "mge" to "5" in row 1
And I set field "verw" to "AUF1_SCEN02" in row 1
And I save the current editor

Given I open the infosystem "SQANALYSIS"
And I set fields
    | auftrag   | Auftrag1  |
And I press start
Then table has values
    | gebmge    | tlplatzzu | tverw         |
    | -5        | LP_AB_1   | AUF1_SCEN02   |
    | 30        | LP_AB_1   | LBU_SCEN02    |
And I modify table
    | tmge  | tverwzu       | !row  |
    | 5     | AUF1_SCEN02   | 2     |
And I set field "tmark" to "ja" in row 2
And I press button "umbuch"
And I press start
Then table has values
    | gebmge    | tlplatzzu | tverw         |
    | 25        | LP_AB_1   | LBU_SCEN02    |
And I close the current editor

# Auftrag liefern und Menge auf 0 setzen
And I deliver the SalesOrder "Auftrag1" with PackingSlip "Liefers1"
Given I set StorageQuantity to zero for Product "SQANA_1" on StorageLocation "LP_AB_1"


Scenario: 03 Setartikel - Selektion nach Auftrag zeigt benoetigtes Material an, Teile werden umgebucht

#Given I set the fake date to "09.03.95"

Given I open an editor "Lagerbuchung" for tip command "(Stockadjustment)" and arguments ""
And I set fields
    | artikel   | SETKOMP_SQA_1 |
    | buart     | Zugang        |
    | beleg     | LBU_SCEN03    |
    | beldat    | .             |
    | wert      | 10.0000       |
And I delete all rows
And I append rows
    | mge    | platz2   | verw          |
    | 15     | LP_AB_1  | LBU_SCEN03    |
And I save the current editor

Given I open an editor "Lagerbuchung" for tip command "(Stockadjustment)" and arguments ""
And I set fields
    | artikel   | SETKOMP_SQA_2 |
    | buart     | Zugang        |
    | beleg     | LBU2_SCEN03   |
    | beldat    | .             |
    | wert      | 10.0000       |
And I delete all rows
And I append rows
    | mge    | platz2   | verw          |
    | 20     | LP_AB_1  | LBU_SCEN03    |
And I save the current editor

Given I create a SalesOrder "AUF_SET" for Customer "TEST" with Product "SET_SQANA" and quantity "10"

Given I open an editor "AUF_SET_LS" from table "(Sales):(SalesOrder)" with command "DELIVERY" for record from editor "AUF_SET"
And I set fields
    | such   | LS_SCEN03    |
    | vom    | .            |
    | ueb    | ja           |
And I set field "mge" to "5" in row 1
And I set field "verw" to "AUF_SET_03" in row 1
And I save the current editor

Given I open the infosystem "SQANALYSIS"
And I set fields
    | auftrag   | AUF_SET   |
And I press start
Then table has values
    | gebmge    | tartikel      | tlplatzzu | tverw         |
    | -5        | SETKOMP_SQA_1 | LP_AB_1   | AUF_SET_03    |
    | 15        | SETKOMP_SQA_1 | LP_AB_1   | LBU_SCEN03    |
    | -10       | SETKOMP_SQA_2 | LP_AB_1   | AUF_SET_03    |
    | 20        | SETKOMP_SQA_2 | LP_AB_1   | LBU_SCEN03    |
And I modify table
    | !row  | tmge  | tverwzu       | tmark |
    | 2     | 5     | AUF_SET_03    | ja    |
    | 4     | 10    | AUF_SET_03    | ja    |
And I press button "umbuch"
And I press start
Then table has values
    | gebmge    | tartikel      | tlplatzzu | tverw         |
    | 10        | SETKOMP_SQA_1 | LP_AB_1   | LBU_SCEN03    |
    | 10        | SETKOMP_SQA_2 | LP_AB_1   | LBU_SCEN03    |
And I close the current editor

# Auftrag liefern und Menge auf 0 setzen
And I deliver the SalesOrder "AUF_SET" with PackingSlip "LS4"
Given I set StorageQuantity to zero for Product "SETKOMP_SQA_1" on StorageLocation "LP_AB_1"
Given I set StorageQuantity to zero for Product "SETKOMP_SQA_2" on StorageLocation "LP_AB_1"


Scenario: 04 Selektion fuer Zugang aus Betriebsauftrag zeigt Bestaende aus diesem Zugang

#Given I set the fake date to "08.03.95"

Given I open an editor "Lagerbuchung" for tip command "(Stockadjustment)" and arguments ""
And I set fields
    | artikel   | BG_SQANA      |
    | buart     | Zugang        |
    | beleg     | LBU_ZU_SC04   |
    | beldat    | .             |
    | wert      | 10.0000       |
And I delete all rows
And I append rows
    | mge    | platz2   | verw          |
    | 2      | LP_ZU_1  | LBUZU_SCEN04  |
And I save the current editor

Given I open an editor "Lagerbuchung" for tip command "(Stockadjustment)" and arguments ""
And I set fields
    | artikel   | BG_SQANA      |
    | buart     | Abgang        |
    | beleg     | LBU_AB_SC04   |
    | beldat    | .             |
And I delete all rows
And I append rows
    | mge    | platz    | verw          |
    | 2      | LP_AB_1  | LBUAB_SCEN04  |
And I save the current editor

# Fertigungsvorschlag anlegen und freigeben
Given I open an editor "FV" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
And I append rows
    | artikel   | netmge | bisuch    | verw         | mfreig |
    | BG_SQANA  | 10     | SCEN04_   | RM_SCEN04    | ja     |
And I press button "freig" to open a subeditor for "BA_freigeben"
And I close the current subeditor to switch back to the parent editor
And I close the current editor

Given I open an editor "RM1_SCEN04" from table "(Workorder):(WorkOrders)" with command "DONE" for search criteria "$,,such=SCEN04_001;@richtung=rückwärts;@maxordtreffer=1"
And I set fields
    | sofort    | ja            |
    | bem       | RM1_SCEN04    |
And I set field "gutmge" to "5" in row 1
And I save the current editor

Given I open an editor "RM2_SCEN04" from table "(Workorder):(WorkOrders)" with command "DONE" for search criteria "$,,such=SCEN04_001;@richtung=rückwärts;@maxordtreffer=1"
And I set fields
    | sofort    | ja            |
    | bem       | RM2_SCEN04    |
And I set field "gutmge" to "1" in row 1
And I save the current editor

Given I open the infosystem "SQANALYSIS"
And I set fields
    | fertigung | 1002  |
And I press start
# nur die Zugaenge zu diesem Betriebsauftrag werden angezeigt, nicht alle Bestaende
Then the table has 2 rows
Then table has values
    | gebmge    | tlplatzzu | tverw         |
    | 5         | F1        | RM_SCEN04     |
    | 1         | F1        | RM_SCEN04     |
And I set fields
    | artikel   | BG_SQANA      |
    | fertigung |               |
    | behaelter |               |
And I press start
Then the table has 5 rows
And I close the current editor

# BA loeschen, Material auf 0 setzen
Given I open an editor "Betriebsauftrag" from table "(Workorder):(WorkOrders)" with command "UPDATE" for record "SCEN04_000"
And I respond with answer "JA" to the dialog with id "345"
And I set field "status" to "s"
And I save the current editor


Scenario: 05 Selektion fuer Zugang aus Einkaufsvorgang zeigt Bestaende aus diesem Zugang

#Given I set the fake date to "08.03.95"

Given I open an editor "Lagerbuchung" for tip command "(Stockadjustment)" and arguments ""
And I set fields
    | artikel   | SQANA_2       |
    | buart     | Zugang        |
    | beleg     | LBU_ZU_SC05   |
    | beldat    | .             |
    | wert      | 10.0000       |
And I delete all rows
And I append rows
    | mge    | platz2   | verw          |
    | 2      | LP_ZU_1  | LBUZU_SCEN05  |
And I save the current editor

Given I open an editor "BE_SCEN05" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set fields
    | lief | TEST       |
    | such | BE_SCEN05  |
    | vom  | .          |
And I append rows
    | artikel   | mge | einplan | verw          |
    | SQANA_2   | 3   | ja      | EKLS_SCEN05   |
And I save the current editor

And I deliver the PurchaseOrder "BE_SCEN05" with PackingSlip "LS_SCEN05"

Given I open the infosystem "SQANALYSIS"
And I set fields
    | kzugang | LS_SCEN05   |
And I press start
# nur die Zugaenge zu diesem EInakufsvorgang werden angezeigt, nicht alle Bestaende
Then the table has 1 rows
Then table has values
    | gebmge    | tlplatzzu | tverw         |
    | 3         | LP_ZU_1   | EKLS_SCEN05   |
And I set fields
    | artikel   | SQANA_2   |
    | kzugang   |           |
And I press start
Then the table has 2 rows
Then table has values
    | gebmge    | tlplatzzu | tverw         |
    | 2         | LP_ZU_1   | LBUZU_SCEN05  |
    | 3         | LP_ZU_1   | EKLS_SCEN05   |
And I close the current editor

Given I set StorageQuantity to zero for Product "SQANA_2" on StorageLocation "LP_ZU_1"


Scenario: 06 Ordner auf- und zuklappen bei Ueberdeckung, Bestand mit Verwendung aber auf zwei Plaetzen

# Bestand aus Scenario 04 verwenden und weiteren Bestand auf anderen Lagerplatz zubuchen, um Ueberdeckung zu erzeugen
Given I open an editor "Lagerbuchung" for tip command "(Stockadjustment)" and arguments ""
And I set fields
    | artikel   | BG_SQANA      |
    | buart     | Zugang        |
    | beleg     | LBU_ZU_SC04   |
    | beldat    | .             |
    | wert      | 10.0000       |
And I delete all rows
And I append rows
    | mge    | platz2   | verw          |
    | 2      | F1       | LBUZU_SCEN04  |
And I save the current editor

# Dispo muss laufen, um Ueberdeckung zu ermitteln
And I run Scheduling

Given I open the infosystem "SQANALYSIS"
And I set fields
    | behaelter | nein      |
    | ueberd    | ja        |
And I press start
Then the table has 2 rows
Then field "taufklappen" has value "icon:folder_closed" in row 1
And I press button "taufklappen" in row 1
Then the table has 4 rows
Then field "taufklappen" has value "icon:folder_opened" in row 1
Then table has values
    | aufgeklappt   | gebmge    | tlplatzzu | tverw         |
    | nein          | 4         |           | LBUZU_SCEN04  |
    | ja            | 2         | F1        | LBUZU_SCEN04  |
    | ja            | 2         | LP_ZU_1   | LBUZU_SCEN04  |
    | nein          | 6         | F1        | RM_SCEN04     |
And I press button "taufklappen" in row 1
Then the table has 2 rows
Then field "taufklappen" has value "icon:folder_closed" in row 1
Then table has values
    | aufgeklappt   | gebmge    | tlplatzzu | tverw         |
    | nein          | 4         |           | LBUZU_SCEN04  |
    | nein          | 6         | F1        | RM_SCEN04     |
And I close the current editor
