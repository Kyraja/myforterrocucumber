# *****************************************************************************
#  Name           : inv_kvert_objektsperre.feature   
#  Autor          : sih
#  Verantwortlich : sih
#  Funktion       : Plausibilisierung von gesperrten Kostenstellen und Kostenverteilern mit gesperrten Objekten in Inventurzähllisten
#
# *****************************************************************************
#
@persistent
Feature: Stamm-Kostenverteiler mit gesperrten Objekten in Inventurzähllisten
Background: 
Given I set the fake date to "20.12.1995"

Scenario: 01 Stammdaten
Given I open an editor "kostenverteiler-40" from table "(Account):(CostDistribution)" with command "NEW" for record ""
And I set field "nummer" to "40"
And I set field "such" to "kv40"
And I create a new row at the end of the table
And I set field "kstelle" to "1100" in row 1
And I set field "proz" to "40" in row 1
And I create a new row at the end of the table
And I set field "kstelle" to "100010" in row 2
And I set field "proz" to "60" in row 2
And I save the current editor

Given I open an editor "Kst-Sperre" from table "(Account)(CostCenter)" with command "UPDATE" for record "1100"
And I set field "sperrkonfigurationneu" to "Standard-Kostenstellensperre"
And I save the current editor
And I close the current editor

Scenario: 02 Zählliste erstellen
# Zaehlliste anlegen 
Given I open an editor "Zaehlliste1" from table "(Stocktaking):(EnterQuantitiesCounted)" with command "NEW" for record ""
And I set field "such" to "ZAEHL_1"
And I append rows
    | artikel  | platz | gebeinh | gebf  |
    | E2       |  F1   | St      |  1    |
    | E2       |  F2   | St      |  1    |
    | E3       |  F1   | St      |  1    |
    | E3       |  F2   | St      |  1    |
    | BG1      |  F1   | St      |  1    |
And I save the current editor

Scenario: 03  Inventur eroeffnen
Given I open an editor "InvEroeffnung" from table "(Stocktaking)" with command "RELEASE" for record "ZAEHL_1" and menu choice "Ja"
And I save the current editor

Scenario: 04 Zählliste ändern - Bestand eintragen
Given I open an editor "InvBestandErfassen" from table "(Stocktaking):(EnterQuantitiesCounted)" with command "UPDATE" for record "ZAEHL_1"
Then table has values
    | artikel  | platz | gebeinh | gebf  | ibest |
    | BG1      |  F1   | Stück   |  1    |    0  |
    | E3       |  F2   | Stück   |  1    |    0  |
    | E3       |  F1   | Stück   |  1    |    0  |
    | E2       |  F2   | Stück   |  1    |    0  |
    | E2       |  F1   | Stück   |  1    |    0  |
And I modify table
    | !row | nbest |
    |  1   |  3    |
    |  2   |  5    |
    |  3   |  1    |
    |  4   |  5    |
    |  5   |  4    |
And I save the current editor

Scenario: 05 Zählliste ändern - Kostenobjekte eintragen, Kostenverteiler 40 mit hart gesperrtem Kostenobjekt
Given I open an editor "ZaehllisteEditieren" from table "(Stocktaking):(EnterQuantitiesCounted)" with command "UPDATE" for record "ZAEHL_1"
Then setting field "kstelle" to "40" in row 1 throws the exception "3602"
And I set field "kstelle" to "20" in row 1
And I set field "kstelle" to "1400" in row 2
And I set field "kstelle" to "5400" in row 3
And I save the current editor

Scenario: 06 Zählliste ändern - Leerzeilen einfügen
Given I open an editor "ZaehllisteEditieren" from table "(Stocktaking):(EnterQuantitiesCounted)" with command "UPDATE" for record "ZAEHL_1"
And I create a new row at position 1
And I create a new row at the end of the table
And I save the current editor

Scenario: 07 Kst 5100 (ist in KV 20 enthalten) hart sperren und Zählliste per ändern aufrufen und speichern
Given I open an editor "Kst-Sperre" from table "(Account)(CostCenter)" with command "UPDATE" for record "5100"
And I set field "sperrkonfigurationneu" to "Standard-Kostenstellensperre"
And I save the current editor
And I close the current editor

Given I open an editor "ZaehllisteEditieren" from table "(Stocktaking):(EnterQuantitiesCounted)" with command "UPDATE" for record "ZAEHL_1"
Then saving the current editor throws the exception "3602"
And I close the current editor


Scenario: 08 Kostenstelle 5400 hart sperren sperren und Zählliste per ändern aufrufen und speichern
Given I open an editor "Kst-Sperre" from table "(Account)(CostCenter)" with command "UPDATE" for record "5400"
And I set field "sperrkonfigurationneu" to "Standard-Kostenstellensperre"
And I save the current editor
And I close the current editor

Given I open an editor "ZaehllisteEditieren" from table "(Stocktaking):(EnterQuantitiesCounted)" with command "UPDATE" for record "ZAEHL_1"
Then saving the current editor throws the exception "4806"
And I close the current editor

Scenario: 09 Feststellen dass Zählliste hart und Hinweis-Gesperrtes Kostenobjekt enthält
Given I open an editor "HinweisGesperrteKst" from table "(Account):(CostCenter)" with command "VIEW" for record "1400"
Then field "sperrkonfigurationneu" has value "Individuelle Kostenstellensperre, nur Hinweis"
And I close the current editor

Given I open an editor "GesperrteKst" from table "(Account):(CostCenter)" with command "VIEW" for record "5400"
Then field "sperrkonfigurationneu" has value "Standard-Kostenstellensperre"
And I close the current editor

Given I open an editor "ZaehllisteEditieren" from table "(Stocktaking):(EnterQuantitiesCounted)" with command "UPDATE" for record "ZAEHL_1"
Then field "kstelle" has value "1400" in row 2
Then field "kstelle" has value "5400" in row 3
And I close the current editor

Scenario: 10 Bestandabschluss - trotz hart gesperrter Kostenobjekte
Given I open an editor "BestAbschluss" from table "(Stocktaking)" with command "DONE" for record "ZAEHL_1" and menu choice "Ja"
Then saving the current editor throws the exception "4806"
And I close the current editor

# Scenario: 11 Inventurabschluss - trotz hart gesperrter Kostenobjekte
# Folgendes funktioniert nicht. Daher im testbett dieses per edp abgebildet.
# Given I open an editor "Invbearb" from table "(Stocktaking)" with command "TRANSFER" for record "ZAEHL_1" and menu choice "Ja"
# Then saving the current editor throws the exception "1665"
# And I close the current editor

