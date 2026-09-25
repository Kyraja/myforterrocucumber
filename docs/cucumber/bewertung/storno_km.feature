@persistent
Feature: BW2-592 (Storno Fibu-Buchungen der Kostenumlage)
Background:
Given I set the fake date to "02.01.1995"
#  Test der Erzeugung der Stornobuchungen von Buchungen mit Ursache Kostenumlage im
#  offenen und im geschlossenen Zeitraum.

# ----------------------
# #!database=Einkauf 
# #!group=Rechnung
# #!action=copy
# nummer;nummer;vom;ueb
# +6001RKM;6001RKM2;.;nein
Scenario: Storno bei XYZ
Given I open an editor "6001RKM2" from table "(Purchasing):(Invoice)" with command "COPY" for record "+6001RKM"
And I set fields
    | nummer | 6001RKM2 |
    | vom    | .        |
    | ueb    | nein     |
And I set field "konto" to "10000" in row 1
#And I set field "mge" to "10000" in row 1

# Kostenumlage zu Rechnung anlegen
And I press button "kostenuml" to open a subeditor for "Kostenumlage" in row 1
And I set field "umlagemeth" to "linear"
And I set field "fibuumbuch" to "ja"
#And I set field "name" to "KM1"
And I create a new row at the end of the table	
And I set field "pos" to "$,,@datei=4:2;kopf=+6001LS1;artex=RTEIL1;@ablageart=abgelegt" in row 1
And I save the current editor
And I switch the current editor to editor "6001RKM2"
And I set field "ueb" to "ja"
And I save the current editor
  
Given I set the fake date to "02.02.95"

Given I open an editor "Monatsabschluss" from table "(FiscalYearManagement):(Closings)" with command "NEW" for record ""
And I set fields
    | such | ABSCHL      |
And I press button "fbbbu" in row 4
And I respond with answer "Ja" to the dialog with id "7626"
And I save the current editor
#And I set field "mge" to "10000" in row 1

Given I open an editor "6001RKM3" from table "(Purchasing):(Invoice)" with command "COPY" for record "+6001RKM"
And I set fields
    | nummer | 6001RKM3 |
    | vom    | .        |
    | ueb    | nein     |
And I set field "konto" to "10000" in row 1

# Kostenumlage zu Rechnung anlegen
And I press button "kostenuml" to open a subeditor for "Kostenumlage" in row 1
And I set field "umlagemeth" to "linear"
And I set field "fibuumbuch" to "ja"
#And I set field "name" to "KM2"
And I create a new row at the end of the table	
And I set field "pos" to "$,,@datei=4:2;kopf=+6001LS1;artex=RTEIL1;@ablageart=abgelegt" in row 1
And I save the current editor
And I switch the current editor to editor "6001RKM3"
And I set field "ueb" to "ja"
And I save the current editor

Given I open an editor "StornoKostenumlage" from table "(CostDistribution):(CostDistribution)" with command "REVERSAL" for record "+3"
Then saving the current editor throws the exception "50"
And I close the current editor


Given I open an editor "StornoKostenumlage2" from table "(CostDistribution):(CostDistribution)" with command "REVERSAL" for record "+4"
And I save the current editor

# ----------------------

#And I append rows
#    |artex  |pnum | mge | tterm | platz | preis |
#    |RTEIL1 |  1  | 40  | .     | F1    | 1,00  |
#And I save the current editor
#
#Given I open an editor "6001RE3" from table "(Purchasing):(PurchaseOrder)" with command "INVOICE" for record "6001BE1"
#And I set fields
#    | nummer | 6001BE1 |
#    | lief   | 1       |
#    | vom    | .       |
#    
#And I append rows
#    |artex  |pnum | mge | tterm | platz | preis |
#    |RTEIL1 |  1  | 40  | .     | F1    | 1,00  |
#And I save the current editor


