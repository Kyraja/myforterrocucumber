# *****************************************************************************
#  Name             : ref_zv_ch_QR_QRR_cu.feature
#  Autor            : rem
#  Verantwortlich   : hc
#  Kontrolle        :
#  Funktion         : Test der QR-Zahlungen QRR (Schweizer Zahlungsverkehr), wenn Inland CH und Inlandswaehrung CHF
#  ref              : ref_zv_ch_QR_QRR_cu
# *****************************************************************************
@persistent
Feature: ref_zv_ch_QR_QRR_cu.feature
Background:
Given I set the fake date to "31.12.2022"
# =============================================================================
Scenario: Bestellung und Rechnung CHF anlegen
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
# Felder für QRR Zahlung in der Eingangsrechnung bestücken 
Given I open an editor "ausBestellung" from table "04:22" with command "INVOICE" for record "BTEST"
Then field "artikel" has value "E1" in row 1
And I set field "vom" to "."
And I set field "ebeleg" to "08154711"
And I set field "lief" to "60019"
And I set field "zatlnr" to "CH4431999123000889012"
And I set field "zaqrreferenz" to "210000000003139471430009017"
And I set field "zarefpruef" to "QRR"
And I set field "zakodzeile" to "Mein Zusatztext"
And I set field "mge" to "10" in row 1
And I set field "ueb" to "ja"
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

Scenario: Rechnung umbuchen in CHF
Given I open an editor "Umbuchung" from table "102:01" with command "NEW" for record ""
And I set field "gkonto" to "14610"
And I set field "beleg" to "ZA33"
And I set field "bdatauto" to "ja"
And I set field "beldat" to "."
And I set field "kbudat" to "."
Then field "kwaehr" has value "CHF"
Then field "zaraum" has value "Inlandszahlungen"
And I create a new row at the end of the table
And I set field "tbeleg" to "1" in row 1
And I press button "topladen" in row 1
Then field "ofbetr" has value "194.57" in row 1
And I press button "tueber" in row 1
Then field "opzabetr" has value "194.57" in row 1
Then field "tlnr" has value "CH4431999123000889012" in row 1
Then field "zaqrreferenz" has value "210000000003139471430009017" in row 1
Then field "refpruef" has value "QRR" in row 1
Then field "kodzeile" has value "Mein Zusatztext" in row 1
And I respond with answer "ja" to the dialog with id "588"
And I save the current editor

#Hat ZAHLAUS den Status grün
Given I open the infosystem "ZAHLAUS"
And I set field "bankdatei" to "2"
Then field "zaraum" has value "Inlandszahlungen"
Then field "statusz" has value "icon:ball_green"
Then field "tiban" has value "CH4431999123000889012" in row 1
Then field "ttlnr" has value "CH4431999123000889012" in row 1
Then field "ttaart" has value "ZA3.QRR" in row 1
Then field "tstatusz" has value "icon:ball_green" in row 1
And I press button "bdtrerzeug"
And I save the current editor

# selbe Schritte nochmal mit Bestellung RE in EUR
Scenario: Bestellung und Rechnung EUR anlegen
Given I open an editor "BestellvorschlägeEUR" from table "04:07" with command "NEW" for record ""
And I create a new row at the end of the table
And I set field "artikel" to "E1" in row 1
And I set field "mge" to "10" in row 1
And I save the current editor

Scenario: Bestellvorschlag freigeben zu Bestellung EUR
Given I open an editor "BestellvorschlägeEUR" from table "04:07" with command "UPDATE" for record ""
And I set field "artikel" to "E1"
And I press button "ladetab"
And I set field "mfreig" to "ja" in row !lastRow
And I press button "freig" to open a subeditor for "BestellungEUR"
And I save the current editor
And I switch the current editor to editor "BestellvorschlägeEUR"
And I close the current editor

Scenario: Rechnung aus Bestellung generieren EUR
# Felder für QRR Zahlung in der Eingangsrechnung bestücken EUR
Given I open an editor "BestellungEUR" from table "04:22" with command "INVOICE" for record "BTEST"
Then field "artikel" has value "E1" in row 1
And I set field "vom" to "."
And I set field "ebeleg" to "08154712"
And I set field "lief" to "60019"
And I set field "erfwaehr" to "EUR"
And I set field "zatlnr" to "CH4431999123000889012"
And I set field "zaqrreferenz" to "210000000003139471430009017"
And I set field "zarefpruef" to "QRR"
And I set field "zakodzeile" to "Mein Zusatztext EUR"
And I set field "mge" to "10" in row 1
And I set field "ueb" to "ja"
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

Scenario: Rechnung umbuchen in EUR
Given I open an editor "Umbuchung" from table "102:01" with command "NEW" for record ""
And I set field "gkonto" to "14610"
And I set field "kwaehr" to "EUR"
And I set field "beleg" to "ZA34"
And I set field "bdatauto" to "ja"
And I set field "beldat" to "."
And I set field "kbudat" to "."
Then field "kwaehr" has value "EUR"
Then field "zaraum" has value "Inlandszahlungen"
And I create a new row at the end of the table
And I set field "tbeleg" to "2" in row 1
And I press button "topladen" in row 1
Then field "ofbetr" has value "178.50" in row 1
And I press button "tueber" in row 1
Then field "opzabetr" has value "178.50" in row 1
Then field "tlnr" has value "CH4431999123000889012" in row 1
Then field "zaqrreferenz" has value "210000000003139471430009017" in row 1
Then field "refpruef" has value "QRR" in row 1
Then field "kodzeile" has value "Mein Zusatztext EUR" in row 1
And I respond with answer "ja" to the dialog with id "588"
And I save the current editor

#Hat ZAHLAUS den Status grün
Given I open the infosystem "ZAHLAUS"
And I set field "bankdatei" to "4"
Then field "zaraum" has value "Inlandszahlungen"
Then field "statusz" has value "icon:ball_green"
Then field "tiban" has value "CH4431999123000889012" in row 1
Then field "ttlnr" has value "CH4431999123000889012" in row 1
Then field "ttaart" has value "ZA3.QRR" in row 1
Then field "tstatusz" has value "icon:ball_green" in row 1
And I press button "bdtrerzeug"
And I save the current editor
