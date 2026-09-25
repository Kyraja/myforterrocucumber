# *****************************************************************************
#  Name           : kv_kempf.feature                         
#  Autor          : sih
#  Verantwortlich : sih
#  Kontrolle      : uo
#  Funktion       : Test des Verwendens von Kostenverteilern, die nur Kostenobjekte, nur Kostenempfänger oder beides enthalten 
#                   im Kontext ohne und mit Kore-Zwang                                                                        
#
# *****************************************************************************
@persistent
Feature: ref_kv_kempfvor_kore_startdat_cu und ref_kv_kempf_nach_kore_startdat_cu
Background: 
# Startdatum Kore 12/00
Given I set the fake date to "01.12.00"

Scenario: Buchungen
#
# Buchung-1
# Zeile 1: Konto 55000 (ohne Korezwang), mehrzeiliger dyn. KV ohne Kostenobjekt, mit Kostenempfänger
# Zeile 2: Konto 55000,                  mehrzeiliger dyn. KV mit Kostenobjekt, ohne Kostenempfänger   
# Zeile 3: Konto 54000 (mit Korezwang),  mehrzeiliger dyn. KV mit Kostenobjekt, eine Zeile mit Kostenempfänger     
# Zeile 4: Konto 54000 (mit Korezwang),  zunächst Versuch, dyn. KV ohne Kostenobjekt anzulegen, dann
#                                        mehrzeiliger dyn. KV mit Kostenobjekt, mit Kostenempfänger     
#
Given I open an editor "Buchung-1" from table "(Entry):(Entry)" with command "NEW" for record ""
And I set field "such" to "bu1"
# Zeile 1
And I create a new row at the end of the table
And I set field "konto" to "55000" in row !lastRow
And I set field "ewsbetr" to "100" in row !lastRow
# KV nur mit Kostenempfaengern
And I press button "vert" to open a subeditor for "Kostenverteiler" in row !lastRow
And I create a new row at the end of the table
And I set field "kstempf" to "(174,4,0)" in row 1
And I set field "proz" to "20" in row 1
And I create a new row at the end of the table
And I set field "kstempf" to "(174,4,0)" in row 2
And I set field "proz" to "80" in row 2
And I save the current editor
And I close the current editor
And I switch the current editor to editor "Buchung-1"
# Zeile 2
And I create a new row at the end of the table
And I set field "konto" to "55000" in row !lastRow
And I set field "ewsbetr" to "100" in row !lastRow
# KV nur mit Kostenobjekten
And I press button "vert" to open a subeditor for "Kostenverteiler" in row !lastRow
And I create a new row at the end of the table
And I set field "kstelle" to "100" in row 1
And I set field "proz" to "20" in row 1
And I create a new row at the end of the table
And I set field "kstelle" to "101" in row 2
And I set field "proz" to "80" in row 2
And I save the current editor
And I close the current editor
And I switch the current editor to editor "Buchung-1"
# Zeile 3
And I create a new row at the end of the table
And I set field "konto" to "54000" in row !lastRow
And I set field "ewsbetr" to "300" in row !lastRow
# KV gemischt (ersten beiden Zeilen nur Kst, dritte Zeile Kst und KEmpf)
And I press button "vert" to open a subeditor for "Kostenverteiler" in row !lastRow
And I create a new row at the end of the table
And I set field "kstelle" to "100" in row 1
And I set field "proz" to "15" in row 1
And I create a new row at the end of the table
And I set field "kstelle" to "101" in row 2
And I set field "proz" to "80" in row 2
And I create a new row at the end of the table
And I set field "kstelle" to "102" in row 3
And I set field "kstempf" to "(174,4,0)" in row 3
And I set field "proz" to "5" in row 3
And I save the current editor
And I close the current editor
And I switch the current editor to editor "Buchung-1"
# Zeile 4
And I create a new row at the end of the table
And I set field "konto" to "54000" in row !lastRow
And I set field "ewsbetr" to "400" in row !lastRow
# KV gemischt (ersten beiden Zeilen Kst und KEmpf, dritte Zeile nur KEmpf)
And I press button "vert" to open a subeditor for "Kostenverteiler" in row !lastRow
#
# zunächst Fehlerzeile
And I create a new row at the end of the table
And I set field "kstempf" to "(174,4,0)" in row 1
And I set field "proz" to "100" in row 1
Then saving the current editor throws the exception "1415"
And I close the current editor
#
# nun gültigen dyn. KV anlegen
And I switch the current editor to editor "Buchung-1"
And I press button "vert" to open a subeditor for "Kostenverteiler" in row !lastRow
And I create a new row at the end of the table
#
And I set field "kstelle" to "100" in row 1
And I set field "kstempf" to "(174,4,0)" in row 1
And I set field "proz" to "15" in row 1
And I create a new row at the end of the table
And I set field "kstelle" to "101" in row 2
And I set field "kstempf" to "(174,4,0)" in row 2
And I set field "proz" to "80" in row 2
And I create a new row at the end of the table
And I set field "kstelle" to "100000" in row 3
And I set field "kstempf" to "(174,4,0)" in row 3
And I set field "proz" to "5" in row 3
And I save the current editor
And I close the current editor
And I switch the current editor to editor "Buchung-1"
# Zeile 5
And I create a new row at the end of the table
And I set field "konto" to "11400" in row !lastRow
And I respond with answer "Ja" to the dialog with id "1941"
And I save the current editor
#
#
#
# Buchung-2
# Zeile 1: Konto 54000 (mit Korezwang),  einzeiliger dyn. KV mit Kostenobjekt, mit Kostenempfänger
# Zeile 2: Konto 55000 (ohne Korezwang), einzeiliger dyn. KV ohne Kostenobjekt, ohne Kostenempfänger   
#
Given I open an editor "Buchung-2" from table "(Entry):(Entry)" with command "NEW" for record ""
And I set field "such" to "bu2"
# Zeile 1
And I create a new row at the end of the table
And I set field "konto" to "54000" in row 1
And I set field "ewsbetr" to "500" in row 1
# KV nur mit KEmpf
And I press button "vert" to open a subeditor for "Kostenverteiler" in row !lastRow
And I create a new row at the end of the table
And I set field "kstelle" to "100" in row 1 
And I set field "kstempf" to "(174,4,0)" in row 1
And I set field "proz" to "100" in row 1
And I save the current editor
And I close the current editor
And I switch the current editor to editor "Buchung-2"
# Zeile 2
And I create a new row at the end of the table
And I set field "konto" to "55000" in row 2
And I set field "ewsbetr" to "400" in row 2
# KV nur mit KEmpf
And I press button "vert" to open a subeditor for "Kostenverteiler" in row !lastRow
And I create a new row at the end of the table
And I set field "kstempf" to "(174,4,0)" in row 1
And I set field "proz" to "100" in row 1
And I save the current editor
And I close the current editor
And I switch the current editor to editor "Buchung-2"
# Zeile 3
And I create a new row at the end of the table
And I set field "konto" to "11400" in row !lastRow
And I respond with answer "Ja" to the dialog with id "1941"
And I save the current editor


