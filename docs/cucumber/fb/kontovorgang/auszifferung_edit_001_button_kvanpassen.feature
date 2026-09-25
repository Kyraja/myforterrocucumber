# *****************************************************************************
#  Name             : auszifferung_edit_001_button_kvanpassen.feature
#  Autor            : wane
#  Verantwortlich   : wane
#  Kontrolle        :
#  Funktion         : Nutzung von Button "kvanpassen" in der Auszifferungsmaske (V-138-02)
#
# *****************************************************************************
@persistent
Feature: auszifferung_edit_001_button_kvanpassen.feature
Background: 

Given I set the fake date to "05.10.95"


Scenario: Auszifferung: Button "kvanpassen"

Given I open an editor "ausziffern-001" from table "(AccountTransaction):(Allocation)" with command "NEW" for record ""
And I set field "konto" to "K 008" in row 0
And I set field "geschl" to "ja" in row 0
Then field "kvoffen" has value "ja"
Then field "geschl" has value "ja"
And I press button "ladetab" in row 0

Then the table has 6 rows
# Zeile 1
Then field "tkvnum" has value "1" in row 1
Then field "tbetrag" has value "1000.66" in row 1
# Zeile 2
Then field "tkvnum" has value "b1_002" in row 2
Then field "tbetrag" has value "10000.00" in row 2
# Zeile 3
Then field "tkvnum" has value "b1_034" in row 3
Then field "tbetrag" has value "10355.00" in row 3
# Zeile 4
Then field "tkvnum" has value "b1_d03" in row 4
Then field "tbetrag" has value "0.02" in row 4
#
And I set field "kvneu" to "1kvBUTTON" in row 0
Then field "kvnum" has value "1kvBUTTON"
Then field "kvanzahl" has value "0"
Then field "markanzahl" has value "0"
#
And I set field "tmarke" to "ja" in row 1
And I set field "tmarke" to "ja" in row 2
And I set field "tmarke" to "ja" in row 3
Then field "kvneu" has value "1kvBUTTON"
Then field "kvnum" has value "1kvBUTTON"
Then field "kvschl" has value "nein"
Then field "kvanzahl" has value "0"
Then field "markanzahl" has value "3"
# 
And I press button "kvanpassen" in row 0
Then the table has 6 rows
Then field "kvoffen" has value "ja"
Then field "geschl" has value "ja"
Then field "konto" has value "K 008"
Then field "kvneu" has value ""
Then field "kvnum" has value "1kvBUTTON"
Then field "kvschl" has value "nein"
Then field "kvanzahl" has value "3"
Then field "markanzahl" has value "0"
Then field "tkvnum" has value "1kvBUTTON" in row 1
Then field "tkvnum" has value "1kvBUTTON" in row 2
Then field "tkvnum" has value "1kvBUTTON" in row 3
#
# Erzeugen und abschliessen
# die abgeschlossenen KVs nicht mehr laden
And I set field "geschl" to "nein" in row 0
And I set field "kvneu" to "2kvBUTTON" in row 0
And I set field "kvschl" to "ja" in row 0
And I set field "tmarke" to "ja" in row 1
And I set field "tmarke" to "ja" in row 2
And I set field "tmarke" to "ja" in row 3
Then field "kvneu" has value "2kvBUTTON"
Then field "kvnum" has value "2kvBUTTON"
Then field "kvschl" has value "ja"
Then field "kvanzahl" has value "0"
Then field "markanzahl" has value "3"
#
And I press button "kvanpassen" in row 0
Then the table has 3 rows
Then field "kvoffen" has value "ja"
Then field "geschl" has value "nein"
Then field "konto" has value "K 008"
Then field "kvneu" has value ""
Then field "kvnum" has value "2kvBUTTON"
Then field "kvschl" has value "nein"
Then field "kvanzahl" has value "3"
Then field "markanzahl" has value "0"
#
# 8565 TX=de   |Sie haben entweder keine Zeilen markiert oder keine neue Kontovorgangsnummer vergeben
Then saving the current editor throws the exception "8565"
And I close the current editor


Given I open an editor "kontovorgang-001" from table "(AccountTransaction):(AccountTransaction)" with command "VIEW" for record "+K008_1KVBUTTON"
Then field "saldo" has value "0.00"
Then field "anzahlzeil" has value "0"
Then field "kvoffen" has value "nein"
Then field "gdmgeschl" has value ""
And I close the current editor


Given I open an editor "kontovorgang-002" from table "(AccountTransaction):(AccountTransaction)" with command "VIEW" for record "+K008_2KVBUTTON"
Then field "saldo" has value "-1355.66"
Then field "anzahlzeil" has value "3"
Then field "kvoffen" has value "nein"
Then field "gdmgeschl" has value "05.10.95"
And I close the current editor

