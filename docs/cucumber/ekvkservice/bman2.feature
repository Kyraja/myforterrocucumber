# *****************************************************************************
#  Name           : bman2.feature
#  Autor          : mibr
#  Verantwortlich : teampss
#  Funktion       : Testet Behaelterkontenverwaltung.
#                   Nachfolgetest zu ref_bman1_cu
#
# *****************************************************************************
#
Feature: Behaelterkontenverwaltung
Background:
Given I set the fake date to "02.01.1995"

# ----------------------------------------------------------------------------------------------
Scenario: Stammdaten Fremdeigentums-Lagerplatz
# ----------------------------------------------------------------------------------------------
Given I open an editor "Lagergruppe" from table "(Warehouse):(WarehouseGroup)" with command "STORE" for record "FREMDLG"
And I set field "such" to "FREMDLG"
And I set field "namebspr" to "XXX"
And I set field "zkonsilg" to "Ja"
And I save the current editor

Given I open an editor "Lager" from table "(Warehouse):(Warehouse)" with command "STORE" for record "FREMDLAGER"
And I set field "such" to "FREMDLAGER"
And I set field "lgruppe" to "FREMDLG"
And I save the current editor

Given I open an editor "Lagerplatz" from table "(Location):(Location)" with command "STORE" for record "FREMD1"
And I set field "such" to "FREMD1"
And I set field "lager" to "FREMDLAGER"
And I save the current editor

Given I open an editor "Lagerplatz" from table "(Location):(Location)" with command "STORE" for record "FREMD2"
And I set field "such" to "FREMD2"
And I set field "lager" to "FREMDLAGER"
And I save the current editor

# ----------------------------------------------------------------------------------------------
Scenario Outline: EDL-Umlagerung mit Behaelterkonto ohne Interner Lagergruppe
# ----------------------------------------------------------------------------------------------
# Bisher gab es nur Behaelterbuchungen, wenn eine interne Lagergruppe beiteiligt war.
# Bei EDL-LS sollen auch Umlagerungen von einer anderen externen LG fuer Behaelterbuchungen beruecksichtigt werden.

# Behaelterkonto 1270 Buchen bei EDL
Given I open an editor "bkonto" from table "(ContainerAccount):(ContainerAccount)" with command "UPDATE" for record "1270"
And I set fields
   | edlumbhbuchung | <edlumb> |
And I save the current editor

# Speditionsauftrag anlegen
Given I open an editor "spedauftrag" from table "(ShipOrder):(ShippingOrder)" with command "NEW" for record ""
And I set field "warenempf" to "301"
And I set field "edl" to "1"
And I save the current editor

#Lieferschein anlegen und buchen
Given I open an editor "lieferscheinEDL" from table "(Sales):(PackingSlip)" with command "NEW" for record ""
And I set field "kunde" to "301"
And I set field "umplatz" to "<umplatz>"
And I set field "edl" to "1"
And I set field "sped" to id from editor "spedauftrag"
And I set field "ueb" to "ja"
And I set field "such" to "EDL"
And I set field "nummer" to "<nummerls1>"
And I append rows
| artex  | mge | platz    |
| V1     | 15  | <lplatz> |
Then field "bhkto" has value "" in row 1
And I press button "packvor"
Then field "bhkto" has value "<bhkto1>" in row 2
And I save the current editor

# Pruefen, ob im Lieferschein das Behaelterkonto noch vorhanden ist
Given I open an editor "lieferscheinView" from table "(Sales):(PackingSlip)" with command "VIEW" for record from editor "lieferscheinEDL"
Then field "bhkto" has value "<bhkto1>" in row 2
And I close the current editor
# Entnahme LS erstellen
Given I open an editor "lieferscheinEntnahme" from table "(Sales):(PackingSlip)" with command "COPY" for record from editor "lieferscheinEDL"
And I set field "nummer" to "<nummerlsedl>"
And I set field "such" to "EDLENT"
And I press button "edlls"
And I press button "packvor"
And I set field "ueb" to "ja"
And I set field "mge" to "15" in row 1
And I respond with answer "Ja" to the dialog with id "8076"
And I save the current editor
# In diesem LS darf keine Behaelterbuchung sein (Skipfeld Behaelterkonto ist leer)
Given I open an editor "lieferscheinView" from table "(Sales):(PackingSlip)" with command "VIEW" for record from editor "lieferscheinEntnahme"
Then field "bhkto" has value "<bhkto2>" in row 2
And I close the current editor

# Hilfe bei der Fehlersuche:
# LJ                 : <(Journal)> %,nummer=;such==L460014;sucherw~/;artikel==;platz==;mge=;buarta==;@gruppe=1;@ablageart=(Active) <(View)>
# Behaelterbuchungen : <(ContainerAccounting)> %,nummer=;such==L460014;sucherw~/;@gruppe=1;@ablageart=(Active) <(View)>

Examples:
    | zeile | edlumb | umplatz | lplatz | nummerls1 | nummerlsedl | bhkto1 | bhkto2 |
    |     0 | ja     |    L3F2 |   L2F1 |    460002 |      460003 |   1270 |        |
    |     1 | ja     |    L3F2 |     F2 |    460004 |      460005 |   1270 |        |
    |     2 | nein   |    L3F2 |   L2F1 |    460006 |      460007 |        |   1270 |
    |     3 | nein   |    L3F2 |     F2 |    460008 |      460009 |        |   1270 |
    |     4 | ja     |  FREMD2 | FREMD1 |    460010 |      460011 |   1270 |        |
    |     5 | Nein   |  FREMD2 | FREMD1 |    460012 |      460013 |        |   1270 |
    |     6 | ja     |  FREMD2 |     F2 |    460014 |      460015 |   1270 |        |
    |     7 | Nein   |  FREMD2 |     F2 |    460016 |      460017 |        |   1270 |


# ----------------------------------------------------------------------------------------------
Scenario: bmanrep repariert Behaelterbuchungen in der Vergangenheit
# ----------------------------------------------------------------------------------------------
# Korrigiert alle abestand, bestand
#Aufrufbar fuer ein Kont oder fuer alle
#Ausgabe des Reparaturprogramms wird ebenfalls in das REF ausgegeben

# Behaelterkonto 1270 Buchen bei EDL zuruecksetzen
Given I open an editor "bkonto" from table "(ContainerAccount):(ContainerAccount)" with command "UPDATE" for record "1270"
And I set fields
   | edlumbhbuchung | nein |
And I save the current editor

Given I execute shell command "echo \"******************************************************************\" >> ref_bman2_cu.REF"
Given I execute shell command "echo \"Test Standalone Programm bmanburep zur Behaelterbunchungsreparatur\" >> ref_bman2_cu.REF"
Given I execute shell command "echo \"******************************************************************\" >> ref_bman2_cu.REF"
Given I execute shell command "echo \" \" >> ref_bman2_cu.REF"

# LS auf Behaelter BHKto 1000 in die Vergangenheit buchen
Given I set the fake date to "15.06.1995"
Given I open an editor "LBORGBREMREP1" from table "(Sales):(PackingSlip)" with command "NEW" for record ""
And I set fields
	| kunde     | 500           |
	| kl2       | 050           |
	| warenempf | 500           |
	| werk      | 001           |
	| ablstelle | 100           |
	| such      | LBORGBRE1     |
	| ueb       | ja            |
	| vom       | .             |
And I append rows
	| artikel   | mge |
	| V2        | 20  |
	| BEHAELTER | 20  |
And I save the current editor

# LS auf Behaelter BHKto 1001 in die Vergangenheit buchen
Given I set the fake date to "01.02.1995"
Given I open an editor "LBORGBREMREP1" from table "(Sales):(PackingSlip)" with command "NEW" for record ""
And I set fields
	| kunde     | 500           |
	| kl2       | 050           |
	| warenempf | 500           |
	| werk      | 001           |
	| ablstelle | 100           |
	| such      | LBORGBRE1     |
	| ueb       | ja            |
	| vom       | .             |
And I append rows
	| artikel   | mge |
	| V2        | 10  |
	| KLT       | 10  |
And I save the current editor

Given I execute shell command "echo \"Behaelterbuchungen zu Kto 1000, 1001 vor Reparatur\" >> ref_bman2_cu.REF"
Given I execute shell command "edpexport.sh -p sy -F -f bhkto,beldat,budat,buart,mge,abestand,bestand -O TAB -k \"@datei=159;@gruppe=1;bhkto=1000;@ordnung=bhkto,id\" >> ref_bman2_cu.REF"
Given I execute shell command "edpexport.sh -p sy -F -f bhkto,beldat,budat,buart,mge,abestand,bestand -O TAB -k \"@datei=159;@gruppe=1;bhkto=1001;@ordnung=bhkto,id\" >> ref_bman2_cu.REF"

Given I execute shell command "echo \" \" >> ref_bman2_cu.REF"
Given I execute shell command "echo \"Behaelterbuchungen zu Kto 1000, 1001 nach Reparatur 1000\" >> ref_bman2_cu.REF"
# Aufruf ueber Satznummer! Muss ggf. angepasst werden, wenn Vorgaengertest geaendert wird
Given I execute shell command "bmanburep -s \"(161,158,0)\"  >> ref_bman2_cu.REF"
Given I execute shell command "edpexport.sh -p sy -F -f bhkto,beldat,budat,buart,mge,abestand,bestand -O TAB -k \"@datei=159;@gruppe=1;bhkto=1000;@ordnung=bhkto,id\" >> ref_bman2_cu.REF"
Given I execute shell command "edpexport.sh -p sy -F -f bhkto,beldat,budat,buart,mge,abestand,bestand -O TAB -k \"@datei=159;@gruppe=1;bhkto=1001;@ordnung=bhkto,id\" >> ref_bman2_cu.REF"

Given I execute shell command "echo \" \" >> ref_bman2_cu.REF"
Given I execute shell command "echo \"Behaelterbuchungen zu Kto 1000, 1001 nach Reparatur ALLE Konten\" >> ref_bman2_cu.REF"
Given I execute shell command "bmanburep -a >> ref_bman2_cu.REF"
Given I execute shell command "edpexport.sh -p sy -F -f bhkto,beldat,budat,buart,mge,abestand,bestand -O TAB -k \"@datei=159;@gruppe=1;bhkto=1000;@ordnung=bhkto,id\" >> ref_bman2_cu.REF"
Given I execute shell command "edpexport.sh -p sy -F -f bhkto,beldat,budat,buart,mge,abestand,bestand -O TAB -k \"@datei=159;@gruppe=1;bhkto=1001;@ordnung=bhkto,id\" >> ref_bman2_cu.REF"
Given I execute shell command "echo \" \" >> ref_bman2_cu.REF"
Given I execute shell command "echo \" \" >> ref_bman2_cu.REF"
