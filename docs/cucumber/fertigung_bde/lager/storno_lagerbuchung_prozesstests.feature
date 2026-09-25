@persistent
Feature: storno_lagerbuchung_prozesstests.feature

Background: 
Given I set the fake date to "03.02.1995"

# *****************************************************************************
#  Name             : storno_lagerbuchung_prozesstests
#  Autor            : lschneider
#  Verantwortlich   : drpf
#  Kontrolle        : carue
#  Funktion         : Testet Prozesse zum Storno einer Lagerbuchung
#  Jira-Issue       : FDA-754
# *****************************************************************************

#Scenario: Behälter kaufen
#Given I open an editor "rechnung_behälter" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
#And I set fields
#	| lief		| KETTLER	|
#	| ebeleg	| B-LAGER	|
#	| ueb		| ja		|
#	| vom		| .			|
#	| budat     | .         |
#	| fakt		| ja		|
#And I append rows
#	| artikel	| mge	| preis	|
#	| BEHAELTER	| 10	| 3		|
#And I respond with answer "ja" to the dialog with id "4841"
#And I save the current editor

Scenario Outline: 01 Storno einer LBuchung
# Lagerbestand korrigieren
Given I set StorageQuantity to zero for Product "EINKAUF-1" on StorageLocation "F1" with document "K-01"

# Lagerbuchungen buchen
Given I open an editor "LBuchung" for tip command "LBuchung" and arguments ""
And I set fields
	| artikel	| EINKAUF-1	|
	| buart		| <buart>	|
	| beleg		| <beleg>	|
	| beldat	| .			|
And I modify table
	| mge	| platz		| platz2	| !row	|
	| 10	| <platz>	| <platz2>	| +1	|
And I save the current editor

# Bewertung Lagerbuchung
Given I open an editor "Bewertung" from table "(Valuation):(Valuation)" with command "VIEW" for search criteria "<bewertung>"
Then field "nachfolger" is empty
And I close the current editor


# Lagerbuchungen stornieren
Given I open an editor "LbuchungStorno" from table "(ManualStockAdjustment):(ManualStockAdjustment)" with command "REVERSAL" for record from editor "LBuchung"
And I set field "beleg" to "<beleg>"
Then field "buart" has value "<buart>"
Then table has values
	| mge	| platz		| platz2	| 
	| -10	| <platz>	| <platz2>	|
And I save the current editor

# LJ prüfen, zweite Zeile nur für Umbuchung relevant
Given I open the infosystem "LJ"
And I set field "richtung" to "rückwärts"
And I set field "beleg" to "<beleg>"
And I press start
Then table has values	
	| amge		| zmge		| nplatz	| vplatz	| detursache                | !row	|
	| <amge1>	| <zmge>	| <platz2>	| <vplatz1>	| <detursache>              | 1		|
	| <amge2>	| 			| 			| <vplatz2>	| Storno manuelle Umbuchung | <row>	|
Then field "storniert" has value "ja" in row <stornorow>
Then field "stornolj^id" in row 1 has value equal to field "verweis^id" from editor "LJ" in row <stornorow>
And I close the current editor

# Lagerbestand prüfen
Given I open the infosystem "BESTAND"
And I set fields
	| artikel	 | EINKAUF-1	|
	| klplatz	 | F1		|
	| verdichten | ja		|
	| details    | nein     |
And I press start
Then field "lemge" has value "<bestand>" in row 1
And I close the current editor

Examples:
| buart		| beleg		| bestand	| platz			| platz2		| vplatz1		| vplatz2		| amge1	| zmge	| amge2			| row			| stornorow	| detursache                   | bewertung	|
| Zugang	| LB01-Z	| 			| !dontChange	| F1			| !dontChange	| F1			|  		| -10	| !dontChange	| !dontChange	| 2			| Storno manuelle Lagerbuchung | $,,detursache=Manueller Zugang;artikel=EINKAUF-1;@richtung=rückwärts;@maxtreffer=1	|
| Abgang	| LB01-A	| 			| F1			| !dontChange	| F1			| !dontChange	|  -10	|		| !dontChange	| !dontChange	| 2			| Storno manuelle Lagerbuchung | $,,detursache=Manueller Abgang;artikel=EINKAUF-1;@richtung=rückwärts;@maxtreffer=1	|
| Umbuchung	| LB01-U	| 			| F1			| F2			| !dontChange	| F1			| 		| -10	| -10			| 2				| 3			| Storno manuelle Umbuchung    | $,,detursache=Manuelle Umbuchung;artikel=EINKAUF-1;@richtung=rückwärts;@maxtreffer=1	|


Scenario Outline: 02 Storno von LBuchungen mit verw, charge, projekt, behaelter
# Lagerbestand korrigieren
Given I set StorageQuantity to zero for Product "BAUGRUPPE" on StorageLocation "F1" with document "K-02"

# Projekt anlegen
Given I open an editor "PROJEKT_S" from table "(Transaction):(Project)" with command "STORE" for record "PROJEKT_S"
And I set field "such" to "PROJEKT_S"
And I save the current editor

# Charge anlegen
Given I open an editor "CH_BG1" from table "(Lots):(Lots)" with command "STORE" for record "CH_BG1"
And I set fields
	| such		| CH_BG1	|
	| exnum		| 921		|
	| artikel	| BAUGRUPPE	|
And I save the current editor

# Behälter anlegen für Scenarien mit Behälter
Given I create a Container "<behaelter>" for packaging material "BEHAELTER" if condition is "<cond>"

# Lagerbuchungen 
Given I open an editor "LBuchung" for tip command "LBuchung" and arguments ""
And I set fields
	| artikel	| BAUGRUPPE	|
	| buart		| <buart>	|
	| beleg		| <beleg>	|
	| beldat	| .			|
And I modify table
	| mge	| platz		| platz2	| verw		| projekt	| charge1	| charge2	| !row	|
	| <mge>	| <platz>	| <platz2>	| <verw>	| <projekt>	| <charge1>	| <charge2>	| 1		|
And I set field "behaelter" to id from editor "<behaelter>" in row 1
And I save the current editor

# Bewertung Lagerbuchung wird in Nachfolgetest geprüft

# Lagerbuchungen stornieren
Given I open an editor "LbuchungStorno" from table "(ManualStockAdjustment):(ManualStockAdjustment)" with command "REVERSAL" for record from editor "LBuchung"
And I set field "beleg" to "<beleg>"
Then field "buart" has value "<buart>"
Then table has values
	| mge		| platz		| platz2	| behaelter^such	| verw		| charge1^id	| charge2^id	| projekt	|
	| <smge>	| <platz>	| <platz2>	| <behaelter>		| <verw>	| <charge1>		| <charge2>		| <projekt>	|
And I save the current editor

# Storno manueller Zugang/ Abgang prüfen
# LJ prüfen
Given I open the infosystem "LJ"
And I set field "artikel" to "BAUGRUPPE"
And I set field "richtung" to "rückwärts"
And I set field "beleg" to "<beleg>"
And I press start
Then table has values	
	| amge			| zmge		| nplatz	| vplatz	| detursache					| verw		| projekt	| behaelter^such	| vcharge^id	| ncharge^id	|
	| <amge>		| <zmge>	| <platz2>	| <platz>	| Storno manuelle Lagerbuchung	| <verw>	| <projekt>	| <behaelter>		| <charge1>		| <charge2>		|
Then table has values
	| !row	| storniert	|
	| 2		| ja		|
And I close the current editor

# Lagerbestand prüfen
Given I open the infosystem "BESTAND"
And I set fields
	| artikel		| BAUGRUPPE	|
	| klplatz		| F1		|
	| verdichten	| ja		|
	| details       | nein      |
And I press start
Then field "lemge" has value "<bestand>" in row 1
And I close the current editor

Examples:
	| Scen			| buart		| beleg			| bestand	| mge	| platz			| platz2		| smge	| amge	| zmge	| verw			| projekt		| behaelter		| cond	| charge1		| charge2		|
	| Verwendung	| Zugang	| LB02-Z-V		| 			| 10	| !dontChange	| F1			| -10	| 		| -10	| Zugang-V		| !dontChange	| !dontChange	| nein	| !dontChange	| !dontChange	|
	| Projekt		| Zugang	| LB02-Z-P		| 			| 10	| !dontChange	| F1			| -10	| 		| -10	| !dontChange	| PROJEKT_S		| !dontChange	| nein	| !dontChange	| !dontChange	|
	| Behälter		| Zugang	| LB02-Z-B		| 			|  10	| !dontChange	| F1			| -10	| 		| -10	| !dontChange	| !dontChange	| LBUCH1		| ja	| !dontChange	| !dontChange	|
	| Charge		| Zugang	| LB02-Z-C		| 			|  10	| !dontChange	| F1			| -10	| 		| -10	| !dontChange	| !dontChange	| !dontChange	| nein	| !dontChange	| !CH_BG1^id	|
	| Alles			| Zugang	| LB02-Z-A		| 			|  10	| !dontChange	| F1			| -10	| 		| -10	| Zugang-V		| PROJEKT_S		| LBUCH2		| ja	| !dontChange	| !CH_BG1^id	|
	| Projekt		| Abgang	| LB02-A-P		| 			|  10	| F1			| !dontChange	| -10	| -10	|		| !dontChange	| PROJEKT_S		| !dontChange	| nein	| !dontChange	| !dontChange	|
	| Charge		| Abgang	| LB02-A-C		| 			| 10	| F1			| !dontChange	| -10	| -10	|		| !dontChange	| !dontChange	| !dontChange	| nein	| !CH_BG1^id	| !dontChange	|
	

Scenario Outline: 03 Storno von LBuchungen mit verw, charge, projekt, behaelter - Abgang mit Behälter
# Lagerbestand korrigieren
Given I set StorageQuantity to zero for Product "BAUGRUPPE" on StorageLocation "F1" with document "K-03"

# Projekt anlegen
Given I open an editor "PROJEKT_S" from table "(Transaction):(Project)" with command "STORE" for record "PROJEKT_S"
And I set field "such" to "PROJEKT_S"
And I save the current editor

# Charge anlegen
Given I open an editor "CH_BG1" from table "(Lots):(Lots)" with command "STORE" for record "CH_BG1"
And I set fields
	| such		| CH_BG1	|
	| exnum		| 921		|
	| artikel	| BAUGRUPPE	|
And I save the current editor

# Behälter anlegen
Given I create a Container "<behaelter>" for packaging material "BEHAELTER" if condition is "<cond>"

# Lagerbuchung Zugang
Given I open an editor "LBuchungZ" for tip command "LBuchung" and arguments ""
And I set fields
	| artikel	| BAUGRUPPE	|
	| buart		| Zugang	|
	| beleg		| Zugang05H	|
	| beldat	| .			|
And I modify table
	| mge	| platz2	| verw		| projekt	| charge2	| !row	|
	| <mge>	| <platz2>	| <verw>	| <projekt>	| <charge2>	| 1		|
And I set field "behaelter" to id from editor "<behaelter>" in row 1
And I save the current editor

# Lagerbuchung Abgang
Given I open an editor "LBuchungA" for tip command "LBuchung" and arguments ""
And I set fields
	| artikel	| BAUGRUPPE	|
	| buart		| <buart>	|
	| beleg		| <beleg>	|
	| beldat	| .			|
And I modify table
	| mge	| platz		| verw		| projekt	| charge1	| !row	|
	| <mge>	| <platz>	| <verw>	| <projekt>	| <charge1>	| 1		|
And I set field "behaelter" to id from editor "<behaelter>" in row 1
And I save the current editor

# Bewertung Lagerbuchung
Given I open an editor "Bewertung" from table "(Valuation):(Valuation)" with command "VIEW" for search criteria "$,,artikel=BAUGRUPPE;@richtung=rückwärts;@maxtreffer=1"
Then field "nachfolger" is empty
And I close the current editor


# Lagerbuchungen stornieren
Given I open an editor "LbuchungStorno" from table "(ManualStockAdjustment):(ManualStockAdjustment)" with command "REVERSAL" for record from editor "LBuchungA"
And I set field "beleg" to "<beleg>"
Then field "buart" has value "<buart>"
Then table has values
	| mge		| platz		| verw		| charge1^id	| projekt	| behaelter^such	|
	| <smge>	| <platz>	| <verw>	| <charge1>		| <projekt>	| <behaelter>		|
And I save the current editor

# Stornierter manueller Abgang einfügen
# LJ prüfen
Given I open the infosystem "LJ"
And I set field "richtung" to "rückwärts"
And I set field "artikel" to "BAUGRUPPE"
And I set field "beleg" to "<beleg>"
And I press start
Then table has values	
	| amge		| zmge		| vplatz	| detursache					| verw		| projekt	| behaelter^such	| vcharge^id	| ncharge^id	|
	| <amge>	| <zmge>	| <platz2>	| Storno manuelle Lagerbuchung	| <verw>	| <projekt>	| <behaelter>		| <charge1>		| <charge2_lj>	|
Then table has values
	| !row	| storniert	|
	| 2		| ja		|
And I close the current editor

# Bewertung hat Nachfolger bekommen
And I switch the current editor to editor "Bewertung" with command "VIEW"
Then field "nachfolger" is not empty
And I close the current editor

# Lagerbestand prüfen
Given I open the infosystem "BESTAND"
And I set fields
	| artikel		| BAUGRUPPE	|
	| klplatz		| F1		|
	| verdichten	| ja		|
	| details       | nein      |  
And I press start
Then field "lemge" has value "<mge>" in row 1
And I close the current editor

Examples:
	| Scen				| buart		| beleg		| mge	| platz	| platz2	| smge	| amge	| zmge	| verw			| projekt		| behaelter		| cond	| charge1		| charge2		| charge2_lj	|
	| Abgang Behälter	| Abgang	| LB02-A-B	| 10	| F1	| F1		| -10	| -10	| 		| !dontChange	| !dontChange	| LBUCH3		| ja	| !dontChange	| !dontChange	| !dontChange	|
	| Abgang alles		| Abgang	| LB02-A-A	| 10	| F1	| F1		| -10	| -10	| 		| Abgang-V		| PROJEKT_S		| LBUCH4		| ja	| !CH_BG1^id	| !CH_BG1^id	| !dontChange	|
	| Abgang Verwendung	| Abgang	| LB02-A-V	| 10	| F1	| F1		| -10	| -10	| 		| Abgang-V		| !dontChange	| !dontChange	| nein	| !dontChange	| !dontChange	| !dontChange	|



Scenario Outline: 04 Storno von LBuchungen mit verw, charge, projekt, behaelter - Umbuchung
# Lagerbestand korrigieren
Given I set StorageQuantity to zero for Product "BAUGRUPPE" on StorageLocation "F1" with document "K-04"

# Projekt anlegen
Given I open an editor "PROJEKT_S" from table "(Transaction):(Project)" with command "STORE" for record "PROJEKT_S"
And I set field "such" to "PROJEKT_S"
And I save the current editor

# Charge anlegen
Given I open an editor "CH_BG1" from table "(Lots):(Lots)" with command "STORE" for record "CH_BG1"
And I set fields
	| such		| CH_BG1	|
	| exnum		| 921		|
	| artikel	| BAUGRUPPE	|
And I save the current editor

# Behälter anlegen
Given I create a Container "<behaelter>" for packaging material "BEHAELTER" if condition is "<cond>"
Given I create a Container "<behaelter2>" for packaging material "BEHAELTER" if condition is "<cond>"

# Lagerbuchung Zugang
Given I open an editor "LBuchungZ" for tip command "LBuchung" and arguments ""
And I set fields
	| artikel	| BAUGRUPPE	|
	| buart		| Zugang	|
	| beleg		| UMBUCH05H	|
	| beldat	| .			|
And I modify table
	| mge	| platz2	| verw		| projekt	| charge2	| !row	|
	| <mge>	| <platz>	| <verw>	| <projekt>	| <charge2>	| 1		|
And I set field "behaelter" to id from editor "<behaelter>" in row 1
And I save the current editor

# Lagerbuchungen 
Given I open an editor "LBuchung" for tip command "LBuchung" and arguments ""
And I set fields
	| artikel	| BAUGRUPPE	|
	| buart		| <buart>	|
	| beleg		| <beleg>	|
	| beldat	| .			|
And I modify table
	| mge	| platz		| platz2	| verw		| verw2		| projekt	| projekt2		| charge1	| charge2	| !row	|
	| <mge>	| <platz>	| <platz2>	| <verw>	| <verw2>	| <projekt>	| <projekt2>	| <charge1>	| <charge2>	| 1		|
And I set field "behaelter" to id from editor "<behaelter>" in row 1
And I set field "behaelterzu" to id from editor "<behaelter2>" in row 1
And I save the current editor

# Bewertung Lagerbuchung
Given I open an editor "Bewertung" from table "(Valuation):(Valuation)" with command "VIEW" for search criteria "$,,artikel=BAUGRUPPE;@richtung=rückwärts;@maxtreffer=1"
Then field "nachfolger" is empty
And I close the current editor

# Lagerbuchungen stornieren
Given I open an editor "LbuchungStorno" from table "(ManualStockAdjustment):(ManualStockAdjustment)" with command "REVERSAL" for record from editor "LBuchung"
And I set field "beleg" to "<beleg>"
Then field "buart" has value "<buart>"
Then table has values
	| mge		| platz		| platz2	| behaelter^such	| behaelterzu^such	| verw		| charge1^id	| charge2^id	| projekt	|
	| <smge>	| <platz>	| <platz2>	| <behaelter>		| <behaelter2>		| <verw>	| <charge1>		| <charge2>		| <projekt>	|
And I save the current editor

# stornierte manuelle Umbuchung einfügen
# LJ prüfen
Given I open the infosystem "LJ"
And I set field "artikel" to "BAUGRUPPE"
And I set field "richtung" to "rückwärts"
And I set field "beleg" to "<beleg>"
And I press start
Then table has values	
	| amge		| zmge		| nplatz	| vplatz	| detursache				| verw		| projekt	| behaelter^such	| vcharge^id	| ncharge^id	|
	| 			| <zmge>	| <platz2>	| 			| Storno manuelle Umbuchung	| <verw>	| <projekt>	| <behaelter2>		| <charge1>		| <charge2>		|
	| <amge>	| 			| 			| <platz>	| Storno manuelle Umbuchung	| <verw>	| <projekt>	| <behaelter>		| <charge1>		| <charge2>		|
Then table has values
	| !row	| storniert	|
	| 3		| ja		|
	| 4		| ja		|
And I close the current editor

# Lagerbestand prüfen
Given I open the infosystem "BESTAND"
And I set fields
	| artikel		| BAUGRUPPE	|
	| klplatz		| F1		|
	| verdichten	| ja		|
	| details       | nein      |
And I press start
Then field "lemge" has value "<mge>" in row 1
And I close the current editor

# Bewertung hat Nachfolger bekommen
And I switch the current editor to editor "Bewertung" with command "VIEW"
Then field "nachfolger" is not empty
And I close the current editor

Examples:
	| Scen			| buart		| beleg			| mge	| platz	| platz2	| smge	| amge	| zmge	| verw			| verw2			| projekt		| projekt2		| behaelter		| behaelter2	| cond	| charge1		| charge2		|
	| Verwendung	| Umbuchung	| LB02-U-V		| 10	| F1	| F2		| -10	| -10	| -10	| Umbuch-V		| Umbuch-V		| !dontChange	| !dontChange	| !dontChange	| !dontChange	| nein	| !dontChange	| !dontChange	|
	| Projekt		| Umbuchung	| LB02-U-P		| 10	| F1	| F2		| -10	| -10	| -10	| !dontChange	| !dontChange	| PROJEKT_S		| PROJEKT_S		| !dontChange	| !dontChange	| nein	| !dontChange	| !dontChange	|
	| Behälter		| Umbuchung	| LB02-U-B		| 10	| F1	| F2		| -10	| -10	| -10	| !dontChange	| !dontChange	| !dontChange	| !dontChange	| LBUCHUML1		| LBUCHUML2		| ja	| !dontChange	| !dontChange	|
	| Charge		| Umbuchung	| LB02-U-C		| 10	| F1	| F2		| -10	| -10	| -10	| !dontChange	| !dontChange	| !dontChange	| !dontChange	| !dontChange	| !dontChange	| nein	| !CH_BG1^id	| !CH_BG1^id	|
	| Alles			| Umbuchung	| LB02-U-A		| 10	| F1	| F2		| -10	| -10	| -10	| Umbuch-V		| Umbuch-V		| PROJEKT_S		| PROJEKT_S		| LBUCHUML3		| LBUCHUML4		| ja	| !CH_BG1^id	| !CH_BG1^id	|


Scenario Outline: 05 Storno LBuchung eines Artikels mit Gebindepflicht
# Lagerbestand korrigieren
Given I open an editor "BKorrektur" for tip command "Lbestand" and arguments ""
And I set fields
	| artikel	| <artikel>	|
	| beleg		| K-05		|
	| beldat	| .			|
And I set field "platz" to "F1" in row 1
And I modify table
| !row			| mge	|
| platz=='F1'	| 0		|
And I save the current editor

# Lagerbuchungen buchen
Given I open an editor "LBuchung" for tip command "LBuchung" and arguments ""
And I set fields
	| artikel	| <artikel>	|
	| buart		| <buart>	|
	| beleg		| <beleg>	|
	| beldat	| .			|
And I append rows
	| mge	| ze	| platz		| platz2	|
	| <mge>	| <ze>	| <platz>	| <platz2>	|
And I save the current editor

# Bewertung Lagerbuchung
Given I open an editor "Bewertung" from table "(Valuation):(Valuation)" with command "VIEW" for search criteria "<bewertung>"
Then field "nachfolger" is empty
And I close the current editor

# Lagerbuchungen stornieren
Given I open an editor "LbuchungStorno" from table "(ManualStockAdjustment):(ManualStockAdjustment)" with command "REVERSAL" for record from editor "LBuchung"
And I set field "beleg" to "<beleg>"
Then field "buart" has value "<buart>"
Then table has values
	| mge		| platz		| platz2	|
	| <smge>	| <platz>	| <platz2>	|
And I save the current editor

# LJ prüfen
Given I open the infosystem "LJ"
And I set field "richtung" to "rückwärts"
And I set field "beleg" to "<beleg>"
And I press start
Then table has values	
	| amge		| zmge		| nplatz	| vplatz	| detursache					|
	| <amge>	| <zmge>	| <platz2>	| <platz>	| Storno manuelle Lagerbuchung	|
Then table has values
	| !row	| storniert	|
	| 2		| ja		|
Then field "stornolj^id" in row 1 has value equal to field "verweis^id" from editor "LJ" in row 2
And I close the current editor

# Lagerbestand prüfen
Given I open the infosystem "BESTAND"
And I set fields
	| artikel		| <artikel>	|
	| klplatz		| F1		|
	| verdichten	| ja		|
	| details       | nein      |
And I press start
Then field "lemge" has value "<bestand>" in row 1
And I close the current editor

Given I open the infosystem "BESTAND"
And I set fields
	| artikel		| <artikel>	|
	| klplatz		| F1		|
	| verdichten	| nein		|
	| nullmge		| nein		|
	| details       | nein      |
And I press start
Then the table has 0 rows
And I close the current editor

# Bewertung hat Nachfolger bekommen
And I switch the current editor to editor "Bewertung" with command "VIEW"
Then field "nachfolger" is not empty
And I close the current editor

Examples:
| artikel		| buart		| beleg		| bestand	| mge	| ze	| platz			| platz2		| smge	| amge	| zmge	| bewertung	|  
| GEBINDE		| Zugang	| LB03-Zkg	| 			| 10	| kg	| !dontChange	| F1			| -10	| 		| -10	| $,,artikel=GEBINDE;@richtung=rückwärts;@maxtreffer=1	| 
| GEBINDE		| Zugang	| LB03-ZStG	| 			| 10	| Stück	| !dontChange	| F1			| -10	| 		| -10	| $,,artikel=GEBINDE;@richtung=rückwärts;@maxtreffer=1	|
| GEBINDE		| Abgang	| LB03-Akg	| 			| 10	| kg	| F1			| !dontChange	| -10	| -10	|		| $,,artikel=GEBINDE;@richtung=rückwärts;@maxtreffer=1	|
| GEBINDE		| Abgang	| LB03-AStG	| 			| 10	| Stück	| F1			| !dontChange	| -10	| -10	|		| $,,artikel=GEBINDE;@richtung=rückwärts;@maxtreffer=1	|
| GEBINDEPFL	| Zugang	| LB03-ZP	| 			| 10	| Paar	| !dontChange	| F1			| -10	| 		| -10	| $,,artikel=GEBINDEPFL;@richtung=rückwärts;@maxtreffer=1	|
| GEBINDEPFL	| Zugang	| LB03-ZSt	| 			| 10	| Stück	| !dontChange	| F1			| -10	| 		| -10	| $,,artikel=GEBINDEPFL;@richtung=rückwärts;@maxtreffer=1	|
| GEBINDEPFL	| Abgang	| LB03-AP	| 			| 10	| Paar	| F1			| !dontChange	| -10	| -10	|		| $,,artikel=GEBINDEPFL;@richtung=rückwärts;@maxtreffer=1	|
| GEBINDEPFL	| Abgang	| LB03-ASt	| 			| 10	| Stück	| F1			| !dontChange	| -10	| -10	|		| $,,artikel=GEBINDEPFL;@richtung=rückwärts;@maxtreffer=1	|


Scenario Outline: 06 Storno LBuchung eines Artikels mit Gebindepflicht - Umbuchung
# Lagerbestand korrigieren
Given I open an editor "BKorrektur" for tip command "Lbestand" and arguments ""
And I set fields
	| artikel	| <artikel>	|
	| beleg		| K-06		|
	| beldat	| .			|
And I set field "platz" to "F1" in row 1
And I modify table
| !row			| mge	|
| platz=='F1'	| 0		|
And I save the current editor

# Lagerbuchungen buchen
Given I open an editor "LBuchung" for tip command "LBuchung" and arguments ""
And I set fields
	| artikel	| <artikel>	|
	| buart		| <buart>	|
	| beleg		| <beleg>	|
	| beldat	| .			|
And I append rows
	| mge	| ze	| platz		| platz2	|
	| <mge>	| <ze>	| <platz>	| <platz2>	|
And I save the current editor

# Bewertung Lagerbuchung
Given I open an editor "Bewertung" from table "(Valuation):(Valuation)" with command "VIEW" for search criteria "<bewertung>"
Then field "nachfolger" is empty
And I close the current editor

# Lagerbuchungen stornieren
Given I open an editor "LbuchungStorno" from table "(ManualStockAdjustment):(ManualStockAdjustment)" with command "REVERSAL" for record from editor "LBuchung"
And I set field "beleg" to "<beleg>"

Then field "buart" has value "<buart>"
Then table has values
	| mge		| platz		| platz2	|
	| <smge>	| <platz>	| <platz2>	|
And I save the current editor

# stornierte manueller Umbuchung einfügen
# LJ prüfen
Given I open the infosystem "LJ"
And I set field "richtung" to "rückwärts"
And I set field "beleg" to "<beleg>"
And I press start
Then table has values	
	| amge		| zmge		| nplatz	| vplatz	| detursache					|
	| 			| <zmge>	| <platz2>	| 			| Storno manuelle Umbuchung	    |
	| <amge2>	| 			| 			| <platz>	| Storno manuelle Umbuchung	    |
Then table has values
	| !row	| storniert	|
	| 3		| ja		|
	| 4		| ja		|
Then field "stornolj^id" in row 1 has value equal to field "verweis^id" from editor "LJ" in row 3
Then field "stornolj^id" in row 2 has value equal to field "verweis^id" from editor "LJ" in row 4
And I close the current editor

# Lagerbestand prüfen
Given I open the infosystem "BESTAND"
And I set fields
	| artikel		| <artikel>	|
	| klplatz		| F1		|
	| verdichten	| ja		|
	| details       | nein      |
And I press start
Then the table has 1 rows
Then field "lemge" has value "<bestand>" in row 1
And I close the current editor

# Bewertung hat Nachfolger bekommen
And I switch the current editor to editor "Bewertung" with command "VIEW"
Then field "nachfolger" is not empty
And I close the current editor

Examples:
| artikel		| buart		| beleg		| bestand	| mge	| ze	| platz	| platz2	| smge	| zmge	| amge2	| bewertung	|
| GEBINDE		| Umbuchung	| LB03-UkgG	| 			| 10	| kg	| F1	| F2		| -10	| -10	| -10	| $,,artikel=GEBINDE;@richtung=rückwärts;@maxtreffer=1	|
| GEBINDE		| Umbuchung	| LB03-UStG	| 			| 10	| Stück	| F1	| F2		| -10	| -10	| -10	| $,,artikel=GEBINDE;@richtung=rückwärts;@maxtreffer=1	|  
| GEBINDEPFL	| Umbuchung	| LB03-UPa	| 			| 10	| Paar	| F1	| F2		| -10	| -10	| -10	| $,,artikel=GEBINDEPFL;@richtung=rückwärts;@maxtreffer=1	|
| GEBINDEPFL	| Umbuchung	| LB03-USt	| 			| 10	| Stück	| F1	| F2		| -10	| -10	| -10	| $,,artikel=GEBINDEPFL;@richtung=rückwärts;@maxtreffer=1	|


Scenario: 07 Storno einer LBuchung mit Jokerbestand
# Bestandskorrektur EINKAUF-1
Given I open an editor "Bestandskorrektur" for tip command "(SInventory)" and arguments ""
And I set fields
	| artikel	| EINKAUF-1	|
	| beleg		| K-07		|
	| beldat	| .			|
And I set field "platz" to "F1" in row 1
And I modify table
	| mge	| !row			|
	| 0		| platz=='F1'	|
And I save the current editor

# Lagerbuchungen buchen
Given I open an editor "LBuchungZ" for tip command "LBuchung" and arguments ""
And I set fields
	| artikel	| EINKAUF-1	|
	| buart		| Zugang	|
	| beleg		| Zugang06	|
	| beldat	| .			|
And I append rows
	| mge	| verw			| platz2	| 
	| 10	| 				| F1		|
	| 10	| Zugangsverw2	| F1		| 
And I save the current editor

# Lagerbuchungen buchen
Given I open an editor "LBuchungA" for tip command "LBuchung" and arguments ""
And I set fields
	| artikel	| EINKAUF-1	|
	| buart		| Abgang	|
	| beleg		| Abgang06	|
	| beldat	| .			|
And I append rows
	| mge	| verw			| platz	| 
	| 20	| Zugangsverw2	| F1	|
And I save the current editor

# Bewertung Lagerbuchung
Given I open an editor "Bewertung" from table "(Valuation):(Valuation)" with command "VIEW" for search criteria "$,,artikel=EINKAUF-1;@richtung=rückwärts;@maxtreffer=1"
Then field "nachfolger" is empty
And I close the current editor

# Lagerbuchungen stornieren
Given I open an editor "LbuchungStorno" from table "(ManualStockAdjustment):(ManualStockAdjustment)" with command "REVERSAL" for record from editor "LBuchungA"
And I set field "beleg" to "Abgang06"

Then field "buart" has value "Abgang"
Then table has values
	| mge	| verw			| platz	|
	| -20	| Zugangsverw2	| F1	|
And I save the current editor

# LJ prüfen
Given I open the infosystem "LJ"
And I set field "richtung" to "rückwärts"
And I set field "beleg" to "Abgang06"
And I press start
Then table has values	
	| amge		| verw			| verwla		| detursache					|
	| -10		| Zugangsverw2	| 				| Storno manuelle Lagerbuchung	|
	| -10		| Zugangsverw2	| Zugangsverw2	| Storno manuelle Lagerbuchung	|
Then table has values
	| !row	| storniert	|
	| 3		| ja		|
	| 4		| ja		|
Then field "stornolj^id" in row 1 has value equal to field "verweis^id" from editor "LJ" in row 3
Then field "stornolj^id" in row 2 has value equal to field "verweis^id" from editor "LJ" in row 4
And I close the current editor

# Lagerbestand prüfen
Given I open the infosystem "BESTAND"
And I set fields
	| artikel		| EINKAUF-1	|
	| klplatz		| F1		|
	| verdichten	| nein		|
	| details       | nein      |
And I press start
And I press button "taufzu" in row 1
Then table has values
	| !row	| gebmge	| verw			|
	| 2		| 10		| Zugangsverw2	|
	| 3		| 10		|				|
And I close the current editor

# Bewertung hat Nachfolger bekommen
And I switch the current editor to editor "Bewertung" with command "VIEW"
Then field "nachfolger" is not empty
And I close the current editor


Scenario Outline: 08 Lohnfertigung mit gefülltem lffert
# Lohnfertigungsartikel anlegen/ Bestand auf 0 korrigieren
Given I open an editor "A-LOHNF" from table "(Part):(Product)" with command "STORE" for record "A-LOHNF"
And I set fields
	| such		| A-LOHNF		|
	| namebspr	| Lohnfertigung	|
	| bsart		| Lohnfertigung	|
And I save the current editor
Given I set StorageQuantity to zero for Product "A-LOHNF" on StorageLocation "F1"

# Lagerbuchungen buchen
Given I open an editor "LBuchung" for tip command "LBuchung" and arguments ""
And I set fields
	| artikel	| A-LOHNF	|
	| buart		| <buart>	|
	| beleg		| <beleg>	|
	| beldat	| .			|
And I append rows
	| mge	| platz		| platz2	| lffert	|
	| <mge>	| <platz>	| <platz2>	| <lffert>	|
And I save the current editor

# Bewertung Lagerbuchung
Given I open an editor "Bewertung" from table "(Valuation):(Valuation)" with command "VIEW" for search criteria "$,,artikel=A-LOHNF;@richtung=rückwärts;@maxtreffer=1"
Then field "nachfolger" is empty
And I close the current editor

# Lagerbuchungen stornieren
Given I open an editor "LbuchungStorno" from table "(ManualStockAdjustment):(ManualStockAdjustment)" with command "REVERSAL" for record from editor "LBuchung"
And I set field "beleg" to "<beleg>"

Then field "buart" has value "<buart>"
Then table has values
	| mge		| platz		| platz2	| lffert	| 
	| <smge>	| <platz>	| <platz2>	| <lffert>	|
And I save the current editor

# LJ prüfen
Given I open the infosystem "LJ"
And I set field "richtung" to "rückwärts"
And I set field "beleg" to "<beleg>"
And I press start
Then table has values	
	| amge		| zmge		| fert		| nplatz	| vplatz	| detursache					|
	| <amge>	| <zmge>	| <lffert>	| <platz2>	| <platz>	| Storno manuelle Lagerbuchung	|
Then table has values
	| !row	| storniert	|
	| 2		| ja		|
Then field "stornolj^id" in row 1 has value equal to field "verweis^id" from editor "LJ" in row 2
And I close the current editor

# Lagerbestand prüfen
Given I open the infosystem "BESTAND"
And I set fields
	| artikel		| A-LOHNF	|
	| klplatz		| F1		|
	| verdichten	| ja		|
	| details       | nein      |
And I press start
Then field "lemge" has value "<bestand>" in row 1
And I close the current editor

# Bewertung hat Nachfolger bekommen
And I switch the current editor to editor "Bewertung" with command "VIEW"
Then field "nachfolger" is not empty
And I close the current editor

Examples:
| buart		| beleg		| bestand	| mge	| lffert	| platz			| platz2		| smge	| amge	| zmge	| 
| Zugang	| LB01-Z	| 			| 10	| BAUGRUPPE	| !dontChange	| F1			| -10	| 		| -10	| 
| Abgang	| LB01-A	| 			| 10	| BAUGRUPPE	| F1			| !dontChange	| -10	| -10	|		|


Scenario Outline: 09 Lohnfertigung mit gefülltem lffert - Umbuchung
# Lohnfertigungsartikel anlegen/ Lagerbestand auf 0 korrigieren
Given I open an editor "A-LOHNF" from table "(Part):(Product)" with command "STORE" for record "A-LOHNF"
And I set fields
	| such		| A-LOHNF		|
	| namebspr	| Lohnfertigung	|
	| bsart		| Lohnfertigung	|
And I save the current editor
Given I set StorageQuantity to zero for Product "A-LOHNF" on StorageLocation "F1"

# Lagerbuchung buchen
Given I open an editor "LBuchung" for tip command "LBuchung" and arguments ""
And I set fields
	| artikel	| A-LOHNF	|
	| buart		| <buart>	|
	| beleg		| <beleg>	|
	| beldat	| .			|
And I append rows
	| mge	| platz		| platz2	| lffert	| lffert2	|
	| <mge>	| <platz>	| <platz2>	| <lffert>	| <lffert2>	|
And I save the current editor

# Bewertung Lagerbuchung
Given I open an editor "Bewertung" from table "(Valuation):(Valuation)" with command "VIEW" for search criteria "$,,artikel=A-LOHNF;@richtung=rückwärts;@maxtreffer=1"
Then field "nachfolger" is empty
And I close the current editor

# Lagerbuchungen stornieren
Given I open an editor "LbuchungStorno" from table "(ManualStockAdjustment):(ManualStockAdjustment)" with command "REVERSAL" for record from editor "LBuchung"
And I set field "beleg" to "<beleg>"

Then field "buart" has value "<buart>"
Then table has values
	| mge		| platz		| platz2	| lffert	| lffert2	|
	| <smge>	| <platz>	| <platz2>	| <lffert>	| <lffert2>	|
And I save the current editor

# LJ prüfen
Given I open the infosystem "LJ"
And I set field "richtung" to "rückwärts"
And I set field "beleg" to "<beleg>"
And I press start
Then table has values	
	| amge		| zmge		| fert		| nplatz	| vplatz	| detursache					|
	| 			| <zmge>	| <lffert2>	| <platz2>	| 			| Storno manuelle Umbuchung	|
	| <amge2>	| 			| <lffert>	|			| <platz>	| Storno manuelle Umbuchung	|
Then table has values
	| !row	| storniert	|
	| 3		| ja		|
	| 4		| ja		|
Then field "stornolj^id" in row 1 has value equal to field "verweis^id" from editor "LJ" in row 3
And I close the current editor

# Lagerbestand prüfen
Given I open the infosystem "BESTAND"
And I set fields
	| artikel		| A-LOHNF	|
	| klplatz		| F1		|
	| verdichten	| ja		|
	| details       | nein      |
And I press start
Then field "lemge" has value "<bestand>" in row 1
And I close the current editor

# Bewertung hat Nachfolger bekommen
And I switch the current editor to editor "Bewertung" with command "VIEW"
Then field "nachfolger" is not empty
And I close the current editor

Examples:
| buart		| beleg		| bestand	| mge	| lffert	| lffert2		| platz	| platz2	| smge	| zmge	| amge2	|
| Umbuchung	| LB01-Z	| 			| 10	| BAUGRUPPE	| BAUGRUPPE		| F1	| F2		| -10	| -10	| -10	|
| Umbuchung	| LB01-Z	| 			| 10	| BAUGRUPPE	| M_BAUGRUPPE	| F1	| F2		| -10	| -10	| -10	|
