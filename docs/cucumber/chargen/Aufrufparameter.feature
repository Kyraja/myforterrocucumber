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

Scenario: AP01 Aufrufparameter Tabellenfeld aus EK-Bestellung in die Charge uebernehmen, bereits vorhandene Charge verwenden

# Kopieraufrufparameter anpassen, tename in udi uebernehmen
Given I open an editor "EKBEPOS2CH" from table "(DataExport):(CallParameter)" with command "UPDATE" for record "EKBEPOS2CH"
And I append rows
    | zielaktion        | zielvar   | aufrwtyp      | aufrwert  |
    | Kopffeld setzen   | udi       | Tabellenfeld  | tename    |
And I save the current editor

Given I create a Lot "CH_AP01" for Product "EK01_CHARGE"

Given I open an editor "EKBE_AP01" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set fields
    | lief | LIEFCHA1   |
    | such | EKBE_AP01  |
    | vom  | .          |
And I append rows
    | artikel       | mge | einplan | charge        |
    | EK01_CHARGE   | 10  | ja      | !CH_AP01^id   |
And I save the current editor

Given I open an editor "CH_AP01" from table "(Lots):(Lots)" with command "VIEW" for record from editor "CH_AP01"
Then fields have values
    | exnum     | CH_AP01                   |
    | udi       | chargenpflichtiges Teil 1 |
    | lief^such | LIEFCHA1                  |
And I close the current editor


Scenario: AP02 Aufrufparameter Tabellenfeld aus VK-Auftrag in die ueber tcharge neu angelegte Charge uebernehmen

# Kopieraufrufparameter anpassen, tename in udi uebernehmen
Given I open an editor "VKAUPOS2CH" from table "(DataExport):(CallParameter)" with command "UPDATE" for record "VKAUPOS2CH"
And I append rows
    | zielaktion        | zielvar   | aufrwtyp      | aufrwert  |
    | Kopffeld setzen   | udi       | Tabellenfeld  | tename    |
And I save the current editor

Given I open an editor "AUF_AP02" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set fields
    | kunde | KUNDECH1   |
    | such  | AUF_AP02   |
    | vom   | .          |
And I append rows
    | artikel       | mge | einplan | tcharge   |
    | EK02_CHARGE   | 3   | ja      | CH_AP02   |
And I save the current editor

Given I open an editor "CH_AP02" from table "(Lots):(Lots)" with command "VIEW" for search criteria "$,,exnum=CH_AP02;@maxtreffer=1;@ablageart=lebendig"
Then fields have values
    | exnum | CH_AP02                   |
    | udi   | chargenpflichtiges Teil 2 |
    | lief  |                           |
And I close the current editor


Scenario: AP03 Aufrufparameter Tabellenfeld aus der MZ im VK-Auftrag in die ueber tcharge neu angelegte Charge uebernehmen

# Kopieraufrufparameter anpassen, verw in udi uebernehmen
Given I open an editor "MZ2CH" from table "(DataExport):(CallParameter)" with command "UPDATE" for record "MZ2CH"
And I append rows
    | zielaktion        | zielvar   | aufrwtyp      | aufrwert  |
    | Kopffeld setzen   | udi       | Tabellenfeld  | verw      |
And I save the current editor

Given I open an editor "AUF_AP03" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set fields
    | kunde | KUNDECH1   |
    | such  | AUF_AP03   |
    | vom   | .          |
And I append rows
    | artikel       | mge | einplan | verw          |
    | EK01_CHARGE   | 3   | ja      | VERW_AUF_AP03 |
And I press button "mzsubm" to open a subeditor for "Materialzuordnung" in row 1
And I modify table
    | !row  | lpsuch | zuomge | tcharge |
    | 1     | F1     | 2      | CH_AP03 |
    | +2    | F1     | 1      | CH123   |
And I save the current editor
And I switch the current editor to editor "AUF_AP03"
And I save the current editor

Given I open an editor "CH_AP03" from table "(Lots):(Lots)" with command "VIEW" for search criteria "$,,exnum=CH_AP03;@maxtreffer=1;@ablageart=lebendig"
Then fields have values
    | exnum | CH_AP03       |
    | udi   | VERW_AUF_AP03 |
    | lief  |               |
And I close the current editor


Scenario: AP04 Aufrufparameter Kopffeld aus manueller Lagerbuchung in die Charge uebernehmen, Dummycharge verwenden

# Kopieraufrufparameter anpassen, verw in udi uebernehmen
Given I open an editor "MLBUCH2CH" from table "(DataExport):(CallParameter)" with command "UPDATE" for record "MLBUCH2CH"
And I append rows
    | zielaktion        | zielvar   | aufrwtyp  | aufrwert  |
    | Kopffeld setzen   | udi       | Kopffeld  | verw      |
And I save the current editor

Given I open an editor "DUMMY_AP04" from table "(Lots):(Lots)" with command "NEW" for record ""
And I set fields
    | such      | DUMMY_AP04    |
    | exnum     | DUMMY_AP04    |
And I save the current editor

Given I open an editor "Lagerbuchung" for tip command "(Stockadjustment)" and arguments ""
And I set fields
    | artikel   | EK03_CHARGE   |
    | buart     | Zugang        |
    | beleg     | LBU_AP04      |
    | beldat    | .             |
    | verw      | VERW_LBU_AP04 |
And I delete all rows
And I append rows
    | mge    | platz2   | charge2           |
    | 1      | F1       | !DUMMY_AP04^id    |
And I save the current editor

Given I open an editor "DUMMY_AP04" from table "(Lots):(Lots)" with command "VIEW" for record from editor "DUMMY_AP04"
Then fields have values
    | exnum | DUMMY_AP04    |
    | udi   | VERW_LBU_AP04 |
    | lief  |               |
And I close the current editor


Scenario: AP05 Aufrufparameter Kopffeld aus Rueckmeldung in die ueber tcharge neu angelegte Charge uebernehmen

# Kopieraufrufparameter anpassen, verw in udi uebernehmen
Given I open an editor "RM2CH" from table "(DataExport):(CallParameter)" with command "UPDATE" for record "RM2CH"
And I append rows
    | zielaktion        | zielvar   | aufrwtyp  | aufrwert  |
    | Kopffeld setzen   | udi       | Kopffeld  | verw      |
And I save the current editor

# Fertigungsvorschlag anlegen mit Verwendung und freigeben
Given I open an editor "FV" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
And I append rows
    | artikel     | netmge | mfreig | verw           | bisuch |
    | BG01_CHARGE | 10     | ja     | VERW_RM_AP05   | AP05_  |
And I press button "freig" to open a subeditor for "BA_freigeben"
And I close the current editor
And I switch the current editor to editor "FV"
And I save the current editor

Given I open an editor "AP05" from table "(Workorder):(WorkOrders)" with command "UPDATE" for record "AP05_000"
And I press button "absteig" to open a subeditor for "AFL"
And I modify table
    | !row  | tcharge   |
    | 1     | AP05_AB1  |
    | 3     | AP05_AB2  |
And I save the current editor
And I switch the current editor to editor "AP05"
And I save the current editor

# Rueckmeldung Gesamtmenge auf Arbeitsschein 2
Given I open an editor "RM_AP05" from table "(Workorder):(WorkOrders)" with command "DONE" for search criteria "$,,such=AP05_002;@richtung=rückwärts;@maxordtreffer=1"
And I set fields
    | sofort    | ja            |
    | gut       | ja            |
    | tkcharge  | AP05_ZU       |
    | bem       | RM_AP05       |
Then field "verw" has value "VERW_RM_AP05"
And I set field "erbtext1" to "RM_AP05" in row 1
And I save the current editor

Given I open an editor "AP05_ZU" from table "(Lots):(Lots)" with command "VIEW" for search criteria "$,,exnum=AP05_ZU;@maxtreffer=1;@ablageart=lebendig"
Then fields have values
    | exnum | AP05_ZU       |
    | udi   | VERW_RM_AP05  |
And I close the current editor

Given I open an editor "AP05_AB1" from table "(Lots):(Lots)" with command "VIEW" for search criteria "$,,exnum=AP05_AB1;@maxtreffer=1;@ablageart=lebendig"
Then fields have values
    | exnum | AP05_AB1      |
    | udi   | VERW_RM_AP05  |
And I close the current editor

Given I open an editor "AP05_AB2" from table "(Lots):(Lots)" with command "VIEW" for search criteria "$,,exnum=AP05_AB2;@maxtreffer=1;@ablageart=lebendig"
Then fields have values
    | exnum | AP05_AB2      |
    | udi   | VERW_RM_AP05  |
And I close the current editor
