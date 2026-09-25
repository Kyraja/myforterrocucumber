@persistent
Feature: VERSAND_BEHAELTER_Fertigung.feature

# *****************************************************************************
#  Name             : VERSAND_BEHAELTER_Fertigung.feature
#  Autor            : lschneider
#  Verantwortlich   : carue
#  Kontrolle        : drpf
#  Funktion         : Testet Fertigungsprozess mit Behaeltern
#  ref              : ref_behaelter_fertigung_cu
# Stammdaten        : VERSAND_BEHAELTER_Stammdaten.feature
#
# *****************************************************************************
    
Background:
Given I set the fake date to "02.01.1995"

@FertStammdaten
Scenario: Packanweisung FERTIGUNG, zweistufig

Given I open an editor "Packanweisung" from table "(PackingInstructions):(PackingInstructions)" with command "STORE" for record "FERTIGUNG"
And I set field "such" to "FERTIGUNG"
And I delete all rows
And I append rows
    | artikel   | anzahl    | ebene | minebene  | auffuell  |
    | Behälter  | 4         | 3     | 2         | ja        |
    | SPALETTE  | 1         | 1     | 1         | nein      |
And I save the current editor

@FertStammdaten
Scenario Outline: KOMPONENTEN anlegen

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
Scenario: BAUGR1 anlegen

Given I open an editor "BAUGR1" from table "(Part):(Product)" with command "STORE" for record "BAUGR1"
And I set fields
    | such      | BAUGR1            |
    | namebspr  | Baugruppe 1       |
    | bsart     | Eigenfertigung    |
And I delete all rows
And I append rows
    | elex          | elanzahl      | lge   | breite    |
    | KOMPONENTE1   | 2             |       |           |
    | KOMPONENTE2   | 1             |       |           |
    | A SCHRAUBEN   | !dontChange   | 5     | 10        |
    | KOMPONENTE3   | 1             |       |           |
    | A MONTAGE1    | !dontChange   | 10    | 15        |
And I save the current editor

@FertStammdaten
Scenario Outline: PROD_F01 und PROF_F02

Given I open an editor "<such>" from table "(Part):(Product)" with command "STORE" for record "<such>"
And I set fields
    | such              | <such>                   |
    | namebspr          | <namebspr>               |
    | bsart             | Eigenfertigung           |
    | dispoa            | auftragsbezogen          |
    | chimlager         | ja                       |
    | packanwstdla      | !Packanweisung           |
    | fmengestdla       | 10                       |
    | vpr               | 25.00                    |
And I delete all rows
And I append rows
    | elex        | elanzahl    | lge | breite | packmnotw   |
    | KOMPONENTE1 | 2           |     |        | !dontChange |
    | A SCHRAUBEN | !dontChange | 15  | 30     | !dontChange |
    | BAUGR1      | 1           |     |        | !dontChange |
    | A MONTAGE1  | !dontChange | 25  | 60     | ja          |
And I save the current editor
    
Examples:
    | such      | namebspr                  | 
    | PROD_F01  | Artikel 1 in Behaelter    | 
    | PROD_F02  | Artikel 2 in Behaelter    |


########## Tests ##############

Scenario: 01 Fertigungsdurchlauf mit Behaelter, Rueckmeldung ueber Betriebsauftrag

# Charge und Behaelter zum Befuellen
Given I create a Lot "CH_FERT01" for Product "PROD_F01"

Given I create a Container "behaelter1_1" for packaging material "KLT" and search word "BEH_F0101"
Given I create a Container "behaelter1_2" for packaging material "KLT" and search word "BEH_F0102"
Given I create a Container "behaelter1_3" for packaging material "KLT" and search word "BEH_F0103"
Given I create a Container "behaelter1_4" for packaging material "KLT" and search word "BEH_F0104"
Given I create a Container "behaelter1_5" for packaging material "KLT" and search word "BEH_F0105"
Given I create a Container "behaelter1_6" for packaging material "KLT" and search word "BEH_F0106"
Given I create a Container "behaelter1_7" for packaging material "KLT" and search word "BEH_F0107"
Given I create a Container "behaelter1_8" for packaging material "KLT" and search word "BEH_F0108"
Given I create a Container "behaelter1_9" for packaging material "KLT" and search word "BEH_F0109"
Given I create a Container "behaelter1_10" for packaging material "KLT" and search word "BEH_F0110"
Given I create a Container "behaelter1_11" for packaging material "KLT" and search word "BEH_F0111"
Given I create a Container "behaelter1_12" for packaging material "KLT" and search word "BEH_F0112"
Given I create a Container "behaelter1_13" for packaging material "KLT" and search word "BEH_F0113"
Given I create a Container "behaelter1_14" for packaging material "KLT" and search word "BEH_F0114"
Given I create a Container "behaelter1_15" for packaging material "KLT" and search word "BEH_F0115"
Given I create a Container "behaelter1_16" for packaging material "KLT" and search word "BEH_F0116"

# Auftrag und Verwendung fuer weitere Pruefungen anpassen
Given I create a SalesOrder "Auftrag01" for Customer "RADSHOP" with Product "PROD_F01" and quantity "160"

And I switch the current editor to editor "Auftrag01" with command "UPDATE"
And I set field "verw" in row 1 to "nummer" from editor "Auftrag01" in row 0
And I save the current editor

And I run Scheduling

# Fertigungsvorschlag freigeben
Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "UPDATE" for record ""
And I set field "artikel" to "PROD_F01"
And I press button "ladetab"
And I modify table
    | mfreig    | bisuch    | !row  |
    | ja        | AUFTR_F01 | 1     |
And I press button "freig" to open a subeditor for "fertigung"
And I close the current subeditor to switch back to the parent editor
And I close the current editor

## BA oeffnen, Nummer zur Pruefung LJ benoetigt
Given I open an editor "Rueckmeldung1-1" from table "(Workorder):(WorkOrders)" with command "VIEW" for record "AUFTR_F01000"
And I save value from field "nummer" in row 0
And I close the current editor

# Manuelle Entnahme Packmittel
Given I open an editor "manbu_pack" for tip command "(WOIssue)" and arguments ""
And I set field "auftrag" to "AUFTR_F01000"
And I press button "stllad"
And I set field "mgr" to "101"
And I save the current editor

Scenario Outline: 01 Fertigungsdurchlauf mit Behaelter, Rueckmeldung ueber Betriebsauftrag

# Rueckmeldung ueber BA in Behaelter
Given I open an editor "<Arbeitsschein>" from table "(Workorder):(WorkOrders)" with command "DONE" for record "AUFTR_F01000"
And I set fields
    | mgr       | 112           |
    | kcharge   | !CH_FERT01    |
    | behaelter | <behaelter>   |
    | sofort    | ja            |
And I set field "gutmge" to "10" in row 1
And I save the current editor

Examples: Rueckmeldungen
    | Arbeitsschein    | behaelter      |
    | Rueckmeldung1-2  | !behaelter1_1  |
    | Rueckmeldung1-3  | !behaelter1_2  |
    | Rueckmeldung1-4  | !behaelter1_3  |
    | Rueckmeldung1-5  | !behaelter1_4  |
    | Rueckmeldung1-6  | !behaelter1_5  |
    | Rueckmeldung1-7  | !behaelter1_6  |
    | Rueckmeldung1-8  | !behaelter1_7  |
    | Rueckmeldung1-9  | !behaelter1_8  |
    | Rueckmeldung1-10 | !behaelter1_9  |
    | Rueckmeldung1-11 | !behaelter1_10 |
    | Rueckmeldung1-12 | !behaelter1_11 |
    | Rueckmeldung1-13 | !behaelter1_12 |
    | Rueckmeldung1-14 | !behaelter1_13 |
    | Rueckmeldung1-15 | !behaelter1_14 |
    | Rueckmeldung1-16 | !behaelter1_15 |

Scenario: 01 Ferigungsdurchauf mit Behaelter, Rueckmeldung ueber Betriebsauftrag

Given I open an editor "Arbeitsschein1-17" from table "(Workorder):(WorkOrders)" with command "DONE" for record "AUFTR_F01000"
And I set fields
    | mgr       | 112               |
    | kcharge   | !CH_FERT01        |
    | behaelter | !behaelter1_16    |
    | sofort    | ja                |
And I set field "gutmge" to "10" in row 1
And I save the current editor

And I open the infosystem "LJ"
And I set fields
    | adatum    | 02.01.95                  |
    | zugang    | JA                        |
    | artikel   | PROD_F01                  |
And I set field "beleg" in row 0 to saved value
And I press start
Then the table has 16 rows
Then table has values
    | art       | buart     | nplatz    | zmge  | behaelter              |
    | PROD_F01  | Zugang    | F1        | 10    | !behaelter1_1^nummer   |
    | PROD_F01  | Zugang    | F1        | 10    | !behaelter1_2^nummer   |
    | PROD_F01  | Zugang    | F1        | 10    | !behaelter1_3^nummer   |
    | PROD_F01  | Zugang    | F1        | 10    | !behaelter1_4^nummer   |
    | PROD_F01  | Zugang    | F1        | 10    | !behaelter1_5^nummer   |
    | PROD_F01  | Zugang    | F1        | 10    | !behaelter1_6^nummer   |
    | PROD_F01  | Zugang    | F1        | 10    | !behaelter1_7^nummer   |
    | PROD_F01  | Zugang    | F1        | 10    | !behaelter1_8^nummer   |
    | PROD_F01  | Zugang    | F1        | 10    | !behaelter1_9^nummer   |
    | PROD_F01  | Zugang    | F1        | 10    | !behaelter1_10^nummer  |
    | PROD_F01  | Zugang    | F1        | 10    | !behaelter1_11^nummer  |
    | PROD_F01  | Zugang    | F1        | 10    | !behaelter1_12^nummer  |
    | PROD_F01  | Zugang    | F1        | 10    | !behaelter1_13^nummer  |
    | PROD_F01  | Zugang    | F1        | 10    | !behaelter1_14^nummer  |
    | PROD_F01  | Zugang    | F1        | 10    | !behaelter1_15^nummer  |
    | PROD_F01  | Zugang    | F1        | 10    | !behaelter1_16^nummer  |
And I close the current editor

# Behaelterinhalt pruefen
And I open the infosystem "PRODUCTFINDER"
And I set fields
    | kartikel  | PROD_F01          |
    | kverw     | !Auftrag01^nummer |
    | kcharge   | !CH_FERT01        |
And I press start
Then the table has 16 rows
And I close the current editor

# Auftrag liefern
Given I switch the current editor to editor "Auftrag01" with command "DELIVERY"
And I modify table
    | !row  | mge   | charge     |
    | 1     | 160   | !CH_FERT01 |
And I press button "mzsubm" to open a subeditor for "Materialzuordnung" in row 1
And I modify table
    | !row  | zuomge    | behaelter              |
    | 1     | 10        | !behaelter1_1^nummer   |
    | +2    | 10        | !behaelter1_2^nummer   |
    | +3    | 10        | !behaelter1_3^nummer   |
    | +4    | 10        | !behaelter1_4^nummer   |
    | +5    | 10        | !behaelter1_5^nummer   |
    | +6    | 10        | !behaelter1_6^nummer   |
    | +7    | 10        | !behaelter1_7^nummer   |
    | +8    | 10        | !behaelter1_8^nummer   |
    | +9    | 10        | !behaelter1_9^nummer   |
    | +10   | 10        | !behaelter1_10^nummer  |
    | +11   | 10        | !behaelter1_11^nummer  |
    | +12   | 10        | !behaelter1_12^nummer  |
    | +13   | 10        | !behaelter1_13^nummer  |
    | +14   | 10        | !behaelter1_14^nummer  |
    | +15   | 10        | !behaelter1_15^nummer  |
    | +16   | 10        | !behaelter1_16^nummer  |
And I save the current subeditor to switch back to the parent editor
And I save the current editor


Scenario: 02 Fertigungsdurchlauf mit Behaelter, Rueckmeldung ueber Betriebsauftrag, mehrere Chargen

Given I set the fake date to "03.01.1995"
# Chargen und Behaelter zum befuellen anlegen
Given I create a Lot "CH_FERT02-1" for Product "PROD_F02"
Given I create a Lot "CH_FERT02-2" for Product "PROD_F02"

Given I create a Container "behaelter2-1" for packaging material "KLT" and search word "BEH-F0201"
Given I create a Container "behaelter2-2" for packaging material "KLT" and search word "BEH-F0202"
Given I create a Container "behaelter2-3" for packaging material "KLT" and search word "BEH-F0203"
Given I create a Container "behaelter2-4" for packaging material "KLT" and search word "BEH-F0204"
Given I create a Container "behaelter2-5" for packaging material "KLT" and search word "BEH-F0205"
Given I create a Container "behaelter2-6" for packaging material "KLT" and search word "BEH-F0206"
Given I create a Container "behaelter2-7" for packaging material "KLT" and search word "BEH-F0207"
Given I create a Container "behaelter2-8" for packaging material "KLT" and search word "BEH-F0208"
Given I create a Container "behaelter2-9" for packaging material "KLT" and search word "BEH-F0209"
Given I create a Container "behaelter2-10" for packaging material "KLT" and search word "BEH-F0210"
Given I create a Container "behaelter2-11" for packaging material "KLT" and search word "BEH-F0211"
Given I create a Container "behaelter2-12" for packaging material "KLT" and search word "BEH-F0212"
Given I create a Container "behaelter2-13" for packaging material "KLT" and search word "BEH-F0213"
Given I create a Container "behaelter2-14" for packaging material "KLT" and search word "BEH-F0214"
Given I create a Container "behaelter2-15" for packaging material "KLT" and search word "BEH-F0215"
Given I create a Container "behaelter2-16" for packaging material "KLT" and search word "BEH-F0216"

# Auftrag und Nummer des Auftrags als Verwendung hinterlegen
Given I create a SalesOrder "Auftrag02" for Customer "RADSHOP" with Product "PROD_F02" and quantity "160"

And I switch the current editor to editor "Auftrag02" with command "UPDATE"
And I set field "verw" to "nummer" from editor "Auftrag02" in row 1
And I save the current editor

And I run Scheduling

Given I open an editor "fvor02-1" from table "(Purchasing):(WorkOrderSuggestions)" with command "UPDATE" for record ""
And I set field "artikel" to "PROD_F02"
And I press button "ladetab"
And I modify table
    | mfreig    | bisuch    | !row  |
    | ja        | AUFTR_F02 | 1     |
And I press button "freig" to open a subeditor for "fertigung"
And I close the current subeditor to switch back to the parent editor
And I close the current editor

## BA oeffnen, Nummer zur Pruefung LJ benoetigt
Given I open an editor "Rueckmeldung2-1" from table "(Workorder):(WorkOrders)" with command "VIEW" for record "AUFTR_F02000"
And I save value from field "nummer" in row 0
And I close the current editor

# Manuelle entnahme Packmittel
Given I open an editor "Manuelle Entnahme" for tip command "(WOIssue)" and arguments ""
And I set field "auftrag" to "AUFTR_F02000"
And I press button "stllad"
And I set field "mgr" to "101"
And I save the current editor

Scenario Outline: 02 Fertigungsdurchlauf mit Behaelter, Rueckmeldung ueber Betriebsauftrag, mehrere Chargen

Given I set the fake date to "03.01.1995"
# Rueckmeldungen in Behaelter
Given I open an editor "<Arbeitsschein>" from table "(Workorder):(WorkOrders)" with command "DONE" for record "AUFTR_F02000"
And I set fields
    | mgr       | 112               |
    | kcharge   | <charge>          |
    | behaelter | <behaelter>       |
    | sofort    | 1                 |
And I set field "gutmge" to "10" in row 1
And I save the current editor

Examples: Rueckmeldungen
| Arbeitsschein     | behaelter      | charge       |
| Rueckmeldung2-2   | !behaelter2-1  | !CH_FERT02-1 |
| Rueckmeldung2-3   | !behaelter2-2  | !CH_FERT02-2 |
| Rueckmeldung2-4   | !behaelter2-3  | !CH_FERT02-1 |
| Rueckmeldung2-5   | !behaelter2-4  | !CH_FERT02-2 |
| Rueckmeldung2-6   | !behaelter2-5  | !CH_FERT02-1 |
| Rueckmeldung2-7   | !behaelter2-6  | !CH_FERT02-2 |
| Rueckmeldung2-8   | !behaelter2-7  | !CH_FERT02-1 |
| Rueckmeldung2-9   | !behaelter2-8  | !CH_FERT02-2 |
| Rueckmeldung2-10  | !behaelter2-9  | !CH_FERT02-1 |
| Rueckmeldung2-11  | !behaelter2-10 | !CH_FERT02-2 |
| Rueckmeldung2-12  | !behaelter2-11 | !CH_FERT02-1 |
| Rueckmeldung2-13  | !behaelter2-12 | !CH_FERT02-2 |
| Rueckmeldung2-14  | !behaelter2-13 | !CH_FERT02-1 |
| Rueckmeldung2-15  | !behaelter2-14 | !CH_FERT02-2 |
| Rueckmeldung2-16  | !behaelter2-15 | !CH_FERT02-1 |

Scenario: 02 Fertigungsdurchlauf mit Behaelter, Rueckmeldung ueber Betriebsauftrag, mehrere Chargen

And I set the fake date to "03.01.1995"
Given I open an editor "Arbeitsschein2-17" from table "(Workorder):(WorkOrders)" with command "DONE" for record "AUFTR_F02000"
And I set fields
    | mgr       | 112               |
    | kcharge   | !CH_FERT02-2      |
    | behaelter | !behaelter2-16    |
    | sofort    | ja                |
And I set field "gutmge" to "10" in row 1
And I save the current editor

# Lagerjournaleintraege pruefen
And I open the infosystem "LJ"
And I set fields
    | adatum    | 03.01.95  |
    | zugang    | ja        |
    | artikel   | PROD_F02  |
And I set field "beleg" in row 0 to saved value
And I press start
Then the table has 16 rows
Then table has values
    | buart      | nplatz   | zmge  | verweis^behaelter      |
    | Zugang     | F1       | 10    | !behaelter2-1^nummer   |
    | Zugang     | F1       | 10    | !behaelter2-2^nummer   |
    | Zugang     | F1       | 10    | !behaelter2-3^nummer   |
    | Zugang     | F1       | 10    | !behaelter2-4^nummer   |
    | Zugang     | F1       | 10    | !behaelter2-5^nummer   |
    | Zugang     | F1       | 10    | !behaelter2-6^nummer   |
    | Zugang     | F1       | 10    | !behaelter2-7^nummer   |
    | Zugang     | F1       | 10    | !behaelter2-8^nummer   |
    | Zugang     | F1       | 10    | !behaelter2-9^nummer   |
    | Zugang     | F1       | 10    | !behaelter2-10^nummer  |
    | Zugang     | F1       | 10    | !behaelter2-11^nummer  |
    | Zugang     | F1       | 10    | !behaelter2-12^nummer  |
    | Zugang     | F1       | 10    | !behaelter2-13^nummer  |
    | Zugang     | F1       | 10    | !behaelter2-14^nummer  |
    | Zugang     | F1       | 10    | !behaelter2-15^nummer  |
    | Zugang     | F1       | 10    | !behaelter2-16^nummer  |
And I close the current editor

# Behaelterinhalt pruefen
And I open the infosystem "PRODUCTFINDER"
And I set fields
    | kartikel  | PROD_F02          |
    | kverw     | !Auftrag02^nummer |
    | kcharge   | !CH_FERT02-1      |
And I press start
Then the table has 8 rows
And I close the current editor

And I open the infosystem "PRODUCTFINDER"
And I set fields
    | kartikel  | PROD_F02          |
    | kverw     | !Auftrag02^nummer |
    | kcharge   | !CH_FERT02-2      |
And I press start
Then the table has 8 rows
And I close the current editor

# Auftrag02 abschliessen
Given I switch the current editor to editor "Auftrag02" with command "DELIVERY"
And I modify table
    | !row  | artikel       | mge   | charge        |
    | 1     | !dontChange   | 80    | !CH_FERT02-1  |
    | +2    | PROD_F02      | 80    | !CH_FERT02-2  |
And I press button "mzsubm" to open a subeditor for "Materialzuordnung" in row 1
And I modify table
    | !row  | zuomge    | behaelter         |
    | 1     | 10        | !behaelter2-1     |
    | +2    | 10        | !behaelter2-3     |
    | +3    | 10        | !behaelter2-5     |
    | +4    | 10        | !behaelter2-7     |
    | +5    | 10        | !behaelter2-9     |
    | +6    | 10        | !behaelter2-11    |
    | +7    | 10        | !behaelter2-13    |
    | +8    | 10        | !behaelter2-15    |
And I save the current subeditor to switch back to the parent editor
And I press button "mzsubm" to open a subeditor for "Materialzuordnung2" in row 2
And I modify table
    | !row  | zuomge    | behaelter         |
    | 1     | 10        | !behaelter2-2     |
    | +2    | 10        | !behaelter2-4     |
    | +3    | 10        | !behaelter2-6     |
    | +4    | 10        | !behaelter2-8     |
    | +5    | 10        | !behaelter2-10    |
    | +6    | 10        | !behaelter2-12    |
    | +7    | 10        | !behaelter2-14    |
    | +8    | 10        | !behaelter2-16    |
And I save the current subeditor to switch back to the parent editor
And I set field "ueb" to "ja"
And I save the current editor


Scenario: 03 buplatz ist nicht aenderbar, wenn ein gefuellter Behaelter angegeben wurde, Rueckmeldung und Rueckbau

Given I set the fake date to "04.01.1995"
Given I open an editor "artikel" from table "(Part):(Product)" with command "STORE" for record "FERTIGUNG03"
And I set fields
    | such      | FERTIGUNG03               |
    | namebspr  | Fertigteil in Behaelter   |
    | bsart     | Eigenfertigung            |
And I delete all rows
And I append rows
    | elex          | elanzahl      | lge   | breite    |
    | RAHMEN        | 1             |       |           |
    | RAD           | 1             |       |           |
    | A MONTAGE1    | !dontChange   | 5     | 10        |
And I save the current editor

Given I create a Container "behaelter03" for packaging material "KLT" and search word "FERTIGUNG03"

# Fertigungsvorschlag anlegen und freigeben
Given I open an editor "fvanlegen" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record "" 
And I append rows
    | artikel       | mge   | mfreig    | bisuch        |
    | FERTIGUNG03   | 10    | ja        | FERTIGUNG03   |
And I press button "freig" to open a subeditor for "fertigung"
And I close the current subeditor to switch back to the parent editor
And I close the current editor

# BA Rueckmeldung auf erfassen
Given I open an editor "rueckmelden1" from table "(Workorder):(WorkOrders)" with command "DONE" for record "FERTIGUNG03000"
And I set fields
    | mgr       | 112           |
    | sofort    | ja            |
    | behaelter | !behaelter03  |
And I modify table
    | gutmge    | buplatz   | !row  |
    | 5         | F1        | 1     |
And I save the current editor

# buplatz fuer gefuellte Behaelter nicht aenderbar
Given I open an editor "rueckmelden2" from table "(Workorder):(WorkOrders)" with command "DONE" for record "FERTIGUNG03000"
And I set field "behaelter" to "!behaelter03"
And I set field "gutmge" to "2" in row 1
Then field "buplatz" is not modifiable in row 1
And I close the current editor

# buplatz fuer Rueckgaben nicht aenderbar
Given I open an editor "rueckmelden3" from table "(Workorder):(WorkOrders)" with command "RETURN" for record "FERTIGUNG03000"
And I set field "behaelter" to "!behaelter03"
And I set field "gutmge" to "-2" in row 1
Then field "buplatz" is not modifiable in row 1
And I close the current editor

And I create a Container "FERTIGUNGB03" for packaging material "KLT"

Given I open an editor "EKLS01" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set fields
    | lief   | KETTLER |
    | ebeleg | EKLS01  |
    | vom    | .       |
    | ueb    | ja      |
And I append rows
    | artikel 	| mge	| platz	| !dialogId                                    | !dialogAnswer | exbehnum			  |
    | Pedale  	| 5   	| L2F1	| Externe Behälternummer ist bereits vergeben. | nein          | !FERTIGUNGB03^nummer |
And I save the current editor

# Behaelter aus anderer Lagergruppe nicht eintragbar
Given I open an editor "rueckmelden3" from table "(Workorder):(WorkOrders)" with command "DONE" for record "FERTIGUNG03000"
Then setting field "behaelter" to "FERTIGUNGB03" throws the exception "10687"
And I close the current editor


Scenario: 04 Beschraenkung von manuellen Materialruecknahmen ans Lager, Maske Materialentnahme - Plausis

Given I set the fake date to "05.01.1995"
And I create a Container "behaelter_004fe_1" for packaging material "KLT"
And I create a Container "behaelter_004fe_2" for packaging material "KLT"
And I create a Container "behaelter_004fe_3" for packaging material "KLT"

And I post a receipt via ManualStockAdjustment for Product "RAHMEN" and quantity "5" on StorageLocation "L2F1" with document "L04-ZU" and Container "!behaelter_004fe_2"
And I post a receipt via ManualStockAdjustment for Product "RAD" and quantity "5" on StorageLocation "F1" with document "L04-ZU" and Container "!behaelter_004fe_3"

# Fertigungsvorschlag anlegen und freigeben
Given I open an editor "fvanlegen" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
And I append rows
    | artikel   | mge   | mfreig    | bisuch    |
    | FAHRRAD   | 10    | ja        | MANUELL_  |
And I press button "freig" to open a subeditor for "fertigung"
And I save the current subeditor to switch back to the parent editor
And I close the current editor

# Diverse Fehlermeldungen, wenn angegebener Behaelter nicht das angegebene Material enthaelt
And I open an editor "Materialentnahme" for tip command "(WOIssue)" and arguments ""
And I set fields
    | auftrag       | MANUELL_001   |
    | autorment     | ja            |
And I press button "stllad"
And I set field "manbu" to "ja" in row 1
And I set field "bumge" to "5" in row 1
# Fehler 8343: Der angegebene Behaelter ist leer
Then setting field "behaelter" to "!behaelter_004fe_1" in row 1 throws the exception "8343"
# Fehler 8334: Behaelter liegt nicht auf dem Abgangsplatz
Then setting field "behaelter" to "!behaelter_004fe_2" in row 1 throws the exception "8334"
# Fehler 8311: Der Artikel ist nicht mit den passenden Gebindeinformationen im Behaelter enthalten
Then setting field "behaelter" to "!behaelter_004fe_3" in row 1 throws the exception "8311"
Then field "chentmge" has value "0" in row 1
And I save the current editor

# Betriebsauftrag abschliessen
Given I open an editor "Arbeitsschein" from table "(Workorder):(WorkOrders)" with command "DONE" for record "MANUELL_000"
And I set fields
    | gut           | ja    |
    | sofort        | ja    |
    | mgr           | 112   |
    | stornorest    | ja    |
And I save the current editor


Scenario: 05 Materialrueckgabe von zuvor entnommenem Material ueber eine neue Materialzeile moeglich

Given I set the fake date to "06.01.1995"
# Fertigungsvorschlag anlegen und freigeben
Given I open an editor "fvanlegen" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
And I append rows
    | artikel  | mge   | mfreig    | bisuch    |
    | FAHRRAD  | 10    | ja        | ZUSATZ_   |
And I press button "freig" to open a subeditor for "fertigung"
And I save the current subeditor to switch back to the parent editor
And I close the current editor

# AS1 oeffnen
Given I open an editor "AS05_1" from table "(Workorder):(WorkOrders)" with command "VIEW" for record "ZUSATZ_001"
And I close the current editor

# zusaetzliche Entnahme eines fremden Materials ueber eine neue Zeile in der Materialentnahme
And I open an editor "Materialentnahme05_1" for tip command "(WOIssue)" and arguments ""
And I set fields
    | auftrag       | ZUSATZ_001   |
    | autorment     | ja           |
And I press button "stllad"
And I modify table
    | !row  | elex      | bumge |
    | +1    | PEDALE    | 2     |
Then field "chentmge" has value "0" in row !lastRow
And I save the current editor

# Zuruecklegen zusaetzliche entnommenes Material
And I open an editor "Materialentnahme_zurücklegen" for tip command "(WOIssue)" and arguments ""
And I set fields
    | auftrag       | ZUSATZ_001   |
    | autorment     | ja           |
And I press button "stllad"
Then field "chentmge" has value "2" in row !lastRow
Then field "nlimge" has value "-2" in row !lastRow
And I set field "bumge" to "-1" in row !lastRow
Then field "nlimge" has value "-1" in row !lastRow
And I save the current editor

# Lagerbuchung zusaetzlich entnommenes Material
Given I open the infosystem "LJ"
And I set fields
    | adatum    | 06.01.95          |
    | artikel   | PEDALE            |
    | beleg     | !AS05_1^nummer    |
And I press start
Then table has values
    | art       | amge  |
    | PEDALE    | 2     |
    | PEDALE    | -1    |
And I close the current editor

# Betriebsauftrag abschliessen
Given I open an editor "Arbeitsschein" from table "(Workorder):(WorkOrders)" with command "DONE" for record "ZUSATZ_000"
And I set fields
    | gut           | ja    |
    | sofort        | ja    |
    | mgr           | 112   |
    | stornorest    | ja    |
And I save the current editor


Scenario: BDE01 Behaelter in BDE-Objekten - Auftragszeit

Given I create a Container "BDE01" for packaging material "KLT"

Given I open an editor "MA" from table "(Employee):(Employee)" with command "UPDATE" for record "KARL"
And I set field "lohn" to "1"
And I save the current editor

# Fertigungsvorschlag anlegen
Given I open an editor "FV_BDE01" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
And I append rows
    | artikel           | netmge    | mfreig    | bisuch    |
    | BAUGRUPPE_1010    | 100       | ja        | BDE01_    |
And I press button "freig" to open a subeditor for "BA_freigeben"
And I close the current subeditor to switch back to the parent editor
And I close the current editor

# Arbeitsschein oeffnen, um Zugriff auf Nummer zu haben
Given I open an editor "AS1" from table "(Workorder):(WorkOrders)" with command "VIEW" for search criteria "$,,such=BDE01_001;@richtung=rückwärts;@maxordtreffer=1"
And I close the current editor

# Auftragszeit mit Behaelterangabe buchen
Given I open an editor "Auftragszeit" from table "(PDC):(OrderTime)" with command "NEW" for record ""
And I set fields
    | ma        | KARL          |
    | asma      | !AS1^nummer   |
    | anfdat    | .             |
    | anfzeit   | 10:00         |
    | enddat    | .             |
    | endzeit   | 10:45         |
    | istmge    | 20            |
    | behaelter | BDE01         |
    | sofort    | ja            |
And I save the current editor

# Behaelter in Rueckmeldung pruefen
Given I open an editor "RMPruef" from table "(Workorder):(CompletionConfirmations)" with command "VIEW" for search criteria "$,,such=BDE01_001;@ablage=abgelegt;@richtung=rückwärts;@maxordtreffer=1"
Then field "behaelter^id" has value "!BDE01^id"
And I close the current editor

Given I open an editor "BDE01" from table "(Container):(ContainerShell)" with command "VIEW" for record "BDE01"
Then fields have values
    | behstatusaz   |       |
    | platz         | F1    |
    | behleer       | nein  |
Then table has values
    | artikel           | mge |
    | BAUGRUPPE_1010    | 20  |
And I close the current editor

And I open the infosystem "LJ"
And I set fields
    | adatum        | .                     |
    | artikel       | BAUGRUPPE_1010        |
    | kdetursache   | Rückmeldung Fertigung |
And I press start
Then table has values
    | art               | zmge | behaelter^id |
    | BAUGRUPPE_1010    | 20   | !BDE01^id    |
And I close the current editor


Scenario: BDE01K Behaelter in BDE-Objekten - Kurzlauefer

Given I create a Container "BDE01K" for packaging material "KLT"

# Arbeitsschein aus Scenario BDEO1 nehmen
Given I open an editor "AS1" from table "(Workorder):(WorkOrders)" with command "VIEW" for search criteria "$,,such=BDE01_001;@richtung=rückwärts;@maxordtreffer=1"
And I close the current editor

# Kurzläufer mit Behaelterangabe buchen
Given I open an editor "Kurz1" from table "(PDC):(ShortProductionOrder)" with command "NEW" for record ""
And I set fields
    | ma        | KARL          |
    | asma      | !AS1^nummer   |
    | anfdat    | .             |
    | anfzeit   | 9:00          |
    | istzeit   | 1             |
    | istmge    | 5             |
    | behaelter | BDE01K        |
    | sofort    | ja            |
And I save the current editor

# Behaelter in Rueckmeldung pruefen
Given I open an editor "RMPruef" from table "(Workorder):(CompletionConfirmations)" with command "VIEW" for search criteria "$,,such=BDE01_001;mge==5;@ablage=abgelegt;@richtung=rückwärts;@maxordtreffer=1"
Then field "behaelter^id" has value "!BDE01K^id"
And I close the current editor

Given I open an editor "BDE01K" from table "(Container):(ContainerShell)" with command "VIEW" for record "BDE01K"
Then fields have values
    | behstatusaz   |       |
    | platz         | F1    |
    | behleer       | nein  |
Then table has values
    | artikel           | mge |
    | BAUGRUPPE_1010    | 5   |
And I close the current editor

And I open the infosystem "LJ"
And I set fields
    | adatum        | .                     |
    | artikel       | BAUGRUPPE_1010        |
    | kdetursache   | Rückmeldung Fertigung |
    | richtung      | rückwärts             |
And I press start
Then table has values
    | art               | zmge | behaelter^id |
    | BAUGRUPPE_1010    | 5    | !BDE01K^id   |
And I close the current editor


Scenario: BDE02 Behaelter in BDE-Objekten - Plausis - Behaelterstatus leer und Platz aus Behaelter weicht ab vom FV

Given I create a Container "BDE02SPERR" for packaging material "KLT"
Given I create a Container "BDE02LPF2" for packaging material "KLT"
Given I create a Container "BDE02LPF1" for packaging material "KLT"
Given I create a Container "BDE02ABLAGE" for packaging material "KLT"
Given I create a Container "BDE02LIEFER" for packaging material "BEHAELTER"

And I post a receipt via ManualStockAdjustment for Product "BAUGRUPPE_3000" and quantity "10" on StorageLocation "F1" with document "LBU1BDE02" and Container "!BDE02LPF1"
And I post a receipt via ManualStockAdjustment for Product "BAUGRUPPE_3000" and quantity "10" on StorageLocation "F2" with document "LBU2BDE02" and Container "!BDE02LPF2"
And I post a receipt via ManualStockAdjustment for Product "BG1" and quantity "5" on StorageLocation "F2" with document "LBU3BDE02" and Container "!BDE02LIEFER"

# Behaelter sperren
Given I open an editor "BDE02SPERR" from table "(Container):(ContainerShell)" with command "UPDATE" for record "BDE02SPERR"
And I set field "behstatusaz" to "Gesperrt"
And I save the current editor

# Behaelter ablegen
Given I open an editor "BDE02ABLAGE" from table "(Container):(ContainerShell)" with command "UPDATE" for record "BDE02ABLAGE"
And I set field "ablagef" to "ja"
And I save the current editor

# Behaelter liefern
Given I create a SalesOrder "AUF1" for Customer "TEST" with Product "BG1" and quantity "5"

Given I open an editor "AUF1" from table "(Sales):(SalesOrder)" with command "DELIVERY" for record "AUF1"
And I set fields
    | such   | VKLS_16  |
    | vom    | .        |
    | ueb    | ja       |
And I modify table
    | !row  | platz  | mge  | behaelter     |
    | 1     | F2     | 5    | !BDE02LIEFER  |
And I save the current editor

Given I open an editor "BDE02LIEFER" from table "(Container):(ContainerShell)" with command "VIEW" for record "BDE02LIEFER"
Then fields have values
    | behstatusaz   | Geliefert      |
And I close the current editor

# Arbeitsschein aus Scenario BDEO1 nehmen
Given I open an editor "AS1" from table "(Workorder):(WorkOrders)" with command "VIEW" for search criteria "$,,such=BDE01_001;@richtung=rückwärts;@maxordtreffer=1"
And I close the current editor

# Auftragszeit Plausis bei Behaelterangabe
Given I open an editor "Auftragszeit" from table "(PDC):(OrderTime)" with command "NEW" for record ""
And I set fields
    | ma        | KARL          |
    | asma      | !AS1^nummer   |
    | anfdat    | .             |
    | anfzeit   | 11:00         |
    | enddat    | .             |
    | endzeit   | 11:45         |
    | istmge    | 8             |
    | sofort    | ja            |
# 8413 de      |Behälter ist außer Haus.
Then setting field "behaelter" to "BDE02LIEFER" throws the exception "8413"
# 11072 de      |Der Behälter ist gesperrt.
Then setting field "behaelter" to "BDE02SPERR" throws the exception "11072"
# 2564 de      |Der Behälter ist abgelegt.
Then setting field "behaelter" to "!BDE02ABLAGE^id" throws the exception "2564"
# zulaessigen Behaelter eintragen
And I set field "behaelter" to "BDE02LPF1"
And I save the current editor

# Behaelter pruefen, war bereits gefuellt und liegt auf Platz F1
Given I open an editor "BDE02LPF1" from table "(Container):(ContainerShell)" with command "VIEW" for record "BDE02LPF1"
Then fields have values
    | behstatusaz   |       |
    | platz         | F1    |
    | behleer       | nein  |
Then table has values
    | artikel           | mge |
    | BAUGRUPPE_1010    | 8   |
    | BAUGRUPPE_3000    | 10  |
And I close the current editor

# Kurzlaeufer Plausis bei Behaelterangabe
Given I open an editor "Kurzlaeufer" from table "(PDC):(ShortProductionOrder)" with command "NEW" for record ""
And I set fields
    | ma        | KARL          |
    | asma      | !AS1^nummer   |
    | anfdat    | .             |
    | anfzeit   | 10:00         |
    | istzeit   | 1             |
    | istmge    | 9             |
    | sofort    | ja            |
# 8413 de      |Behälter ist außer Haus.
Then setting field "behaelter" to "BDE02LIEFER" throws the exception "8413"
# 11072 de      |Der Behälter ist gesperrt.
Then setting field "behaelter" to "BDE02SPERR" throws the exception "11072"
# 2564 de      |Der Behälter ist abgelegt.
Then setting field "behaelter" to "!BDE02ABLAGE^id" throws the exception "2564"
# zulaessigen Behaelter eintragen
And I set field "behaelter" to "BDE02LPF1"
And I save the current editor

# Behaelter pruefen, war bereits gefuellt und liegt auf Platz F1
Given I open an editor "BDE02LPF1" from table "(Container):(ContainerShell)" with command "VIEW" for record "BDE02LPF1"
Then fields have values
    | behstatusaz   |       |
    | platz         | F1    |
    | behleer       | nein  |
Then table has values
    | artikel           | mge |
    | BAUGRUPPE_1010    | 17  |
    | BAUGRUPPE_3000    | 10  |
And I close the current editor


Scenario: BDE03 Behaelter in BDE-Objekten - Auftragszeit und Platz aus Behaelter weicht ab vom FV

# BA-Nummer zwischenspeichern
Given I open an editor "BA" from table "(Workorder):(WorkOrders)" with command "VIEW" for search criteria "$,,such=BDE01_000;@richtung=rückwärts;@maxordtreffer=1"
And I save value from field "nummer" in row 0
And I close the current editor

# Platz im Fertigungsvorschlag ist F1
Given I open an editor "FV" from table "(Purchasing):(WorkOrderSuggestions)" with command "VIEW" for record ""
And I set field "artikel" to "BAUGRUPPE_1010"
And I set field "banummer" in row 0 to saved value
And I press button "ladetab"
Then the table has 1 rows
Then field "platz" has value "F1" in row 1
And I close the current editor

# Arbeitsschein aus Scenario BDEO1 nehmen
Given I open an editor "AS1" from table "(Workorder):(WorkOrders)" with command "VIEW" for search criteria "$,,such=BDE01_001;@richtung=rückwärts;@maxordtreffer=1"
And I close the current editor

# Arbeitsschein aus Scenario BDE01 verwenden, gefuellter Behaelter mit abweichendem Platz ist moeglich
Given I open an editor "Auftragszeit" from table "(PDC):(OrderTime)" with command "NEW" for record ""
And I set fields
    | ma        | KARL          |
    | asma      | !AS1^nummer   |
    | anfdat    | .             |
    | anfzeit   | 13:00         |
    | enddat    | .             |
    | endzeit   | 13:45         |
    | istmge    | 7             |
    | behaelter | !BDE02LPF2^id |
    | sofort    | ja            |
And I save the current editor

# Rueckmeldung wurde gebucht und Lagerplatz geaendert
Given I open an editor "RM_03" from table "(Workorder):(CompletionConfirmations)" with command "VIEW" for search criteria "$,,such=BDE01_001;mge==7;@ablage=abgelegt;@richtung=rückwärts;@maxordtreffer=1"
Then field "behaelter^id" has value "!BDE02LPF2^id"
Then field "buplatz" has value "F2" in row 1
And I close the current editor

# Behaelter pruefen, war bereits gefuellt und liegt auf Platz F2
Given I open an editor "BDE02LPF2" from table "(Container):(ContainerShell)" with command "VIEW" for record "BDE02LPF2"
Then fields have values
    | behstatusaz   |       |
    | platz         | F2    |
    | behleer       | nein  |
Then table has values
    | artikel           | mge |
    | BAUGRUPPE_1010    | 7   |
    | BAUGRUPPE_3000    | 10  |
And I close the current editor


Scenario: BDE03K Behaelter in BDE-Objekten - Kurzlaeufer und Platz aus Behaelter weicht ab vom FV

# BA-Nummer zwischenspeichern
Given I open an editor "BA" from table "(Workorder):(WorkOrders)" with command "VIEW" for search criteria "$,,such=BDE01_000;@richtung=rückwärts;@maxordtreffer=1"
And I save value from field "nummer" in row 0
And I close the current editor

# Platz im Fertigungsvorschlag ist F1
Given I open an editor "FV" from table "(Purchasing):(WorkOrderSuggestions)" with command "VIEW" for record ""
And I set field "artikel" to "BAUGRUPPE_1010"
And I set field "banummer" in row 0 to saved value
And I press button "ladetab"
Then the table has 1 rows
Then field "platz" has value "F1" in row 1
And I close the current editor

# Arbeitsschein aus Scenario BDE01 verwenden, gefuellter Behaelter mit abweichendem Platz ist moeglich
Given I open an editor "AS1" from table "(Workorder):(WorkOrders)" with command "VIEW" for search criteria "$,,such=BDE01_001;@richtung=rückwärts;@maxordtreffer=1"
And I close the current editor

Given I open an editor "Kurz2" from table "(PDC):(ShortProductionOrder)" with command "NEW" for record ""
And I set fields
    | ma        | KARL          |
    | asma      | !AS1^nummer   |
    | anfdat    | .             |
    | anfzeit   | 11:00         |
    | istzeit   | 1             |
    | istmge    | 1             |
    | behaelter | !BDE02LPF2^id |
    | sofort    | ja            |
And I save the current editor

# Rueckmeldung wurde gebucht und Lagerplatz geaendert
Given I open an editor "RM_03K" from table "(Workorder):(CompletionConfirmations)" with command "VIEW" for search criteria "$,,such=BDE01_001;mge==1;@ablage=abgelegt;@richtung=rückwärts;@maxordtreffer=1"
Then field "behaelter^id" has value "!BDE02LPF2^id"
Then field "buplatz" has value "F2" in row 1
And I close the current editor

# Behaelter pruefen, war bereits gefuellt und liegt auf Platz F2
Given I open an editor "BDE02LPF2" from table "(Container):(ContainerShell)" with command "VIEW" for record "BDE02LPF2"
Then fields have values
    | behstatusaz   |       |
    | platz         | F2    |
    | behleer       | nein  |
Then table has values
    | artikel           | mge |
    | BAUGRUPPE_1010    | 8   |
    | BAUGRUPPE_3000    | 10  |
And I close the current editor


Scenario: BDE04 Behaelter in BDE-Objekten - Auftragszeit Behaelter mit Platz aus abweichender Lagergruppe nicht zulaessig

Given I create a Container "BDE04EXTERN" for packaging material "BEHAELTER"

And I post a receipt via ManualStockAdjustment for Product "BG1" and quantity "10" on StorageLocation "L3F1" with document "LBU1BDE04" and Container "BDE04EXTERN"

# BA-Nummer zwischenspeichern
Given I open an editor "BA" from table "(Workorder):(WorkOrders)" with command "VIEW" for search criteria "$,,such=BDE01_000;@richtung=rückwärts;@maxordtreffer=1"
And I save value from field "nummer" in row 0
And I close the current editor

# Platz im Fertigungsvorschlag ist F1
Given I open an editor "FV" from table "(Purchasing):(WorkOrderSuggestions)" with command "VIEW" for record ""
And I set field "artikel" to "BAUGRUPPE_1010"
And I set field "banummer" in row 0 to saved value
And I press button "ladetab"
Then the table has 1 rows
Then field "platz" has value "F1" in row 1
And I close the current editor

Given I open an editor "AS1" from table "(Workorder):(WorkOrders)" with command "VIEW" for search criteria "$,,such=BDE01_001;@richtung=rückwärts;@maxordtreffer=1"
And I close the current editor

# Arbeitsschein aus Scenario BDE01 verwenden, gefuellter Behaelter mit Platz aus abweichender Lagergruppe NICHT moeglich
Given I open an editor "Auftragszeit" from table "(PDC):(OrderTime)" with command "NEW" for record ""
And I set fields
    | ma        | KARL          |
    | asma      | !AS1^nummer   |
    | anfdat    | .             |
    | anfzeit   | 14:00         |
    | enddat    | .             |
    | endzeit   | 14:45         |
    | istmge    | 6             |
    | sofort    | ja            |
# Behälter hat Inhalt und Lagerplatz des Behälters passt nicht zu Zugangslagerplatz.
Then setting field "behaelter" to "BDE04EXTERN" throws the exception "10687"
Then field "behaelter" is empty
And I save the current editor

# Rueckmeldung wurde gebucht ohne Behaelter
Given I open an editor "RM_04" from table "(Workorder):(CompletionConfirmations)" with command "VIEW" for search criteria "$,,such=BDE01_001;mge==6;@ablage=abgelegt;@richtung=rückwärts;@maxordtreffer=1"
Then field "behaelter" is empty
Then field "buplatz" has value "F1" in row 1
And I close the current editor

# Behaelter pruefen, war bereits gefuellt und liegt auf Platz L3F1, BAUGRUPPE_1010 wurde NICHT in den Behaelter gebucht
Given I open an editor "BDE04EXTERN" from table "(Container):(ContainerShell)" with command "VIEW" for record "BDE04EXTERN"
Then fields have values
    | behstatusaz   |       |
    | platz         | L3F1  |
    | behleer       | nein  |
Then the table has 1 rows
Then table has values
    | artikel   | mge |
    | BG1       | 10  |
And I close the current editor


Scenario: BDE04K Behaelter in BDE-Objekten - Kurzlaeufer Behaelter mit Platz aus abweichender Lagergruppe nicht zulaessig

# BA-Nummer zwischenspeichern
Given I open an editor "BA" from table "(Workorder):(WorkOrders)" with command "VIEW" for search criteria "$,,such=BDE01_000;@richtung=rückwärts;@maxordtreffer=1"
And I save value from field "nummer" in row 0
And I close the current editor

# Platz im Fertigungsvorschlag ist F1
Given I open an editor "FV" from table "(Purchasing):(WorkOrderSuggestions)" with command "VIEW" for record ""
And I set field "artikel" to "BAUGRUPPE_1010"
And I set field "banummer" in row 0 to saved value
And I press button "ladetab"
Then the table has 1 rows
Then field "platz" has value "F1" in row 1
And I close the current editor

Given I open an editor "AS1" from table "(Workorder):(WorkOrders)" with command "VIEW" for search criteria "$,,such=BDE01_001;@richtung=rückwärts;@maxordtreffer=1"
And I close the current editor

# Arbeitsschein aus Scenario BDE01 verwenden, gefuellter Behaelter mit Platz aus abweichender Lagergruppe NICHT moeglich
Given I open an editor "Kurz4" from table "(PDC):(ShortProductionOrder)" with command "NEW" for record ""
And I set fields
    | ma        | KARL          |
    | asma      | !AS1^nummer   |
    | anfdat    | .             |
    | anfzeit   | 14:00         |
    | istzeit   | 1             |
    | istmge    | 9             |
    | sofort    | ja            |
# Behälter hat Inhalt und Lagerplatz des Behälters passt nicht zu Zugangslagerplatz.
Then setting field "behaelter" to "BDE04EXTERN" throws the exception "10687"
Then field "behaelter" is empty
And I save the current editor

# Rueckmeldung wurde gebucht ohne Behaelter
Given I open an editor "RM_04K" from table "(Workorder):(CompletionConfirmations)" with command "VIEW" for search criteria "$,,such=BDE01_001;mge==9;@ablage=abgelegt;@richtung=rückwärts;@maxordtreffer=1"
Then field "behaelter" is empty
Then field "buplatz" has value "F1" in row 1
And I close the current editor

# Behaelter pruefen, war bereits gefuellt und liegt auf Platz L3F1, BAUGRUPPE_1010 wurde NICHT in den Behaelter gebucht
Given I open an editor "BDE04EXTERN" from table "(Container):(ContainerShell)" with command "VIEW" for record "BDE04EXTERN"
Then fields have values
    | behstatusaz   |       |
    | platz         | L3F1  |
    | behleer       | nein  |
Then the table has 1 rows
Then table has values
    | artikel   | mge |
    | BG1       | 10  |
And I close the current editor
