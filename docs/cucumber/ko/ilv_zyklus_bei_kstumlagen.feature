@persistent
Feature: BW2-1746
Background:
Given I set the fake date to "30.08.2002"

# *****************************************************************************
#  Name             : ilv_zyklus_bei_kstumlagen.feature
#  Autor            : Silvia Warth
#  Verantwortlich   : sih
#  Kontrolle        : uo
#  Funktion         : Test der Stammdaten dahingehend, daß keine Kostenstelle bei der ILV ihre 
#                     Kosten zu 100% an eine Kostenstelle weitergibt, welche sie wieder zu 100% 
#                     an die Ausgangskostenstelle zurück gibt.
#                     Im Fehlerfall bei bestehendem Zyklus:
#                     ERROR_MESSAGE Cat=FATALERROR No=1547: falsches Ergebnis in der ILV
#
# *****************************************************************************

Scenario: 01 Konten Be- und Entlastung ILV für neu anzulegende Kst 201 bis 204 anlegen 
Given I open an editor "ko" from table "(Account):(Account)" with command "COPY" for record "99210"
And I set field "nummer" to "99230"
And I set field "bem" to "Belastung Kst 201, 202, 203, 204"
And I save the current editor

Given I open an editor "ko" from table "(Account):(Account)" with command "COPY" for record "99220"
And I set field "nummer" to "99240"
And I set field "bem" to "Entlastung Kst 201, 202, 203, 204"
And I save the current editor

Scenario: 02 Hilfskostenstellen anlegen
Given I open an editor "ks" from table "(Account):(CostCenter)" with command "NEW" for record ""
And I set field "nummer" to "201"
And I set field "such" to "ks201"
And I set field "hilfsks" to "ja"
And I set field "bezug" to "9000"
And I set field "umlzu" to "99240"
And I set field "umlab" to "99230"
And I save the current editor

Given I open an editor "ks" from table "(Account):(CostCenter)" with command "NEW" for record ""
And I set field "nummer" to "202"
And I set field "such" to "ks202"
And I set field "hilfsks" to "ja"
And I set field "bezug" to "9000"
And I set field "umlzu" to "99240"
And I set field "umlab" to "99230"
And I save the current editor

Given I open an editor "ks" from table "(Account):(CostCenter)" with command "NEW" for record ""
And I set field "nummer" to "203"
And I set field "such" to "ks203"
And I set field "hilfsks" to "ja"
And I set field "bezug" to "9000"
And I set field "umlzu" to "99240"
And I set field "umlab" to "99230"
And I save the current editor

Given I open an editor "ks" from table "(Account):(CostCenter)" with command "NEW" for record ""
And I set field "nummer" to "204"
And I set field "such" to "ks204"
And I set field "hilfsks" to "ja"
And I set field "bezug" to "9000"
And I set field "umlzu" to "99240"
And I set field "umlab" to "99230"
And I save the current editor

Scenario: 03 Kostenstellenumlagen anlegen
Given I open an editor "ksum1" from table "(Assessment):(CostCenterAssessment)" with command "NEW" for record ""
And I set field "such" to "um201"
And I set field "ksab" to "201"
And I create a new row at the end of the table
And I set field "kszu" to "202" in row 1
And I save the current editor
And I close the current editor

Given I open an editor "ksum1" from table "(Assessment):(CostCenterAssessment)" with command "UPDATE" for record "um201"
And I set field "gjahr" to "."
And I press button "kszuist" to open a subeditor for "Ist-VKZ" in row 1 with dialog "2011" and answer "Ja"
And I set field "s7" to "100"
And I respond with answer "Ja" to the dialog with id "2012"
And I save the current editor
And I switch the current editor to editor "ksum1"
And I close the current editor

Given I open an editor "ksum1" from table "(Assessment):(CostCenterAssessment)" with command "NEW" for record ""
And I set field "such" to "um202"
And I set field "ksab" to "202"
And I create a new row at the end of the table
And I set field "kszu" to "203" in row 1
And I save the current editor
And I close the current editor

Given I open an editor "ksum1" from table "(Assessment):(CostCenterAssessment)" with command "UPDATE" for record "um202"
And I set field "gjahr" to "."
And I press button "kszuist" to open a subeditor for "Ist-VKZ" in row 1 with dialog "2011" and answer "Ja"
And I set field "s7" to "100"
And I respond with answer "Ja" to the dialog with id "2012"
And I save the current editor
And I switch the current editor to editor "ksum1"
And I close the current editor

Given I open an editor "ksum1" from table "(Assessment):(CostCenterAssessment)" with command "NEW" for record ""
And I set field "such" to "um203"
And I set field "ksab" to "203"
And I create a new row at the end of the table
And I set field "kszu" to "204" in row 1
And I save the current editor
And I close the current editor

Given I open an editor "ksum1" from table "(Assessment):(CostCenterAssessment)" with command "UPDATE" for record "um203"
And I set field "gjahr" to "."
And I press button "kszuist" to open a subeditor for "Ist-VKZ" in row 1 with dialog "2011" and answer "Ja"
And I set field "s7" to "100"
And I respond with answer "Ja" to the dialog with id "2012"
And I save the current editor
And I switch the current editor to editor "ksum1"
And I close the current editor

Given I open an editor "ksum1" from table "(Assessment):(CostCenterAssessment)" with command "NEW" for record ""
And I set field "such" to "um204"
And I set field "ksab" to "204"
And I create a new row at the end of the table
And I set field "kszu" to "201" in row 1
And I save the current editor
And I close the current editor

Given I open an editor "ksum1" from table "(Assessment):(CostCenterAssessment)" with command "UPDATE" for record "um204"
And I set field "gjahr" to "."
And I press button "kszuist" to open a subeditor for "Ist-VKZ" in row 1 with dialog "2011" and answer "Ja"
And I set field "s7" to "100"
And I respond with answer "Ja" to the dialog with id "2012"
And I save the current editor
And I switch the current editor to editor "ksum1"
And I close the current editor

Scenario: 04 Buchung erzeugen
Given I open an editor "Buchung1" from table "(Entry):(Entry)" with command "NEW" for record ""
And I set field "budat" to "31.7.02"
And  I create a new row at the end of the table
And I set field "konto" to "54000" in row 1
And I set field "ewsbetr" to "1000" in row 1
And I set field "kstelle" to "201" in row 1
And  I create a new row at the end of the table
And I set field "konto" to "51000" in row 2
And I set field "ewsbetr" to "4000" in row 2
And I set field "kstelle" to "202" in row 2
And  I create a new row at the end of the table
And I set field "konto" to "50000" in row 3
And I set field "ewsbetr" to "2000" in row 3
And I set field "kstelle" to "203" in row 3
And  I create a new row at the end of the table
And I set field "konto" to "54000" in row 4
And I set field "ewsbetr" to "600" in row 4
And I set field "kstelle" to "202" in row 4
And  I create a new row at the end of the table
And I set field "konto" to "11400" in row 5
And I respond with answer "ja" to the dialog with id "1941"
And I save the current editor

Scenario: 05 ILV ausführen
Given I open an editor "Umlage" for tip command "ilv" and arguments ""
And I set field "monat" to "7"
And I set field "vorschau" to "ja"
And I set field "datart" to "Ist"
And I press button "bstart"
And I save the current editor




