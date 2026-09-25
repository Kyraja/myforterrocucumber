@persistent
Feature: behaelter_ekls_mit_mz_chargen.feature

Background:
Given I set the fake date to "02.01.1995"

# *****************************************************************************
#  Name             : behaelter_ekls_mit_mz_chargen.feature
#  Autor            : bschiga
#  Verantwortlich   : carue
#  Kontrolle        : drpf
#  Funktion         : Behaelter fuellen ueber Einkaufslieferschein mit MZ
#                     Artikel mit Charge, EK-LS stornieren
#
# *****************************************************************************
### FDA-3252
### Fall 1 - Behaelter wird nur durch EK-LS gefüllt, keine weiteren Buchungen, dann Storno
### Fall 2 - Behaelter wird durch EK-LS und LBU gefüllt, keine Abgänge, dann Storno von EK-LS, Rest bleibt im Behälter

Scenario: 01 Storno EK-LS betrifft kompletten Behaelterinhalt, Charge und Behaelter in Position und weitere Chargen in MZ

Given I open an editor "TEST" from table "(Part):(Product)" with command "UPDATE" for record "TEST"
And I set field "dispoa" to "auftragsbezogen"
And I set field "chverfolgung" to "Chargenverfolgung"
And I set field "chimlager" to "ja"
And I save the current editor

# Chargen anlegen
And I create a Lot "CH_1S12" for Product "TEST"
And I create a Lot "CH_2S12" for Product "TEST"
And I create a Lot "CH_3S12" for Product "TEST"

# Behaelter anlegen
And I create a Container "SCEN12" for packaging material "KLT"

# Einkaufslieferschein eine Position, Artikel in Behaelter mit mehreren Charge
# Behaelter und Charge in Position eintragen und dann in den MZ unterschiedliche Chargen eintragen
Given I open an editor "EKLS12" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set fields
    | lief   | TEST		|
    | ebeleg | EKLS_S12 |
    | vom    | .        |
And I append rows
    | artikel 	| mge	| charge	| !dialogId                                     | !dialogAnswer | exbehnum			|
    | TEST  	| 5   	| CH_1S12	| Externe Behälternummer ist bereits vergeben. | nein          | !SCEN12^nummer 	|
And I press button "mzsubm" to open a subeditor for "Materialzuordnung" in row 1
And I delete all rows
And I append rows
    | lpsuch | zuomge | verw  	 | charge  | !dialogId                                     | !dialogAnswer | exbehnum		|
    | F1     | 2      | SCEN12_1 | CH_1S12 | Externe Behälternummer ist bereits vergeben. | nein          | !SCEN12^nummer	|
    | F1     | 2      | SCEN12_2 | CH_2S12 | Externe Behälternummer ist bereits vergeben. | nein          | !SCEN12^nummer	|
    | F1     | 1      | SCEN12_3 | CH_3S12 | Externe Behälternummer ist bereits vergeben. | nein          | !SCEN12^nummer |
And I save the current subeditor to switch back to the parent editor
And I set field "ueb" to "ja"
And I save the current editor

# Lagerjournal pruefen
And I open the infosystem "LJ"
And I set field "adatum" to "."
And I set field "beleg" to "nummer" from editor "EKLS12"
And I press start
Then table has values
    | art  | zmge | verw  		| ncharge^id  | behaelter^id	|
    | TEST | 2    | SCEN12_1	| !CH_1S12^id | !SCEN12^id		|
    | TEST | 2    | SCEN12_2	| !CH_2S12^id | !SCEN12^id		|
    | TEST | 1    | SCEN12_3	| !CH_3S12^id | !SCEN12^id		|
And I close the current editor

# Behaelter pruefen
And I open an editor "behaelter" from table "(Container):(ContainerShell)" with command "VIEW" for record "SCEN12"
Then table has values
| mge | verw  		| charge^such	|
| 2   | SCEN12_1 	| CH_1S12 		|
| 2   | SCEN12_2 	| CH_2S12 		|
| 1   | SCEN12_3 	| CH_3S12		|
And I close the current editor

# EK-Lieferschein stornieren
Given I open an editor "STORNOEKLS12" from table "(Purchasing):(PackingSlip)" with command "REVERSAL" for record from editor "EKLS12"
And I save the current editor

# Behaelter ist leer
Then Container from editor "SCEN12" is empty

###############################################
Scenario: 02 Storno EK-LS betrifft nur einen Teil des Behaelterinhalts,  Charge und Behaelter in Position und weitere Chargen in MZ

# Chargen anlegen
And I create a Lot "CH_4S12" for Product "TEST"
And I create a Lot "CH_5S12" for Product "TEST"
And I create a Lot "CH_6S12" for Product "TEST"

# Behaelter anlegen
And I create a Container "SCEN12A" for packaging material "KLT"

# Einkaufslieferschein eine Position Artikel in Behaelter mit mehreren Charge
Given I open an editor "EKLS12A" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set fields
    | lief   | TEST		|
    | ebeleg | EKLS_S12A 	|
    | vom    | .         	|
And I append rows
    | artikel	| mge | charge	| !dialogId                                     | !dialogAnswer | exbehnum			|
    | TEST  	| 5   | CH_4S12	| Externe Behälternummer ist bereits vergeben. | nein          | !SCEN12A^nummer 	|
And I press button "mzsubm" to open a subeditor for "Materialzuordnung" in row 1
And I delete all rows
And I append rows
    | lpsuch | zuomge | verw  	 | charge  | !dialogId                                     | !dialogAnswer | exbehnum    	 |
    | F1     | 2      | SCEN12_4 | CH_4S12 | Externe Behälternummer ist bereits vergeben. | nein          | !SCEN12A^nummer |
    | F1     | 3      | SCEN12_5 | CH_5S12 | Externe Behälternummer ist bereits vergeben. | nein          | !SCEN12A^nummer |
And I save the current subeditor to switch back to the parent editor
And I set field "ueb" to "ja"
And I save the current editor

# weitere Zugaenge mit diesem Artikel und Behaelter buchen
Given I open an editor "Lagerbuchung" for tip command "(Stockadjustment)" and arguments ""
And I set fields
    | artikel | TEST			|
    | buart   | Zugang  		|
    | beleg   | LBU_SCEN12A 	|
    | beldat  | .       		|
And I modify table
    | !row | mge | platz2 | behaelter       | charge2 	| verw		|
    | 1    | 1	 | F1     | !SCEN12A^nummer | CH_5S12   | SCEN12_5	|
    | +2   | 1	 | F1     | !SCEN12A^nummer | CH_6S12   | SCEN12_6	|
And I save the current editor

# Lagerjournal pruefen
And I open the infosystem "LJ"
And I set field "adatum" to "."
And I set field "richtung" to "rückwärts"
And I press start
Then table has values
    | art  | zmge | verw  		| ncharge^id  | behaelter^id	|
    | TEST | 1    | SCEN12_6	| !CH_6S12^id | !SCEN12A^id		|
    | TEST | 1    | SCEN12_5	| !CH_5S12^id | !SCEN12A^id		| 
    | TEST | 3    | SCEN12_5	| !CH_5S12^id | !SCEN12A^id		|       
    | TEST | 2    | SCEN12_4	| !CH_4S12^id | !SCEN12A^id		|
And I close the current editor

# Behaelter pruefen
And I open an editor "behaelter" from table "(Container):(ContainerShell)" with command "VIEW" for record "SCEN12A"
Then table has values
| mge | verw  		| charge^such	|
| 2   | SCEN12_4 	| CH_4S12 		|
| 4   | SCEN12_5 	| CH_5S12 		|
| 1   | SCEN12_6 	| CH_6S12		|
And I close the current editor

# EK-Lieferschein stornieren
Given I open an editor "STORNOEKLS12A" from table "(Purchasing):(PackingSlip)" with command "REVERSAL" for record from editor "EKLS12A"
And I save the current editor

# Behaelter pruefen
And I open an editor "behaelter" from table "(Container):(ContainerShell)" with command "VIEW" for record "SCEN12A"
Then table has values
| mge | verw  		| charge^such	|
| 1   | SCEN12_5 	| CH_5S12 		|
| 1   | SCEN12_6 	| CH_6S12		|
And I close the current editor

