@persistent
Feature: VERSAND_BEHAELTER_Fertigung_Materialzuordnung.feature

# *****************************************************************************
#  Name             : VERSAND_BEHAELTER_Fertigung_Materialzuordnung.feature
#  Autor            : lschneider
#  Verantwortlich   : carue
#  Kontrolle        : drpf
#  Funktion         : Testet Materialentnahme ueber MZs in der Fertigung mit Behaeltern
#  ref              : ref_behaelter_fertigung_cu
#  Stammdaten       : VERSAND_BEHAELTER_Stammdaten.feature
#
# *****************************************************************************

Background:
Given I set the fake date to "07.01.1995"

@FertStammdaten
Scenario: Packanweisung FERTIGUNG, zweistufig

Given I open an editor "Packanweisung" from table "(PackingInstructions):(PackingInstructions)" with command "STORE" for record "FERTIGUNG"
And I set field "such" to "FERTIGUNG"
And I delete all rows
And I append rows
    | artikel   | anzahl    | ebene | minebene  | auffuell  |
    | Behaelter | 4         | 3     | 2         | ja        |
    | SPALETTE  | 1         | 1     | 1         | nein      |
And I save the current editor

@FertStammdaten
Scenario Outline: KOMPONENTEN

Given I open an editor "<such>" from table "(Part):(Product)" with command "STORE" for record "<such>"
And I set fields
    | such      | <such>        |
    | namebspr  | <namebspr>    |
And I save the current editor

Examples: KOMPONENTEN
    | such        | namebspr     |
    | KOMPONENTE1 | Komponente 1 |
    | KOMPONENTE2 | Komponente 2 |
    | KOMPONENTE3 | Komponente 3 |

@FertStammdaten
Scenario: BAUGR1

Given I open an editor "artikel" from table "(Part):(Product)" with command "STORE" for record "BAUGR1"
And I set fields
    | such      | BAUGR1            |
    | namebspr  | Baugruppe 1       |
    | bsart     | Eigenfertigung    |
And I delete all rows
And I append rows
    | elex        | elanzahl    | lge | breite |
    | KOMPONENTE1 | 2           |     |        |
    | KOMPONENTE2 | 1           |     |        |
    | A SCHRAUBEN | !dontChange | 5   | 10     |
    | KOMPONENTE3 | 1           |     |        |
    | A MONTAGE1  | !dontChange | 10  | 15     |
And I save the current editor

@FertStammdaten
Scenario Outline: Auftragsbezogene Verkaufsartikel

Given I open an editor "<such>" from table "(Part):(Product)" with command "STORE" for record "<such>"
And I set fields
    | such          | <such>                        |
    | namebspr      | Fertigartikel in Behaelter    |
    | bsart         | Eigenfertigung                |
    | dispoa        | auftragsbezogen               |
    | chimlager     | ja                            |
    | packanwstdla  | !Packanweisung                |
    | fmengestdla   | 10                            |
    | vpr           | 25.00                         |
And I delete all rows
And I append rows
    | elex        | elanzahl    | lge | breite | packmnotw   | manbu       |
    | KOMPONENTE1 | 2           |     |        | !dontChange | ja          |
    | A SCHRAUBEN | !dontChange | 15  | 30     | !dontChange | !dontChange |
    | BAUGR1      | 1           |     |        | !dontChange | !dontChange |
    | A MONTAGE1  | !dontChange | 25  | 60     | ja          | !dontChange |
And I save the current editor

Examples: Auftragsbezogene Verkaufsartikel
    | such      |
    | PROD_MZ01 |
    | PROD_MZ02 |

#################TEST#######################

Scenario: 01 Fertigungsdurchlauf, eine Charge, ein Behaelter

# Charge und Behaelter
Given I create a Lot "CH_M03" for Product "PROD_MZ01"
Given I create a Container "BEH_KOMPONENTE1" for packaging material "KLT"
Given I create a Container "FERTIGTEIL1" for packaging material "KLT"

# Auftrag anlegen und Nummer als Verwendung hinerlegen
Given I create a SalesOrder "Auftrag1" for Customer "RADSHOP" with Product "PROD_MZ01" and quantity "160"

And I switch the current editor to editor "Auftrag1" with command "UPDATE"
And I set field "verw" to "nummer" from editor "Auftrag1" in row 1
And I save the current editor

# Material in Behaelter buchen, MZ fuer FV anlegen und freigeben
Given I post a receipt via ManualStockAdjustment for Product "KOMPONENTE1" and quantity "320" on StorageLocation "F1" with document "M01" and Container "!BEH_KOMPONENTE1"
Given I run Scheduling

Given I open an editor "Fertivor1" from table "(Purchasing):(WorkOrderSuggestions)" with command "UPDATE" for record ""
And I set field "artikel" to "PROD_MZ01"
And I press button "ladetab"
And I press button "mzabsm" to open a subeditor for "EntnahmeMZ" in row 1
And I append rows
    | zuomge    | behaelter         | lpsuch    |
    | 320       | !BEH_KOMPONENTE1  | F1        |
And I save the current subeditor to switch back to the parent editor
And I press button "mzsubm" to open a subeditor for "MZ" in row 1
And I append rows
    | zuomge    | behaelter     | charge    | lpsuch    |
    | 10        | !FERTIGTEIL1  | !CH_M03   | F1        |
And I save the current subeditor to switch back to the parent editor
And I modify table
    | !row  | mfreig    | bisuch    |
    | 1     | ja        | MZ_A01    |
And I press button "freig" to open a subeditor for "fertigung"
And I close the current subeditor to switch back to the parent editor
And I close the current editor

# Manuelle Materialentnahme
Given I open an editor "Manuelle Entnahme" for tip command "(WOIssue)" and arguments ""
And I set fields
    | auftrag   | MZ_A01001 |
And I press button "stllad"
And I save the current editor

# LJ pruefen
And I open the infosystem "LJ"
And I set fields
    | adatum        | .                             |
    | abgang        | ja                            |
    | artikel       | KOMPONENTE1                   |
    | richtung      | rueckwaerts                   |
And I press start
Then table has values
    | art         | buart  | vplatz  | amge | behaelter                 |
    | KOMPONENTE1 | Abgang | F1      | 320  | !BEH_KOMPONENTE1^nummer   |
And I close the current editor

# Rueckmeldung AS1 und manuelle Entnahme Packmittel
Given I open an editor "Arbeitsschein" from table "(Workorder):(WorkOrders)" with command "DONE" for record "MZ_A01001"
And I set fields
    | sofort    | ja    |
    | gut       | ja    |
And I save the current editor

Given I open an editor "Manuelle Entnahme" for tip command "(WOIssue)" and arguments ""
And I set fields
    | auftrag   | MZ_A01002 |
And I press button "stllad"
And I save the current editor

# Rueckmeldung AS2 in Behaelter
Given I open an editor "Arbeitsschein" from table "(Workorder):(WorkOrders)" with command "DONE" for record "MZ_A01002"
And I set fields
    | sofort    | ja        |
    | gut       | ja        |
And I save the current editor

# LJ und Auftrag liefern
Given I open the infosystem "LJ"
And I set fields
    | adatum        | .                             |
    | artikel       | PROD_MZ01                     |
    | richtung      | rueckwaerts                   |
And I press start
Then table has values
    | art       | buart  | zmge | behaelter           | ncharge           |
    | PROD_MZ01 | Zugang | 150  |                     | !dontChange       |
    | PROD_MZ01 | Zugang | 10   | !FERTIGTEIL1^nummer | !CH_M03^nummer    |
And I close the current editor

Given I switch the current editor to editor "Auftrag1" with command "DELIVERY"
And I modify table
    | !row  | artikel       | mge   | charge        | behaelter      |
    | 1     | !dontChange   | 10    | !CH_M03       | !FERTIGTEIL1   |
    | +2    | PROD_MZ01     | 150   |               |                |
And I set field "ueb" to "ja"
And I save the current editor


Scenario: 02 Fertigungsdurchlauf, mehrere Chargen, mehrere Behaelter, verschiedene Lagerplaetze

Given I set the fake date to "08.01.1995"
# Chargen und Behaelter
Given I create a Lot "CH_MZ02-1" for Product "PROD_MZ02"
Given I create a Lot "CH_MZ02-2" for Product "PROD_MZ02"
Given I create a Lot "CH_MZ02-3" for Product "PROD_MZ02"
Given I create a Lot "CH_MZ02-4" for Product "PROD_MZ02"
Given I create a Lot "CH_MZ02-5" for Product "PROD_MZ02"

Given I create a Container "BEH-ROHTEIL1" for packaging material "KLT"
Given I create a Container "BEH-ROHTEIL2" for packaging material "KLT"
Given I create a Container "BEH-01" for packaging material "KLT"
Given I create a Container "BEH-02" for packaging material "KLT"
Given I create a Container "BEH-03" for packaging material "KLT"
Given I create a Container "BEH-04" for packaging material "KLT"
Given I create a Container "BEH-05" for packaging material "KLT"

# Lagerzugang KOMPONENTE1
Given I post a receipt via ManualStockAdjustment for Product "KOMPONENTE1" and quantity "200" on StorageLocation "F1" with document "M02" and Container "!BEH-ROHTEIL1"
Given I post a receipt via ManualStockAdjustment for Product "KOMPONENTE1" and quantity "200" on StorageLocation "F1" with document "M02" and Container "!BEH-ROHTEIL2"
And I run Scheduling

# Fertigungsvorschlag und BA erzeugen
Given I open an editor "Fertivor2" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
And I append rows
    | artikel       | mge   | mfreig    | bisuch    |
    | PROD_MZ02     | 200   | ja        | MZ_A02    |
And I press button "mzsubm" to open a subeditor for "MZ" in row 1
And I delete all rows
And I append rows
    | zuomge    | behaelter | charge        | lpsuch    |
    | 40        | !BEH-01   | !CH_MZ02-1    | F1        |
    | 40        | !BEH-02   | !CH_MZ02-2    | F2        |
    | 40        | !BEH-03   | !CH_MZ02-3    | F2        |
    | 40        | !BEH-04   | !CH_MZ02-4    | F3        |
    | 40        | !BEH-05   | !CH_MZ02-5    | F3        |
And I save the current subeditor to switch back to the parent editor
And I press button "mzabsm" to open a subeditor for "EntnahmeMZ" in row 1
And I delete all rows
And I append rows
    | zuomge    | behaelter     |
    | 200       | !BEH-ROHTEIL1 |
    | 200       | !BEH-ROHTEIL2 |
And I save the current subeditor to switch back to the parent editor
And I set field "bisuch" to "MZ_A02" in row !lastRow
And I press button "freig" to open a subeditor for "fertigung"
And I close the current subeditor to switch back to the parent editor
And I close the current editor

# Manuelle Entnahme Packmittel
Given I open an editor "Manuelle Entnahme" for tip command "(WOIssue)" and arguments ""
And I set fields
    | auftrag   | MZ_A02002 |
    | autorment | ja        |
    | mgr       | 101       |
And I press button "stllad"
And I save the current editor

# Rueckmeldung auf zweiten AS
Given I open an editor "MZ_A02_Rueckm1" from table "(Workorder):(WorkOrders)" with command "DONE" for record "MZ_A02002"
And I set field "sofort" to "1"
And I set field "gutmge" to "100" in row 1
And I save the current editor

# Behaelter pruefen
And I switch the current editor to editor "BEH-01"
Then field "platz" has value "F1"
Then table has values
    | artikel   | mge   | charge            |
    | PROD_MZ02 | 40    | !CH_MZ02-1^nummer |
And I close the current editor

And I switch the current editor to editor "BEH-03"
Then field "platz" has value "F2"
Then table has values
    | artikel   | mge   | charge            |
    | PROD_MZ02 | 20    | !CH_MZ02-3^nummer |
And I close the current editor

# Rueckmeldung auf zweiten AS
Given I open an editor "MZ_A02_Rueckm1" from table "(Workorder):(WorkOrders)" with command "DONE" for record "MZ_A02002"
And I set field "sofort" to "1"
And I set field "gutmge" to "100" in row 1
And I save the current editor

# LJ pruefen
Given I open the infosystem "LJ"
And I set fields
    | adatum    | .                         |
    | beleg     | !MZ_A02_Rueckm1^barmex    |
    | richtung  | rueckwaerts               |
And I press start
Then table has values
    | nplatz    | zmge   | amge     | behaelter             | ncharge            |
    | F3        | 40     |          | !BEH-05^nummer        | !CH_MZ02-5^nummer  |
    | F3        | 40     |          | !BEH-04^nummer        | !CH_MZ02-4^nummer  |
    | F2        | 20     |          | !BEH-03^nummer        | !CH_MZ02-3^nummer  |
    | F2        | 20     |          | !BEH-03^nummer        | !CH_MZ02-3^nummer  |
    | F2        | 40     |          | !BEH-02^nummer        | !CH_MZ02-2^nummer  |
    | F1        | 40     |          | !BEH-01^nummer        | !CH_MZ02-1^nummer  |
    |           |        | 200      | !BEH-ROHTEIL2^nummer  |                    |
    |           |        | 200      | !BEH-ROHTEIL1^nummer  |                    |
And I close the current editor


Scenario: 03 Fertigungsdurchlauf, MZ in Rueckmeldung auf BA anlegen

Given I set the fake date to "09.01.1995"
# Behaelter und FV anlegen
Given I create a Container "TEILRUECKMELDUNG1" for packaging material "KLT"
Given I create a Container "TEILRUECKMELDUNG2" for packaging material "KLT"
Given I create a Container "TEILRUECKMELDUNG3" for packaging material "KLT"

Given I open an editor "fvanlegen" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
And I append rows
    | artikel   | mge   | mfreig    | bisuch    |
    | FAHRRAD   | 100   | ja        | TEILRUECK |
And I press button "freig" to open a subeditor for "fertigung"
And I close the current subeditor to switch back to the parent editor
And I close the current editor

# Rueckmeldungen
Given I open an editor "rueckmeldung_BA1" from table "(Workorder):(WorkOrders)" with command "DONE" for record "TEILRUECK000"
And I set fields
    | sofort    | ja    |
    | mgr       | 112   |
And I set field "gutmge" to "50" in row 1
And I press button "mzsubm" to open a subeditor for "MZ" in row 1
And I append rows
    | zuomge    | behaelter             |
    | 25        | !TEILRUECKMELDUNG1    |
    | 25        | !TEILRUECKMELDUNG2    |
And I save the current subeditor to switch back to the parent editor
And I save the current editor

Given I open an editor "rueckmeldung_BA2" from table "(Workorder):(WorkOrders)" with command "DONE" for record "TEILRUECK000"
And I set fields
    | sofort    | ja    |
    | mgr       | 112   |
And I set field "gutmge" to "50" in row 1
And I press button "mzsubm" to open a subeditor for "MZ" in row 1
And I append rows
    | zuomge    | behaelter             | lpsuch        |
    | 25        | !TEILRUECKMELDUNG2    | !dontChange   |
    | 25        | !TEILRUECKMELDUNG3    | F2            |
Then field "lpsuch" has value "F1" in row 1
And I save the current subeditor to switch back to the parent editor
And I set field "sofort" to "ja"
And I save the current editor

# LJ pruefen
Given I open the infosystem "LJ"
And I set fields
    | adatum    | .                         |
    | beleg     | !rueckmeldung_BA1^barmex  |
    | zugang    | ja                        |
    | richtung  | rueckwaerts               |
And I press start
Then table has values
    | nplatz    | behaelter                 |
    | F2        | !TEILRUECKMELDUNG3^nummer |
    | F1        | !TEILRUECKMELDUNG2^nummer |
    | F1        | !TEILRUECKMELDUNG2^nummer |
    | F1        | !TEILRUECKMELDUNG1^nummer |
And I close the current editor


Scenario: 04 Behaelter mit gleicher exbehnum lassen sich in MZ anlegen
# FDA-4069

#Given I set the fake date to "10.01.1995"
#Given I open an editor "fvanlegen" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
#And I append rows
#    | artikel   | mge   | mfreig    | bisuch   |
#    | FAHRRAD   | 100   | ja        | EXBEHNUM |
#And I press button "freig" to open a subeditor for "fertigung"
#And I close the current subeditor to switch back to the parent editor
#And I close the current editor
#
## gleiche exbehnum in MZ
#Given I open an editor "EXBEHNUM1" from table "(Container):(ContainerShell)" with command "NEW" for record ""
#And I set fields
#    | such      | EXBEHNUM1 |
#    | exbehnum  | EXBEHNUM1 |
#    | packm     | KLT       |
#And I save the current editor
#
#Given I open an editor "EXBEHNUM11" from table "(Container):(ContainerShell)" with command "NEW" for record ""
#And I set fields
#    | such      | EXBEHNUM11 |
#    | exbehnum  | EXBEHNUM1  |
#    | packm     | KLT        |
#And I save the current editor
#
#Given I open an editor "rueckmeldung_BA1" from table "(Workorder):(WorkOrders)" with command "DONE" for record "EXBEHNUM000"
#And I set fields
#    | sofort    | ja    |
#    | mgr       | 112   |
#And I set field "gutmge" to "50" in row 1
#And I press button "mzsubm" to open a subeditor for "MZ" in row 1
#And I append rows
#    | zuomge    | behaelter     |
#    | 25        | !EXBEHNUM1    |
#    | 25        | !EXBEHNUM11   |
#And I save the current subeditor to switch back to the parent editor
#And I save the current editor
#
## gleiche exbehnum, unterschiedliche Lagerplaetze in MZ
#Given I open an editor "EXBEHNUM2" from table "(Container):(ContainerShell)" with command "NEW" for record ""
#And I set fields
#    | such      | EXBEHNUM2 |
#    | exbehnum  | EXBEHNUM2 |
#    | packm     | KLT       |
#And I save the current editor
#
#Given I open an editor "EXBEHNUM22" from table "(Container):(ContainerShell)" with command "NEW" for record ""
#And I set fields
#    | such      | EXBEHNUM22 |
#    | exbehnum  | EXBEHNUM2  |
#    | packm     | KLT        |
#And I save the current editor
#
#Given I open an editor "rueckmeldung_BA2" from table "(Workorder):(WorkOrders)" with command "DONE" for record "EXBEHNUM000"
#And I set fields
#    | sofort    | ja    |
#    | mgr       | 112   |
#And I set field "gutmge" to "50" in row 1
#And I press button "mzsubm" to open a subeditor for "MZ" in row 1
#And I append rows
#    | zuomge    | behaelter     | lpsuch    |
#    | 25        | !EXBEHNUM2    | F1        |
#    | 25        | !EXBEHNUM22   | F2        |
#And I save the current subeditor to switch back to the parent editor
#And I save the current editor
