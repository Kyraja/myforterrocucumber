# *****************************************************************************
#  Name           : plausi_kostobj_fibu_aend.feature
#  Autor          : sih
#  Verantwortlich : sih
#  Kontrolle      : uo
#  Funktion       : Plausibilisierung des Änderns des Feldes "Kostenobjekt" in Finanz- und statistischen Buchungen
#                   unter Verwendung von 
#                   
#                   Kostenstellen (mit harter und mit Hinweis-Sperre)
#                   
#                   Kostenträgern (mit harter und mit Hinweis-Sperre) -> Ktr nur ein Testfall
#                  
#                   Stamm-Kostenverteilern, mit
#                       eigener Sperrkonfiguration (hart) ohne gesperrte Kostenobjekte
#                       eigener Sperrkonfiguration (Hinweis) ohne gesperrte Kostenobjekte
#
#                       ohne eigene Sperrkonfiguration, mit hart gesperrten Kostenobjekten
#                       ohne eigene Sperrkonfiguration, mit Hinweis-gesperrten Kostenobjekten
#                       ohne eigene Sperrkonfiguration, mit hart und Hinweis-gesperrten Kostenobjekten
#
#                       eigener Sperrkonfiguration Gesperrt, mit hart gesperrten Kostenobjekten
#                       eigener Sperrkonfiguration Gesperrt, mit Hinweis-gesperrten Kostenobjekten
#                       eigener Sperrkonfiguration Gesperrt, mit hart und Hinweis-gesperrten Kostenobjekten

#                       eigener Sperrkonfiguration Hinweis, mit hart gesperrten Kostenobjekten
#                       eigener Sperrkonfiguration Hinweis, mit Hinweis-gesperrten Kostenobjekten
#                       eigener Sperrkonfiguration Hinweis, mit hart und Hinweis-gesperrten Kostenobjekten
#
#
#                   dynamischen Kostenverteilern, mit Hinweis-gesperrten Kostenobjekten
#
# 
# *****************************************************************************
#
@persistent
Feature:  
Background: 
Given I set the fake date to "20.12.1995"

Scenario Outline: 01 Kostenstellen erzeugen

Given I open an editor "ks-erzeugen" from table "(Account):(CostCenter)" with command "COPY" for record "<objnum>"
And I set field "nummer" to "<nummer>"
And I set field "sperrkonfigurationneu" to "<sperrkonf>"
And I save the current editor
And I close the current editor

Examples:

|objnum|nummer|sperrkonf|
|   101|  110 |         |
|   101|  120G|         |
|   101|  130H|         |


Scenario Outline: 02 Kostenträger erzeugen

Given I open an editor "ks-erzeugen" from table "(Account):(CostObject)" with command "COPY" for record "<objnum>"
And I set field "nummer" to "<nummer>"
And I set field "sperrkonfigurationneu" to "<sperrkonf>"
And I save the current editor
And I close the current editor

Examples:

|objnum   |nummer   |sperrkonf                                    |
|   100000|  101111 |                                             |
|   100000|  101112G|Standard-Kostenträgersperre                  |
|   100000|  101113H|Individuelle Kostenträgersperre, nur Hinweis |


Scenario Outline: 03 Stamm-Kostenverteiler erzeugen 

Given I open an editor "kv-erzeugen" from table "(Account):(CostDistribution)" with command "COPY" for record "<objnum>"
And I set field "nummer" to "<nummer>"
And I set field "such" to "<sw>"
And I set field "sperrkonfigurationneu" to "<sperrkonf>"
And I save the current editor
And I close the current editor

Examples:

|objnum   |nummer   |sw       |sperrkonf                                            |
|   10    |  60     |KV60     |                                                     |
|   10    |  71     |KV71+    |                                                     |
|   10    |  72     |KV72+    |                                                     |
|   10    |  73     |KV73++   |                                                     |
|   10    |  74     |KV74H++  |                                                     |
|   10    |  75     |KV75G++  |                                                     |
|   10    |  76     |KV76G+   |                                                     |
|   10    |  77     |KV77G+   |                                                     |
|   10    |  78     |KV78H+   |                                                     |
|   10    |  79     |KV79H+   |                                                     |
|   10    |  61G    |KV61G    |Standard-Stammkostenverteilersperre                  |
|   10    |  62H    |KV62H    |Individuelle Stammkostenverteilersperre, nur Hinweis |


Scenario: 04 Stamm-Kostenverteiler ändern
Given I open an editor "KV71+" from table "(Account):(CostDistribution)" with command "UPDATE" for record "KV71+"
And I set field "namebspr" to "ohne eigene Sperre, mit hart gesperrten Kostenobjekten"
And I set field "kstelle" to "120G" in row 1
And I save the current editor
And I close the current editor
#
Given I open an editor "KV72+" from table "(Account):(CostDistribution)" with command "UPDATE" for record "KV72+"
And I set field "namebspr" to "ohne eigene Sperre, mit Hinweis-gesperrten Kostenobjekten"
And I set field "kstelle" to "130H" in row 1
And I save the current editor
And I close the current editor
#
Given I open an editor "KV73++" from table "(Account):(CostDistribution)" with command "UPDATE" for record "KV73++"
And I set field "namebspr" to "ohne eigene Sperre, mit hart und Hinweis-gesperrten Kostenobjekten"
And I set field "kstelle" to "130H" in row 1
And I set field "kstelle" to "120G" in row 2
And I save the current editor
And I close the current editor
#
Given I open an editor "KV74H++" from table "(Account):(CostDistribution)" with command "UPDATE" for record "KV74H++"
And I set field "namebspr" to "mit eigener Hinweis-Sperre und mit hart und Hinweis-gesperrten Kostenobjekten"
And I set field "sperrkonfigurationneu" to "Individuelle Stammkostenverteilersperre, nur Hinweis"
And I set field "kstelle" to "130H" in row 1
And I set field "kstelle" to "120G" in row 2
And I save the current editor
And I close the current editor
#
Given I open an editor "KV75G++" from table "(Account):(CostDistribution)" with command "UPDATE" for record "KV75G++"
And I set field "namebspr" to "mit eigener harter Sperre und mit hart und Hinweis-gesperrten Kostenobjekten"
And I set field "sperrkonfigurationneu" to "Standard-Stammkostenverteilersperre"
And I set field "kstelle" to "130H" in row 1
And I set field "kstelle" to "120G" in row 2
And I save the current editor
And I close the current editor
#
Given I open an editor "KV76G+" from table "(Account):(CostDistribution)" with command "UPDATE" for record "KV76G+"
And I set field "namebspr" to "mit eigener harter Sperre und mit Gesperrten Kostenobjekten"
And I set field "sperrkonfigurationneu" to "Standard-Stammkostenverteilersperre"
And I set field "kstelle" to "120G" in row 1
And I save the current editor
And I close the current editor
# #
Given I open an editor "KV77G+" from table "(Account):(CostDistribution)" with command "UPDATE" for record "KV77G+"
And I set field "namebspr" to "mit eigener harter Sperre und mit Hinweis-Gesperrten Kostenobjekten"
And I set field "sperrkonfigurationneu" to "Standard-Stammkostenverteilersperre"
And I set field "kstelle" to "130H" in row 1
And I save the current editor
And I close the current editor

Given I open an editor "KV78H+" from table "(Account):(CostDistribution)" with command "UPDATE" for record "KV78H+"
And I set field "namebspr" to "mit eigener Hinweis Sperre und mit Gesperrten Kostenobjekten"
And I set field "sperrkonfigurationneu" to "Individuelle Stammkostenverteilersperre, nur Hinweis"
And I set field "kstelle" to "120G" in row 1
And I save the current editor
And I close the current editor
#
Given I open an editor "KV79H+" from table "(Account):(CostDistribution)" with command "UPDATE" for record "KV79H+"
And I set field "namebspr" to "mit eigener Hinweis Sperre und mit Hinweis-Gesperrten Kostenobjekten"
And I set field "sperrkonfigurationneu" to "Individuelle Stammkostenverteilersperre, nur Hinweis"
And I set field "kstelle" to "130H" in row 1
And I save the current editor
And I close the current editor
#
Given I open an editor "KV61G" from table "(Account):(CostDistribution)" with command "UPDATE" for record "KV61G"
And I set field "namebspr" to "mit harter Sperre"
And I save the current editor
And I close the current editor
#
Given I open an editor "KV62H" from table "(Account):(CostDistribution)" with command "UPDATE" for record "KV62H"
And I set field "namebspr" to "mit Hinweis-Sperre"
And I save the current editor
And I close the current editor


Scenario Outline: 05 Kostenstellen ändern und Sperre eintragen

Given I open an editor "ks-erzeugen" from table "(Account):(CostCenter)" with command "UPDATE" for record "<objnum>"
And I set field "sperrkonfigurationneu" to "<sperrkonf>"
And I save the current editor
And I close the current editor

Examples:

|objnum |sperrkonf                                     |
|   120G|Standard-Kostenstellensperre                  |
|   130H|Individuelle Kostenstellensperre, nur Hinweis |



Scenario: 06 Finanzbuchung erzeugen 
Given I open an editor "Buchung1" from table "(Entry):(Entry)" with command "NEW" for record ""
And I set field "such" to "bukv1"
And I set field "budat" to "."
And I create a new row at the end of the table
And I set field "konto" to "50000" in row 1
And I set field "ewsbetr" to "4000" in row 1
# Then setting field "kstelle" to "kv10" in row 1 throws the exception "3602"
And I set field "kstelle" to "kv10" in row 1
#
And I create a new row at the end of the table
And I set field "konto" to "50000" in row 2
And I set field "ewsbetr" to "3000" in row 2
And I set field "kstelle" to "kv20" in row 2
#
And I create a new row at the end of the table
And I set field "konto" to "54000" in row 3
And I set field "ewsbetr" to "1000" in row 3
And I set field "kstelle" to "kv10" in row 3
#
And I create a new row at the end of the table
And I set field "konto" to "11400" in row 4
And I respond with answer "ja" to the dialog with id "1941"
And I save the current editor
And I close the current editor

Scenario: 07 Statistische Buchung erzeugen 
Given I open an editor "Buchung1" from table "(Entry):(StatisticalEntry)" with command "NEW" for record ""
And I set field "such" to "stbukv1"
And I set field "budat" to "."
And I create a new row at the end of the table
And I set field "konto" to "99800" in row 1
And I set field "sbetrag" to "300" in row 1
And I set field "kstelle" to "kv10" in row 1
#
And I create a new row at the end of the table
And I set field "konto" to "99800" in row 2
And I set field "sbetrag" to "3000" in row 2
And I set field "kstelle" to "kv20" in row 2
#
And I create a new row at the end of the table
And I set field "konto" to "99800" in row 3
And I set field "sbetrag" to "1000" in row 3
And I set field "kstelle" to "100000" in row 3
#
And I create a new row at the end of the table
And I set field "konto" to "99900" in row 4
And I set field "kstelle" to "101" in row 4
And I respond with answer "ja" to the dialog with id "1941"
And I save the current editor
And I close the current editor

#####################                        Ändern                                                    #####################
##
## Wie verhalten sich der (EAF-) Standard und die KV-Prüffunktion?
#
## Prüfung bei Verwenden der Standard-Sperrkonfiguration:
## Erständerung:      Prüfung bei Feldaustritt greift noch nicht (Skifeld "Sperre deaktivieren" noch auf "true" beim Prüfzeitpunkt der EAF-Sperre).
##                    Maskenprüfung greift (Skifeld "Sperre deaktivieren" auf "false"). 
#                     Das bedeutet, Hinweise gibt es keine und Fehler gibt es bei Maskenprüfungen.
#                
#
## Folgeänderungen, wenn Skifeld "Sperre deaktivieren" auf "false" steht:
#                     Prüfung bei Feldaustritt greift. Maskenprüfung greift. 
#                     Das bedeutet, bei Feldaustritt werden Hinweise und Fehler ausgegeben bei Eintrag von gesperrten Objekten.
#                     Die Prüfung, dass ein Hinweis ausgegeben wird, erfolgt per edp in der testbett-Datei.
# 
## KV-Prüffunktion, die Kostenobjekte des Verteilers auf Speren prüft: 
#  Hinweis kommt nur bei Feld- und nicht bei Maskenprüfung. Bei Feldprüfung kommt sie immer, d.h. bei Erständerung und Folgeänderung.
#
#######################################################################################
#  Übersicht über die im Test verwendeten Objekte und deren Konfiguration beim Ändern:
#######################################################################################
#
#  |  Scenario | Gruppe  | Identnummer   | Art der Standard-Sperrkonfiguration | Tabellenobjekte Art der Sperrkonfiguration | Erständerung | Erständerung  | Folgeänderung
#  |           |         |               |                                     |                                            | Feldaustritt | Maskenprüfung | Feldaustritt
#
#  |    10     |  5:2    | 120G          | Gesperrt                            |               -                            | kein Fehler  | Fehler        | Fehler
#  |    11     |  5:2    | 130H          | Hinweis                             |               -                            | kein Hinweis | kein Hinweis  | Hinweis
#  |    12     |  5:8    | 61G           | Gesperrt                            |               -                            | kein Fehler  | Fehler        | Fehler
#  |    13     |  5:8    | 62H           | Hinweis                             |               -                            | kein Hinweis | kein Hinweis  | Hinweis
#  |    14a    |  5:8    | 75            | Gesperrt                            |  Gesperrt und Hinweis                      | Fehler       -> keine Veränderung mehr
#  |    14b    |  5:8    | 76            | Gesperrt                            |  Gesperrt                                  | Fehler
#  |    14c    |  5:8    | 77            | Gesperrt                            |  Hinweis                                   | Hinweis
#  |    15a    |  5:8    | 71            | -                                   |  Gesperrt                                  | Fehler
#  |    15b    |  5:8    | 72            | -                                   |  Hinweis                                   | Hinweis
#  |    15c    |  5:8    | 73            | -                                   |  Gesperrt und Hinweis                      | Fehler
#  |    16c    |  5:8    | 74            | Hinweis                             |  Gesperrt und Hinweis                      | Fehler
#  |    16a    |  5:8    | 78            | Hinweis                             |  Gesperrt                                  | Fehler
#  |    16b    |  5:8    | 79            | Hinweis                             |  Hinweis                                   | Hinweis
#  | s. Komm.  |  5:9    | *             | -                                   |  Hinweis                               |        
#
#
# Kommentar zu 5:9 (dynamischer Kostenverteiler): Verwenden von Hinweis-Gesperrten Objekten
##   aus Stamm-Kostenverteiler dynamischen Kostenverteiler erzeugen, Hinweis-gesperrtes Objekt verwenden
##   Kostenobjekt in Buchungszeule entfernen und dynamischen Kostenverteiler erzeugen, Gesperrtes Objekt eintragen erzeugt Exception, dann Hinweis-gesperrtes Objekt eintragen
############################################################################################################################



#####################                        Erständerung Finanzbuchung                              #####################
#
# Erständerung: wird das Feld "kstelle" zum ersten mal geändert, greift die Sperre noch nicht bei Feld- sondern erst bei Maskenprüfung
#
############################################################################################################################

############################################################################################################################
# Kostenstelle 120G: Sperrkonfiguration "Gesperrt": --> Fehler
############################################################################################################################
Scenario: 10 Kst (120G) - Sperrkonfiguration "Gesperrt"
Given I open an editor "BuchungAend" from table "(Entry):(Entry)" with command "UPDATE" for record "bukv1"
Then field "kstellesperredeakt" has value "ja" in row 1
And I set field "kstelle" to "120G" in row 1
Then field "kstellesperredeakt" has value "nein" in row 1
# Gesperrte Kst - Fehler
Then saving the current editor throws the exception "4806"
And I close the current editor

############################################################################################################################
# Kostenstelle 130H: Sperrkonfiguration "Hinweis": --> Hinweis
############################################################################################################################
Scenario: 11 Kst (130H) - Sperrkonfiguration "Hinweis"
Given I open an editor "BuchungAend" from table "(Entry):(Entry)" with command "UPDATE" for record "bukv1"
Then field "kstellesperredeakt" has value "ja" in row 1
And I set field "kstelle" to "130H" in row 1
Then field "kstellesperredeakt" has value "nein" in row 1
# Hinweis-gesperrte Kst - bei Standard-Sperrkonfiguration wird kein Hinweis in cucumber ausgegeben!
And I respond with answer "Ja" to the dialog with id "583"
And I save the current editor
And I close the current editor

############################################################################################################################
# Stamm-Kostenverteiler 61G: eigene Sperrkonfiguration "Gesperrt": --> Fehler
############################################################################################################################
Scenario: 12 KV (61G) - Sperrkonfiguration "Gesperrt"
Given I open an editor "BuchungAend" from table "(Entry):(Entry)" with command "UPDATE" for record "bukv1"
Then field "kstellesperredeakt" has value "ja" in row 1
And I set field "kstelle" to "61G" in row 1
Then field "kstellesperredeakt" has value "nein" in row 1
# Gesperrte Kst - Fehler
Then saving the current editor throws the exception "4806"
And I close the current editor

############################################################################################################################
# Stamm-Kostenverteiler 62H: eigene Sperrkonfiguration "Hinweis": --> kein Hinweis in cucumber
############################################################################################################################
Scenario: 13 KV (62H) - Sperrkonfiguration "Hinweis"
Given I open an editor "BuchungAend" from table "(Entry):(Entry)" with command "UPDATE" for record "bukv1"
Then field "kstellesperredeakt" has value "ja" in row 1
And I set field "kstelle" to "62H" in row 1
Then field "kstellesperredeakt" has value "nein" in row 1
# Hinweis-gesperrte Kst - bei Standard-Sperrkonfiguration wird in cucumber kein Hinweis ausgegeben!
And I respond with answer "Ja" to the dialog with id "583"
And I save the current editor
And I close the current editor


############################################################################################################################
# Stamm-Kostenverteiler: eigene Sperrkonfiguration "Gesperrt"
#                               und Gesperrte und Hinweis-Gesperrte Objekte: --> Fehler (KV 75)
#                               und Gesperrte Objekte: -->  Fehler (KV 76)
#                               und Hinweis-Gesperrte Objekte: --> Hinweis (KV 77)
############################################################################################################################

Scenario: 14a KV (75) - Sperrkonfiguration "Gesperrt" und Gesperrte und Hinweis-Gesperrte Objekte
Given I open an editor "BuchungAend" from table "(Entry):(Entry)" with command "UPDATE" for record "bukv1"
Then field "kstellesperredeakt" has value "ja" in row 1
Then setting field "kstelle" to "75" in row 1 throws the exception "3602"
Then field "kstellesperredeakt" has value "ja" in row 1
And I close the current editor

Scenario: 14b KV (76) - Sperrkonfiguration "Gesperrt" und Gesperrte Objekte
Given I open an editor "BuchungAend" from table "(Entry):(Entry)" with command "UPDATE" for record "bukv1"
Then field "kstellesperredeakt" has value "ja" in row 1
Then setting field "kstelle" to "76" in row 1 throws the exception "3602"
Then field "kstellesperredeakt" has value "ja" in row 1
And I close the current editor

Scenario: 14c KV (77) - Sperrkonfiguration "Gesperrt" und Hinweis-Gesperrte Objekte
Given I open an editor "BuchungAend" from table "(Entry):(Entry)" with command "UPDATE" for record "bukv1"
Then field "kstellesperredeakt" has value "ja" in row 1
And I set field "kstelle" to "77" in row 1
Then message "Kostenverteiler enthält gesperrte Objekte." was displayed
Then field "kstellesperredeakt" has value "nein" in row 1
Then saving the current editor throws the exception "4806"
And I close the current editor


############################################################################################################################
# Stamm-Kostenverteiler: keine eigene Sperrkonfiguration
#                                     und Gesperrte Objekte: --> Fehler (KV 71)
#                                     und Hinweis-Gesperrte Objekte: -->  Hinweis (KV 72)
#                                     und Gesperrte und Hinweis-Gesperrte Objekte: --> Fehler (KV 73)
############################################################################################################################

Scenario: 15a KV (71) - keine eigene Sperrkonfiguration, aber Gesperrte Objekte
Given I open an editor "BuchungAend" from table "(Entry):(Entry)" with command "UPDATE" for record "bukv1"
Then field "kstellesperredeakt" has value "ja" in row 1
Then setting field "kstelle" to "71" in row 1 throws the exception "3602"
Then field "kstellesperredeakt" has value "ja" in row 1
And I close the current editor

Scenario: 15b KV (72) - keine eigene Sperrkonfiguration, aber Hinweis-gesperrte Objekte enthalten
Given I open an editor "BuchungAend" from table "(Entry):(Entry)" with command "UPDATE" for record "bukv1"
Then field "kstellesperredeakt" has value "ja" in row 1
And I set field "kstelle" to "72" in row 1
Then message "Kostenverteiler enthält gesperrte Objekte." was displayed
Then field "kstellesperredeakt" has value "nein" in row 1
And I respond with answer "Ja" to the dialog with id "583"
And I save the current editor
And I close the current editor

Scenario: 15c KV (73) - keine eigene Sperrkonfiguration, aber Gesperrte und Hinweis-Gesperrte Objekte enthalten
Given I open an editor "BuchungAend" from table "(Entry):(Entry)" with command "UPDATE" for record "bukv1"
Then field "kstellesperredeakt" has value "ja" in row 1
Then setting field "kstelle" to "73" in row 1 throws the exception "3602"
Then field "kstellesperredeakt" has value "ja" in row 1
And I close the current editor

############################################################################################################################
# Stamm-Kostenverteiler: eigene Sperrkonfiguration "Hinweis" 
#                               und Gesperrte Objekte: --> Fehler (KV 78)
#                               und Hinweis-Gesperrte Objekte: -->  Hinweis (KV 79)
#                               und Gesperrte und Hinweis-Gesperrte Objekte: --> Fehler (KV 74)
############################################################################################################################

Scenario: 16a KV (KV 78) - eigene Sperrkonfiguration "Hinweis" und Gesperrte Objekte enthalten
Given I open an editor "BuchungAend" from table "(Entry):(Entry)" with command "UPDATE" for record "bukv1"
Then field "kstellesperredeakt" has value "ja" in row 1
Then setting field "kstelle" to "78" in row 1 throws the exception "3602"
Then field "kstellesperredeakt" has value "ja" in row 1
And I close the current editor

Scenario: 16b KV (KV 79) - eigene Sperrkonfiguration "Hinweis" und Hinweis-Gesperrte Objekte enthalten
Given I open an editor "BuchungAend" from table "(Entry):(Entry)" with command "UPDATE" for record "bukv1"
Then field "kstellesperredeakt" has value "ja" in row 1
And I set field "kstelle" to "79" in row 1 
Then message "Kostenverteiler enthält gesperrte Objekte." was displayed
Then field "kstellesperredeakt" has value "nein" in row 1
And I respond with answer "Ja" to the dialog with id "583"
And I save the current editor
And I close the current editor

Scenario: 16c KV (KV 74) - eigene Sperrkonfiguration "Hinweis" und Gesperrte und Hinweis-Gesperrte Objekte enthalten
Given I open an editor "BuchungAend" from table "(Entry):(Entry)" with command "UPDATE" for record "bukv1"
Then field "kstellesperredeakt" has value "ja" in row 1
Then setting field "kstelle" to "74" in row 1 throws the exception "3602"
Then field "kstellesperredeakt" has value "ja" in row 1
And I close the current editor

############################################################################################################################
# dynamischer Kostenverteiler
############################################################################################################################
Scenario: 17a KV - aus Stamm-Kostenverteiler dynamischen Kostenverteiler erzeugen 
Given I open an editor "BuchungAend" from table "(Entry):(Entry)" with command "UPDATE" for record "bukv1"
Then field "kstellesperredeakt" has value "ja" in row 1
#
And I press button "vert" to open a subeditor for "Kostenverteiler" in row 2
And I set field "kstelle" to "130H" in row 1
And I save the current subeditor to switch back to the parent editor
#
Then field "kstellesperredeakt" has value "ja" in row 1
And I respond with answer "Ja" to the dialog with id "583"
And I save the current editor
And I close the current editor

Scenario: 17b - Kostenobjekt entfernen und dynamischen Kostenverteiler erzeugen
Given I open an editor "BuchungAend" from table "(Entry):(Entry)" with command "UPDATE" for record "bukv1"
Then field "kstellesperredeakt" has value "ja" in row 1
And I set field "kstelle" to " " in row 1
#
And I press button "vert" to open a subeditor for "Kostenverteiler" in row 1
And I create a new row at the end of the table
Then setting field "kstelle" to "120G" in row 1 throws the exception "4806"
And I set field "kstelle" to "130H" in row 1
And I set field "proz" to "100" in row 1
And I save the current subeditor to switch back to the parent editor
#
Then field "kstellesperredeakt" has value "nein" in row 1
And I respond with answer "ja" to the dialog with id "583"
And I save the current editor
And I close the current editor





#####################                        Folgeänderung Finanzbuchung                              #####################
#
# Folgeänderungen nach Erständerung: wird das Feld "kstelle" geändert, greift die Sperre bei der Feldprüfung 
#
############################################################################################################################

############################################################################################################################
# Kostenstelle 120G: Sperrkonfiguration "Gesperrt": --> Fehler
############################################################################################################################
Scenario: 20 Kst (120G) - Sperrkonfiguration "Gesperrt"
Given I open an editor "BuchungAend" from table "(Entry):(Entry)" with command "UPDATE" for record "bukv1"
Then field "kstellesperredeakt" has value "ja" in row 3
And I set field "kstelle" to "120G" in row 3
Then field "kstellesperredeakt" has value "nein" in row 3
Then setting field "kstelle" to "120G" in row 3 throws the exception "4806"
Then saving the current editor throws the exception "4806"
And I close the current editor

############################################################################################################################
# Kostenstelle 130H: Sperrkonfiguration "Hinweis": --> Hinweis: 2 mal Kst eintragen, um Hinweis zu provozieren, erfolgt per edp 
############################################################################################################################

############################################################################################################################
# Stamm-Kostenverteiler 61G: eigene Sperrkonfiguration "Gesperrt": --> Fehler
############################################################################################################################
Scenario: 21 KV (61G) - Sperrkonfiguration "Gesperrt"
Given I open an editor "BuchungAend" from table "(Entry):(Entry)" with command "UPDATE" for record "bukv1"
Then field "kstellesperredeakt" has value "ja" in row 3
And I set field "kstelle" to "61G" in row 3
Then field "kstellesperredeakt" has value "nein" in row 3
Then setting field "kstelle" to "61G" in row 3 throws the exception "4806"
Then saving the current editor throws the exception "4806"
And I close the current editor

############################################################################################################################
# Stamm-Kostenverteiler 62H: eigene Sperrkonfiguration "Hinweis": 2 mal KV eintragen, um Hinweis zu provozieren, erfolgt per edp
############################################################################################################################

############################################################################################################################
# Stamm-Kostenverteiler: eigene Sperrkonfiguration "Gesperrt"
#                               und Gesperrte und Hinweis-Gesperrte Objekte: --> Fehler (KV 75)
#                               und Gesperrte Objekte: -->  Fehler (KV 76)
#                               und Hinweis-Gesperrte Objekte: --> Hinweis (KV 77)
# kein Unterschied zur Erständerung!
############################################################################################################################

Scenario: 22a KV (75) - Sperrkonfiguration "Gesperrt" und Gesperrte und Hinweis-Gesperrte Objekte
Given I open an editor "BuchungAend" from table "(Entry):(Entry)" with command "UPDATE" for record "bukv1"
Then field "kstellesperredeakt" has value "ja" in row 3
Then setting field "kstelle" to "75" in row 3 throws the exception "3602"
Then field "kstellesperredeakt" has value "ja" in row 3
And I close the current editor

Scenario: 22b KV (76) - Sperrkonfiguration "Gesperrt" und Gesperrte Objekte
Given I open an editor "BuchungAend" from table "(Entry):(Entry)" with command "UPDATE" for record "bukv1"
Then field "kstellesperredeakt" has value "ja" in row 3
Then setting field "kstelle" to "76" in row 3 throws the exception "3602"
Then field "kstellesperredeakt" has value "ja" in row 3
And I close the current editor

Scenario: 22c KV (77) - Sperrkonfiguration "Gesperrt" und Hinweis-Gesperrte Objekte
Given I open an editor "BuchungAend" from table "(Entry):(Entry)" with command "UPDATE" for record "bukv1"
Then field "kstellesperredeakt" has value "ja" in row 3
And I set field "kstelle" to "77" in row 3
Then message "Kostenverteiler enthält gesperrte Objekte." was displayed
Then field "kstellesperredeakt" has value "nein" in row 3
Then saving the current editor throws the exception "4806"
And I close the current editor

############################################################################################################################
# Stamm-Kostenverteiler: keine eigene Sperrkonfiguration
#                                     und Gesperrte Objekte: --> Fehler (KV 71)
#                                     und Hinweis-Gesperrte Objekte: -->  Hinweis (KV 72)
#                                     und Gesperrte und Hinweis-Gesperrte Objekte: --> Fehler (KV 73)
# kein Unterschied zur Erständerung!
############################################################################################################################

Scenario: 23a KV (71) - keine eigene Sperrkonfiguration, aber Gesperrte Objekte
Given I open an editor "BuchungAend" from table "(Entry):(Entry)" with command "UPDATE" for record "bukv1"
Then field "kstellesperredeakt" has value "ja" in row 3
Then setting field "kstelle" to "71" in row 3 throws the exception "3602"
Then field "kstellesperredeakt" has value "ja" in row 3
And I close the current editor

Scenario: 23b KV (72) - keine eigene Sperrkonfiguration, aber Hinweis-gesperrte Objekte enthalten
Given I open an editor "BuchungAend" from table "(Entry):(Entry)" with command "UPDATE" for record "bukv1"
Then field "kstellesperredeakt" has value "ja" in row 3
And I set field "kstelle" to "72" in row 3
Then message "Kostenverteiler enthält gesperrte Objekte." was displayed
Then field "kstellesperredeakt" has value "nein" in row 3
And I respond with answer "Ja" to the dialog with id "583"
And I save the current editor
And I close the current editor

Scenario: 23c KV (73) - keine eigene Sperrkonfiguration, aber Gesperrte und Hinweis-Gesperrte Objekte enthalten
Given I open an editor "BuchungAend" from table "(Entry):(Entry)" with command "UPDATE" for record "bukv1"
Then field "kstellesperredeakt" has value "ja" in row 3
Then setting field "kstelle" to "73" in row 3 throws the exception "3602"
Then field "kstellesperredeakt" has value "ja" in row 3
And I close the current editor

############################################################################################################################
# Stamm-Kostenverteiler: eigene Sperrkonfiguration "Hinweis" 
#                               und Gesperrte Objekte: --> Fehler (KV 78)
#                               und Hinweis-Gesperrte Objekte: -->  Hinweis (KV 79)
#                               und Gesperrte und Hinweis-Gesperrte Objekte: --> Fehler (KV 74)
# kein Unterschied zur Erständerung!
############################################################################################################################

Scenario: 24a KV (KV 78) - eigene Sperrkonfiguration "Hinweis" und Gesperrte Objekte enthalten
Given I open an editor "BuchungAend" from table "(Entry):(Entry)" with command "UPDATE" for record "bukv1"
Then field "kstellesperredeakt" has value "ja" in row 3
Then setting field "kstelle" to "78" in row 3 throws the exception "3602"
Then field "kstellesperredeakt" has value "ja" in row 3
And I close the current editor

Scenario: 24b KV (KV 79) - eigene Sperrkonfiguration "Hinweis" und Hinweis-Gesperrte Objekte enthalten
Given I open an editor "BuchungAend" from table "(Entry):(Entry)" with command "UPDATE" for record "bukv1"
Then field "kstellesperredeakt" has value "ja" in row 3
And I set field "kstelle" to "79" in row 3 
Then message "Kostenverteiler enthält gesperrte Objekte." was displayed
Then field "kstellesperredeakt" has value "nein" in row 3
And I close the current editor

Scenario: 24c KV (KV 74) - eigene Sperrkonfiguration "Hinweis" und Gesperrte und Hinweis-Gesperrte Objekte enthalten
Given I open an editor "BuchungAend" from table "(Entry):(Entry)" with command "UPDATE" for record "bukv1"
Then field "kstellesperredeakt" has value "ja" in row 3
Then setting field "kstelle" to "74" in row 3 throws the exception "3602"
Then field "kstellesperredeakt" has value "ja" in row 3
And I close the current editor


############################################################################################################################
# Kostenträger 101112G: Sperrkonfiguration "Gesperrt": --> Fehler
# Kostenträger 101113H: Serrkonfiguration "Hinweis"
############################################################################################################################
Scenario: 11 Kst (130H) - Sperrkonfiguration "Hinweis"
Given I open an editor "BuchungAend" from table "(Entry):(StatisticalEntry)" with command "UPDATE" for record "stbukv1"
Then field "kstellesperredeakt" has value "ja" in row 1
And I set field "kstelle" to "101112G" in row 1
Then field "kstellesperredeakt" has value "nein" in row 1
Then setting field "kstelle" to "101112G" in row 1 throws the exception "4806"
Then I set field "kstelle" to "101113H" in row 1
And I respond with answer "Ja" to the dialog with id "583"
And I save the current editor
And I close the current editor


