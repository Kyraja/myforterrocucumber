# *****************************************************************************
#  Name             : ref_zv_de_QR_NON_cu.feature
#  Autor            : rem
#  Verantwortlich   : hc
#  Kontrolle        :
#  Funktion         : Test der QR-Zahlungen NON (Schweizer Zahlungsverkehr), wenn Inland DE und Inlandswaehrung EUR
#  ref              : ref_zv_de_QR_NON_cu
# *****************************************************************************
@persistent
Feature: ref_zv_de_QR_NON_cu.feature
Background:
Given I set the fake date to "31.12.2022"
#Scenario: QR-Zahlungen NON von der Rechnung bis zur Zahlung
# =============================================================================
Scenario: Bestellung und Rechnung anlegen
Given I open an editor "Bestellvorschläge" from table "04:07" with command "NEW" for record ""
And I create a new row at the end of the table
And I set field "artikel" to "E1" in row 1
And I set field "mge" to "10" in row 1
And I save the current editor

Scenario: Bestellvorschlag freigeben zu Bestellung
Given I open an editor "Bestellvorschläge" from table "04:07" with command "UPDATE" for record ""
And I set field "artikel" to "E1"
And I press button "ladetab"
And I set field "mfreig" to "ja" in row !lastRow
And I press button "freig" to open a subeditor for "Bestellung"
And I save the current editor
And I switch the current editor to editor "Bestellvorschläge"
And I close the current editor

Scenario: Rechnung aus Bestellung generieren
# ehemals roter Zahlschein, Referenzlose Zahlung nur mit IBAN
Given I open an editor "ausBestellung" from table "04:22" with command "INVOICE" for record "BTEST"
Then field "artikel" has value "E1" in row 1
And I set field "vom" to "."
And I set field "ebeleg" to "33477"
And I set field "lief" to "60019"
And I set field "zatlnr" to "CH5800791123000889012"
And I set field "zarefpruef" to "NON"
And I set field "mge" to "10" in row 1
And I set field "ueb" to "ja"
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

Scenario: Rechnung umbuchen
Given I open an editor "Umbuchung" from table "102:01" with command "NEW" for record ""
And I set field "gkonto" to "14600"
And I set field "beleg" to "ZANON"
And I set field "bdatauto" to "ja"
And I set field "beldat" to "."
And I set field "kbudat" to "."
Then field "kwaehr" has value "CHF"
Then field "zaraum" has value "Inlandszahlungen"
And I create a new row at the end of the table
And I set field "tbeleg" to "1" in row 1
And I press button "topladen" in row 1
Then field "ofbetr" has value "163.50" in row 1
And I press button "tueber" in row 1
Then field "opzabetr" has value "163.50" in row 1
Then field "tlnr" has value "CH5800791123000889012" in row 1
Then field "zaqrreferenz" has value "" in row 1
Then field "refpruef" has value "NON" in row 1
And I respond with answer "ja" to the dialog with id "588"
And I save the current editor

#Hat ZAHLAUS den Status gruen ?
#Hier wird durch die Abfrage der Felder tzaland und tzabetr auch das Feld Rechnungsbetrag (das sonst immer leer war, mitgetestet)
Given I open the infosystem "ZAHLAUS"
And I set field "bankdatei" to "2"
Then field "zaraum" has value "Inlandszahlungen"
Then field "statusz" has value "icon:ball_green"
Then field "tiban" has value "CH5800791123000889012" in row 1
Then field "tzabetr" has value "163.50" in row 1
Then field "tzaland" has value "CHF" in row 1
Then field "trefcheck" has value "NON" in row 1
Then field "tqrreferenz" has value "" in row 1
Then field "ttaart" has value "ZA3.NON" in row 1
Then field "tstatusz" has value "icon:ball_green" in row 1
Then field "ttaart" has value "ZA3.NON" in row 1
And I press button "bdtrerzeug"
And I save the current editor
