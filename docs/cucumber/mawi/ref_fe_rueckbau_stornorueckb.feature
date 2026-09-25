# *****************************************************************************
#  Name             : ref_fe_rueckbau_stornorueckb.feature
#  Autor            : lschneider/uo
#  Verantwortlich   : carue
#  Kontrolle        : ak
#  Funktion         : Testet die Platzmengen bei Rueckbau und Storno Rueckbau
#
# *****************************************************************************
@persistent
Feature: ref_fe_rueckbau_stornorueckb.feature

Background:
And I set the fake date to "03.02.1995"

#############################################################################
# aus std/test/cucumber/Fertigung_LJ/fertigung_storno.feature
Scenario: 6 Fall SR1 Storno eines Rueckbaus
# LJ, Prodlist und gebuchte RM zur ID von RM1_FallSR1 
#############################################################################
And I set the fake date to "28.02.1995"

Given I set StorageQuantity to zero for Product "EINKAUF-1" on StorageLocation "F1" with document "SCEN01"
Given I set StorageQuantity to zero for Product "BG3-LOHNGRUPPE" on StorageLocation "F1" with document "SCEN01"

# Bestandskorrektur: fuer eine einfachere spaetere Platzmengenkontrolle
Given I open an editor "Bestandskorrektur" for tip command "LBestand" and arguments ""
And I set fields
	| artikel	| EINKAUF-1	|
	| beleg		| storb		|
	| beldat	| .			|
And I set field "platz" to "F1" in row 1
And I modify table
	| !row			| mge	|
	| platz=="F1"	| 1000	|
And I save the current editor


And I append "--- in dieser ref-datei werden die absolutbestaende des artikels an 4 prozesszeitpunkten ausgegeben --- HIER KEINE SPIEGELBETRACHTUNG ---" to output file "ref_fe_rueckbau_stornorueckb.STORNRB_001.ref" in cucu_refs_dir

And I append "bestand ueber die gesetzten 1000 stk. vor return/rueckbau sicherstellen:" to output file "ref_fe_rueckbau_stornorueckb.STORNRB_001.ref" in cucu_refs_dir
And I export "bewertungslagermengen1" from StorageQuantities where "artikel==EINKAUF-1;gebmge<>0" to output file "ref_fe_rueckbau_stornorueckb.STORNRB_001.ref"
And I append "----" to output file "ref_fe_rueckbau_stornorueckb.STORNRB_001.ref" in cucu_refs_dir

Given I query "bewertungslagermengen1" from StorageQuantities where "artikel==BG3-LOHNGRUPPE;gebmge<>0"
Then StorageQuantity is zero

# 01 FV anlegen für BG mit 3 AGs und freigeben
Given I open an editor "fvor_FallSR1" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
And I append rows
    | artikel        | netmge     | bisuch    | mfreig    |
    | BG3-LOHNGRUPPE | 100        | STORNRB_    | ja        |
And I press button "freig" to open a subeditor for "BA_freigeben"
And I close the current editor
And I switch the current editor to editor "fvor_FallSR1"
And I save the current editor
##############################################
# 02 Dispo  starten
And I run Scheduling
##############################################
# 03 RM auf ersten Arbeitsgang über volle Menge
Given I open an editor "RM1_FallSR1" from table "(Workorder):(WorkOrders)" with command "DONE" for record "STORNRB_001"
And I set fields
    | sofort    | ja         |
    | gut       | ja        | 
And I save the current editor 


And I append "bestand nach RM:" to output file "ref_fe_rueckbau_stornorueckb.STORNRB_001.ref" in cucu_refs_dir
And I export "bewertungslagermengen1" from StorageQuantities where "artikel==EINKAUF-1;gebmge<>0;" to output file "ref_fe_rueckbau_stornorueckb.STORNRB_001.ref"
And I append "----" to output file "ref_fe_rueckbau_stornorueckb.STORNRB_001.ref" in cucu_refs_dir

Given I query "bewertungslagermengen1" from StorageQuantities where "artikel==BG3-LOHNGRUPPE;gebmge<>0;"
Then StorageQuantity is zero

##############################################
# 04 Rückbau auf ersten Arbeitsgang um 20 Einheiten
Given I open an editor "RB1_FallSR1" from table "(Workorder):(WorkOrders)" with command "RETURN" for record "STORNRB_001"
And I set field "sofort" to "ja"
And I set field "gutmge" to "-20" in row 1
And I save the current editor
##############################################

And I append "bestand nach return/rueckbau -20 gutmge:" to output file "ref_fe_rueckbau_stornorueckb.STORNRB_001.ref" in cucu_refs_dir
And I export "bewertungslagermengen1" from StorageQuantities where "artikel==EINKAUF-1;gebmge<>0;" to output file "ref_fe_rueckbau_stornorueckb.STORNRB_001.ref"
And I append "----" to output file "ref_fe_rueckbau_stornorueckb.STORNRB_001.ref" in cucu_refs_dir

Given I query "bewertungslagermengen1" from StorageQuantities where "artikel==BG3-LOHNGRUPPE;gebmge<>0;"
Then StorageQuantity is zero

# 05 Diese Rückbau stornieren
Given I open an editor "Storno1_FallSR1" via ID from editor "RB1_FallSR1" from field "id" in row 0 for table "(Workorder):(CompletionConfirmations)" with command "REVERSAL" 
And I save the current editor
Then field "stornopartnervorg^id" has value equal to field "id" from editor "RB1_FallSR1" in row 0
Then field "typa279" has value "Storno-Rückbau auf Betriebsauftrag"


And I append "bestand nach Storno return/rueckbau sicherstellen:" to output file "ref_fe_rueckbau_stornorueckb.STORNRB_001.ref" in cucu_refs_dir
And I export "bewertungslagermengen1" from StorageQuantities where "artikel==EINKAUF-1;gebmge<>0;" to output file "ref_fe_rueckbau_stornorueckb.STORNRB_001.ref"

Given I query "bewertungslagermengen1" from StorageQuantities where "artikel==BG3-LOHNGRUPPE;gebmge<>0;"
Then StorageQuantity is zero


##############################################
# 06 LJ für Rückmeldung auf ersten AG auswerten
Given I open the infosystem "LJ"
And I set field "beleg" to "nummer" from editor "RM1_FallSR1"
And I press start
Then table has values
    | art           | zmge  | amge   |detursache                     | 
    | EINKAUF-1     |       | 200    |Rückmeldung Fertigung          |
    | EINKAUF-1     |       | -40    |Rückbau Fertigung              |
    | EINKAUF-1     |       |  40    |Storno-Rückbau Fertigung       |
And I close the current editor
Given I open the infosystem "LJ"
And I set field "beleg" to "nummer" from editor "RM1_FallSR1"
And I set field "umlag" to "ja"
And I press start
Then the table has 0 rows
Given I open the infosystem "LJ"
And I set field "beleg" to "nummer" from editor "RM1_FallSR1"
And I set field "kdetursache" to "Storno-Rückbau Fertigung"
And I press start
Then table has values
    | art           | zmge  | amge   |detursache                     | 
    | EINKAUF-1     |       |  40    |Storno-Rückbau Fertigung       |
And I close the current editor

# LJ prüfen
And I append "alle LJ zu STORNRB_001 (zur Sortierung s. Feldliste und MawiSteps.java)" to output file "ref_fe_rueckbau_stornorueckb.lj.STORNRB_001.ref" in cucu_refs_dir
And I export "ljfeldliste1" from StockMovementJournal where "vorgang^such=STORNRB_001!STORNRB_001" to output file "ref_fe_rueckbau_stornorueckb.lj.STORNRB_001.ref"

########################################################################################
Scenario: 13 Rückbau zu Rückmeldung mit Material aus zwei Zugängen; Joker und Verwendung


# Bestände korrigieren
Given I set StorageQuantity to zero for Product "BAUGRUPPE" on StorageLocation "F1"
Given I set StorageQuantity to zero for Product "EINKAUF-1" on StorageLocation "F1" with document "B_SCEN13"
Given I set StorageQuantity to zero for Product "EINKAUF-2" on StorageLocation "F1"

# Auftrag anlegen und Hälfte der Bedarfe einkaufen (Verwendung)
Given I create a SalesOrder "auftrag13" for Customer "RADSHOP" with Product "BAUGRUPPE" and quantity "60"
Given I open an editor "RechnungmL" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set fields
	| lief		| KETTLER	|
	| vom		| .			|
	| fakt		| ja		|
	| ebeleg	| 13R		|
	| ueb		| ja		|
And I append rows
	| artikel	| mge	| 
	| EINKAUF-1	| 60	|
	| EINKAUF-1	| 60	|
	| EINKAUF-2	| 60	|
And I set field "verw" in row 1 to "verw" from editor "auftrag13" in row 1
And I set field "verw" in row 2 to "nummer" from editor "auftrag13" in row 0
And I set field "verw" in row 3 to "verw" from editor "auftrag13" in row 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor
And I run Scheduling
	
# Fertigungsvorschlag freigeben
Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
And I append rows
	| artikel	| mge	| bisuch	| mfreig	|
	| BAUGRUPPE	| 60	| JOKER_	| ja		|
And I set field "verw" in row !lastRow to "verw" from editor "auftrag13" in row 1
And I press button "freig" to open a subeditor for "BA_freigeben"
And I close the current editor
And I switch the current editor to editor "fvor"
And I save the current editor
And I run Scheduling

# Rückmeldung1 auf ersten Arbeitsgang
Given I open an editor "Rückmeldung1" from table "(Workorder):(WorkOrders)" with command "DONE" for record "JOKER_001"
And I set fields
	| sofort	| ja	|
And I set field "gutmge" to "50" in row 1
And I set field "erbtext1" to "Rückmeldung1" in row 1
And I save the current editor

# bestände auf 0 bringen, WICHTIG FÜR SPIEGELBILDLICHEN VERGLEICH, s. dazu in der storno-feature-datei
Given I set StorageQuantity to zero for Product "BAUGRUPPE" on StorageLocation "F1" with document "B_SCEN132"
Given I set StorageQuantity to zero for Product "EINKAUF-1" on StorageLocation "F1" with document "B_SCEN132"
Given I set StorageQuantity to zero for Product "EINKAUF-2" on StorageLocation "F1" with document "B_SCEN132"

# sicher keine bestände mehr!
Given I query "bewertungslagermengen1" from StorageQuantities where "artikel==EINKAUF-1;gebmge<>0;"
Then StorageQuantity is zero
Given I query "bewertungslagermengen1" from StorageQuantities where "artikel==EINKAUF-2;gebmge<>0;"
Then StorageQuantity is zero
Given I query "bewertungslagermengen1" from StorageQuantities where "artikel==BAUGRUPPE;gebmge<>0;"
Then StorageQuantity is zero

# Rückbau1 zu Betriebsauftrag  JOKER_001
Given I open an editor "Rückbau1" from table "(Workorder):(WorkOrders)" with command "RETURN" for record "JOKER_001"
And I set fields
	| sofort	| ja	|
And I set field "gutmge" to "-45" in row 1
And I set field "erbtext1" to "Rückbau1" in row 1
And I save the current editor


And I append "bestand nach return/rueckbau -45 gutmge:" to output file "ref_fe_rueckbau_stornorueckb.JOKER_001.ref" in cucu_refs_dir
And I append "vor dem return/rueckbau waren die bestaende der artikel == 0" to output file "ref_fe_rueckbau_stornorueckb.JOKER_001.ref" in cucu_refs_dir
And I export "bewertungslagermengen1" from StorageQuantities where "artikel==EINKAUF-1;gebmge<>0;" to output file "ref_fe_rueckbau_stornorueckb.JOKER_001.ref"
And I append "----" to output file "ref_fe_rueckbau_stornorueckb.JOKER_001.ref" in cucu_refs_dir

And I export "bewertungslagermengen1" from StorageQuantities where "artikel==EINKAUF-2;gebmge<>0;" to output file "ref_fe_rueckbau_stornorueckb.JOKER_001.ref"
And I append "----" to output file "ref_fe_rueckbau_stornorueckb.JOKER_001.ref" in cucu_refs_dir

And I export "bewertungslagermengen1" from StorageQuantities where "artikel==BAUGRUPPE;gebmge<>0;" to output file "ref_fe_rueckbau_stornorueckb.JOKER_001.ref"
And I append "----" to output file "ref_fe_rueckbau_stornorueckb.JOKER_001.ref" in cucu_refs_dir


# Lagerbewegungsjournal prüfen
Given I open the infosystem "LJ"
And I set fields
	| adatum	| -10		|
	| edatum	| +30		|
	| richtung	| rückwärts	|
And I set field "beleg" to "barmex" from editor "Rückmeldung1"
And I press start
Then table has values
	| art		| zmge	| amge	| rueckmge	| restmge	| detursache			| !row	|
	| BAUGRUPPE	| -45	|		| -45		| 0			| Rückbau Fertigung		| 1		|
	| EINKAUF-1	| 		| -50	| -50		| 0			| Rückbau Fertigung		| 2		|
	| EINKAUF-1	| 		| -40	| -40		| 0			| Rückbau Fertigung		| 3		|
	| EINKAUF-2	|		| -45	| -45		| 0			| Rückbau Fertigung		| 4		|
	| BAUGRUPPE	| 50	|		| 45		| 5			| Rückmeldung Fertigung	| 5		|
	| EINKAUF-1	| 		| 40	| 40		| 0			| Rückmeldung Fertigung	| 6		|
	| EINKAUF-1	| 		| 60	| 50		| 10		| Rückmeldung Fertigung	| 7		|
	| EINKAUF-2	| 		| 50	| 45		| 5			| Rückmeldung Fertigung	| 8		|
# Jokerbestand wird durch Rückbau vollständig zurückgebucht
Then field "verwla" in row 3 has value equal to field "verw" from editor "RechnungmL" in row 2
# Restliche Rückbuchung Bestand mit eindeutiger  Verwendung
Then field "verwla" in row 2 has value equal to field "verw" from editor "RechnungmL" in row 1
And I close the current editor

# Lagerjournal prüfen
Given I open an editor "LJ_Rückbau1" from table "(Journal):(Journal)" with command "VIEW" for search criteria "$,,artikel=BAUGRUPPE;erbtext1=Rückbau1;@richtung=rückwärts;@maxtreffer=1"
Then fields have values
	| rueckmge		| -45	|
	| restmge		| 0		|
Then field "vorgang^id" has value equal to field "id" from editor "Rückbau1"
And I close the current editor

And I open an editor "LJ_Rückmeldung_Orig" via ID from editor "LJ_Rückbau1" from field "rueckorig" in row 0 for table "(Journal):(Journal)" with command "VIEW"
Then fields have values
	| mge			| 50	|
	| rueckmge		| 45	|
	| restmge		| 5		|
Then field "vorgang^id" has value equal to field "id" from editor "Rückmeldung1"
And I close the current editor

# Betriebsauftrag abschließen
Given I open an editor "Betriebsauftrag" from table "(Workorder):(WorkOrders)" with command "DONE" for record "JOKER_001"
And I set fields
	| gut		| ja	|
	| sofort	| ja	|
And I save the current editor
And I deliver the SalesOrder "auftrag13" with PackingSlip "LS-13"

# Bestände auf 0 bringen
Given I set StorageQuantity to zero for Product "BAUGRUPPE" on StorageLocation "F1" with document "B_SCEN134s"
Given I set StorageQuantity to zero for Product "EINKAUF-1" on StorageLocation "F1" with document "B_SCEN134s"
Given I set StorageQuantity to zero for Product "EINKAUF-2" on StorageLocation "F1" with document "B_SCEN134s"

# sicher keine bestände mehr!
Given I query "bewertungslagermengen1" from StorageQuantities where "artikel==EINKAUF-1;gebmge<>0;"
Then StorageQuantity is zero
Given I query "bewertungslagermengen1" from StorageQuantities where "artikel==EINKAUF-2;gebmge<>0;"
Then StorageQuantity is zero
Given I query "bewertungslagermengen1" from StorageQuantities where "artikel==BAUGRUPPE;gebmge<>0;"
Then StorageQuantity is zero

# such==JOKER_001
Given I open an editor "Storno1_32xx" from table "(Workorder):(CompletionConfirmations)" with command "REVERSAL" for search criteria "$,,such==JOKER_001;gutmge<0;@richtung=rückwärts;@ablageart=abgelegt"
And I save the current editor

And I append "diese datei muss den spiegelbildlichen bestand zur nach.return-ref-datei enthalten:" to output file "ref_fe_rueckbau_stornorueckb.JOKER_001.ref" in cucu_refs_dir
And I append "bestand nach storno return/rueckbau:" to output file "ref_fe_rueckbau_stornorueckb.JOKER_001.ref" in cucu_refs_dir

And I export "bewertungslagermengen1" from StorageQuantities where "artikel==EINKAUF-1;gebmge<>0;" to output file "ref_fe_rueckbau_stornorueckb.JOKER_001.ref"
And I append "----" to output file "ref_fe_rueckbau_stornorueckb.JOKER_001.ref" in cucu_refs_dir

And I export "bewertungslagermengen1" from StorageQuantities where "artikel==EINKAUF-2;gebmge<>0;" to output file "ref_fe_rueckbau_stornorueckb.JOKER_001.ref"
And I append "----" to output file "ref_fe_rueckbau_stornorueckb.JOKER_001.ref" in cucu_refs_dir

And I export "bewertungslagermengen1" from StorageQuantities where "artikel==BAUGRUPPE;gebmge<>0;" to output file "ref_fe_rueckbau_stornorueckb.JOKER_001.ref"
And I append "----" to output file "ref_fe_rueckbau_stornorueckb.JOKER_001.ref" in cucu_refs_dir

# LJ prüfen
And I append "alle LJ zu JOKER_001 (zur Sortierung s. Feldliste und MawiSteps.java)" to output file "ref_fe_rueckbau_stornorueckb.lj.JOKER_001.ref" in cucu_refs_dir
And I export "ljfeldliste1" from StockMovementJournal where "vorgang^such=JOKER_001!JOKER_001" to output file "ref_fe_rueckbau_stornorueckb.lj.JOKER_001.ref"


################################################################################################
#  aus std/test/cucumber/fertigung_bde/BC2_RUECKBAU_Fertigung_Rueckmeldungen_Prozesstests.feature
# FDA-890: Bei der Rückgabe von Chargen wird in Rückmeldung in rueckmge und restmge nur eine Charge berücksichtigt
Scenario Outline: 14 A Rückbau zu Rückmeldung mit Gutmenge mit Charge und ohne Zeitbuchung, Material aus einem Zugang
################################################################################################

# Chargen anlegen
Given I open an editor "<such>" from table "(Lots):(Lots)" with command "STORE" for record "<such>"
And I set fields
	| such		| <such>	|
	| chname	| <chname>	|
	| artikel	| <artikel>	|
	| lief		| <lief>	|
And I save the current editor

Examples:
| such			| chname | artikel		| lief		|
| B_MATERIAL1	| 6677	 | B_EINKAUF-1	| KETTLER	|
| B_MATERIAL2	| 6678	 | B_EINKAUF-1	| KETTLER	|
| B_BG1			| 991	 | B_BAUGRUPPE	| 			|
| B_BG2			| 991	 | B_BAUGRUPPE	| 			|

################################################################################################
#  aus std/test/cucumber/fertigung_bde/BC2_RUECKBAU_Fertigung_Rueckmeldungen_Prozesstests.feature
Scenario: 14 B Rueckbau zu Rueckmeldung mit Gutmenge mit Charge und ohne Zeitbuchung, Material aus einem Zugang
################################################################################################

# Auftrag anlegen und # Bedarfe einkaufen
Given I create a SalesOrder "auftrag14" for Customer "RADSHOP" with Product "B_BAUGRUPPE" and quantity "50"

Given I open an editor "RechnungLager" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set fields
	| lief		| KETTLER	|
	| vom		| .			|
	| ebeleg	| Rückbau1	|
	| ueb		| ja		| 
	| fakt		| ja		|
And I append rows
| artikel 		| mge	| charge		|
| B_EINKAUF-1	| 60	| B_MATERIAL1	|
| B_EINKAUF-1	| 40	| B_MATERIAL2	|
| B_EINKAUF-2	| 50	|				|
And I set field "verw" in row 1 to "verw" from editor "auftrag14" in row 1
And I set field "verw" in row 2 to "verw" from editor "auftrag14" in row 1
And I set field "verw" in row 3 to "verw" from editor "auftrag14" in row 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# Fertigungsvorschlag anlegen und freigeben
Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
And I append rows
	| artikel		| netmge	| mfreig	| 
	| B_BAUGRUPPE	| 50		| ja		|
And I press button "mzsubm" to open a subeditor for "MZFertig" in row 1
And I delete all rows
And I append rows
	| zuomge	| charge	|
	| 10		| B_BG1		|
	| 25		| B_BG2		|
	| 15		|			|
And I save the current editor
And I switch the current editor to editor "fvor"
And I press button "mzabsm" to open a subeditor for "MZMaterial" in row 1
And I delete all rows
And I append rows
	| zuomge	| charge		|
	| 60		| B_MATERIAL1	|
	| 40		| B_MATERIAL2	|
And I save the current editor
And I switch the current editor to editor "fvor"
And I set field "bisuch" to "CHRUECKBAU_" in row 1
And I press button "freig" to open a subeditor for "BA_freigeben"
And I close the current editor
And I switch the current editor to editor "fvor"
And I save the current editor
And I run Scheduling

# Rückmeldung auf ersten Arbeitsgang
Given I open an editor "Rückmeldung1" from table "(Workorder):(WorkOrders)" with command "DONE" for record "CHRUECKBAU_001"
And I set fields
	| sofort	| ja	|
And I set field "gutmge" to "40" in row 1
And I set field "erbtext1" to "Rückmeldung1" in row 1
And I save the current editor


# Bestandskorrektur B_BAUGRUPPE: für eine einfachere spätere platzmengenkontrolle
Given I open an editor "Bestandskorrektur" for tip command "LBestand" and arguments ""
And I set fields
	| artikel	| B_BAUGRUPPE	|
	| beleg		| chrueckb01	|
	| beldat	| .			|
And I set field "platz" to "F1" in row 1
Then the table has 3 rows
And I modify table
	| !row	| mge	|
	| 1	    |   0	|
	| 2	    |   0	|
	| 3	    |   0	|
And I save the current editor
Given I set StorageQuantity to zero for Product "B_EINKAUF-1" on StorageLocation "F1" with document "chrueckb01"
Given I set StorageQuantity to zero for Product "B_EINKAUF-2" on StorageLocation "F1" with document "chrueckb01"

# ausgangszustand VOR return 
# sicher keine bestände mehr!
Given I query "bewertungslagermengen1" from StorageQuantities where "artikel==B_EINKAUF-1;gebmge<>0;"
Then StorageQuantity is zero
Given I query "bewertungslagermengen1" from StorageQuantities where "artikel==B_EINKAUF-2;gebmge<>0;"
Then StorageQuantity is zero
Given I query "bewertungslagermengen1" from StorageQuantities where "artikel==B_BAUGRUPPE;gebmge<>0;"
Then StorageQuantity is zero

# Rückbau1 zu Betriebsauftrag  CHRUECKBAU_001
Given I open an editor "Rückbau1" from table "(Workorder):(WorkOrders)" with command "RETURN" for record "CHRUECKBAU_001"
And I set fields
	| sofort	| ja	|
And I set field "gutmge" to "-10" in row 1
And I set field "charge" to "B_BG1" in row 1
And I set field "erbtext1" to "Rückbau1" in row 1
And I save the current editor

# Rückbau2 zu Betriebsauftrag  CHRUECKBAU_001
Given I open an editor "Rückbau1" from table "(Workorder):(WorkOrders)" with command "RETURN" for record "CHRUECKBAU_001"
And I set fields
	| sofort	| ja	|
And I set field "gutmge" to "-25" in row 1
And I set field "charge" to "B_BG2" in row 1
And I set field "erbtext1" to "Rückbau1" in row 1
And I save the current editor

# Prüfausgabe return
And I append "bestand nach return/rueckbau -35 gutmenge:" to output file "ref_fe_rueckbau_stornorueckb.CHRUECKBAU_001.ref" in cucu_refs_dir
And I append "vor dem return/rueckbau waren die bestaende der artikel == 0" to output file "ref_fe_rueckbau_stornorueckb.CHRUECKBAU_001.ref" in cucu_refs_dir

And I export "bewertungslagermengen1" from StorageQuantities where "artikel==B_EINKAUF-1;gebmge<>0;" to output file "ref_fe_rueckbau_stornorueckb.CHRUECKBAU_001.ref"
And I append "----" to output file "ref_fe_rueckbau_stornorueckb.CHRUECKBAU_001.ref" in cucu_refs_dir

And I export "bewertungslagermengen1" from StorageQuantities where "artikel==B_EINKAUF-2;gebmge<>0;" to output file "ref_fe_rueckbau_stornorueckb.CHRUECKBAU_001.ref"
And I append "----" to output file "ref_fe_rueckbau_stornorueckb.CHRUECKBAU_001.ref" in cucu_refs_dir

And I export "bewertungslagermengen1" from StorageQuantities where "artikel==B_BAUGRUPPE;gebmge<>0;" to output file "ref_fe_rueckbau_stornorueckb.CHRUECKBAU_001.ref"
And I append "----" to output file "ref_fe_rueckbau_stornorueckb.CHRUECKBAU_001.ref" in cucu_refs_dir

# --- SONDERAUSGABE: hier nur test indiv. steps. - kein inhalt. prozesstest
And I append "" to output file "ref_fe_rueckbau_stornorueckb.spez.indiv.exportstep.feldlisten.fuer.lj.ref" in cucu_refs_dir
And I append "--- es muessen ca. 1-5 zeilen folgen --- die LJ ohne zeilen --- test indiv. step ohne zeilenausgabe zu CHRUECKBAU_001" to output file "ref_fe_rueckbau_stornorueckb.spez.indiv.exportstep.feldlisten.fuer.lj.ref" in cucu_refs_dir
And I append "--- genaue Zeilenangaben sind sinnlos, die gehen immer kaputt" to output file "ref_fe_rueckbau_stornorueckb.spez.indiv.exportstep.feldlisten.fuer.lj.ref" in cucu_refs_dir
And I export "ljfeldliste0_oh_zei" from StockMovementJournal where "vorgang^such=CHRUECKBAU_001!CHRUECKBAU_001" to output file "ref_fe_rueckbau_stornorueckb.spez.indiv.exportstep.feldlisten.fuer.lj.ref"
And I append "--- es muessen ca. 15-25 zeilen folgen --- die LJ mit zeilen --- test indiv. step MIT zeilenausgabe zu CHRUECKBAU_001" to output file "ref_fe_rueckbau_stornorueckb.spez.indiv.exportstep.feldlisten.fuer.lj.ref" in cucu_refs_dir
And I append "--- genaue Zeilenangaben sind sinnlos, die gehen immer kaputt" to output file "ref_fe_rueckbau_stornorueckb.spez.indiv.exportstep.feldlisten.fuer.lj.ref" in cucu_refs_dir
And I export "ljfeldliste2_mit_zei" from StockMovementJournal where "vorgang^such=CHRUECKBAU_001!CHRUECKBAU_001" to output file "ref_fe_rueckbau_stornorueckb.spez.indiv.exportstep.feldlisten.fuer.lj.ref"
# --- ENDE SONDERAUSGABE

# rueckmge und restmge in Rückbau und Rückmeldung prüfen
And I switch the current editor to editor "Rückbau1" with command "VIEW"
Then table has values
	| artikel		| rueckmge	| restmge	| bumge	| limgev	| limgen	|
	| B_BAUGRUPPE	| -25		| 0			| -25	| 30		| 5			|
	| B_EINKAUF-2	| -25		| 0			| -25	| 20		| 45		|
	| B_EINKAUF-1	| -50		| 0			| -50	| 40		| 90		|
And I close the current editor

# Lagerjournal prüfen
Given I open the infosystem "LJ"
And I set field "adatum" to "-10"
And I set field "edatum" to "+30"
And I set field "beleg" to "barmex" from editor "Rückbau1"
And I set field "richtung" to "rückwärts"
And I press start
Then table has values
	| art			| zmge	| amge	| rueckmge	| restmge	| vcharge^such	| ncharge^such	|
	| B_BAUGRUPPE	| -25	|		| -25		| 0			| 				| B_BG2			|
	| B_EINKAUF-1	|		| -40	| -40		| 0			| B_MATERIAL1	| B_BG2			|
	| B_EINKAUF-1	|		| -10	| -10		| 0			| B_MATERIAL2	| B_BG2			|
	| B_EINKAUF-2	|		| -25	| -25		| 0			|				| B_BG2			|
	| B_BAUGRUPPE	| -10	|		| -10		| 0			| 				| B_BG1			|
	| B_EINKAUF-1	|		| -20	| -20		| 0			| B_MATERIAL1	| B_BG1			|
	| B_EINKAUF-2	|		| -10	| -10		| 0			|				| B_BG1			|
	| B_BAUGRUPPE	| 5		|		| 0			| 5			|				| 				|
	| B_BAUGRUPPE	| 25	|		| 25		| 0			|				| B_BG2			|
	| B_BAUGRUPPE	| 10	| 		| 10		| 0 		|				| B_BG1			|
	| B_EINKAUF-1	|		| 10	| 0			| 10		| B_MATERIAL2	| 				|
	| B_EINKAUF-1	|		| 10	| 10		| 0			| B_MATERIAL2	| B_BG2			|
	| B_EINKAUF-1	|		| 40	| 40		| 0 		| B_MATERIAL1	| B_BG2			|
	| B_EINKAUF-1	|		| 20	| 20		| 0 		| B_MATERIAL1	| B_BG1			|
	| B_EINKAUF-2	|		| 5  	| 0  		| 5			|				| 				|
	| B_EINKAUF-2	|		| 25  	| 25  		| 0			|				| B_BG2			|
	| B_EINKAUF-2	|		| 10  	| 10  		| 0			|				| B_BG1			|
And I close the current editor

# Lagerjournal-Einträge prüfen, Verweis auf Rückbau
Given I open an editor "LJ_Rückbau1" from table "(Journal):(Journal)" with command "VIEW" for search criteria "$,,artikel=B_BAUGRUPPE;ursache=Fertigung;mge=-25;@richtung=rückwärts;@maxtreffer=1"
Then fields have values
	| rueckmge		| -25	|
	| restmge		| 0		|
Then field "ncharge^such" has value "B_BG2" in row 1
Then field "vorgang^id" has value equal to field "id" from editor "Rückbau1"
And I close the current editor

And I open an editor "LJ_Rückmeldung_Orig" via ID from editor "LJ_Rückbau1" from field "rueckorig" in row 0 for table "(Journal):(Journal)" with command "VIEW"
Then fields have values
	| mge			| 25	|
	| rueckmge		| 25	|
	| restmge		| 0		|
Then field "ncharge^such" has value "B_BG2" in row 1
Then field "vorgang^id" has value equal to field "id" from editor "Rückmeldung1"
And I close the current editor



# Betriebsauftrag abschließen
Given I open an editor "Betriebsauftrag" from table "(Workorder):(WorkOrders)" with command "DONE" for record "CHRUECKBAU_001"
And I set fields
	| gut		| ja	|
	| sofort	| ja	|
And I save the current editor

And I switch the current editor to editor "auftrag14" with command "DELIVERY"
And I set fields
	| nummer| 63414	|
	| ueb	| ja	|
	| vom	| .		|
And I set field "mge" to "50" in row 1
And I press button "mzsubm" to open a subeditor for "MZ" in row 1
And I modify table
	| zuomge	| charge	| !row	|
	| 10		| B_BG1		| 1		|
	| 25		| B_BG2		| +2	|
	| 15		| 			| +3	|
And I save the current editor
And I switch the current editor to editor "auftrag14"
And I save the current editor



# Bestandskorrektur B_BAUGRUPPE: für eine einfachere spätere platzmengenkontrolle
Given I open an editor "Bestandskorrektur" for tip command "LBestand" and arguments ""
And I set fields
	| artikel	| B_BAUGRUPPE	|
	| beleg		| chrueckb01	|
	| beldat	| .			|
And I set field "platz" to "F1" in row 1
Then the table has 3 rows
And I modify table
	| !row	| mge	|
	| 1	    |   0	|
	| 2	    |   0	|
	| 3	    |   0	|
And I save the current editor
Given I set StorageQuantity to zero for Product "B_EINKAUF-1" on StorageLocation "F1" with document "chrueckb01"
Given I set StorageQuantity to zero for Product "B_EINKAUF-2" on StorageLocation "F1" with document "chrueckb01"

# Ausgangszustand VOR storno.return 
# sicher keine Bestände mehr!
Given I query "bewertungslagermengen1" from StorageQuantities where "artikel==B_EINKAUF-1;gebmge<>0;"
Then StorageQuantity is zero
Given I query "bewertungslagermengen1" from StorageQuantities where "artikel==B_EINKAUF-2;gebmge<>0;"
Then StorageQuantity is zero
Given I query "bewertungslagermengen1" from StorageQuantities where "artikel==B_BAUGRUPPE;gebmge<>0;"
Then StorageQuantity is zero


# Prüfausgabe Platzmengen
And I append "diese datei muss den spiegelbildlichen bestand zur nach.return-ref-datei enthalten:" to output file "ref_fe_rueckbau_stornorueckb.CHRUECKBAU_001.ref" in cucu_refs_dir
And I append "bestand nach storno return/rueckbau:" to output file "ref_fe_rueckbau_stornorueckb.CHRUECKBAU_001.ref" in cucu_refs_dir
And I export "bewertungslagermengen1" from StorageQuantities where "artikel==B_EINKAUF-1;gebmge<>0;" to output file "ref_fe_rueckbau_stornorueckb.CHRUECKBAU_001.ref"
And I append "----" to output file "ref_fe_rueckbau_stornorueckb.CHRUECKBAU_001.ref" in cucu_refs_dir

And I export "bewertungslagermengen1" from StorageQuantities where "artikel==B_EINKAUF-2;gebmge<>0;" to output file "ref_fe_rueckbau_stornorueckb.CHRUECKBAU_001.ref"
And I append "----" to output file "ref_fe_rueckbau_stornorueckb.CHRUECKBAU_001.ref" in cucu_refs_dir

And I export "bewertungslagermengen1" from StorageQuantities where "artikel==B_BAUGRUPPE;gebmge<>0;" to output file "ref_fe_rueckbau_stornorueckb.CHRUECKBAU_001.ref"
And I append "----" to output file "ref_fe_rueckbau_stornorueckb.CHRUECKBAU_001.ref" in cucu_refs_dir

# LJ prüfen
And I append "alle LJ zu CHRUECKBAU_001 (zur Sortierung s. Feldliste und MawiSteps.java)" to output file "ref_fe_rueckbau_stornorueckb.lj.CHRUECKBAU_001.ref" in cucu_refs_dir
And I export "ljfeldliste1" from StockMovementJournal where "vorgang^such=CHRUECKBAU_001!CHRUECKBAU_001" to output file "ref_fe_rueckbau_stornorueckb.lj.CHRUECKBAU_001.ref"

