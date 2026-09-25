@persistent
Feature: korezwangneu
Background:
Given I set the fake date to "04.01.1995"

Scenario: Fibubuchungen korezwang, kein neuer korezwang weil OHNE STARTDATUM
Given I set the fake date to "04.01.1995"

Given I open an editor "kont1-mit-korezwang" from table "(Account):(Account)" with command "UPDATE" for record "50000"
And I set field "kost" to "ja"
And I save the current editor

Given I open an editor "check" from table "(Account):(Account)" with command "VIEW" for record "50000"
Then field "kost" has value "ja"
And I close the current editor

Given I open an editor "Buchung1" from table "(Entry):(Entry)" with command "NEW" for record ""
And I set field "text" to "konto m. zwang"
And I set field "such" to "mkost"
And I set field "budat" to "04.01.95"
And I create a new row at the end of the table
And I set field "konto" to "50000" in row 1
And I set field "ewhbetr" to "50" in row 1
# falldef. s. testbett: fuer die prueffunktion wird der fall ggf. im nachfolgetest fehlerhaft gemacht
And I set field "ptext" to "fall 7 (8 wenn koart gefuellt)" in row 1
And I create a new row at the end of the table
And I set field "konto" to "50000" in row 2
And I set field "ewhbetr" to "60" in row 2
And I set field "kstelle" to "100000" in row 2
And I set field "ptext" to "fall 7 (8 wenn koart gefuellt)" in row 2
And I create a new row at the end of the table
And I set field "konto" to "10000" in row 3
# 1415 de      |Bitte Kostenstelle oder Kostenträger eintragen
# And saving the current editor throws the exception "1415"
# And I set field "kstelle" to "101" in row 1
And I respond with answer "Ja" to the dialog with id "1941"
And I save the current editor
And I close the current editor

# =============================================================================

Given I open an editor "konto-ohne-korezwang" from table "(Account):(Account)" with command "VIEW" for record "47000"
Then field "kost" has value "nein"
And I close the current editor

Given I open an editor "Buchung2" from table "(Entry):(Entry)" with command "NEW" for record ""
And I set field "text" to "konto oh. zwang"
And I set field "such" to "ohkost"
And I set field "budat" to "04.01.95"
And I create a new row at the end of the table
And I set field "konto" to "47000" in row 1
And I set field "ewhbetr" to "50" in row 1
And I set field "ptext" to "fall 1 (2 wenn koart gefuellt)" in row 1
And I create a new row at the end of the table
And I set field "konto" to "47000" in row 2
And I set field "ewhbetr" to "60" in row 2
And I set field "kstelle" to "100000" in row 2
And I set field "ptext" to "fall 3 (4 wenn koart gefuellt)" in row 2
And I create a new row at the end of the table
And I set field "konto" to "10000" in row 3
And I respond with answer "Ja" to the dialog with id "1941"
And I save the current editor
And I close the current editor



Scenario: statistische buchungen korezwang

Given I set the fake date to "04.01.1995"

Given I open an editor "kont99-mit-korezwang" from table "(Account):(Account)" with command "UPDATE" for record "99900"
And I set field "kost" to "ja"
And I save the current editor

Given I open an editor "check" from table "(Account):(Account)" with command "VIEW" for record "99900"
Then field "kost" has value "ja"
And I close the current editor

Given I open an editor "kont98-mit-korezwang" from table "(Account):(Account)" with command "UPDATE" for record "99800"
And I set field "kost" to "ja"
And I save the current editor

Given I open an editor "check" from table "(Account):(Account)" with command "VIEW" for record "99800"
Then field "kost" has value "ja"
And I close the current editor


Given I open an editor "Buchung1" from table "(Entry):(StatisticalEntry)" with command "NEW" for record ""
And I set field "text" to "konto m. zwang"
And I set field "such" to "mkost"
And I set field "budat" to "04.01.95"
And I create a new row at the end of the table
And I set field "konto" to "99900" in row 1
And I set field "sbetrag" to "50" in row 1
And I set field "ptext" to "fall 7 (8 wenn koart gefuellt)" in row 1
And I create a new row at the end of the table
And I set field "konto" to "99900" in row 2
And I set field "kstelle" to "100000" in row 2
And I set field "ptext" to "fall 7 (8 wenn koart gefuellt)" in row 2
# 1415 de      |Bitte Kostenstelle oder Kostenträger eintragen
# And saving the current editor throws the exception "1415"
# And I set field "kstelle" to "101" in row 1
And I respond with answer "Ja" to the dialog with id "1941"
And I save the current editor
And I close the current editor

# =============================================================================

Given I open an editor "konto-ohne-korezwang" from table "(Account):(Account)" with command "COPY" for record "99900"
And I set field "nummer" to "99773"
And I set field "kost" to "nein"
And I save the current editor
And I close the current editor

Given I open an editor "konto-ohne-korezwang" from table "(Account):(Account)" with command "VIEW" for record "99773"
Then field "kost" has value "nein"
And I close the current editor

Given I open an editor "Buchung2" from table "(Entry):(StatisticalEntry)" with command "NEW" for record ""
And I set field "text" to "konto oh. zwang"
And I set field "such" to "ohkost"
And I set field "budat" to "04.01.95"
And I create a new row at the end of the table
And I set field "konto" to "99773" in row 1
And I set field "sbetrag" to "50" in row 1
And I set field "ptext" to "fall 1 (2 wenn koart gefuellt)" in row 1
And I create a new row at the end of the table
And I set field "konto" to "99773" in row 2
And I set field "kstelle" to "100000" in row 2
And I set field "ptext" to "fall 3 (4 wenn koart gefuellt)" in row 2
And I respond with answer "Ja" to the dialog with id "1941"
And I save the current editor
And I close the current editor

# funktioniert nicht
# Given I open an editor "ss" for tip command "(Service)" and arguments "10"
# And I close the current editor

Given I open an editor "KOArtKostenart-1" from table "(CostType):(CostType)" with command "NEW" for record ""
And I set fields
	| nummer | 222                      |
	| such   | unerwuensh               |
	| name   | fuer fehlerpruefung prueffunktion kore  |
#	| stat   | ja                       |
And I save the current editor



Scenario: Ohne Korezwang und ohne Startdatum, darf die Fibu das Kostenobjekt
#         nicht eigenstaendig ergaenzen! s. jira bw2-1596
Given I set the fake date to "05.01.1995"

# Zusatzposition Transport
Given I open an editor "zusatzp_transport" from table "(Part):(SupplementaryItem)" with command "NEW" for record ""
And I set field "nummer" to "1transp"
And I set field "such" to "transport"
And I set field "name" to "transportkosten"
And I set field "ekonto" to "58000"
And I save the current editor

Given I open an editor "kont-transp" from table "(Account):(Account)" with command "UPDATE" for record "58000"
And I set field "kstelle" to "101"
And I save the current editor

Given I open an editor "rechnung" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "num4" to "75932"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "lief" to "1"
And I create a new row at the end of the table
And I set field "artikel" to "transport" in row 1
And I set field "pwert" to "645" in row 1
# das ist die entscheidende stelle!! in der rechnung keine kostenstelle
# in der buchung darf dann auch keine ergaenzt werden!
And I set field "kstelle" to "" in row 1
And I set field "kenn" to ""
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor
And I close the current editor

