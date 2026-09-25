# *****************************************************************************
#  Name           : d_hinweis_plausi_kv_mit_gesperrten_obj_in_bu.feature
#  Autor          : sih
#  Verantwortlich : sih
#  Kontrolle      : uo
#  Funktion       : Plausibilisierung von Stamm-Kostenverteilern, die ein Hinweis-gesperrtes Kostenobjekt enthalten, auf Verwendung
#                   in Finanz- und statistischen Buchungen
#                   - bei Neuanlage einer Finanz- und einer stat. Buchung mit einem KV, der ein gesperrtes Objekt enthält
#                   - bei Kopie einer Finanz- und stat. Buchung, die einen KV mit gesperrtem Objetk enthält
#                   - beim Storno einer Finanz- und stat. Buchung, die einen KV mit gesperrtem Objetk enthält
#
# *****************************************************************************
#
@persistent
Feature: Stamm-Kostenverteiler mit gesperrten Objekten in Finanz- und statistischen Buchungen 
Background: 
Given I set the fake date to "20.12.1995"

Scenario: 19
# Kst 1100 erst wieder entsperren
Given I open an editor "ks" from table "(Account):(CostCenter)" with command "UPDATE" for record "1100"
And I set field "sperrkonfigurationneu" to ""
And I save the current editor
And I close the current editor

Scenario: 20 Sperrkonfiguration in Kst und Ktr eintragen
Given I open an editor "ks" from table "(Account):(CostCenter)" with command "UPDATE" for record "1200"
And I set field "sperrkonfigurationneu" to "Individuelle Kostenstellensperre, nur Hinweis"
And I set field "sperrgrundneu" to "Hinweis"
And I save the current editor
And I close the current editor

Given I open an editor "kt" from table "(Account):(CostObject)" with command "UPDATE" for record "100020"
And I set field "sperrkonfigurationneu" to "Individuelle Kostenträgersperre, nur Hinweis"
And I set field "sperrgrundneu" to "Hinweis"
And I save the current editor
And I close the current editor

Scenario: 21 Finanzbuchung erzeugen (Kommando NEU)
Given I open an editor "Buchung21" from table "(Entry):(Entry)" with command "NEW" for record ""
And I set field "such" to "bukv21"
And I set field "budat" to "."
And I create a new row at the end of the table
And I set field "konto" to "50000" in row 1
And I set field "ewsbetr" to "4000" in row 1
# Neu in Finanzbuchung
# KV 10 enthält Kst 1200 mit Hinweissperre - KEINE EXCEPTION, nur Hinweis
And I set field "kstelle" to "kv10" in row 1
Then message "Kostenverteiler enthält gesperrte Objekte." was displayed
#
And I create a new row at the end of the table
And I set field "konto" to "11400" in row 2
And I respond with answer "ja" to the dialog with id "1941"
And I save the current editor
And I close the current editor

# Scenario: 22 Statistische Buchung erzeugen (Kommando NEU)
Given I open an editor "Buchung22" from table "(Entry):(StatisticalEntry)" with command "NEW" for record ""
And I set field "such" to "bukv22"
And I set field "budat" to "."
And I create a new row at the end of the table
And I set field "konto" to "99800" in row 1
And I set field "sbetrag" to "1000" in row 1
# Neu in Statistischer Buchung
# KV 20 enthält Kst 1200 mit Hinweissperre - KEINE EXCEPTION, nur Hinweis
And I set field "kstelle" to "kv20" in row 1
Then message "Kostenverteiler enthält gesperrte Objekte." was displayed
#
And I create a new row at the end of the table
And I set field "konto" to "99900" in row 2
And I set field "kstelle" to "100000" in row 2
And I respond with answer "Ja" to the dialog with id "1941"
And I save the current editor
And I close the current editor
 
Scenario: 23  Finanzbuchung bukv21 mit KV10, der Hinweis-gesperrte Objekte enthält, kopieren (Kommando COPY)- KEINE EXCEPTION
Given I open an editor "Buchung23" from table "(Entry):(Entry)" with command "COPY" for record "bukv21"
And I set field "budat" to "."
And I set field "such" to "bukv21-k"
And I respond with answer "Ja" to the dialog with id "583"
And I save the current editor
And I close the current editor

# wurde die Finanzbuchung erzeugt durch Kopieren?
Given I open an editor "Buchung" from table "(Entry):(Entry)" with command "VIEW" for search criteria "$,,such=bukv21-k;gjahr=95;monat=12;ursache=manuell;@richtung=rückwärts;@maxtreffer=1"
Then field "kstelle" has value "10" in row 1

Scenario: 24 Statistische Buchung, die KV 20 enthält (Hinweis-gesperrte Objekte), kopieren (Kommando COPY)- KEINE EXCEPTION
Given I open an editor "Buchung24" from table "(Entry):(StatisticalEntry)" with command "COPY" for record "bukv22"
And I set field "budat" to "."
And I set field "such" to "bukv22-k"
And I respond with answer "Ja" to the dialog with id "583"
And I save the current editor
And I close the current editor
 
# wurde die statistische Buchung erzeugt durch Kopieren?
Given I open an editor "Buchung" from table "(Entry):(StatisticalEntry)" with command "VIEW" for search criteria "$,,such=bukv22-k;gjahr=95;monat=12;ursache=manuell;@richtung=rückwärts;@maxtreffer=1"
Then field "kstelle" has value "20" in row 1

Scenario: 25 Finanzbuchung mit KV, der Hinweis-gesperrtes Objekt enthält, stornieren (Kommando STORNO)
# Finanzbuchung bukv21 stornieren
Given I open an editor "Buchung25" from table "(Entry):(Entry)" with command "REVERSAL" for record "bukv21"
And I respond with answer "Ja" to the dialog with id "583"
And I save the current editor
And I close the current editor
 
Scenario: 26 Statistische Buchung mit KV, der Hinweis-gesperrtes Objekt enthält, stornieren (Kommando STORNO)
# Statistische Buchung bukv22 stornieren
Given I open an editor "Buchung6" from table "(Entry):(StatisticalEntry)" with command "REVERSAL" for record "bukv22"
And I respond with answer "Ja" to the dialog with id "583"
And I save the current editor
And I close the current editor
