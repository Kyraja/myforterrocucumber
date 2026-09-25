# *****************************************************************************
#  Name             : ref_zv_de_QR_stamm_cu.feature
#  Autor            : rem
#  Verantwortlich   : hc
#  Kontrolle        :
#  Funktion         : Stammdaten fuer Tests der QR-Zahlungen (ref_zv_de_QR_*) erfassen, wenn Inland DE und Inlandswaehrung EUR
#  ref              : ref_zv_de_QR_stamm_cu
# *****************************************************************************
@persistent
Feature: ref_zv_de_QR_stamm_cu.feature
Background:
Given I set the fake date to "31.12.2022"
# Kunden, Lieferanten, Bankverbindungen, ... erfassen
# =============================================================================
Scenario: Land_in_Betriebsdaten
Given I open an editor "Betriebsdaten" from table "12:10" with command "UPDATE" for record "1"
And I set field "staat" to "DEUTSCHLAND"
And I set field "knam1" to "Flextrusion Maschinenbau"
And I set field "ans" to "Flextrusion Maschinenbau"
And I set field "str" to "Bahnhofstrasse 21"
And I set field "plz" to "78246"
And I set field "nort" to "Harmsdorf"
And I save the current editor
#--------------------------------------
Scenario: Land_update
Given I open an editor "landeswaehrung" from table "97:01" with command "UPDATE" for record "SCHWEIZ"
And I set field "inlwaehr" to "CHF"
And I set field "waeh" to "CHF"
And I save the current editor
#---------------------------------------
Scenario: Stammdaten_anlegen
Given I open an editor "Stadtsparkasse" from table "96:01" with command "NEW" for record ""
And I set field "such" to "B70150000"
And I set field "name" to "Stadtsparkasse München"
And I set field "iident" to "SSKMDEMM"
And I save the current editor
#--------------------------------------
Given I open an editor "DeutscheBank" from table "96:01" with command "NEW" for record ""
And I set field "such" to "B66070004"
And I set field "name" to "Deutsche Bank Bruchsal"
And I set field "iident" to "DEUTDESM661"
And I set field "nident" to "70150000"
And I save the current editor
#--------------------------------------
Given I open an editor "Kantonalb" from table "96:01" with command "NEW" for record ""
And I set field "such" to "KANTONALB"
And I set field "name" to "Zuericher Kantonalbank"
And I set field "iident" to "ZKBKCHZZ80A"
And I set field "staat" to "SCHWEIZ"
And I save the current editor
#---------------------------------------------------------------------------------
# Wir benötigen zum schweizer Inlandszahlungsverkehr eine schweizer Bankverbindung
Given I open an editor "Bankverb" from table "96:02" with command "NEW" for record ""
And I set field "nummer" to "100"
And I set field "koinh" to "Überweisungen Schweiz"
And I set field "such" to "BVERB"
And I set field "name" to "Überweisungen Kantonalbank"
And I set field "konto" to "14600"
And I set field "bank" to "KANTONALB"
And I set field "iban" to "CH1700700110006355066"
And I save the current editor
#-----------------------------------------
Given I open an editor "Moneytr" from table "05:01" with command "UPDATE" for record "14600"
And I set field "such" to "K14600"
And I set field "name" to "Überweisungen Schweiz"
And I set field "zaraum" to "Inlandszahlungen"
And I set field "zawaehr" to "CHF"
And I set field "zasammelart" to "Sammelbuchungen und Sammel-OP"
And I set field "bverb" to id from editor "Bankverb"
And I save the current editor
#-------------------------------------------
Given I open an editor "SchweizerLieferant" from table "01:01" with command "STORE" for record "60019"
And I set field "nummer" to "60019"
And I set field "such" to "Schaefer"
And I set field "name" to "Schaefer, Bern"
And I set field "ans" to "Schaefer, Bern"
And I set field "str" to "Hohe Strasse 25"
And I set field "nort" to "Aarau"
And I set field "plz" to "8888"
And I set field "zbed" to "200"
And I set field "staat" to "SCHWEIZ"
And I set field "waehr" to "CHF"
And I save the current editor

