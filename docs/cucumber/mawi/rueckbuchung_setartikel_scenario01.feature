# *****************************************************************************
#  Name             : rueckbuchung_setartikel_scenario01.feature
#  Autor            : carue
#  Verantwortlich   : carue
#  Kontrolle        : ak
#  Funktion         : Testet Ruecklieferung von Setartikeln im Verkauf
#
# Testszenario:
#  - Zugang EK-Rechnung mit Lagerbewegung auf Platz WELA
#  - Umbuchung je 2x auf MLF01 und 2x auf ZLQM
#  - Umlagerung je 1x 50 Stueck von MLF01 nach L3F1 und 1x 50 Stueck von ZLQM nach L3F1
#  - Ruecklieferung des Zugangs von L3F1
#  - Storno der Ruecklieferung
#
# *****************************************************************************
@persistent
Feature: rueckbuchung_setartikel_scenario01.feature
Background:
Given I set the fake date to "12.01.95"

Scenario: 00 Setartikel anlegen
Given I open an editor "Setkomponente1" from table "(Part):(Product)" with command "STORE" for record "SETKOMPONENTE1"
And I set field "such" to "SETKOMPONENTE1"
And I set field "namebspr" to "Komponente 1 fuer Setartikel"
And I set field "efrist" to "1"
And I set field "epr" to "2,00"
And I save the current editor
Given I open an editor "Setkomponente2" from table "(Part):(Product)" with command "STORE" for record "SETKOMPONENTE2"
And I set field "such" to "SETKOMPONENTE2"
And I set field "namebspr" to "Komponente 2 fuer Setartikel"
And I set field "efrist" to "1"
And I set field "epr" to "2,50"
And I save the current editor
Given I open an editor "Setkomponente3" from table "(Part):(Product)" with command "STORE" for record "SETKOMPONENTE3"
And I set field "such" to "SETKOMPONENTE3"
And I set field "namebspr" to "Komponente 3 fuer Setartikel"
And I set field "efrist" to "1"
And I set field "epr" to "4,00"
And I save the current editor

Given I open an editor "BaugruppeSet" from table "(Part):(Product)" with command "STORE" for record "BG_SET"
And I set field "such" to "BG_SET"
And I set field "namebspr" to "Baugruppe Set"
And I set field "bsart" to "Eigenfertigung"
And I set field "earta" to "über Stückliste"
And I set field "elex" to "SETKOMPONENTE1" in row 1
And I set field "elanzahl" to "1" in row 1
And I create a new row at the end of the table
And I set field "elex" to "SETKOMPONENTE2" in row 2
And I set field "elanzahl" to "2" in row 2
And I create a new row at the end of the table
And I set field "elex" to "A SCHRAUBEN" in row 4
And I save the current editor

Given I open an editor "Setartikel" from table "(Part):(Product)" with command "STORE" for record "SETARTIKEL"
And I set field "such" to "SETARTIKEL"
And I set field "namebspr" to "Setartikel"
And I set field "bsart" to "Eigenfertigung"
And I set field "earta" to "über Stückliste"
And I set field "elex" to "SETKOMPONENTE3" in row 1
And I set field "elanzahl" to "3" in row 1
And I create a new row at the end of the table
And I set field "elex" to "BG_SET" in row 2
And I set field "elanzahl" to "1" in row 2
And I create a new row at the end of the table
And I set field "elex" to "A SCHRAUBEN" in row 4
And I save the current editor

Scenario: 01 VK-Lieferschein fuer Setartikel erzeugen
Given I open an editor "Vkls01" from table "(Sales):(PackingSlip)" with command "NEW" for record ""
And I set field "nummer" to "1vkls"
And I set field "kunde" to "RADSHOP"
And I create a new row at the end of the table
And I set field "artikel" to "SETARTIKEL" in row 1
And I set field "mge" to "10" in row 1
And I set field "ueb" to "ja"
And I save the current editor

# Ruecklieferung
Given I open an editor "Vkrls01" from table "(Sales):(PackingSlip)" with command "RETURN" for record from editor "Vkls01"
And I set field "nummer" to "1vkrls"
And I set field "mge" to "-1" in row 1
And I set field "ueb" to "ja"
And I save the current editor

# Ruecklieferung Stornieren
Given I open an editor "Vksrls01" from table "(Sales):(PackingSlip)" with command "REVERSAL" for record from editor "Vkrls01"
And I set field "nummer" to "1vksrls"
And I save the current editor

#Lieferschein stornieren
Given I open an editor "Vksls01" from table "(Sales):(PackingSlip)" with command "REVERSAL" for record from editor "Vkls01"
And I set field "nummer" to "1vksls"
And I save the current editor

