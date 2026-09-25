# **********************************************************************************
#  Name             : roll_woche_monat.feature
#  Autor            : foe
#  Verantwortlich   : foe
#  Kontrolle        :
#  Funktion         : Test des Rollieren über Wochen- und Monatsraster
# **********************************************************************************

@persistent
Feature: roll_woche_monat.feature
Background:
Given I set the fake date to "05.01.2009"

# ----------------------------------------------------------------------------------------------
Scenario: Stammdaten anlegen
# ----------------------------------------------------------------------------------------------

# Artikel anlegen
Given I open an editor "Artikel" from table "(Part):(Product)" with command "NEW" for record ""
And I set fields
  | such     | ABSATZPLAN          |
  | namebspr | Artikel mit Planung |
  | bsart    | Fremdbeschaffung    |
  | dispoa   | bedarfsbezogen      |
  | lief     | 1                   |
  | efrist   | 7                   |
  | epr      | 20                  |
And I save the current editor

# Zeitraster anlegen
Given I open an editor "ZeitrasterM" from table "(PlanningTimePeriod):(PeriodPattern)" with command "NEW" for record ""
And I set fields
  | such        | PL_MONAT   |
  | namebspr    | Plan Monat |
  | zeiteinheit | Monat      |
  | zefaktor    | 1          |
And I save the current editor

Given I open an editor "ZeitrasterW" from table "(PlanningTimePeriod):(PeriodPattern)" with command "NEW" for record ""
And I set fields
  | such        | PL_WOCHE   |
  | namebspr    | Plan Woche |
  | zeiteinheit | Woche      |
  | zefaktor    | 1          |
And I save the current editor

# Planungszeitraeume anlegen
Given I open an editor "Planungzeitraum" from table "(PlanningTimePeriod):(PlanningTimePeriod)" with command "NEW" for record ""
And I set fields
  | such     | MONAT2009  |
  | namebspr | Monat 2009 |
  | zraster  | PL_MONAT   |
  | vorgdat  | 1.1.09     |
  | dauer    | 24         |
And I save the current editor

# Rollierungszeitraeume anlegen
Given I open an editor "RollZR12Monate" from table "(PlanningTimePeriod):(PlanningTimePeriod)" with command "NEW" for record ""
And I set fields
  | such     | RMONAT12             |
  | namebspr | Monat Rollierung 2008|
  | zraster  | PL_MONAT             |
  | vorgdat  | 01.05.09             |
  | dauer    | 12                   |
And I save the current editor

Given I open an editor "RollZR18Wochen" from table "(PlanningTimePeriod):(PlanningTimePeriod)" with command "NEW" for record ""
And I set fields
  | such     | RWOCHE18 |
  | zraster  | PL_WOCHE |
  | vorgdat  | 05.01.09 |
  | dauer    | 18       |
And I save the current editor

# ----------------------------------------------------------------------------------------------
Scenario: Planung anlegen
# ----------------------------------------------------------------------------------------------

# rollierende Planung anlegen
Given I open an editor "WMRollPlanung" from table "(SalesPlanning):(RollingPlanning)" with command "NEW" for record ""
And I set fields
  | such         | ROLLPLAN         |
  | namebspr     | Rollierender Plan|
  | swprefix     | RP20             |
  | nametext     | Roll20           |
  | maxrabschn   | 1                |
  | aktrabschn   | 1                |
  | rollzraum1   | RWOCHE18         |
  | rollzraum2   | RMONAT12         |
  | aktiv        | ja               |
And I save the current editor

# Planung anlegen
Given I open an editor "Planung2009" from table "(SalesPlanning):(Planning)" with command "NEW" for record ""
And I set fields
  | such         | PLAN2009         |
  | namebspr     | Planung fuer 2009|
  | swprefix     | PL09             |
  | nametext     | Plan fuer 2009   |
  | vtabstufen   | 2                |
  | vtabzeilen   | 20               |
  | istzraum     | MONAT2009        |
  | planzraum    | MONAT2009        |
  | rollplanung  | ROLLPLAN         |
And I save the current editor

# Hauptplanungseinheit anlegen
Given I open an editor "HauptPlanEinh" from table "(SalesPlanning):(PlanningUnit)" with command "NEW" for record ""
And I set fields
  | such         | HPL09        |
  | name         | HauptPE 2009 |
  | planung      | PLAN2009     |
  | artber       | ABSATZPLAN   |
  | progtyp      | Mittelwert   |
  | zyklus       | 12           |
  | zeiteinheit  | Monat        |
  | zuwachsfakt  | 0            |
  | rundung      | 1            |
And I save the current editor

# Planung aktivieren
Given I open an editor "Planung2009" from table "(SalesPlanning):(Planning)" with command "UPDATE" for record "PLAN2009"
And I set field "aktiv" to "ja"
And I save the current editor

# Plandaten erzeugen
Given I open an editor "Planung2009" from table "(SalesPlanning):(Planning)" with command "UPDATE" for record "PLAN2009"
And I press button "planerz" to open a subeditor for "plandaten"
And I save the current subeditor to switch back to the parent editor
And I save the current editor

#Basismengen erfassen
Given I open an editor "Wertereihe" from table "(ValueSequence):(ValueSequence)" with command "UPDATE" for search criteria "$,,eplan=HPL09;artber=ABSATZPLAN;typ=Plandaten;@richtung=rückwärts;@maxtreffer=1;@ablageart=lebendig"
And I modify table
  | !row | mge |
  | 1    | 100 |
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
  | 13   | 100 |
  | 14   | 100 |
  | 15   | 100 |
  | 16   | 100 |
  | 17   | 100 |
  | 18   | 100 |
  | 19   | 100 |
  | 20   | 100 |
  | 21   | 100 |
  | 22   | 100 |
  | 23   | 100 |
  | 24   | 100 |

And I save the current editor

# Bedarfsplanung erzeugen
Given I open an editor "Planung2009" from table "(SalesPlanning):(Planning)" with command "UPDATE" for record "PLAN2009"
And I press button "bedarfplerz" to open a subeditor for "bedarfsplanung"
And I save the current subeditor to switch back to the parent editor
And I save the current editor

# ----------------------------------------------------------------------------------------------
Scenario: Rollieren
# ----------------------------------------------------------------------------------------------

# 1. Rollieren
Given I open an editor "WMRollPlanung" from table "(SalesPlanning):(RollingPlanning)" with command "UPDATE" for record "ROLLPLAN"
And I set field "rolldat" to "05.01.09"
And I press button "rollieren" to open a subeditor for "rollieren"
And I save the current subeditor to switch back to the parent editor
And I save the current editor

# Planmengen in den Rollierenden Wertereihen pruefen
Given I open an editor "Wertereihe" from table "(ValueSequence):(RollingForecast)" with command "UPDATE" for search criteria "$,,artber=ABSATZPLAN;;abschn=1;typ=(RollingForecast);archiv=nein;@richtung=rückwärts;@maxtreffer=1;@ablageart=lebendig"
Then field "verrechuebertrag" has value "0"
Then table has values
  | vondat     | bisdat     | bmge | anzarbtage | status      | fix  |
  | 05.01.2009 | 11.01.2009 | 23   | 5          | automatisch | nein |
  | 12.01.2009 | 18.01.2009 | 23   | 5          | automatisch | nein |
  | 19.01.2009 | 25.01.2009 | 23   | 5          | automatisch | nein |
  | 26.01.2009 | 01.02.2009 | 22   | 5          | automatisch | nein |
  | 02.02.2009 | 08.02.2009 | 25   | 5          | automatisch | nein |
  | 09.02.2009 | 15.02.2009 | 25   | 5          | automatisch | nein |
  | 16.02.2009 | 22.02.2009 | 25   | 5          | automatisch | nein |
  | 23.02.2009 | 01.03.2009 | 25   | 5          | automatisch | nein |
  | 02.03.2009 | 08.03.2009 | 23   | 5          | automatisch | nein |
  | 09.03.2009 | 15.03.2009 | 23   | 5          | automatisch | nein |
  | 16.03.2009 | 22.03.2009 | 23   | 5          | automatisch | nein |
  | 23.03.2009 | 29.03.2009 | 22   | 5          | automatisch | nein |
  | 30.03.2009 | 05.04.2009 | 23   | 5          | automatisch | nein |
  | 06.04.2009 | 12.04.2009 | 23   | 5          | automatisch | nein |
  | 13.04.2009 | 19.04.2009 | 22   | 5          | automatisch | nein |
  | 20.04.2009 | 26.04.2009 | 23   | 5          | automatisch | nein |
  | 27.04.2009 | 03.05.2009 | 23   | 5          | automatisch | nein |
  | 04.05.2009 | 10.05.2009 | 24   | 5          | automatisch | nein |
And I close the current editor

Given I open an editor "Wertereihe" from table "(ValueSequence):(RollingForecast)" with command "UPDATE" for search criteria "$,,artber=ABSATZPLAN;abschn=2;typ=(RollingForecast);archiv=nein;@richtung=rückwärts;@maxtreffer=1;@ablageart=lebendig"
Then table has values
  | vondat     | bisdat     | bmge | anzarbtage | status      | fix  |
  | 11.05.2009 | 31.05.2009 | 71   | 15         | automatisch | nein |
  | 01.06.2009 | 30.06.2009 | 100  | 22         | automatisch | nein |
  | 01.07.2009 | 31.07.2009 | 100  | 23         | automatisch | nein |
  | 01.08.2009 | 31.08.2009 | 100  | 21         | automatisch | nein |
  | 01.09.2009 | 30.09.2009 | 100  | 22         | automatisch | nein |
  | 01.10.2009 | 31.10.2009 | 100  | 22         | automatisch | nein |
  | 01.11.2009 | 30.11.2009 | 100  | 21         | automatisch | nein |
  | 01.12.2009 | 31.12.2009 | 100  | 23         | automatisch | nein |
  | 01.01.2010 | 31.01.2010 | 100  | 21         | automatisch | nein |
  | 01.02.2010 | 28.02.2010 | 100  | 20         | automatisch | nein |
  | 01.03.2010 | 31.03.2010 | 100  | 23         | automatisch | nein |
  | 01.04.2010 | 30.04.2010 | 100  | 22         | automatisch | nein |
And I close the current editor

# 2. Rollieren
Given I open an editor "WMRollPlanung" from table "(SalesPlanning):(RollingPlanning)" with command "UPDATE" for record "ROLLPLAN"
And I set field "rolldat" to "12.01.09"
And I press button "rollieren" to open a subeditor for "rollieren"
And I save the current subeditor to switch back to the parent editor
And I save the current editor

# Planmengen in den Rollierenden Wertereihen pruefen
Given I open an editor "Wertereihe" from table "(ValueSequence):(RollingForecast)" with command "UPDATE" for search criteria "$,,artber=ABSATZPLAN;abschn=1;typ=(RollingForecast);archiv=nein;@richtung=rückwärts;@maxtreffer=1;@ablageart=lebendig"
Then field "verrechuebertrag" has value "0"
Then table has values
  | vondat     | bisdat     | bmge | anzarbtage | status      | fix  |
  | 12.01.2009 | 18.01.2009 | 23   | 5          | automatisch | nein |
  | 19.01.2009 | 25.01.2009 | 23   | 5          | automatisch | nein |
  | 26.01.2009 | 01.02.2009 | 22   | 5          | automatisch | nein |
  | 02.02.2009 | 08.02.2009 | 25   | 5          | automatisch | nein |
  | 09.02.2009 | 15.02.2009 | 25   | 5          | automatisch | nein |
  | 16.02.2009 | 22.02.2009 | 25   | 5          | automatisch | nein |
  | 23.02.2009 | 01.03.2009 | 25   | 5          | automatisch | nein |
  | 02.03.2009 | 08.03.2009 | 23   | 5          | automatisch | nein |
  | 09.03.2009 | 15.03.2009 | 23   | 5          | automatisch | nein |
  | 16.03.2009 | 22.03.2009 | 23   | 5          | automatisch | nein |
  | 23.03.2009 | 29.03.2009 | 22   | 5          | automatisch | nein |
  | 30.03.2009 | 05.04.2009 | 23   | 5          | automatisch | nein |
  | 06.04.2009 | 12.04.2009 | 23   | 5          | automatisch | nein |
  | 13.04.2009 | 19.04.2009 | 22   | 5          | automatisch | nein |
  | 20.04.2009 | 26.04.2009 | 23   | 5          | automatisch | nein |
  | 27.04.2009 | 03.05.2009 | 23   | 5          | automatisch | nein |
  | 04.05.2009 | 10.05.2009 | 24   | 5          | automatisch | nein |
  | 11.05.2009 | 17.05.2009 | 24   | 5          | automatisch | nein |
And I close the current editor

Given I open an editor "Wertereihe" from table "(ValueSequence):(RollingForecast)" with command "UPDATE" for search criteria "$,,artber=ABSATZPLAN;abschn=2;typ=(RollingForecast);archiv=nein;@richtung=rückwärts;@maxtreffer=1;@ablageart=lebendig"
Then table has values
  | vondat     | bisdat     | bmge | anzarbtage | status      | fix  |
  | 18.05.2009 | 31.05.2009 |  47  | 10         | automatisch | nein |
  | 01.06.2009 | 30.06.2009 | 100  | 22         | automatisch | nein |
  | 01.07.2009 | 31.07.2009 | 100  | 23         | automatisch | nein |
  | 01.08.2009 | 31.08.2009 | 100  | 21         | automatisch | nein |
  | 01.09.2009 | 30.09.2009 | 100  | 22         | automatisch | nein |
  | 01.10.2009 | 31.10.2009 | 100  | 22         | automatisch | nein |
  | 01.11.2009 | 30.11.2009 | 100  | 21         | automatisch | nein |
  | 01.12.2009 | 31.12.2009 | 100  | 23         | automatisch | nein |
  | 01.01.2010 | 31.01.2010 | 100  | 21         | automatisch | nein |
  | 01.02.2010 | 28.02.2010 | 100  | 20         | automatisch | nein |
  | 01.03.2010 | 31.03.2010 | 100  | 23         | automatisch | nein |
  | 01.04.2010 | 30.04.2010 | 100  | 22         | automatisch | nein |
And I close the current editor

# 3. Rollieren
Given I open an editor "WMRollPlanung" from table "(SalesPlanning):(RollingPlanning)" with command "UPDATE" for record "ROLLPLAN"
And I set field "rolldat" to "19.01.2009"
And I press button "rollieren" to open a subeditor for "rollieren"
And I save the current subeditor to switch back to the parent editor
And I save the current editor

# Planmengen in den Rollierenden Wertereihen pruefen

Given I open an editor "Wertereihe" from table "(ValueSequence):(RollingForecast)" with command "UPDATE" for search criteria "$,,artber=ABSATZPLAN;abschn=1;typ=(RollingForecast);archiv=nein;@richtung=rückwärts;@maxtreffer=1;@ablageart=lebendig"
Then field "verrechuebertrag" has value "0"
Then table has values
  | vondat     | bisdat     | bmge | anzarbtage | status      | fix  |
  | 19.01.2009 | 25.01.2009 | 23   | 5          | automatisch | nein |
  | 26.01.2009 | 01.02.2009 | 22   | 5          | automatisch | nein |
  | 02.02.2009 | 08.02.2009 | 25   | 5          | automatisch | nein |
  | 09.02.2009 | 15.02.2009 | 25   | 5          | automatisch | nein |
  | 16.02.2009 | 22.02.2009 | 25   | 5          | automatisch | nein |
  | 23.02.2009 | 01.03.2009 | 25   | 5          | automatisch | nein |
  | 02.03.2009 | 08.03.2009 | 23   | 5          | automatisch | nein |
  | 09.03.2009 | 15.03.2009 | 23   | 5          | automatisch | nein |
  | 16.03.2009 | 22.03.2009 | 23   | 5          | automatisch | nein |
  | 23.03.2009 | 29.03.2009 | 22   | 5          | automatisch | nein |
  | 30.03.2009 | 05.04.2009 | 23   | 5          | automatisch | nein |
  | 06.04.2009 | 12.04.2009 | 23   | 5          | automatisch | nein |
  | 13.04.2009 | 19.04.2009 | 22   | 5          | automatisch | nein |
  | 20.04.2009 | 26.04.2009 | 23   | 5          | automatisch | nein |
  | 27.04.2009 | 03.05.2009 | 23   | 5          | automatisch | nein |
  | 04.05.2009 | 10.05.2009 | 24   | 5          | automatisch | nein |
  | 11.05.2009 | 17.05.2009 | 24   | 5          | automatisch | nein |
  | 18.05.2009 | 24.05.2009 | 24   | 5          | automatisch | nein |
And I close the current editor

Given I open an editor "Wertereihe" from table "(ValueSequence):(RollingForecast)" with command "UPDATE" for search criteria "$,,artber=ABSATZPLAN;abschn=2;typ=(RollingForecast);archiv=nein;@richtung=rückwärts;@maxtreffer=1;@ablageart=lebendig"
Then table has values
  | vondat     | bisdat     | bmge | anzarbtage | status      | fix  |
  | 25.05.2009 | 31.05.2009 |  23  | 5          | automatisch | nein |
  | 01.06.2009 | 30.06.2009 | 100  | 22         | automatisch | nein |
  | 01.07.2009 | 31.07.2009 | 100  | 23         | automatisch | nein |
  | 01.08.2009 | 31.08.2009 | 100  | 21         | automatisch | nein |
  | 01.09.2009 | 30.09.2009 | 100  | 22         | automatisch | nein |
  | 01.10.2009 | 31.10.2009 | 100  | 22         | automatisch | nein |
  | 01.11.2009 | 30.11.2009 | 100  | 21         | automatisch | nein |
  | 01.12.2009 | 31.12.2009 | 100  | 23         | automatisch | nein |
  | 01.01.2010 | 31.01.2010 | 100  | 21         | automatisch | nein |
  | 01.02.2010 | 28.02.2010 | 100  | 20         | automatisch | nein |
  | 01.03.2010 | 31.03.2010 | 100  | 23         | automatisch | nein |
  | 01.04.2010 | 30.04.2010 | 100  | 22         | automatisch | nein |
And I close the current editor

# 4. Rollieren
Given I open an editor "WMRollPlanung" from table "(SalesPlanning):(RollingPlanning)" with command "UPDATE" for record "ROLLPLAN"
And I set field "rolldat" to "26.01.2009"
And I press button "rollieren" to open a subeditor for "rollieren"
And I save the current subeditor to switch back to the parent editor
And I save the current editor

# Planmengen in den Rollierenden Wertereihen pruefen

Given I open an editor "Wertereihe" from table "(ValueSequence):(RollingForecast)" with command "UPDATE" for search criteria "$,,artber=ABSATZPLAN;abschn=1;typ=(RollingForecast);archiv=nein;@richtung=rückwärts;@maxtreffer=1;@ablageart=lebendig"
Then field "verrechuebertrag" has value "0"
Then table has values
  | vondat     | bisdat     | bmge | anzarbtage | status      | fix  |
  | 26.01.2009 | 01.02.2009 | 22   | 5          | automatisch | nein |
  | 02.02.2009 | 08.02.2009 | 25   | 5          | automatisch | nein |
  | 09.02.2009 | 15.02.2009 | 25   | 5          | automatisch | nein |
  | 16.02.2009 | 22.02.2009 | 25   | 5          | automatisch | nein |
  | 23.02.2009 | 01.03.2009 | 25   | 5          | automatisch | nein |
  | 02.03.2009 | 08.03.2009 | 23   | 5          | automatisch | nein |
  | 09.03.2009 | 15.03.2009 | 23   | 5          | automatisch | nein |
  | 16.03.2009 | 22.03.2009 | 23   | 5          | automatisch | nein |
  | 23.03.2009 | 29.03.2009 | 22   | 5          | automatisch | nein |
  | 30.03.2009 | 05.04.2009 | 23   | 5          | automatisch | nein |
  | 06.04.2009 | 12.04.2009 | 23   | 5          | automatisch | nein |
  | 13.04.2009 | 19.04.2009 | 22   | 5          | automatisch | nein |
  | 20.04.2009 | 26.04.2009 | 23   | 5          | automatisch | nein |
  | 27.04.2009 | 03.05.2009 | 23   | 5          | automatisch | nein |
  | 04.05.2009 | 10.05.2009 | 24   | 5          | automatisch | nein |
  | 11.05.2009 | 17.05.2009 | 24   | 5          | automatisch | nein |
  | 18.05.2009 | 24.05.2009 | 24   | 5          | automatisch | nein |
  | 25.05.2009 | 31.05.2009 | 23   | 5          | automatisch | nein |
 And I close the current editor

Given I open an editor "Wertereihe" from table "(ValueSequence):(RollingForecast)" with command "UPDATE" for search criteria "$,,artber=ABSATZPLAN;abschn=2;typ=(RollingForecast);archiv=nein;@richtung=rückwärts;@maxtreffer=1;@ablageart=lebendig"
Then table has values
  | vondat     | bisdat     | bmge | anzarbtage | status      | fix  |
  | 01.06.2009 | 30.06.2009 | 100  | 22         | automatisch | nein |
  | 01.07.2009 | 31.07.2009 | 100  | 23         | automatisch | nein |
  | 01.08.2009 | 31.08.2009 | 100  | 21         | automatisch | nein |
  | 01.09.2009 | 30.09.2009 | 100  | 22         | automatisch | nein |
  | 01.10.2009 | 31.10.2009 | 100  | 22         | automatisch | nein |
  | 01.11.2009 | 30.11.2009 | 100  | 21         | automatisch | nein |
  | 01.12.2009 | 31.12.2009 | 100  | 23         | automatisch | nein |
  | 01.01.2010 | 31.01.2010 | 100  | 21         | automatisch | nein |
  | 01.02.2010 | 28.02.2010 | 100  | 20         | automatisch | nein |
  | 01.03.2010 | 31.03.2010 | 100  | 23         | automatisch | nein |
  | 01.04.2010 | 30.04.2010 | 100  | 22         | automatisch | nein |
  | 01.05.2010 | 31.05.2010 | 100  | 21          | automatisch | nein |
And I close the current editor

# 5. Rollieren
Given I open an editor "WMRollPlanung" from table "(SalesPlanning):(RollingPlanning)" with command "UPDATE" for record "ROLLPLAN"
And I set field "rolldat" to "02.02.2009"
And I press button "rollieren" to open a subeditor for "rollieren"
And I save the current subeditor to switch back to the parent editor
And I save the current editor

# Planmengen in den Rollierenden Wertereihen pruefen

Given I open an editor "Wertereihe" from table "(ValueSequence):(RollingForecast)" with command "UPDATE" for search criteria "$,,artber=ABSATZPLAN;abschn=1;typ=(RollingForecast);archiv=nein;@richtung=rückwärts;@maxtreffer=1;@ablageart=lebendig"
Then field "verrechuebertrag" has value "0"
Then table has values
  | vondat     | bisdat     | bmge | anzarbtage | status      | fix  |
  | 02.02.2009 | 08.02.2009 | 25   | 5          | automatisch | nein |
  | 09.02.2009 | 15.02.2009 | 25   | 5          | automatisch | nein |
  | 16.02.2009 | 22.02.2009 | 25   | 5          | automatisch | nein |
  | 23.02.2009 | 01.03.2009 | 25   | 5          | automatisch | nein |
  | 02.03.2009 | 08.03.2009 | 23   | 5          | automatisch | nein |
  | 09.03.2009 | 15.03.2009 | 23   | 5          | automatisch | nein |
  | 16.03.2009 | 22.03.2009 | 23   | 5          | automatisch | nein |
  | 23.03.2009 | 29.03.2009 | 22   | 5          | automatisch | nein |
  | 30.03.2009 | 05.04.2009 | 23   | 5          | automatisch | nein |
  | 06.04.2009 | 12.04.2009 | 23   | 5          | automatisch | nein |
  | 13.04.2009 | 19.04.2009 | 22   | 5          | automatisch | nein |
  | 20.04.2009 | 26.04.2009 | 23   | 5          | automatisch | nein |
  | 27.04.2009 | 03.05.2009 | 23   | 5          | automatisch | nein |
  | 04.05.2009 | 10.05.2009 | 24   | 5          | automatisch | nein |
  | 11.05.2009 | 17.05.2009 | 24   | 5          | automatisch | nein |
  | 18.05.2009 | 24.05.2009 | 24   | 5          | automatisch | nein |
  | 25.05.2009 | 31.05.2009 | 23   | 5          | automatisch | nein |
  | 01.06.2009 | 07.06.2009 | 23   | 5          | automatisch | nein |
 And I close the current editor

Given I open an editor "Wertereihe" from table "(ValueSequence):(RollingForecast)" with command "UPDATE" for search criteria "$,,artber=ABSATZPLAN;abschn=2;typ=(RollingForecast);archiv=nein;@richtung=rückwärts;@maxtreffer=1;@ablageart=lebendig"
Then table has values
  | vondat     | bisdat     | bmge | anzarbtage | status      | fix  |
  | 08.06.2009 | 30.06.2009 |  77  | 17         | automatisch | nein |
  | 01.07.2009 | 31.07.2009 | 100  | 23         | automatisch | nein |
  | 01.08.2009 | 31.08.2009 | 100  | 21         | automatisch | nein |
  | 01.09.2009 | 30.09.2009 | 100  | 22         | automatisch | nein |
  | 01.10.2009 | 31.10.2009 | 100  | 22         | automatisch | nein |
  | 01.11.2009 | 30.11.2009 | 100  | 21         | automatisch | nein |
  | 01.12.2009 | 31.12.2009 | 100  | 23         | automatisch | nein |
  | 01.01.2010 | 31.01.2010 | 100  | 21         | automatisch | nein |
  | 01.02.2010 | 28.02.2010 | 100  | 20         | automatisch | nein |
  | 01.03.2010 | 31.03.2010 | 100  | 23         | automatisch | nein |
  | 01.04.2010 | 30.04.2010 | 100  | 22         | automatisch | nein |
  | 01.05.2010 | 31.05.2010 | 100  | 21         | automatisch | nein |
And I close the current editor


# Planmengen in den archivierten Rollierenden Wertereihen pruefen

Given I open an editor "Wertereihe" from table "(ValueSequence):(RollingForecast)" with command "UPDATE" for search criteria "$,,artber=ABSATZPLAN;abschn=1;typ=(RollingForecast);archiv=ja;@richtung=rückwärts;@maxtreffer=1;@ablageart=lebendig"
Then table has values
  | vondat     | bisdat     | bmge | anzarbtage | status      | fix  |
  | 05.01.2009 | 11.01.2009 | 23   | 5          | automatisch | nein |
  | 12.01.2009 | 18.01.2009 | 23   | 5          | automatisch | nein |
  | 19.01.2009 | 25.01.2009 | 23   | 5          | automatisch | nein |
  | 26.01.2009 | 01.02.2009 | 22   | 5          | automatisch | nein |
 And I close the current editor

Given I open an editor "Wertereihe" from table "(ValueSequence):(RollingForecast)" with command "UPDATE" for search criteria "$,,artber=ABSATZPLAN;abschn=2;typ=(RollingForecast);archiv=ja;@richtung=rückwärts;@maxtreffer=1;@ablageart=lebendig"
Then table has values
  | vondat     | bisdat     | bmge | anzarbtage | status      | fix  |
  | 11.05.2009 | 31.05.2009 |  71  | 15         | automatisch | nein |
  | 01.06.2009 | 07.06.2009 |  23  | 5          | automatisch | nein |
And I close the current editor


# 6. Rollieren 4 Wochen weiter
Given I open an editor "WMRollPlanung" from table "(SalesPlanning):(RollingPlanning)" with command "UPDATE" for record "ROLLPLAN"
And I set field "rolldat" to "02.03.2009"
And I press button "rollieren" to open a subeditor for "rollieren"
And I save the current subeditor to switch back to the parent editor
And I save the current editor

# Planmengen in den Rollierenden Wertereihen pruefen

Given I open an editor "Wertereihe" from table "(ValueSequence):(RollingForecast)" with command "UPDATE" for search criteria "$,,artber=ABSATZPLAN;abschn=1;typ=(RollingForecast);archiv=nein;@richtung=rückwärts;@maxtreffer=1;@ablageart=lebendig"
Then field "verrechuebertrag" has value "0"
Then table has values
  | vondat     | bisdat     | bmge | anzarbtage | status      | fix  |
  | 02.03.2009 | 08.03.2009 | 23   | 5          | automatisch | nein |
  | 09.03.2009 | 15.03.2009 | 23   | 5          | automatisch | nein |
  | 16.03.2009 | 22.03.2009 | 23   | 5          | automatisch | nein |
  | 23.03.2009 | 29.03.2009 | 22   | 5          | automatisch | nein |
  | 30.03.2009 | 05.04.2009 | 23   | 5          | automatisch | nein |
  | 06.04.2009 | 12.04.2009 | 23   | 5          | automatisch | nein |
  | 13.04.2009 | 19.04.2009 | 22   | 5          | automatisch | nein |
  | 20.04.2009 | 26.04.2009 | 23   | 5          | automatisch | nein |
  | 27.04.2009 | 03.05.2009 | 23   | 5          | automatisch | nein |
  | 04.05.2009 | 10.05.2009 | 24   | 5          | automatisch | nein |
  | 11.05.2009 | 17.05.2009 | 24   | 5          | automatisch | nein |
  | 18.05.2009 | 24.05.2009 | 24   | 5          | automatisch | nein |
  | 25.05.2009 | 31.05.2009 | 23   | 5          | automatisch | nein |
  | 01.06.2009 | 07.06.2009 | 23   | 5          | automatisch | nein |
  | 08.06.2009 | 14.06.2009 | 23   | 5          | automatisch | nein |
  | 15.06.2009 | 21.06.2009 | 23   | 5          | automatisch | nein |
  | 22.06.2009 | 28.06.2009 | 22   | 5          | automatisch | nein |
  | 29.06.2009 | 05.07.2009 | 23   | 5          | automatisch | nein |
 And I close the current editor

Given I open an editor "Wertereihe" from table "(ValueSequence):(RollingForecast)" with command "UPDATE" for search criteria "$,,artber=ABSATZPLAN;abschn=2;typ=(RollingForecast);archiv=nein;@richtung=rückwärts;@maxtreffer=1;@ablageart=lebendig"
Then table has values
  | vondat     | bisdat     | bmge | anzarbtage | status      | fix  |
  | 06.07.2009 | 31.07.2009 |  86  | 20         | automatisch | nein |
  | 01.08.2009 | 31.08.2009 | 100  | 21         | automatisch | nein |
  | 01.09.2009 | 30.09.2009 | 100  | 22         | automatisch | nein |
  | 01.10.2009 | 31.10.2009 | 100  | 22         | automatisch | nein |
  | 01.11.2009 | 30.11.2009 | 100  | 21         | automatisch | nein |
  | 01.12.2009 | 31.12.2009 | 100  | 23         | automatisch | nein |
  | 01.01.2010 | 31.01.2010 | 100  | 21         | automatisch | nein |
  | 01.02.2010 | 28.02.2010 | 100  | 20         | automatisch | nein |
  | 01.03.2010 | 31.03.2010 | 100  | 23         | automatisch | nein |
  | 01.04.2010 | 30.04.2010 | 100  | 22         | automatisch | nein |
  | 01.05.2010 | 31.05.2010 | 100  | 21         | automatisch | nein |
And I close the current editor

# Planmengen in den archivierten Rollierenden Wertereihen pruefen

Given I open an editor "Wertereihe" from table "(ValueSequence):(RollingForecast)" with command "UPDATE" for search criteria "$,,artber=ABSATZPLAN;abschn=1;typ=(RollingForecast);archiv=ja;@richtung=rückwärts;@maxtreffer=1;@ablageart=lebendig"
Then table has values
  | vondat     | bisdat     | bmge | anzarbtage | status      | fix  |
  | 05.01.2009 | 11.01.2009 | 23   | 5          | automatisch | nein |
  | 12.01.2009 | 18.01.2009 | 23   | 5          | automatisch | nein |
  | 19.01.2009 | 25.01.2009 | 23   | 5          | automatisch | nein |
  | 26.01.2009 | 01.02.2009 | 22   | 5          | automatisch | nein |
  | 02.02.2009 | 08.02.2009 | 25   | 5          | automatisch | nein |
  | 09.02.2009 | 15.02.2009 | 25   | 5          | automatisch | nein |
  | 16.02.2009 | 22.02.2009 | 25   | 5          | automatisch | nein |
  | 23.02.2009 | 01.03.2009 | 25   | 5          | automatisch | nein |
 And I close the current editor

Given I open an editor "Wertereihe" from table "(ValueSequence):(RollingForecast)" with command "UPDATE" for search criteria "$,,artber=ABSATZPLAN;abschn=2;typ=(RollingForecast);archiv=ja;@richtung=rückwärts;@maxtreffer=1;@ablageart=lebendig"
Then table has values
  | vondat     | bisdat     | bmge | anzarbtage | status      | fix  |
  | 11.05.2009 | 31.05.2009 |  71  | 15         | automatisch | nein |
  | 01.06.2009 | 30.06.2009 | 100  | 22         | automatisch | nein |
  | 01.07.2009 | 05.07.2009 |  14  | 3          | automatisch | nein |
And I close the current editor


# 7. Rollieren 2 Wochen zuurueck
Given I open an editor "WMRollPlanung" from table "(SalesPlanning):(RollingPlanning)" with command "UPDATE" for record "ROLLPLAN"
And I set field "rolldat" to "16.02.2009"
And I press button "rollieren" to open a subeditor for "rollieren"
And I save the current subeditor to switch back to the parent editor
And I save the current editor

# Planmengen in den Rollierenden Wertereihen pruefen

Given I open an editor "Wertereihe" from table "(ValueSequence):(RollingForecast)" with command "UPDATE" for search criteria "$,,artber=ABSATZPLAN;abschn=1;typ=(RollingForecast);archiv=nein;@richtung=rückwärts;@maxtreffer=1;@ablageart=lebendig"
Then field "verrechuebertrag" has value "0"
Then table has values
  | vondat     | bisdat     | bmge | anzarbtage | status      | fix  |
  | 16.02.2009 | 22.02.2009 | 25   | 5          | automatisch | nein |
  | 23.02.2009 | 01.03.2009 | 25   | 5          | automatisch | nein |
  | 02.03.2009 | 08.03.2009 | 23   | 5          | automatisch | nein |
  | 09.03.2009 | 15.03.2009 | 23   | 5          | automatisch | nein |
  | 16.03.2009 | 22.03.2009 | 23   | 5          | automatisch | nein |
  | 23.03.2009 | 29.03.2009 | 22   | 5          | automatisch | nein |
  | 30.03.2009 | 05.04.2009 | 23   | 5          | automatisch | nein |
  | 06.04.2009 | 12.04.2009 | 23   | 5          | automatisch | nein |
  | 13.04.2009 | 19.04.2009 | 23   | 5          | automatisch | nein |
  | 20.04.2009 | 26.04.2009 | 22   | 5          | automatisch | nein |
  | 27.04.2009 | 03.05.2009 | 23   | 5          | automatisch | nein |
  | 04.05.2009 | 10.05.2009 | 24   | 5          | automatisch | nein |
  | 11.05.2009 | 17.05.2009 | 24   | 5          | automatisch | nein |
  | 18.05.2009 | 24.05.2009 | 24   | 5          | automatisch | nein |
  | 25.05.2009 | 31.05.2009 | 23   | 5          | automatisch | nein |
  | 01.06.2009 | 07.06.2009 | 23   | 5          | automatisch | nein |
  | 08.06.2009 | 14.06.2009 | 23   | 5          | automatisch | nein |
  | 15.06.2009 | 21.06.2009 | 23   | 5          | automatisch | nein |
 And I close the current editor

Given I open an editor "Wertereihe" from table "(ValueSequence):(RollingForecast)" with command "UPDATE" for search criteria "$,,artber=ABSATZPLAN;abschn=2;typ=(RollingForecast);archiv=nein;@richtung=rückwärts;@maxtreffer=1;@ablageart=lebendig"
Then table has values
  | vondat     | bisdat     | bmge | anzarbtage | status      | fix  |
  | 22.06.2009 | 30.06.2009 |  31  |  7         | automatisch | nein |
  | 01.07.2009 | 31.07.2009 | 100  | 23         | automatisch | nein |
  | 01.08.2009 | 31.08.2009 | 100  | 21         | automatisch | nein |
  | 01.09.2009 | 30.09.2009 | 100  | 22         | automatisch | nein |
  | 01.10.2009 | 31.10.2009 | 100  | 22         | automatisch | nein |
  | 01.11.2009 | 30.11.2009 | 100  | 21         | automatisch | nein |
  | 01.12.2009 | 31.12.2009 | 100  | 23         | automatisch | nein |
  | 01.01.2010 | 31.01.2010 | 100  | 21         | automatisch | nein |
  | 01.02.2010 | 28.02.2010 | 100  | 20         | automatisch | nein |
  | 01.03.2010 | 31.03.2010 | 100  | 23         | automatisch | nein |
  | 01.04.2010 | 30.04.2010 | 100  | 22         | automatisch | nein |
  | 01.05.2010 | 31.05.2010 | 100  | 21         | automatisch | nein |
And I close the current editor

# Planmengen in den archivierten Rollierenden Wertereihen pruefen

Given I open an editor "Wertereihe" from table "(ValueSequence):(RollingForecast)" with command "UPDATE" for search criteria "$,,artber=ABSATZPLAN;abschn=1;typ=(RollingForecast);archiv=ja;@richtung=rückwärts;@maxtreffer=1;@ablageart=lebendig"
Then table has values
  | vondat     | bisdat     | bmge | anzarbtage | status      | fix  |
  | 05.01.2009 | 11.01.2009 | 23   | 5          | automatisch | nein |
  | 12.01.2009 | 18.01.2009 | 23   | 5          | automatisch | nein |
  | 19.01.2009 | 25.01.2009 | 23   | 5          | automatisch | nein |
  | 26.01.2009 | 01.02.2009 | 22   | 5          | automatisch | nein |
  | 02.02.2009 | 08.02.2009 | 25   | 5          | automatisch | nein |
  | 09.02.2009 | 15.02.2009 | 25   | 5          | automatisch | nein |
 And I close the current editor

Given I open an editor "Wertereihe" from table "(ValueSequence):(RollingForecast)" with command "UPDATE" for search criteria "$,,artber=ABSATZPLAN;abschn=2;typ=(RollingForecast);archiv=ja;@richtung=rückwärts;@maxtreffer=1;@ablageart=lebendig"
Then table has values
  | vondat     | bisdat     | bmge | anzarbtage | status      | fix  |
  | 11.05.2009 | 31.05.2009 |  71  | 15         | automatisch | nein |
  | 01.06.2009 | 21.06.2009 |  69  | 15         | automatisch | nein |
And I close the current editor

