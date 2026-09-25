# *****************************************************************************
#  Name             : ref_zv_ch_QR_stamm_cu.feature
#  Autor            : rem
#  Verantwortlich   : hc
#  Kontrolle        :
#  Funktion         : Stammdaten fuer Tests der QR-Zahlungen (ref_zv_ch_QR_*) erfassen, wenn Inland CH und Inlandswaehrung CHF
#  ref              : ref_zv_ch_QR_stamm_cu
# *****************************************************************************
@persistent
Feature: ref_zv_ch_QR_stamm_cu.feature
Background:
Given I set the fake date to "31.12.2022"
# =============================================================================
Scenario: Land_in_Betriebsdaten
Given I open an editor "Betriebsdaten" from table "12:10" with command "UPDATE" for record "1"
And I set field "staat" to "SCHWEIZ"
And I set field "knam1" to "Ruebli und Reibekuchen GmbH"
And I set field "ans" to "Ruebli und Reibekuchen GmbH"
And I set field "str" to "Bahnhofstrasse 21" 
And I set field "plz" to "4460"
And I set field "nort" to "Aargau"
And I save the current editor
#--------------------------------------
Scenario: Stammdaten_anlegen
Given I open an editor "Bank" from table "96:01" with command "NEW" for record ""
And I set field "such" to "THURG"
And I set field "name" to "Thurgauer Kantonalbank"
And I set field "iident" to "KBTGCH22"
And I save the current editor
#--------------------------------------
Given I open an editor "Kantonalb" from table "96:01" with command "NEW" for record ""
And I set field "such" to "KANTONALB"
And I set field "name" to "Zuericher Kantonalbank"
And I set field "iident" to "ZKBKCHZZ80A"
And I save the current editor
#--------------------------------------
Given I open an editor "Moneytr" from table "05:01" with command "NEW" for record ""
And I set field "nummer" to "14610"
And I set field "such" to "K14610"
And I set field "name" to "Geldtransit Ueberweisungen"
And I set field "karta" to "Geldtransitkonto"
And I set field "zaform" to "(Transfer)"
And I set field "zaraum" to "Inlandszahlungen"
And I set field "zawaehr" to "CHF"
And I set field "zasammelart" to "Sammelbuchungen und Sammel-OP"
And I set field "oprel" to "ja"
And I save the current editor
#-------------------------------------------
Given I open an editor "Bankverb" from table "96:02" with command "NEW" for record ""
And I set field "nummer" to "100"
And I set field "such" to "BVERB"
And I set field "name" to "Überweisungen Zuericher Kantonalbank"
And I set field "konto" to "14610"
And I set field "bank" to "KANTONALB"
And I set field "iban" to "CH1700700110006355066"
And I save the current editor
#---------------------------------------------
Given I open an editor "Geldkonto" from table "05:01" with command "UPDATE" for record "14610"
And I set field "bverb" to id from editor "Bankverb"
And I save the current editor
#------------------------------------------------
Given I open an editor "SchweizerLieferant" from table "01:01" with command "STORE" for record "60019"
And I set field "nummer" to "60019"
And I set field "such" to "Schaefer"
And I set field "name" to "Schaefer, Bern"
And I set field "ans" to "Schaefer, Bern"
And I set field "str" to "Hohe Strasse 25"
And I set field "nort" to "Aarau"
And I set field "plz" to "8888"
And I set field "zbed" to "200"
And I save the current editor
