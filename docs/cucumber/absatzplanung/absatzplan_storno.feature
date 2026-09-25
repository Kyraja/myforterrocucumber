@persistent
Feature: absatzplan_storno.feature

Background:
And I set the fake date to "15.02.2009"


# **********************************************************************************
#  Name             : absatzplan_storno.feature
#  Autor            : bschiga
#  Verantwortlich   : foe
#  Kontrolle        : 
#  Funktion         : Verrechnung der Istmengen in der Absatzplanung
#
# **********************************************************************************

###### Lagerstruktur ######

# Die Angaben zu Anschrift und Länge sind dem geschuldet, dass nicht mehrfach !dontChange für die Feldvariablen
# definiert werden kann. Daher mussten Ausweichfelder her.
# Wird mit CUCU-134 gelöst, dann können staat und lplaenge durch !dontChange ersetzt werden.

Scenario Outline: Lagergruppen, Lager und Lagerplätze
Given I open an editor "<such>" from table "<table>" with command "STORE" for record "<such>"
And I set fields
  | such              | <such>                |
  | namebspr          | <namebspr>            |
  | zkonsilg          | <zkonsilg>            |
  | <lager>           | <lager2>              |
  | <ruecklieferung>  | <vkruecklieferung>    |
  | <kundenanliefer>  | <vkkundenanlieferung> |
And I save the current editor
Examples:
  | table                         | Hinweis     | such        | namebspr                  | lager   | lager2    | ruecklieferung    | vkruecklieferung  | kundenanliefer      | vkkundenanlieferung | zkonsilg    |
  | (Warehouse):(WarehouseGroup)  | LAGERGRUPPE | KONSI       | Konsignationslagergruppe  | ans     | KONSI     | staat             | Deutschland       | !dontChange         | !dontChange         | ja          |
  | (Warehouse):(Warehouse)       | LAGER       | K1          | Konsignationslager        | lgruppe | !KONSI^id | staat             | Deutschland       | !dontChange         | !dontChange         | !dontChange |
  | (Location):(Location)   | LAGERPLATZ  | L2F3        | Lagerplatz Hongkong 3     | lager   | L2        | lplaenge          | 5                 | !dontChange         | !dontChange         | !dontChange |

###### Lieferanten und Kunden ######

Scenario Outline: Lieferanten und Kunden
Given I open an editor "<such>" from table "<table>" with command "STORE" for record "<such>"
And I set fields
    | such		| <such>		|
    | namebspr	| <namebspr>	|
    | ans		| <ans>			|
    | str		| <str>			|
    | plz		| <plz>			|
    | nort		| <nort>    	|
    | staat     | <staat>       |
    | konsi     | <konsi>       |
    | zbed		| <zbed>		|
    | waehr     | <waehr>       |
And I save the current editor
Examples:
    | table					| such		| namebspr        	    | ans		| str				| plz         | nort        | staat       | konsi       | zbed      | waehr       |
    | (Vendor):(Vendor)		| LIEFER1 	| Lieferant 1 Inland    | LIEF1 	| Neue Straße 1 	| 12345       | Neustadt    | !dontChange | !dontChange | ZSOFORT   | !dontChange |
    | (Customer):(Customer)	| KUNDE1	| Kunde 1 Inland        | KUNDE1	| Hohe Straße 1 	| 56789       | Hochstadt   | !dontChange | !dontChange | ZSOFORT   | !dontChange |
    | (Customer):(Customer)	| KUNDE2	| Kunde 2 Inland        | KUNDE2	| Tiefe Straße 2 	| 67890       | Tiefstadt   | !dontChange | !dontChange | Z10.3     | !dontChange |


##############################################################################################################
## Verrechnung der Istmengen aus Lieferschein-Storno und Rücklieferschein

Scenario: 01 Verrechnung der Istmengen aus Lieferschein-Storno und Rücklieferschein

# Artikel anlegen
Given I open an editor "Artikel" from table "(Part):(Product)" with command "STORE" for record "ABSATZPLAN"
And I set fields
    | such     | ABSATZPLAN   			|
    | namebspr | Artikel mit Planung	|
    | bsart    | Fremdbeschaffung		|
    | dispoa   | bedarfsbezogen			|
    | lief     | LIEFER1                |
    | efrist   | 7			            |
    | epr      | 80			            |
And I save the current editor

# Anlieferung ABSATZPLAN

Given I open an editor "Rechnung_01" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set fields
    | lief     | LIEFER1    |
    | vom      | .          |
    | ueb      | ja         |
    | fakt     | ja         |
    | ebeleg   | RE1_scen01 |
    | budat    | .          |
And I append rows
    | artikel     | mge | preis | tterm	|
    | ABSATZPLAN  | 35  | 80,00 | +4	|
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# Zeitraster anlegen
Given I open an editor "ZeitrasterM" from table "(PlanningTimePeriod):(PeriodPattern)" with command "NEW" for record ""
And I set fields
	| such			| PL_MONAT	 	|
	| namebspr		| Plan Monat	|
	| zeiteinheit 	| Monat 		|
	| zefaktor		| 1				|
And I save the current editor

Given I open an editor "ZeitrasterW" from table "(PlanningTimePeriod):(PeriodPattern)" with command "NEW" for record ""
And I set fields
	| such			| PL_WOCHE	 	|
	| namebspr		| Plan Woche	|
	| zeiteinheit 	| Woche 		|
	| zefaktor		| 1				|
And I save the current editor

# Planungszeitraeume anlegen
Given I open an editor "Planungzeitraum1" from table "(PlanningTimePeriod):(PlanningTimePeriod)" with command "NEW" for record ""
And I set fields
	| such		| MONAT2019 	|
	| namebspr	| Monat 2019	|
	| zraster 	| PL_MONAT 		|
	| vorgdat	| 1.1.19		|
	| dauer		|	12			|
And I save the current editor

Given I open an editor "Planungzeitraum2" from table "(PlanningTimePeriod):(PlanningTimePeriod)" with command "NEW" for record ""
And I set fields
	| such		| MONAT2008 	|
	| namebspr	| Monat 2008	|
	| zraster 	| PL_MONAT 		|
	| vorgdat	| 1.1.20		|
	| dauer		|	12			|
And I save the current editor

Given I open an editor "Planungzeitraum3" from table "(PlanningTimePeriod):(PlanningTimePeriod)" with command "NEW" for record ""
And I set fields
	| such		| MONAT2009 	|
	| namebspr	| Monat 2009	|
	| zraster 	| PL_MONAT 		|
	| vorgdat	| 1.1.09		|
	| dauer		|	12			|
And I save the current editor

# Rollierungszeitraeume anlegen
Given I open an editor "RollzeitraumM" from table "(PlanningTimePeriod):(PlanningTimePeriod)" with command "NEW" for record ""
And I set fields
	| such		| RMONAT2008 			|
	| namebspr	| Monat Rollierung 2008	|
	| zraster 	| PL_MONAT 				|
	| vorgdat	| 1.11.20				|
	| dauer		|	12					|
And I save the current editor

Given I open an editor "RollzeitraumW" from table "(PlanningTimePeriod):(PlanningTimePeriod)" with command "NEW" for record ""
And I set fields
	| such		| RWOCHE2008 			|
	| zraster 	| PL_WOCHE				|
	| vorgdat	| 1.11.20				|
	| dauer		|	4					|
And I save the current editor

# rollierende Planung anlegen
Given I open an editor "RollPlanung" from table "(SalesPlanning):(RollingPlanning)" with command "NEW" for record ""
And I set fields
	| such			| ROLLPLAN 			|
	| namebspr		| Rollierender Plan	|
	| swprefix 		| RP20				|
	| nametext		| Roll20			|
	| maxrabschn	|	1				|
	| aktrabschn	|   1 				|
	| rollzraum1	| RMONAT2008		|
	| aktiv			| ja				|
And I save the current editor

# Planung anlegen
Given I open an editor "Planung2009" from table "(SalesPlanning):(Planning)" with command "NEW" for record ""
And I set fields
	| such			| PLAN2009 			|
	| namebspr		| Planung fuer 2009	|
	| swprefix 		| PL09				|
	| nametext		| Plan fuer 2009	|
	| vtabstufen	|	2				|
	| vtabzeilen	|  20 				|
	| basiszraum	| MONAT2008			|
	| istzraum		| MONAT2009			|
	| planzraum		| MONAT2009			|
	| rollplanung	| ROLLPLAN			|
And I save the current editor

# Hauptplanungseinheit anlegen
Given I open an editor "HauptPlanEinh" from table "(SalesPlanning):(PlanningUnit)" with command "NEW" for record ""
And I set fields
	| such			| HPL09 		|
	| name			| HauptPE 2009	|
	| planung 		| PLAN2009		|
	| artber		| ABSATZPLAN	|
	| progtyp		| Mittelwert	|
	| zyklus		| 12			|
	| zeiteinheit	| Monat			|
	| zuwachsfakt	| 0				|
	| rundung		| 1				|
And I save the current editor

# Planung aktivieren
Given I open an editor "Planung2009" from table "(SalesPlanning):(Planning)" with command "UPDATE" for record "PLAN2009"
And I set field "aktiv" to "ja"
And I save the current editor

# Basisdaten erzeugen
Given I open an editor "Planung2009" from table "(SalesPlanning):(Planning)" with command "UPDATE" for record "PLAN2009"
And I press button "basiserz" to open a subeditor for "basisdaten"
And I save the current subeditor to switch back to the parent editor
And I save the current editor

#Basismengen erfassen
Given I open an editor "Wertereihe" from table "(ValueSequence):(ValueSequence)" with command "UPDATE" for search criteria "$,,eplan=HPL09;artber=ABSATZPLAN;typ=Basisdaten;@richtung=rückwärts;@maxtreffer=1;@ablageart=lebendig"
And I modify table
	| !row	| mge	|
	| 1		| 50	|
	| 2		| 50	|
	| 3		| 50	|
	| 4		| 50	|
	| 5		| 50	|
	| 6		| 50	|
	| 7		| 50	|
	| 8		| 50	|
	| 9		| 50	|
	| 10	| 50	|
	| 11	| 50	|
And I save the current editor

# Plandaten erzeugen
Given I open an editor "Planung2009" from table "(SalesPlanning):(Planning)" with command "UPDATE" for record "PLAN2009"
And I press button "planerz" to open a subeditor for "plandaten"
And I save the current subeditor to switch back to the parent editor
And I save the current editor

# Bedarfsplanung erzeugen
Given I open an editor "Planung2009" from table "(SalesPlanning):(Planning)" with command "UPDATE" for record "PLAN2009"
And I press button "bedarfplerz" to open a subeditor for "bedarfsplanung"
And I save the current subeditor to switch back to the parent editor
And I save the current editor

# Rollieren
Given I open an editor "RollPlanung" from table "(SalesPlanning):(RollingPlanning)" with command "UPDATE" for record "ROLLPLAN"
And I set field "rolldat" to "."
And I press button "rollieren" to open a subeditor for "rollieren"
And I save the current subeditor to switch back to the parent editor
And I save the current editor

And I run Scheduling

# Auftrag Kunde1
Given I open an editor "auftrag01" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set fields
	| kunde	| KUNDE1	|
	| such  | A01_KD1	|
	| vom	| .			|
And I append rows
	| artikel 		| mge	| preis | tterm    | einplan |
	| ABSATZPLAN	|  7	| 	115	| 15.02.09 |  ja	 |
And I save the current editor

# Auftrag Kunde2
Given I open an editor "auftrag02" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set fields
	| kunde	| KUNDE2	|
	| such  | A02_KD2	|
	| vom	| .			|
And I append rows
	| artikel 		| mge	| preis | tterm    | einplan |
	| ABSATZPLAN	|  12	| 	115	| 25.01.09 |  ja	 |
And I save the current editor

And I run Scheduling

# LS zu den Aufträgen und die Istmengen prüfen

And I deliver the SalesOrder "auftrag01" with PackingSlip "LS-KUNDE1"

And I deliver the SalesOrder "auftrag02" with PackingSlip "LS-KUNDE2"

# Istmengen prüfen in der Wertereihe
Given I open an editor "Wertereihe" from table "(ValueSequence):(RollingForecast)" with command "UPDATE" for search criteria "$,,artber=ABSATZPLAN;typ=(RollingForecast);@richtung=rückwärts;@maxtreffer=1;@ablageart=lebendig"
Then table has values
	| vondat 	 | bisdat 	 | bmge | bpreis | bistmge | bmgeabweich | status  	   | fix	|
	| 15.02.2009 | 28.02.2009|  25  | 0.0000 |  19	   |    6		 | automatisch | nein	|
	| 01.03.2009 | 31.03.2009|  50  | 0.0000 |  0	   |    50		 | automatisch | nein	|
	| 01.04.2009 | 30.04.2009|  50  | 0.0000 |  0	   |    50		 | automatisch | nein	|
	| 01.05.2009 | 31.05.2009|  50  | 0.0000 |  0	   |    50		 | automatisch | nein	|
	| 01.06.2009 | 30.06.2009|  50  | 0.0000 |  0	   |    50		 | automatisch | nein	|
	| 01.07.2009 | 31.07.2009|  50  | 0.0000 |  0	   |    50		 | automatisch | nein	|
	| 01.08.2009 | 31.08.2009|  50  | 0.0000 |  0	   |    50		 | automatisch | nein	|
	| 01.09.2009 | 30.09.2009|  50  | 0.0000 |  0	   |    50		 | automatisch | nein	|
	| 01.10.2009 | 31.10.2009|  50  | 0.0000 |  0	   |    50		 | automatisch | nein	|
	| 01.11.2009 | 30.11.2009|  50  | 0.0000 |  0	   |    50		 | automatisch | nein	|
	| 01.12.2009 | 31.12.2009|   0  | 0.0000 |  0	   |     0		 | automatisch | nein	|
	| 01.01.2010 | 31.01.2010|   0  | 0.0000 |  0	   |     0		 | initialisiert | nein	|
And I close the current editor

## Fall 1 - Storno im gleichen Zeitraum wie Buchung und Rollierung hat den Zeitraum noch offen

And I reverse the PackingSlip "LS-KUNDE1"

And I reverse the PackingSlip "LS-KUNDE2"

And I run Scheduling

# Istmengen prüfen in der Wertereihe
Given I open an editor "Wertereihe" from table "(ValueSequence):(RollingForecast)" with command "UPDATE" for search criteria "$,,artber=ABSATZPLAN;typ=(RollingForecast);@richtung=rückwärts;@maxtreffer=1;@ablageart=lebendig"
Then table has values
	| vondat 	 | bisdat 	 | bmge | bpreis | bistmge | bmgeabweich | status  	   | fix	|
	| 15.02.2009 | 28.02.2009|  25  | 0.0000 |  0	   |     6		 | automatisch | nein	|
	| 01.03.2009 | 31.03.2009|  50  | 0.0000 |  0	   |    50		 | automatisch | nein	|
	| 01.04.2009 | 30.04.2009|  50  | 0.0000 |  0	   |    50		 | automatisch | nein	|
	| 01.05.2009 | 31.05.2009|  50  | 0.0000 |  0	   |    50		 | automatisch | nein	|
	| 01.06.2009 | 30.06.2009|  50  | 0.0000 |  0	   |    50		 | automatisch | nein	|
	| 01.07.2009 | 31.07.2009|  50  | 0.0000 |  0	   |    50		 | automatisch | nein	|
	| 01.08.2009 | 31.08.2009|  50  | 0.0000 |  0	   |    50		 | automatisch | nein	|
	| 01.09.2009 | 30.09.2009|  50  | 0.0000 |  0	   |    50		 | automatisch | nein	|
	| 01.10.2009 | 31.10.2009|  50  | 0.0000 |  0	   |    50		 | automatisch | nein	|
	| 01.11.2009 | 30.11.2009|  50  | 0.0000 |  0	   |    50		 | automatisch | nein	|
	| 01.12.2009 | 31.12.2009|   0  | 0.0000 |  0	   |     0		 | automatisch | nein	|
	| 01.01.2010 | 31.01.2010|   0  | 0.0000 |  0	   |     0		 | initialisiert | nein	|
And I close the current editor

And I set the fake date to "21.02.2009"

And I deliver the SalesOrder "auftrag01" with PackingSlip "LS2-KD1"

And I deliver the SalesOrder "auftrag02" with PackingSlip "LS2-KD2"

## Fall 2 - Rollierung hat den Abschnitt, in dem die Istmenge gebucht wurde, archiviert
## vor dem Storno das fake date in anderen Zeitraum setzen und Rollieren

And I set the fake date to "01.03.2009"

# Rollieren
Given I open an editor "RollPlanung" from table "(SalesPlanning):(RollingPlanning)" with command "UPDATE" for record "ROLLPLAN"
And I set field "rolldat" to "."
And I press button "rollieren" to open a subeditor for "rollieren"
And I save the current subeditor to switch back to the parent editor
And I save the current editor

# Lieferschein stornieren

And I reverse the PackingSlip "LS2-KD1"

And I run Scheduling

## die Istmengen Verrechnung ist noch falsch Issue FDA-2600 bzw. EVS-3032
# Istmengen prüfen in der Wertereihe

Given I open an editor "Wertereihe" from table "(ValueSequence):(RollingForecast)" with command "UPDATE" for search criteria "$,,artber=ABSATZPLAN;typ=(RollingForecast);@richtung=rückwärts;@maxtreffer=1;@ablageart=lebendig"
Then table has values
	| vondat 	 | bisdat 	 | bmge | bpreis | bistmge | bmgeabweich | status  	   | fix	|
	| 01.03.2009 | 31.03.2009|  50  | 0.0000 |  0	   |    43		 | automatisch | nein	|
	| 01.04.2009 | 30.04.2009|  50  | 0.0000 |  0	   |    50		 | automatisch | nein	|
	| 01.05.2009 | 31.05.2009|  50  | 0.0000 |  0	   |    50		 | automatisch | nein	|
	| 01.06.2009 | 30.06.2009|  50  | 0.0000 |  0	   |    50		 | automatisch | nein	|
	| 01.07.2009 | 31.07.2009|  50  | 0.0000 |  0	   |    50		 | automatisch | nein	|
	| 01.08.2009 | 31.08.2009|  50  | 0.0000 |  0	   |    50		 | automatisch | nein	|
	| 01.09.2009 | 30.09.2009|  50  | 0.0000 |  0	   |    50		 | automatisch | nein	|
	| 01.10.2009 | 31.10.2009|  50  | 0.0000 |  0	   |    50		 | automatisch | nein	|
	| 01.11.2009 | 30.11.2009|  50  | 0.0000 |  0	   |    50		 | automatisch | nein	|
	| 01.12.2009 | 31.12.2009|   0  | 0.0000 |  0	   |     0		 | automatisch | nein	|
	| 01.01.2010 | 31.01.2010|   0  | 0.0000 |  0	   |     0		 | initialisiert | nein	|
And I close the current editor

And I set the fake date to "01.03.2009"

# Ruecklieferung Teilmenge
Given I open an editor "Rueckliefer" from table "(Sales):(PackingSlip)" with command "RETURN" for record "LS2-KD2"
And I set field "ueb" to "ja"
And I set field "such" to "RLS1-KD2"
And I set field "mge" to "-2" in row 1
And I set field "platz" to "F1" in row 1
And I save the current editor

Given I open an editor "Wertereihe" from table "(ValueSequence):(RollingForecast)" with command "UPDATE" for search criteria "$,,artber=ABSATZPLAN;typ=(RollingForecast);@richtung=rückwärts;@maxtreffer=1;@ablageart=lebendig"
Then table has values
	| vondat 	 | bisdat 	 | bmge | bpreis | bistmge | bmgeabweich | status  	   | fix	|
	| 01.03.2009 | 31.03.2009|  50  | 0.0000 |  -2	   |    43		 | automatisch | nein	|
	| 01.04.2009 | 30.04.2009|  50  | 0.0000 |  0	   |    50		 | automatisch | nein	|
	| 01.05.2009 | 31.05.2009|  50  | 0.0000 |  0	   |    50		 | automatisch | nein	|
	| 01.06.2009 | 30.06.2009|  50  | 0.0000 |  0	   |    50		 | automatisch | nein	|
	| 01.07.2009 | 31.07.2009|  50  | 0.0000 |  0	   |    50		 | automatisch | nein	|
	| 01.08.2009 | 31.08.2009|  50  | 0.0000 |  0	   |    50		 | automatisch | nein	|
	| 01.09.2009 | 30.09.2009|  50  | 0.0000 |  0	   |    50		 | automatisch | nein	|
	| 01.10.2009 | 31.10.2009|  50  | 0.0000 |  0	   |    50		 | automatisch | nein	|
	| 01.11.2009 | 30.11.2009|  50  | 0.0000 |  0	   |    50		 | automatisch | nein	|
	| 01.12.2009 | 31.12.2009|   0  | 0.0000 |  0	   |     0		 | automatisch | nein	|
	| 01.01.2010 | 31.01.2010|   0  | 0.0000 |  0	   |     0		 | initialisiert | nein	|
And I close the current editor



