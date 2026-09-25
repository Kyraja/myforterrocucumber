@persistent
Feature: Inventur_Stammdaten.feature

# *****************************************************************************
#  Name             : Inventur_Stammdaten.feature
#  Autor            : bschiga/lschneider
#  Verantwortlich   : carue
#  Kontrolle        : drpf, ak
#  Funktion         : Stammdaten fuer Inventurtests anlegen
#
# *****************************************************************************

Background:
Given I set the fake date to "02.01.1995"
Given I enable the flag 39

Scenario: Projektkostenrechnung aktivieren
Given I open an editor "Konfiguration" from table "(Company):(Configuration)" with command "UPDATE" for record "0k"
And I set fields
    | projekt | ja |
And I save the current editor


Scenario: Inventurlager anlegen
Given I open an editor "Inv-Lager" from table "(Warehouse):(Warehouse)" with command "STORE" for record "INVENTUR"
And I set fields
    | such     | INVENTUR      |
    | namebspr | Inventurlager |
    | lgruppe  | KARLSRUHE     |
    | disporel | ja            |
    | lnullm   | ja            |
And I save the current editor

Scenario Outline: Inventur-Lagerplaetze anlegen
Given I open an editor "Inv-Lagerplatz" from table "(Location):(Location)" with command "STORE" for record "<such>"
And I set field "such" to "<such>"
And I set field "namebspr" to "<namebspr>"
And I set field "lager" to id from editor "Inv-Lager"
And I save the current editor

Examples: Inventur-Lagerplatz
    | such    | namebspr             |
    | LP_INV1 | Inventurlagerplatz 1 |
    | LP_INV2 | Inventurlagerplatz 2 |
    | LP_INV3 | Inventurlagerplatz 3 |
    | LP_INV4 | Inventurlagerplatz 4 |
    | LP_INV5 | Inventurlagerplatz 5 |
    | LP_INV6 | Inventurlagerplatz 6 |
    | LP_INV7 | Inventurlagerplatz 7 |
    | LP_INV8 | Inventurlagerplatz 8 |


Scenario Outline: Packmittel anlegen
Given I open an editor "artikel" from table "(Part):(Product)" with command "STORE" for record "<such>"
And I set fields
    | such     | <such>        |
    | namebspr | <namebspr>    |
    | packmit  | <packmit>     |
    | pmtyp    | <pmtyp>       |
    | vbezbspr | <vbezbspr>    |
And I save the current editor

Examples:
    | such      | namebspr  | packmit | pmtyp     | vbezbspr |
    | KLT       | KLT       | JA      | Behaelter | KLT      |
    | DE-KARTON | DE-KARTON | JA      | Behaelter | Karton   |


Scenario: Konsi-Lagerstruktur

Given I open an editor "K-Lagergruppe" from table "(Warehouse):(WarehouseGroup)" with command "STORE" for record "KLGRUPPE"
And I set fields
    | such     | KLGRUPPE         |
    | namebspr | Konsilagergruppe |
And I save the current editor

Given I open an editor "K-Lager" from table "(Warehouse):(Warehouse)" with command "STORE" for record "KLAGER"
And I set fields
    | such     | KLAGER     |
    | namebspr | Konsilager |
    | lgruppe  | KLGRUPPE   |
    | disporel | ja         |
And I save the current editor

Given I open an editor "K-Lagerplatz" from table "(Location):(Location)" with command "STORE" for record "KLPLATZ"
And I set fields
    | such     | KLPLATZ    |
    | namebspr | KonsiPlatz |
    | lager    | KLAGER     |
And I save the current editor

Given I open an editor "Lieferant" from table "(Vendor):(Vendor)" with command "STORE" for record "LOHNFERT"
And I set fields
    | such     | LOHNFERT     |
    | namebspr | Lohnfertiger |
    | konsi    | KLPLATZ      |
And I save the current editor


Scenario: Artikel

Given I open an editor "EKTEIL_3001" from table "(Part):(Product)" with command "STORE" for record "EKTEIL_3001"
And I set fields
    | such       | EKTEIL_3001      |
    | namebspr   | Einkaufsteil     |
    | bsart      | Fremdbeschaffung |
    | lief       | 1                |
    | efrist     | 2                |
    | epr        | 3                |
And I save the current editor

Given I open an editor "HALBF_3001" from table "(Part):(Product)" with command "STORE" for record "HALBF_3001"
And I set fields
    | such       | HALBF_3001       |
    | namebspr   | Halbfabrikat     |
    | bsart      | Eigenfertigung   |
    | dispoa     |                  |
And I press button "alge" to open a subeditor for "Lagergruppeneigenschaften"
And I delete all rows
And I append rows
    | lgruppe    | umllg            |
    | KLGRUPPE   | 1                |
And I save the current subeditor to switch back to the parent editor
And I save the current editor

Given I open an editor "LOHNFERT_3001" from table "(Part):(Product)" with command "STORE" for record "LOHNFERT_3001"
And I set fields
    | such       | LOHNFERT_3001   |
    | namebspr   | Lohnfertigung   |
    | bsart      | Lohnfertigung   |
    | lief       | LOHNFERT        |
    | efrist     | 2               |
    | epr        | 3               |
And I append rows
    | elex       | anzahl | bu                     |
    | HALBF_3001 |   1    | Lieferantenbeistellung |
And I save the current editor

Given I open an editor "BAUGRUPPE_3001" from table "(Part):(Product)" with command "STORE" for record "BAUGRUPPE_3001"
And I set fields
    | such        | BAUGRUPPE_3001  |
    | namebspr    | Testbaugruppe   |
    | bsart       | Eigenfertigung  |
And I append rows
    | elex        | anzahl | breite |
    | EKTEIL_3001 |   1    |   0    |
    | A 122       |   1    |   25   |
And I save the current editor

Given I open an editor "VERKAUF_3001" from table "(Part):(Product)" with command "STORE" for record "VERKAUF_3001"
And I set fields
    | such          | VERKAUF_3001     |
    | namebspr      | Verkaufsteil     |
    | bsart         | Eigenfertigung   |
And I append rows
    | elex           | anzahl | breite |
    | BAUGRUPPE_3001 |   1    |   0    |
    | A 121          |   1    |   0    |
    | LOHNFERT_3001  |   1    |   480  |
    | A 122          |   1    |   15   |
And I save the current editor

Given I open an editor "EINKAUF_3001" from table "(Part):(Product)" with command "STORE" for record "EINKAUF_3001"
And I set fields
    | such     | EINKAUF_3001     |
    | namebspr | Einkaufsteil     |
    | bsart    | Fremdbeschaffung |
    | dispoa   | bedarfsbezogen   |
And I save the current editor

Given I open an editor "MINDESTB_3001" from table "(Part):(Product)" with command "STORE" for record "MINDESTB_3001"
And I set fields
    | such     | MINDESTB_3001    |
    | namebspr | Mindestbestand   |
    | bsart    | Fremdbeschaffung |
    | dispoa   | auftragsbezogen  |
    | mindest  | 50               |
    | lief     | 1                |
    | efrist   | 2                |
    | epr      | 3                |
And I save the current editor

# Kaufteil m Gebindeeinheiten EINHEIT
Given I open an editor "EINHEIT_3001" from table "(Part):(Product)" with command "STORE" for record "EINHEIT_3001"
And I set fields
    | such     | EINHEIT_3001     |
    | namebspr | Einheit          |
    | bsart    | Fremdbeschaffung |
    | lief     | 1                |
    | efrist   | 2                |
    | epr      | 3                |
    | le       | m                |
    | vhe      | Stück            |
    | fvhle    | 2                |
    | gebvhe   | JA               |
    | vpe      | Stück            |
    | fvple    | 2                |
    | gebvpe   | JA               |
    | ehe      | kg               |
    | fehle    | 1                |
    | gebehe   | JA               |
    | epe      | kg               |
    | feple    | 1                |
    | gebepe   | JA               |
    | ve       | Stück            |
    | fvele    | 2                |
    | gebve    | JA               |
    | ge       | m                |
And I save the current editor

# auftragsbezogenes Kaufteil m Gebindeeinheiten AEINHEIT
Given I open an editor "AEINHEIT_3001" from table "(Part):(Product)" with command "STORE" for record "AEINHEIT_3001"
And I set fields
    | such     | AEINHEIT_3001    |
    | namebspr | Auftrag Einheit  |
    | bsart    | Fremdbeschaffung |
    | dispoa   | auftragsbezogen  |
    | lief     | 1                |
    | efrist   | 2                |
    | epr      | 3                |
    | le       | m                |
    | vhe      | Stück            |
    | fvhle    | 2                |
    | gebvhe   | JA               |
    | vpe      | Stück            |
    | fvple    | 2                |
    | gebvpe   | JA               |
    | ehe      | kg               |
    | fehle    | 1                |
    | gebehe   | JA               |
    | epe      | kg               |
    | feple    | 1                |
    | gebepe   | JA               |
    | ve       | Stück            |
    | fvele    | 2                |
    | gebve    | JA               |
    | ge       | m                |
And I save the current editor


Scenario Outline: Kaufteile ERWBEDARF, AUFTRAG, PROJEKT (bedarfsbezogen, auftragsbezogen, projektbezogen)
Given I open an editor "<such>" from table "(Part):(Product)" with command "STORE" for record "<such>"
And I set fields
    | such     | <such>           |
    | namebspr | <namebspr>       |
    | bsart    | Fremdbeschaffung |
    | dispoa   | <dispoa>         |
    | lief     | 1                |
    | efrist   | 2                |
    | epr      | 3                |
And I save the current editor

Examples: Kaufteile
    | such           | namebspr                 | dispoa                   |
    | ERWBEDARF_3001 | Erweitert Bedarfsbezogen | erweitert bedarfsbezogen |
    | AUFTRAG_3001   | Auftrag                  | auftragsbezogen          |
    | PROJEKT_3001   | Projekt                  | projektbezogen           |


Scenario Outline: Projekte
Given I open an editor "<such>" from table "(Transaction):(Project)" with command "STORE" for record "<such>"
And I set fields
    | such     | <such>           |
    | namebspr | <namebspr>       |
And I save the current editor

Examples: Projekte
    | such        | namebspr           |
    | TESTP_3001  | Testprojekt_3001   |
    | T2ESTP_3001 | Testprojekt 2_3001 |
    | T3ESTP_3001 | Testprojekt 3_3001 |


Scenario Outline: chargenpflichtige Artikel
Given I open an editor "<such>" from table "(Part):(Product)" with command "STORE" for record "<such>"
And I set fields
    | such         | <such>            |
    | namebspr     | <namebspr>        |
    | bsart        | Fremdbeschaffung  |
    | dispoa       | <dispoa>          |
    | chverfolgung | Chargenverfolgung |
    | chimlager    | ja                |
    | lief         | 1                 |
    | efrist       | 2                 |
    | epr          | 3                 |
And I save the current editor

Examples: Kaufteile
    | such           | namebspr         | dispoa            |
    | CHARGE_3001    | Charge           | bedarfsbezogen    |
    | ACHARGE_3001   | Charge Auftrag   | auftragsbezogen   |


Scenario Outline: Chargen anlegen
Given I open an editor "<such>" from table "(Lots):(Lots)" with command "STORE" for record "<such>"
And I set fields
    | such     | <such>           |
    | chname   | <chname>         |
    | exnum    | <exnum>          |
    | artikel  | <artikel>        |
    | lief     | <lief>           |
And I save the current editor

Examples: Chargen
    | such      | chname         | exnum       | artikel      | lief |
    | CH1_3001  | Charge 1_3001  | 887799_3001 | CHARGE_3001  | 1    |
    | CHA1_3001 | Charge A1_3001 | 89639_3001  | ACHARGE_3001 | 1    |
    | CHA2_3001 | Charge A2_3001 | 67zu99_3001 | ACHARGE_3001 | 1    |
