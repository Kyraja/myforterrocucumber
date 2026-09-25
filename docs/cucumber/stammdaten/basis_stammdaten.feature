Feature: basis_stammdaten.feature

  Background:
    Given I'm logged in with password "annette"
    And I set the fake date to "01.01.2000"
    Given I enable the flag 39

# **********************************************************************************
#  Name             : basis_stammdaten
#  Autor            : lschneider
#  Verantwortlich   : amk
#  Kontrolle        : sb
#  Funktion         : Stammdaten für die Teams BC, EVS, FDA
#                     Änderungen bitte nur in Absprache mit den Verantwortlichen!
#
# **********************************************************************************



  # Struktur:

  # Firmenkonfiguration
  # Kostenstellen und Gemeinkosten
  # Mitarbeiter
  # Lagerstruktur
  # Lieferanten und Kunden
  # Maschinengruppen, Arbeitsgänge und Fertigungsmittel
  # Materialzuschläge
  # Packmittel und Packanweisungen
  # Artikel
  # Zusatzpositionen
  # Techniker, Dienstleistungen, Einsatzmittel
  # Preise und Rabatte





 ###### Firmenkonfiguration ######

  Scenario: Konfigurationen einschalten
    Given I open an editor "Konfiguration" from table "(Company):(Configuration)" with command "UPDATE" for record "0k"
    And I set fields
      | projekt  | ja  |
      | inlwaehr | EUR |
    And I save the current editor

  Scenario: Bewertungskonfiguration anlegen
    Given I open an editor "Bewertungskonfig" from table "(Company):(ValuationConfiguration)" with command "STORE" for record "BEWERT"
    And I set fields
      | such     | BEWERT                                                    |
      | namebspr | Bewertungsverfahren für die Bewertung von Lagerbewegungen |
    And I modify table
      | !row | bewverf     | bewab                    | bewzu         | verfsperr |
      | 1    | !dontChange | Mischpreis               | Vorgangspreis | nein      |
      | 2    | !dontChange | Preis des Zugangs        | Planpreis     | nein      |
      | +3   | 2           | Preis des Zugangs        | Nullbewertung | nein      |
      | +4   | 4           | letzter   Zugang  (LIFO) | Vorgangspreis | nein      |
      | +5   | 5           | frühester Zugang  (FIFO) | Vorgangspreis | nein      |
      | +6   | 6           | Preis des Zugangs        | Vorgangspreis | nein      |
      | +7   | 7           | Mischpreis               | Vorgangspreis | nein      |
      | +8   | 8           | Lagergruppenmischpreis   | Vorgangspreis | nein      |
      | +9   | 9           | Preis des Zugangs        | Planpreis     | nein      |
      | +10  | 10          | Preis des Zugangs        | Nullbewertung | nein      |
    And I save the current editor



 ###### Kostenstellen und Gemeinkosten ######

  Scenario Outline: Kostenstellen
    Given I open an editor "<such>" from table "(Account):(CostCenter)" with command "STORE" for record "<such>"
    And I set fields
      | such | <such> |
    And I save the current editor
    Examples:
      | such     |
      | KS-TECHN |


  Scenario Outline: Gemeinkosten
    Given I open an editor "<such>" from table "(Company):(OverheadRates)" with command "STORE" for record "<such>"
    And I set fields
      | such       | <such>       |
      | namebspr   | <namebspr>   |
      | matgks     | <matgks>     |
      | flgksatz   | <flgksatz>   |
      | hkztext1   | <hkztext1>   |
      | hkzart1    | <hkzart1>    |
      | hkzuschlg1 | <hkzuschlg1> |
      | skztext1   | <skztext1>   |
      | skzart1    | <skzart1>    |
      | skzuschlg1 | <skzuschlg1> |
    And I save the current editor
    Examples:
      | such | namebspr          | matgks | flgksatz | hkztext1 | hkzart1 | hkzuschlg1 | skztext1 | skzart1 | skzuschlg1 |
      | GK0  | ohne Gemeinkosten | 0      | 0        |          |         |            |          |         |            |



  ###### Mitarbeiter ######

  Scenario Outline: Mitarbeiter
    Given I open an editor "<such>" from table "(Employee):(Employee)" with command "STORE" for record "<such>"
    And I set fields
      | such     | <such>     |
      | namebspr | <namebspr> |
      | splan    | <splan>    |
      | lohn     | <lohn>     |
      | kstelle  | <kstelle>  |
    And I save the current editor
    Examples:
      | such     | namebspr    | splan | lohn | kstelle      |
      | TEST     | !dontChange | 301   | 1    | !KS-TECHN^id |
      | KARL     | !dontChange | 301   | 2    |              |
      | MEIER    | !dontChange | 302   | 1    |              |
      | MA-LOHN1 | Lohngruppe1 | 301   | 1    |              |
      | MA-LOHN2 | Lohngruppe2 | 301   | 2    |              |
      | MA-LOHN3 | Lohngruppe3 | 301   | 3    |              |



 ###### Lagerstruktur ######

  # Die Angaben zu Anschrift und Länge sind dem geschuldet, dass nicht mehrfach !dontChange für die Feldvariablen
  # definiert werden kann. Daher mussten Ausweichfelder her.
  # Wird mit CUCU-134 gelöst, dann können staat und lplaenge durch !dontChange ersetzt werden.

  Scenario Outline: Lagergruppen, Lager und Lagerplätze
    Given I open an editor "<such>" from table "<table>" with command "STORE" for record "<such>"
    And I set fields
      | such             | <such>                |
      | namebspr         | <namebspr>            |
      | zkonsilg         | <zkonsilg>            |
      | <lager>          | <lager2>              |
      | <ruecklieferung> | <vkruecklieferung>    |
      | <kundenanliefer> | <vkkundenanlieferung> |
    And I save the current editor
    Examples:
      | table                        | Hinweis     | such      | namebspr                  | lager   | lager2    | ruecklieferung   | vkruecklieferung | kundenanliefer      | vkkundenanlieferung | zkonsilg    |
      | (Warehouse):(WarehouseGroup) | LAGERGRUPPE | KONSI     | Konsignationslagergruppe  | ans     | KONSI     | staat            | Deutschland      | !dontChange         | !dontChange         | ja          |
      | (Warehouse):(Warehouse)      | LAGER       | K1        | Konsignationslager        | lgruppe | !KONSI^id | staat            | Deutschland      | !dontChange         | !dontChange         | !dontChange |
      | (Location):(Location)        | LAGERPLATZ  | KONSI1    | Konsignationslagerplatz 1 | lager   | !K1^id    | lplaenge         | 5                | !dontChange         | !dontChange         | !dontChange |
      | (Location):(Location)        | LAGERPLATZ  | KONSI2    | Konsignationslagerplatz 2 | lager   | !K1^id    | lplaenge         | 5                | !dontChange         | !dontChange         | !dontChange |
      | (Location):(Location)        | LAGERPLATZ  | L2F3      | Lagerplatz Hongkong 3     | lager   | L2        | lplaenge         | 5                | !dontChange         | !dontChange         | !dontChange |
      | (Warehouse):(WarehouseGroup) | LAGERGRUPPE | KARLSRUHE | !dontChange               | ans     | KARLSRUHE | vkruecklieferung | F3               | vkkundenanlieferung | KONSI1              | !dontChange |



 ###### Lieferanten und Kunden ######

  Scenario Outline: Lieferanten und Kunden
    Given I open an editor "<such>" from table "<table>" with command "STORE" for record "<such>"
    And I set fields
      | such     | <such>     |
      | namebspr | <namebspr> |
      | ans      | <ans>      |
      | str      | <str>      |
      | plz      | <plz>      |
      | nort     | <nort>     |
      | staat    | <staat>    |
      | konsi    | <konsi>    |
      | zbed     | <zbed>     |
      | waehr    | <waehr>    |
    And I save the current editor
    Examples:
      | table                 | such     | namebspr             | ans      | str             | plz   | nort        | staat       | konsi       | zbed    | waehr       |
      | (Vendor):(Vendor)     | LIEFER1  | Lieferant 1 Inland   | LIEF1    | Neue Straße 1   | 12345 | Neustadt    | !dontChange | !dontChange | ZSOFORT | !dontChange |
      | (Vendor):(Vendor)     | LIEFER2  | Lieferant 2 Inland   | LIEF2    | Alte Straße 2   | 23456 | Altstadt    | !dontChange | !dontChange | Z10.3   | !dontChange |
      | (Vendor):(Vendor)     | K-LIEF   | Lief mit Konsilager  | K-LIEF   | Kleine Straße 3 | 45678 | Kleinstadt  | !dontChange | L3F1        | LAST    | !dontChange |
      | (Vendor):(Vendor)     | LIEFERUS | Lieferant mit USD    | LIEFERUS | Dollarstraße 4  | 77777 | Usdollar    | USA         |             | ZSOFORT | USD         |
      | (Customer):(Customer) | KUNDE1   | Kunde 1 Inland       | KUNDE1   | Hohe Straße 1   | 56789 | Hochstadt   | !dontChange | !dontChange | ZSOFORT | !dontChange |
      | (Customer):(Customer) | KUNDE2   | Kunde 2 Inland       | KUNDE2   | Tiefe Straße 2  | 67890 | Tiefstadt   | !dontChange | !dontChange | Z10.3   | !dontChange |
      | (Customer):(Customer) | K-KUNDE  | Kunde mit Konsilager | K-KUNDE  | Kleine Straße 3 | 45678 | Kleinstadt  | !dontChange | KONSI1      | LAST    | !dontChange |
      | (Vendor):(Vendor)     | LIEFCHA1 | Lieferant 1 Chargen  | LIEFCHA1 | Chargen Straße 1| 12345 | Chargenstadt| !dontChange | !dontChange | ZSOFORT | !dontChange |
      | (Vendor):(Vendor)     | LIEFCHA2 | Lieferant 2 Chargen  | LIEFCHA2 | Chargen Straße 2| 23456 | Chargenstadt| !dontChange | !dontChange | Z10.3   | !dontChange |
      | (Customer):(Customer) | KUNDECH1 | Kunde 1 Chargen      | KUNDECH1 | CHSN Straße 1   | 56789 | CHSNstadt   | !dontChange | !dontChange | ZSOFORT | !dontChange |
      | (Customer):(Customer) | KUNDECH2 | Kunde 2 Chargen      | KUNDECH1 | CHSN Straße 2   | 67890 | CHSNstadt   | !dontChange | KONSI2      | Z10.3   | !dontChange |



  ###### Materialzuschläge und Zusatzpositionen ######

  Scenario Outline: Materialzuschläge
    Given I open an editor "<such>" from table "(Company):(MaterialSurchargeHeader)" with command "STORE" for record "<such>"
    And I press button "ladetab"
    And I append rows
      | matart   | matbasis   | matnotiz   | matproz   |
      | <matart> | <matbasis> | <matnotiz> | <matproz> |
    And I save the current editor
    Examples:
      | such     | matart | matbasis | matnotiz | matproz |
      | MATERIAL | CU     | 100      | 150      | 5       |


  Scenario Outline: Zusatzpositionen
    Given I open an editor "<such>" from table "(Part):(SupplementaryItem)" with command "STORE" for record "<such>"
    And I set fields
      | such      | <such>      |
      | namebspr  | <namebspr>  |
      | zptyp     | <zptyp>     |
      | lirelev   | <lirelev>   |
      | rerelev   | <rerelev>   |
      | umlage    | <umlage>    |
      | ebezbspr  | <ebezbspr>  |
      | vkbezbspr | <vkbezbspr> |
    And I save the current editor
    Examples:
      | such    | namebspr          | zptyp             | lirelev | rerelev | umlage | ebezbspr          | vkbezbspr         |
      | NEUTRAL | Neutrale Position | Neutrale Position | ja      | ja      | nein   | Neutrale Position | Neutrale Position |
      | AU/BE   | AU/BE-Position    | AU/BE-Position,BV | ja      | ja      | nein   | AU/BE-Position    | AU/BE-Position    |



 ###### Packmittel und Packanweisungen ######

  Scenario Outline: Packmittel
    Given I open an editor "<such>" from table "(Part):(Product)" with command "STORE" for record "<such>"
    And I set fields
      | such      | <such>           |
      | namebspr  | <namebspr>       |
      | bsart     | Fremdbeschaffung |
      | dispoa    | <dispoa>         |
      | packmit   | <packmit>        |
      | egtkenn   | <egtkenn>        |
      | pmtyp     | <pmtyp>          |
      | gewicht   | <gewicht>        |
      | vpkenn    | <vpkenn>         |
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
      | such         | namebspr           | dispoa         | packmit     | pmtyp        | egtkenn     | gewicht     | vpkenn            | lief        | efrist | epr | gemein | kbpr          | ekbewverf | wgruppe | erlgrp |
      | KLT          | Kleinladungsträger | bedarfsbezogen | ja          | Behälter     | !dontChange | 0,5         | Mehrwegverpackung | LIEFER2     | 1      | 3   | GK0    | Einkaufspreis | 10        | WG-RHB  | PG-UE  |
      | BEHAELTER2   | Behälter 2         | bedarfsbezogen | ja          | Behälter     | !dontChange | 0,75        | Mehrwegverpackung | LIEFER2     | 1      | 5   | GK0    | Einkaufspreis | 10        | WG-RHB  | PG-UE  |
      | BEHAELTER_K  | Behälter Kunde     | bedarfsbezogen |             |              | !dontChange |             |                   |             |        |     | GK0    | Einkaufspreis | 10        | WG-RHB  | PG-UE  |
      | P-PALETTE    | P-PALETTE          | bedarfsbezogen | ja          | PALETTE      | Kunde       | 10          | Mehrwegverpackung | LIEFER2     | 1      | 10  | GK0    | Einkaufspreis | 10        | WG-RHB  | PG-UE  |
      | PAL-DECKEL   | Palettendeckel     | bedarfsbezogen | ja          | Deckel       | !dontChange | 3           | Mehrwegverpackung | LIEFER2     | 1      | 25  | GK0    | Einkaufspreis | 10        | WG-RHB  | PG-UE  |
      | GITTERBOX    | Gitterbox          | bedarfsbezogen | ja          | Behälter     | !dontChange | 70          | Mehrwegverpackung | LIEFER2     | 1      | 150 | GK0    | Einkaufspreis | 10        | WG-RHB  | PG-UE  |
      | FUELLMAT     | Füllmaterial       | bedarfsbezogen | ja          | Füllmaterial | !dontChange |             | Einwegverpackung  | LIEFER2     | 1      | 10  | GK0    | Einkaufspreis | 10        | WG-RHB  | PG-UE  |
      | ZWISCHENLAGE | Zwischenlage       | bedarfsbezogen | ja          | Zwischenlage | !dontChange |             | Einwegverpackung  | LIEFER2     | 1      | 2   | GK0    | Einkaufspreis | 10        | WG-RHB  | PG-UE  |
      | BEHAELTER    | !dontChange        | !dontChange    | !dontChange | !dontChange  | !dontChange | !dontChange | !dontChange       | !dontChange | 1      | 15  | GK0    | !dontChange   | 10        | WG-RHB  | PG-UE  |
      | PALETTE      | !dontChange        | !dontChange    | !dontChange | !dontChange  | !dontChange | !dontChange | !dontChange       | !dontChange | 1      | 15  | GK0    | !dontChange   | 10        | WG-RHB  | PG-UE  |

  Scenario Outline: Packanweisungen
    Given I open an editor "<such>" from table "(PackingInstructions):(PackingInstructions)" with command "STORE" for record "<such>"
    And I set fields
      | such     | <such>     |
      | namebspr | <namebspr> |
    And I delete all rows
    And I modify table
      | artikel    | anzahl    | ebene       | minebene    | auffuell    | !row   |
      | <artikel1> | <anzahl1> | <ebene1>    | <minebene1> | <auffuell1> | +1     |
      | <artikel2> | <anzahl2> | !dontChange | !dontChange | <auffuell2> | <row2> |
      | <artikel3> | <anzahl3> | !dontChange | !dontChange | <auffuell3> | <row3> |
      | <artikel4> | <anzahl4> | !dontChange | !dontChange | <auffuell4> | <row4> |
    And I save the current editor
    Examples:
      | such               | namebspr                                        | artikel1  | anzahl1 | ebene1 | minebene1 | auffuell1 | artikel2     | anzahl2     | auffuell2   | artikel3    | anzahl3     | auffuell3   | artikel4    | anzahl4     | auffuell4   | row2 | row3 | row4 |
      | LAGER_EINFACH      | Nur Gitterbox                                   | GITTERBOX | 1       | 1      | 1         | nein      | !dontChange  | !dontChange | !dontChange | !dontChange | !dontChange | !dontChange | !dontChange | !dontChange | !dontChange | 0    | 0    | 0    |
      | LAGER_ZWEISTUFIG   | Behälter & Palette                              | BEHAELTER | 4       | 2      | 1         | nein      | P-PALETTE    | 1           | !dontChange | !dontChange | !dontChange | !dontChange | !dontChange | !dontChange | !dontChange | +2   | 0    | 0    |
      | VERSAND_EINFACH    | Behälter & Palette                              | BEHAELTER | 4       | 4      | 1         | ja        | P-PALETTE    | 1           | nein        | !dontChange | !dontChange | !dontChange | !dontChange | !dontChange | !dontChange | +2   | 0    | 0    |
      | VERSAND_MEHRSTUFIG | Behälter, Zwischenlage, Palette, Palettendeckel | BEHAELTER | 4       | 3      | 2         | ja        | ZWISCHENLAGE | 1           | nein        | P-PALETTE   | 1           | nein        | PAL-DECKEL  | 1           | nein        | +2   | +3   | +4   |



 ###### Maschinengruppen, Arbeitsgänge und Fertigungsmittel ######

  Scenario Outline: Maschinengruppen
    Given I open an editor "<such>" from table "(Capacity):(WorkCenter)" with command "STORE" for record "<such>"
    And I set fields
      | abtlg    | <abtlg>    |
      | kstelle  | <kstelle>  |
      | manz     | <manz>     |
      | nschicht | <nschicht> |
      | azpt     | <azpt>     |
      | such     | <such>     |
      | namebspr | <namebspr> |
      | auslast  | <auslast>  |
      | leist    | <leist>    |
      | kapaz    | <kapaz>    |
      | gkapaz   | <gkapaz>   |
      | fixkost  | <fixkost>  |
      | varkost  | <varkost>  |
      | automzeit| <automzt>  |
    And I save the current editor
    Examples:
      | such | namebspr         | abtlg | kstelle | manz | nschicht | azpt | auslast | leist | kapaz | gkapaz | fixkost | varkost | automzt |
      | MGR1 | Maschinengruppe1 | A1    | KS-MK   | 2    | 1        | 7,5  | 80      | 50    | 3     | 6      | 10      | 5       | nein    |
      | MGR2 | Maschinengruppe2 | A1    | KS-MK   | 1    | 1        | 7,5  | 100     | 100   | 7,5   | 7,5    | 5       | 5       | nein    |
      | MGR3 | Maschinengruppe3 | A2    | KS-MK   | 2    | 2        | 7,5  | 120     | 120   | 21,6  | 43,2   | 10      | 10      | nein    |
      | MGR4 | Maschinengruppe4 | A2    | KS-MK   | 1    | 2        | 7,5  | 100     | 100   | 15    | 15     | 10      | 10      | nein    |
      | MGR5 | Maschinengruppe5 | A2    | KS-MK   | 0    | 2        | 7,5  | 100     | 100   | 11    | 0      | 15      | 15      | nein    |


  Scenario Outline: Arbeitsgänge
    Given I open an editor "<such>" from table "(Operation):(Operation)" with command "STORE" for record "<such>"
    And I set fields
      | such        | <such>        |
      | namebspr    | <namebspr>    |
      | mgr         | <mgr>         |
      | grgr        | <grgr>        |
      | grgrruesten | <grgrruesten> |
      | lgr         | <lgr>         |
      | lgrruesten  | <lgrruesten>  |
      | aschein     | <aschein>     |
      | skostfix    | <skostfix>    |
      | tr          | <tr>          |
      | te          | <te>          |
    And I save the current editor
    Examples:
      | such     | namebspr              | mgr  | grgr | grgrruesten | lgr | lgrruesten | aschein | skostfix | tr | te |
      | AG-LOHN1 | AG Lohngruppe 1       | MGR1 | 1    | 0           | 1   |            | ja      | 10       | 20 | 10 |
      | AG-LOHN2 | AG Lohngruppe 2       | MGR1 | 1    | 0           | 2   |            | ja      | 15       | 30 | 15 |
      | AG-LOHN3 | AG Lohngruppe 3       | MGR1 | 1    | 0           | 3   |            | ja      | 5        | 30 | 10 |
      | AG-OHNE  | AG ohne Arbeitsschein | MGR2 | 1    | 0           | 1   |            | nein    | 5        | 10 | 5  |
      | AG-RUEST | AG Lgr für Ruesten    | MGR2 | 1    | 0           | 1   | 4          | ja      | 5        | 60 | 1  |
      | AG-NOMANZ| AG ohne Maschinenanz  | MGR5 | 1    | 3           | 1   | 3          | ja      | 6        | 60 | 1  |
      | AG-NOGR  | AG ohne Gruppengroesse| MGR3 | 0    | 0           | 1   | 0          | ja      | 7        | 60 | 1  |


  Scenario Outline: Fertigungsmittel
    Given I open an editor "<such>" from table "(Part):(MeansOfProduction)" with command "STORE" for record "<such>"
    And I set fields
      | such     | <such>     |
      | namebspr | <namebspr> |
      | wkosten  | <wkosten>  |
      | ekosten  | <ekosten>  |
      | skostfix | <skostfix> |
      | skostvar | <skostvar> |
    And I save the current editor
    Examples:
      | such  | namebspr             | wkosten | ekosten | skostfix | skostvar |
      | TESTF | Testfertigungsmittel |         | 1       | 10       | 5        |



 ###### Artikel (Artikel, Baugruppen, Basisartikel) ######

  Scenario Outline: Einkaufsartikel
    Given I open an editor "<such>" from table "(Part):(Product)" with command "STORE" for record "<such>"
    And I set fields
      | such            | <such>           |
      | namebspr        | <namebspr>       |
      | bsart           | Fremdbeschaffung |
      | dispoa          | <dispoa>         |
      | mindest         | <mindest>        |
      | maxbsmge        | <maxbsmge>       |
      | minbsmge        | <minbsmge>       |
      | losgr           | <losgr>          |
      | losbild         | <losbild>        |
      | rundung         | <rundung>        |
      | chverfolgung    | <chverfolgung>   |
      | lief            | <lief>           |
      | efrist          | <efrist>         |
      | epr             | <epr>            |
      | gemein          | <gemein>         |
      | kbpr            | <kbpr>           |
      | ekbewverf       | <ekbewverf>      |
      | wgruppe         | <wgruppe>        |
      | erlgrp          | <erlgrp>         |
      | matart          | <matart>         |
      | zmge            | <zmge>           |
      | matvrel         | <matvrel>        |
      | materel         | <materel>        |
    And I save the current editor
    Examples:
      | such            | namebspr                         | dispoa                   | mindest     | maxbsmge    | minbsmge    | losgr       | losbild     | rundung     | chverfolgung        | lief        | efrist      | epr         | gemein      | kbpr          | ekbewverf | wgruppe | erlgrp | matart | zmge | matvrel | materel |
      | EK1-BEDARF      | bedarfsbezogenes Teil 1          | bedarfsbezogen           | 0           | 0           | 0           | 0           | 0           | 0           |                     | LIEFER1     | 3           | 5           | GK2.14.3    | Einkaufspreis | 6         | WG-RHB  | PG-UE  |        |      |         |         |
      | EK1-BEDARF_CH   | bedarfsbez Teil 1 mit CH-Pflicht | bedarfsbezogen           | 0           | 0           | 0           | 0           | 0           | 0           | Chargenverfolgung   | LIEFER1     | 3           | 5           | GK2.14.3    | Einkaufspreis | 6         | WG-RHB  | PG-UE  |        |      |         |         |
      | EK2-BEDARF      | bedarfsbezogenes Teil 2          | bedarfsbezogen           | 0           | 0           | 0           | 0           | 0           | 0           |                     | LIEFER1     | 3           | 5           | GK2.14.3    | Einkaufspreis | 6         | WG-RHB  | PG-UE  |        |      |         |         |
      | EK2-BEDARF_CH   | bedarfsbez Teil 2 mit CH-Pflicht | bedarfsbezogen           | 0           | 0           | 0           | 0           | 0           | 0           | Chargenverfolgung   | LIEFER1     | 3           | 5           | GK2.14.3    | Einkaufspreis | 6         | WG-RHB  | PG-UE  |        |      |         |         |
      | EK3-BEDARF      | bedarfsbezogenes Teil 3          | bedarfsbezogen           | 0           | 0           | 0           | 0           | 0           | 0           |                     | LIEFER1     | 3           | 5           | GK2.14.3    | Einkaufspreis | 6         | WG-RHB  | PG-UE  |        |      |         |         |
      | EK3-BEDARF_CH   | bedarfsbez Teil 3 mit CH-Pflicht | bedarfsbezogen           | 0           | 0           | 0           | 0           | 0           | 0           | Chargenverfolgung   | LIEFER1     | 3           | 5           | GK2.14.3    | Einkaufspreis | 6         | WG-RHB  | PG-UE  |        |      |         |         |
      | EK1-AUFTRAG     | auftragsbezoges Teil 1           | auftragsbezogen          | 0           | 0           | 0           | 0           | 0           | 0           |                     | LIEFER1     | 3           | 5           | GK2.14.3    | Einkaufspreis | 6         | WG-RHB  | PG-UE  |        |      |         |         |
      | EK2-AUFTRAG     | auftragsbezoges Teil 2           | auftragsbezogen          | 0           | 0           | 0           | 0           | 0           | 0           |                     | LIEFER1     | 3           | 5           | GK2.14.3    | Einkaufspreis | 6         | WG-RHB  | PG-UE  |        |      |         |         |
      | EK-ERWBEDARF    | erweitert bedarfsbezogenes Teil  | erweitert bedarfsbezogen | 0           | 0           | 0           | 0           | 0           | 0           |                     | LIEFER1     | 3           | 5           | GK2.14.3    | Einkaufspreis | 6         | WG-RHB  | PG-UE  |        |      |         |         |
      | EK-KEINE        | Entnahmeart keine                |                          | 0           | 0           | 0           | 0           | 0           | 0           |                     | LIEFER1     | 3           | 5           | GK2.14.3    | Einkaufspreis | 6         | WG-RHB  | PG-UE  |        |      |         |         |
      | EK-MINDESTB     | mindestbestandsbezoges Teil      | mindestbestandsbezogen   | 0           | 0           | 0           | 0           | 0           | 0           |                     | LIEFER1     | 3           | 5           | GK2.14.3    | Einkaufspreis | 6         | WG-RHB  | PG-UE  |        |      |         |         |
      | EK-PROJEKT      | projektbezoges Teil              | projektbezogen           | 0           | 0           | 0           | 0           | 0           | 0           |                     | LIEFER1     | 3           | 5           | GK2.14.3    | Einkaufspreis | 6         | WG-RHB  | PG-UE  |        |      |         |         |
      | EK-RESTMENGE    | restmengenbezogenesbezoges Teil  | restmengenbezogen        | 0           | 0           | 0           | 0           | 0           | 0           |                     | LIEFER1     | 3           | 5           | GK2.14.3    | Einkaufspreis | 6         | WG-RHB  | PG-UE  |        |      |         |         |
      | KOPPELPROD      | Koppelprodukt                    | bedarfsbezogen           | 0           | 0           | 0           | 0           | 0           | 0           |                     |             |             |             | GK2.14.3    | Einkaufspreis | 6         | WG-RHB  | PG-UE  |        |      |         |         |
      | UMBAUART        | Artikel Zugang durch Umbau       | bedarfsbezogen           | 0           | 0           | 0           | 0           | 0           | 0           |                     |             |             |             | GK2.14.3    | Einkaufspreis | 6         | WG-RHB  | PG-UE  |        |      |         |         |
      | EK-LOSGROESSE   | Losgröße und Losbildungsfrist    | bedarfsbezogen           | 0           | 0           | 0           | 10          | 3           | 0           |                     | LIEFER1     | 3           | 5           | GK2.14.3    | Einkaufspreis | 6         | WG-RHB  | PG-UE  |        |      |         |         |
      | EK-MIT_MINDESTB | Mindestbestand                   | bedarfsbezogen           | 50          | 0           | 0           | 0           | 0           | 0           |                     | LIEFER1     | 3           | 5           | GK2.14.3    | Einkaufspreis | 6         | WG-RHB  | PG-UE  |        |      |         |         |
      | EK-MINBESCHAFF  | Minimale Beschaffmenge           | bedarfsbezogen           | 0           | 0           | 50          | 0           | 0           | 0           |                     | LIEFER1     | 3           | 5           | GK2.14.3    | Einkaufspreis | 6         | WG-RHB  | PG-UE  |        |      |         |         |
      | EK-MAXBESCHAFF  | Maximale Beschaffmenge           | bedarfsbezogen           | 0           | 50          | 0           | 0           | 0           | 0           |                     | LIEFER1     | 3           | 5           | GK2.14.3    | Einkaufspreis | 6         | WG-RHB  | PG-UE  |        |      |         |         |
      | EK-BEDARF_MIX   | alle möglichen Parameter gesetzt | bedarfsbezogen           | 100         | 100         | 25          | 25          | 2           | 0           |                     | LIEFER1     | 3           | 5           | GK2.14.3    | Einkaufspreis | 6         | WG-RHB  | PG-UE  |        |      |         |         |
      | EK-AUFTRAG_MIX  | alle möglichen Parameter gesetzt | bedarfsbezogen           | 100         | 100         | 0           | 0           | 2           | 0           |                     | LIEFER1     | 3           | 5           | GK2.14.3    | Einkaufspreis | 6         | WG-RHB  | PG-UE  |        |      |         |         |
      | HALBFABRIKAT    | Halbfabrikat                     | bedarfsbezogen           | 0           | 0           | 0           | 0           | 0           | 0           |                     | LIEFER1     | 3           | 5           | GK2.14.3    | Einkaufspreis | 6         | WG-RHB  | PG-UE  |        |      |         |         |
      | BEISTELLTEIL    | Für Beistellungen in Stückliste  | bedarfsbezogen           | 0           | 0           | 0           | 0           | 0           | 0           |                     | LIEFER1     | 3           | 5           | GK2.14.3    | Einkaufspreis | 6         | WG-RHB  | PG-UE  |        |      |         |         |
      | EK-MATZUSCHLAG  | Materialzuschlag CU              | bedarfsbezogen           | 0           | 0           | 0           | 0           | 0           | 0           |                     | LIEFER1     | 3           | 5           | GK2.14.3    | Einkaufspreis | 6         | WG-RHB  | PG-UE  | CU     | 1    | ja      | ja      |
      | EK-NACHFOLGER   | Nachfolgeartikel für EK-AUSLAUF  | bedarfsbezogen           | 0           | 0           | 0           | 0           | 0           | 0           |                     | LIEFER1     | 3           | 5           | GK2.14.3    | Einkaufspreis | 6         | WG-RHB  | PG-UE  |        |      |         |         |
      | E1              | !dontChange                      | !dontChange              | !dontChange | !dontChange | !dontChange | !dontChange | !dontChange | !dontChange | !dontChange         | !dontChange | !dontChange | !dontChange | !dontChange | !dontChange   | 6         | WG-RHB  | PG-UE  |        |      |         |         |
      | E2              | !dontChange                      | !dontChange              | !dontChange | !dontChange | !dontChange | !dontChange | !dontChange | !dontChange | !dontChange         | !dontChange | !dontChange | !dontChange | !dontChange | !dontChange   | 6         | WG-RHB  | PG-UE  |        |      |         |         |
      | E3              | !dontChange                      | !dontChange              | !dontChange | !dontChange | !dontChange | !dontChange | !dontChange | !dontChange | !dontChange         | !dontChange | !dontChange | !dontChange | !dontChange | !dontChange   | 6         | WG-RHB  | PG-UE  |        |      |         |         |
      | EINK            | !dontChange                      | !dontChange              | !dontChange | !dontChange | !dontChange | !dontChange | !dontChange | !dontChange | !dontChange         | LIEFER1     | 1           | 2           | GK2.14.3    | !dontChange   | 6         | WG-RHB  | PG-UE  |        |      |         |         |
      | EK-B-VERS1      | Version zu Basisartikel 1        | bedarfsbezogen           | 0           | 0           | 0           | 0           | 0           | 0           |                     | LIEFER1     | 3           | 5           | GK2.14.3    | Einkaufspreis | 6         | WG-RHB  | PG-UE  |        |      |         |         |
      | EK-B-VERS2      | Version zu Basisartikel 2        | bedarfsbezogen           | 0           | 0           | 0           | 0           | 0           | 0           |                     | LIEFER1     | 3           | 3           | GK2.14.3    | Einkaufspreis | 6         | WG-RHB  | PG-UE  |        |      |         |         |
      | EK1-BEDARF_RD   | bedarfsbezogenes Teil 1 gerundet | bedarfsbezogen           | 0           | 0           | 0           | 0           | 0           | 5           |                     | LIEFER1     | 3           | 5           | GK2.14.3    | Einkaufspreis | 6         | WG-RHB  | PG-UE  |        |      |         |         |
      | EK2-BEDARF_RD   | bedarfsbezogenes Teil 2 gerundet | bedarfsbezogen           | 0           | 0           | 0           | 0           | 0           | 10          |                     | LIEFER1     | 3           | 5           | GK2.14.3    | Einkaufspreis | 6         | WG-RHB  | PG-UE  |        |      |         |         |
      | EK3-BEDARF_RD   | bedarfsbezogenes Teil 3 gerundet | bedarfsbezogen           | 0           | 0           | 0           | 0           | 0           | 10          |                     | LIEFER1     | 3           | 5           | GK2.14.3    | Einkaufspreis | 6         | WG-RHB  | PG-UE  |        |      |         |         |


  Scenario Outline: Einkaufsartikel mit Nachfolgeartikel
    Given I open an editor "<such>" from table "(Part):(Product)" with command "STORE" for record "<such>"
    And I set fields
      | such             | <such>             |
      | namebspr         | <namebspr>         |
      | bsart            | Fremdbeschaffung   |
      | dispoa           | <dispoa>           |
      | nachfolgeartikel | <nachfolgeartikel> |
      | lbsdatum         | <lbsdatum>         |
      | lverwdatum       | <lverwdatum>       |
      | vgltermin        | <vgltermin>        |
      | lief             | <lief>             |
      | efrist           | <efrist>           |
      | epr              | <epr>              |
      | gemein           | <gemein>           |
      | kbpr             | <kbpr>             |
      | ekbewverf        | <ekbewverf>        |
      | wgruppe          | <wgruppe>          |
      | erlgrp           | <erlgrp>           |
    And I save the current editor
    Examples:
      | such       | namebspr                         | dispoa         | nachfolgeartikel | lbsdatum | lverwdatum | vgltermin     | lief    | efrist | epr | gemein   | kbpr          | ekbewverf | wgruppe | erlgrp |
      | EK-AUSLAUF | Beschaff bis heute,Nachfolger+30 | bedarfsbezogen | EK-NACHFOLGER    | .        | +30        | Anfangstermin | LIEFER1 | 3      | 7   | GK2.14.3 | Einkaufspreis | 6         | WG-RHB  | PG-UE  |


  Scenario Outline: Einkaufsartikel mit Lagergruppeneigenschaften
    Given I open an editor "<such>" from table "(Part):(Product)" with command "STORE" for record "<such>"
    And I set fields
      | such      | <such>      |
      | namebspr  | <namebspr>  |
      | bsart     | <bsart>     |
      | dispoa    | <dispoa>    |
      | lief      | <lief>      |
      | efrist    | <efrist>    |
      | epr       | <epr>       |
      | gemein    | <gemein>    |
      | kbpr      | <kbpr>      |
      | ekbewverf | <ekbewverf> |
      | wgruppe   | <wgruppe>   |
      | erlgrp    | <erlgrp>    |
    And I press button "alge" to open a subeditor for "Lagergruppeneigenschaften"
    And I delete all rows
    And I append rows
      | lgruppe   | dispoa    | bsart    | umllg   | lief    |
      | <lgruppe> | <dispoa2> | <bsart2> | <umllg> | <lief2> |
    And I save the current subeditor to switch back to the parent editor
    And I save the current editor
    Examples:
      | such           | namebspr                         | dispoa         | bsart            | lief    | efrist | epr | gemein   | kbpr          | ekbewverf | wgruppe | erlgrp | lgruppe | dispoa2        | bsart2           | umllg     | lief2   |
      | EK-LAGERGRUPPE | Lagergruppeneigenschaften Berlin | bedarfsbezogen | Fremdbeschaffung | LIEFER1 | 5      | 5   | GK2.14.3 | Einkaufspreis | 6         | WG-RHB  | PG-UE  | BERLIN  | bedarfsbezogen | Fremdbeschaffung | KARLSRUHE | LIEFER2 |


  Scenario Outline: Einkaufsartikel mit Stückliste
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
    And I delete all rows
    And I append rows
      | elex    | elanzahl    | bua    | kompeig   |
      | <elex1> | <elanzahl1> | <bua1> | <kompeig> |
      | <elex2> | <elanzahl2> | <bua2> |           |
    And I save the current editor
    Examples:
      | such        | namebspr                | dispoa         | lief        | efrist | epr         | gemein   | kbpr          | ekbewverf | wgruppe | erlgrp | elex1      | elanzahl1 | bua1                   | kompeig | elex2 | elanzahl2 | bua2 |
      | EK-BEISTELL | EK-Teil mit Beistellung | bedarfsbezogen | LIEFER1     | 3      | 10          | GK2.14.3 | Einkaufspreis | 6         | WG-RHB  | PG-UE  | EK1-BEDARF | 1         | Lieferantenbeistellung |         |       |           |      |
      | TEST        | !dontChange             | !dontChange    | !dontChange | 1      | !dontChange | GK2.14.3 | !dontChange   | 6         | WG-RHB  | PG-UE  | TESTF      | 2         |                        |         | TESTF | 3         |      |


  Scenario Outline: Einkaufsartikel mit Einheiten und Einkaufsartikel mit Einheiten und Gebindepflicht
    Given I open an editor "<such>" from table "(Part):(Product)" with command "STORE" for record "<such>"
    And I set fields
      | such      | <such>           |
      | namebspr  | <namebspr>       |
      | dispoa    | <dispoa>         |
      | bsart     | Fremdbeschaffung |
      | rundung   | <rundung>        |
      | lief      | <lief>           |
      | efrist    | <efrist>         |
      | epr       | <epr>            |
      | gemein    | <gemein>         |
      | ekbewverf | <ekbewverf>      |
      | wgruppe   | <wgruppe>        |
      | erlgrp    | <erlgrp>         |
      | gebehe    | <gebehe>         |
      | fehe      | <fehe>           |
      | ehe       | <ehe>            |
      | fehle     | <fehle>          |
      | le        | <le>             |
      | gebepe    | <gebepe>         |
      | fepe      | <fepe>           |
      | epe       | <epe>            |
      | feple     | <feple>          |
      | gebve     | <gebve>          |
      | fve       | <fve>            |
      | ve        | <ve>             |
      | fvele     | <fvele>          |
      | gebge     | <gebge>          |
      | fge       | <fge>            |
      | ge        | <ge>             |
      | fgele     | <fgele>          |
    And I save the current editor
    Examples:
      | such          | namebspr                         | dispoa         | rundung | lief    | efrist | epr | gemein   | ekbewverf | wgruppe | erlgrp | gebehe | fehe | ehe  | fehle | le    | gebepe | fepe | epe  | feple | gebve | fve | ve   | fvele | gebge | fge | ge   | fgele |
      | EK-EINHEITEN  | Handel-&Lagereinheit verschieden | bedarfsbezogen |         | LIEFER1 | 3      | 5   | GK2.14.3 | 6         | WG-RHB  | PG-UE  |        | 5    | kg   | 1     | Stück |        | 5    | kg   | 1     |       | 5   | kg   | 1     |       | 5   | kg   | 1     |
      | EK-GEBINDEPFL | Faktor und Gebindepflicht        | bedarfsbezogen |         | LIEFER1 | 3      | 5   | GK2.14.3 | 6         | WG-RHB  | PG-UE  | ja     | 1    | Paar | 2     | Stück | ja     | 1    | Paar | 2     | ja    | 1   | Paar | 2     | ja    | 1   | Paar | 2     |
      | EK-RUNDUNG    | rundung=1; Lagereinheit Meter    | bedarfsbezogen | 1       | LIEFER1 | 3      | 5   | GK2.14.3 | 6         | WG-RHB  | PG-UE  |        | 300  | g    | 3,25  | m     |        | 300  | g    | 3,25  |       | 300 | g    | 3,25  |       | 300 | g    | 3,25  |


  Scenario Outline: Einkaufsartikel mit Chargen/Seriennummern
    Given I open an editor "<such>" from table "(Part):(Product)" with command "STORE" for record "<such>"
    And I set fields
      | such          | <such>            |
      | namebspr      | <namebspr>        |
      | bsart         | Fremdbeschaffung  |
      | dispoa        | <dispoa>          |
      | chverfolgung  | <chverfolgung>    |
      | chimlager     | <chimlager>       |
      | lief          | <lief>            |
      | efrist        | <efrist>          |
      | epr           | <epr>             |
      | vpr           | <vpr>             |
    And I save the current editor
    Examples:
      | such            | namebspr                         | dispoa                   | chverfolgung              | chimlager     | lief        | efrist      | epr         | vpr         |
      | NOCHARGE2       | ohne Chargenpflicht              | bedarfsbezogen           |                           | !dontChange   | TEST        | 3           | 5           | 10          |
      | INVNOCHARGE     | Inventur ohne Charge             | auftragsbezogen          |                           | !dontChange   | TEST        | 3           | 5           | 10          |
      | EK01_SNR        | seriennummernpflichtiges Teil 1  | bedarfsbezogen           | Seriennummernverfolgung   | ja            | LIEFCHA1    | 3           | 5           | 10          |
      | EK02_SNR        | seriennummernpflichtiges Teil 1  | bedarfsbezogen           | Seriennummernverfolgung   | ja            | LIEFCHA1    | 3           | 5           | 10          |
      | EKBEI_SNR       | seriennummernpflicht Beistell    | bedarfsbezogen           | Seriennummernverfolgung   | ja            | TEST        | 3           | 5           | 10          |
      | SET_KOMP01_SNR  | seriennummernpflicht Setkomp 1   | bedarfsbezogen           | Seriennummernverfolgung   | ja            | TEST        | 3           | 5           | 10          |
      | SET_KOMP02_SNR  | seriennummernpflicht Setkomp 2   | bedarfsbezogen           | Seriennummernverfolgung   | ja            | TEST        | 3           | 5           | 10          |
      | EK-KDANLIEFER   | seriennummernpflicht Kundeanlief | bedarfsbezogen           | Seriennummernverfolgung   | ja            | LIEFCHA1    | 3           | 5           | 10          |
      | EK-UMLAGERSNR   | seriennummernpflicht umlagern    | bedarfsbezogen           | Seriennummernverfolgung   | ja            | LIEFCHA1    | 3           | 5           | 10          |
      | KOPPEL_SNR      | Koppelprod Seriennummernpflicht  | bedarfsbezogen           | Seriennummernverfolgung   | ja            | TEST        | 3           | 5           | 10          |
      | EINHEIT_SNR     | seriennummernpflicht mit Einheit | bedarfsbezogen           | Seriennummernverfolgung   | ja            | LIEFCHA1    | 3           | 5           | 10          |
      | INV_LAGERJA_SNR | Inventur chimlagerja SNR-Pflicht | auftragsbezogen          |                           | !dontChange   | TEST        | 3           | 5           | 10          |


  Scenario: Einkaufsartikel mit Beistellung, Artikel mit Einheit und Setartikel anlegen
    Given I open an editor "KT-BEISTELL_SNR" from table "(Part):(Product)" with command "STORE" for record "KT-BEISTELL_SNR"
    And I set fields
      | such          | KT-BEISTELL_SNR            |
      | namebspr      | Kaufteil mit Beistellung   |
      | bsart         | Fremdbeschaffung           |
      | lief          | LIEFCHA2                   |
      | chverfolgung  | Seriennummernverfolgung    |
    And I delete all rows
    And I append rows
      | elex      | elanzahl  | bua                       |
      | EKBEI_SNR | 1         | Lieferantenbeistellung    |
    And I save the current editor

    Given I open an editor "EINHEIT_SNR" from table "(Part):(Product)" with command "UPDATE" for record "EINHEIT_SNR"
    And I set field "ehe" to "m"
    And I save the current editor

    Given I open an editor "SET-SNR" from table "(Part):(Product)" with command "STORE" for record "SET-SNR"
    And I set fields
      | such          | SET-SNR                       |
      | namebspr      | SNR-pflichtiger Setartikel    |
      | earta         | über Stückliste               |
      | chverfolgung  |                               |
    And I delete all rows
    And I append rows
      | elex              | elanzahl  |
      | SET_KOMP01_SNR    | 1         |
      | SET_KOMP02_SNR    | 2         |
    And I save the current editor



  Scenario Outline: Lohnfertigung
    Given I open an editor "<such>" from table "(Part):(Product)" with command "STORE" for record "<such>"
    And I set fields
      | such      | <such>        |
      | namebspr  | <namebspr>    |
      | bsart     | Lohnfertigung |
      | dispoa    | <dispoa>      |
      | lief      | <lief>        |
      | efrist    | <efrist>      |
      | epr       | <epr>         |
      | gemein    | <gemein>      |
      | kbpr      | <kbpr>        |
      | ekbewverf | <ekbewverf>   |
      | wgruppe   | <wgruppe>     |
      | erlgrp    | <erlgrp>      |
    And I delete all rows
    And I append rows
      | elex    | elanzahl    | kompeig    |
      | <elex1> | <elanzahl1> | <kompeig1> |
      | <elex2> | <elanzahl2> |            |
    And I save the current editor
    Examples:
      | such          | namebspr         | dispoa         | lief   | efrist | epr | gemein   | kbpr          | ekbewverf | wgruppe | erlgrp | elex1        | elanzahl1 | kompeig1     | elex2 | elanzahl2 |
      | LOHNFERTIGUNG | Mit Halbfabrikat | bedarfsbezogen | K-LIEF | 3      | 10  | GK2.14.3 | Einkaufspreis | 6         | WG-RHB  | PG-UE  | HALBFABRIKAT | 0         | Halbfabrikat |       |           |


  Scenario Outline: Baugruppe mit Servicepflicht, zwei Komponenten und ein Arbeitsgang
    Given I open an editor "<such>" from table "(Part):(Product)" with command "STORE" for record "<such>"
    And I set fields
      | such      | <such>         |
      | namebspr  | <namebspr>     |
      | dispoa    | <dispoa>       |
      | bsart     | Eigenfertigung |
      | gemein    | <gemein>       |
      | ekbewverf | <ekbewverf>    |
      | wgruppe   | <wgruppe>      |
      | erlgrp    | <erlgrp>       |
    And I delete all rows
    And I append rows
      | elex    | anzahl    |
      | <elex1> | <anzahl1> |
      | <elex2> | <anzahl2> |
      | <elex3> | <anzahl3> |
    And I save the current editor
    Examples:
      | such       | namebspr          | dispoa          | gemein   | ekbewverf | wgruppe | erlgrp | elex1 | anzahl1 | elex2 | anzahl2 | elex3  | anzahl3 |
      | BG-SERVICE | BG Servicepflicht | auftragsbezogen | GK2.14.3 | 6         | WG-RHB  | PG-UE  | V1    | 1       | E3    | 1       | A DREH | 1       |


  Scenario Outline: Baugruppen mit einer Komponente und zwei Arbeitsgängen, Lagergruppeneigenschaften Eigenfertigung mit Standard-Fertigungsliste
    Given I open an editor "<such>" from table "(Part):(Product)" with command "STORE" for record "<such>"
    And I set fields
      | such            | <such>            |
      | namebspr        | <namebspr>        |
      | dispoa          | <dispoa>          |
      | bsart           | Eigenfertigung    |
      | chverfolgung    | <chverfolgung>    |
      | ekbewverf       | <ekbewverf>       |
      | gemein          | <gemein>          |
      | wgruppe         | <wgruppe>         |
      | erlgrp          | <erlgrp>          |

  # Lagergruppeneigenschaften zuerst anpassen, sonst wird die Stueckliste geloescht
    And I press button "alge" to open a subeditor for "Lagergruppeneigenschaften"
    And I delete all rows
    And I append rows
      | lgruppe   | bsart          |
      | <lgruppe> | Eigenfertigung |
    And I save the current subeditor to switch back to the parent editor


    And I delete all rows
    And I append rows
      | elex    | anzahl    |
      | <elex1> | <anzahl1> |
      | <elex2> | <anzahl2> |
      | <elex3> | <anzahl3> |
    And I save the current editor

    Examples:
      | such         | namebspr                        | dispoa          | chverfolgung         | ekbewverf | gemein   | wgruppe | erlgrp | elex1         | anzahl1 | elex2      | anzahl2 | elex3      | anzahl3 | lgruppe |
      | BG-BEDARF    | Bedarfsbez, Lgruppeneigenschaft | bedarfsbezogen  |                      | 6         | GK2.14.3 | WG-RHB  | PG-UE  | EK1-BEDARF    | 1       | A AG-LOHN1 | 1       | A AG-LOHN2 | 1       | BERLIN  |
      | BG-BEDARF_CH | Bedarfsbez, Lgruppeneig, Charge | bedarfsbezogen  | Chargenverfolgung    | 6         | GK2.14.3 | WG-RHB  | PG-UE  | EK1-BEDARF_CH | 1       | A AG-LOHN1 | 1       | A AG-LOHN2 | 1       | BERLIN  |
      | BG-AUFTRAG   | Auftragsbez, Lgruppeneigenschft | auftragsbezogen |                      | 6         | GK2.14.3 | WG-RHB  | PG-UE  | EK1-AUFTRAG   | 1       | A AG-LOHN1 | 1       | A AG-LOHN2 | 1       | BERLIN  |


  Scenario Outline: Baugruppen mit einer Komponenten und zwei Arbeitsgängen
    Given I open an editor "<such>" from table "(Part):(Product)" with command "STORE" for record "<such>"
    And I set fields
      | such      | <such>         |
      | namebspr  | <namebspr>     |
      | dispoa    | <dispoa>       |
      | bsart     | Eigenfertigung |
      | ekbewverf | <ekbewverf>    |
      | gemein    | <gemein>       |
      | wgruppe   | <wgruppe>      |
      | erlgrp    | <erlgrp>       |
    And I delete all rows
    And I append rows
      | elex    | anzahl    | lge    | breite    |
      | <elex1> | <anzahl1> | <lge1> | <breite1> |
      | <elex3> | <anzahl3> |        |           |
      | <elex4> | <anzahl4> |        |           |
    And I save the current editor
    Examples:
      | such | namebspr    | dispoa      | ekbewverf | gemein   | wgruppe | erlgrp | elex1 | lge1        | breite1     | anzahl1 | elex3  | anzahl3 | elex4  | anzahl4 |
      | BG1  | !dontChange | !dontChange | 6         | GK2.14.3 | WG-RHB  | PG-UE  | E1    | 10          | 100         | 2       | A AG1  | 1       | A AG2  | 1       |
      | BAUT | !dontChange | !dontChange | 6         | GK2.14.3 | WG-RHB  | PG-UE  | EINK  | !dontChange | !dontChange | 2       | A BOHR | 1       | A DREH | 1       |


  Scenario Outline: Baugruppen mit zwei Komponenten und zwei Arbeitsgängen
    Given I open an editor "<such>" from table "(Part):(Product)" with command "STORE" for record "<such>"
    And I set fields
      | such      | <such>         |
      | namebspr  | <namebspr>     |
      | dispoa    | <dispoa>       |
      | bsart     | Eigenfertigung |
      | ekbewverf | <ekbewverf>    |
      | gemein    | <gemein>       |
      | wgruppe   | <wgruppe>      |
      | erlgrp    | <erlgrp>       |
    And I delete all rows
    And I append rows
      | elex    | anzahl    | kompeig   |
      | <elex1> | <anzahl1> |           |
      | <elex2> | <anzahl2> | <kompeig> |
      | <elex3> | <anzahl3> |           |
      | <elex4> | <anzahl4> |           |
    And I save the current editor
    Examples:
      | such             | namebspr                         | dispoa            | ekbewverf | gemein      | wgruppe | erlgrp | elex1      | anzahl1 | elex2      | anzahl2 | kompeig       | elex3         | anzahl3 | elex4       | anzahl4 |
      | BG-EIN_AUSLAUF   | Ein/Auslaufartikel in Stückliste | bedarfsbezogen    | 6         | GK2.14.3    | WG-RHB  | PG-UE  | EK1-BEDARF | 1       | EK-AUSLAUF | 1       |               | A AG-OHNE     | 1       | A AG-LOHN1  | 1       |
      | BG-KOPPELPROD    | Koppelprodukt in Stückliste      | bedarfsbezogen    | 6         | GK2.14.3    | WG-RHB  | PG-UE  | EK1-BEDARF | 1       | KOPPELPROD | 1       | Koppelprodukt | A AG-OHNE     | 1       | A AG-LOHN1  | 1       |
      | BG-UMBAUART      | Umbauartikel in Stückliste       | bedarfsbezogen    | 6         | GK2.14.3    | WG-RHB  | PG-UE  | EK1-BEDARF | 1       | UMBAUART   | 1       | Umbauartikel  | A AG-OHNE     | 1       | A AG-LOHN1  | 1       |
      | BG-RM_AUF_BA     | Artikel an letzter Stelle in STL | bedarfsbezogen    | 6         | GK2.14.3    | WG-RHB  | PG-UE  | EK1-BEDARF | 1       | A AG-OHNE  | 1       |               | A AG-LOHN1    | 1       | EK2-BEDARF  | 1       |
      | BG-ARBEITSGAENGE | Nur Abreitsgänge in STL          | bedarfsbezogen    | 6         | GK2.14.3    | WG-RHB  | PG-UE  | A AG-OHNE  | 1       | A AG-LOHN1 | 1       |               | A AG-LOHN2    | 1       | A AG-LOHN3  | 1       |
      | BG-NUR_TEILE     | Nur Artikel in STL               | bedarfsbezogen    | 6         | GK2.14.3    | WG-RHB  | PG-UE  | EK1-BEDARF | 1       | EK2-BEDARF | 1       |               | EK1-AUFTRAG   | 1       | EK2-AUFTRAG | 1       |
      | BG-LOHNFERT      | BG mit LOHNFERTIGUNG in STL      | bedarfsbezogen    | 6         | GK2.14.3    | WG-RHB  | PG-UE  | EK1-BEDARF | 1       | A AG-LOHN1 | 1       |               | LOHNFERTIGUNG | 1       | A AG-LOHN2  | 1       |
      | BG-UNTERBG       | BG mit Unterbaugruppe            | bedarfsbezogen    | 6         | GK2.14.3    | WG-RHB  | PG-UE  | EK2-BEDARF | 1       | A AG-LOHN1 | 1       |               | BG-BEDARF     | 1       | A AG-LOHN2  | 1       |
      | V1               | !dontChange                      | !dontChange       | 6         | !dontChange | WG-RHB  | PG-UE  | E2         | 2       | A AG3      | 1       |               | BG1           | 1       | A AG4       | 1       |
      | BG-Variante      | !dontChange                      | variantenbezogen  | 6         | !dontChange | WG-RHB  | PG-UE  | E2         | 2       | A AG3      | 1       |               | BG1           | 1       | A AG4       | 1       |


  Scenario Outline: Baugruppen mit zwei Komponenten und zwei Arbeitsgängen oder Koppelprodukt und 1 Arbeitsgang
    Given I open an editor "<such>" from table "(Part):(Product)" with command "STORE" for record "<such>"
    And I set fields
      | such          | <such>            |
      | namebspr      | <namebspr>        |
      | dispoa        | <dispoa>          |
      | bsart         | Eigenfertigung    |
      | chverfolgung  | <chverfolgung>    |
    And I delete all rows
    And I append rows
      | elex      | anzahl    | ikompeig      |
      | <elex1>   | <anzahl1> | !dontChange   |
      | <elex2>   | <anzahl2> | <ikompeig>    |
      | <elex3>   | <anzahl3> | !dontChange   |
      | <elex4>   | <anzahl4> | !dontChange   |
    And I save the current editor
    Examples:
      | such              | namebspr                          | dispoa          | chverfolgung            | elex1          | anzahl1 | elex2          | ikompeig      | anzahl2   | elex3          | anzahl3   | elex4        | anzahl4       |
      | BG01_SNR          | seriennummernpflicht Baugruppe 1  | bedarfsbezogen  | Seriennummernverfolgung | EK01_SNR       | 1       | A AG2          | !dontChange   | 1         | EK02_SNR       | 1         | A AG3        | 1             |
      | BG_SNR_KOPPEL     | seriennummernpflicht BG Koppel    | bedarfsbezogen  | Seriennummernverfolgung | EK01_SNR       | 1       | KOPPEL_SNR     | Koppelprodukt | 2         | A AG2          | 1         | !dontChange  | !dontChange   |


  Scenario: Baugruppe mit 2 Komponenten und 3 Arbeitsgaengen anlegen (Kopie bon BG01_SNR)
    Given I open an editor "BG01_SNR" from table "(Part):(Product)" with command "COPY" for record "BG01_SNR"
    And I set fields
      | such          | BG03_SNR                   |
      | namebspr      | Baugruppe 3 Arbeitsgaenge  |
      | bsart         | Eigenfertigung             |
      | chverfolgung  | Seriennummernverfolgung    |
    And I append rows
      | elex  | elanzahl  |
      | A AG2 | 1         |
    And I save the current editor


  Scenario Outline: Baugruppe mit alternativer Fertigungsliste in externer Lagergruppe
    Given I open an editor "<such>" from table "(Part):(Product)" with command "STORE" for record "<such>"
    And I set fields
      | such      | <such>         |
      | namebspr  | <namebspr>     |
      | dispoa    | <dispoa>       |
      | bsart     | Eigenfertigung |
      | ekbewverf | <ekbewverf>    |
      | gemein    | <gemein>       |
      | wgruppe   | <wgruppe>      |
      | erlgrp    | <erlgrp>       |
    And I delete all rows
    And I append rows
      | elex    | anzahl    |
      | <elex1> | <anzahl1> |
      | <elex2> | <anzahl2> |
      | <elex3> | <anzahl3> |
      | <elex4> | <anzahl4> |
    And I press button "alge" to open a subeditor for "Lagergruppeneigenschaften"
    And I delete all rows
    And I append rows
      | lgruppe   | bsart          |
      | <lgruppe> | Eigenfertigung |
    And I save the current subeditor to switch back to the parent editor
    And I save the current editor

    Given I open an editor "<such_FL>" from table "(ProductionList):(ProductionList)" with command "STORE" for record "<such_FL>"
    And I set fields
      | such      | <such_FL>    |
      | artikel   | <artikel_FL> |
      | lgruppe   | <lgruppe>    |
      | flistestd | ja           |
    And I modify table
      | elex    | elanzahl       | !row |
      | <elex1> | <elanzahl1_FL> | 1    |
      | <elex2> | <elanzahl2_FL> | 2    |
      | <elex3> | <elanzahl3_FL> | 3    |
      | <elex4> | <elanzahl4_FL> | 4    |
    And I save the current editor
    Examples:
      | such              | namebspr                 | dispoa         | ekbewverf | gemein   | wgruppe | erlgrp | elex1      | anzahl1 | elanzahl1_FL | elex2      | anzahl2 | elanzahl2_FL | elex3      | anzahl3 | elanzahl3_FL | elex4      | anzahl4 | elanzahl4_FL | such_FL | artikel_FL        | lgruppe |
      | BG-ALTERNATIVE_FL | Alternative FL in BERLIN | bedarfsbezogen | 6         | GK2.14.3 | WG-RHB  | PG-UE  | EK1-BEDARF | 1       | 5            | EK2-BEDARF | 1       | 5            | A AG-LOHN1 | 1       | 1            | A AG-LOHN2 | 1       | 1            | BERL-1  | BG-ALTERNATIVE_FL | BERLIN  |


  Scenario Outline: Baugruppen mit Einheit und Einheiten und Gebindepflicht, eine Komponente und zwei Arbeitsgänge
    Given I open an editor "<such>" from table "(Part):(Product)" with command "STORE" for record "<such>"
    And I set fields
      | such      | <such>         |
      | namebspr  | <namebspr>     |
      | dispoa    | <dispoa>       |
      | bsart     | Eigenfertigung |
      | ekbewverf | <ekbewverf>    |
      | gemein    | <gemein>       |
      | wgruppe   | <wgruppe>      |
      | erlgrp    | <erlgrp>       |
      | gebvhe    | <gebvhe>       |
      | fvhe      | <fvhe>         |
      | vhe       | <vhe>          |
      | fvhle     | <fvhle>        |
      | le        | <le>           |
      | gebvpe    | <gebvpe>       |
      | fvpe      | <fvpe>         |
      | vpe       | <vpe>          |
      | fvple     | <fvple>        |
      | gebve     | <gebve>        |
      | fve       | <fve>          |
      | ve        | <ve>           |
      | fvele     | <fvele>        |
      | gebge     | <gebge>        |
      | fge       | <fge>          |
      | ge        | <ge>           |
      | fgele     | <fgele>        |
    And I delete all rows
    And I append rows
      | elex       | anzahl |
      | EK1-BEDARF | 1      |
      | A AG-LOHN1 | 1      |
      | A AG-LOHN2 | 1      |
    And I save the current editor
    Examples:
      | such              | namebspr          | dispoa         | ekbewverf | gemein   | wgruppe | erlgrp | gebvhe | fvhe | vhe  | fvhle | le    | gebvpe | fvpe | vpe  | fvple | le    | gebve | fve | ve   | fvele | le    | gebge | fge | ge   | fgele | le    |
      | BG-GEBINDEPFLICHT | 1 Satz = 25 Stück | bedarfsbezogen | 6         | GK2.14.3 | WG-RHB  | PG-UE  | ja     | 1    | Satz | 25    | Stück | ja     | 1    | Satz | 25    | Stück | ja    | 1   | Satz | 25    | Stück | ja    | 1   | Satz | 25    | Stück |


  Scenario Outline: Baugruppen mit zwei oder drei Komponenten und zwei oder drei Arbeitsgängen
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
      | ekbewverf         | <ekbewverf>         |
      | gemein            | <gemein>            |
      | wgruppe           | <wgruppe>           |
      | erlgrp            | <erlgrp>            |
    And I delete all rows
    And I append rows
      | elex    | anzahl    | packmnotw   |
      | <elex1> | <anzahl1> |             |
      | <elex2> | <anzahl2> |             |
      | <elex3> | <anzahl3> |             |
      | <elex4> | <anzahl4> |             |
      | <elex5> | <anzahl5> | <packmnotw> |
    And I save the current editor
    Examples:
      | such             | namebspr                      | dispoa          | packanwstdla  | fmengestdla | packanwstdversand  | fmengestdversand | ekbewverf | gemein      | wgruppe | erlgrp | elex1      | anzahl1 | elex2       | anzahl2 | elex3        | anzahl3 | elex4         | anzahl4 | elex5      | anzahl5 | packmnotw |
      | BG-STL_EINHEITEN | Artikel in STL mit Einheiten  | bedarfsbezogen  |               |             |                    |                  | 6         | GK2.14.3    | WG-RHB  | PG-UE  | EK1-BEDARF | 1       | A AG-LOHN1  | 1       | EK-EINHEITEN | 1       | EK-GEBINDEPFL | 1       | A AG-LOHN2 | 1       | ja        |
      | VK1-BEDARF       | Versandpackanweisung          | bedarfsbezogen  |               |             | VERSAND_EINFACH    | 10               | 6         | GK2.14.3    | WG-RHB  | PG-UE  | BG-BEDARF  | 1       | EK1-BEDARF  | 1       | A AG-LOHN1   | 1       | EK2-BEDARF    | 1       | A AG-LOHN2 | 1       | ja        |
      | VK1-AUFTRAG      | Versandpackanweisung          | auftragsbezogen |               |             | VERSAND_EINFACH    | 10               | 6         | GK2.14.3    | WG-RHB  | PG-UE  | BG-AUFTRAG | 1       | EK1-AUFTRAG | 1       | A AG-LOHN1   | 1       | EK2-AUFTRAG   | 1       | A AG-LOHN2 | 1       | ja        |
      | VK2-BEDARF       | Lager- & Versandpackanweisung | bedarfsbezogen  | LAGER_EINFACH | 10          | VERSAND_MEHRSTUFIG | 25               | 6         | GK2.14.3    | WG-RHB  | PG-UE  | BG-BEDARF  | 1       | EK1-BEDARF  | 1       | A AG-LOHN1   | 1       | EK2-BEDARF    | 1       | A AG-LOHN2 | 1       | ja        |
      | VK1-AUFTRAG      | Versandpackanweisung          | auftragsbezogen | LAGER_EINFACH | 10          | VERSAND_MEHRSTUFIG | 25               | 6         | GK2.14.3    | WG-RHB  | PG-UE  | BG-AUFTRAG | 1       | EK1-AUFTRAG | 1       | A AG-LOHN1   | 1       | EK2-AUFTRAG   | 1       | A AG-LOHN2 | 1       | ja        |
      | V2               | !dontChange                   | !dontChange     | !dontChange   | !dontChange | !dontChange        | !dontChange      | 6         | !dontChange | WG-RHB  | PG-UE  | E2         | 1       | A AG3       | 1       | BG1          | 1       | A AG4         | 1       | E3         | 2       |           |


  Scenario Outline: Baugruppen mit drei Komponenten und drei Arbeitsgängen
    Given I open an editor "<such>" from table "(Part):(Product)" with command "STORE" for record "<such>"
    And I set fields
      | such      | <such>         |
      | namebspr  | <namebspr>     |
      | dispoa    | <dispoa>       |
      | bsart     | Eigenfertigung |
      | ekbewverf | <ekbewverf>    |
      | gemein    | <gemein>       |
      | wgruppe   | <wgruppe>      |
      | erlgrp    | <erlgrp>       |
    And I delete all rows
    And I append rows
      | elex    | anzahl    | lge    | breite    |
      | <elex1> | <anzahl1> | <lge1> | <breite1> |
      | <elex2> | <anzahl2> |        |           |
      | <elex3> | <anzahl3> |        |           |
      | <elex4> | <anzahl4> |        |           |
      | <elex5> | <anzahl5> |        |           |
      | <elex6> | <anzahl6> |        |           |
    And I save the current editor
    Examples:
      | such | namebspr    | dispoa      | ekbewverf | gemein      | wgruppe | erlgrp | elex1 | lge1 | breite1 | anzahl1 | elex2 | anzahl2 | elex3 | anzahl3 | elex4 | anzahl4 | elex5 | anzahl5 | elex6 | anzahl6 |
      | V3   | !dontChange | !dontChange | 6         | !dontChange | WG-RHB  | PG-UE  | E1    | 100  | 100     | 1       | A AG1 | 1       | E2    | 2       | A AG2 | 1       | E3    | 3       | A AG3 | 1       |


  Scenario Outline: Setartikel und Pseudobaugruppen
    Given I open an editor "<such>" from table "(Part):(Product)" with command "STORE" for record "<such>"
    And I set fields
      | such      | <such>          |
      | namebspr  | <namebspr>      |
      | dispoa    | <dispoa>        |
      | bsart     | Eigenfertigung  |
      | earta     | über Stückliste |
      | ekbewverf | <ekbewverf>     |
      | gemein    | <gemein>        |
      | wgruppe   | <wgruppe>       |
      | erlgrp    | <erlgrp>        |
    And I delete all rows
    And I append rows
      | elex    | anzahl    |
      | <elex1> | <anzahl1> |
      | <elex2> | <anzahl2> |
      | <elex3> | <anzahl3> |
    And I save the current editor
    Examples:
      | such            | namebspr        | dispoa         | ekbewverf | gemein   | wgruppe | erlgrp | elex1      | anzahl1 | elex2      | anzahl2 | elex3      | anzahl3 |
      | SETARTIKEL      | Setartikel      | bedarfsbezogen | 6         | GK2.14.3 | WG-RHB  | PG-UE  | EK1-BEDARF | 1       | EK2-BEDARF | 1       | EK3-BEDARF | 1       |
      | PSEUDOBAUGRUPPE | Pseudobaugruppe | bedarfsbezogen | 6         | GK2.14.3 | WG-RHB  | PG-UE  | EK1-BEDARF | 1       | EK2-BEDARF | 1       | A AG-LOHN1 | 1       |


  Scenario: Basisartikel mit zwei Versionen anlegen
    Given I open an editor "BASISART" from table "(Part):(BaseProduct)" with command "STORE" for record "BASISART"
    And I set field "such" to "BASISART"
    And I delete all rows
    And I append rows
      | tversion   | tstdvers | tindex |
      | EK-B-VERS1 | ja       | V01    |
      | EK-B-VERS2 |          | V02    |
    And I save the current editor



  ###### Techniker, Dienstleistungen, Einsatzmittel ######

  Scenario Outline: Techniker
    Given I open an editor "<such>" from table "(ServiceEmployees):(EmployeeRole)" with command "STORE" for record "<such>"
    And I set fields
      | such     | <such>     |
      | namebspr | <namebspr> |
      | ma       | <ma>       |
    And I save the current editor
    Examples:
      | such      | namebspr  | ma   |
      | TECHNIKER | Techniker | TEST |


  Scenario Outline: Dienstleistungen
    Given I open an editor "<ndienstl>" from table "(Part):(Service)" with command "STORE" for record "<such>"
    And I set fields
      | such     | <such>     |
      | namebspr | <namebspr> |
      | vpr      | <preis>    |
      | vpe      | <vpe>      |
      | vhe      | <vhe>      |
    And I delete all rows
    And I append rows
      | elex   |
      | <elex> |
    And I save the current editor
    Examples: Dienstleistungen
      | ndienstl   | such         | namebspr     | preis | vpe         | vhe         | elex  |
      | HDIENSTL   | DL-hAnalyse  | Analyse in h | 60.00 | h           | h           |       |
      | REPDIENSTL | DL-Reparatur | Reparatur    | 70.00 | !dontChange | !dontChange |       |
      | DIENSTL    | DL-Analyse   | Analyse      | 50.00 | !dontChange | !dontChange | A AG1 |


  Scenario Outline: Einsatzmittel
    Given I open an editor "<such>" from table "(ServiceAssignment):(AssignmentResources)" with command "STORE" for record "<such>"
    And I set field "such" to "<such>"
    And I save the current editor
    Examples:
      | such   |
      | EM-PKW |



 #### Preise und Rabatte ######

  Scenario Outline: Preise und Rabatte
    Given I open an editor "<such>" from table "(Pricing):(Pricing)" with command "STORE" for record "<such>"
    And I set fields
      | such  | <such>  |
      | typ   | <typ>   |
      | artpg | <artpg> |
      | klpg  | <klpg>  |
      | mgeab | <mgeab> |
    And I delete all rows
    And I append rows
      | mgrenze    | mpreis    | mproz    |
      | <mgrenze1> | <mpreis1> | <mproz1> |
      | <mgrenze2> | <mpreis2> | <mproz2> |
      | <mgrenze3> | <mpreis3> | <mproz3> |
    And I save the current editor
    Examples:
      | such      | typ                | artpg       | klpg    | mgeab | mgrenze1 | mproz1      | mpreis1     | mgrenze2 | mproz2      | mpreis2     | mgrenze3 | mpreis3     | mproz3      |
      | K-PREISE1 | Verkauf Preisliste | EK1-AUFTRAG | KUNDE1  | ja    | 1        | !dontChange | 50          | 10       | !dontChange | 45          | 100      | 40          | !dontChange |
      | L-PREISE1 | Einkauf Preisliste | EK1-BEDARF  | LIEFER1 | ja    | 1        | !dontChange | 10          | 10       | !dontChange | 9           | 100      | 8           | !dontChange |
      | K-RABATT1 | Verkauf Rabatte    | EK1-AUFTRAG | KUNDE1  | ja    | 10       | -5          | !dontChange | 50       | -10         | !dontChange |          | !dontChange |             |
      | L-RABATT1 | Einkauf Rabatte    | EK1-BEDARF  | LIEFER1 | nein  | 49       | 0           | !dontChange | 99       | -5          | !dontChange | 9999999  | !dontChange | -10         |

