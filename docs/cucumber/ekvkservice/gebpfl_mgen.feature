@persistent
Feature: Stammdaten

Background: 
Given I set the fake date to "03.02.1995"

# *****************************************************************************
#  Name             : gebpfl_mgen.feature
#  Autor            : Silvia Warth
#  Verantwortlich   : sih
#  Kontrolle        : 
#  Funktion         : Stammdaten und Geschäftsprozesse
#
# *****************************************************************************
# 

Scenario Outline: Artikel mit und ohne Gebindepflicht anlegen
Given I open an editor "<such>" from table "(Part):(Product)" with command "STORE" for record "<such>"
And I set fields
	| such		| <such>		|
	| namebspr	| <namebspr>	|
	| dispoa	| <dispoa>		|
	| bsart		| <bsart>		|
	| lief      | <lief>        |
	| epr       | <epr>         |
	| vhe       | <vhe>         |
	| vpe       | <vpe>         |
	| ehe       | <ehe>         |
	| epe       | <epe>         |
	| ve        | <ve>          |
	| ge        | <ge>          |
	| gebvhe    | <gebvhe>      |
	| gebehe    | <gebehe>      |
	| gebve     | <gebve>       |
	| gebvpe    | <gebvpe>      |
	| gebepe    | <gebepe>      |
	| gebge     | <gebge>       |

And I save the current editor
And I close the current editor

Examples: 
| such			| namebspr			| dispoa			| bsart				|lief | epr    |epe1 |fvhe | vhe         |fvpe  |  vpe        | fehe |  ehe        | fepe  |  epe	      | fve | ve         | fge | ge         |gebvhe       |gebehe       |gebve        |gebvpe       |gebepe       |gebge        |  
| SCHUHE		| schöne Schuhe 	| auftragsbezogen	| Fremdbeschaffung	| 1   |  89,99 |     |     | Paar        |      |Paar   	  |    2  | Paar        |       | Paar 	  |     |Paar        |     |Paar        |             |             |             |             |             |             |
| SCHUHEMITGEB 	| nochmal Schuhe	| auftragsbezogen	| Fremdbeschaffung	| 1   |  99,99 |     |     |Paar         |      |Paar         |      | Paar        |       | Paar	      |     |Paar        |     |Paar        |  1          |  1          |  1          |  1          |  1          |  1          |
| HIGHHEELS		| schöne Schuhe 	| auftragsbezogen	| Fremdbeschaffung	| 1   |  79,00 |     |     |Paar         |      |Paar   	  |      | Paar        |       | Paar 	  |     |Paar        |     |Paar        |             |             |             |             |             |             |
| PUMPS      	| nochmal Schuhe	| auftragsbezogen	| Fremdbeschaffung	| 1   | 119,90 |     |     |Paar         |      |Paar         |      | Paar        |       | Paar	      |     |Paar        |     |Paar        |  1          |  1          |  1          |  1          |  1          |  1          |
| STIEFEL		| schöne Schuhe 	| auftragsbezogen	| Fremdbeschaffung	| 1   | 219,00 |     |     |Paar         |      |Paar	      |      | Paar        |       | Paar       |     |Paar        |     |Paar        |             |             |             |             |             |             |
| CLUTCH		| schöne Tasche 	| bedarfsbezogen	| Fremdbeschaffung	| 1   |  69,75 |     |     |!dontChange  |      |!dontChange  |     | !dontChange |       |!dontChange |     |!dontChange |     |!dontChange |             |             |             |             |             |             |
| SHOPPER		| schöne Tasche 	| auftragsbezogen	| Fremdbeschaffung	| 1   |  48,00 |     |     |!dontChange  |      |!dontChange  |      | !dontChange |       |!dontChange |     |!dontChange |     |!dontChange |             |             |             |             |             |             |
| BOWLINGBAG	| schöne Tasche 	| auftragsbezogen	| Fremdbeschaffung	| 1   |  99,95 |     |     |!dontChange  |      |!dontChange  |      | !dontChange |       |!dontChange |     |!dontChange |     |!dontChange |             |             |             |             |             |             |
#| GEBINDE       | Teil mit Einheiten| !dontChange       | !dontChange       | 1   |  13,40 |  kg |  2  |kg           |  4   |kg           |   2  | kg          |   4   |kg          |  2  |kg          | 4   |kg          | 1           | 1           | 1           | 1           |  1          |  1          |
| GEBINDEPFL    | Teil mit Gebindepf| !dontChange       | !dontChange       | 1   |  36,80 |     |     |Paar         |      |Paar         |      | Paar        |       |Paar        |      |Paar        |     |Paar        | ja          | ja          | ja          | ja          | ja          | ja          |
#| MEGABOOTS     | doppelt so toll   | !dontChange       | !dontChange       | 1   | 387,70 |   kg|  2  |Paar         |  4   |Paar         |      | Paar        |       |Paar        |      |Paar        |     |Paar        | 2           | 2           | 2           | 2           | 2           | 2           |

Scenario Outline: 00 Stammdaten anlegen - Einkaufsartikel
Given I open an editor "<suchw>" from table "(Part):(Product)" with command "STORE" for record "<suchw>"

And I set fields
    | such      | <suchw>    |
    | namebspr  | <namebspr> |
    | dispoa    | <dispoa>   |
    | fehe      | <fehe>     |
    | ehe       | <ehe>      |
    | fehle     | <fehle>    |
    | feple     | <feple>    |
    | lief      | 1      |
    | efrist    | <efrist>   |
    | epr       | <epr>      |
    | epe1      | <epe1>     |
    | chverfolgung |          |
    | chimlager | nein       |
    | vhe       | <vhe>      |
    | vpe       | <vpe>      |
    | epe       | <epe>      |
    | ve        | <ve>       |
    | ge        | <ge>       |
    | fvhe      | <fvhe>     |
    | fvpe      | <fvpe>     |
    | fepe      | <fepe>     |
    | fve       | <fve>      |
    | fge       | <fge>      |
    | gebehe    | <gebehe>   |
    | gebvhe    | <gebvhe>   |
    | gebve     | <gebve>    |
    | gebvpe    | <gebvpe>   |
    | gebepe    | <gebepe>   |
    | gebge     | <gebge>    |
    | zuplatz   | 1          |
    | abplatz   | 1          |

And I save the current editor

Examples: Artikel
| suchw     |  namebspr            | dispoa          | fehe | ehe         | fehle       | feple      | efrist | epr | epe1        | vhe         | vpe         | epe         | ve          | ge          | fvhe | fvpe | fepe | fve | fge | gebehe | gebvhe | gebve | gebvpe | gebepe | gebge |
| RAHMEN    | Rahmen Ultralight    | !dontChange     | 5    | kg          | 1           | 1          | 2      | 100 | kg          | kg          | kg          | kg          | kg          | kg          | 5    | 2    | 2    | 5   | 2   | JA     | JA     | JA    | JA     | JA     | JA    |
| GEBINDE2  | gebinde              | !dontChange     | 2    | kg          | !dontChange |!dontChange | 2      |  30 | kg          | kg          | kg          | kg          | kg          | kg          | 2    | 4    | 4    | 2   | 4   | JA     | JA     | JA    | JA     | JA     | JA    |  
| MEGABOOTS | dopplet so toll      | !dontChange     | 10   | kg          | !dontChange |!dontChange | 2      | 300 | kg          | kg          | kg          | kg          | kg          | kg          | 4    | 10   | 10   | 4   |10   | JA     | JA     | JA    | JA     | JA     | JA    |  

Scenario: einzelne Daten in Artikeln aendern
Given I open an editor "art" from table "(Part):(Product)" with command "UPDATE" for record "HIGHHEELS"
And I set field "zuplatz" to "F2"
And I set field "abplatz" to "F2"
And I save the current editor

Given I open an editor "art" from table "(Part):(Product)" with command "UPDATE" for record "PUMPS"
And I set field "zuplatz" to "F3"
And I set field "abplatz" to "F3"
And I save the current editor

Scenario: Geschaeftsprozesse                                                                                          
# Lieferschein für Artikel SCHUHEMITGEB, HIGHHEEL und PUMPS
Given I open an editor "ls-100" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set field "num4" to "100"
And I set field "lief" to "1"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I append rows
 | artikel      | mge |
 | SCHUHEMITGEB |  20 |
 | HIGHHEEL     |  40 |
 | PUMPS        |  60 |
And I save the current editor

# Bestellung für Artikel SCHUHE, SCHUHEMITGEB, HIGHHEEL, PUMPS UND CLUTCH
Given I open an editor "Bestellung-200" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set field "num4" to "200"
And I set field "lief" to "1"
And I set field "vom" to "."
And I append rows
 | artikel      | mge |
 | SCHUHE       | 100 |
 | SCHUHEMITGEB |  30 |
 | HIGHHEEL     |  25 |
 | PUMPS        |  40 |
 | CLUTCH       |  80 |
And I save the current editor

Given I open an editor "ls-200.1" from table "(Purchasing):(PurchaseOrder)" with command "DELIVERY" for record from editor "Bestellung-200"
Then the table has 5 rows
And I set field "vom" to "."
And I set field "num4" to "200.1"
And I set field "mge" to "70" in row 1
And I set field "mge" to "15" in row 2
And I set field "mge" to "10" in row 3
And I set field "mge" to "20" in row 4
And I set field "mge" to "30" in row 5
And I set field "ueb" to "ja"
And I save the current editor

Given I open an editor "ls-200.1" from table "(Purchasing):(PurchaseOrder)" with command "DELIVERY" for record from editor "Bestellung-200"
Then the table has 5 rows
And I set field "vom" to "."
And I set field "num4" to "200.2"
And I set field "mge" to "5" in row 2
And I set field "he" to "Stück" in row 2
And I set field "mge" to "2" in row 4
And I set field "he" to "Stück" in row 4
And I append rows
 | artikel      | mge | he    |
 | MEGABOOTS    |  20 | Stück|
 | MEGABOOTS    |  20 | kg    |
And I set field "ueb" to "ja"
And I save the current editor

Scenario: Lagerbuchung

Given I open an editor "Lagerbuchung" for tip command "LBuchung" and arguments ""
And I set fields
    | artikel | SCHUHEMITGEB |
    | beleg   | SIH          |
    | beldat  | .            |
    | buart   | Zugang       |
And I append rows
    | mge | zele  |   ze    |
    | 10  |  2    | Paar    |
    | 2   |  1    | Stück  |
    | 2   |  1    | Paar    |
And I save the current editor

Given I open an editor "Lagerbuchung" for tip command "LBuchung" and arguments ""
And I set fields
    | artikel | PUMPS        |
    | beleg   | Schuh        |
    | beldat  | .            |
    | buart   | Zugang       |
And I append rows
    | mge | zele  |   ze    |
    | 10  |  3    | Stück  |
    | 2   |  6    | Stück  |
    | 2   |  6    | Paar    |
And I save the current editor

Given I open an editor "Lagerbuchung" for tip command "LBuchung" and arguments ""
And I set fields
    | artikel | MEGABOOTS    |
    | beleg   | Boots        |
    | beldat  | .            |
    | buart   | Zugang       |
And I append rows
    | mge | zele  |   ze    |
    | 10  |  4    | kg      |
    | 10  |  8    | Stück  |
And I save the current editor

And I append "--- 1 Lagermenge ---" to output file "ref_gebpfl_mgen.ref" in cucu_refs_dir
And I export "bewertungslagermengen1" from StorageQuantities where "@ordnung=artikel,lgruppe,lager,platz" to output file "ref_gebpfl_mgen.ref"
And I append "--- Ende 1 Lagermenge ---" to output file "ref_gebpfl_mgen.ref" in cucu_refs_dir

And I append "--- 1 Lagerjournal ---" to output file "ref_gebpfl_mgen.ref" in cucu_refs_dir
And I export "ljfeldliste1_oh_zei" from StockMovementJournal where "@ordnung=budat,artikel" to output file "ref_gebpfl_mgen.ref"
And I append "--- Ende 1 Lagerjournal ---" to output file "ref_gebpfl_mgen.ref" in cucu_refs_dir

And I append "--- 1 Artikelmengen ---" to output file "ref_gebpfl_mgen.ref" in cucu_refs_dir
And I export "artikelmengenfeldliste1" from part_receipts_and_issues where "gjahr=95;waehr=DEM;dart=ist;" to output file "ref_gebpfl_mgen.ref"
And I append "--- Ende 1 Artikelmengen ---" to output file "ref_gebpfl_mgen.ref" in cucu_refs_dir

# Storno 
Given I open an editor "lieferschein-st-200.2" from table "(Purchasing):(PackingSlip)" with command "REVERSAL" for record "200.2" 
And I set field "num4" to "200.2s"
And I save the current editor

Given I open an editor "lieferschein-st-100" from table "(Purchasing):(PackingSlip)" with command "REVERSAL" for record "100" 
And I set field "num4" to "100s"
And I save the current editor

And I append "--- 2 Lagermenge ---" to output file "ref_gebpfl_mgen.ref" in cucu_refs_dir
And I export "bewertungslagermengen1" from StorageQuantities where "@ordnung=artikel,lgruppe,lager,platz" to output file "ref_gebpfl_mgen.ref"
And I append "--- Ende 2 Lagermenge ---" to output file "ref_gebpfl_mgen.ref" in cucu_refs_dir

And I append "--- 2 Lagerjournal ---" to output file "ref_gebpfl_mgen.ref" in cucu_refs_dir
And I export "ljfeldliste1_oh_zei" from StockMovementJournal where "@ordnung=budat,artikel" to output file "ref_gebpfl_mgen.ref"
And I append "--- Ende 2 Lagerjournal ---" to output file "ref_gebpfl_mgen.ref" in cucu_refs_dir

And I append "--- 2 Artikelmengen ---" to output file "ref_gebpfl_mgen.ref" in cucu_refs_dir
And I export "artikelmengenfeldliste1" from part_receipts_and_issues where "gjahr=95;waehr=DEM;dart=ist;" to output file "ref_gebpfl_mgen.ref"
And I append "--- Ende 2 Artikelmengen ---" to output file "ref_gebpfl_mgen.ref" in cucu_refs_dir

# Rücklieferung
Given I open an editor "rls-200.1" from table "(Purchasing):(PackingSlip)" with command "RETURN" for record "200.1"
And I set field "num4" to "200.1R"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "-40" in row 1
And I set field "mge" to "-5" in row 2
And I set field "mge" to "-5" in row 3
And I set field "mge" to "-10" in row 4
And I set field "mge" to "-20" in row 5
And I save the current editor

And I append "--- 3 Lagermenge ---" to output file "ref_gebpfl_mgen.ref" in cucu_refs_dir
And I export "bewertungslagermengen1" from StorageQuantities where "@ordnung=artikel,lgruppe,lager,platz" to output file "ref_gebpfl_mgen.ref"
And I append "--- Ende 3 Lagermenge ---" to output file "ref_gebpfl_mgen.ref" in cucu_refs_dir

And I append "--- 3 Lagerjournal ---" to output file "ref_gebpfl_mgen.ref" in cucu_refs_dir
And I export "ljfeldliste1_oh_zei" from StockMovementJournal where "@ordnung=budat,artikel" to output file "ref_gebpfl_mgen.ref"
And I append "--- Ende 3 Lagerjournal ---" to output file "ref_gebpfl_mgen.ref" in cucu_refs_dir

And I append "--- 3 Artikelmengen ---" to output file "ref_gebpfl_mgen.ref" in cucu_refs_dir
And I export "artikelmengenfeldliste1" from part_receipts_and_issues where "gjahr=95;waehr=DEM;dart=ist;" to output file "ref_gebpfl_mgen.ref"
And I append "--- Ende 3 Artikelmengen ---" to output file "ref_gebpfl_mgen.ref" in cucu_refs_dir

# Storno Rücklieferung
Given I open an editor "lieferschein-st-rls-200.1" from table "(Purchasing):(PackingSlip)" with command "REVERSAL" for record "+200.1R"
And I set field "num4" to "200.1RS"
And I save the current editor

And I append "--- 4 Lagermenge ---" to output file "ref_gebpfl_mgen.ref" in cucu_refs_dir
And I export "bewertungslagermengen1" from StorageQuantities where "@ordnung=artikel,lgruppe,lager,platz" to output file "ref_gebpfl_mgen.ref"
And I append "--- Ende 4 Lagermenge ---" to output file "ref_gebpfl_mgen.ref" in cucu_refs_dir

And I append "--- 4 Lagerjournal ---" to output file "ref_gebpfl_mgen.ref" in cucu_refs_dir
And I export "ljfeldliste1_oh_zei" from StockMovementJournal where "@ordnung=budat,artikel" to output file "ref_gebpfl_mgen.ref"
And I append "--- Ende 4 Lagerjournal ---" to output file "ref_gebpfl_mgen.ref" in cucu_refs_dir

And I append "--- 4 Artikelmengen ---" to output file "ref_gebpfl_mgen.ref" in cucu_refs_dir
And I export "artikelmengenfeldliste1" from part_receipts_and_issues where "gjahr=95;waehr=DEM;dart=ist;" to output file "ref_gebpfl_mgen.ref"
And I append "--- Ende 4 Artikelmengen ---" to output file "ref_gebpfl_mgen.ref" in cucu_refs_dir



