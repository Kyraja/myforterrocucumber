# *********************************************************************************************************
#  Name             : kasb_vgj_dyn_kverteiler.feature
#  Autor            : Jan Effler
#  Verantwortlich   : wane
#  Kontrolle        : 
#  Funktion         : Erzeugt 3 Kassenbücher mit EUR und DEM 
#      und testet die Neuanlage dreier dyn. Kostenverteiler mit W�hrungsumrechnung in diesen.
#      In den Buchungen mit Erfassungswährung DEM wird ausserdem eine Rundungsdifferenz automtisch 
#      erzeugt und gebucht. Diese entsteht nur in der Buchung in Buchungswährung (EUR), jedoch nicht
#      Im Kassenbuch und auch nicht in der Erfassungswährungseite der Buchung (DEM)
#      
#      Erzeugt Ausserdem ein viertes Kassenbuch, das für den L�schtest von dyn. Kostenverteilern 
#      dient. Es wird sowohl das L�schen bei Fertig als auch bei Abbruch getestet!
#      
#      2 EU-Testf�lle (einer mit 2.Kontenwährung)
#
#
# *********************************************************************************************************

@persistent
Feature: Kassenbuch und dyn. Kostenverteiler
Background: 

Scenario: Test

Given I set the fake date to "3.07.00"

#  Stammdaten für EU-Testfall mit 2er Kontenwährung

Given I open an editor "" from table "(Account):(Account)" with command "UPDATE" for record "54250"
And I set field "w2ist" to "cad"
And I set field "w2gjahr" to "00-2"
And I save the current editor
And I close the current editor

#  ======================================================================
#  Kassenbuch in EUR (= Buchungswährung) mit dyn.Kostenverteiler
#  EUR wird vor dem Kostenverteiler festgelegt.
#  ======================================================================

Given I open an editor "CashBook-1" from table "(CashBook):(CashBook)" with command "NEW" for record ""
And I set field "kasskto" to "16000"
And I set field "gm" to "2"
And I set field "anfbest" to "120"
And I create a new row at the end of the table
And I set field "beldat" to "1.7.00" in row 1
And I set field "beinn" to "100" in row 1
And I set field "bausg" to "100" in row 1
And I set field "gkonto" to "54000" in row 1
And I press button "vert" to open a subeditor for "CashBook-1-vert" in row 1
And I create a new row at the end of the table
And I set field "kstelle" to "100" in row 1
And I set field "proz" to "70" in row 1
And I create a new row at the end of the table
And I set field "kstelle" to "101" in row 2
And I set field "proz" to "30" in row 2
And I save the current subeditor to switch back to the parent editor

#  zur�ck im Kassenbuch

And I press button "allefr" in row 0
And I press button "bucheschl" to open a subeditor for "CashBook-1-buchen" in row 0
And I save the current subeditor to switch back to the parent editor
And I save the current editor
And I close the current editor


#  ======================================================================
#  Kassenbuch in DEM (ist nicht Buchungswährung) mit dyn.Kostenverteiler
#  DEM wird vor dem Kostenverteiler festgelegt.
#  ======================================================================
# 

Given I open an editor "CashBook-2" from table "(CashBook):(CashBook)" with command "NEW" for record ""
And I set field "kasskto" to "16000"
And I set field "gm" to "1"
And I set field "anfbest" to "400"
And I create a new row at the end of the table
And I set field "beldat" to "1.6.00" in row 1
And I set field "bausg" to "100" in row 1
And I set field "gkonto" to "54000" in row 1
And I set field "waehr" to "dem"
And I set field "anfbest" to "400"
And I press button "vert" to open a subeditor for "CashBook-2-vert" in row 1
And I create a new row at the end of the table
And I set field "kstelle" to "100" in row 1
And I set field "proz" to "60" in row 1
And I create a new row at the end of the table
And I set field "kstelle" to "101" in row 2
And I set field "proz" to "40" in row 2
And I save the current subeditor to switch back to the parent editor
#  
#  zur�ck im Kassenbuch
#  
And I press button "allefr" in row 0
And I press button "bucheschl" to open a subeditor for "CashBook-2-buchen" in row 0
And I save the current subeditor to switch back to the parent editor
And I save the current editor
And I close the current editor

#  ======================================================================
#  Kassenbuch in DEM (ist nicht Buchungswährung) mit dyn.Kostenverteiler
#  DEM wird aber erst NACH dem Kostenverteiler festgelegt/erfasst.
#  ======================================================================

Given I open an editor "CashBook-3" from table "(CashBook):(CashBook)" with command "NEW" for record ""
And I set field "kasskto" to "16000"
And I set field "gm" to "1"
And I set field "anfbest" to "400"
And I create a new row at the end of the table
And I set field "beldat" to "1.6.00" in row 1
And I set field "bausg" to "100" in row 1
And I set field "gkonto" to "54000" in row 1
And I press button "vert" to open a subeditor for "CashBook-3-buchen-1" in row 1
And I create a new row at the end of the table
And I set field "kstelle" to "100" in row 1
And I set field "proz" to "80" in row 1
And I create a new row at the end of the table
And I set field "kstelle" to "101" in row 2
And I set field "proz" to "20" in row 2
And I save the current subeditor to switch back to the parent editor
#  
#  zur�ck im Kassenbuch
#  die 2 EU-Testf�lle
And I create a new row at the end of the table
And I set field "beldat" to "2.6.00" in row 2
And I set field "beinn" to "20" in row 2
And I set field "gkonto" to "43000" in row 2
And I set field "butext" to "EU-VK o. St.zeile" in row 2
And I create a new row at the end of the table
And I set field "beldat" to "2.6.00" in row 3
And I set field "bausg" to "30" in row 3
And I set field "gkonto" to "54250" in row 3
And I set field "butext" to "EU-EKspez.2St.zeilen" in row 3
And I set field "waehr" to "dem"
And I set field "anfbest" to "400"
And I press button "allefr" in row 0
And I press button "bucheschl" to open a subeditor for "CashBook-3-buchen" in row 0
And I save the current subeditor to switch back to the parent editor
And I save the current editor
And I close the current editor

# ========================================================================
# L�schung von Kostenverteilern bei FERTIG testen
# ========================================================================

Given I open an editor "CashBook-4" from table "(CashBook):(CashBook)" with command "NEW" for record ""
And I set field "kasskto" to "16000"
And I set field "gm" to "1"
And I set field "anfbest" to "400"
And I create a new row at the end of the table
And I set field "beldat" to "1.6.00" in row 1
And I set field "bausg" to "100" in row 1
And I set field "gkonto" to "54000" in row 1
And I press button "vert" to open a subeditor for "CashBook-4-vert-1" in row 1
And I create a new row at the end of the table
And I set field "kstelle" to "100" in row 1
And I set field "proz" to "59" in row 1
And I create a new row at the end of the table
And I set field "kstelle" to "101" in row 2
And I set field "proz" to "41" in row 2
And I save the current subeditor to switch back to the parent editor
#  
#  zur�ck im Kassenbuch
#  Kassenbuch Zeile 2 aufsuchen
And I create a new row at the end of the table
And I set field "beldat" to "1.6.00" in row 2
And I set field "bausg" to "200" in row 2
And I set field "gkonto" to "54000" in row 2
And I press button "vert" to open a subeditor for "CashBook-4-vert-2" in row 2
And I create a new row at the end of the table
And I set field "kstelle" to "100" in row 1
And I set field "proz" to "71" in row 1
And I create a new row at the end of the table
And I set field "kstelle" to "101" in row 2
And I set field "proz" to "29" in row 2
And I save the current subeditor to switch back to the parent editor
#  
#  zur�ck im Kassenbuch
#  
#  Kassenbuch Zeile 3 aufsuchen
And I create a new row at the end of the table
And I set field "beldat" to "1.6.00" in row 3
And I set field "bausg" to "300" in row 3
And I set field "gkonto" to "54000" in row 3
And I press button "vert" to open a subeditor for "CashBook-4-vert-3" in row 3
And I create a new row at the end of the table
And I set field "kstelle" to "100" in row 1
And I set field "proz" to "81" in row 1
And I create a new row at the end of the table
And I set field "kstelle" to "101" in row 2
And I set field "proz" to "19" in row 2
And I save the current subeditor to switch back to the parent editor
#  
#  zur�ck im Kassenbuch
#  
#  Zeile 1 aufsuchen
#  --------------- Kostenverteiler in Zeile 1 direkt überschreiben -----------------
And I set field "kstelle" to "101" in row 1
#  --------------- Kostenverteiler in Zeile 2 indirekt überschreiben ---------------
And I set field "gkonto" to "44000" in row 2
#  --------------- Zeile 3 mit Kostenverteiler löschen ---------------
And I delete row at position 3
And I save the current editor
And I close the current editor
# 
# 
Given I open an editor "" from table "(CashBook):(CashBook)" with command "UPDATE" for record "4"
#  --------------- Button darf nur für Kostenverteiler funktionieren----------------
Then pressing button "vert" in row 1 to open a subeditor throws the exception "354"
And I close the current subeditor to switch back to the parent editor
And I close the current editor
# 
#  ====================================================
#  L�schtest bei <neu> + Abbruch
#  ====================================================

Given I open an editor "CashBook-5" from table "(CashBook):(CashBook)" with command "NEW" for record ""
And I set field "waehr" to "DEM"
And I set field "kasskto" to "16000"
And I set field "gm" to "1"
And I set field "anfbest" to "400"
#  Kassenbuch Zeile 1 aufsuchen
And I create a new row at the end of the table
And I set field "beldat" to "2.6.00" in row 1
And I set field "bausg" to "100" in row 1
And I set field "gkonto" to "54000" in row 1
And I press button "vert" to open a subeditor for "CashBook-5-vert" in row 1
And I create a new row at the end of the table
And I set field "kstelle" to "100" in row 1
And I set field "proz" to "61" in row 1
And I create a new row at the end of the table
And I set field "kstelle" to "101" in row 2
And I set field "proz" to "39" in row 2
And I save the current subeditor to switch back to the parent editor
#  
#  zur�ck im Kassenbuch
And I close the current editor
# 
#  ====================================================
#  L�schtest bei <aendern> + Abbruch
#  ====================================================

Given I open an editor "CashBook-4" from table "(CashBook):(CashBook)" with command "UPDATE" for record "4"
And I create a new row at position 2
And I set field "beldat" to "2.6.00" in row 2
And I set field "bausg" to "100" in row 2
And I set field "gkonto" to "54000" in row 2
And I press button "vert" to open a subeditor for "CashBook-4-vert-2" in row 2
And I create a new row at the end of the table
And I set field "kstelle" to "100" in row 1
And I set field "proz" to "62" in row 1
And I create a new row at the end of the table
And I set field "kstelle" to "101" in row 2
And I set field "proz" to "38" in row 2
And I save the current subeditor to switch back to the parent editor
#  
#  zur�ck im Kassenbuch
And I close the current editor






