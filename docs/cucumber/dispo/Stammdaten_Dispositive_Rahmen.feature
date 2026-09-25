@persistent
Feature: Stammdaten_Dispositive_Rahmen.feature

Background:
And I set the fake date to "16.01.1995"

# **********************************************************************************
#  Name             : Stammdaten_Dispositive_Rahmen
#  Autor            : bschiga
#  Verantwortlich   : bheim
#  Kontrolle        : drpf
#  Funktion         : Stammdaten fuer Dispositive Rahmenauftraege
#
# **********************************************************************************

#### Auszug aus NeueStammdaten.feature - Kunden KUNDE1 und KUNDE2, Lieferant LIEFER1 und LIEFER2, Artikel EK1-AUFTRAG und EK2-AUFTRAG und EK3-BEDARF

Scenario: Bewertungskonfiguration anlegen
Given I open an editor "Bewertungskonfig" from table "(Company):(ValuationConfiguration)" with command "STORE" for record "BEWERT"
And I set fields
    | such      | BEWERT  |
    | namebspr  | Bewertungsverfahren für die Bewertung von Lagerbewegungen |
And I modify table
    | !row  | bewverf     | bewab                     | bewzu           | verfsperr |
    | 1     | !dontChange | Mischpreis                | Vorgangspreis   | nein      |
    | 2     | !dontChange | Preis des Zugangs         | Planpreis       | nein      |
    | +3    | 2           | Preis des Zugangs         | Nullbewertung   | nein      |
    | +4    | 4           | letzter   Zugang  (LIFO)  | Vorgangspreis   | nein      |
    | +5    | 5           | frühester Zugang  (FIFO)  | Vorgangspreis   | nein      |
    | +6    | 6           | Preis des Zugangs         | Vorgangspreis   | nein      |
    | +7    | 7           | Mischpreis                | Vorgangspreis   | nein      |
    | +8    | 8           | Lagergruppenmischpreis    | Vorgangspreis   | nein      |
    | +9    | 9           | Preis des Zugangs         | Planpreis       | nein      |
    | +10   | 10          | Preis des Zugangs         | Nullbewertung   | nein      |
And I save the current editor
  
###### Lieferanten und Kunden ######

Scenario Outline: Lieferanten und Kunden
Given I open an editor "<such>" from table "<table>" with command "STORE" for record "<such>"
And I set fields
    | such        | <such>        |
    | namebspr    | <namebspr>    |
    | ans         | <ans>         |
    | str         | <str>         |
    | plz         | <plz>         |
    | nort        | <nort>        |
    | staat       | <staat>       |
    | konsi       | <konsi>       |
    | zbed        | <zbed>        |
    | waehr       | <waehr>       |
And I save the current editor
Examples:
    | table                   | such      | namebspr              | ans      | str            | plz         | nort        | staat       | konsi       | zbed      | waehr       |
    | (Vendor):(Vendor)       | LIEFER1   | Lieferant 1 Inland    | LIEF1    | Neue Straße 1  | 12345       | Neustadt    | !dontChange | !dontChange | ZSOFORT   | !dontChange |
    | (Vendor):(Vendor)       | LIEFER2   | Lieferant 2 Inland    | LIEF2    | Alte Straße 2  | 23456       | Altstadt    | !dontChange | !dontChange | Z10.3     | !dontChange |
    | (Customer):(Customer)   | KUNDE1    | Kunde 1 Inland        | KUNDE1   | Hohe Straße 1  | 56789       | Hochstadt   | !dontChange | !dontChange | ZSOFORT   | !dontChange |
    | (Customer):(Customer)   | KUNDE2    | Kunde 2 Inland        | KUNDE2   | Tiefe Straße 2 | 67890       | Tiefstadt   | !dontChange | !dontChange | Z10.3     | !dontChange |


Scenario Outline: Einkaufsartikel
Given I open an editor "<such>" from table "(Part):(Product)" with command "STORE" for record "<such>"
And I set fields
    | such        | <such>            |
    | namebspr    | <namebspr>        |
    | bsart       | Fremdbeschaffung  |
    | dispoa      | <dispoa>          |
    | mindest     | <mindest>         |
    | maxbsmge    | <maxbsmge>        |
    | minbsmge    | <minbsmge>        |
    | losgr       | <losgr>           |
    | losbild     | <losbild>         |
    | rundung     | <rundung>         |
    | chpflicht   | <chverfolgung>    |
    | lief        | <lief>            |
    | efrist      | <efrist>          |
    | epr         | <epr>             |
    | gemein      | <gemein>          |
    | kbpr        | <kbpr>            |
    | ekbewverf   | <ekbewverf>       |
    | wgruppe     | <wgruppe>         |
    | erlgrp      | <erlgrp>          |
    | matart      | <matart>          |
    | zmge        | <zmge>            |
    | matvrel     | <matvrel>         |
    | materel     | <materel>         |
And I save the current editor
Examples:
    | such            | namebspr                  | dispoa            | mindest     | maxbsmge    | minbsmge    | losgr       | losbild     | rundung     | chverfolgung | lief        | efrist      | epr         | gemein      | kbpr          | ekbewverf | wgruppe | erlgrp  | matart  | zmge  | matvrel | materel |
    | EK1-BEDARF      | bedarfsbezogenes Teil 1   | bedarfsbezogen    | 0           | 0           | 0           | 0           | 0           | 0           |              | LIEFER1     | 3           | 5           | GK2.14.3    | Einkaufspreis | 6         | WG-RHB  | PG-UE   |         |       |         |         |
    | EK2-BEDARF      | bedarfsbezogenes Teil 2   | bedarfsbezogen    | 0           | 0           | 0           | 0           | 0           | 0           |              | LIEFER1     | 3           | 5           | GK2.14.3    | Einkaufspreis | 6         | WG-RHB  | PG-UE   |         |       |         |         |
    | EK3-BEDARF      | bedarfsbezogenes Teil 3   | bedarfsbezogen    | 0           | 0           | 0           | 0           | 0           | 0           |              | LIEFER1     | 3           | 5           | GK2.14.3    | Einkaufspreis | 6         | WG-RHB  | PG-UE   |         |       |         |         |
    | EK1-AUFTRAG     | auftragsbezoges Teil 1    | auftragsbezogen   | 0           | 0           | 0           | 0           | 0           | 0           |              | LIEFER1     | 3           | 5           | GK2.14.3    | Einkaufspreis | 6         | WG-RHB  | PG-UE   |         |       |         |         |
    | EK2-AUFTRAG     | auftragsbezoges Teil 2    | auftragsbezogen   | 0           | 0           | 0           | 0           | 0           | 0           |              | LIEFER1     | 3           | 5           | GK2.14.3    | Einkaufspreis | 6         | WG-RHB  | PG-UE   |         |       |         |         |
    | E1              | !dontChange               | !dontChange       | !dontChange | !dontChange | !dontChange | !dontChange | !dontChange | !dontChange | !dontChange  | !dontChange | !dontChange | !dontChange | !dontChange | !dontChange   | 6         | WG-RHB  | PG-UE   |         |       |         |         |
    | E2              | !dontChange               | !dontChange       | !dontChange | !dontChange | !dontChange | !dontChange | !dontChange | !dontChange | !dontChange  | !dontChange | !dontChange | !dontChange | !dontChange | !dontChange   | 6         | WG-RHB  | PG-UE   |         |       |         |         |
    | E3              | !dontChange               | !dontChange       | !dontChange | !dontChange | !dontChange | !dontChange | !dontChange | !dontChange | !dontChange  | !dontChange | !dontChange | !dontChange | !dontChange | !dontChange   | 6         | WG-RHB  | PG-UE   |         |       |         |         |
    | EINK            | !dontChange               | !dontChange       | !dontChange | !dontChange | !dontChange | !dontChange | !dontChange | !dontChange | !dontChange  | LIEFER1     | 1           | 2           | GK2.14.3    | !dontChange   | 6         | WG-RHB  | PG-UE   |         |       |         |         |

Scenario: Dienstleistungen
Given I open an editor "DIENSTL" from table "(Part):(Service)" with command "STORE" for record "DL-Reparatur"
And I set fields
    | such      | DL-Reparatur   |
    | namebspr  | Reparatur      |
    | vpr       | 70.00          |
And I delete all rows
And I save the current editor

########################################################################################################################

Scenario: 1 Zeitraster anlegen

Given I open an editor "ZeitrasterM" from table "(PlanningTimePeriod):(PeriodPattern)" with command "NEW" for record ""
And I set fields
    | such           | MONAT1            |
    | namebspr       | Zeitraster Monat  |
    | zeiteinheit    | Monat             |
    | zefaktor       | 1                 |
And I save the current editor

Given I open an editor "ZeitrasterW" from table "(PlanningTimePeriod):(PeriodPattern)" with command "NEW" for record ""
And I set fields
    | such          | WOCHE1             |
    | namebspr      | Zeitraster Woche   |
    | zeiteinheit   | Woche              |
    | zefaktor      | 1                  |
And I save the current editor

Given I open an editor "ZeitrasterT" from table "(PlanningTimePeriod):(PeriodPattern)" with command "NEW" for record ""
And I set fields
    | such           | TAG1              |
    | namebspr       | Zeitraster Tag    |
    | zeiteinheit    | Tag               |
    | zefaktor       | 1                 |
And I save the current editor

Given I open an editor "ZeitrasterQ" from table "(PlanningTimePeriod):(PeriodPattern)" with command "NEW" for record ""
And I set fields
    | such           | QUARTAL1             |
    | namebspr       | Zeitraster Quartal   |
    | zeiteinheit    | Quartal              |
    | zefaktor       | 1                    |
And I save the current editor

Given I open an editor "ZeitrasterF" from table "(PlanningTimePeriod):(PeriodPattern)" with command "NEW" for record ""
And I set fields
    | such           | FREI1             |
    | namebspr       | Freie Periode     |
    | zeiteinheit    | Frei              |
And I append rows
    | vondat         | bisdat    |
    | 13.02.95       | 07.03.95  |
    | 08.03.95       | 23.03.95  |
    | 24.03.95       | 21.04.95  |
And I save the current editor

####################################################################################################################
