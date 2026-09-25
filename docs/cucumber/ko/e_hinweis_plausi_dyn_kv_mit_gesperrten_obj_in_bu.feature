# *****************************************************************************
#  Name           : e_hinweis_plausi_dyn_kv_mit_gesperrten_obj_in_bu.feature
#  Autor          : sih
#  Verantwortlich : sih
#  Kontrolle      : uo
#  Funktion       : Plausibilisierung von dynamischen Kostenverteilern, die ein Hinweis-gesperrtes Kostenobjekt enthalten, auf Verwendung
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

Scenario: 30 Finanzbuchung erzeugen (Kommando NEU)
Given I open an editor "Buchung30" from table "(Entry):(Entry)" with command "NEW" for record ""
And I set field "such" to "bukv30"
And I set field "budat" to "."
And I create a new row at the end of the table
And I set field "konto" to "50000" in row 1
And I set field "ewsbetr" to "4000" in row 1
#
# Neu in Finanzbuchung 
#
# dyn. KV erzeugen mit Hinweis-gesperrtem Objekt
And I press button "vert" to open a subeditor for "Kostenverteiler" in row 1
And I create a new row at the end of the table
And I set field "kstelle" to "1200" in row 1
# testweise Einbau von "was not displayed" - ergibt keinen Fehler, ist aber überflüssig/unsinnig und wäre nur bei KV mit hinweis-gesperrtem Inhalt abfragbar im positiven Sinn ("was displayed")
Then message "Kostenverteiler enthält gesperrte Objekte." was not displayed
And I set field "proz" to "100" in row 1
And I save the current subeditor to switch back to the parent editor
#
And I create a new row at the end of the table
And I set field "konto" to "11400" in row 2
And I respond with answer "ja" to the dialog with id "1941"
And I save the current editor
And I close the current editor


Scenario: 31 Statistische Buchung erzeugen (Kommando NEU)
Given I open an editor "Stat-Buchung31" from table "(Entry):(StatisticalEntry)" with command "NEW" for record ""
And I set field "such" to "bukv31"
And I set field "budat" to "."
And I create a new row at the end of the table
And I set field "konto" to "99800" in row 1
And I set field "sbetrag" to "350" in row 1
#
# Neu in Statistischer Buchung
#
# dyn. KV erzeugen mit Hinweis-gesperrtem Objekt
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
And I close the current editor

Scenario: 32 Finanzbuchung mit dyn. KV erzeugen (Kommando KOPIE), Objekt im dyn. KV sperren, Finanzbuchung kopieren
# Kst 1400 erst wieder entsperren
Given I open an editor "ks" from table "(Account):(CostCenter)" with command "UPDATE" for record "1400"
And I set field "sperrkonfigurationneu" to ""
And I save the current editor
And I close the current editor

Given I open an editor "Buchung32" from table "(Entry):(Entry)" with command "NEW" for record ""
And I set field "such" to "bukv32"
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
And I set field "sperrkonfigurationneu" to "Individuelle Kostenstellensperre, nur Hinweis"
And I set field "sperrgrundneu" to "Hinweis"
And I save the current editor
And I close the current editor

# Finanzbuchung bukv32 kopieren
Given I open an editor "Buchung13" from table "(Entry):(Entry)" with command "COPY" for record "bukv32"
And I set field "budat" to "."
And I set field "such" to "bukv32-k"
And I respond with answer "Ja" to the dialog with id "583"
And I save the current editor
And I close the current editor

# wurde die Finanzbuchung wirklich nicht erzeugt durch Kopieren?
Given I open an editor "buchung" from table "(Entry):(Entry)" with command "VIEW" for search criteria "$,,such=bukv32-k;gjahr=95;monat=12;ursache=manuell;@richtung=rückwärts;@maxtreffer=1"
Then field "konto" has value "50000" in row 1

Scenario: 33 Statistische Buchung mit dyn. KV erzeugen (Kommando KOPIE), Objekt im dyn. KV sperren, Statisische Buchung kopieren
Given I open an editor "Buchung33" from table "(Entry):(StatisticalEntry)" with command "NEW" for record ""
And I set field "such" to "bukv33"
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

# Statistische Buchung bukv33 kopieren
Given I open an editor "Buchung34" from table "(Entry):(StatisticalEntry)" with command "COPY" for record "bukv33"
And I set field "budat" to "."
And I set field "such" to "bukv33-k"
And I respond with answer "Ja" to the dialog with id "583"
And I save the current editor
And I close the current editor

# wurde die statistische Buchung wirklich nicht erzeugt durch Kopieren?
Given I open an editor "statbuchung" from table "(Entry):(StatisticalEntry)" with command "VIEW" for search criteria "$,,such=bukv33-k;gjahr=95;monat=12;ursache=manuell;@richtung=rückwärts;@maxtreffer=1"
Then field "konto" has value "99800" in row 1

Scenario: 34 Finanzbuchung mit dyn. KV, der Hinweis-gesperrtes Objekt enthaelt, stornieren (Kommando STORNO)
# Finanzbuchung bukv32 stornieren
Given I open an editor "Buchung35" from table "(Entry):(Entry)" with command "REVERSAL" for record "bukv32"
And I respond with answer "Ja" to the dialog with id "583"
And I save the current editor
And I close the current editor

Scenario: 35 Statistische Buchung mit dyn. KV, der Hinweis-gesperrtes Objekt enthaelt, stornieren (Kommando STORNO)
# Statistische Buchung bukv33 stornieren
Given I open an editor "Buchung36" from table "(Entry):(StatisticalEntry)" with command "REVERSAL" for record "bukv33"
And I respond with answer "Ja" to the dialog with id "583"
And I save the current editor
And I close the current editor

Scenario: 36 dynamischer KV ohne Kostenobjekt verwenden
Given I open an editor "konto" from table "(Account):(Account)" with command "COPY" for record "44000"
And I set field "nummer" to "44123"
And I save the current editor
And I close the current editor

# VK-LS
Given I open an editor "Lieferschein" from table "(Sales):(PackingSlip)" with command "NEW" for record ""
And I set field "nummer" to "100LS"
And I set field "kunde" to "1"
And I set field "ueb" to "ja"
# Zeile 1
And I create a new row at the end of the table
And I set field "artikel" to "V1" in row 1
And I set field "mge" to "10" in row 1
And I set field "konto" to "44123" in row 1
And I save the current editor
And I close the current editor

# VK-RE
Given I open an editor "Rechnung" from table "(Sales):(Invoice)" with command "NEW" for record ""
And I set field "nummer" to "200RE"
And I set field "kunde" to "1"
And I set field "ueb" to "ja"
And I set field "budat" to "."
And I set field "tterm" to "."
# Zeile 1
And I create a new row at the end of the table
And I set field "artikel" to "V1" in row 1
And I set field "mge" to "20" in row 1
And I set field "konto" to "44123" in row 1
And I set field "kstelle" to "" in row 1
And I press button "dynkst" to open a subeditor for "Kostenverteiler" in row 1
And I append rows
   | proz | kstempf |
   |100   | (154,3) |
And I save the current editor
And I close the current editor
And I switch the current editor to editor "Rechnung"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor
And I close the current editor



