@persistent
Feature: absatzplan_basisartikel.feature

Background:
And I set the fake date to "02.01.2002"


# **********************************************************************************
#  Name             : absatzplan_basisartikel.feature
#  Autor            : foe
#  Verantwortlich   : foe
#  Kontrolle        :
#  Funktion         :  Test zur Absatzplanung mit Basiartikeln
#
# **********************************************************************************

##############################################################################################################
## Absatzplanung mit Basiartikel

Scenario: 01 Stammdaten anlegen

# Artikel anlegen
Given I open an editor "Basisartikel" from table "(Part):(BaseProduct)" with command "NEW" for record ""
And I set fields
    | such     | BASISABSATZ  |
    | namebspr | Basisartikel |
And I save the current editor

Scenario Outline: Versionen anlegen
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
    | such  | namebspr                  | dispoa          | plpreis | vpr   |
    | VERS1 | Version 1 bedarfsbezogen  | bedarfsbezogen  | 15.0    | 10.0  |
    | VERS2 | Version 2 auftragsbezogen | auftragsbezogen | 10.0    |  5.0  |
    | VERS3 | Version 3 auftragsbezogen | auftragsbezogen | 15.0    | 10.0  |

Scenario: 01 A Versionen in Basisartikel und Zeitraeume
Given I open an editor "Basisartikel" from table "(Part):(BaseProduct)" with command "UPDATE" for record "BASISABSATZ"
And I append rows
| tversion  | tindex  | tstdvers |
| VERS1     | 001     | ja       |
| VERS2     | 002     | nein     |
| VERS3     | 003     | nein     |
And I save the current editor

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


Scenario: 01 B Basisdaten erfassen

# Lieferscheine und Rechnungen mit den Artikel VERS1, VERS2 und VERS3 fuer jeden Monat des Jahres 2002 buchen
And I set the fake date to "20.01.2002"
Given I open an editor "1LS1" from table "(Sales):(PackingSlip)" with command "NEW" for record ""
And I set fields
   | nummer  | 1LS1  |
   | kunde   | 1     |
   | such    | LS1   |
   | ueb     | ja    |
   | vom     | .     |
   | waehr   | EUR   |
And I append rows
   | artikel | mge | preis |
   | VERS1   | 50  | 12    |
   | VERS2   | 20  |  5    |
   | VERS3   | 20  | 10    |
And I save the current editor

Given I open an editor "1RE1" from table "(Sales):(PackingSlip)" with command "INVOICE" for record from editor "1LS1"
And I set fields
   | nummer | 1RE1  |
   | such   | RE1   |
   | ueb    | ja    |
   | tterm  | .     |
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

And I set the fake date to "14.02.2002"
Given I open an editor "1LS2" from table "(Sales):(PackingSlip)" with command "NEW" for record ""
And I set fields
   | nummer  | 1LS2  |
   | kunde   | 1     |
   | such    | LS2   |
   | ueb     | ja    |
   | vom     | .     |
   | waehr   | EUR   |
And I append rows
   | artikel | mge | preis |
   | VERS1   | 75  | 12    |
   | VERS2   | 30  |  5    |
   | VERS3   | 30  | 10    |
And I save the current editor

Given I open an editor "1RE2" from table "(Sales):(PackingSlip)" with command "INVOICE" for record from editor "1LS2"
And I set fields
   | nummer | 1RE2  |
   | such   | RE2   |
   | ueb    | ja    |
   | tterm  | .     |
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

And I set the fake date to "08.03.2002"
Given I open an editor "1LS3" from table "(Sales):(PackingSlip)" with command "NEW" for record ""
And I set fields
   | nummer  | 1LS3  |
   | kunde   | 1     |
   | such    | LS3   |
   | ueb     | ja    |
   | vom     | .     |
   | waehr   | EUR   |
And I append rows
   | artikel | mge | preis |
   | VERS1   | 100 | 12    |
   | VERS2   | 40  |  5    |
   | VERS3   | 40  | 10    |
And I save the current editor

Given I open an editor "1RE3" from table "(Sales):(PackingSlip)" with command "INVOICE" for record from editor "1LS3"
And I set fields
   | nummer | 1RE3  |
   | such   | RE3   |
   | ueb    | ja    |
   | tterm  | .     |
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

And I set the fake date to "1.04.2002"
Given I open an editor "1LS4" from table "(Sales):(PackingSlip)" with command "NEW" for record ""
And I set fields
   | nummer  | 1LS4  |
   | kunde   | 1     |
   | such    | LS4   |
   | ueb     | ja    |
   | vom     | .     |
   | waehr   | EUR   |
And I append rows
   | artikel | mge | preis |
   | VERS1   | 125 | 13    |
   | VERS2   |  50 |  5    |
   | VERS3   |  50 | 10    |
And I save the current editor

Given I open an editor "1RE4" from table "(Sales):(PackingSlip)" with command "INVOICE" for record from editor "1LS4"
And I set fields
   | nummer | 1RE4  |
   | such   | RE4   |
   | ueb    | ja    |
   | tterm  | .     |
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

And I set the fake date to "17.05.2002"
Given I open an editor "1LS5" from table "(Sales):(PackingSlip)" with command "NEW" for record ""
And I set fields
   | nummer  | 1LS5  |
   | kunde   | 1     |
   | such    | LS5   |
   | ueb     | ja    |
   | vom     | .     |
   | waehr   | EUR   |
And I append rows
   | artikel | mge | preis |
   | VERS1   | 125 | 13    |
   | VERS2   | 50  |  5    |
   | VERS3   | 50  | 10    |
And I save the current editor

Given I open an editor "1RE5" from table "(Sales):(PackingSlip)" with command "INVOICE" for record from editor "1LS5"
And I set fields
   | nummer | 1RE5  |
   | such   | RE5   |
   | ueb    | ja    |
   | tterm  | .     |
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

And I set the fake date to "08.06.2002"
Given I open an editor "1LS6" from table "(Sales):(PackingSlip)" with command "NEW" for record ""
And I set fields
   | nummer  | 1LS6  |
   | kunde   | 1     |
   | such    | LS6   |
   | ueb     | ja    |
   | vom     | .     |
   | waehr   | EUR   |
And I append rows
   | artikel | mge | preis |
   | VERS1   | 175 | 10    |
   | VERS2   | 70  |  6    |
   | VERS3   | 70  | 11    |
And I save the current editor

Given I open an editor "1RE6" from table "(Sales):(PackingSlip)" with command "INVOICE" for record from editor "1LS6"
And I set fields
   | nummer | 1RE6  |
   | such   | RE6   |
   | ueb    | ja    |
   | tterm  | .     |
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

And I set the fake date to "03.07.2002"
Given I open an editor "1LS7" from table "(Sales):(PackingSlip)" with command "NEW" for record ""
And I set fields
   | nummer  | 1LS7  |
   | kunde   | 1     |
   | such    | LS7   |
   | ueb     | ja    |
   | vom     | .     |
   | waehr   | EUR   |
And I append rows
   | artikel | mge | preis |
   | VERS1   | 160 | 11    |
   | VERS2   | 64  |  5    |
   | VERS3   | 64  | 10    |
And I save the current editor

Given I open an editor "1RE7" from table "(Sales):(PackingSlip)" with command "INVOICE" for record from editor "1LS7"
And I set fields
   | nummer | 1RE7  |
   | such   | RE7   |
   | ueb    | ja    |
   | tterm  | .     |
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

And I set the fake date to "03.08.2002"
Given I open an editor "1LS8" from table "(Sales):(PackingSlip)" with command "NEW" for record ""
And I set fields
   | nummer  | 1LS8  |
   | kunde   | 1     |
   | such    | LS8   |
   | ueb     | ja    |
   | vom     | .     |
   | waehr   | EUR   |
And I append rows
   | artikel | mge | preis |
   | VERS1   | 100 | 12    |
   | VERS2   | 40  |  5    |
   | VERS3   | 40  | 10    |
And I save the current editor

Given I open an editor "1RE8" from table "(Sales):(PackingSlip)" with command "INVOICE" for record from editor "1LS8"
And I set fields
   | nummer | 1RE8  |
   | such   | RE8   |
   | ueb    | ja    |
   | tterm  | .     |
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

And I set the fake date to "30.09.2002"
Given I open an editor "1LS9" from table "(Sales):(PackingSlip)" with command "NEW" for record ""
And I set fields
   | nummer  | 1LS9  |
   | kunde   | 1     |
   | such    | LS9   |
   | ueb     | ja    |
   | vom     | .     |
   | waehr   | EUR   |
And I append rows
   | artikel | mge | preis |
   | VERS1   | 75  |  9    |
   | VERS2   | 30  |  8    |
   | VERS3   | 30  | 12    |
And I save the current editor

Given I open an editor "1RE9" from table "(Sales):(PackingSlip)" with command "INVOICE" for record from editor "1LS9"
And I set fields
   | nummer | 1RE9  |
   | such   | RE9   |
   | ueb    | ja    |
   | tterm  | .     |
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

And I set the fake date to "08.10.2002"
Given I open an editor "1LS10" from table "(Sales):(PackingSlip)" with command "NEW" for record ""
And I set fields
   | nummer  | 1LS10 |
   | kunde   | 1     |
   | such    | LS7   |
   | ueb     | ja    |
   | vom     | .     |
   | waehr   | EUR   |
And I append rows
   | artikel | mge | preis |
   | VERS1   | 125 | 11    |
   | VERS2   | 50  |  8    |
   | VERS3   | 50  | 12    |
And I save the current editor

Given I open an editor "1RE10" from table "(Sales):(PackingSlip)" with command "INVOICE" for record from editor "1LS10"
And I set fields
   | nummer | 1RE10 |
   | such   | RE10  |
   | ueb    | ja    |
   | tterm  | .     |
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

And I set the fake date to "09.11.2002"
Given I open an editor "1LS11" from table "(Sales):(PackingSlip)" with command "NEW" for record ""
And I set fields
   | nummer  | 1LS11 |
   | kunde   | 1     |
   | such    | LS11  |
   | ueb     | ja    |
   | vom     | .     |
   | waehr   | EUR   |
And I append rows
   | artikel | mge | preis |
   | VERS1   | 150 | 15    |
   | VERS2   | 60  |  5    |
   | VERS3   | 60  | 15    |
And I save the current editor

Given I open an editor "1RE11" from table "(Sales):(PackingSlip)" with command "INVOICE" for record from editor "1LS11"
And I set fields
   | nummer | 1RE11 |
   | such   | RE11  |
   | ueb    | ja    |
   | tterm  | .     |
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

And I set the fake date to "19.12.2002"
Given I open an editor "1LS12" from table "(Sales):(PackingSlip)" with command "NEW" for record ""
And I set fields
   | nummer  | 1LS12 |
   | kunde   | 1     |
   | such    | LS12  |
   | ueb     | ja    |
   | vom     | .     |
   | waehr   | EUR   |
And I append rows
   | artikel | mge | preis |
   | VERS1   | 125 | 15    |
   | VERS2   | 50  |  5    |
   | VERS3   | 50  | 15    |
And I save the current editor

Given I open an editor "1RE12" from table "(Sales):(PackingSlip)" with command "INVOICE" for record from editor "1LS12"
And I set fields
   | nummer | 1RE12 |
   | such   | RE12  |
   | ueb    | ja    |
   | tterm  | .     |
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

Scenario: 02 Absatzplanung fuer Basisartikel mit Gewichtung der Plandaten

# Rollierungszeitraeume anlegen
Given I open an editor "RollzeitraumM" from table "(PlanningTimePeriod):(PlanningTimePeriod)" with command "NEW" for record ""
And I set fields
 | such     | RMONAT2003            |
 | namebspr | Monat Rollierung 2003 |
 | zraster  | PL_MONAT              |
 | vorgdat  | 1.11.2003             |
 | dauer    | 12                    |
And I save the current editor

# rollierende Planung anlegen
Given I open an editor "RollPlanung" from table "(SalesPlanning):(RollingPlanning)" with command "NEW" for record ""
And I set fields
 | such        | ROLLPLAN          |
 | namebspr    | Rollierender Plan |
 | swprefix    | RP2003            |
 | nametext    | Roll2003          |
 | maxrabschn  | 1                 |
 | aktrabschn  | 1                 |
 | rollzraum1  | RMONAT2003        |
 | aktiv       | ja                |
And I save the current editor

# Planung anlegen
Given I open an editor "Planung2003" from table "(SalesPlanning):(Planning)" with command "NEW" for record ""
And I set fields
 | such        | BPLAN2003         |
 | namebspr    | Planung fuer 2003 |
 | swprefix    | BPL03             |
 | nametext    | Plan fuer 2003    |
 | vtabstufen  | 1                 |
 | vtabzeilen  | 10                |
 | basiszraum  | MONAT2002         |
 | istzraum    | MONAT2003         |
 | planzraum   | MONAT2003         |
 | rollplanung | ROLLPLAN          |
And I save the current editor

# Hauptplanungseinheit anlegen
Given I open an editor "HauptPlanEinh" from table "(SalesPlanning):(PlanningUnit)" with command "NEW" for record ""
And I set fields
 | such        | BPL03        |
 | name        | BasisPE 2003 |
 | planung     | BPLAN2003    |
 | artber      | BASISABSATZ  |
 | progtyp     | Mittelwert   |
 | zyklus      | 12           |
 | zeiteinheit | Monat        |
 | zuwachsfakt | 0            |
 | rundung     | 1            |
And I save the current editor

# Planung aktivieren
Given I open an editor "Planung2003" from table "(SalesPlanning):(Planning)" with command "UPDATE" for record "BPLAN2003"
And I set field "aktiv" to "ja"
And I save the current editor

# Basis-, Ist- und Plandaten erzeugen
Given I open an editor "Planung2003" from table "(SalesPlanning):(Planning)" with command "UPDATE" for record "BPLAN2003"
And I press button "basiserz" to open a subeditor for "basiserz2"
And I save the current subeditor to switch back to the parent editor
And I press button "isterz" to open a subeditor for "isterz2"
And I save the current subeditor to switch back to the parent editor
And I press button "planerz" to open a subeditor for "planerz2"
And I save the current subeditor to switch back to the parent editor
And I save the current editor

# Plandaten erfassen
Given I open an editor "Wertereihe" from table "(ValueSequence):(ValueSequence)" with command "UPDATE" for search criteria "$,,eplan=BPL03;typ=Plandaten;@richtung=rueckwaerts;@maxtreffer=1;@ablageart=lebendig"
And I modify table
  | !row | mge |
  | 1    | 100 |
  | 2    | 150 |
  | 3    | 200 |
  | 4    | 250 |
  | 5    | 250 |
  | 6    | 350 |
  | 7    | 320 |
  | 8    | 200 |
  | 9    | 150 |
  | 10   | 250 |
  | 11   | 300 |
  | 12   | 250 |
And I save the current editor

# Gewichtungen fuer untergeordnete Planungseinheiten eintragen
Given I open an editor "HPlanEinh" from table "(SalesPlanning):(PlanningUnit)" with command "UPDATE" for record "BPL03"
And I set field "anzauto" to "ja"
And I press button "knstanz"
And I modify table
  | !row | tgewichtung |
  | 1    | 50          |
  | 2    | 20          |
  | 3    | 30          |
And I press button "knstgew" to open a subeditor for "Stufen" in row 0
And I save the current editor


Scenario: 03 Erweiterung der Planungshierarchie um eine Version in der Tabelle der Planungseinheit

# neue Version zum Basisartikel erzeugen
Given I open an editor "VERS1" from table "(Part):(Product)" with command "VIEW" for record "VERS1"
And I press button "neuevers" to open a subeditor for "Version"
And I set fields
  | such       | VERS4                       |
  | namebspr   | Version 4 für Absatzplanung |
  | index      | 004                         |
  | rundung    | 1                           |
And I save the current subeditor to switch back to the parent editor
And I close the current editor

# neue Version wird nicht automatisch in die Planung aufgenommen, kann manuell hinzugefügt und Gewichtung angepasst werden
Given I open an editor "HauptPlanEinh" from table "(SalesPlanning):(PlanningUnit)" with command "UPDATE" for record "BPL03"
And I press button "knstanz"
Then the table has 3 rows
Then table has values
  | eplan        | tartber      |
  | BPL03VERS1   | VERS1        |
  | BPL03VERS2   | VERS2        |
  | BPL03VERS3   | VERS3        |
And I create a new row at the end of the table
And I set field "tartber" to "VERS4" in row !lastRow
And I set field "tinplan" to "ja" in row !lastRow
And I press button "eplanerz" in row !lastRow
And I set field "tgewichtung" to "50" in row 1
And I set field "tgewichtung" to "20" in row 2
And I set field "tgewichtung" to "20" in row 3
And I set field "tgewichtung" to "10" in row 4
And I press button "knstgew" to open a subeditor for "aufteilplangew"
And I save the current subeditor to switch back to the parent editor
And I save the current editor


Scenario: 04 Pruefung auf falsche Eingaben - nicht passende Version oder Basisartikel in der Tabelle der Planungseinheit

# Artikel der nicht zum Basisartikel gehört, kann nicht in die Planungseinheit eingetragen werden
Given I open an editor "HauptPlanEinh" from table "(SalesPlanning):(PlanningUnit)" with command "UPDATE" for record "BPL03"
And I press button "knstanz"
Then the table has 4 rows
Then table has values
  | eplan      | tartber|
  | BPL03VERS1 | VERS1  |
  | BPL03VERS2 | VERS2  |
  | BPL03VERS3 | VERS3  |
  | BPL03VERS4 | VERS4  |
And I create a new row at the end of the table
# 1163 |Der Artikel ist keine Version des Basisartikels.
Then setting field "tartber" to "V1" in row !lastRow throws the exception "1163"
# 6725 de      |Untergeordnete Planungseinheiten zu Basisartikeln sind nicht erlaubt.
Then setting field "tartber" to "BASISABSATZ" in row !lastRow throws the exception "6725"
And I close the current editor

############################################################################################################################
# Absatzplanung zu einer Version und Herkunft der Basisdaten aus dem Basisartikel, Abgänge aller Versionen aus dem Vorjahr

Scenario: 05 Absatzplanung zu einer Version und Herkunft der Basisdaten aus dem Basisartikel

# neuen Basisartikel anlegen mit 2 Versionen
Given I open an editor "B_ABSATZ" from table "(Part):(BaseProduct)" with command "STORE" for record "B_ABSATZ"
And I set fields
   | such     | B_ABSATZ            |
   | namebspr | Basis Absatzplanung |
And I save the current editor

Given I open an editor "ABSATZ-V01" from table "(Part):(Product)" with command "STORE" for record "ABSATZ-V01"
And I set fields
    | such          | ABSATZ-V01                  |
    | namebspr      | Version 1 für Absatzplanung |
    | index         | V01                         |
    | basisartikel  | B_ABSATZ                    |
And I save the current editor

Given I open an editor "ABSATZ-V01" from table "(Part):(Product)" with command "VIEW" for record "ABSATZ-V01"
And I press button "neuevers" to open a subeditor for "Version"
And I set fields
    | such         | ABSATZ-V02                   |
    | namebspr     | Version 2 für Absatzplanung  |
    | index        | V02                          |
    | basisartikel | B_ABSATZ                     |
And I save the current subeditor to switch back to the parent editor
And I close the current editor

# Abgaenge buchen im Jahr 2002, die Planung wird fuer 2003 erstellt

Given I create a SalesOrder "AUF001" for Customer "1" with Product "ABSATZ-V01" and quantity "500"
And I deliver the SalesOrder "AUF001" with PackingSlip "LS-AUF001"

And I set the fake date to "15.02.2002"

Given I create a SalesOrder "AUF002" for Customer "1" with Product "ABSATZ-V01" and quantity "500"
And I deliver the SalesOrder "AUF002" with PackingSlip "LS-AUF002"

Given I create a SalesOrder "AUF003" for Customer "1" with Product "ABSATZ-V02" and quantity "1000"
And I deliver the SalesOrder "AUF003" with PackingSlip "LS-AUF003"

And I set the fake date to "15.04.2002"

Given I create a SalesOrder "AUF004" for Customer "1" with Product "ABSATZ-V01" and quantity "1000"
And I deliver the SalesOrder "AUF004" with PackingSlip "LS-AUF004"

Given I create a SalesOrder "AUF005" for Customer "1" with Product "ABSATZ-V02" and quantity "1200"
And I deliver the SalesOrder "AUF005" with PackingSlip "LS-AUF005"

And I set the fake date to "25.05.2002"

Given I create a SalesOrder "AUF006" for Customer "1" with Product "ABSATZ-V01" and quantity "400"
And I deliver the SalesOrder "AUF006" with PackingSlip "LS-AUF006"

Given I create a SalesOrder "AUF007" for Customer "1" with Product "ABSATZ-V02" and quantity "200"
And I deliver the SalesOrder "AUF007" with PackingSlip "LS-AUF007"

And I set the fake date to "05.06.2002"

Given I create a SalesOrder "AUF008" for Customer "1" with Product "ABSATZ-V02" and quantity "300"
And I deliver the SalesOrder "AUF008" with PackingSlip "LS-AUF008"

And I set the fake date to "10.07.2002"

Given I create a SalesOrder "AUF009" for Customer "1" with Product "ABSATZ-V02" and quantity "300"
And I deliver the SalesOrder "AUF009" with PackingSlip "LS-AUF009"

And I set the fake date to "10.08.2002"

Given I create a SalesOrder "AUF010" for Customer "1" with Product "ABSATZ-V01" and quantity "500"
And I deliver the SalesOrder "AUF010" with PackingSlip "LS-AUF010"

And I set the fake date to "15.09.2002"

Given I create a SalesOrder "AUF011" for Customer "1" with Product "ABSATZ-V01" and quantity "500"
And I deliver the SalesOrder "AUF011" with PackingSlip "LS-AUF011"

Given I create a SalesOrder "AUF012" for Customer "1" with Product "ABSATZ-V02" and quantity "1000"
And I deliver the SalesOrder "AUF012" with PackingSlip "LS-AUF012"

And I set the fake date to "10.10.2002"

Given I create a SalesOrder "AUF013" for Customer "1" with Product "ABSATZ-V01" and quantity "500"
And I deliver the SalesOrder "AUF013" with PackingSlip "LS-AUF013"

And I set the fake date to "15.11.2002"

Given I create a SalesOrder "AUF014" for Customer "1" with Product "ABSATZ-V01" and quantity "500"
And I deliver the SalesOrder "AUF014" with PackingSlip "LS-AUF014"

And I set the fake date to "05.12.2002"

Given I create a SalesOrder "AUF015" for Customer "1" with Product "ABSATZ-V02" and quantity "1000"
And I deliver the SalesOrder "AUF015" with PackingSlip "LS-AUF015"

# fake date aendern und neue Version anlegen
And I set the fake date to "02.01.2003"

Given I open an editor "ABSATZ-V01" from table "(Part):(Product)" with command "VIEW" for record "ABSATZ-V01"
And I press button "neuevers" to open a subeditor for "Version"
And I set fields
    | such     | ABSATZ-V03                  |
    | namebspr | Version 3 für Absatzplanung |
    | index    | V03                         |
And I save the current subeditor to switch back to the parent editor
And I close the current editor

# neue Planung anlegen
Given I open an editor "Planung2003neu" from table "(SalesPlanning):(Planning)" with command "NEW" for record ""
And I set fields
 | such        | PLAN2003NEU            |
 | namebspr    | neue Planung fuer 2003 |
 | swprefix    | NPL03                  |
 | nametext    | neuer Plan fuer 2003   |
 | vtabstufen  | 1                      |
 | vtabzeilen  | 10                     |
 | basiszraum  | MONAT2002              |
 | istzraum    | MONAT2003              |
 | planzraum   | MONAT2003              |
 | rollplanung | ROLLPLAN               |
And I save the current editor

# Planungseinheit anlegen und in artber diese dritte Version eintragen und in basisart den Basisartikel
Given I open an editor "HauptPlanEinh" from table "(SalesPlanning):(PlanningUnit)" with command "NEW" for record ""
And I set fields
 | such        | NPL03              |
 | name        | neue BasisPE 2003  |
 | planung     | PLAN2003NEU        |
 | artber      | ABSATZ-V03         |
 | basisart    | B_ABSATZ           |
 | progtyp     | Mittelwert         |
 | zyklus      | 12                 |
 | zeiteinheit | Monat              |
 | zuwachsfakt | 0                  |
 | rundung     | 1                  |
And I save the current editor

# Planung aktivieren
Given I open an editor "Planung2003neu" from table "(SalesPlanning):(Planning)" with command "UPDATE" for record "PLAN2003NEU"
And I set field "aktiv" to "ja"
And I save the current editor

# Basis-, Ist- und Plandaten erzeugen
Given I open an editor "Planung2003neu" from table "(SalesPlanning):(Planning)" with command "UPDATE" for record "PLAN2003NEU"
And I press button "basiserz" to open a subeditor for "basiserz2"
And I save the current subeditor to switch back to the parent editor
And I press button "isterz" to open a subeditor for "isterz2"
And I save the current subeditor to switch back to the parent editor
And I press button "planerz" to open a subeditor for "planerz2"
And I save the current subeditor to switch back to the parent editor
And I save the current editor

Scenario Outline: Neue Versionen anlegen
Given I open an editor "<such>" from table "(Part):(Product)" with command "NEW" for record ""
And I set fields
    | such     | <such>           |
    | namebspr | <namebspr>       |
    | dispoa   | <dispoa>         |
    | bsart    | Fremdbeschaffung |
And I save the current editor
Examples:
    | such   | namebspr                   | dispoa          |
    | VERSA1 | Version A1 bedarfsbezogen  | bedarfsbezogen  |
    | VERSA2 | Version A2 auftragsbezogen | auftragsbezogen |
    | VERSB1 | Version B1 auftragsbezogen | auftragsbezogen |

Scenario: 06 Weitere Stammdaten anlegen

# Basisartikel mit 2 Versionen anlegen
Given I open an editor "BasisartikelA" from table "(Part):(BaseProduct)" with command "NEW" for record ""
And I set fields
    | such     | BASISART_A     |
    | namebspr | Basisartikel A |
And I append rows
    | tversion  | tindex  | tstdvers |
    | VERSA1    | 001     | ja       |
    | VERSA2    | 002     | nein     |
And I save the current editor

# Basisartikel mit 1 Version anlegen
Given I open an editor "BasisartikelB" from table "(Part):(BaseProduct)" with command "NEW" for record ""
And I set fields
    | such     | BASISART_B     |
    | namebspr | Basisartikel B |
And I append rows
    | tversion  | tindex  | tstdvers |
    | VERSB1    | 100     | ja       |
And I save the current editor

Given I open an editor "Artbereich" from table "(ProductRange):(ProductRange)" with command "NEW" for record ""
And I set fields
    | such     | ABERVER                  |
    | namebspr | Artikelbereich Versionen |
And I append rows
    | artikel  | plaktiv |
    | VERSA1   | ja      |
    | VERSB1   | ja      |
# Basisartikel kann nicht planungsrelevant gesetzt werden
# And I create a new row at the end of the table
# And I set field "artikel" to "BASISART_A" in row 3
# And setting field "plaktiv" to "ja" in row 3 throws the exception "203"
# And I delete row at position 3
And I save the current editor

Scenario: Absatzplanung mit Artikelbereich anlegen und aktivieren

# neue Planung anlegen
Given I open an editor "Planung2003Ber" from table "(SalesPlanning):(Planning)" with command "NEW" for record ""
And I set fields
 | such        | PLAN2003BER          |
 | namebspr    | Planung fuer 2003    |
 | swprefix    | ABPL03               |
 | nametext    | ArtBerPlan fuer 2003 |
 | vtabstufen  | 1                    |
 | vtabzeilen  | 10                   |
 | basiszraum  | MONAT2002            |
 | istzraum    | MONAT2003            |
 | planzraum   | MONAT2003            |
 | rollplanung | ROLLPLAN             |
And I save the current editor

# Planungseinheit fuer Artikelbereich anlegen
Given I open an editor "HPlanArtBer" from table "(SalesPlanning):(PlanningUnit)" with command "NEW" for record ""
And I set fields
 | such        | ABPL03B     |
 | name        | BerPE 2003  |
 | planung     | PLAN2003BER |
 | artber      | B ABERVER   |
 | progtyp     | Mittelwert  |
 | zyklus      | 12          |
 | zeiteinheit | Monat       |
 | zuwachsfakt | 0           |
 | rundung     | 1           |
And I save the current editor

Given I open an editor "HPlanArtBer" from table "(SalesPlanning):(PlanningUnit)" with command "UPDATE" for record "ABPL03B"
And I press button "knsterz" to open a subeditor for "sterz1"
And I save the current subeditor to switch back to the parent editor
And I save the current editor

# Artikel in Planungseinheit kann nicht auf Baisartikle geaendert werden
Given I open an editor "PlanVerB1" from table "(SalesPlanning):(PlanningUnit)" with command "UPDATE" for record "ABPL03VERSB1"
And setting field "artber" to "BASISART_B" throws the exception "6725"
And I close the current editor

Given I open an editor "PlanVerA1" from table "(SalesPlanning):(PlanningUnit)" with command "UPDATE" for record "ABPL03VERSA1"
And setting field "artber" to "BASISART_A" throws the exception "6725"
And I close the current editor

# Planung aktivieren
Given I open an editor "Planung2003Ber" from table "(SalesPlanning):(Planning)" with command "UPDATE" for record "PLAN2003BER"
And I set field "aktiv" to "ja"
And I save the current editor

# Istdaten erzeugen
Given I open an editor "Planung2003ber" from table "(SalesPlanning):(Planning)" with command "UPDATE" for record "PLAN2003BER"
And I press button "isterz" to open a subeditor for "isterz2"
And I save the current subeditor to switch back to the parent editor
And I save the current editor

# Istdaten erneut bestimmen
Given I open an editor "Planung2003ber" from table "(SalesPlanning):(Planning)" with command "UPDATE" for record "PLAN2003BER"
And I press button "isterz" to open a subeditor for "isterz2"
And I save the current subeditor to switch back to the parent editor
And I save the current editor

# Istdaten nochmals bestimmen
Given I open an editor "Planung2003ber" from table "(SalesPlanning):(Planning)" with command "UPDATE" for record "PLAN2003BER"
And I press button "isterz" to open a subeditor for "isterz2"
And I save the current subeditor to switch back to the parent editor
And I save the current editor
