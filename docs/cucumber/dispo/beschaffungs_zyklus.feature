@persistent
Feature: beschaffungs_zyklus.feature

Background:
And I set the fake date to "02.01.95"

# **********************************************************************************
#  Name             : beschaffungs_zyklus.feature
#  Autor            : drpf
#  Verantwortlich   : drpf
#  Kontrolle        : bheim
#  Funktion         : Testet Erkennung von Beschaffungszyklus in der Disposition
#  ref              : ref_dispo_misc_cu
#
# **********************************************************************************
# verwendete Stammdaten: basis_stammdaten.feature

Scenario Outline: Einkaufsartikel erstellen
    Given I open an editor "<such>" from table "(Part):(Product)" with command "STORE" for record "<such>"
    And I set fields
      | such      | <such>           |
      | namebspr  | <namebspr>       |
      | bsart     | Fremdbeschaffung |
      | dispoa    | <dispoa>         |
      | lief      | <lief>           |
      | efrist    | <efrist>         |
      | epr       | <epr>            |
      | gemein    | <gemein>         |
      | kbpr      | <kbpr>           |
      | ekbewverf | <ekbewverf>      |
      | wgruppe   | <wgruppe>        |
      | erlgrp    | <erlgrp>         |
	And I save the current editor
    Examples:
      | such     | namebspr      | dispoa         | lief        | efrist | epr         | gemein   | kbpr          | ekbewverf | wgruppe | erlgrp |
      | EK_STUFE | EK-Teil Stufe | bedarfsbezogen | LIEFER1     | 3      | 10          | GK2.14.3 | Einkaufspreis | 6         | WG-RHB  | PG-UE  |

Scenario Outline: Zweistufigen Eigenfertigungsartikel erstellen
	Given I open an editor "<such>" from table "(Part):(Product)" with command "STORE" for record "<such>"
    And I set fields
      | such      | <such>           |
      | namebspr  | <namebspr>       |
      | bsart     | Eigenfertigung   |
      | dispoa    | <dispoa>         |
      | lief      | <lief>           |
      | efrist    | <efrist>         |
      | epr       | <epr>            |
      | gemein    | <gemein>         |
      | kbpr      | <kbpr>           |
      | ekbewverf | <ekbewverf>      |
      | wgruppe   | <wgruppe>        |
      | erlgrp    | <erlgrp>         |
    And I delete all rows
    And I append rows
      | elex    | elanzahl    |
      | <elex1> | <elanzahl1> |
      | <elex2> | !dontChange |
    And I save the current editor
    Examples:
      | such     | namebspr         | dispoa         | lief        | efrist | epr         | gemein   | kbpr          | ekbewverf | wgruppe | erlgrp | elex1    | elanzahl1 | elex2 |
      | BG_STUFE | Baugruppe Stufe  | bedarfsbezogen | LIEFER1     | 3      | 10          | GK2.14.3 | Einkaufspreis | 6         | WG-RHB  | PG-UE  | EK_STUFE | 1         | a ag1 |
      | FT_STUFE | Fertigteil Stufe | bedarfsbezogen | !dontChange | 1      | !dontChange | GK2.14.3 | !dontChange   | 6         | WG-RHB  | PG-UE  | BG_STUFE | 1         | a ag1 |


Scenario: Fertigungsvorschlag anlegen und freigeben
	Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
	And I append rows
		| artikel	| netmge	| bisuch	 | mfreig	|
		| FT_STUFE	| 10		| FT1_STUFE_ | ja		|
	#	| FT_STUFE	| 10		| FT2_STUFE_ | ja		|
	And I press button "freig" to open a subeditor for "BA_freigeben"
	And I close the current editor
	And I switch the current editor to editor "fvor"
	And I save the current editor

	And I run Scheduling

Scenario: Fertigungsliste erweitern
	Given I open an editor "FV" from table "(Purchasing):(WorkOrderSuggestions)" with command "UPDATE" for record ""
	And I set field "artikel" to "BG_STUFE"
	And I press button "ladetab"
	And I set field "fix" to "ja" in row 1
	And I press button "absteig" to open a subeditor for "FL" in row 1
	And I create a new row at the end of the table
	And I set field "elex" to "FT_STUFE" in row !lastRow
	And I set field "elanzahl" to "1" in row !lastRow
	And I save the current editor
	And I switch the current editor to editor "FV"
	And I save the current editor

	And I run Scheduling

Scenario: Tabellenzeilen pruefen
	Given I open an editor "FV" from table "(Purchasing):(WorkOrderSuggestions)" with command "VIEW" for record ""
	And I set field "artikel" to "FT_STUFE"
	And I press button "ladetab"
	Then table has values
		| art		| mge	|
		| FT_STUFE	| 10	|
		| FT_STUFE	| 10	|
	And I close the current editor
