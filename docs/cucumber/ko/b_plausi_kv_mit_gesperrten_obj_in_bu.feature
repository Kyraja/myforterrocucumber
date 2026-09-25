# *****************************************************************************
#  Name           : b_plausi_kv_mit_gesperrten_obj_in_bu.feature
#  Autor          : sih
#  Verantwortlich : sih
#  Kontrolle      : uo
#  Funktion       : Plausibilisierung von Stamm-Kostenverteilern, die ein gesperrtes Kostenobjekt enthalten, auf Verwendung
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


Scenario: 02 Sperrkonfiguration in Kst und Ktr eintragen
Given I open an editor "ks" from table "(Account):(CostCenter)" with command "UPDATE" for record "1200"
And I set field "sperrkonfigurationneu" to "Standard-Kostenstellensperre"
And I set field "sperrgrundneu" to "gesperrt"
And I save the current editor
And I close the current editor

Given I open an editor "kt" from table "(Account):(CostObject)" with command "UPDATE" for record "100020"
And I set field "sperrkonfigurationneu" to "Standard-Kostentraegersperre"
And I set field "sperrgrundneu" to "gesperrt"
And I save the current editor
And I close the current editor

Scenario: 03 Finanzbuchung erzeugen (Kommando NEU)
Given I open an editor "Buchung1" from table "(Entry):(Entry)" with command "NEW" for record ""
And I set field "such" to "bukv1"
And I set field "budat" to "."
And I create a new row at the end of the table
And I set field "konto" to "50000" in row 1
And I set field "ewsbetr" to "4000" in row 1
# Neu in Finanzbuchung
# harte Sperre - Exception
Then setting field "kstelle" to "kv10" in row 1 throws the exception "3602"
And I set field "kstelle" to "kv30" in row 1
# testweise Einbau von "was not displayed"
Then message "Kostenverteiler enthält gesperrte Objekte." was not displayed
#
And I create a new row at the end of the table
And I set field "konto" to "11400" in row 2
And I respond with answer "ja" to the dialog with id "1941"
And I save the current editor
And I close the current editor

Scenario: 04 Statistische Buchung erzeugen (Kommando NEU)
Given I open an editor "Buchung2" from table "(Entry):(StatisticalEntry)" with command "NEW" for record ""
And I set field "such" to "bukv2"
And I set field "budat" to "."
And I create a new row at the end of the table
And I set field "konto" to "99800" in row 1
And I set field "sbetrag" to "1000" in row 1
# Neu in Statistischer Buchung
# harte Sperre - Exception
Then setting field "kstelle" to "kv20" in row 1 throws the exception "3602"
And I set field "kstelle" to "kv30" in row 1
#
And I create a new row at the end of the table
And I set field "konto" to "99900" in row 2
And I set field "kstelle" to "100000" in row 2
And I respond with answer "Ja" to the dialog with id "1941"
And I save the current editor
And I close the current editor

Scenario: 05 Sperre eines Objekts aus KV30
#            Finanzbuchung, die KV 30 enthält, kopieren (Kommando COPY)
Given I open an editor "ks" from table "(Account):(CostCenter)" with command "UPDATE" for record "1100"
And I set field "sperrkonfigurationneu" to "Standard-Kostenstellensperre"
And I set field "sperrgrundneu" to "gesperrt"
And I save the current editor
And I close the current editor

Given I open an editor "Buchung3" from table "(Entry):(Entry)" with command "COPY" for record "bukv1"
And I set field "budat" to "."
And I set field "such" to "bukv1-k"
# harte Sperre - Exception
Then saving the current editor throws the exception "3602"
And I close the current editor

# wurde die Finanzbuchung wirklich nicht erzeugt durch Kopieren?
Then opening an editor from table "(Entry):(Entry)" with command "VIEW" for search criteria "$,,such=bukv1-k;gjahr=95;monat=12;ursache=manuell;@richtung=rückwärts;@maxtreffer=1" throws the exception "1582"

#            Statistische Buchung, die KV 30 enthält, kopieren (Kommando COPY)
Given I open an editor "Buchung4" from table "(Entry):(StatisticalEntry)" with command "COPY" for record "bukv2"
And I set field "budat" to "."
And I set field "such" to "bukv2-k"
# harte Sperre - Exception
Then saving the current editor throws the exception "3602"
And I close the current editor

# wurde die statistische Buchung wirklich nicht erzeugt durch Kopieren?
Then opening an editor from table "(Entry):(StatisticalEntry)" with command "VIEW" for search criteria "$,,such=bukv2-k;gjahr=95;monat=12;ursache=manuell;@richtung=rückwärts;@maxtreffer=1" throws the exception "1582"

Scenario: 06 Finanzbuchung mit KV, der gesperrtes Objekt enthält, stornieren (Kommando STORNO)
# Finanzbuchung bukv1 stornieren
Given I open an editor "Buchung5" from table "(Entry):(Entry)" with command "REVERSAL" for record "bukv1"
And I respond with answer "Ja" to the dialog with id "583"
And I save the current editor
And I close the current editor

Scenario: 07 Statistische Buchung mit KV, der gesperrtes Objekt enthält, stornieren (Kommando STORNO)
# Statistische Buchung bukv2 stornieren
Given I open an editor "Buchung6" from table "(Entry):(StatisticalEntry)" with command "REVERSAL" for record "bukv2"
And I respond with answer "Ja" to the dialog with id "583"
And I save the current editor
And I close the current editor
