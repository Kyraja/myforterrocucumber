# *****************************************************************************
#  Name             : rueckbuchung_mit_umbuchung_scenario1.feature
#  Autor            : carue
#  Verantwortlich   : carue
#  Kontrolle        : ak
#  Funktion         : Testet die Rueckbuchung fuer Zugaenge,
#                     eine Umbuchung der Bestaende erfolgt ist
#
# *****************************************************************************
@persistent
Feature: rueckbuchung_mit_umbuchung_scenario1.feature
Background:
Given I set the fake date to "12.01.95"

Scenario: 01 Artikel anlegen

Given I open an editor "RUECKUM_001" from table "(Part):(Product)" with command "STORE" for record "RUECKUM_001"
And I set field "such" to "RUECKUM_001"
And I set field "namebspr" to "Ruecklieferartikel"
And I save the current editor

Scenario: 02 Zugang auf Platz buchen
Given I open an editor "EKLSUM01" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set field "lief" to "1"
And I set field "vom" to "."
And I set field "ebeleg" to "Originallieferung_001"
And I create a new row at the end of the table
And I set field "artikel" to id from editor "RUECKUM_001" in row 1
And I set field "mge" to "100" in row 1
And I set field "platz" to "F3" in row 1
And I set field "ueb" to "JA"
And I save the current editor

# Journal pruefen
And I open the infosystem "LJ"
And I set field "adatum" to "."
And I set field "beleg" to "nummer" from editor "EKLSUM01"
And I set field "artikel" to id from editor "RUECKUM_001"
And I press start
Then the table has 1 rows
Then field "buart" has value "Zugang" in row 1
Then field "nplatz" has value "F3" in row 1
Then field "zmge" has value "100" in row 1
And I close the current editor

# Platzmenge pruefen
Given I query StorageQuantity for Product "RUECKUM_001" on StorageLocation "F3"
Then StorageQuantities have values
	| gebmge |
	| 100	 |
And I close the current editor

# Lagergruppenelement pruefen
Given I query StorageQuantity for Product "RUECKUM_001" in WarehouseGroup "KARLSRUHE"
Then StorageQuantities have values
	| gebmge |
	| 100	 |
And I close the current editor

# Artikelmengenelement prüfen
Given I query StorageQuantity for Product "RUECKUM_001"
Then StorageQuantities have values
	| gebmge |
	| 100	 |
And I close the current editor

Scenario: 03 Menge umbuchen
And I transfer StorageQuantity of "10" for Product "RUECKUM_001" from StorageLocation "F3" to "F4" with document "Umbuch_001"

# Platzmengen pruefen
Given I query StorageQuantity for Product "RUECKUM_001" on StorageLocation "F3"
Then StorageQuantities have values
	| gebmge |
	| 90	 |
And I close the current editor

Given I query StorageQuantity for Product "RUECKUM_001" on StorageLocation "F4"
Then StorageQuantities have values
	| gebmge |
	| 10	 |
And I close the current editor

# Lagergruppe, Artikel pruefen
Given I query StorageQuantity for Product "RUECKUM_001" in WarehouseGroup "KARLSRUHE"
Then StorageQuantities have values
	| gebmge |
	| 100	 |
And I close the current editor

Given I query StorageQuantity for Product "RUECKUM_001"
Then StorageQuantities have values
	| gebmge |
	| 100	 |
And I close the current editor


Scenario: 04 Rueckbuchung auf Originallieferschein
Given I open an editor "EKLSUM02" from table "(Purchasing):(PackingSlip)" with command "RETURN" for record from editor "EKLSUM01"
And I set field "vom" to "."
And I set field "ebeleg" to "Ruecklieferung_001"
And I set field "mge" to "-20" in row 1
And I press button "mzsubm" to open a subeditor for "Materialzuordnung" in row 1
And I delete all rows
And I append rows
    | lpsuch | zuomge |
    | F3     | -10    |
    | F4     | -10    |
And I save the current editor
And I switch the current editor to editor "EKLSUM02"
And I set field "ueb" to "Ja"
And I save the current editor

# Journal pruefen
And I open the infosystem "LJ"
And I set field "adatum" to "."
And I set field "beleg" to "nummer" from editor "EKLSUM02"
And I set field "artikel" to id from editor "RUECKUM_001"
And I press start
Then the table has 2 rows
Then field "buart" has value "Zugang" in row 1
Then field "nplatz" has value "F4" in row 1
Then field "zmge" has value "-10" in row 1
Then field "buart" has value "Zugang" in row 2
Then field "nplatz" has value "F3" in row 2
Then field "zmge" has value "-10" in row 2
And I close the current editor

# Platzmengen pruefen
Given I query StorageQuantity for Product "RUECKUM_001" on StorageLocation "F3"
Then StorageQuantities have values
	| gebmge |
	| 80	 |
And I close the current editor

Given I query StorageQuantity for Product "RUECKUM_001" on StorageLocation "F4"
Then StorageQuantity is zero
And I close the current editor

# Lagergruppe, Artikel pruefen
Given I query StorageQuantity for Product "RUECKUM_001" in WarehouseGroup "KARLSRUHE"
Then StorageQuantities have values
	| gebmge |
	| 80	 |
And I close the current editor

Given I query StorageQuantity for Product "RUECKUM_001"
Then StorageQuantities have values
	| gebmge |
	| 80	 |
And I close the current editor
