@persistent
Feature: Dispo_vorlauf_in_umlagerung.feature

Background:
And I set the fake date to "02.01.95"

# **********************************************************************************
#  Name             : Dispo_vorlauf_in_umlagerung.feature
#  Autor            : lbettendorf
#  Verantwortlich   : bheim
#  Kontrolle        : drpf
#  Funktion         : Testet Umlagerungseigenschaften
#  ref              : ref_dispo_misc_cu
#
# **********************************************************************************
# verwendete Stammdaten: basis_stammdaten.feature

Scenario: Vorlauf im Umlagerungsvorschlag

# Zulaessiger Rueckstand in Betriebsdaten auf 0 setzen
Given I open an editor "KonfigurationDisposition" from table "(SchedulingConfiguration):(CompanySchedConfig)" with command "STORE" for record "1"
And I set field "rueckstand" to "0"
And I save the current editor

# Umlagerungseigenschaften in externer Lagergruppe setzen: Vorlauf 30 Tage
Given I open an editor "BERLIN" from table "(Warehouse):(WarehouseGroup)" with command "UPDATE" for record "BERLIN"
And I press button "umleig" to open a subeditor for "Umlagerungseigenschaften"
And I delete all rows
And I append rows
    | lgziel    | tlzeit    | tlzeiteinh    | spedit    |
    | KARLSRUHE | 30        | Kalendertage  | 002       |
And I save the current subeditor to switch back to the parent editor
And I save the current editor

# Parameter in Artikel EK-LAGERGRUPPE anpassen
Given I open an editor "EK-LAGERGRUPPE" from table "(Part):(Product)" with command "STORE" for record "EK-LAGERGRUPPE"
And I set fields
    | bsart     | Umlagern  |
    | umllg     | BERLIN    |
    | lief      |           |
    | efrist    | 0         |
And I save the current editor

# Auftrag fuer EK-LAGERGRUPPE
Given I open an editor "Auftrag" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set field "kunde" to "KUNDE1"
And I append rows
    | artikel           | mge   |
    | EK-LAGERGRUPPE    | 10    |
And I save the current editor
And I run Scheduling

# Termine im Umlagerungsvorschlag pruefen und Vorschlag freigeben
Given I open an editor "umlv" from table "(Purchasing):(RelocationSuggestions)" with command "UPDATE" for record ""
And I set field "artikel" to "EK-LAGERGRUPPE"
And I press button "ladetab"
#Then table has values
#    | wtsterm   | wtterm    | wtfterm   |
#    | 02.01.95  | 01.02.95  |           |
And I set field "mfreig" to "ja" in row 1
And I press button "freig" to open a subeditor for "Bestellung"
And I save the current subeditor to switch back to the parent editor
And I save the current editor

# am naechsten Tag darf auch kein fruehster Termin gesetzt sein
And I set the fake date to "15.01.95"
And I run Scheduling

Given I switch the current editor to editor "Auftrag" with command "VIEW"
Then table has values
    | wtsterm   | wtterm    | wtfterm   |
    | 01.02.95  | 01.02.95  | 01.02.95  |
And I close the current editor


Scenario: Lieferant im Umlagerungsvorschlag wird aus Artikel-Lagergruppeneigenschaften uebernommen

# Umlagerungseigenschaften in externer Lagergruppe setzen, unterschiedlicher Lieferant und Vorlauf
Given I open an editor "KARLSRUHE" from table "(Warehouse):(WarehouseGroup)" with command "UPDATE" for record "KARLSRUHE"
And I press button "umleig" to open a subeditor for "Umlagerungseigenschaften"
And I delete all rows
And I append rows
    | lgziel    | tlzeit    | tlzeiteinh    | spedit    | mittel    |
    | HONGKONG  | 2         | Kalendertage  | 001       | Flugzeug  |
    | HONGKONG  | 30        | Kalendertage  | 002       | Schiff    |
And I save the current subeditor to switch back to the parent editor
And I save the current editor

# Lagergruppeneigenschaften im Artikel anpassen und Lieferant eintragen
Given I open an editor "UML_HK_002" from table "(Part):(Product)" with command "STORE" for record "UML_HK_002"
And I set fields
    | such      | UML_HK_002        |
    | bsart     | Fremdbeschaffung  |
    | lief      | TEST              |
    | efrist    | 0                 |
And I press button "alge" to open a subeditor for "Lagergruppeneigenschaften"
And I delete all rows
And I append rows
  | lgruppe     | dispoa            | bsart     | umllg     | lief  | mindest   | vorlauf   |
  | HONGKONG    | bedarfsbezogen    | Umlagern  | KARLSRUHE | 002   | 50        | 35        |
And I save the current subeditor to switch back to the parent editor
And I save the current editor

And I run Scheduling

# Termine und Lieferant im Umlagerungsvorschlag pruefen, vorlauf ist in Arbeitstagen, tlzeit in Kalendertagen, deshalb vorlauf 21
Given I open an editor "umlvor" from table "(Purchasing):(RelocationSuggestions)" with command "VIEW" for record ""
And I set field "artikel" to "UML_HK_002"
And I press button "ladetab"
Then table has values
    | lief  | vorlauf   | wtsterm   | wtterm    |
    | 002   | 21        | 02.01.95  | 01.02.95  |
And I close the current editor


Scenario: Plausi Umlagerungseigenschaften unterscheiden sich in Lieferant, Uebergangszeit oder Transportmittel

# Umlagerungseigenschaften in externer Lagergruppe setzen, unterschiedlicher Lieferant und Vorlauf
Given I open an editor "KARLSRUHE" from table "(Warehouse):(WarehouseGroup)" with command "UPDATE" for record "KARLSRUHE"
And I press button "umleig" to open a subeditor for "Umlagerungseigenschaften"
And I delete all rows
And I append rows
    | lgziel    | tlzeit    | tlzeiteinh    | spedit    | mittel    |
    | HONGKONG  | 2         | Kalendertage  | 001       | Flugzeug  |
    | HONGKONG  | 2         | Kalendertage  | 001       | Flugzeug  |
# 985 Für eine Ziellagergruppe müssen die Eigenschaften Spediteur, Übergangszeit oder Mittel sich unterscheiden.
Then saving the current editor throws the exception "985"
And I set field "mittel" to "Schiff" in row 2
And I save the current subeditor to switch back to the parent editor
And I save the current editor

Given I open an editor "KARLSRUHE" from table "(Warehouse):(WarehouseGroup)" with command "UPDATE" for record "KARLSRUHE"
And I press button "umleig" to open a subeditor for "Umlagerungseigenschaften"
And I set field "mittel" to "Flugzeug" in row 2
Then saving the current editor throws the exception "985"
And I set field "tlzeit" to "25" in row 2
And I save the current subeditor to switch back to the parent editor
And I save the current editor

Given I open an editor "KARLSRUHE" from table "(Warehouse):(WarehouseGroup)" with command "UPDATE" for record "KARLSRUHE"
And I press button "umleig" to open a subeditor for "Umlagerungseigenschaften"
And I set field "tlzeit" to "2" in row 2
Then saving the current editor throws the exception "985"
And I set field "spedit" to "002" in row 2
And I save the current subeditor to switch back to the parent editor
And I save the current editor


Scenario: Kundenbeistellung ueber Umlagerung aus externer Lagergruppe beschaffen

# Artikel fuer Kundenbeistellung anlegen mit Lagergruppeneigenschaften
Given I open an editor "KD_BEISTELL" from table "(Part):(Product)" with command "STORE" for record "KD_BEISTELL"
And I set fields
    | such      | KD_BEISTELL       |
    | dispoa    | auftragsbezogen   |
And I press button "alge" to open a subeditor for "Lagergruppeneigenschaften"
And I delete all rows
And I append rows
    | lgruppe | dispoa            | bsart             |
    | KONSI   | auftragsbezogen   | Eigenfertigung    |
And I save the current subeditor to switch back to the parent editor
And I set fields
    | umllg     | KONSI     |
    | bsart     | Umlagern  |
And I save the current editor

Given I open an editor "BG_BEISTELL" from table "(Part):(Product)" with command "STORE" for record "BG_BEISTELL"
And I set fields
    | such      | BG_BEISTELL       |
    | bsart     | Eigenfertigung    |
    | dispoa    | auftragsbezogen   |
And I delete all rows
And I append rows
    | elex          | lge | breite | anzahl    |
    | EINK          |     |        | 1         |
    | KD_BEISTELL   |     |        | 2         |
    | A AG2         | 20  | 15     | 1         |
And I set field "bua" to "Kundenbeistellung" in row 2
And I save the current editor

Given I create a SalesOrder "AUF_BG" for Customer "KUNDE1" with Product "BG_BEISTELL" and quantity "25"

And I run Scheduling

# es ist ein Umlagerungsvorschlag entstanden fuer das Beistell-Material
Given I open an editor "umlvor" from table "(Purchasing):(RelocationSuggestions)" with command "VIEW" for record ""
And I set field "artikel" to "KD_BEISTELL"
And I press button "ladetab"
Then table has values
    | mge       | ablgruppe | lgruppe   |
    | 50        | KONSI     | KARLSRUHE |
And I close the current editor

# in der Lagergruppe KONSI ist ein BV erstellt worden, immer Fremdbeschaffung fuer Kundenbeistellung, auch wenn der Artikel in der Lagergruppe Eigenfertigung hat
Given I open an editor "BV" from table "(Purchasing):(PurchaseOrderSuggestions)" with command "VIEW" for record ""
And I set field "artikel" to "KD_BEISTELL"
And I set field "lgruppe" to "KONSI"
And I press button "ladetab"
Then table has values
    | mge       |
    | 50        |
And I close the current editor


Scenario: Kundenbeistellung wird in Bedarfslagergruppe immer fremdbeschafft, wenn nicht Umlagern im Artikel hinterlegt ist

# Artikel fuer Kundenbeistellung anlegen mit Eigenfertigung
Given I open an editor "KD_BEISTELL_F" from table "(Part):(Product)" with command "STORE" for record "KD_BEISTELL_F"
And I set fields
    | such      | KD_BEISTELL_F     |
    | dispoa    | auftragsbezogen   |
    | bsart     | Eigenfertigung    |
And I save the current editor

Given I open an editor "BG_BEISTELL_F" from table "(Part):(Product)" with command "STORE" for record "BG_BEISTELL_F"
And I set fields
    | such      | BG_BEISTELL_F     |
    | bsart     | Eigenfertigung    |
    | dispoa    | auftragsbezogen   |
And I delete all rows
And I append rows
    | elex          | lge | breite | anzahl    |
    | EINK          |     |        | 1         |
    | KD_BEISTELL_F |     |        | 2         |
    | A AG2         | 20  | 15     | 1         |
And I set field "bua" to "Kundenbeistellung" in row 2
And I save the current editor

Given I create a SalesOrder "AUF_BG_F" for Customer "KUNDE1" with Product "BG_BEISTELL_F" and quantity "25"

And I run Scheduling

# es ist ein Bestellvorschlag entstanden fuer das Beistell-Material
Given I open an editor "BV" from table "(Purchasing):(PurchaseOrderSuggestions)" with command "VIEW" for record ""
And I set field "artikel" to "KD_BEISTELL_F"
And I press button "ladetab"
Then table has values
    | mge       | lgruppe   |
    | 50        | KARLSRUHE |
And I close the current editor


Scenario: Bedarf der nicht aus einer Kundenbeistellung wird mit der Beschaffungsart beschafft, die im Beistell-Artikel hinterlegt ist

# Mindestbestand fuer Beistell-Artikel eintragen
Given I open an editor "KD_BEISTELL_F" from table "(Part):(Product)" with command "UPDATE" for record "KD_BEISTELL_F"
And I set fields
    | mindest   | 10    |
And I save the current editor

And I run Scheduling

# es ist ein Fertigungsvorschlag entstanden fuer den Bedarf des Beistell-Artikels, der NICHT aus einer AFL mit Kundenbeistellung stammt
Given I open an editor "FV" from table "(Purchasing):(WorkOrderSuggestions)" with command "VIEW" for record ""
And I set field "artikel" to "KD_BEISTELL_F"
And I press button "ladetab"
Then table has values
    | mge       | lgruppe   |
    | 10        | KARLSRUHE |
And I close the current editor


Scenario: CompanySchedConfig - An-und Abschalten der permanenten Dispo ueber die Dispokonfiguration

Given I open an editor "KonfigurationDisposition" from table "(SchedulingConfiguration):(CompanySchedConfig)" with command "UPDATE" for record "1"
And I set fields
    | pdispointervall   | 30    |
And I press button "pdispoan"
Then field "pdispostatus" has value "ja"
And I save the current editor

Given I open an editor "KonfigurationDisposition" from table "(SchedulingConfiguration):(CompanySchedConfig)" with command "UPDATE" for record "1"
Then field "pdispostatus" has value "ja"
And I press button "pdispoaus"
Then field "pdispostatus" has value "nein"
And I save the current editor
