# *****************************************************************************
#  Name           : liefpack.feature
#  Autor          : mibr
#  Verantwortlich : foe
#  Kontrolle      : dago
#  Funktion       : Packmitteleintraege im Lieferschein
#                   Nachfolgetest zu edp/LADER-Test ref_ns_liefpack als Cucumber Test
#
# *****************************************************************************
#
Feature: Packmittelanweisungen
Background:
Given I set the fake date to "02.01.1995"
Given I enable the flag 39

@Stammdaten
Scenario Outline: Packmittel Container anlegen
Given I open an editor "artikel" from table "(Part):(Product)" with command "STORE" for record "<artikel>"
And I set field "such" to "<such>"
And I set field "namebspr" to "<namebspr>"
And I set field "packmit" to "ja"
And I set field "pmtyp" to "<pmtyp>"
And I save the current editor

Examples:
| artikel   | such | namebspr  | pmtyp     |
| CONTAINER | CONT | CONTAINER | Container |

Scenario: Rundungsfehler bei ungeraden Fuellmengen fixen
#Packmittelanweisung anlegen

Given I open an editor "EBEHPALETTE" from table "(PackingInstructions):(PackingInstructions)" with command "NEW" for record ""
And I set fields
    | such      | EBEHPALETTE                       |
    | namebspr  | Einzelbehaelter auf einer Palette |
And I append rows
    | artikel   | anzahl | ebene       | minebene    | auffuell |
    | BEHAELTER |      1 |          1  |           1 |     nein |
    | 502       |      1 | !dontChange | !dontChange |     nein |
And I save the current editor

#LS anlegen mit Artikel + Packanweisung und Fuellmenge
Given I open an editor "LS1" from table "(Sales):(PackingSlip)" with command "NEW" for record ""
And I set fields
    | kunde     | 1            |
    | such      | BEHPALETT    |
    | vom       | .            |
And I append rows
    | artikel   | mge  | packanw      | fmenge |
    | V1        | 61.2 | !EBEHPALETTE |   20.4 |
And I press button "packvor"
# Es duerfen keine zusaetzlichen Zeilen mit leeren Behaeltern angelegt werden
Then the table has 3 rows
Then table has values
    | pmgrp | stufe | tename            | mge  | fmenge |
    |     1 |     0 | Verkaufsteil eins | 61.2 |   20.4 |
    |     1 |     1 | Behälter eins     |    3 |   20.4 |
    |     1 |     2 | Palette eins      |    3 |      1 |
And I close the current editor

Scenario: Ruecklieferschein getrennt fuer Artikel und Packmittel moeglich, Behaelterkonto wird bebucht

# Behaelterkonto bebuchen in Konfigurationen einschalten
Given I open an editor "Konfiguration" from table "(Company):(Configuration)" with command "UPDATE" for record "0k"
And I set fields
  | automotive   | ja  |
  | bman         | ja  |
And I save the current editor

# Kundenkontakt fuer Kunde 1 anlegen
Given I open an editor "KONTAKT1" from table "(Customer):(CustomerContact)" with command "STORE" for record "KONTAKT1"
And I set fields
    | firma     | 1             |
    | such      | KONTAKT1      |
    | namebspr  | Werk Kunde 1  |
    | werk      | Werk1         |
    | ablstelle | A01           |
And I save the current editor

# Behaelterkonto Geschaeftspartner Kundenkontakt Kunde 1
Given I open an editor "KONTOW1" from table "(ContainerAccount):(ContainerAccount)" with command "STORE" for record "KONTOW1"
And I set fields
    | such      | KONTOW1       |
    | name      | Konto Werk1   |
    | ktofuehr  | intern        |
    | artikel   | PMKARTON      |
    | partner   | !KONTAKT1^id  |
    | werk      | Werk1         |
And I save the current editor

# Packanweisung anlegen
Given I open an editor "PACKVIER" from table "(PackingInstructions):(PackingInstructions)" with command "STORE" for record "PACKVIER"
And I set fields
   | such      | PACKVIER               |
   | namebspr  | vier Stufen mit Deckel |
And I delete all rows
And I append rows
   | artikel     | anzahl   | ebene | minebene  | auffuell  |
   | PMKARTON    | 4        | 1     | 1         | ja        |
   | PMDECKELKRT | 1        | 0     | 0         | nein      |
   | PMPALETTE   | 1        | 1     | 1         | ja        |
   | PMDECKELPLT | 1        | 0     | 0         | nein      |
And I save the current editor

# Lieferschein anlegen, Packmittelgruppe, Packmittelstufe und Gewicht pruefen
Given I open an editor "LS02" from table "(Sales):(PackingSlip)" with command "NEW" for record ""
And I set fields
    | kunde     | KONTAKT1     |
    | such      | LS_PACK      |
    | vom       | .            |
    | ueb       | ja           |
And I append rows
    | artikel   | mge  | packanw   | fmenge |
    | EINK      | 40   | !PACKVIER |   10   |
And I press button "packvor"
Then the table has 5 rows
Then table has values
    | pmgrp | stufe | artikel^such  | mge  | fmenge |
    |     1 |     0 | EINK          | 40   |   10   |
    |     1 |     1 | PMKARTON      |  4   |   10   |
    |     1 |     1 | PMDECKELKRT   |  4   |    1   |
    |     1 |     2 | PMPALETTE     |  1   |    4   |
    |     1 |     2 | PMDECKELPLT   |  1   |    1   |
Then field "nettogew" has value "80"
Then field "bruttogew" has value "93.7"
# 8186 de      |Packstücknummern werden automatisch angelegt bzw. aktualisiert - ok?
#And I respond with answer "ja" to the dialog with id "8186"
And I save the current editor

# Buchung Behaelterkonto pruefen, Abgang
Given I open an editor "KONTOW1" from table "(ContainerAccount):(ContainerAccount)" with command "VIEW" for record "KONTOW1"
Then field "ainternm1" has value "4.00"
And I close the current editor

# Ruecklieferschein erstellen nur fuer Artikel, Packmittelzeilen loeschen
Given I open an editor "RLS1" from table "(Sales):(PackingSlip)" with command "RETURN" for record from editor "LS02"
And I set fields
    | ueb       | ja         |
Then the table has 5 rows
And I set field "mge" to "-40" in row 1
Then field "pmgrp" has value "1" in row 1
Then field "stufe" has value "0" in row 1
And I delete row at position 2
And I delete row at position 2
Then field "nettogew" has value "80"
Then field "bruttogew" has value "80"
And I save the current editor

# Zeile loeschen ist moeglich, nicht speichern, da fuer weiteren Test benoetigt wird
Given I open an editor "RLS2" from table "(Sales):(PackingSlip)" with command "RETURN" for record from editor "LS02"
Then the table has 4 rows
And I delete row at position 1
And I close the current editor

# RLS nur fuer Packmittel kann erfasst und gebucht werden
Given I open an editor "RLS2" from table "(Sales):(PackingSlip)" with command "RETURN" for record from editor "LS02"
And I set fields
    | ueb       | ja         |
Then the table has 4 rows
And I modify table
    | !row | mge   |
    | 1    | -4    |
    | 2    | -4    |
    | 3    | -1    |
    | 4    | -1    |
Then table has values
    | pmgrp | stufe | pmgewnet  | pmgewbrut | bhkto^such    |
    | 1     | 0     | 0         | 0         | !KONTOW1^such |
    | 2     | 0     | 0         | 0         |               |
    | 3     | 0     | 0         | 0         |               |
    | 4     | 0     | 0         | 0         |               |
Then field "nettogew" has value "13.7"
Then field "bruttogew" has value "13.7"
And I save the current editor

# Buchung Behaelterkonto pruefen, Abgang aus LS und Zugang aus RLS
Given I open an editor "KONTOW1" from table "(ContainerAccount):(ContainerAccount)" with command "VIEW" for record "KONTOW1"
Then field "ainternm1" has value "4.00"
Then field "zinternm1" has value "4.00"
And I close the current editor

# ----------------------------------------------------------------------------------------------
Scenario: Packanweisungen und dessen Plausiprüfungen
# ----------------------------------------------------------------------------------------------

# Packanweisung anlegen
Given I open an editor "PACKANW1" from table "(PackingInstructions):(PackingInstructions)" with command "STORE" for record "PACKANW1"
And I set fields
   | such     | PACKANW1           |
   | namebspr | Packanweisung Test |
And I delete all rows
And I append rows
   | artikel   | anzahl | ebene | minebene | auffuell |
   | PMPALETTE | 4      | 1     | 1        | ja       |
Then setting field "mitwanh" to "ja" in row 1 throws the exception "203"
Then field "mitwanh" has value "nein" in row 1
Then field "walayout" has value "" in row 1
And I create a new row at the end of the table
# Ist in der Tabelle bereits vorhanden
Then setting field "artikel" to "PMPALETTE" in row 2 throws the exception "5114"
And I set field "artikel" to "PMKARTONGR" in row 1
And I set field "mitwanh" to "ja" in row 1
# Nur Behaelter, Palette oder Container erlaubt.
Then setting field "pmtyp" to "Zwischenlage" in row 1 throws the exception "8030"
# Leere Zeile loeschen
And I delete row at position 2
# Plausi fuer Container
And I append rows
   | artikel   |
   | PMPALETTE |
   | CONT      |
Then field "anzahl" has value "1" in row 3
Then field "ebene" has value "1" in row 3
Then field "minebene" has value "1" in row 3
Then field "auffuell" has value "nein" in row 3
Then field "mitwanh" has value "nein" in row 3
Then field "walayout" has value "" in row 3
And I save the current editor
