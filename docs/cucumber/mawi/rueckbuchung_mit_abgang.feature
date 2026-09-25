# *****************************************************************************
#  Name             : rueckbuchung_mit_abgang.feature
#  Autor            : carue
#  Verantwortlich   : carue
#  Kontrolle        : ak
#  Funktion         : Testet die Rueckbuchung fuer Zugaenge,
#                     wenn ein Abgang erfolgt ist. Der Zugang kann nicht ausgetauscht
#                     werden, d.h. es ist kein weiterer passender Zugang vorhanden.
#                     In der Fertigung, da es dort keine Bestandspruefung gibt
#
# *****************************************************************************
@persistent
Feature: rueckbuchung_mit_abgang.feature

Background:
Given I set the fake date to "12.01.95"

@Testvorbereitung
Scenario Outline: Artikel, Komponenten
Given I open an editor "<such>" from table "(Part):(Product)" with command "STORE" for record "<such>"
And I set fields
    | such         | <such>         |
    | namebspr     | <namebspr>     |
    | lief         | 1              |
    | efrist       | 2              |
    | epr          | 25             |
    | zuplatz      | <zuplatz>      |
    | chverfolgung | <chverfolgung> |
    | dispoa       | <dispoa>       |
And I save the current editor

Examples:
| such      | namebspr       | zuplatz     | chverfolgung      | dispoa          |
| EINKAUF-1 | Einkaufsteil 1 | !dontChange | Chargenverfolgung | auftragsbezogen |
| EINKAUF-2 | Einkaufsteil 2 | !dontChange | Chargenverfolgung | auftragsbezogen |

@Testvorbereitung
Scenario: Arbeitsgang
Given I open an editor "MONTAGE1" from table "(Operation):(Operation)" with command "STORE" for record "MONTAGE1"
And I set fields
    | such       | MONTAGE1  |
    | namebspr   | Montage 1 |
    | mgr        | 112       |
    | lgr        | 1         |
    | lgrruesten | 2         |
    | aschein    | ja        |
    | tr         | 15        |
    | te         | 16        |
    | skostfix   | 10        |
    | skostvar   | 20        |
And I save the current editor

@Testvorbereitung
Scenario Outline: Baugruppen, 1 AG
Given I open an editor "<such>" from table "(Part):(Product)" with command "STORE" for record "<such>"
And I set fields
    | such      | <such>         |
    | namebspr  | <namebspr>     |
    | dispoa    | <dispoa>       |
    | bsart     | Eigenfertigung |
    | chverfolgung | Chargenverfolgung             |
    | zuplatz   | F3             |
    | abplatz   | F3             |
And I delete all rows
And I append rows
    | elex       | anzahl    | manbu   |
    | <elex1>    | <anzahl1> | <manbu> |
    | <elex2>    | <anzahl2> | <manbu> |
    | A MONTAGE1 | 1         |         |
And I save the current editor

Examples: 
| such          | namebspr           | dispoa          | manbu | elex1     | anzahl1 | elex2     | anzahl2 |
| BAUABGANG_222 | Einfache Baugruppe | auftragsbezogen | nein  | EINKAUF-1 | 2       | EINKAUF-2 | 1       |


Scenario: 01 Teil-Rueckbau auf Arbeitsschein nach retrograder Buchung ueber Rueckmeldung
# Fertigungsvorschlag anlegen und freigeben
Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
And I append rows
    | artikel       | netmge | bisuch    | mfreig |
    | BAUABGANG_222 | 100    | ARBEITSS_ | ja     |
And I press button "freig" to open a subeditor for "BA_freigeben"
And I close the current editor
And I switch the current editor to editor "fvor"
And I save the current editor

# Rueckmeldung auf ersten Arbeitsgang
Given I open an editor "Rueckmeldung1" from table "(Workorder):(WorkOrders)" with command "DONE" for record "ARBEITSS_001"
And I set field "sofort" to "1"
And I set field "gutmge" to "20" in row 1
And I save the current editor

# Platzmenge pruefen
Given I query StorageQuantity for Product "BAUABGANG_222" on StorageLocation "F3"
Then StorageQuantities have values
	| gebmge	|
	|  20		|
And I close the current editor

# Lagergruppe, Artikel pruefen
Given I query StorageQuantity for Product "BAUABGANG_222" in WarehouseGroup "KARLSRUHE"
Then StorageQuantities have values
	| gebmge	|
	|  20		|
And I close the current editor

Given I query StorageQuantity for Product "BAUABGANG_222"
Then StorageQuantities have values
	| gebmge	|
	|  20		|
And I close the current editor

# Zwischendurch Abgang buchen
Given I open an editor "VKLS-01" from table "(Sales):(PackingSlip)" with command "NEW" for record ""
And I set field "kunde" to "1"
And I set field "ueb" to "ja"
And I create a new row at the end of the table
And I set field "artikel" to "BAUABGANG_222" in row 1
And I set field "mge" to "13" in row 1
And I save the current editor

# Platzmenge pruefen
Given I query StorageQuantity for Product "BAUABGANG_222" on StorageLocation "F3"
Then StorageQuantities have values
	| gebmge	|
	|  7		|
And I close the current editor

# Lagergruppe, Artikel pruefen

Given I query StorageQuantity for Product "BAUABGANG_222" in WarehouseGroup "KARLSRUHE"
Then StorageQuantities have values
	| gebmge	|
	|  7		|
And I close the current editor

Given I query StorageQuantity for Product "BAUABGANG_222"
Then StorageQuantities have values
	| gebmge	|
	|  7		|
And I close the current editor

# Bindungen pruefen - folgt noch

Given I open the infosystem "LJ"
And I set field "adatum" to "."
And I set field "beleg" to "nummer" from editor "VKLS-01"
And I set field "richtung" to "rückwärts"
And I press start
Then table has values 
    | art           | amge |
    | BAUABGANG_222 | 13   |
And I close the current editor

# Rueckbau auf ersten Arbeitsschein
Given I open an editor "Rueckbau1" from table "(Workorder):(WorkOrders)" with command "RETURN" for record "ARBEITSS_001"
And I set field "sofort" to "ja"
And I set field "gutmge" to "-10" in row 1
And I save the current editor

# Platzmenge pruefen
Given I query StorageQuantity for Product "BAUABGANG_222" on StorageLocation "F3"
Then StorageQuantities have values
	| gebmge	|
	|  -3		|
And I close the current editor

# Lagergruppe, Artikel pruefen

Given I query StorageQuantity for Product "BAUABGANG_222" in WarehouseGroup "KARLSRUHE"
Then StorageQuantities have values
	| gebmge	|
	|  -3		|
And I close the current editor

Given I query StorageQuantity for Product "BAUABGANG_222"
Then StorageQuantities have values
	| gebmge	|
	|  -3		|
And I close the current editor

# Lagerjournaleintrag pruefen
Given I open the infosystem "LJ"
And I set field "adatum" to "."
And I set field "beleg" to "barmex" from editor "Rueckbau1"
And I set field "richtung" to "rückwärts"
And I press start
Then table has values 
    | art           | zmge | amge | detursache         |
    | BAUABGANG_222 | -10  |      | Rückbau Fertigung |
    | EINKAUF-1     |      | -20  | Rückbau Fertigung |
    | EINKAUF-2     |      | -10  | Rückbau Fertigung |
And I close the current editor


Scenario: Mengen und Preise bereitstellen
Given I open an editor "Lagerbuchung" for tip command "(Stockadjustment)" and arguments ""
And I set fields
    | artikel   | EINKAUF-1 |
    | buart     | Zugang    | 
    | beleg     | mge-preis | 
    | wert      | 4,5       | 
    | beldat    | .         | 
And I delete all rows
And I append rows
    | mge  | platz2 |
    | 400  | F1     |
And I save the current editor

Given I open an editor "Lagerbuchung" for tip command "(Stockadjustment)" and arguments ""
And I set fields
    | artikel   | EINKAUF-2 |
    | buart     | Zugang    | 
    | beleg     | mge-preis | 
    | wert      | 6,0       | 
    | beldat    | .         | 
And I delete all rows
And I append rows
    | mge  | platz2 |
    | 1000 | MLF01  |
And I save the current editor

# ------ nachbewerten ---------------
And I run Revaluation
