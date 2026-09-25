# *****************************************************************************
#  Name             : ref_138_kontovorgang_edit_001.feature
#  Autor            : wane
#  Verantwortlich   : wane
#  Kontrolle        :
#  Funktion         : Editierbarkeit im der Maske "Kontovorgang"
#
# *****************************************************************************
@persistent
Feature: ref_138_kontovorgang_edit_001.feature
Background:

# Given I set the fake date to "7.1.01"


Scenario: Kontovorgang editieren; sy

# Given I'm logged in with password "sy"


Given I open an editor "kontovorgang" from table "(AccountTransaction):(AccountTransaction)" with command "UPDATE" for record "12"
# it-Felder
Then field "such" is modifiable
Then field "nummer" is not modifiable
And I set field "name" to "Verfolgung von ..."
# kv-Felder
Then field "konto" is not modifiable
Then field "kvnum" is not modifiable
Then field "saldo" is not modifiable
Then field "kvoffen" is not modifiable
Then field "kvgjahr" is not modifiable
Then field "gdmgeschl" is not modifiable
Then field "gdsergeschl" is not modifiable
Then field "anzahlzeil" is not modifiable
Then field "sumsoll" is not modifiable
Then field "sumhaben" is not modifiable
Then field "erstbudat" is not modifiable
Then field "letztbudat" is not modifiable
#
And I save the current editor
And I close the current editor
# =========================================================================================


Scenario: Kontovorgang editieren; Wartung

Given I'm logged in with password "annette"


Given I open an editor "kontovorgang2" from table "(AccountTransaction):(AccountTransaction)" with command "UPDATE" for record "23"
# it-Felder
Then field "such" is modifiable
Then field "nummer" is modifiable
And I set field "such" to "TEST123456789"
And I set field "nummer" to "100aaaaaaaaa"
And I set field "name" to "Verfolgung von ..."
#
And I save the current editor
And I close the current editor
# =========================================================================================
