# *****************************************************************************
#  Name           : kvert_edit_berechne.feature
#  Autor          : Silvia Warth
#  Verantwortlich : sih
#  Kontrolle      : uo
#  Funktion       : Editieren eines Kostenverteilers, der eine Umlageeinheit besitzt.
#                   Der Test prüft die Berechnung der Prozentwerte in der Tabelle, wenn Kst mit Umlageanteilen eingetragen werden, die der Umlageeinheit
#                   des Kostenverteilers entpsrechen.
#                   Weiterhin dokumentiert der Test das Systemverhalten, dass eine Zeile im Kostenverteiler gelöscht wird, sobald die Kostenstelle geleert wird.
#                   Außerdem dokumentiert er generell die Editiereigenschaften (Feldänderbarkeit, Feldprüf und Feldnachbehandlung) von
#                   statischen und dynamischen Kostenverteilern.
#
# *****************************************************************************
@persistent
Feature: REWE-2447
Background:
Given I set the fake date to "31.12.2002"


Scenario: 01 Anlage von Kostenstellen mit diversen Umlageanteilen, Bebuchen der Kostenstellen
Given I open an editor "ks" from table "(Account):(CostCenter)" with command "NEW" for record ""
And I set field "nummer" to "500"
And I set field "such" to "KS500"
And I set field "namebspr" to "Kostenstelle 500"
And I set field "umlage" to "90 qm"
And I save the current editor

Given I open an editor "ks" from table "(Account):(CostCenter)" with command "NEW" for record ""
And I set field "nummer" to "501"
And I set field "such" to "KS501"
And I set field "namebspr" to "Kostenstelle 501"
And I set field "umlage" to "5 Personen"
And I save the current editor

Given I open an editor "ks" from table "(Account):(CostCenter)" with command "NEW" for record ""
And I set field "nummer" to "502"
And I set field "such" to "KS502"
And I set field "namebspr" to "Kostenstelle 502"
And I set field "umlage" to "8 Personen"
And I save the current editor

Given I open an editor "ks" from table "(Account):(CostCenter)" with command "NEW" for record ""
And I set field "nummer" to "503"
And I set field "such" to "KS503"
And I set field "namebspr" to "Kostenstelle 503"
And I set field "umlage" to "7 Personen"
And I save the current editor

Given I open an editor "ks" from table "(Account):(CostCenter)" with command "NEW" for record ""
And I set field "nummer" to "504"
And I set field "such" to "KS504"
And I set field "namebspr" to "Kostenstelle 504"
And I set field "umlage" to "10 qm"
And I save the current editor

Given I open an editor "BuchungKV_1" from table "(Entry):(Entry)" with command "NEW" for record ""
And I set field "budat" to "31.12.02"
And I set field "beleg" to "kvtest"
And I set field "beldat" to "31.12.02"
And I set field "beleg" to "BUKV_1"
And  I create a new row at the end of the table 
And I set field "konto" to "50000" in row 1 
And I set field "ewsbetr" to "12000" in row 1
And I set field "kstelle" to "501" in row 1
And  I create a new row at the end of the table
And I set field "konto" to "54000" in row 2
And I set field "ewsbetr" to "4000" in row 2
And I set field "kstelle" to "502" in row 2
And  I create a new row at the end of the table
And I set field "konto" to "54000" in row 3
And I set field "ewsbetr" to "200" in row 3
And I set field "kstelle" to "503" in row 3
And  I create a new row at the end of the table
And I set field "konto" to "11400" in row 4
And I respond with answer "ja" to the dialog with id "583" 
And I save the current editor

# Kostenverteiler anlegen mit der Umlageeinheit "Personen"
Scenario: 02 Anlegen Stammkostenverteiler
Given I open an editor "kostenverteiler" from table "(Account):(CostDistribution)" with command "NEW" for record ""
Then field "nummer" is modifiable
Then field "such" is modifiable
Then field "bsum" is modifiable
Then field "ebsum" is modifiable
Then field "piwbu" is not modifiable
Then field "erfwaehr" is not modifiable
Then field "umeinheit" is modifiable
Then field "esum" is not modifiable
Then field "schutz" is not modifiable
Then field "grp" is not modifiable
Then field "prest" is not modifiable
Then field "brest" is not modifiable
Then field "ebrest" is not modifiable
# Währungsfelder sind leer
Then field "piwbu" has value "EUR"
Then field "ewbu" has value ""
# Wertinitialisierungen für Stammkostenverteiler
Then field "bsum" has value "100.00"
Then field "brest" has value "100.00"
Then field "ebsum" has value "100.00"
Then field "ebrest" has value "100.00"
# And I delete all rows
And I set field "nummer" to "550"
And I set field "such" to "KV550"
And I set field "umeinheit" to "Personen"
And I create a new row at the end of the table
Then field "kstelle" is modifiable in row 1
Then field "proz" is modifiable in row 1
Then field "ewbetr" is modifiable in row 1
Then field "betr" is modifiable in row 1
Then field "eanteil" is not modifiable in row 1
Then field "kstempf" is not modifiable in row 1
And I set field "kstelle" to "501" in row 1
# And I set field "proz" to "41" in row 1
And I create a new row at the end of the table
And I set field "kstelle" to "502" in row 2
# And I set field "proz" to "59" in row 2
And I create a new row at the end of the table
And I set field "kstelle" to "503" in row 3
And I save the current editor

Scenario: 03 Kopieren eines Stammkostenverteilers
# Kostenverteiler 550 kopieren
Given I open an editor "kostenverteiler" from table "(Account):(CostDistribution)" with command "NEW" for record "550"
Then field "nummer" is modifiable
Then field "such" is modifiable
Then field "bsum" is modifiable
Then field "ebsum" is modifiable
Then field "piwbu" is not modifiable
Then field "erfwaehr" is not modifiable
Then field "umeinheit" is modifiable
Then field "esum" is not modifiable
Then field "schutz" is not modifiable
Then field "grp" is not modifiable
Then field "prest" is not modifiable
Then field "brest" is not modifiable
Then field "ebrest" is not modifiable
# And I delete all rows
And I set field "nummer" to "551"
And I set field "such" to "KV551"
And I save the current editor


Scenario: 04 Stammkostenverteiler, Kostenstellen entfernen
# Kostenverteiler editieren, Kst aus der Zeile der Tabelle entfernen, dann wird automatisch die komplette Zeile gelöscht
Given I open an editor "kostenverteiler" from table "(Account):(CostDistribution)" with command "UPDATE" for record "550"
Then field "schutz" has value "nein"
And I set field "kstelle" to "" in row 1
Then the table has 2 rows
And I save the current editor
Given I open an editor "kostenverteiler" from table "(Account):(CostDistribution)" with command "UPDATE" for record "550"
And I set field "kstelle" to "" in row 1
And I set field "kstelle" to "" in row 1
Then the table has 0 rows
Then saving the current editor throws the exception "1340"
And I close the current editor

Scenario: 05 dynamischen Kostenverteiler aus Finanzbuchung anlegen
Given I open an editor "BuchungKV_2" from table "(Entry):(Entry)" with command "NEW" for record ""
And I set field "budat" to "31.12.02"
And I set field "beleg" to "BUKV_2"
And I set field "beldat" to "31.12.02"
And I create a new row at the end of the table 
And I set field "konto" to "50000" in row 1 
And I set field "ewsbetr" to "12000" in row 1
And I press button "vert" to open a subeditor for "Kostenverteiler" in row 1
Then field "nummer" is not modifiable
Then field "such" is not modifiable
Then field "bsum" is not modifiable
Then field "ebsum" is not modifiable
Then field "piwbu" is not modifiable
Then field "erfwaehr" is not modifiable
Then field "umeinheit" is modifiable
Then field "esum" is not modifiable
Then field "schutz" is not modifiable
Then field "grp" is not modifiable
Then field "prest" is not modifiable
Then field "brest" is not modifiable
Then field "ebrest" is not modifiable
# Wertinitialisierungen für dynamische Kostenverteiler
Then field "bsum" has value "12000.00"
Then field "brest" has value "12000.00"
Then field "ebsum" has value "12000.00"
Then field "ebrest" has value "12000.00"
And I create a new row at the end of the table
Then field "kstelle" is modifiable in row 1
Then field "proz" is modifiable in row 1
Then field "ewbetr" is modifiable in row 1
Then field "betr" is modifiable in row 1
Then field "eanteil" is not modifiable in row 1
Then field "kstempf" is modifiable in row 1
# 
And I set field "namebspr" to "ref_kvert_ehsum_cu_05_dyn"
#
And I set field "kstelle" to "501" in row 1
And I set field "proz" to "41" in row 1
And I create a new row at the end of the table
And I set field "kstelle" to "502" in row 2
And I set field "proz" to "59" in row 2
And I save the current editor
And I close the current editor
And I switch the current editor to editor "BuchungKV_2"
Then field "konto" is not modifiable in row 1
And I create a new row at the end of the table
And I set field "konto" to "11400" in row 2
And I respond with answer "Ja" to the dialog with id "583" 
And I save the current editor
And I close the current editor

Scenario: 06 Verwendung des statischen Kostenverteilers in einer Finanzbuchung
Given I open an editor "BuchungKV_3" from table "(Entry):(Entry)" with command "NEW" for record ""
And I set field "budat" to "31.12.02"
And I set field "beldat" to "31.12.02"
And I set field "beleg" to "BUKV_3"
And I create a new row at the end of the table 
And I set field "konto" to "50000" in row 1 
And I set field "ewsbetr" to "12000" in row 1
And I set field "kstelle" to "KV551" in row 1
And I create a new row at the end of the table 
And I set field "konto" to "L 1" in row 2 
And I respond with answer "Ja" to the dialog with id "583" 
And I save the current editor
And I close the current editor

Scenario: 07 Editieren eines verwendeten statischen Kostenverteilers (Felder sind nicht mehr aenderbar)
Given I open an editor "kostenverteiler" from table "(Account):(CostDistribution)" with command "UPDATE" for record "551"
Then field "schutz" has value "ja" in row 0
Then field "nummer" is not modifiable
Then field "such" is modifiable
Then field "bsum" is modifiable
Then field "ebsum" is modifiable
Then field "piwbu" is not modifiable
Then field "erfwaehr" is not modifiable
Then field "umeinheit" is not modifiable
Then field "esum" is not modifiable
Then field "schutz" is not modifiable
Then field "grp" is not modifiable
Then field "prest" is not modifiable
Then field "brest" is not modifiable
Then field "ebrest" is not modifiable
Then field "kstelle" is not modifiable in row 1
Then field "proz" is not modifiable in row 1
Then field "ewbetr" is not modifiable in row 1
Then field "betr" is not modifiable in row 1
Then field "eanteil" is not modifiable in row 1
Then field "kstempf" is not modifiable in row 1
Then creating a new row at position 1 throws the exception "419"
And I close the current editor
#

Scenario: 09 VK_Rechnung anlegen mit einer Zeile fuer den Kostenempfaenger
Given I open an editor "Rechnung" from table "(Sales):(Invoice)" with command "NEW" for record ""
And I set field "kunde" to "1"
And I set field "tterm" to "31.12.02"
And I set field "ueb" to "ja"
And I create a new row at the end of the table
And I set field "artex" to "V1" in row 1
And I set field "mge" to "3" in row 1
And I set field "kstelle" to "100" in row 1
And I respond with answer "Ja" to the dialog with id "4841" 
And I save the current editor
And I close the current editor
#
Scenario: 10 Verwendung eines dynamischen Kostenverteilers in einer Finanzbuchung mit Fremdwaehrung und kstempf
Given I open an editor "BuchungKV_4" from table "(Entry):(Entry)" with command "NEW" for record ""
And I set field "beleg" to "BUKV_4"
And I set field "budat" to "31.12.02"
And I set field "beldat" to "31.12.02"
And I set field "ewbu" to "USD"
And I create a new row at the end of the table 
And I set field "konto" to "50000" in row 1 
And I set field "ewsbetr" to "12000" in row 1
And I press button "vert" to open a subeditor for "Kostenverteiler" in row 1
#
And I set field "namebspr" to "ref_kvert_ehsum_cu_10_dyn"
#
And I create a new row at the end of the table
Then field "kstelle" is modifiable in row 1
Then field "proz" is modifiable in row 1
Then field "ewbetr" is modifiable in row 1
Then field "betr" is modifiable in row 1
Then field "kstempf" is modifiable in row 1
And I set field "kstelle" to "501" in row 1
And setting field "proz" to "112" in row 1 throws the exception "131"
And I set field "proz" to "41" in row 1
Then field "ewbetr" has value "4920.00" in row 1
Then field "betr" has value "5529.10" in row 1
And I set field "ewbetr" to "2000.00" in row 1
Then field "betr" has value "2247.60" in row 1
Then field "proz" has value "16.7" in row 1
And I create a new row at the end of the table
And I set field "kstelle" to "502" in row 2
And I set field "proz" to "83,3" in row 2
And I set field "betr" to "5529.10" in row 1
And setting field "kstempf" to "400001" in row 1 throws the exception "1361"
And I set field "kstempf" to "(157,3,0)" in row 1
Then field "ewbetr" has value "4920.00" in row 1
Then field "proz" has value "41" in row 1
Then field "proz" has value "83.3" in row 2
Then field "prest" has value "-24.3" in row 0
Then field "brest" has value "-3277.00" in row 0
Then field "ebrest" has value "-2916.00" in row 0
Then saving the current editor throws the exception "1341"
And I set field "proz" to "59" in row 2
And I save the current editor
And I close the current editor
And I switch the current editor to editor "BuchungKV_4"
And I create a new row at the end of the table
And I set field "konto" to "11400" in row 2
And I respond with answer "Ja" to the dialog with id "583" 
And I save the current editor
And I close the current editor

# Scenario: 11 e Kopieren eines Stamm-Kostenverteilers in Stamm-Kostenverteiler 
Given I open an editor "kostenverteiler" from table "(Account):(CostDistribution)" with command "COPY" for record "551"
And I set field "namebspr" to "ref_kvert_ehsum_cu_11e_stamm"
And I set field "nummer" to "599"
And I set field "such" to "KV599"
And I save the current editor
And I close the current editor

Scenario: 12 statischer Kostenverteiler ohne Eintrag in kstelle => Fehlermeldung
Given I open an editor "kostenverteiler" from table "(Account):(CostDistribution)" with command "NEW" for record ""
And I set field "such" to "KV553"
And I create a new row at the end of the table
And I set field "betr" to "100.00" in row 1
Then saving the current editor throws the exception "279"
And I close the current editor

Scenario: 13 Kostenverteiler mit mehr als 100% Verteilung in den Zeilen anlegen => Fehlermeldung
Given I open an editor "kostenverteiler" from table "(Account):(CostDistribution)" with command "NEW" for record ""
And I set field "such" to "KV553"
And I create a new row at the end of the table
And I set field "betr" to "100.00" in row 1
Then saving the current editor throws the exception "279"
And I set field "kstelle" to "100" in row 1
And I set field "betr" to "100.00" in row 1
And I create a new row at the end of the table
And I set field "kstelle" to "101" in row 2
And I set field "proz" to "20" in row 2
Then saving the current editor throws the exception "1341"
And I close the current editor

Scenario: 14 dynamischer Kostenverteiler mit Fremdwaehrung, nur kstempf eintragen (keine Kostenstelle), Buchung wird nicht gespeichert
Given I open an editor "BuchungKV_5" from table "(Entry):(Entry)" with command "NEW" for record ""
And I set field "budat" to "31.12.02"
And I set field "beldat" to "31.12.02"
And I set field "beleg" to "BUKV_5"
And I set field "ewbu" to "USD"
And I create a new row at the end of the table
And I set field "konto" to "44000" in row 1 
And I set field "ewsbetr" to "1000" in row 1
And I press button "vert" to open a subeditor for "Kostenverteiler" in row 1
#
And I set field "namebspr" to "ref_kvert_ehsum_cu_14_dyn"
#
And I create a new row at the end of the table
And I set field "kstempf" to "(157,3,0)" in row 1
And I set field "proz" to "10" in row 1
Then saving the current editor throws the exception "1415"
And I close the current editor
And I switch the current editor to editor "BuchungKV_5"
And I close the current editor

Scenario: 15 dynamischer Kostenverteiler, Zeigen
Given I open an editor "BuchungKV_6" from table "(Entry):(Entry)" with command "VIEW" for record "BBUKV_4"
And I press button "vert" to open a subeditor for "Kostenverteiler" in row 1
Then field "bsum" has value "13485.60"
Then field "brest" has value "0.00"
Then field "ebsum" has value "12000.00"
Then field "ebrest" has value "0.00"
And I close the current editor
And I switch the current editor to editor "BuchungKV_6"
And I close the current editor

Scenario: 16 dynamischer Kostenverteiler, nach Betragsaenderungen im Buchungseditor
Given I open an editor "BuchungKV_6" from table "(Entry):(Entry)" with command "NEW" for record ""
And I set field "beleg" to "BUKV_6"
And I set field "budat" to "31.12.02"
And I set field "beldat" to "31.12.02"
And I set field "ewbu" to "USD"
And I create a new row at the end of the table 
And I set field "konto" to "50000" in row 1 
And I set field "ewsbetr" to "1000" in row 1
And I press button "vert" to open a subeditor for "Kostenverteiler" in row 1
#
And I set field "namebspr" to "ref_kvert_ehsum_cu_16a_dyn"
#
And I create a new row at the end of the table
And I set field "kstelle" to "501" in row 1
And I set field "proz" to "10" in row 1
Then field "ewbetr" has value "100.00" in row 1
Then field "betr" has value "112.38" in row 1
And I create a new row at the end of the table
And I set field "kstelle" to "502" in row 2
And I set field "proz" to "90" in row 2
Then field "ewbetr" has value "900.00" in row 2
Then field "betr" has value "1011.42" in row 2
And I save the current editor
And I close the current editor
And I switch the current editor to editor "BuchungKV_6"
And I set field "ewsbetr" to "2000" in row 1
And I press button "vert" to open a subeditor for "Kostenverteiler" in row 1
#
And I set field "namebspr" to "ref_kvert_ehsum_cu_16b_dyn"
#
Then field "ewbetr" has value "200.00" in row 1
Then field "betr" has value "224.76" in row 1
Then field "ewbetr" has value "1800.00" in row 2
Then field "betr" has value "2022.84" in row 2
And I save the current editor
And I close the current editor
And I switch the current editor to editor "BuchungKV_6"
And I create a new row at the end of the table
And I set field "konto" to "16000" in row 2
And I respond with answer "Ja" to the dialog with id "583" 
And I save the current editor
And I close the current editor

Scenario: 17 Anzeigen der Werte eines statischen Kostenverteilers in einer Finanzbuchung
Given I open an editor "BuchungKV_7" from table "(Entry):(Entry)" with command "VIEW" for record "32"
And I press button "vert" to open a subeditor for "Kostenverteiler" in row 1
# Wertdarstellung für statische Kostenverteiler
Then field "bsum" has value "12000.00"
Then field "kstelle" is not modifiable in row 1
Then field "proz" is not modifiable in row 1
Then field "ewbetr" is not modifiable in row 1
Then field "betr" is not modifiable in row 1
Then field "ewbetr" has value "4920.00" in row 1
Then field "proz" has value "41" in row 1
And I close the current editor
And I switch the current editor to editor "BuchungKV_7"
And I close the current editor

Scenario: 18 statischer Kostenverteiler in statistischer Buchung
Given I open an editor "StatBuchung" from table "(Entry):(StatisticalEntry)" with command "NEW" for record ""
And I set field "beleg" to "BUKV_6"
And I set field "budat" to "31.12.02"
And I set field "beldat" to "31.12.02"
And I create a new row at the end of the table 
And I set field "konto" to "99900" in row 1 
And I set field "sbetrag" to "1000" in row 1
And I set field "kstelle" to "550" in row 1
And I create a new row at the end of the table
And I set field "konto" to "99800" in row 2 
And I set field "kstelle" to "550" in row 2
And I respond with answer "Ja" to the dialog with id "583" 
And I save the current editor
And I close the current editor

Given I open an editor "StatBuchung_Storno" from table "(Entry):(StatisticalEntry)" with command "REVERSAL" for record "0000000001"
And I respond with answer "Ja" to the dialog with id "583" 
And I save the current editor
And I close the current editor

Scenario: 20 Löschversuch statischer Kostenverteiler, welcher in Verwendung ist
Given I open an editor "DEL_KV550" from table "(Account):(CostDistribution)" with command "DELETE" for record "550"
# 1212 | Kst/Ktr/Kv kommt noch in einer Buchung vor. Kein Loschen moglich!
Then saving the current editor throws the exception "1212"
And I close the current editor

Scenario: 21 Löschen statischer Kostenverteiler, welcher nicht in Verwendung ist
#
Given I open an editor "kostenverteiler" from table "(Account):(CostDistribution)" with command "COPY" for record "551"
And I set field "namebspr" to "ref_kvert_ehsum_cu_21_stamm"
And I set field "nummer" to "1"
And I set field "such" to "KV1"
And I save the current editor
And I close the current editor
#
Given I open an editor "DEL_KV1" from table "(Account):(CostDistribution)" with command "DELETE" for record "1"
And I respond with answer "ja" to the dialog with id "826"
And I save the current editor
And I close the current editor

Scenario: 22 Löschversuch dynamischer Kostenverteiler (aus Finanzbuchung 36)
Given I open an editor "DEL_DYNKV" from table "(Account):(DynamicCostDistribution)" with command "DELETE" for record "(968,5)"
# 1212 | Kst/Ktr/Kv kommt noch in einer Buchung vor. Kein Loschen moglich!
Then saving the current editor throws the exception "1212"
And I close the current editor

# Scenario: 23 Neuanlage dynamischer Kostenverteiler (analog Scenario 19)
# And opening an editor "kostenverteiler" from table "(Account):(DynamicCostDistribution)" with command "NEW" for record "" throws the exception "40"
# -> tut nicht

Scenario: 24 Kopieren eines dyn. Kostenverteilers (der keinen Kostenempfänger enthält) (dynamischer KV hat Bezeichnung ref_kvert_ehsum_cu_05_dyn) in Stamm-Kostenverteiler 
Given I open an editor "kostenverteiler" from table "(Account):(CostDistribution)" with command "COPY" for record "(960,5,0)"
And I set field "namebspr" to "ref_kvert_ehsum_cu_24_stamm"
And I set field "nummer" to "600"
And I set field "such" to "KV600"
And I save the current editor
And I close the current editor

