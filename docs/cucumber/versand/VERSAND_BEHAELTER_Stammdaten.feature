@persistent
Feature: VERSAND_BEHAELTER_Stammdaten.feature

# *****************************************************************************
#  Name             : VERSAND_BEHAELTER_Stammdaten.feature
#  Autor            : lschneider
#  Verantwortlich   : carue
#  Kontrolle        : drpf
#  Funktion         : Legt Stammdaten fuer die Behaeltertests an
#  ref              : ref_behaelter_stammdaten_cu
#
# *****************************************************************************

Background:
Given I set the fake date to "02.01.1995"


#Scenario: Behaelter und Behaelterkonten aktivieren
#
#Given I open an editor "Konfiguration" from table "(Company):(Configuration)" with command "UPDATE" for record "0k"
#And I set field "behaelter" to "ja"
#And I set field "bman" to "ja"
#And I save the current editor


Scenario Outline: Packmittel

Given I open an editor "<such>" from table "(Part):(Product)" with command "STORE" for record "<such>"
And I set fields
  | such      | <such>      |
  | namebspr  | <namebspr>  |
  | packmit   | ja          |
  | pmtyp     | <pmtyp>     |
  | dispoa    | <dispoa>    |
  | earta     | <earta>     |
And I save the current editor

Examples:
| such      | namebspr          | pmtyp     | dispoa        | earta	        |
| KLT       | KLT               | Behaelter | !dontChange   | !dontChange   |
| SPALETTE  | Palette Standard  | Palette   | !dontChange   | !dontChange   |
| SKARTON   | KARTON Standard   | Behaelter | !dontChange   | !dontChange   |
| SDECKEL   | DECKEL Standard   | Deckel    | !dontChange   | !dontChange   |
| VTASCHE   | VERSANDTASCHE     | Behaelter | rest          | keine         |
| DE-KARTON | DE-KARTON         | Behaelter | !dontChange   | !dontChange   |


Scenario: Packanweisung PACKA1, einstufig

Given I open an editor "Packanweisung" from table "(PackingInstructions):(PackingInstructions)" with command "STORE" for record "PACKA1"
And I set field "such" to "PACKA1"
And I delete all rows
And I append rows
  | artikel   | anzahl    | ebene   | minebene    | auffuell  |
  | KLT       | 4         | 1       | 1           | nein      |
And I save the current editor


Scenario: Packanweisung PACKA2, zweistufig

Given I open an editor "Packanweisung" from table "(PackingInstructions):(PackingInstructions)" with command "STORE" for record "PACKA2"
And I set field "such" to "PACKA2"
And I delete all rows
And I append rows
  | artikel   | anzahl    | ebene   | minebene    | auffuell  |
  | KLT       | 4         | 1       | 1           | ja        |
  | SPALETTE  | 1         | 1       | 1           | ja        |
And I save the current editor


Scenario Outline: Struktur Konsilagerplatz

Given I open an editor "<suchlg>" from table "(Warehouse):(WarehouseGroup)" with command "STORE" for record "<suchlg>"
And I set fields
  | such      | <suchlg>    |
  | zkonsilg  | <zkonsilg>  |
And I save the current editor

Given I open an editor "<suchl>" from table "(Warehouse):(Warehouse)" with command "STORE" for record "<suchl>"
And I set fields
  | such      | <suchl>     |
  | lgruppe   | <lgruppe>   |
  | disporel  | <disporel>  |
And I save the current editor

Given I open an editor "<suchlp>" from table "(Location):(Location)" with command "STORE" for record "<suchlp>"
And I set fields
  | such    | <suchlp>  |
  | lager   | <lager>   |
And I save the current editor

Examples:
  | suchlg   | zkonsilg   | suchl      | lgruppe | disporel  | suchlp  | lager       |
  | KONSILG  | ja         | KONSILAGER | KONSILG | nein      | KONSILP | KONSILAGER  |
  | LOHNF    | nein       | LOHNF      | LOHNF   | ja        | LOHNF   | LOHNF       |


Scenario Outline: Lieferanten und Kunde

Given I open an editor "<such>" from table "<database>" with command "STORE" for record "<such>"
And I set fields
    | such      | <such>        |
    | namebspr  | <namebspr>    |
    | zbed      | 201           |
    | konsi     | <konsi>       |
And I save the current editor

Examples:
| such      | database                | namebspr                | konsi       |
| KETTLER   | (Vendor):(Vendor)       | Kettler Fahrrad         | !dontChange |
| PUKY      | (Vendor):(Vendor)       | PUKY Fahrrad            | !dontChange |
| LOHNFERT  | (Vendor):(Vendor)       | Lohnfertiger            | LOHNF       |
| RADSHOP   | (Customer):(Customer)   | Radshop Maier, Rastatt  | !dontChange |


Scenario Outline: Kundenkontakte Kettler-Werk und RADSHOP-Werk

Given I open an editor "<such>" from table "<database>" with command "STORE" for record "<such>"
And I set fields
    | firma     | <firma>       |
    | such      | <such>        |
    | namebspr  | <namebspr>    |
    | werk      | <werk>        |
    | ablstelle | <ablstelle>   |
And I save the current editor

Examples:
  | such      | firma    | namebspr      | werk        | ablstelle | database                      |
  | WKETTLER  | !KETTLER | Werk Kettler  | WERKKETTLER | AABL      | (Vendor):(VendorContact)      |
  | WRADSHOP  | !RADSHOP | Werk Radshop  | Rastatt     | 15        | (Customer):(CustomerContact)  |


Scenario Outline: Behaelterkonto Geschaeftspartner KETTLER und RADSHOP

Given I open an editor "Behaelterkonto" from table "(ContainerAccount):(ContainerAccount)" with command "STORE" for record "<such>"
And I set fields
    | such       | <such>               |
    | name       | <name>               |
    | ktofuehr   | (BusinessPartner)    |
    | artikel    | KLT                  |
    | partner    | <partner>            |
    | werk       | <werk>               |
And I save the current editor

Examples:
  | such       | name                       | partner    | werk        |
  | KNTKETTLER | Behaelterkonto Fa. Kettler | L KETTLER  | WERKKETTLER |
  | KNTRADSHOP | Behaelterkonto Fa. Radshop | K WRADSHOP | !dontChange |


Scenario Outline: Einkaufsartikel

Given I open an editor "<such>" from table "(Part):(Product)" with command "STORE" for record "<such>"
And I set fields
  | such              | <such>              |
  | namebspr          | <namebspr>          |
  | dispoa            | <dispoa>            |
  | packanwstdla      | <packanwstdla>      |
  | fmengestdla       | 10                  |
  | packanwstdversand | <packanwstdversand> |
  | fmengestdversand  | 10                  |
  | lief              | <lief>              |
  | efrist            | <efrist>            |
  | epr               | <epr>               |
  | epe1              | <epe1>              |
  | lief2             | PUKY                |
  | efrist2           | <efrist2>           |
  | epr2              | <epr2>              |
  | epe2              | <epe2>              |
  | chverfolgung      | <chverfolgung>      |
  | chimlager         | <chimlager>         |
  | vzaehlen          | <vzaehlen>          |
  | gebvhe            | <gebvhe>            |
  | fvhe              | <fvhe>              |
  | vhe               | <vhe>               |
  | fvhle             | <fvhle>             |
  | le                | <le>                |
  | gebvpe            | <gebvpe>            |
  | fvpe              | <fvpe>              |
  | vpe               | <vpe>               |
  | fvple             | <fvple>             |
  | gebehe            | <gebehe>            |
  | fehe              | <fehe>              |
  | ehe               | <ehe>               |
  | fehle             | <fehle>             |
  | gebepe            | <gebepe>            |
  | fepe              | <fepe>              |
  | epe               | <epe>               |
  | feple             | <feple>             |
  | gebve             | <gebve>             |
  | fve               | <fve>               |
  | ve                | <ve>                |
  | fvele             | <fvele>             |
  | gebge             | <gebge>             |
  | fge               | <fge>               |
  | ge                | <ge>                |
And I save the current editor

Examples:
  | such            | namebspr                          | dispoa                    | packanwstdla | packanwstdversand | lief     | efrist | epr | epe1        | efrist2 | epr2 | epe2        | chverfolgung      | chimlager   | vzaehlen | gebvhe | fvhe | vhe         | fvhle  | le          | gebvpe | fvpe | vpe         | fvple | gebehe | fehe | ehe         | fehle | gebepe | fepe | epe         | feple | gebve | fve | ve          | fvele  | gebge | fge | ge          |
  | RAHMEN          | Rahmen fuer Fahrrad               | !dontChange               | PACKA1       | PACKA1            | KETTLER  | 2      | 100 | kg          | 2       | 120  | kg          | Chargenverfolgung | ja          |          | JA     | 5    | kg          | 1      | !dontChange | JA     | 5    | kg          | 1     | JA     | 5    | kg          | 1     | JA     | 5    | kg          | 1     | JA    | 5   | kg          | 1      | JA    | 5   | kg          |
  | RAD             | Rad fuer Fahrrad                  | !dontChange               | PACKA2       | PACKA2            | KETTLER  | 2      | 60  | Paar        | 2       | 70   | Paar        | Chargenverfolgung | ja          |          |        | 1    | Paar        | 2      | !dontChange |        | 1    | Paar        | 2     |        | 1    | Paar        | 2     |        | 1    | Paar        | 2     |       | 1   | Paar        | 2      |       | 1   | Paar        |
  | SATTEL          | Sattel fuer Fahrrad               | auftragsbezogen           | PACKA1       | PACKA2            | KETTLER  | 1      | 10  | !dontChange | 1       | 15   | !dontChange | Chargenverfolgung | ja          |          |        | 1    | !dontChange | 1      | !dontChange |        | 1    | !dontChange | 1     |        | 1    | !dontChange | 1     |        | 1    | !dontChange | 1     |       | 1   | !dontChange | 1      |       | 1   | !dontChange |
  | PEDALE          | Pedale fuer Fahrrad               | auftragsbezogen           | PACKA1       | PACKA1            | KETTLER  | 1      | 8   | !dontChange | 1       | 9,50 | !dontChange | Chargenverfolgung | ja          |          |        | 1    | Paar        | 2      | !dontChange |        | 1    | Paar        | 2     |        | 1    | Paar        | 2     |        | 1    | Paar        | 2     |       | 1   | Paar        | 2      |       | 1   | Paar        |
  | SCHUHE          | Schuhe mit gebpflicht             | auftragsbezogen           | PACKA1       | PACKA1            | KETTLER  | 1      | 8   | !dontChange | 1       | 9,50 | !dontChange | Chargenverfolgung | ja          |          | JA     | 1    | Paar        | 2      | !dontChange | JA     | 1    | Paar        | 2     | JA     | 1    | Paar        | 2     | JA     | 1    | Paar        | 2     | JA    | 1   | Paar        | 2      | JA    | 1   | Paar        |
  | EKTEIL_1010     | Einkaufsteil                      | bedarfsbezogen            |              |                   | 1        | 2      | 3   | !dontChange |         |      | !dontChange |                   |             |          |        | 1    | !dontChange | 1      | !dontChange |        | 1    | !dontChange | 1     |        | 1    | !dontChange | 1     |        | 1    | !dontChange | 1     |       | 1   | !dontChange | 1      |       | 1   | !dontChange |
  | ERWBEDARF_1010  | Erweitert Bedarfsbezogen          | erweitert bedarfsbezogen  |              |                   | 1        | 2      | 3   | !dontChange |         |      | !dontChange |                   |             |          |        | 1    | !dontChange | 1      | !dontChange |        | 1    | !dontChange | 1     |        | 1    | !dontChange | 1     |        | 1    | !dontChange | 1     |       | 1   | !dontChange | 1      |       | 1   | !dontChange |
  | AUFTRAG_1010    | Auftrag                           | auftragsbezogen           |              |                   | 1        | 2      | 3   | !dontChange |         |      | !dontChange |                   |             |          |        | 1    | !dontChange | 1      | !dontChange |        | 1    | !dontChange | 1     |        | 1    | !dontChange | 1     |        | 1    | !dontChange | 1     |       | 1   | !dontChange | 1      |       | 1   | !dontChange |
  | PROJEKT_1010    | Projekt                           | projektbezogen            |              |                   | 1        | 2      | 3   | !dontChange |         |      | !dontChange |                   |             |          |        | 1    | !dontChange | 1      | !dontChange |        | 1    | !dontChange | 1     |        | 1    | !dontChange | 1     |        | 1    | !dontChange | 1     |       | 1   | !dontChange | 1      |       | 1   | !dontChange |
  | EKTEIL_3000     | Einkaufsteil                      | bedarfsbezogen            |              |                   | 1        | 2      | 3   | !dontChange |         |      | !dontChange |                   |             |          |        | 1    | !dontChange | 1      | !dontChange |        | 1    | !dontChange | 1     |        | 1    | !dontChange | 1     |        | 1    | !dontChange | 1     |       | 1   | !dontChange | 1      |       | 1   | !dontChange |
  | ERWBEDARF_3000  | Erweitert Bedarfsbezogen          | erweitert bedarfsbezogen  |              |                   | 1        | 2      | 3   | !dontChange |         |      | !dontChange |                   |             |          |        | 1    | !dontChange | 1      | !dontChange |        | 1    | !dontChange | 1     |        | 1    | !dontChange | 1     |        | 1    | !dontChange | 1     |       | 1   | !dontChange | 1      |       | 1   | !dontChange |
  | AUFTRAG_3000    | Auftrag3                          | auftragsbezogen           |              |                   | 1        | 2      | 3   | !dontChange |         |      | !dontChange |                   |             |          |        | 1    | !dontChange | 1      | !dontChange |        | 1    | !dontChange | 1     |        | 1    | !dontChange | 1     |        | 1    | !dontChange | 1     |       | 1   | !dontChange | 1      |       | 1   | !dontChange |
  | PROJEKT_3000    | Projekt3                          | projektbezogen            |              |                   | 1        | 2      | 3   | !dontChange |         |      | !dontChange |                   |             |          |        | 1    | !dontChange | 1      | !dontChange |        | 1    | !dontChange | 1     |        | 1    | !dontChange | 1     |        | 1    | !dontChange | 1     |       | 1   | !dontChange | 1      |       | 1   | !dontChange |
  | AUFT-V_1024     | AuftragV                          | auftragsbezogen           |              |                   | 1        | 2      | 3   | !dontChange |         |      | !dontChange |                   |             |          |        | 1    | !dontChange | 1      | !dontChange |        | 1    | !dontChange | 1     |        | 1    | !dontChange | 1     |        | 1    | !dontChange | 1     |       | 1   | !dontChange | 1      |       | 1   | !dontChange |
  | PROJEKT_3000    | ProjektV                          | projektbezogen            |              |                   | 1        | 2      | 3   | !dontChange |         |      | !dontChange |                   |             |          |        | 1    | !dontChange | 1      | !dontChange |        | 1    | !dontChange | 1     |        | 1    | !dontChange | 1     |        | 1    | !dontChange | 1     |       | 1   | !dontChange | 1      |       | 1   | !dontChange |
  | EKTEIL_9999     | Einkaufsteil                      | bedarfsbezogen            |              |                   | 1        | 2      | 3   | !dontChange |         |      | !dontChange |                   |             |          |        | 1    | !dontChange | 1      | !dontChange |        | 1    | !dontChange | 1     |        | 1    | !dontChange | 1     |        | 1    | !dontChange | 1     |       | 1   | !dontChange | 1      |       | 1   | !dontChange |
  | AUFT-V_1024     | AuftragV                          | auftragsbezogen           |              |                   | 1        | 2      | 3   | !dontChange |         |      | !dontChange |                   | nein        | ja       |        | 1    | !dontChange | 1      | !dontChange |        | 1    | !dontChange | 1     |        | 1    | !dontChange | 1     |        | 1    | !dontChange | 1     |       | 1   | !dontChange | 1      |       | 1   | !dontChange |
  | PROJ-V_1024     | ProjektV                          | projektbezogen            |              |                   | 1        | 2      | 3   | !dontChange |         |      | !dontChange |                   | nein        | ja       |        | 1    | !dontChange | 1      | !dontChange |        | 1    | !dontChange | 1     |        | 1    | !dontChange | 1     |        | 1    | !dontChange | 1     |       | 1   | !dontChange | 1      |       | 1   | !dontChange |
  | ACH-V_1024      | auftragsbez. Charge               | auftragsbezogen           |              |                   | 1        | 2      | 3   | !dontChange |         |      | !dontChange | Chargenverfolgung | ja          | ja       |        | 1    | !dontChange | 1      | !dontChange |        | 1    | !dontChange | 1     |        | 1    | !dontChange | 1     |        | 1    | !dontChange | 1     |       | 1   | !dontChange | 1      |       | 1   | !dontChange |
  | BED-V-B_1014    | Bedarfsbezogen                    | !dontChange               |              |                   | 1        | 2      | 3   | !dontChange |         |      | !dontChange |                   | nein        | ja       |        | 1    | !dontChange | 1      | !dontChange |        | 1    | !dontChange | 1     |        | 1    | !dontChange | 1     |        | 1    | !dontChange | 1     |       | 1   | !dontChange | 1      |       | 1   | !dontChange |
  | AUFT-V-B_1014   | Auftrag                           | auftragsbezogen           |              |                   | 1        | 2      | 3   | !dontChange |         |      | !dontChange |                   | nein        | ja       |        | 1    | !dontChange | 1      | !dontChange |        | 1    | !dontChange | 1     |        | 1    | !dontChange | 1     |        | 1    | !dontChange | 1     |       | 1   | !dontChange | 1      |       | 1   | !dontChange |
  | PROJ-V-B_1014   | Projekt                           | projektbezogen            |              |                   | 1        | 2      | 3   | !dontChange |         |      | !dontChange |                   | nein        | ja       |        | 1    | !dontChange | 1      | !dontChange |        | 1    | !dontChange | 1     |        | 1    | !dontChange | 1     |        | 1    | !dontChange | 1     |       | 1   | !dontChange | 1      |       | 1   | !dontChange |
  | EINK-V-B_1014   | Einkaufsteil                      | !dontChange               |              |                   | 1        | 2      | 3   | !dontChange |         |      | !dontChange |                   | nein        | ja       |        | 1    | !dontChange | 1      | !dontChange |        | 1    | !dontChange | 1     |        | 1    | !dontChange | 1     |        | 1    | !dontChange | 1     |       | 1   | !dontChange | 1      |       | 1   | !dontChange |
  | ACH-V-B_1014    | auftragsbez. Charge               | auftragsbezogen           |              |                   | 1        | 2      | 3   | !dontChange |         |      | !dontChange | Chargenverfolgung | ja          | ja       |        | 1    | !dontChange | 1      | !dontChange |        | 1    | !dontChange | 1     |        | 1    | !dontChange | 1     |        | 1    | !dontChange | 1     |       | 1   | !dontChange | 1      |       | 1   | !dontChange |
  | CHARGE_1010     | Charge                            | bedarfsbezogen            |              |                   | 1        | 2      | 3   | !dontChange |         |      | !dontChange | Chargenverfolgung | ja          |          |        | 1    | !dontChange | 1      | !dontChange |        | 1    | !dontChange | 1     |        | 1    | !dontChange | 1     |        | 1    | !dontChange | 1     |       | 1   | !dontChange | 1      |       | 1   | !dontChange |
  | ACHARGE_1010    | Charge Auftrag                    | auftragsbezogen           |              |                   | 1        | 2      | 3   | !dontChange |         |      | !dontChange | Chargenverfolgung | ja          |          |        | 1    | !dontChange | 1      | !dontChange |        | 1    | !dontChange | 1     |        | 1    | !dontChange | 1     |        | 1    | !dontChange | 1     |       | 1   | !dontChange | 1      |       | 1   | !dontChange |
  | CHARGE_3000     | Charge                            | bedarfsbezogen            |              |                   | 1        | 2      | 3   | !dontChange |         |      | !dontChange | Chargenverfolgung | ja          |          |        | 1    | !dontChange | 1      | !dontChange |        | 1    | !dontChange | 1     |        | 1    | !dontChange | 1     |        | 1    | !dontChange | 1     |       | 1   | !dontChange | 1      |       | 1   | !dontChange |
  | ACHARGE_3000    | Charge Auftrag                    | auftragsbezogen           |              |                   | 1        | 2      | 3   | !dontChange |         |      | !dontChange | Chargenverfolgung | ja          |          |        | 1    | !dontChange | 1      | !dontChange |        | 1    | !dontChange | 1     |        | 1    | !dontChange | 1     |        | 1    | !dontChange | 1     |       | 1   | !dontChange | 1      |       | 1   | !dontChange |
  | EINHEIT_1010    | Einheit                           | bedarfsbezogen            |              |                   | 1        | 2      | 3   | !dontChange |         |      | !dontChange |                   |             |          | ja     | 1    | Stück       | 2      | m           | ja     | 1    | Stück       | 2     | ja     | 1    | kg          | 1     | ja     | 1    | kg          | 1     | ja    | 1   | Stück       | 2      |       | 1   | m           |
  | AEINHEIT_1010   | Auftrag Einheit                   | auftragsbezogen           |              |                   | 1        | 2      | 3   | !dontChange |         |      | !dontChange |                   |             |          | ja     | 1    | Stück       | 2      | m           | ja     | 1    | Stück       | 2     | ja     | 1    | kg          | 1     | ja     | 1    | kg          | 1     | ja    | 1   | Stück       | 2      |       | 1   | m           |
  | EINHEIT_3000    | Einheit                           | bedarfsbezogen            |              |                   | 1        | 2      | 3   | !dontChange |         |      | !dontChange |                   |             |          | ja     | 1    | Stück       | 2      | m           | ja     | 1    | Stück       | 2     | ja     | 1    | kg          | 1     | ja     | 1    | kg          | 1     | ja    | 1   | Stück       | 2      |       | 1   | m           |
  | AEINHEIT_3000   | Auftrag Einheit                   | auftragsbezogen           |              |                   | 1        | 2      | 3   | !dontChange |         |      | !dontChange |                   |             |          | ja     | 1    | Stück       | 2      | m           | ja     | 1    | Stück       | 2     | ja     | 1    | kg          | 1     | ja     | 1    | kg          | 1     | ja    | 1   | Stück       | 2      |       | 1   | m           |
  | EINH-V_1024     | auftragsbez. Artikel mit Einheit  | auftragsbezogen           |              |                   | 1        | 2      | 3   | !dontChange |         |      | !dontChange |                   |             | ja       | ja     | 1    | Stück       | 2      | m           | ja     | 1    | Stück       | 2     | ja     | 1    | kg          | 1     | ja     | 1    | kg          | 1     | ja    | 1   | Stück       | 2      |       | 1   | m           |
  | EINH-V-B_1014   | auftragsbez. Artikel mit Einheit  | auftragsbezogen           |              |                   | 1        | 2      | 3   | !dontChange |         |      | !dontChange |                   |             | ja       | ja     | 1    | Stück       | 2      | m           | ja     | 1    | Stück       | 2     | ja     | 1    | kg          | 1     | ja     | 1    | kg          | 1     | ja    | 1   | Stück       | 2      |       | 1   | m           |
  | GEBINDE         | Einheit                           | bedarfsbezogen            |              |                   | 1        | 2      | 3   | !dontChange |         |      | !dontChange |                   |             |          | ja     | 1    | Stück       | 2      | m           | ja     | 1    | Stück       | 2     | ja     | 1    | kg          | 1     | ja     | 1    | kg          | 1     | ja    | 1   | Stück       | 2      |       | 1   | m           |
  | OHNE_GEBINDE    | Einheit                           | !dontChange               |              |                   | 1        | 2      | 3   | !dontChange |         |      | !dontChange |                   |             |          |        | 1    | Stück       | 2      | m           |        | 1    | Stück       | 2     |        | 1    | kg          | 1     |        | 1    | kg          | 1     |       | 1   | Stück       | 2      |       | 1   | m           |


Scenario Outline: auftragsbezogenes Kaufteil mit Mindestbestand MINDESTB

Given I open an editor "<such>" from table "(Part):(Product)" with command "STORE" for record "<such>"
And I set fields
  | such        | <such>            |
  | namebspr    | Mindestbestand    |
  | bsart       | Fremdbeschaffung  |
  | dispoa      | auftragsbezogen   |
  | mindest     | 50                |
  | lief        | 1                 |
  | efrist      | 2                 |
  | epr         | 3                 |
And I save the current editor

Examples:
  | such          |
  | MINDESTB_1010 |
  | MINDESTB_3000 |


Scenario: Einkaufsartikel KLINGEL, Umlagern

Given I open an editor "KLINGEL" from table "(Part):(Product)" with command "STORE" for record "KLINGEL"
And I set fields
  | such      | KLINGEL               |
  | namebspr  | Klingel fuer Fahrrad  |
  | lief      | KETTLER               |
  | dispoa    | auftragsbezogen       |
  | umllg     | HONGKONG              |
And I press button "alge" to open a subeditor for "Lagergruppeneigenschaften"
And I delete all rows
And I append rows
  | lgruppe   | bsart             | dispoa          |
  | HONGKONG  | Fremdbeschaffung  | auftragsbezogen |
And I save the current subeditor to switch back to the parent editor
And I set fields
  | bsart   | Umlagern  |
  | efrist  | 1         |
  | epr     | 2,5       |
And I save the current editor


Scenario Outline: Fertigungsmittel

Given I open an editor "<such>" from table "(Part):(MeansOfProduction)" with command "STORE" for record "<such>"
And I set field "such" to "<such>"
And I set field "namebspr" to "<namebspr>"
And I set field "platz" to "F1"
And I set field "le" to "g"
And I save the current editor

Examples:
  | such       | namebspr   |
  | SCHMIEROEL | Schmieroel |
  | LEIM       | Leim       |


Scenario Outline: Arbeitsgaenge

Given I open an editor "<such>" from table "(Operation):(Operation)" with command "STORE" for record "<such>"
And I set fields
  | such        | <such>      |
  | namebspr    | <namebspr>  |
  | mgr         | 112         |
  | lgr         | 2           |
  | lgrruesten  | 2           |
  | aschein     | ja          |
  | tr          | <tr>        |
  | te          | <te>        |
And I save the current editor

Examples:
  | such         | namebspr     | tr | te |
  | SCHRAUBEN    | Schrauben    | 5  | 10 |
  | MONTAGE1     | Montage 1    | 15 | 6  |
  | VORBEREITUNG | Vorbereitung | 0  | 20 |


Scenario: Verkaufsteil FAHRRAD

Given I open an editor "FAHRRAD" from table "(Part):(Product)" with command "STORE" for record "FAHRRAD"
And I set fields
  | such      | FAHRRAD         |
  | namebspr  | Fahrrad Typ A   |
  | bsart     | Eigenfertigung  |
  | chverfolgung | Chargenverfolgung              |
  | chimlager | ja              |
And I delete all rows
And I append rows
  | elex        | elanzahl    |
  | RAHMEN      | 1           |
  | RAD         | 2           |
  | SCHMIEROEL  | 10          |
  | A SCHRAUBEN | !dontChange |
  | SATTEL      | 1           |
  | A MONTAGE1  | !dontChange |
  | KLINGEL     | 1           |
And I save the current editor


Scenario Outline: Baugruppen Testbaugruppe

Given I open an editor "artikel" from table "(Part):(Product)" with command "STORE" for record "<such>"
And I set fields
  | such      | <such>          |
  | namebspr  | Testbaugruppe   |
  | bsart     | Eigenfertigung  |
  | vzaehlen  | <vzaehlen>      |
And I delete all rows
And I append rows
  | elex        | elanzahl | breite |
  | <elex>      | 1        | 0      |
  | A 122       | 1        | 25     |
And I save the current editor

Examples:
  | such           | elex          | vzaehlen   |
  | BAUGRUPPE_1010 | EKTEIL_1010   | nein       |
  | BAUGRUPPE_3000 | EKTEIL_3000   | nein       |
  | BAU-V-B_1014   | EINK-V-B_1014 | ja         |


Scenario: Baugruppe mit einer Komponente und zwei Arbeitsgaengen, Lagergruppeneigenschaften Eigenfertigung mit Standard-Fertigungsliste

Given I open an editor "BG-BEDARF" from table "(Part):(Product)" with command "STORE" for record "BG-BEDARF"
And I set fields
  | such        | BG-BEDARF             			|
  | namebspr    | Bedarfsbez, Lgruppeneigenschaft   |
  | dispoa      | bedarfsbezogen		            |
  | bsart       | Eigenfertigung        			|
  | ekbewverf   | 1							        |
  | gemein      | GK2.14.3             				|
  | wgruppe     | WG-RHB				            |
  | erlgrp      | PG-UE             				|
# Lagergruppeneigenschaften zuerst anpassen, sonst wird die Stueckliste geloescht
And I press button "alge" to open a subeditor for "Lagergruppeneigenschaften"
And I delete all rows
And I append rows
  | lgruppe   | bsart           |
  | BERLIN	  | Eigenfertigung  |
And I save the current subeditor to switch back to the parent editor
And I delete all rows
And I append rows
  | elex        | anzahl    |
  | EKTEIL_101  | 1 		|
  | A AG1       | 1 		|
  | A AG1       | 1 		|
And I save the current editor


Scenario Outline: Halbfabrikat fuer Lohnfertigung LOHNFERT

Given I open an editor "<such>" from table "(Part):(Product)" with command "STORE" for record "<such>"
And I set fields
  | such        | <such>         |
  | namebspr    | Halbfabrikat   |
  | bsart       | Eigenfertigung |
  | dispoa      |                |
And I press button "alge" to open a subeditor for "Lagergruppeneigenschaften"
And I delete all rows
And I append rows
  | lgruppe   | umllg     |
  | LOHNF     | 1         |
And I save the current subeditor to switch back to the parent editor
And I save the current editor

Examples:
  | such       |
  | HALBF_1010 |
  | HALBF_3000 |


Scenario Outline: Lohnfertigungsartikel LOHNFERT

Given I open an editor "<such>" from table "(Part):(Product)" with command "STORE" for record "<such>"
And I set fields
  | such      | <such>         |
  | namebspr  | Lohnfertigung  |
  | bsart     | Lohnfertigung  |
  | lief      | LOHNFERT       |
  | efrist    | 2              |
  | epr       | 3              |
And I delete all rows
And I append rows
  | elex       | elanzahl | kompeig      | bua                    |
  | <elex>     | 1        | Halbfabrikat | Lieferantenbeistellung |
And I save the current editor

Examples:
  | such          | elex       |
  | LOHNFERT_1010 | HALBF_1010 |
  | LOHNFERT_3000 | HALBF_3000 |


Scenario Outline: Verkaufsteile mit Lohnfertigung

Given I open an editor "artikel" from table "(Part):(Product)" with command "STORE" for record "<such>"
And I set fields
  | such      | <such>          |
  | namebspr  | Verkaufsteil    |
  | bsart     | Eigenfertigung  |
And I delete all rows
And I append rows
  | elex           | elanzahl | breite |
  | <elex1>        | 1        | 0      |
  | A 121          | 1        | 0      |
  | <elex2>        | 1        | 480    |
  | A 122          | 1        | 15     |
And I save the current editor

Examples:
  | such         | elex1          | elex2         |
  | VERKAUF_1010 | BAUGRUPPE_1010 | LOHNFERT_1010 |
  | VERKAUF_3000 | BAUGRUPPE_3000 | LOHNFERT_3000 |


Scenario Outline: Projekte

Given I open an editor "<such>" from table "(Transaction):(Project)" with command "STORE" for record "<such>"
And I set fields
  | such        | <such>            |
  | namebspr    | <namebspr>        |
And I save the current editor

Examples: Projekte
  | such        | namebspr           |
  | TESTP_1010  | Testprojekt_1010   |
  | T2ESTP_1010 | Testprojekt 2_1010 |
  | T3ESTP_1010 | Testprojekt 3_1010 |
  | TESTP_3000  | Testprojekt_3000   |
  | T2ESTP_3000 | Testprojekt 2_3000 |
  | T3ESTP_3000 | Testprojekt 3_3000 |
  | VPROJEKT1   | TestVPROJEKT       |
  | VPROJEKT2   | TestVPROJEKT 2     |
  | VPROJEKT3   | TestVPROJEKT 3     |


Scenario Outline: Chargen
  
Given I open an editor "<such>" from table "(Lots):(Lots)" with command "STORE" for record "<such>"
And I set fields
  | such        | <such>            |
  | chname      | <name>            |
  | exnum       | <exnum>           |
  | artikel     | <artikel>         |
  | lief        | 1                 |
And I save the current editor

Examples:
  | such          | name           | exnum       | artikel      |
  | CH1_1010      | Charge 1_1010  | 887799_1010 | CHARGE_1010  |
  | CHA1_1010     | Charge A1_1010 | 89639_1010  | ACHARGE_1010 |
  | CHA2_1010     | Charge A2_1010 | 67zu99_1010 | ACHARGE_1010 |
  | CH1_3000      | Charge 1_3000  | 887799_3000 | CHARGE_3000  |
  | CHA1_3000     | Charge A1_3000 | 89639_3000  | ACHARGE_3000 |
  | CHA2_3000     | Charge A2_3000 | 67zu99_3000 | ACHARGE_3000 |
  | ZCHARGE1_1024 | Charge 1       | 888888      | ACH-V_1024   |
  | ZCHARGE2_1024 | Charge 2       | 777777      | ACH-V_1024   |
  | ZCHARGE3_1024 | Charge 3       | 666666      | ACH-V_1024   |
  | VCHARGE1_1014 | Charge 1       | 888888_V    | ACH-V-B_1014 |
  | VCHARGE2_1014 | Charge 2       | 777777_V    | ACH-V-B_1014 |
  | VCHARGE3_1014 | Charge 3       | 666666_V    | ACH-V-B_1014 |
