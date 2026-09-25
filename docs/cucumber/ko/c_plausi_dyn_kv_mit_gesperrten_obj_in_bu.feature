# *****************************************************************************
#  Name           : c_plausi_dyn_kv_mit_gesperrten_obj_in_bu.feature   
#  Autor          : sih
#  Verantwortlich : sih
#  Kontrolle      : uo
#  Funktion       : Plausibilisierung von dynamischen Kostenverteilern, die ein gesperrtes Kostenobjekt enthalten, auf Verwendung
#                   in Finanz- und statistischen Buchungen
#                   - bei Neuanlage einer Finanz- und einer stat. Buchung mit einem KV, der ein gesperrtes Objekt enthält
#                   - bei Kopie einer Finanz- und stat. Buchung, die einen KV mit gesperrtem Objetk enthält
#                   - beim Storno einer Finanz- und stat. Buchung, die einen KV mit gesperrtem Objetk enthält
#
# *****************************************************************************
#
@persistent
Feature: dynamischer Kostenverteiler mit gesperrten Objekten in Finanz- und statistischen Buchungen 
Background: 
Given I set the fake date to "20.12.1995"

Scenario: 09
# Kst 1200 erst wieder entsperren
Given I open an editor "ks" from table "(Account):(CostCenter)" with command "UPDATE" for record "1200"
And I set field "sperrkonfigurationneu" to ""
And I save the current editor
And I close the current editor

Scenario: 10 Finanzbuchung erzeugen (Kommando NEU)
Given I open an editor "Buchung10" from table "(Entry):(Entry)" with command "NEW" for record ""
And I set field "such" to "bukv10"
And I set field "budat" to "."
And I create a new row at the end of the table
And I set field "konto" to "50000" in row 1
And I set field "ewsbetr" to "4000" in row 1
#
# Neu in Finanzbuchung 
#
# dyn. KV erzeugen mit gesperrtem Objekt
And I press button "vert" to open a subeditor for "Kostenverteiler" in row 1
And I create a new row at the end of the table
And I set field "kstelle" to "1200" in row 1
And I set field "proz" to "100" in row 1
And I save the current subeditor to switch back to the parent editor
#
And I create a new row at the end of the table
And I set field "konto" to "11400" in row 2
And I respond with answer "ja" to the dialog with id "1941"
And I save the current editor
And I close the current editor

Scenario: 11 Statistische Buchung erzeugen (Kommando NEU)
Given I open an editor "Stat-Buchung11" from table "(Entry):(StatisticalEntry)" with command "NEW" for record ""
And I set field "such" to "bukv11"
And I set field "budat" to "."
And I create a new row at the end of the table
And I set field "konto" to "99800" in row 1
And I set field "sbetrag" to "350" in row 1
#
# Neu in Statistischer Buchung
#
# dyn. KV erzeugen mit gesperrtem Objekt
And I press button "vert" to open a subeditor for "Kostenverteiler" in row 1
And I create a new row at the end of the table
And I set field "kstelle" to "1200" in row 1
And I set field "proz" to "100" in row 1
And I save the current subeditor to switch back to the parent editor
#
And I create a new row at the end of the table
And I set field "konto" to "99900" in row 2
And I set field "kstelle" to "100000" in row 2
And I respond with answer "Ja" to the dialog with id "1941"
And I save the current editor
And I close the current editor

Scenario: 12 Finanzbuchung mit dyn. KV erzeugen (Kommando KOPIE), Objekt im dyn. KV sperren, Finanzbuchung kopieren
Given I open an editor "Buchung12" from table "(Entry):(Entry)" with command "NEW" for record ""
And I set field "such" to "bukv12"
And I set field "budat" to "."
And I create a new row at the end of the table
And I set field "konto" to "50000" in row 1
And I set field "ewsbetr" to "3300" in row 1
#
# dyn. KV erzeugen 
And I press button "vert" to open a subeditor for "Kostenverteiler" in row 1
And I create a new row at the end of the table
And I set field "kstelle" to "1400" in row 1
And I set field "proz" to "100" in row 1
And I save the current subeditor to switch back to the parent editor
#
And I create a new row at the end of the table
And I set field "konto" to "11400" in row 2
And I respond with answer "ja" to the dialog with id "1941"
And I save the current editor
And I close the current editor

# Kst 1400 sperren
Given I open an editor "ks" from table "(Account):(CostCenter)" with command "UPDATE" for record "1400"
And I set field "sperrkonfigurationneu" to "Standard-Kostenstellensperre"
And I set field "sperrgrundneu" to "Gesperrt"
And I save the current editor
And I close the current editor

# Finanzbuchung bukv12 kopieren
Given I open an editor "Buchung13" from table "(Entry):(Entry)" with command "COPY" for record "bukv12"
And I set field "budat" to "."
And I set field "such" to "bukv12-k"
# harte Sperre - Exception
Then saving the current editor throws the exception "3602"
And I close the current editor

# wurde die Finanzbuchung wirklich nicht erzeugt durch Kopieren?
Then opening an editor from table "(Entry):(StatisticalEntry)" with command "VIEW" for search criteria "$,,such=bukv12-k;gjahr=95;monat=12;ursache=manuell;@richtung=rückwärts;@maxtreffer=1" throws the exception "1582"

Scenario: 13 Statistische Buchung mit dyn. KV erzeugen (Kommando KOPIE), Objekt im dyn. KV sperren, Statisische Buchung kopieren
# Kst 1400 erst wieder entsperren
Given I open an editor "ks" from table "(Account):(CostCenter)" with command "UPDATE" for record "1400"
And I set field "sperrkonfigurationneu" to ""
And I save the current editor
And I close the current editor

Given I open an editor "Buchung13" from table "(Entry):(StatisticalEntry)" with command "NEW" for record ""
And I set field "such" to "bukv13"
And I set field "budat" to "."
And I create a new row at the end of the table
And I set field "konto" to "99800" in row 1
And I set field "sbetrag" to "3300" in row 1
#
# dyn. KV erzeugen 
And I press button "vert" to open a subeditor for "Kostenverteiler" in row 1
And I create a new row at the end of the table
And I set field "kstelle" to "1400" in row 1
And I set field "proz" to "100" in row 1
And I save the current subeditor to switch back to the parent editor
#
And I create a new row at the end of the table
And I set field "konto" to "99900" in row 2
And I set field "kstelle" to "100000" in row 2
And I respond with answer "ja" to the dialog with id "1941"
And I save the current editor
And I close the current editor

# Kst 1400 sperren
Given I open an editor "ks" from table "(Account):(CostCenter)" with command "UPDATE" for record "1400"
And I set field "sperrkonfigurationneu" to "Standard-Kostenstellensperre"
And I set field "sperrgrundneu" to "Gesperrt"
And I save the current editor
And I close the current editor

# Statistische Buchung bukv13 kopieren
Given I open an editor "Buchung14" from table "(Entry):(StatisticalEntry)" with command "COPY" for record "bukv13"
And I set field "budat" to "."
And I set field "such" to "bukv13-k"
# harte Sperre - Exception
Then saving the current editor throws the exception "3602"
And I close the current editor

# wurde die statistische Buchung wirklich nicht erzeugt durch Kopieren?
Then opening an editor from table "(Entry):(StatisticalEntry)" with command "VIEW" for search criteria "$,,such=bukv13-k;gjahr=95;monat=12;ursache=manuell;@richtung=rückwärts;@maxtreffer=1" throws the exception "1582"

Scenario: 14 Finanzbuchung mit dyn. KV, der gesperrtes Objekt enthält, stornieren (Kommando STORNO)
# Finanzbuchung bukv12 stornieren
Given I open an editor "Buchung14" from table "(Entry):(Entry)" with command "REVERSAL" for record "bukv12"
And I respond with answer "Ja" to the dialog with id "583"
And I save the current editor
And I close the current editor

Scenario: 15 Statistische Buchung mit dyn. KV, der gesperrtes Objekt enthält, stornieren (Kommando STORNO)
# Statistische Buchung bukv13 stornieren
Given I open an editor "Buchung15" from table "(Entry):(StatisticalEntry)" with command "REVERSAL" for record "bukv13"
And I respond with answer "Ja" to the dialog with id "583"
And I save the current editor
And I close the current editor
