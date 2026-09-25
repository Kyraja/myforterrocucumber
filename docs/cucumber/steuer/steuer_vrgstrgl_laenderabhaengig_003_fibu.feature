# *****************************************************************************
#  Name             : steuer_vrgstrgl_laenderabhaengig_003_fibu.feature
#  Autor            : wane
#  Verantwortlich   : wane
#  Kontrolle        :
#  Funktion         : Vorbelegung der VRGSTRGL in Finanzbuchungen mit Beruecksichtigung
#                     von Laender/Regionen der Kunden/Lieferanten/Mitarbeiter
#
#
# *****************************************************************************
@persistent
Feature: steuer_vrgstrgl_laenderabhaengig_003_fibu.feature
Background:


Scenario: FiBu mit Lieferanten

Given I open an editor "Buchung1" from table "(Entry):(Entry)" with command "NEW" for record ""
And I set field "butyp" to "Rechnungsbuchung" in row 0
And I set field "klm" to "L 10010" in row 0
Then field "vrgstrgl" has value "EKIN" in row 0
Then field "ustid" has value "DE123456" in row 0
# ---- Personenkontowechsel ----
And I set field "klm" to "L 10011" in row 0
Then field "vrgstrgl" has value "EKIN" in row 0
Then field "ustid" has value "DE123456" in row 0
# ---- Personenkontowechsel ----
And I set field "klm" to "L 40002" in row 0
Then field "vrgstrgl" has value "EKBAD" in row 0
Then field "ustid" has value "DE123456" in row 0
# ---- Personenkontowechsel ----
And I set field "klm" to "L 60013" in row 0
Then field "vrgstrgl" has value "EKUSA" in row 0
Then field "ustid" is empty in row 0
# ---- Personenkontowechsel ----
And I set field "klm" to "L 840015" in row 0
Then field "vrgstrgl" has value "EKNY" in row 0
Then field "ustid" is empty in row 0
# ---- Personenkontowechsel ----
And I set field "klm" to "L 2011" in row 0
Then field "vrgstrgl" has value "EKTOS" in row 0
Then field "ustid" has value "IT123456" in row 0
#--
And I set field "ustid" to "" in row 0
Then field "vrgstrgl" has value "EKIN" in row 0
#--
And I set field "ustid" to "FR123456" in row 0
Then field "vrgstrgl" has value "EKBLA4" in row 0
# ---- Personenkontowechsel ----
And I set field "klm" to "L 2012" in row 0
Then field "vrgstrgl" has value "EKITAL" in row 0
Then field "ustid" has value "IT123545" in row 0
And I close the current editor
###############################################################################

Scenario: FiBu mit Kunden

Given I open an editor "Buchung2" from table "(Entry):(Entry)" with command "NEW" for record ""
And I set field "butyp" to "Rechnungsbuchung" in row 0
And I set field "klm" to "K 050" in row 0
Then field "vrgstrgl" has value "VKIN" in row 0
Then field "ustid" has value "DE123456" in row 0
# ---- Personenkontowechsel ----
And I set field "klm" to "K 051" in row 0
Then field "vrgstrgl" has value "VKIN" in row 0
Then field "ustid" has value "DE123456" in row 0
# ---- Personenkontowechsel ----
And I set field "klm" to "K 20587" in row 0
Then field "vrgstrgl" has value "VKBAD" in row 0
Then field "ustid" has value "DE123456" in row 0
# ---- Personenkontowechsel ----
And I set field "klm" to "K 20586" in row 0
Then field "vrgstrgl" has value "VKIN" in row 0
Then field "ustid" has value "DE123456" in row 0
# ---- Personenkontowechsel ----
And I set field "klm" to "K 40001" in row 0
Then field "vrgstrgl" has value "VKMEX" in row 0
Then field "ustid" is empty in row 0
# ---- Personenkontowechsel ----
And I set field "klm" to "K 40002" in row 0
Then field "vrgstrgl" has value "VKNY" in row 0
Then field "ustid" is empty in row 0
# ---- Personenkontowechsel ----
And I set field "klm" to "K 2011" in row 0
Then field "vrgstrgl" has value "VKTOS" in row 0
Then field "ustid" has value "IT123456" in row 0
#--
And I set field "ustid" to "FR123456" in row 0
Then field "vrgstrgl" has value "VKBLA2" in row 0
# ---- Personenkontowechsel ----
And I set field "klm" to "K 2012" in row 0
Then field "vrgstrgl" has value "VKITAL" in row 0
Then field "ustid" has value "IT123545" in row 0
And I close the current editor
###############################################################################

Scenario: FiBu mit Mitarbeiter

Given I open an editor "Buchung3" from table "(Entry):(Entry)" with command "NEW" for record ""
And I set field "butyp" to "Rechnungsbuchung" in row 0
And I set field "klm" to "M 77711" in row 0
Then field "vrgstrgl" has value "EKIN" in row 0
Then field "ustid" is empty in row 0
# ---- Personenkontowechsel ----
And I set field "klm" to "M 77712" in row 0
Then field "vrgstrgl" has value "EKBAD" in row 0
Then field "ustid" is empty in row 0
# auch moeglich
And I set field "vrgstrgl" to "VKBAD" in row 0
Then field "ustid" is empty in row 0
# ---- Personenkontowechsel ----
And I set field "klm" to "M 77713" in row 0
Then field "vrgstrgl" has value "EKIN" in row 0
Then field "ustid" is empty in row 0
# auch moeglich
And I set field "vrgstrgl" to "VKIN" in row 0
Then field "ustid" is empty in row 0
# ---- Personenkontowechsel ----
And I set field "klm" to "M 77714" in row 0
Then field "vrgstrgl" has value "EKUSA" in row 0
Then field "ustid" is empty in row 0
# auch moeglich
And I set field "vrgstrgl" to "VKUSA" in row 0
Then field "ustid" is empty in row 0
# ---- Personenkontowechsel ----
And I set field "klm" to "M 77724" in row 0
Then field "vrgstrgl" has value "EKIN" in row 0
Then field "ustid" is empty in row 0
And I set field "ustid" to "IT123456" in row 0
Then field "vrgstrgl" has value "EKITAL" in row 0
# auch moeglich
And I set field "vrgstrgl" to "VKITAL" in row 0
Then field "ustid" is not empty in row 0
# ---- Personenkontowechsel ----
And I set field "klm" to "M 77723" in row 0
Then field "vrgstrgl" has value "EKNY" in row 0
Then field "ustid" is empty in row 0
And I set field "ustid" to "FR123456" in row 0
Then field "vrgstrgl" has value "EKNY" in row 0
Then field "ustid" is not empty in row 0
# auch moeglich
And I set field "vrgstrgl" to "VKNY" in row 0
Then field "ustid" is not empty in row 0
# ---- Personenkontowechsel ----
And I set field "klm" to "M 77716" in row 0
Then field "vrgstrgl" has value "EKIN" in row 0
Then field "ustid" is empty in row 0
And I set field "ustid" to "FR123456" in row 0
Then field "vrgstrgl" has value "EKBLA4" in row 0
Then field "ustid" is not empty in row 0
# auch moeglich
And I set field "vrgstrgl" to "VKTOS" in row 0
Then field "ustid" is not empty in row 0
# auch moeglich
And I set field "vrgstrgl" to "EKTOS" in row 0
Then field "ustid" is not empty in row 0
#--
And I set field "ustid" to "AT123456" in row 0
Then field "vrgstrgl" has value "EKEUSOFORT" in row 0
# auch moeglich
And I set field "vrgstrgl" to "VKEUFREI" in row 0
Then field "ustid" is not empty in row 0
# ---- Personenkontowechsel ----
And I set field "klm" to "M 77720" in row 0
Then field "vrgstrgl" has value "EKBAD" in row 0
Then field "ustid" is empty in row 0
# auch moeglich
And I set field "ustid" to "AT123456" in row 0
Then field "vrgstrgl" has value "" in row 0
And I close the current editor
###############################################################################

