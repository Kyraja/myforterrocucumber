@persistent
Feature: korezwangneu
Background:
Given I set the fake date to "04.01.2002"

Scenario: Fibubuchungen korezwang
Given I set the fake date to "04.01.2002"

Given I open an editor "Buchung1" from table "(Entry):(Entry)" with command "NEW" for record ""
And I set field "text" to "konto m. zwang, budat vor start"
And I set field "such" to "mkostvs"
And I set field "budat" to "31.12.01"
And I create a new row at the end of the table
And I set field "konto" to "50000" in row 1
And I set field "ewhbetr" to "30" in row 1
# falldef. s. testbett: fuer die prueffunktion wird der fall ggf. im nachfolgetest fehlerhaft gemacht
And I set field "ptext" to "fall 15 (24 wenn koart gef.)" in row 1
And I create a new row at the end of the table
And I set field "konto" to "50000" in row 2
And I set field "ewhbetr" to "40" in row 2
And I set field "kstelle" to "100" in row 2
And I set field "ptext" to "fall 15 (24 wenn koart gef.)" in row 2
And I create a new row at the end of the table
And I set field "konto" to "10000" in row 3
And I respond with answer "Ja" to the dialog with id "1941"
And I save the current editor
And I close the current editor

Given I open an editor "Buchung2" from table "(Entry):(Entry)" with command "NEW" for record ""
And I set field "text" to "konto m. zwang, budat nach start"
And I set field "such" to "mkostns"
And I set field "budat" to "04.01.02"
And I create a new row at the end of the table
And I set field "konto" to "50000" in row 1
And I set field "ewhbetr" to "50" in row 1
And I set field "ptext" to "fall 24 (15 wenn koart leer)" in row 1
And I create a new row at the end of the table
And I set field "konto" to "50000" in row 2
And I set field "ewhbetr" to "60" in row 2
And I set field "kstelle" to "100000" in row 2
And I set field "ptext" to "fall 24 (15 wenn koart leer)" in row 2
And I create a new row at the end of the table
And I set field "konto" to "10000" in row 3
# 1415 de      |Bitte Kostenstelle oder Kostenträger eintragen
And saving the current editor throws the exception "1415"
And I set field "kstelle" to "101" in row 1
And I respond with answer "Ja" to the dialog with id "1941"
And I save the current editor
And I close the current editor

# =============================================================================

Given I open an editor "konto-ohne-korezwang" from table "(Account):(Account)" with command "VIEW" for record "47000"
Then field "kost" has value "nein"
And I close the current editor

Given I open an editor "Buchung3" from table "(Entry):(Entry)" with command "NEW" for record ""
And I set field "text" to "konto oh. zwang, budat vor start"
And I set field "such" to "OHKOSTvs"
And I set field "budat" to "31.12.01"
And I create a new row at the end of the table
And I set field "konto" to "47000" in row 1
And I set field "ewhbetr" to "30" in row 1
And I set field "ptext" to "fall  9 (10 wenn koart gef.)" in row 1
And I create a new row at the end of the table
And I set field "konto" to "47000" in row 2
And I set field "ewhbetr" to "40" in row 2
And I set field "kstelle" to "100" in row 2
And I set field "ptext" to "fall 11 (12 wenn koart gef.)" in row 2
And I create a new row at the end of the table
And I set field "konto" to "10000" in row 3
And I respond with answer "Ja" to the dialog with id "1941"
And I save the current editor
And I close the current editor

Given I open an editor "Buchung4" from table "(Entry):(Entry)" with command "NEW" for record ""
And I set field "text" to "konto oh. zwang, budat nach start"
And I set field "such" to "ohkostns"
And I set field "budat" to "04.01.02"
And I create a new row at the end of the table
And I set field "konto" to "47000" in row 1
And I set field "ewhbetr" to "50" in row 1
And I set field "ptext" to "fall 17 (18 wenn koart gef.)" in row 1
And I create a new row at the end of the table
And I set field "konto" to "47000" in row 2
And I set field "ewhbetr" to "60" in row 2
And I set field "kstelle" to "100000" in row 2
And I set field "ptext" to "fall 19 (20 wenn koart gef.)" in row 2
And I create a new row at the end of the table
And I set field "konto" to "10000" in row 3
And I respond with answer "Ja" to the dialog with id "1941"
And I save the current editor
And I close the current editor



Scenario: statistische buchungen korezwang

Given I set the fake date to "04.01.2002"

Given I open an editor "Buchung1" from table "(Entry):(StatisticalEntry)" with command "NEW" for record ""
And I set field "text" to "konto m. zwang, budat vor start"
And I set field "such" to "mkostvs"
And I set field "budat" to "31.12.01"
And I create a new row at the end of the table
And I set field "konto" to "99800" in row 1
And I set field "sbetrag" to "30" in row 1
And I set field "ptext" to "fall 15 (24 wenn koart gef.)" in row 1
And I create a new row at the end of the table
And I set field "konto" to "99800" in row 2
And I set field "kstelle" to "100" in row 2
And I set field "ptext" to "fall 15 (24 wenn koart gef.)" in row 2
And I respond with answer "Ja" to the dialog with id "1941"
And I save the current editor
And I close the current editor

Given I open an editor "Buchung2" from table "(Entry):(StatisticalEntry)" with command "NEW" for record ""
And I set field "text" to "konto m. zwang, budat nach start"
And I set field "such" to "mkostns"
And I set field "budat" to "04.01.02"
And I create a new row at the end of the table
And I set field "konto" to "99900" in row 1
And I set field "sbetrag" to "50" in row 1
And I set field "ptext" to "fall 24 (15 wenn koart leer)" in row 1
And I create a new row at the end of the table
And I set field "konto" to "99900" in row 2
And I set field "kstelle" to "100000" in row 2
And I set field "ptext" to "fall 24 (15 wenn koart leer)" in row 2
# 1415 de      |Bitte Kostenstelle oder Kostenträger eintragen
And saving the current editor throws the exception "1415"
And I set field "kstelle" to "101" in row 1
And I respond with answer "Ja" to the dialog with id "1941"
And I save the current editor
And I close the current editor

# =============================================================================

Given I open an editor "konto-ohne-korezwang" from table "(Account):(Account)" with command "COPY" for record "99900"
And I set field "nummer" to "99773"
And I set field "kost" to "nein"
And I delete row at position !lastRow
And I save the current editor
And I close the current editor

Given I open an editor "konto-ohne-korezwang" from table "(Account):(Account)" with command "VIEW" for record "99773"
Then field "kost" has value "nein"
And I close the current editor

Given I open an editor "Buchung3" from table "(Entry):(StatisticalEntry)" with command "NEW" for record ""
And I set field "text" to "konto oh. zwang, budat vor start"
And I set field "such" to "OHkoKOSTvs"
And I set field "budat" to "31.12.01"
And I create a new row at the end of the table
And I set field "konto" to "99773" in row 1
And I set field "sbetrag" to "30" in row 1
And I set field "ptext" to "fall  9 (10 wenn koart gef.)" in row 1
And I create a new row at the end of the table
And I set field "konto" to "99773" in row 2
And I set field "kstelle" to "100" in row 2
And I set field "ptext" to "fall 11 (12 wenn koart gef.)" in row 2
And I respond with answer "Ja" to the dialog with id "1941"
And I save the current editor
And I close the current editor

Given I open an editor "Buchung4" from table "(Entry):(StatisticalEntry)" with command "NEW" for record ""
And I set field "text" to "konto oh. zwang, budat nach start"
And I set field "such" to "ohkostns"
And I set field "budat" to "04.01.02"
And I create a new row at the end of the table
And I set field "konto" to "99773" in row 1
And I set field "sbetrag" to "50" in row 1
And I set field "ptext" to "fall 17 (18 wenn koart gef.)" in row 1
And I create a new row at the end of the table
And I set field "konto" to "99773" in row 2
And I set field "kstelle" to "100000" in row 2
And I set field "ptext" to "fall 19 (20 wenn koart gef.)" in row 2
And I respond with answer "Ja" to the dialog with id "1941"
And I save the current editor
And I close the current editor
