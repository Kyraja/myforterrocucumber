#***************************************************************************
#
#  Name           : absatzplan.feature
#  Datum          : 15.12.2008/17.03.2021
#  Autor          : foe
#  Verantwortlich : foe
#
#  Funktion  : Test zum automatischen Anlegen von Planungseinheiten
#
#
#***************************************************************************
@persistent
Feature: Absatzplanung
Background:
Given I set the fake date to "01.02.2009"

Scenario: Absatzplanung
# --------------------------------------------------------------------------
# Alle Stufen erzeugen
# --------------------------------------------------------------------------
Given I open an editor "P09TOP" from table "(SalesPlanning):(PlanningUnit)" with command "UPDATE" for record "P09TOP"
# Plaene der naechsten Stufe erzeugen
And I press button "knsterz" to open a subeditor for "sterz1"
And I save the current subeditor to switch back to the parent editor
# Plaene der naechsten x Stufen anzeigen
And I press button "kxstanz"
# 5 Zeilen vorhanden
Then the table has 5 rows
And I save the current editor

Given I open an editor "P09EINKAUF" from table "(SalesPlanning):(PlanningUnit)" with command "UPDATE" for record "P09EINKAUF"
# Plaene der naechsten Stufe erzeugen
And I press button "knsterz" to open a subeditor for "sterz2"
And I save the current subeditor to switch back to the parent editor
# Plaene der naechsten Stufe anzeigen
And I press button "knstanz"
# 3 Zeilen vorhanden
Then the table has 3 rows
And I save the current editor

Given I open an editor "P09VERKAUF" from table "(SalesPlanning):(PlanningUnit)" with command "UPDATE" for record "P09VERKAUF"
# Plaene der aller Stufen erzeugen
And I press button "knsterz" to open a subeditor for "sterz3"
And I save the current subeditor to switch back to the parent editor
# Plaene der naechsten Stufe anzeigen
And I press button "knstanz"
# 4 Zeilen vorhanden
Then the table has 4 rows
And I save the current editor

Given I open an editor "P09BAUTEILE-EINKAUF" from table "(SalesPlanning):(PlanningUnit)" with command "UPDATE" for record "P09BAUTEILE-EINKAUF"
# Plaene der naechsten Stufe erzeugen
And I press button "kallsterz" to open a subeditor for "allsterz1"
And I save the current subeditor to switch back to the parent editor
# Plaene der naechsten Stufe anzeigen
And I press button "knstanz"
# 2 Zeilen vorhanden
Then the table has 2 rows
And I save the current editor
#
Given I open an editor "P09TOP_2" from table "(SalesPlanning):(PlanningUnit)" with command "VIEW" for record "P09TOP"
# Plaene der naechsten x Stufen anzeigen
And I press button "kxstanz"
# 13 Zeilen vorhanden
Then the table has 13 rows
And I save the current editor

# --------------------------------------------------------------------------
# Spezifischen Planungseinheit erzeugen fuer P09EINKAUF
# --------------------------------------------------------------------------
#
Given I open an editor "PLEINH3" from table "(SalesPlanning):(PlanningUnit)" with command "UPDATE" for record "3"
# Anzeige der untergeordn. Planungseinheiten (Default)
And I set field "tabspez" to "nein"
# Untergeordn. Planungseinheiten von x Stufen anzeigen
And I press button "kxstanz"
# 3 Planungseinheiten vorhanden
Then the table has 3 rows
# Anzeige der spezifische Planungseinheiten
And I set field "tabspez" to "ja"
# Spezifische Planungseinheiten mit Unterplaenen anzeigen
# Nichts vorhanden
Then the table has 0 rows
And I press button "kxstanz"
And I append rows
  |tinplan  | tlgruppe |
  |ja       | KARLSRUHE|
Then the table has 1 rows
# 1 spezifische Planungseinheit erzeugen
And I press button "eplanerz" in row 1
# 8 Zeilen vorhanden
Then the table has 8 rows
And I save the current editor

# Neu holen
Given I open an editor "PLEINH3_NEU" from table "(SalesPlanning):(PlanningUnit)" with command "VIEW" for record "3"
# Spezifische Planungseinheiten der naechsten Stufe anzeigen
And I set field "tabspez" to "ja"
And I press button "knstanz"
# 2 spezifische Planungseinheiten vorhanden
Then the table has 2 rows
# Spezifische Planungseinheiten mit Unterplaenen anzeigen
# je 3 Unterplanungseinheiten
And I press button "kxstanz"
Then the table has 8 rows
# Verdichtung alle Stufen einpacken
And I press button "t1einaus" in row 1
Then the table has 5 rows
And I save the current editor

# --------------------------------------------------------------------------
# Planpreis in Planungseinheit P09BAUT aendern
# --------------------------------------------------------------------------
Given I open an editor "P09BAUT" from table "(SalesPlanning):(PlanningUnit)" with command "UPDATE" for record "P09BAUT"
# Planpreis aendern -> =/= Vorgabeplanpreis
And I set fields
	| plpreis | 12.00  |
And I save the current editor

# --------------------------------------------------------------------------
# Daten erzeugen fuer Planung 2009
# --------------------------------------------------------------------------
# Basis-, Ist-Daten erzeugen
Given I open an editor "PLANUNG1" from table "(SalesPlanning):(Planning)" with command "UPDATE" for record "1"
And I press button "basiserz" to open a subeditor for "basiserz1"
And I save the current subeditor to switch back to the parent editor
And I press button "isterz  " to open a subeditor for "isterz1"
And I save the current subeditor to switch back to the parent editor
And I save the current editor

# --------------------------------------------------------------------------
# Planpreis in Planungseinheit P09BADEMANTEL aendern
# --------------------------------------------------------------------------
Given I open an editor "P09BADEMANTEL" from table "(SalesPlanning):(PlanningUnit)" with command "UPDATE" for record "P09BADEMANTEL"
# Planpreis aendern -> =/= Vorgabeplanpreis
And I set fields
	| plpreis    | 38.00  |
	| fixplpreis | nein   |
And I save the current editor

# Plandaten erzeugen
Given I open an editor "PLANUNG1" from table "(SalesPlanning):(Planning)" with command "UPDATE" for record "1"
And I press button "planerz" to open a subeditor for "planerz1"
And I save the current subeditor to switch back to the parent editor
And I save the current editor

# --------------------------------------------------------------------------
# Neue Planungseinheit (P09TEST) ohne Wertereihen anlegen
# --------------------------------------------------------------------------
Given I open an editor "P09VERKAUF" from table "(SalesPlanning):(PlanningUnit)" with command "UPDATE" for record "P09VERKAUF"
And I set field "anzauto" to "ja"
And I press button "kxstanz"
# Es sind 6 Planungseinheiten in 2 Stufen vorhanden
Then the table has 6 rows
# Zeile 7 aufsuchen ???
And I append rows
  |tinplan  | tartber  | stufe |
  |ja       | TEST     | 1     |
Then the table has 7 rows
# Neue Planungseinheit erzeugen
And I press button "eplanerz" in row 7
And I save the current editor
# Wertereihe Basisdaten erzeugen
Given I open an editor "P09TEST" from table "(SalesPlanning):(PlanningUnit)" with command "UPDATE" for record "P09TEST"
And I press button "kbbasis" to open a subeditor for "kbbasis1"
And I save the current subeditor to switch back to the parent editor
And I save the current editor

# Wertereihe Basisdaten anzeigen
Given I open an editor "P09TEST_2" from table "(SalesPlanning):(PlanningUnit)" with command "VIEW" for record "P09TEST"
And I press button "kbbasis" to open a subeditor for "kbbasis2"
And I save the current subeditor to switch back to the parent editor
And I save the current editor

# --------------------------------------------------------------------------
# Planung 2009 auf Planung 2010 kopieren
# --------------------------------------------------------------------------
# Texte und Zeitraeume anpassen
# Alle zugehoerigen Planungseinheiten kopieren
Given I open an editor "PLANKOPIE1" from table "(SalesPlanning):(Planning)" with command "NEW" for record "1"
And I set fields
	| such      | Planung2010         |
	| name      | Gesamtplanung 2010  |
	| swprefix  | P10                 |
	| nametext  | Plan 2010 für       |
	| istzraum  | ZRMONAT10           |
	| planzraum | ZRMONAT10           |
And I press button "pekopie" to open a subeditor for "pekopie"
And I save the current subeditor to switch back to the parent editor
And I save the current editor

# --------------------------------------------------------------------------
# Weitere lagergruppenspezifische Planungseinheit zu P10E2
# --------------------------------------------------------------------------
Given I open an editor "PLEINH47" from table "(SalesPlanning):(PlanningUnit)" with command "UPDATE" for record "47"
# Anzeige der spezifischen Planungseinheiten fuer E2
# fuer Planungseinheit eines Artikel: tabspez = ja (nicht aenderbar)
And I press button "kxstanz"
#  2 Zeilen vorhanden
Then the table has 2 rows
And I append rows
  |tinplan  | tlgruppe |
  |ja       | BERLIN   |
Then the table has 3 rows
# Weitere spezifische Planungseinheit fuer BERLIN erzeugen
And I press button "eplanerz" in row 3
And I save the current editor

# --------------------------------------------------------------------------
# Planpreis in Planungseinheit P10BAUT aendern
# --------------------------------------------------------------------------
Given I open an editor "P10BAUT" from table "(SalesPlanning):(PlanningUnit)" with command "UPDATE" for record "P10BAUT"
# Planpreisfixierung aufheben
And I set fields
	| fixplpreis | nein  |
And I save the current editor

# --------------------------------------------------------------------------
# Daten erzeugen fuer Planung 2010
# --------------------------------------------------------------------------
# Basis-, Ist- und Plandaten erzeugen
Given I open an editor "PLANUNG43" from table "(SalesPlanning):(Planning)" with command "UPDATE" for record "43"
And I press button "basiserz" to open a subeditor for "basiserz2"
And I save the current subeditor to switch back to the parent editor
And I press button "isterz" to open a subeditor for "isterz2"
And I save the current subeditor to switch back to the parent editor
And I press button "planerz" to open a subeditor for "planerz2"
And I save the current subeditor to switch back to the parent editor
And I save the current editor


# --------------------------------------------------------------------------
# Jahresplanung mit abweichenden Jahreszeitraeumen
# Es werden keine Plandaten generiert, wenn das Anfangsdatum der Zeitraeume
# fuer Basis und Plan bzgl. des Pronoserasters abweichen
# --------------------------------------------------------------------------

Scenario: Planung mit verschiedenen Planungszeitraeumen, teils mit abweichenden Anfangsdatum des Jahreszeitraums

Given I open an editor "JTEST" from table "(Part):(Product)" with command "COPY" for record "Test"
 And I set fields
      | such          | JTEST             |
      | namebspr      | Testartikel Jahr  |
 And I save the current editor

#Planungszeitraeme anlegen
Given I open an editor "Zeitraum2007" from table "(PlanningTimePeriod):(PlanningTimePeriod)" with command "NEW" for record ""
And I set fields
 | nummer   | 20           |
 | such     | JAHR2007/08  |
 | namebspr | Jahr 200//08 |
 | zraster  | ZJAHR        |
 | vorgdat  | 1.5.2007     |
 | dauer    | 1            |
And I save the current editor

Given I open an editor "Zeitraum2008" from table "(PlanningTimePeriod):(PlanningTimePeriod)" with command "NEW" for record ""
And I set fields
 | nummer   | 21           |
 | such     | JAHR2008/09  |
 | namebspr | Jahr 2008/09 |
 | zraster  | ZJAHR        |
 | vorgdat  | 1.5.2008     |
 | dauer    | 1            |
And I save the current editor

Given I open an editor "Zeitraum2009A" from table "(PlanningTimePeriod):(PlanningTimePeriod)" with command "NEW" for record ""
And I set fields
 | nummer   | 22          |
 | such     | JAHR2009A   |
 | namebspr | Jahr 2009 A |
 | zraster  | ZJAHR       |
 | vorgdat  | 1.1.2009    |
 | dauer    | 1           |
And I save the current editor

# Planung anlegen
Given I open an editor "Jahresplanung" from table "(SalesPlanning):(Planning)" with command "NEW" for record ""
And I set fields
 | nummer      | 240                 |
 | such        | JPLANUNG            |
 | namebspr    | Jahresplanung 2009  |
 | basiszraum  | JAHR2007/08         |
 | istzraum    | JAHR2008/09         |
 | planzraum   | JAHR2008/09         |
And I save the current editor

# Hauptplanungseinheit anlegen
Given I open an editor "HauptPlanEinheit" from table "(SalesPlanning):(PlanningUnit)" with command "NEW" for record ""
And I set fields
 | nummer      | 241                   |
 | such        | JHPLAN2009            |
 | name        | Jahresplanungseinheit |
 | planung     | JPLANUNG              |
 | artber      | JTEST                 |
 | progtyp     | Mittelwert            |
 | zyklus      | 1                     |
 | zeiteinheit | Jahr                  |
 | zuwachsfakt | 20                    |
 | rundung     | 1                     |
And I save the current editor

# Basisdaten erzeugen
Given I open an editor "Jahresplanung" from table "(SalesPlanning):(Planning)" with command "UPDATE" for record "JPLANUNG"
And I press button "basiserz" to open a subeditor for "basiserz2"
And I save the current subeditor to switch back to the parent editor
And I save the current editor

# Basisdaten erfassen
Given I open an editor "basisdaten" from table "(ValueSequence):(ValueSequence)" with command "UPDATE" for search criteria "$,,eplan=JHPLAN2009;typ=Basisdaten;@richtung=rueckwaerts;@maxtreffer=1;@ablageart=lebendig"
And I modify table
  | !row | mge |
  | 1    | 100 |
And I save the current editor

# Plandaten erzeugen
Given I open an editor "Jahresplanung" from table "(SalesPlanning):(Planning)" with command "UPDATE" for record "JPLANUNG"
And I press button "planerz" to open a subeditor for "planerz2"
And I save the current subeditor to switch back to the parent editor
And I save the current editor

# Plandaten pruefen
Given I open an editor "plandaten" from table "(ValueSequence):(ValueSequence)" with command "VIEW" for search criteria "$,,eplan=JHPLAN2009;typ=Plandaten;@richtung=rueckwaerts;@maxtreffer=1;@ablageart=lebendig"
# Basiszeitraum und Planungszeitraum mit passenden Anfangsdatum -> Planwert berechnet
Then field "bmge" has value "120" in row 1
And I close the current editor

# Planungszeitraum in Planung aendern
Given I open an editor "Jahresplanung" from table "(SalesPlanning):(Planning)" with command "UPDATE" for record "JPLANUNG"
# Abweichende Anfangsdatum des Jahrs des Planungszeitraums
And I set field "planzraum" to "JAHR2009A"
And I save the current editor

# Plandaten erzeugen
Given I open an editor "Jahresplanung" from table "(SalesPlanning):(Planning)" with command "UPDATE" for record "JPLANUNG"
And I press button "planerz" to open a subeditor for "planerz2"
And I save the current subeditor to switch back to the parent editor
And I save the current editor

# Plandaten pruefen
Given I open an editor "plandaten" from table "(ValueSequence):(ValueSequence)" with command "VIEW" for search criteria "$,,eplan=JHPLAN2009;typ=Plandaten;@richtung=rueckwaerts;@maxtreffer=1;@ablageart=lebendig"
# Basisdaten sind wegen abweichenden Zeitraster nicht passend zum Jahresraster -> Planwert 0
Then field "bmge" has value "0" in row 1
And I close the current editor

# Prognosezeitraster in Planungseinheit aendern
Given I open an editor "JHPlanunseinheit" from table "(SalesPlanning):(PlanningUnit)" with command "UPDATE" for record "JHPLAN2009"
And I set fields
 | zyklus      | 1      |
 | zeiteinheit | Monat  |
And I save the current editor

# Plandaten erzeugen
Given I open an editor "Jahresplanung" from table "(SalesPlanning):(Planning)" with command "UPDATE" for record "JPLANUNG"
And I press button "planerz" to open a subeditor for "planerz2"
And I save the current subeditor to switch back to the parent editor
And I save the current editor

# Plandaten pruefen
Given I open an editor "plandaten" from table "(ValueSequence):(ValueSequence)" with command "VIEW" for search criteria "$,,eplan=JHPLAN2009;typ=Plandaten;@richtung=rueckwaerts;@maxtreffer=1;@ablageart=lebendig"
# Basisdaten im Monatsraster passend zu Plandaten -> Planwert berechnet
Then field "bmge" has value "120" in row 1
And I close the current editor
