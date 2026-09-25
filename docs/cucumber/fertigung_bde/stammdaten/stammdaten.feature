@persistent
Feature: stammdaten.feature

  Background:
    Given I set the fake date to "03.01.1995"
    Given I enable the flag 39

# *****************************************************************************
#  Name             : BC2_Stammdaten
#  Autor            : lschneider
#  Verantwortlich   : amk
#  Kontrolle        : bheim
#  Funktion         : Stammdaten für das Projekt BC2
#  ref              : ref_fe_storno_rueck_daten_cu
# *****************************************************************************
# 
# Lieferant und Kunde
# 	KETTLER			- Lieferant
# 	RADSHOP			- Kunde 
#
# Packmittel:
# 	BEHAELTER
# 	EU-PALETTE
#
# Packanweisungen:
#	PA_1STUFE		- 1 Stufe, Behälter
# 	PA_2STUFEN		- 2 Stufen, Behälter mit Auffüllen und EU-PALETTE (Füllmenge 5)
#
# Einkaufsartikel:
# 	EINKAUF-1		- auftragsbezogen, über Stückliste, chargenpflicht
## 	EINKAUF-2		- auftragsbezogen, über Stückliste, chargenpflicht
## 	EINKAUF-3		- auftragsbezogen, über Stückliste, chargenpflicht
## 	B_EINKAUF-1		- bedarfszebogen, über Stückliste, chargenpflicht
## 	B_EINKAUF-2		- bedarfsbezogen, über Stückliste, chargenpflicht
## 	KOPPELPROD		- bedarfsbezogen, Koppelprodukt
## 	UMBAUART		- bedarfsbezogen, Umbauartikel
## 	GEBINDE			- bedarfsbezogen, mit Einheiten 5kg = 1 Stück, ohne Gebindepflicht
## 	GEBINDEPFL		- bedarfsbezogen, mit Einheiten 1 Paar = 2 Stück, mit Gebindepflicht
#
# Setartikel:
# 	SET-LAGERGR		- Setartikel mit Lagergruppeneigenschaften Hongkong mit Fertigungsliste für Hongkong
# 	SET-ARTIKEL		- Setartikel
#
# Arbeitsgänge
#	SCHRAUBEN		- Lohngruppe 1, Lohngruppe Rüsten 1	
#	MONTAGE1		- Lohngruppe 1, Lohngruppe Rüsten 1		
#	VORBEREITUNG	- Lohngruppe 1, Lohngruppe Rüsten 1	
#	AG_LOHN_1		- Lohngruppe 1, Lohngruppe Rüsten 1	
#	AG_LOHN_2		- Lohngruppe 2, Lohngruppe Rüsten 2	
#	AG_LOHN_3		- Lohngruppe 3, Lohngruppe Rüsten 3	
#
# Baugruppen:
# 	BAUGRUPPE		- auftragsbezogen, 1 Arbeitsgang
#	M_BAUGRUPPE		- auftragsbezogen, 1 Arbeitsgang, Komponenten mit manbu=ja
#	B_BAUGRUPPE		- bedarfsbezogen, 1 Arbeitsgang
#	BM_BAUGRUPPE	- bedarfsbezogen, 1 Arbeitsgang, Komponenten mit manbu=ja
#	BG-KOPPEL		- auftragsbezogen, 1 Arbeitsgang, Koppelrodukt in Stückliste
#	BG-UMBAU		- auftragsbezogen, 1 Arbeitsgang, Umbauartikel in Stückliste
#	BG-BEHAELTER	- auftragsbezogen, 1 Arbeitsgang, Lagerpackanweisung mit Behälter
#	M_BG-BEHAELTER	- auftragsbezogen, 1 Arbeitsgang, Lagerpackanweisung mit Behälter, Komponenten mit manbu=ja
#	BG-GEBINDE		- auftragsbezogen, 1 Arbeitsgang, Komponenten mit Einheiten und Gebindepflicht in Stückliste 
#	BG-EINHEITEN	- auftragsbezogen, 1 Arbeitsgang, Einheiten, Komponenten in Stückliste mit und ohne Einheiten und Gebindepflicht
#	BG-EINHEITENPFL	- auftragsbezogen, 1 Arbeitsgang, Einheiten und Gebindepflicht, Komponenten in Stückliste mit und ohne Einheiten und Gebindepflicht

#	BAUGRUPPE2		- auftragsbezogen, 2 Arbeitsgänge
#	M_BAUGRUPPE2	- auftragsbezogen, 2 Arbeitsgänge, Komponenten mit manbu=ja
#	B_BAUGRUPPE2	- bedarfsbezogen, 2 Arbeitsgänge
#	BG2-KOPPEL		- auftragsbezogen, 2 Arbeitsgänge, Koppelrodukt in Stückliste
#	BG2-UMBAU		- auftragsbezogen, 2 Arbeitsgänge, Umbauartikel in Stückliste
# 	BG2-BEHAELTER	- auftragsbezogen, 2 Arbeitsgänge, Packanweisung mit Behälter

#	BG3-KOPPEL		- auftragsbezogen, 3 Arbeitsgänge, Koppelprodukt in Stückliste
#	BG3-UMBAU		- auftragsbezogen, 3 Arbeitsgänge, Umbauartikel in Stückliste
#	BG3-GEMISCHT	- auftragsbezogen, 3 Arbeitsgänge, STL manuell/retrograd gemischt
#	BG3-LOHNGRUPPE	- auftragsbezogen, 3 Arbeitsgänge mit jeweils unterschiedlichen Lohngruppen
#	BG3-PROZESS		- auftragsbezogen, 3 Arbeitsgänge, Fertigungslistenbasis 2, Anfahrmenge 10%, mit Nutzen 2

# Dienstleistung:
#   Einrichten      - 1 Arbeitsgang



## Vorbereitung: Stammdaten für Test anlegen

  Scenario: Projektkostenrechnung, MKV und FKV anschalten
    Given I open an editor "Konfiguration" from table "(Company):(Configuration)" with command "UPDATE" for record "0k"
    And I set field "projekt" to "ja"
# TODO Hier benoetigen wir einen individuellen Step, der erkennt, ob das Feld bereits aktiv ist
# und in dann nicht nochmal aktiviert
#And I set field "bew" to "ja"
#And I set field "fkkonfig" to "ja"
    And I save the current editor

  Scenario: Bewertungsverfahren anlegen
    Given I open an editor "Konfiguration" from table "(Company):(ValuationConfiguration)" with command "STORE" for record "10"
    And I append rows
      | bewverf | bewab             | bewzu         |
      | 4       | Preis des Zugangs | Nullbewertung |
      | 5       | Preis des Zugangs | Vorgangspreis |
    And I save the current editor

  Scenario: Bediensprache auf Deutsch umstellen
    Given I open an editor "PASSWORT" from table "(Company):(Password)" with command "STORE" for search criteria "$,,bezeich=SY;@richtung=rückwärts;@maxtreffer=1"
    And I set field "sprache" to "Deutsch"
    And I delete all rows
    And I create a new row at the end of the table
    And I set field "rechte" to "26" in row 1
    And I save the current editor

  Scenario Outline: Lieferant und Kunde
    Given I open an editor "<such>" from table "<table>" with command "STORE" for record "<such>"
    And I set fields
      | such     | <such>     |
      | namebspr | <namebspr> |
      | ans      | <ans>      |
      | str      | <str>      |
      | plz      | <plz>      |
      | nort     | <nort>     |
      | zbed     | 201        |
    And I save the current editor
    Examples:
      | table                 | such    | namebspr               | ans             | str             | plz   | nort     |
      | (Vendor):(Vendor)     | KETTLER | Kettler Fahrrad        | Kettler Fahrrad | Industreistr. 3 | 12345 | Neustadt |
      | (Customer):(Customer) | RADSHOP | Radshop Maier, Rastatt | Radshop Maier   | Riedstr. 24     | 76137 | Rastatt  |


  Scenario Outline: Packmittel
    Given I open an editor "<such>" from table "(Part):(Product)" with command "STORE" for record "<such>"
    And I set fields
      | such      | <such>     |
      | namebspr  | <namebspr> |
      | dispoa    | <dispoa>   |
      | lief      | KETTLER    |
      | efrist    | 1          |
      | epr       | <epr>      |
      | zuplatz   | <zuplatz>  |
      | packmit   | ja         |
      | pmtyp     | <pmtyp>    |
      | ekbewverf | 4          |
      | wgruppe   | 55         |
      | erlgrp    | 66         |
    And I save the current editor
    Examples:
      | such       | namebspr   | epr | zuplatz     | chverfolgung      | dispoa         | pmtyp    |
      | BEHAELTER  | Behälter   | 3   | !dontChange | Chargenverfolgung | bedarfsbezogen | Behälter |
      | EU-PALETTE | EU-PALETTE | 10  | !dontChange | Chargenverfolgung | bedarfsbezogen | Palette  |


  Scenario Outline: Einkaufsartikel
    Given I open an editor "<such>" from table "(Part):(Product)" with command "STORE" for record "<such>"
    And I set fields
      | such      | <such>      |
      | namebspr  | <namebspr>  |
      | dispoa    | <dispoa>    |
      | lief      | KETTLER     |
      | efrist    | 2           |
      | epr       | <epr>       |
      | zuplatz   | <zuplatz>   |
      | chverfolgung | <chverfolgung> |
      | wgruppe   | 55          |
      | erlgrp    | 66          |
    And I save the current editor
    Examples:
      | such        | namebspr        | epr  | zuplatz     | chverfolgung       | dispoa          |
      | EINKAUF-1   | Einkaufsteil 1  | 4,50 | !dontChange | Chargenverfolgung  | auftragsbezogen |
      | EINKAUF-2   | Einkaufsteil 2  | 6    | !dontChange | Chargenverfolgung  | auftragsbezogen |
      | EINKAUF-3   | Einkaufsteil 3  | 5,30 | !dontChange | Chargenverfolgung  | auftragsbezogen |
      | B_EINKAUF-1 | Einkaufsteil B1 | 4,50 | !dontChange | Chargenverfolgung  | bedarfsbezogen  |
      | B_EINKAUF-2 | Einkaufsteil B2 | 6    | !dontChange | Chargenverfolgung  | bedarfsbezogen  |
      | KOPPELPROD  | Koppelprodukt   |      | F2          |                    | bedarfsbezogen  |
      | UMBAUART    | Umbauartikel    |      | F2          |                    | bedarfsbezogen  |

  Scenario Outline: Lohnfertigteil
    Given I open an editor "<such>" from table "(Part):(Product)" with command "STORE" for record "<such>"
    And I set fields
      | nummer    | <nummer>    |
      | such      | <such>      |
      | namebspr  | <namebspr>  |
      | dispoa    | <dispoa>    |
      | lief      | KETTLER     |
      | efrist    | 2           |
      | epr       | <epr>       |
      | zuplatz   | <zuplatz>   |
      | chverfolgung | <chverfolgung> |
      | wgruppe   | 55          |
      | erlgrp    | 66          |
      | bsart     | <bsart>     |
    And I save the current editor
    Examples:
      | nummer | such  | namebspr       | epr  | zuplatz     | chverfolgung | dispoa         | bsart         |
      | 20001  | LOHNF | Lohnfertigteil | 4,50 | !dontChange |              | bedarfsbezogen | Lohnfertigung |

  Scenario: Planpreis für Koppelprodukt
    Given I open an editor "teil_koppelprod" from table "(Part):(Product)" with command "UPDATE" for record "KOPPELPROD"
    And I set field "planpr1" to "4.40"
    And I save the current editor

  Scenario Outline: Setartikel ohne Lagergruppeneigenschaften
    Given I open an editor "<such>" from table "(Part):(Product)" with command "STORE" for record "<such>"
    And I set fields
      | such     | <such>          |
      | namebspr | <namebspr>      |
      | earta    | über Stückliste |
      | wgruppe  | 55              |
      | erlgrp   | 66              |
    And I modify table
      | elex      | elanzahl | !row |
      | EINKAUF-1 | 1        | 1    |
      | EINKAUF-2 | 1        | 2    |
    And I save the current editor
    Examples:
      | such        | namebspr   |
      | SET-ARTIKEL | Setartikel |


  Scenario: Setartikel mit Lagergruppeneigenschaften, inkl. eigener Fertigungsliste
    Given I open an editor "SET-LAGERGR" from table "(Part):(Product)" with command "STORE" for record "SET-LAGERGR"
    And I set fields
      | such    | SET-LAGERGR     |
      | earta   | über Stückliste |
      | wgruppe | 55              |
      | erlgrp  | 66              |
    And I modify table
      | elex      | elanzahl | !row |
      | EINKAUF-1 | 1        | 1    |
      | EINKAUF-2 | 1        | 2    |
    And I press button "alge" to open a subeditor for "Lagergruppeneigenschaften"
    And I delete all rows
    And I modify table
      | lgruppe  | !row |
      | HONGKONG | +1   |
    And I save the current editor
    And I switch the current editor to editor "SET-LAGERGR"
    And I modify table
      | elex      | elanzahl | !row |
      | EINKAUF-1 | 1        | 1    |
      | EINKAUF-2 | 1        | 2    |
    And I save the current editor

    Given I open an editor "Fert" from table "(ProductionList):(ProductionList)" with command "STORE" for record "HONG"
    And I set fields
      | such      | HONG        |
      | artikel   | SET-LAGERGR |
      | lgruppe   | HONGKONG    |
      | flistestd | ja          |
    And I modify table
      | elex      | elanzahl | !row |
      | EINKAUF-1 | 5        | 1    |
      | EINKAUF-2 | 5        | 2    |
    And I save the current editor


  Scenario Outline: Artikel mit Einheiten und Artikel mit Gebindepflicht
# Artikel mit Einheiten erstellen
    Given I open an editor "<such>" from table "(Part):(Product)" with command "STORE" for record "<such>"
    And I set fields
      | such      | <such>          |
      | namebspr  | <namebspr>      |
      | dispoa    | auftragsbezogen |
      | lief      | KETTLER         |
      | efrist    | 2               |
      | epr       | 10              |
      | chverfolgung | Chargenverfolgung |
      | gebvhe    | <gebvhe>        |
      | fvhe      | <fvhe>          |
      | vhe       | <vhe>           |
      | gebvpe    | <gebvpe>        |
      | fvpe      | <fvpe>          |
      | vpe       | <vpe>           |
      | gebehe    | <gebehe>        |
      | fehe      | <fehe>          |
      | ehe       | <ehe>           |
      | gebepe    | <gebepe>        |
      | fepe      | <fepe>          |
      | epe       | <epe>           |
      | gebve     | <gebve>         |
      | fve       | <fve>           |
      | ve        | <ve>            |
      | gebge     | <gebge>         |
      | fge       | <fge>           |
      | ge        | <ge>            |
      | wgruppe   | 55              |
      | erlgrp    | 66              |
    And I save the current editor
    Examples:
      | such       | namebspr                | gebvhe      | fvhe | vhe  | gebvpe      | fvpe | vpe  | gebehe      | fehe | ehe  | gebepe      | fepe | epe  | gebve       | fve | ve   | gebge       | fge | ge   |
      | GEBINDE    | Teil mit Einheiten      | !dontChange | 5    | kg   | !dontChange | 5    | kg   | !dontChange | 5    | kg   | !dontChange | 5    | kg   | !dontChange | 5   | kg   | !dontChange | 5   | kg   |
      | GEBINDEPFL | Teil mit Gebindepflicht | ja          | 1    | Paar | ja          | 1    | Paar | ja          | 1    | Paar | ja          | 1    | Paar | ja          | 1   | Paar | ja          | 1   | Paar |


  Scenario: Artikel mit Einheiten und Artikel mit Gebindepflicht
    Given I open an editor "VERSCH-FAKTOR" from table "(Part):(Product)" with command "STORE" for record "VERSCH-FAKTOR"
    And I set fields
      | such     | VERSCH-FAKTOR               |
      | namebspr | Verschiedene Faktoren EK VK |
      | dispoa   | bedarfsbezogen              |
      | lief     | KETTLER                     |
      | efrist   | 2                           |
      | epr      | 10                          |
      | wgruppe  | 55                          |
      | erlgrp   | 66                          |
      | le       | kg                          |
      | gebvhe   | ja                          |
      | fvhe     | 1                           |
      | vhe      | Satz                        |
      | gebvpe   | ja                          |
      | fvpe     | 1                           |
      | vpe      | Satz                        |
      | fvhle    | 100                         |
      | fvple    | 100                         |
      | gebehe   | ja                          |
      | fehe     | 1                           |
      | ehe      | Satz                        |
      | gebepe   | ja                          |
      | fepe     | 1                           |
      | epe      | Satz                        |
      | fehle    | 100                         |
      | feple    | 100                         |
    And I save the current editor


  Scenario: Maschinengruppe
    Given I open an editor "MGRLACK" from table "(Capacity):(WorkCenter)" with command "STORE" for record "MGRLACK"
    And I set fields
      | such      | LACK       |
      | namebspr  | Lackiererei|
      | abtlg     | 10         |
      | kstelle   | 101        |
      | manz      | 1          |
      | automzeit | ja         |
      | nschicht  | 1          |
      | azpt      | 7,5        |
      | auslast   | 90         |
      | leist     | 70         |
      | kapaz     | 4          |
      | gkapaz    | 8          |
    And I save the current editor


  Scenario: Fertigungsmittel
    Given I open an editor "LEIM" from table "(Part):(MeansOfProduction)" with command "STORE" for record "LEIM"
    And I set fields
      | such     | LEIM |
      | namebspr | Leim |
      | platz    | F1   |
      | le       | g    |
    And I save the current editor


  Scenario Outline: Arbeitsgänge
    Given I open an editor "<such>" from table "(Operation):(Operation)" with command "STORE" for record "<such>"
    And I set fields
      | such       | <such>       |
      | namebspr   | <namebspr>   |
      | mgr        | <mgr>        |
      | lgr        | <lgr>        |
      | lgrruesten | <lgrruesten> |
      | tr         | <tr>         |
      | te         | <te>         |
      | skostfix   | 10           |
      | skostvar   | 20           |
      | aschein    | <aschein>    |
    And I save the current editor
    Examples:
      | such         | namebspr     | mgr  | lgr | lgrruesten | tr | te | aschein |
      | SCHRAUBEN    | Schrauben    | M112 | 1   | 2          | 5  | 10 | ja      |
      | MONTAGE1     | Montage 1    | M112 | 1   | 2          | 15 | 6  | ja      |
      | VORBEREITUNG | Vorbereitung | M112 | 1   | 2          | 0  | 20 | ja      |
      | AG_LOHN_1    | Lohngruppe 1 | M112 | 1   | 1          | 10 | 5  | ja      |
      | AG_LOHN_2    | Lohngruppe 2 | M112 | 2   | 2          | 10 | 5  | ja      |
      | AG_LOHN_3    | Lohngruppe 3 | M112 | 3   | 3          | 10 | 5  | ja      |
      | AG_ohne_AS   | Lohngruppe 3 | M112 | 3   | 3          | 10 | 5  | nein    |
      | LACKIEREN    | Lackieren    | LACK | 1   | 2          | 10 | 15 | ja      |


  Scenario: Packanweisungen
    Given I open an editor "PA_1STUFE" from table "(PackingInstructions):(PackingInstructions)" with command "STORE" for record "PA_1STUFE"
    And I set fields
      | such | PA_1STUFE |
    And I modify table
      | !row | artikel   | anzahl | ebene | minebene | auffuell |
      | 1    | BEHAELTER | 1      | 1     | 1        | nein     |
    And I save the current editor
    Given I open an editor "PA_2STUFEN" from table "(PackingInstructions):(PackingInstructions)" with command "STORE" for record "PA_2STUFEN"
    And I set fields
      | such | PA_2STUFEN |
    And I modify table
      | !row | artikel    | anzahl | ebene       | minebene    | auffuell |
      | 1    | BEHAELTER  | 4      | 5           | 1           | ja       |
      | 2    | EU-PALETTE | 1      | !dontChange | !dontChange | nein     |
    And I save the current editor


  Scenario Outline: Baugruppen, 1 AG
    Given I open an editor "<such>" from table "(Part):(Product)" with command "STORE" for record "<such>"
    And I set fields
      | such              | <such>              |
      | namebspr          | <namebspr>          |
      | dispoa            | <dispoa>            |
      | bsart             | Eigenfertigung      |
      | packanwstdla      | <packanwstdla>      |
      | fmengestdla       | <fmengestdla>       |
      | packanwstdversand | <packanwstdversand> |
      | fmengestdversand  | <fmengestdversand>  |
      | chverfolgung      | Chargenverfolgung   |
      | wgruppe           | 55                  |
      | erlgrp            | 66                  |
    And I delete all rows
    And I append rows
      | elex       | anzahl    | manbu   | kompeig    | packmnotw   |
      | <elex1>    | <anzahl1> | <manbu> | <kompeig1> | !dontChange |
      | <elex2>    | <anzahl2> | <manbu> |            | !dontChange |
      | A MONTAGE1 | 1         |         |            | <packmnotw> |
    And I save the current editor
    Examples:
      | such           | namebspr                      | dispoa          | manbu | elex1       | anzahl1 | kompeig1      | elex2       | anzahl2 | packmnotw | packanwstdla | fmengestdla | packanwstdversand | fmengestdversand |
      | BAUGRUPPE      | Einfache Baugruppe            | auftragsbezogen | nein  | EINKAUF-1   | 2       |               | EINKAUF-2   | 1       | nein      |              |             |                   |                  |
      | M_BAUGRUPPE    | Einfache Baugruppe manbu=ja   | auftragsbezogen | ja    | EINKAUF-1   | 2       |               | EINKAUF-2   | 1       | nein      |              |             |                   |                  |
      | B_BAUGRUPPE    | Einfache Baugruppe bedarfsbez | bedarfsbezogen  | nein  | B_EINKAUF-1 | 2       |               | B_EINKAUF-2 | 1       | nein      |              |             |                   |                  |
      | BM_BAUGRUPPE   | Einfache Baugruppe manbu=ja   | bedarfsbezogen  | ja    | B_EINKAUF-1 | 2       |               | B_EINKAUF-2 | 1       | nein      |              |             |                   |                  |
      | BG-KOPPEL      | Baugruppe Koppelprodukt       | auftragsbezogen | nein  | KOPPELPROD  | 1       | Koppelprodukt | EINKAUF-1   | 2       | nein      |              |             |                   |                  |
      | BG-UMBAU       | Baugruppe Umbauartikel        | auftragsbezogen | nein  | UMBAUART    | 1       | Umbauartikel  | EINKAUF-1   | 2       | nein      |              |             |                   |                  |
      | BG-BEHAELTER   | Baugruppe mit Packmittel      | auftragsbezogen | nein  | EINKAUF-1   | 2       |               | EINKAUF-2   | 1       | ja        | PA_1STUFE    | 10          | PA_2STUFEN        | 10               |
      | M_BG-BEHAELTER | BG Packanmittel, manbu=ja     | auftragsbezogen | ja    | EINKAUF-1   | 2       |               | EINKAUF-2   | 1       | ja        | PA_1STUFE    | 10          | PA_2STUFEN        | 10               |
      | BG-GEBINDE     | BG, Komponenten mit Einheiten | auftragsbezogen | nein  | GEBINDE     | 1       |               | GEBINDEPFL  | 1       | nein      |              |             |                   |                  |


  Scenario: Verkaufsartikel mit Lagergruppeneigenschaften für BERLIN und HONGKONG mit abweichender Standard-Fertigungslisten
    Given I open an editor "VK-LAGERGR" from table "(Part):(Product)" with command "STORE" for record "VK-LAGERGR"
    And I set fields
      | such     | VK-LAGERGR                   |
      | namebspr | VK Lagergruppeneigenschfaten |
      | dispoa   | auftragsbezogen              |
      | bsart    | Eigenfertigung               |
    And I press button "alge" to open a subeditor for "Lagergruppeneigenschaften"
    And I delete all rows
    And I modify table
      | lgruppe  | bsart          | !row |
      | HONGKONG | Eigenfertigung | +1   |
      | BERLIN   | Eigenfertigung | +2   |
    And I save the current editor
    And I switch the current editor to editor "VK-LAGERGR"
    And I delete all rows
    And I append rows
      | elex       | anzahl |
      | EINKAUF-1  | 1      |
      | A MONTAGE1 | 1      |
    And I save the current editor

    Given I open an editor "Fertigungsliste_Hongkong" from table "(ProductionList):(ProductionList)" with command "STORE" for record "FL_HONG"
    And I set fields
      | such      | FL_HONG                |
      | namebspr  | VK-LAGERGR FL Hongkong |
      | artikel   | VK-LAGERGR             |
      | lgruppe   | HONGKONG               |
      | flistestd | ja                     |
    And I delete all rows
    And I append rows
      | elex       | elanzahl |
      | EINKAUF-1  | 5        |
      | A MONTAGE1 | 1        |
    And I save the current editor


  Scenario: Spezielle Bewertungsart
    Given I open an editor "MBGBEHAELTER" from table "(Part):(Product)" with command "UPDATE" for record "M_BG-BEHAELTER"
    And I set field "ekbewverf" to "5"
    And I save the current editor


  Scenario Outline: Baugruppen mit Einheiten, Komponenten mit und ohne Einheiten
# Artikel mit Einheiten erstellen
    Given I open an editor "<such>" from table "(Part):(Product)" with command "STORE" for record "<such>"
    And I set fields
      | such     | <such>          |
      | namebspr | <namebspr>      |
      | dispoa   | auftragsbezogen |
      | bsart    | Eigenfertigung  |
      | gebvhe   | <gebvhe>        |
      | fvhe     | <fvhe>          |
      | vhe      | <vhe>           |
      | gebvpe   | <gebvpe>        |
      | fvpe     | <fvpe>          |
      | vpe      | <vpe>           |
      | gebehe   | <gebehe>        |
      | fehe     | <fehe>          |
      | ehe      | <ehe>           |
      | gebepe   | <gebepe>        |
      | fepe     | <fepe>          |
      | epe      | <epe>           |
      | gebve    | <gebve>         |
      | fve      | <fve>           |
      | ve       | <ve>            |
      | gebge    | <gebge>         |
      | fge      | <fge>           |
      | ge       | <ge>            |
      | wgruppe  | 55              |
      | erlgrp   | 66              |
    And I delete all rows
    And I append rows
      | elex       | anzahl |
      | GEBINDE    | 1      |
      | GEBINDEPFL | 1      |
      | EINKAUF-1  | 1      |
      | A MONTAGE1 | 1      |
    And I save the current editor
    Examples:
      | such            | namebspr              | gebvhe      | fvhe | vhe  | gebvpe      | fvpe | vpe  | gebehe      | fehe | ehe  | gebepe      | fepe | epe  | gebve       | fve | ve   | gebge       | fge | ge   |
      | BG-EINHEITEN    | BG mit Einheiten      | !dontChange | 5    | kg   | !dontChange | 5    | kg   | !dontChange | 5    | kg   | !dontChange | 5    | kg   | !dontChange | 5   | kg   | !dontChange | 5   | kg   |
      | BG-EINHEITENPFL | BG mit Gebindepflicht | ja          | 1    | Paar | ja          | 1    | Paar | ja          | 1    | Paar | ja          | 1    | Paar | ja          | 1   | Paar | ja          | 1   | Paar |


  Scenario Outline: Baugruppen, 2 AG
    Given I open an editor "<such>" from table "(Part):(Product)" with command "STORE" for record "<such>"
    And I set fields
      | such              | <such>              |
      | namebspr          | <namebspr>          |
      | dispoa            | auftragsbezogen     |
      | bsart             | Eigenfertigung      |
      | gemein            | GK2.14.3            |
      | packanwstdla      | <packanwstdla>      |
      | fmengestdla       | <fmengestdla>       |
      | packanwstdversand | <packanwstdversand> |
      | fmengestdversand  | <fmengestdversand>  |
      | chverfolgung      | Chargenverfolgung   |
      | wgruppe           | 55                  |
      | erlgrp            | 66                  |
    And I delete all rows
    And I append rows
      | elex        | anzahl    | manbu   | packmnotw   | kompeig   |
      | <elex1>     | <anzahl1> | <manbu> | !dontChange |           |
      | <ag1>       | 1         |         | nein        |           |
      | <elex2>     | <anzahl2> | <manbu> | !dontChange | <kompeig> |
      | <ag2>       | 1         |         | <packmnotw> |           |
    And I save the current editor
    Examples:
      | such          | namebspr                        | manbu | elex1     | anzahl1 | ag1         | elex2      | anzahl2 | ag2        |  kompeig      | packmnotw | packanwstdla | fmengestdla | packanwstdversand | fmengestdversand |
      | BAUGRUPPE2    | Einfache Baugruppe 2            | nein  | EINKAUF-1 | 2       | A SCHRAUBEN | EINKAUF-2  | 1       | A MONTAGE1 |               | nein      |              |             |                   |                  |
      | M_BAUGRUPPE2  | Einfache Baugruppe 2 manbu=ja   | ja    | EINKAUF-1 | 2       | A SCHRAUBEN | EINKAUF-2  | 1       | A MONTAGE1 |               | nein      |              |             |                   |                  |
      | B_BAUGRUPPE2  | Einfache Baugruppe 2 bedarfsbez | nein  | EINKAUF-1 | 2       | A SCHRAUBEN | EINKAUF-2  | 1       | A MONTAGE1 |               | nein      |              |             |                   |                  |
      | BG2-KOPPEL    | Baugruppe Koppelprodukt 2       | nein  | EINKAUF-1 | 1       | A SCHRAUBEN | KOPPELPROD | 1       | A MONTAGE1 | Koppelprodukt | nein      |              |             |                   |                  |
      | BG2-UMBAU     | Baugruppe Umbauartikel 2        | nein  | EINKAUF-1 | 2       | A SCHRAUBEN | UMBAUART   | 1       | A MONTAGE1 | Umbauartikel  | nein      |              |             |                   |                  |
      | BG2-BEHAELTER | Baugruppe 2 mit Packmittel      | nein  | EINKAUF-1 | 2       | A SCHRAUBEN | EINKAUF-2  | 1       | A MONTAGE1 |               | ja        | PA_1STUFE    | 10          | PA_2STUFEN        | 10               |
      | BGAUTOMZEIT   | Baugruppe automzeit=ja in Mgr   | nein  | EINKAUF-1 | 2       | A LACKIEREN | EINKAUF-2  | 1       | A MONTAGE1 |               | nein      |              |             |                   |                  |


  Scenario Outline: Baugruppen, 3 AG
    Given I open an editor "<such>" from table "(Part):(Product)" with command "STORE" for record "<such>"
    And I set fields
      | such      | <such>          |
      | namebspr  | <namebspr>      |
      | dispoa    | auftragsbezogen |
      | bsart     | Eigenfertigung  |
      | gemein    | GK2.14.3        |
      | chverfolgung | Chargenverfolgung |
      | wgruppe   | 55              |
      | erlgrp    | 66              |
      | flbasis   | <flbasis>       |
    And I delete all rows
    And I append rows
      | elex    | anzahl    | kompeig   | manbu    | nutzen   | pverlust   |
      | <elex1> | <anzahl1> |           | <manbu1> | <nutzen> |            |
      | <ag1>   | 1         |           |          |          | <pverlust> |
      | <elex2> | <anzahl2> | <kompeig> | <manbu2> |          |            |
      | <elex3> | <anzahl3> |           | <manbu3> |          |            |
      | <ag2>   | 1         |           |          |          |            |
      | <elex4> | <anzahl4> |           | <manbu4> |          |            |
      | <ag3>   | 1         |           |          |          |            |
    And I save the current editor
    Examples:
      | such           | namebspr                  | flbasis | elex1     | anzahl1 | manbu1 | nutzen | ag1         | elex2      | anzahl2 | kompeig       | manbu2 | ag2            | pverlust | elex3     | anzahl3 | manbu3 | ag3         | elex4     | anzahl4 | manbu4 |
      | BAUGRUPPE3     | Einfache Baugruppe 3      |         | EINKAUF-1 | 1       |        |        | A SCHRAUBEN | EINKAUF-2  | 1       |               |        | A VORBEREITUNG |          |           |         |        | A MONTAGE1  | EINKAUF-3 | 1       |        |
      | BG3-KOPPEL     | Baugruppe Koppelprodukt   |         | EINKAUF-1 | 1       |        |        | A SCHRAUBEN | KOPPELPROD | 1       | Koppelprodukt |        | A VORBEREITUNG |          | EINKAUF-2 | 2       |        | A MONTAGE1  | EINKAUF-3 | 1       |        |
      | BG3-UMBAU      | Baugruppe Umbauartikel    |         | EINKAUF-1 | 1       |        |        | A SCHRAUBEN | UMBAUART   | 1       | Umbauartikel  |        | A VORBEREITUNG |          | EINKAUF-2 | 2       |        | A MONTAGE1  | EINKAUF-3 | 1       |        |
      | BG3-GEMISCHT   | BG retro/manuell gemischt |         | EINKAUF-1 | 1       | ja     |        | A SCHRAUBEN | EINKAUF-2  | 1       |               | ja     | A VORBEREITUNG |          | EINKAUF-3 | 1       |        | A AG_LOHN_3 |           |         |        |
      | BG3-LOHNGRUPPE | BG versch. Lohngruppe     |         | EINKAUF-1 | 2       |        |        | A AG_LOHN_1 | EINKAUF-2  | 1       |               |        | A AG_LOHN_2    |          | EINKAUF-3 | 1       |        | A AG_LOHN_3 |           |         |        |
      | BG3-PROZESS    | BG versch. Lohngruppe2    | 2       | GEBINDE   | 1       | ja     | 2      | A AG_LOHN_1 | EINKAUF-2  | 1       |               |        | A AG_LOHN_2    | 10       | EINKAUF-3 | 1       |        | A AG_LOHN_3 |           |         |        |

  Scenario Outline: Dienstleistung 1 AG
    Given I open an editor "<such>" from table "(Part):(Service)" with command "STORE" for record "<such>"
    And I set fields
      | such     | <such>     |
      | namebspr | <namebspr> |
    And I delete all rows
    And I append rows
      | elex       | anzahl    |
      | <elex1>    | <anzahl1> |
      | A MONTAGE1 | 1         |
    And I save the current editor
    Examples:
      | such       | namebspr   | elex1     | anzahl1 |
      | EINRICHTEN | Einrichten | EINKAUF-1 | 1       |


## muss am Anfang im Testbett laufen, damit die Mengen und Preise für die 
## REWE-Betrachtung da sind

  Scenario: uE Buchung auf fuer Fertigungszeiten
    Given I open an editor "Konto99900" from table "(Account):(Account)" with command "UPDATE" for record "99900"
    And I set field "hkost" to "ja"
    And I save the current editor

  Scenario: Mengen und Preise bereitstellen
    Given I open an editor "Lagerbuchung" for tip command "(Stockadjustment)" and arguments ""
    And I set fields
      | artikel | EINKAUF-1 |
      | buart   | Zugang    |
      | beleg   | mge-preis |
      | wert    | 4,5       |
      | beldat  | .         |
    And I delete all rows
    And I append rows
      | mge | platz2 |
      | 400 | F1     |
    And I save the current editor

    Given I open an editor "Lagerbuchung" for tip command "(Stockadjustment)" and arguments ""
    And I set fields
      | artikel | EINKAUF-2 |
      | buart   | Zugang    |
      | beleg   | mge-preis |
      | wert    | 6,0       |
      | beldat  | .         |
    And I delete all rows
    And I append rows
      | mge  | platz2 |
      | 1000 | F1     |
    And I save the current editor
