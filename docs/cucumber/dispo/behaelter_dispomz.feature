@persistent
Feature: behaelter_dispomz.feature

Background:
And I set the fake date to "02.01.95"

# **********************************************************************************
#  Name             : behaelter_dispomz.feature
#  Autor            : drpf
#  Verantwortlich   : drpf
#  Kontrolle        : 
#  Funktion         : Test der Ermittlung, ob der Inhalt eines Behaelters zur Verfuegung steht
#  ref              : ref_behaelter_dispomz_cu
#
# **********************************************************************************

Scenario Outline: Neue Artikel, damit sicher kein Bestand vorhanden ist 
	Given I open an editor "<such>" from table "(Part):(Product)" with command "STORE" for record "<such>"
    And I set fields
      | such            | <such>           |
      | namebspr        | <namebspr>       |
      | bsart           | Fremdbeschaffung |
      | dispoa          | auftragsbezogen  |
	And I save the current editor
    
	Examples:
	| such            | namebspr          |
	| WANDER		  | Wanderschuhe      |
	| KLETTER		  | Kletterschuhe     |
	| MTB             | Mountainbikeshuhe |


Scenario: neue Behaelter anlegen
	And I create a Container "CU100" for packaging material "KLT"
	And I create a Container "CU101" for packaging material "KLT"
	And I create a Container "CU102" for packaging material "KLT"
	And I create a Container "CU103" for packaging material "KLT"
	And I create a Container "CU104" for packaging material "KLT"

Scenario: Behaelter befuellen
	And I post a receipt via ManualStockAdjustment for Product "WANDER" and quantity "100" on StorageLocation "F1" with document "L00" and Container "CU100"
	And I post a receipt via ManualStockAdjustment for Product "KLETTER" and quantity "10" on StorageLocation "F1" with document "L01" and Container "CU101"
	And I post a receipt via ManualStockAdjustment for Product "KLETTER" and quantity "10" on StorageLocation "F1" with document "L02" and Container "CU102"
	And I post a receipt via ManualStockAdjustment for Product "MTB" and quantity "10" on StorageLocation "F1" with document "L03" and Container "CU103"
	And I post a receipt via ManualStockAdjustment for Product "MTB" and quantity "10" on StorageLocation "F1" with document "L03" and Container "CU104"

Scenario: Auftrag erstellen
	Given I open an editor "Auftrag" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
	And I set fields
		| kunde | 1         |
		| such  | schuhspez |
		| vom   | .         |
	And I append rows
		| artikel  | mge | wtterm | einplan |
		| WANDER   |  30 | +3     |  ja     |
		| WANDER   |  30 | +6     |  ja     |
		| WANDER   |  30 | +12    |  ja     |
		| KLETTER  |  10 | +3     |  ja     |
		| KLETTER  |  10 | +6     |  ja     |
		| MTB      |   5 | +10    |  ja     |
	And I save the current editor

Scenario: Disposition laufen lassen
	And I run Scheduling

Scenario: Auftrag freigeben 1. Lieferschein
	Given I open an editor "Lieferschein1" from table "(Sales):(SalesOrder)" with command "DELIVERY" for record from editor "Auftrag"
	And I modify table
		| !row | mge | behaelter   |
		| 1    | 50  | CU100       |
		| 2    | 50  | CU100       |
	And I set field "ueb" to "ja"
	Then saving the current editor throws the exception "2743"

Scenario: Auftrag freigeben 2. Lieferschein
	Given I open an editor "Lieferschein2" from table "(Sales):(SalesOrder)" with command "DELIVERY" for record from editor "Auftrag"
	And I modify table
		| !row | mge |
		| 4    | 20  |
	And I press button "mzsubm" to open a subeditor for "Materialzuordnung" in row 4
	And I delete all rows
	And I append rows
		| lpsuch | zuomge | behaelter|
		| F1     | 10     | CU101    |
		| F1     | 10     | CU102    |
	And I save the current subeditor to switch back to the parent editor
	And I set field "ueb" to "ja"
	Then saving the current editor throws the exception "2743"

Scenario: Auftrag freigeben 3. Lieferschein
	Given I open an editor "Lieferschein3" from table "(Sales):(SalesOrder)" with command "DELIVERY" for record from editor "Auftrag"
	And I modify table
		| !row | mge |
		| 6    | 8   |
	And I press button "mzsubm" to open a subeditor for "Materialzuordnung" in row 6
	And I delete all rows
	And I append rows
		| lpsuch | zuomge | behaelter|
		| F1     | 5      | CU103    |
		| F1     | 3      | CU104    |
	And I save the current subeditor to switch back to the parent editor
	And I set field "ueb" to "ja"
	Then saving the current editor throws the exception "8367"
