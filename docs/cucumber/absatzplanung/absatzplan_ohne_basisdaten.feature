@persistent
Feature: absatzplan_ohne_basisdaten.feature

Background:
And I set the fake date to "02.01.2002"


# **********************************************************************************
#  Name             : absatzplan_ohne_basisdaten.feature
#  Autor            : foe
#  Verantwortlich   : foe
#  Kontrolle        :
#  Funktion         :  Test zur Absatzplanung ohne Basisdaten
#
# **********************************************************************************

##############################################################################################################
## Absatzplanung mit Artikel ohne Basisdaten

Scenario Outline: Neue Artikel anlegen
Given I open an editor "<such>" from table "(Part):(Product)" with command "NEW" for record ""
And I set fields
    | such     | <such>           |
    | namebspr | <namebspr>       |
    | dispoa   | <dispoa>         |
    | vpr      | <vpr>            |
    | plpreis  | <plpreis>        |
    | rundung  | 1                |
    | bsart    | Fremdbeschaffung |
And I save the current editor
Examples:
    | such  | namebspr                   | dispoa          | plpreis | vpr   |
    | ARTN1 | Artikel N1 bedarfsbezogen  | bedarfsbezogen  | 17.0    | 17.0  |
    | ARTN2 | Artikel N2 auftragsbezogen | auftragsbezogen | 10.0    | 10.0  |
    | ARTN3 | Artikel N3 auftragsbezogen | auftragsbezogen | 25.5    | 25.0  |
    | ARTN4 | Artikel N4 auftragsbezogen | auftragsbezogen | 34.0    | 34.0  |

Scenario: Artikelbereich mit neuen Artikel

Given I open an editor "Artbereich" from table "(ProductRange):(ProductRange)" with command "NEW" for record ""
And I set fields
    | such     | ABERNEU                     |
    | namebspr | Artikelbereich neue Artikel |
And I append rows
    | artikel | plaktiv |
    | ARTN1   | ja      |
    | ARTN2   | ja      |
    | ARTN3   | ja      |
And I save the current editor

Scenario: Zeitraeume

# Zeitraster anlegen
Given I open an editor "ZeitrasterM" from table "(PlanningTimePeriod):(PeriodPattern)" with command "NEW" for record ""
And I set fields
 | such        | PL_MONAT    |
 | namebspr    | Plan Monat  |
 | zeiteinheit | Monat       |
 | zefaktor    | 1           |
And I save the current editor

# Planungszeitraeume anlegen
Given I open an editor "Zeitraum2002" from table "(PlanningTimePeriod):(PlanningTimePeriod)" with command "NEW" for record ""
And I set fields
 | such     | MONAT2002   |
 | namebspr | Monat 2002  |
 | zraster  | PL_MONAT    |
 | vorgdat  | 1.1.2002    |
 | dauer    | 12          |
And I save the current editor

Given I open an editor "Zeitraum2002" from table "(PlanningTimePeriod):(PlanningTimePeriod)" with command "NEW" for record ""
And I set fields
 | such     | MONAT2003   |
 | namebspr | Monat 2003  |
 | zraster  | PL_MONAT    |
 | vorgdat  | 1.1.2003    |
 | dauer    | 12          |
And I save the current editor


Scenario: 02 Absatzplanung fuer neue Artikel

# Planung anlegen
Given I open an editor "Planung2003" from table "(SalesPlanning):(Planning)" with command "NEW" for record ""
And I set fields
 | such        | NPLAN2003         |
 | namebspr    | Planung fuer 2003 |
 | swprefix    | NPL03             |
 | nametext    | Plan fuer 2003    |
 | vtabstufen  | 1                 |
 | vtabzeilen  | 10                |
 | basiszraum  | MONAT2002         |
 | istzraum    | MONAT2003         |
 | planzraum   | MONAT2003         |
And I save the current editor

# Hauptplanungseinheit anlegen
Given I open an editor "HauptPlanEinh" from table "(SalesPlanning):(PlanningUnit)" with command "NEW" for record ""
And I set fields
 | such        | NPL03ABERNEU           |
 | name        | Plan fuer 2003 ABERNEU |
 | planung     | NPLAN2003              |
 | artber      | B ABERNEU              |
 | progtyp     | Mittelwert             |
 | zyklus      | 12                     |
 | zeiteinheit | Monat                  |
 | zuwachsfakt | 0                      |
 | rundung     | 1                      |
And I save the current editor

# Plaene der aller Stufen erzeugen
Given I open an editor "HauptPlanEinh" from table "(SalesPlanning):(PlanningUnit)" with command "UPDATE" for record "NPL03"
And I press button "knsterz" to open a subeditor for "sterz1"
And I save the current subeditor to switch back to the parent editor
And I save the current editor

# Plandaten erfassen
Given I open an editor "PEARTN1" from table "(SalesPlanning):(PlanningUnit)" with command "UPDATE" for record "NPL03ARTN1"
And I press button "kbplan" to open a subeditor for "planerz1"
And I set field "plpreis" to "17.0"
And I modify table
  | !row | mge |
  | 1    | 100 |
  | 2    | 150 |
  | 3    | 200 |
  | 4    | 250 |
  | 5    | 160 |
  | 6    | 350 |
  | 7    | 320 |
  | 8    | 200 |
  | 9    | 150 |
  | 10   | 250 |
  | 11   | 300 |
  | 12   | 250 |
And I save the current subeditor to switch back to the parent editor
And I save the current editor

Given I open an editor "PEARTN2" from table "(SalesPlanning):(PlanningUnit)" with command "UPDATE" for record "NPL03ARTN2"
And I press button "kbplan" to open a subeditor for "planerz2"
And I set field "plpreis" to "10.0"
And I modify table
  | !row | mge |
  | 1    | 200 |
  | 2    | 145 |
  | 3    | 150 |
  | 4    | 220 |
  | 5    | 310 |
  | 6    | 150 |
  | 7    | 120 |
  | 8    | 240 |
  | 9    | 180 |
  | 10   | 310 |
  | 11   | 215 |
  | 12   | 190 |
And I save the current subeditor to switch back to the parent editor
And I save the current editor

Given I open an editor "PEARTN3" from table "(SalesPlanning):(PlanningUnit)" with command "UPDATE" for record "NPL03ARTN3"
And I press button "kbplan" to open a subeditor for "planerz3"
And I set field "plpreis" to "25.5"
And I modify table
  | !row | mge |
  | 1    | 115 |
  | 2    | 150 |
  | 3    | 210 |
  | 4    | 170 |
  | 5    | 340 |
  | 6    | 190 |
  | 7    | 140 |
  | 8    | 150 |
  | 9    | 270 |
  | 10   | 170 |
  | 11   | 260 |
  | 12   | 150 |
And I save the current subeditor to switch back to the parent editor
And I save the current editor

# Summierte Plantern pruefen
Given I open an editor "SumPlandaten1" from table "(ValueSequence):(ValueSequence)" with command "VIEW" for search criteria "$,,eplan=NPL03ABERNEU;typ=Plandaten;@richtung=rueckwaerts;@maxtreffer=1;@ablageart=lebendig"
Then the table has 12 rows
Then table has values
  | !row   | mge  |
  | 1      | 415  |
  | 2      | 445  |
  | 3      | 560  |
  | 4      | 640  |
  | 5      | 810  |
  | 6      | 690  |
  | 7      | 580  |
  | 8      | 590  |
  | 9      | 600  |
  | 10     | 730  |
  | 11     | 775  |
  | 12     | 590  |
And I save the current editor

# Plandaten summerieren
Given I open an editor "Planung2003" from table "(SalesPlanning):(Planning)" with command "UPDATE" for record "NPLAN2003"
And I press button "planerz" to open a subeditor for "planerz2"
And I save the current subeditor to switch back to the parent editor
And I save the current editor

# Summierte Plantern pruefen
Given I open an editor "SumPlandaten2" from table "(ValueSequence):(ValueSequence)" with command "VIEW" for search criteria "$,,eplan=NPL03ABERNEU;typ=Plandaten;@richtung=rueckwaerts;@maxtreffer=1;@ablageart=lebendig"
Then the table has 12 rows
Then table has values
  | !row   | mge  |
  | 1      | 415  |
  | 2      | 445  |
  | 3      | 560  |
  | 4      | 640  |
  | 5      | 810  |
  | 6      | 690  |
  | 7      | 580  |
  | 8      | 590  |
  | 9      | 600  |
  | 10     | 730  |
  | 11     | 775  |
  | 12     | 590  |
And I save the current editor

# Planung aktivieren
Given I open an editor "Planung2003" from table "(SalesPlanning):(Planning)" with command "UPDATE" for record "NPLAN2003"
And I set field "aktiv" to "ja"
And I save the current editor

Scenario: 03 Erweiterung der Planungshierarchie um einen Artikel in der Tabelle der Planungseinheit

# Artikel N4 kann manuell der Planung hinzugefuegt werden
Given I open an editor "HauptPlanEinh" from table "(SalesPlanning):(PlanningUnit)" with command "UPDATE" for record "NPL03ABERNEU"
And I press button "knstanz"
Then the table has 3 rows
Then table has values
  | eplan        | tartber |
  | NPL03ARTN1   | ARTN1   |
  | NPL03ARTN2   | ARTN2   |
  | NPL03ARTN3   | ARTN3   |
And I create a new row at the end of the table
And I set field "tartber" to "ARTN4" in row !lastRow
And I set field "tinplan" to "ja" in row !lastRow
And I press button "eplanerz" in row !lastRow
And I save the current editor

Given I open an editor "PEARTN4" from table "(SalesPlanning):(PlanningUnit)" with command "UPDATE" for record "NPL03ARTN4"
And I press button "kbplan" to open a subeditor for "planerz1"
And I set field "plpreis" to "34.0"
And I modify table
  | !row | mge |
  | 1    |  50 |
  | 2    | 100 |
  | 3    | 100 |
  | 4    | 100 |
  | 5    | 100 |
  | 6    | 100 |
  | 7    | 100 |
  | 8    | 100 |
  | 9    | 100 |
  | 10   | 100 |
  | 11   | 100 |
  | 12   | 100 |
And I save the current subeditor to switch back to the parent editor
And I save the current editor

 # Summierte Plandaten vor Loeschen pruefen
Given I open an editor "SumPlandaten3" from table "(ValueSequence):(ValueSequence)" with command "VIEW" for search criteria "$,,eplan=NPL03ABERNEU;typ=Plandaten;@richtung=rueckwaerts;@maxtreffer=1;@ablageart=lebendig"
Then the table has 12 rows
Then table has values
  | !row   | mge  |
  | 1      | 465  |
  | 2      | 545  |
  | 3      | 660  |
  | 4      | 740  |
  | 5      | 910  |
  | 6      | 790  |
  | 7      | 680  |
  | 8      | 690  |
  | 9      | 700  |
  | 10     | 830  |
  | 11     | 875  |
  | 12     | 690  |
And I save the current editor

# Summerierte Plandaten loeschen
Given I open an editor "WRDelete1" from table "(ValueSequence):(ValueSequence)" with command "DELETE" for search criteria "$,,eplan=NPL03ABERNEU;typ=Plandaten;@richtung=rueckwaerts;@maxtreffer=1;@ablageart=lebendig"
And I save the current editor

# Plandaten neu summerieren
Given I open an editor "Planung2003Neu" from table "(SalesPlanning):(Planning)" with command "UPDATE" for record "NPLAN2003"
And I press button "planerz" to open a subeditor for "planerz2"
And I save the current subeditor to switch back to the parent editor
And I save the current editor

 # Summierte Plandaten nach Loeschen und Erzeugen pruefen
Given I open an editor "SumPlandaten3" from table "(ValueSequence):(ValueSequence)" with command "VIEW" for search criteria "$,,eplan=NPL03ABERNEU;typ=Plandaten;@richtung=rueckwaerts;@maxtreffer=1;@ablageart=lebendig"
Then the table has 12 rows
Then table has values
  | !row   | mge  |
  | 1      | 465  |
  | 2      | 545  |
  | 3      | 660  |
  | 4      | 740  |
  | 5      | 910  |
  | 6      | 790  |
  | 7      | 680  |
  | 8      | 690  |
  | 9      | 700  |
  | 10     | 830  |
  | 11     | 875  |
  | 12     | 690  |
And I save the current editor
