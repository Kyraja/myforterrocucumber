@persistent
Feature: stamm_preise.feature

Background:
And I set the fake date to "07.01.1995"

# **********************************************************************************
# Name             : stamm_preise.feature
# Autor            : mibr
# Verantwortlich   : teampss
# Funktion         : Stammdatenmaske Preise/Rabatte (Plausis und Schreibschutz)
#
# **********************************************************************************

Scenario: Schreibschutzpruefungen
Given I open an editor "PREIS" from table "(Pricing):(Pricing)" with command "NEW" for record ""
Then field "typ" is modifiable
And I set field "rpreis" to "1"
Then field "typ" is not modifiable
And I set field "rpreis" to "0"
Then field "typ" is modifiable
# zwei Mal testen
And I set field "rpreis" to "1"
Then field "typ" is not modifiable
And I set field "rpreis" to "0"
Then field "typ" is modifiable
And I set field "spreis" to "1"
Then field "typ" is not modifiable
And I set field "spreis" to "0"
Then field "typ" is modifiable
And I set field "nrpreis" to "1"
Then field "typ" is not modifiable
And I set field "nrpreis" to "0"
Then field "typ" is modifiable
And I set field "nspreis" to "1"
Then field "typ" is not modifiable
And I set field "nspreis" to "0"
Then field "typ" is modifiable

#gruppenpr auf nein -> kein Schreibschutz
And I set field "gruppenpr" to "nein"
Then field "spreis" is modifiable
Then field "rpreis" is modifiable
Then field "nspreis" is modifiable
Then field "nrpreis" is modifiable

#gruppenpr = ja -> typ und spreis, npreis, nspreis, nrpreis sind schreibgeschützt
And I set field "gruppenpr" to "yes"
Then field "typ" is modifiable
Then field "spreis" is not modifiable
Then field "rpreis" is not modifiable
Then field "nspreis" is not modifiable
Then field "nrpreis" is not modifiable

And I save the current editor


#Erneut diesen Datensatz oeffnen
Given I open an editor "PREIS2" from table "(Pricing):(Pricing)" with command "UPDATE" for record from editor "PREIS"
#-> typ und spreis, npreis, nspreis, nrpreis sind schreibgeschützt
Then field "typ" is modifiable
Then field "spreis" is not modifiable
Then field "rpreis" is not modifiable
Then field "nspreis" is not modifiable
Then field "nrpreis" is not modifiable
And I close the current editor
