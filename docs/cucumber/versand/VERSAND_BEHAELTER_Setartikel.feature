# *****************************************************************************
#  Name             : VERSAND_BEHAELTER_Setartikel.feature
#  Autor            : lschneider
#  Verantwortlich   : carue
#  Kontrolle        : drpf
#  Funktion         : Setartikel in Behaelter verpacken und versenden
#
# *****************************************************************************
@persistent
Feature: VERSAND_BEHAELTER_Setartikel.feature
Background:
Given I set the fake date to "02.01.1995"

##################################################################################################################

@Stammdaten
Scenario: Verkaufsteil Setartikel anlegen
Given I open an editor "Lieferant" from table "(Vendor):(Vendor)" with command "STORE" for record "SETL"
And I set field "such" to "SETL"
And I set field "namebspr" to "Set Lieferant"
And I set field "zbed" to "201"
And I save the current editor

Given I open an editor "artikel" from table "(Part):(Product)" with command "STORE" for record "SETKOMPONENTE1"
And I set field "such" to "SETKOMPONENTE1"
And I set field "namebspr" to "Komponente 1 fuer Setartikel"
And I set field "chverfolgung" to "Chargenverfolgung"
And I set field "chimlager" to "JA"
And I set field "lief" to "SETL"
And I set field "efrist" to "1"
And I set field "epr" to "2,00"
And I save the current editor
Given I open an editor "artikel" from table "(Part):(Product)" with command "STORE" for record "SETKOMPONENTE2"
And I set field "such" to "SETKOMPONENTE2"
And I set field "namebspr" to "Komponente 2 fuer Setartikel"
And I set field "chverfolgung" to "Chargenverfolgung"
And I set field "chimlager" to "JA"
And I set field "lief" to "SETL"
And I set field "efrist" to "1"
And I set field "epr" to "2,50"
And I save the current editor
Given I open an editor "artikel" from table "(Part):(Product)" with command "STORE" for record "SETKOMPONENTE3"
And I set field "such" to "SETKOMPONENTE3"
And I set field "namebspr" to "Komponente 3 fuer Setartikel"
And I set field "chverfolgung" to "Chargenverfolgung"
And I set field "chimlager" to "JA"
And I set field "lief" to "SETL"
And I set field "efrist" to "1"
And I set field "epr" to "4,00"
And I save the current editor

Given I open an editor "artikel" from table "(Part):(Product)" with command "STORE" for record "SETARTIKEL_BEHAELTER"
And I set field "such" to "SETARTIKEL_BEHAELTER"
And I set field "namebspr" to "Test Setartikel Behaelterversand"
And I set field "bsart" to "Eigenfertigung"
And I set field "earta" to "über Stückliste"
And I set field "elex" to "SETKOMPONENTE1" in row 1
And I set field "elanzahl" to "1" in row 1
And I create a new row at the end of the table
And I set field "elex" to "SETKOMPONENTE2" in row 2
And I set field "elanzahl" to "1" in row 2
And I create a new row at the end of the table
And I set field "elex" to "SETKOMPONENTE3" in row 3
And I set field "elanzahl" to "1" in row 3
And I create a new row at the end of the table
And I set field "elex" to "A VORBEREITUNG" in row 4
And I save the current editor

##################################################################################################################


Scenario: 1 im VK LS kann kein Behaelter in der Artikelzeile angegeben werden
Given I open an editor "Verkaufslieferschein01" from table "(Sales):(PackingSlip)" with command "NEW" for record ""
And I create a new row at the end of the table
And I set field "artikel" to "SETARTIKEL_BEHAELTER" in row 1
And I set field "mge" to "2" in row 1

Then field "behaelter" is not modifiable in row 1
Then field "exbehnum" is not modifiable in row 1

And I close the current editor


Scenario: 2 im VK LS Ruecklieferung kann kein Behaelter in der Artikelzeile angegeben werden
Given I open an editor "Verkaufslieferschein02" from table "(Sales):(PackingSlip)" with command "NEW" for record ""
And I set field "kunde" to "RADSHOP"
And I create a new row at the end of the table
And I set field "artikel" to "SETARTIKEL_BEHAELTER" in row 1
And I set field "mge" to "10" in row 1
And I set field "ueb" to "JA"
And I save the current editor

Given I open an editor "Verkaufslieferschein03" from table "(Sales):(PackingSlip)" with command "RETURN" for record from editor "Verkaufslieferschein02"
And I set field "mge" to "-2" in row 1
Then field "behaelter" is not modifiable in row 1
Then field "exbehnum" is not modifiable in row 1
And I close the current editor


Scenario: 3 im VK Rechnung kann kein Behaelter in der Artikelzeile angegeben werden
Given I open an editor "VKRechnung" from table "(Sales):(Invoice)" with command "NEW" for record ""
And I create a new row at the end of the table
And I set field "artikel" to "SETARTIKEL_BEHAELTER" in row 1
And I set field "mge" to "2" in row 1

Then field "behaelter" is not modifiable in row 1
Then field "exbehnum" is not modifiable in row 1

And I close the current editor


Scenario: 4 im VK Rechnung Ruecklieferung kann kein Behaelter in der Artikelzeile angegeben werden
Given I open an editor "VKRechnung04a" from table "(Sales):(Invoice)" with command "NEW" for record ""
And I set field "kunde" to "RADSHOP"
And I create a new row at the end of the table
And I set field "artikel" to "SETARTIKEL_BEHAELTER" in row 1
And I set field "mge" to "10" in row 1
And I set field "ueb" to "JA"
And I save the current editor

Given I open an editor "VKRechnung04b" from table "(Sales):(Invoice)" with command "RETURN" for record from editor "VKRechnung04a"
And I set field "mge" to "-2" in row 1
Then field "behaelter" is not modifiable in row 1
Then field "exbehnum" is not modifiable in row 1
And I close the current editor

Scenario Outline: 5 In Lagerbuchung kann kein Behaelter angegeben werden
# Muss nur noch fuer Abgang/Umbuchung getestet werden. Zugang fuer Setartikel ist inzwischen verboten
Given I open an editor "Lagerbuchung" for tip command "(Stockadjustment)" and arguments ""
And I set field "artikel" to "SETARTIKEL_BEHAELTER"
And I set field "buart" to "<buart>"
And I set field "beleg" to "5"
And I set field "beldat" to "."
And I set field "mge" to "1" in row 1

Then field "behaelter" is not modifiable in row 1
Then field "behaelterzu" is not modifiable in row 1

And I close the current editor

Examples: Lagerbuchung

| buart     |
| Abgang    |
| Umbuchung |
