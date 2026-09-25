# *****************************************************************************
#  Name             : rdiff_ev_001_bruttopreise.feature
#  Autor            : wane
#  Verantwortlich   : wane
#  Kontrolle        :
#  Funktion         : Rundungsdifferenzen bei Bruttopreisen in EK/VK
#
#
# *****************************************************************************
@persistent
Feature: rdiff_ev_001_bruttopreise.feature
Background: Rundungsdifferenzen bei Bruttopreisen in EK/VK


@FALL-DIAG-565572
Scenario: DIAG 565572 nachstellen, Teil 1: Daten vorbereiten


Given I open an editor "standartkontierung" from table "(Company):(StandardChartOfAccounts)" with command "UPDATE" for record "4"
And I set field "verbrdiff" to "Rundungsdifferenz auf Bemessungsgrundlage addieren"
Then field "verbrdiff" has value "Rundungsdifferenz auf Bemessungsgrundlage addieren" in row 0
And I save the current editor
And I close the current editor


Given I open an editor "konto" from table "(Account):(Account)" with command "UPDATE" for record "10000"
And I set field "oprel" to "ja"
Then field "oprel" has value "ja" in row 0
And I save the current editor
And I close the current editor


Given I open an editor "konto" from table "(Account):(Account)" with command "UPDATE" for record "44000"
And I set field "oprel" to "ja"
Then field "oprel" has value "ja" in row 0
And I save the current editor
And I close the current editor
###################################################################################################

Scenario: DIAG 565572 nachstellen, Teil 2: EK-RE verbuchen

Given I open an editor "rechnung" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "num4" to "1000-RE1"
And I set field "lief" to "001"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "budat" to "."
And I set field "bem" to "DIAG-565572,"
And I set field "brutto" to "ja"
And I set field "posnsammel" to "ja"
#Erfassungs- und Buchungswaehrung muessen gleich sein
And I set field "erfwaehr" to "EUR"
Then field "fakt" has value "ja" in row 0
When I create a new row at the end of the table
And I set field "artex" to "e1" in row 1
And I set field "mge" to "1" in row 1
And I set field "preis" to "75.78" in row 1
Then field "konto" has value "10000" in row 1
When I create a new row at the end of the table
And I set field "artex" to "e1" in row 2
And I set field "mge" to "1" in row 2
And I set field "preis" to "193.44" in row 2
Then field "konto" has value "10000" in row 2
And I set field "brutto" to "ja"
And I set field "posnsammel" to "ja"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor
And I close the current editor
###################################################################################################

Scenario: DIAG 565572 nachstellen, Teil 3: VK-RE verbuchen

Given I open an editor "rechnung" from table "(Sales):(Invoice)" with command "NEW" for record ""
And I set field "num3" to "1000-RE1"
And I set field "kunde" to "001"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "budat" to "."
And I set field "bem" to "DIAG-565572,"
And I set field "brutto" to "ja"
And I set field "posnsammel" to "ja"
#Erfassungs- und Buchungswaehrung muessen gleich sein
And I set field "waehr" to "EUR"
Then field "fakt" has value "ja" in row 0
When I create a new row at the end of the table
And I set field "artex" to "e1" in row 1
And I set field "mge" to "1" in row 1
And I set field "preis" to "75.78" in row 1
Then field "konto" has value "44000" in row 1
When I create a new row at the end of the table
And I set field "artex" to "e1" in row 2
And I set field "mge" to "1" in row 2
And I set field "preis" to "193.44" in row 2
Then field "konto" has value "44000" in row 2
And I set field "brutto" to "ja"
And I set field "posnsammel" to "ja"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor
And I close the current editor
###################################################################################################

