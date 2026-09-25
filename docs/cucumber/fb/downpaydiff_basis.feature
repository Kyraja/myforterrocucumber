@persistent
@FP_TEST
Feature: Daten anlegen fuer Infosystem DOWNPAYDIFF
Background:
Given I set the fake date to "02.01.1995"

@EVS-379
@persistent
Scenario: Test 1 fuer ANZKDIFF anlegen
Given I open an editor "kunde" from table "(Customer):(Customer)" with command "STORE" for record "AUSLAND"
And I set field "such" to "AUSLAND"
And I set field "namebspr" to "Ausland Werkzeugbau, Rastatt"
And I set field "ans" to "Bayram Werkzeugbau GmbH"
And I set field "str" to "Riedstr. 24-28"
And I set field "plz" to "76437"
And I set field "nort" to "Rastatt"
And I set field "region" to "BADEN"
And I set field "tele" to "+49 (0) 7222/9456-0"
And I set field "email" to "info@bayram-corp.de"
And I set field "betreuer" to "."
And I set field "waehr" to "USD"
And I set field "ustid" to "DE56454651"
And I set field "lbed" to "EXW"
And I set field "zbed" to "201"
And I save the current editor
Then field "name" has value "Ausland Werkzeugbau, Rastatt"
Then field "zbed" has value "201"
 
@EVS-379
@persistent
Scenario: Test 1 Neuen Artikel anlegen
Given I open an editor "artikel" from table "(Part):(Product)" with command "STORE" for record "traktor10ps"
And I set field "such" to "traktor10ps"
And I set field "namebspr" to "Rasentraktor 10 PS"
And I set field "vkbez" to "Rasentraktor 10 PS"
And I set field "vbez" to "Rasentraktor 10 PS"
And I set field "ebez" to "Rasentraktor 10 PS"
And I set field "vpr" to "10000"
And I set field "bsart" to "Fremdbeschaffung"
And I set field "dispoa" to "bedarfsbezogen"
And I save the current editor
Then field "such" has value "TRAKTOR10PS"
 
@EVS-379
@persistent
Scenario: Test 1 Waehrungskurs auf 0,9 setzen
Given I open an editor "waehrung" from table "(ExchangeRate):(ExchangeRate)" with command "NEW" for record ""
And I set field "fwaehr" to "USD"
And I set field "ikurs" to "0.9"
And I save the current editor
 
@EVS-379
@persistent
Scenario: Test 1 Auftrag mit 1 Artikel und 2 Anzahlungspositionen anlegen
Given I open an editor "auftrag" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set field "kunde" to id from editor "kunde"
And I set field "betreff" to "Testcase AU379T1 (Tests fuer ANZKDIFF anlegen)"
And I set field "such" to "B1AUSLAND"
When I create a new row at the end of the table
And I set field "artex" to id from editor "artikel" in row 1
And I set field "mge" to "1" in row 1
When I create a new row at the end of the table
And I set field "artex" to "anz" in row 2
When I create a new row at the end of the table
And I set field "artex" to "anz" in row 3
And I save the current editor
 
@EVS-379
@persistent
Scenario: Test 1 Anzahlungsrechnung fuer 1. Anzahlungsposition anlegen
Given I open an editor "anzahlrech" from table "(Sales):(Invoice)" with command "NEW" for record ""
And I set field "vorganga" to "Anzahlung"
And I set field "beleg" to id from editor "auftrag"
And I set field "ueb" to "ja"
And I set field "pwert" to "100" in row 1
And I delete row at position 2
And I set field "num3" to "2"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor
 
@EVS-379
@persistent
Scenario: Test 1 Offener Posten der Anzahlungsrechnung ausbuchen
Given I open an editor "OP-Bearbeitung" from table "102:4" with command "NEW" for record ""
And I set field "gkonto" to "18100"
And I set field "beleg" to "1"
And I create a new row at the end of the table
And I set field "tbeleg" to "2" in row 1
And I press button "opladen"
And I set field "opzabetr" to "115.00" in row 1
And I respond with answer "ja" to the dialog with id "588"
And I save the current editor

@EVS-379
@persistent
Scenario: Test 1 Schlussrechnung erzeugen
Given I open an editor "rechnung" from table "(Sales):(Invoice)" with command "NEW" for record ""
And I set field "betreff" to "Schlussrechnung erzeugen"
And I set field "beleg" to id from editor "auftrag"
Then the table has 3 rows
When I set field "ewekurs" to "0.80"
And I set field "ueb" to "ja"
And I set field "mge" to "1" in row 1
And I set field "num3" to "3"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor
 
@EVS-379
@persistent
Scenario: Test 1 Offener Posten der Schlussrechnung ausbuchen
Given I open an editor "OP-Bearbeitung" from table "102:4" with command "NEW" for record ""
And I set field "gkonto" to "18100"
And I set field "beleg" to "1"
And I create a new row at the end of the table
And I set field "tbeleg" to "3" in row 1
And I press button "opladen"
And I set field "opzabetr" to "14245.63" in row 1
And I set field "sksatz" to "0" in row 1
Then field "ofbetr" has value "0.00" in row 1
And I respond with answer "ja" to the dialog with id "588"
And I save the current editor
 
@EVS-379
@persistent
Scenario: Test 2 Auftrag mit 1 Artikel und 2 Anzahlungspositionen anlegen fuer Test 2
Given I open an editor "auftrag-2" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set field "kunde" to id from editor "kunde"
And I set field "betreff" to "Testcase AU379T2 (Test 2 fuer ANZKDIFF anlegen)"
And I set field "such" to "B2AUSLAND"
When I create a new row at the end of the table
And I set field "artex" to id from editor "artikel" in row 1
And I set field "mge" to "1" in row 1
When I create a new row at the end of the table
And I set field "artex" to "anz" in row 2
When I create a new row at the end of the table
And I set field "artex" to "anz" in row 3
And I save the current editor
 
@EVS-379
@persistent
Scenario: Test 2 Anzahlungsrechnung fuer 1. Anzahlungsposition anlegen
Given I open an editor "anzahlrech" from table "(Sales):(Invoice)" with command "NEW" for record ""
And I set field "vorganga" to "Anzahlung"
And I set field "beleg" to id from editor "auftrag-2"
And I set field "ueb" to "ja"
And I set field "pwert" to "200" in row 1
And I delete row at position 2
And I set field "num3" to "4"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor
 
@EVS-379
@persistent
Scenario: Test 2 Offener Posten der Anzahlungsrechnung ausbuchen
Given I open an editor "OP-Bearbeitung" from table "102:4" with command "NEW" for record ""
And I set field "gkonto" to "18100"
And I set field "beleg" to "1"
And I create a new row at the end of the table
And I set field "tbeleg" to "4" in row 1
And I press button "opladen"
And I set field "opzabetr" to "230.00" in row 1
And I respond with answer "ja" to the dialog with id "588"
And I save the current editor
 
@EVS-379
@persistent
Scenario: Test 2 Anzahlungsrechnung fuer 2. Anzahlungsposition anlegen
Given I open an editor "anzahlrech" from table "(Sales):(Invoice)" with command "NEW" for record ""
And I set field "vorganga" to "Anzahlung"
And I set field "beleg" to id from editor "auftrag-2"
And I set field "ueb" to "ja"
And I set field "pwert" to "200" in row 2
And I delete row at position 1
And I set field "num3" to "5"
And I set field "ewekurs" to "0.95"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor
 
@EVS-379
@persistent
Scenario: Test 2 Offener Posten der 2. Anzahlungsrechnung zu 50% ausbuchen
Given I open an editor "OP-Bearbeitung" from table "102:4" with command "NEW" for record ""
And I set field "gkonto" to "18100"
And I set field "beleg" to "1"
And I create a new row at the end of the table
And I set field "tbeleg" to "5" in row 1
And I press button "opladen"
And I set field "opzabetr" to "110.00" in row 1
And I respond with answer "ja" to the dialog with id "588"
And I save the current editor
 
@EVS-379
@persistent
Scenario: Test 2 Schlussrechnung erzeugen
Given I open an editor "rechnung" from table "(Sales):(Invoice)" with command "NEW" for record ""
And I set field "betreff" to "Schlussrechnung erzeugen"
And I set field "beleg" to id from editor "auftrag-2"
Then the table has 3 rows
When I set field "ewekurs" to "0.80"
And I set field "ueb" to "ja"
And I set field "mge" to "1" in row 1
And I set field "num3" to "6"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor
 
@EVS-379
@persistent
Scenario: Test 2 Offener Posten der Schlussrechnung ausbuchen
Given I open an editor "OP-Bearbeitung" from table "102:4" with command "NEW" for record ""
And I set field "gkonto" to "18100"
And I set field "beleg" to "1"
And I create a new row at the end of the table
And I set field "tbeleg" to "6" in row 1
And I press button "opladen"
And I set field "opzabetr" to "13871,13" in row 1
And I set field "sksatz" to "0" in row 1
Then field "ofbetr" has value "0.00" in row 1
And I respond with answer "ja" to the dialog with id "588"
And I save the current editor
 
@EVS-379
@persistent
Scenario: Test 3 Auftrag mit 1 Artikel und 2 Anzahlungspositionen anlegen fuer Test 3
Given I open an editor "auftrag-3" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set field "kunde" to id from editor "kunde"
And I set field "betreff" to "Testcase AU379T3 (Test 3 fuer ANZKDIFF anlegen)"
And I set field "such" to "B3AUSLAND"
When I create a new row at the end of the table
And I set field "artex" to id from editor "artikel" in row 1
And I set field "mge" to "1" in row 1
When I create a new row at the end of the table
And I set field "artex" to "anz" in row 2
When I create a new row at the end of the table
And I set field "artex" to "anz" in row 3
And I save the current editor
 
@EVS-379
@persistent
Scenario: Test 3 Anzahlungsrechnung fuer 1. Anzahlungsposition anlegen
Given I open an editor "anzahlrech" from table "(Sales):(Invoice)" with command "NEW" for record ""
And I set field "vorganga" to "Anzahlung"
And I set field "beleg" to id from editor "auftrag-3"
And I set field "ueb" to "ja"
And I set field "pwert" to "300" in row 1
And I delete row at position 2
And I set field "num3" to "7"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor
 
@EVS-379
@persistent
Scenario: Test 3 Offener Posten der Anzahlungsrechnung ausbuchen
Given I open an editor "OP-Bearbeitung" from table "102:4" with command "NEW" for record ""
And I set field "gkonto" to "18100"
And I set field "beleg" to "1"
And I create a new row at the end of the table
And I set field "tbeleg" to "7" in row 1
And I press button "opladen"
And I set field "opzabetr" to "345.00" in row 1
Then field "ofbetr" has value "0.00" in row 1
And I respond with answer "ja" to the dialog with id "588"
And I save the current editor
 
@EVS-379
@persistent
Scenario: Test 3 Weitere Anzahlungsrechnung fuer 1. Anzahlungsposition anlegen
Given I open an editor "anzahlrech" from table "(Sales):(Invoice)" with command "NEW" for record ""
And I set field "vorganga" to "Anzahlung"
And I set field "beleg" to id from editor "auftrag-3"
And I set field "ueb" to "ja"
And I set field "pwert" to "300" in row 1
And I delete row at position 2
And I set field "num3" to "8"
And I set field "ewekurs" to "0.95"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor
 
@EVS-379
@persistent
Scenario: Test 3 Offener Posten der 2. Anzahlungsrechnung ausbuchen
Given I open an editor "OP-Bearbeitung" from table "102:4" with command "NEW" for record ""
And I set field "gkonto" to "18100"
And I set field "beleg" to "1"
And I create a new row at the end of the table
And I set field "tbeleg" to "8" in row 1
And I press button "opladen"
And I set field "opzabetr" to "326.84" in row 1
Then field "ofbetr" has value "0.00" in row 1
And I respond with answer "ja" to the dialog with id "588"
And I save the current editor
 
@EVS-379
@persistent
Scenario: Test 3 Anzahlungsrechnung fuer 2. Anzahlungsposition anlegen
Given I open an editor "anzahlrech" from table "(Sales):(Invoice)" with command "NEW" for record ""
And I set field "vorganga" to "Anzahlung"
And I set field "beleg" to id from editor "auftrag-3"
And I set field "ueb" to "ja"
And I set field "pwert" to "300" in row 2
And I delete row at position 1
And I set field "num3" to "9"
And I set field "ewekurs" to "0.95"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor
 
@EVS-379
@persistent
Scenario: Test 3 Offener Posten der 3. Anzahlungsrechnung ausbuchen
Given I open an editor "OP-Bearbeitung" from table "102:4" with command "NEW" for record ""
And I set field "gkonto" to "18100"
And I set field "beleg" to "1"
And I create a new row at the end of the table
And I set field "tbeleg" to "9" in row 1
And I press button "opladen"
And I set field "opzabetr" to "326.84" in row 1
Then field "ofbetr" has value "0.00" in row 1
And I respond with answer "ja" to the dialog with id "588"
And I save the current editor
 
@EVS-379
@persistent
Scenario: Test 3 Schlussrechnung erzeugen
Given I open an editor "rechnung" from table "(Sales):(Invoice)" with command "NEW" for record ""
And I set field "betreff" to "Schlussrechnung erzeugen"
And I set field "beleg" to id from editor "auftrag-3"
Then the table has 4 rows
When I set field "ewekurs" to "0.80"
And I set field "ueb" to "ja"
And I set field "mge" to "1" in row 1
And I set field "num3" to "10"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor
 
@EVS-379
@persistent
Scenario: Test 3 Offener Posten der Schlussrechnung ausbuchen
Given I open an editor "OP-Bearbeitung" from table "102:4" with command "NEW" for record ""
And I set field "gkonto" to "18100"
And I set field "beleg" to "1"
And I create a new row at the end of the table
And I set field "tbeleg" to "10" in row 1
And I press button "opladen"
And I set field "opzabetr" to "13251.47" in row 1
And I set field "sksatz" to "0" in row 1
Then field "ofbetr" has value "0.00" in row 1
And I respond with answer "ja" to the dialog with id "588"
And I save the current editor
 
@EVS-379
@persistent
Scenario: Test 4 Auftrag mit 1 Artikel und 1 Anzahlungspositio anlegen fuer Test 4
Given I open an editor "auftrag-4" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set field "kunde" to id from editor "kunde"
And I set field "betreff" to "Testcase AU379T4 (Test 4 fuer ANZKDIFF anlegen)"
And I set field "such" to "B4AUSLAND"
When I create a new row at the end of the table
And I set field "artex" to id from editor "artikel" in row 1
And I set field "mge" to "1" in row 1
When I create a new row at the end of the table
And I set field "artex" to "anz" in row 2
And I save the current editor
 
@EVS-379
@persistent
Scenario: Test 4 Anzahlungsrechnung fuer die Anzahlungsposition anlegen
Given I open an editor "anzahlrech" from table "(Sales):(Invoice)" with command "NEW" for record ""
And I set field "vorganga" to "Anzahlung"
And I set field "beleg" to id from editor "auftrag-4"
And I set field "ueb" to "ja"
And I set field "pwert" to "400" in row 1
And I set field "num3" to "11"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor
 
@EVS-379
@persistent
Scenario: Test 4 Offener Posten der Anzahlungsrechnung ausbuchen
Given I open an editor "OP-Bearbeitung" from table "102:4" with command "NEW" for record ""
And I set field "gkonto" to "18100"
And I set field "beleg" to "1"
And I create a new row at the end of the table
And I set field "tbeleg" to "11" in row 1
And I press button "opladen"
And I set field "opzabetr" to "460.00" in row 1
Then field "ofbetr" has value "0.00" in row 1
And I respond with answer "ja" to the dialog with id "588"
And I save the current editor
 
@EVS-379
@persistent
Scenario: Test 4 Anzahlungsrechnung fuer die Anzahlungsposition gutschreiben
Given I open an editor "gutanzahlrech" from table "(Sales):(Invoice)" with command "NEW" for record ""
And I set field "vorganga" to "Anzahlung"
And I set field "beleg" to id from editor "auftrag-4"
And I set field "ueb" to "ja"
And I set field "pwert" to "-400" in row 1
And I set field "num3" to "12"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor
 
@EVS-379
@persistent
Scenario: Test 4 Schlussrechnung fuer Auftrag erzeugen
Given I open an editor "rechnung" from table "(Sales):(Invoice)" with command "NEW" for record ""
And I set field "betreff" to "Schlussrechnung erzeugen Test 4"
And I set field "beleg" to id from editor "auftrag-4"
Then the table has 1 rows
When I set field "ewekurs" to "0.80"
And I set field "ueb" to "ja"
And I set field "mge" to "1" in row 1
And I set field "num3" to "13"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor
 
@EVS-379
@persistent
Scenario: Test 4 Offener Posten der Schlussrechnung ausbuchen
Given I open an editor "OP-Bearbeitung" from table "102:4" with command "NEW" for record ""
And I set field "gkonto" to "18100"
And I set field "beleg" to "1"
And I create a new row at the end of the table
And I set field "tbeleg" to "13" in row 1
And I press button "opladen"
And I set field "opzabetr" to "14375.00" in row 1
And I set field "sksatz" to "0" in row 1
Then field "ofbetr" has value "0.00" in row 1
And I respond with answer "ja" to the dialog with id "588"
And I save the current editor
 
@EVS-379
@persistent
Scenario: Test 5 Auftrag mit 1 Artikel und 1 Anzahlungspositio anlegen fuer Test 5
Given I open an editor "auftrag-5" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set field "kunde" to id from editor "kunde"
And I set field "betreff" to "Testcase AU379T5 (Test 5 fuer ANZKDIFF anlegen)"
And I set field "such" to "B5AUSLAND"
When I create a new row at the end of the table
And I set field "artex" to id from editor "artikel" in row 1
And I set field "mge" to "1" in row 1
When I create a new row at the end of the table
And I set field "artex" to "anz" in row 2
And I save the current editor
 
@EVS-379
@persistent
Scenario: Test 5 Anzahlungsrechnung fuer die Anzahlungsposition anlegen
Given I open an editor "anzahlrech" from table "(Sales):(Invoice)" with command "NEW" for record ""
And I set field "vorganga" to "Anzahlung"
And I set field "beleg" to id from editor "auftrag-5"
And I set field "ueb" to "ja"
And I set field "pwert" to "500" in row 1
And I set field "num3" to "14"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor
 
@EVS-379
@persistent
Scenario: Test 5 Offener Posten der Anzahlungsrechnung ausbuchen
Given I open an editor "OP-Bearbeitung" from table "102:4" with command "NEW" for record ""
And I set field "gkonto" to "18100"
And I set field "beleg" to "1"
And I create a new row at the end of the table
And I set field "tbeleg" to "14" in row 1
And I press button "opladen"
And I set field "opzabetr" to "575.00" in row 1
Then field "ofbetr" has value "0.00" in row 1
And I respond with answer "ja" to the dialog with id "588"
And I save the current editor
 
@EVS-379
@persistent
Scenario: Test 5 Anzahlungsrechnung fuer die Anzahlungsposition gutschreiben
Given I open an editor "gutanzahlrech" from table "(Sales):(Invoice)" with command "NEW" for record ""
And I set field "vorganga" to "Anzahlung"
And I set field "beleg" to id from editor "auftrag-5"
And I set field "ueb" to "ja"
And I set field "pwert" to "-500" in row 1
And I set field "num3" to "15"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor
 
@EVS-379
@persistent
Scenario: Test 5 Auftrag aufrufen und Stern aus dem Status der Anzahlungsposition entfernen
Given I open an editor "auftrag-5" from table "(Sales):(SalesOrder)" with command "UPDATE" for record "B5AUSLAND"
And I set field "status" to "" in row 2
Then field "status" has value "" in row 2
And I save the current editor
 
@EVS-379
@persistent
Scenario: Test 5 Anzahlungsrechnung fuer die Anzahlungsposition anlegen
Given I open an editor "anzahlrech" from table "(Sales):(Invoice)" with command "NEW" for record ""
And I set field "vorganga" to "Anzahlung"
And I set field "beleg" to id from editor "auftrag-5"
And I set field "ueb" to "ja"
And I set field "pwert" to "500" in row 1
And I set field "num3" to "16"
And I set field "ewekurs" to "0.85"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor
 
@EVS-379
@persistent
Scenario: Test 5 Offener Posten der Anzahlungsrechnung ausbuchen
Given I open an editor "OP-Bearbeitung" from table "102:4" with command "NEW" for record ""
And I set field "gkonto" to "18100"
And I set field "beleg" to "1"
And I create a new row at the end of the table
And I set field "tbeleg" to "16" in row 1
And I press button "opladen"
And I set field "opzabetr" to "608.82" in row 1
Then field "ofbetr" has value "0.00" in row 1
And I respond with answer "ja" to the dialog with id "588"
And I save the current editor
 
@EVS-379
@persistent
Scenario: Test 5 Anzahlungsrechnung fuer die Anzahlungsposition anlegen
Given I open an editor "anzahlrech" from table "(Sales):(Invoice)" with command "NEW" for record ""
And I set field "vorganga" to "Anzahlung"
And I set field "beleg" to id from editor "auftrag-5"
And I set field "ueb" to "ja"
And I set field "pwert" to "500" in row 1
And I set field "num3" to "17"
And I set field "ewekurs" to "0.75"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor
 
@EVS-379
@persistent
Scenario: Test 5 Schlussrechnung fuer Auftrag erzeugen
Given I open an editor "rechnung" from table "(Sales):(Invoice)" with command "NEW" for record ""
And I set field "betreff" to "Schlussrechnung erzeugen Test 5"
And I set field "beleg" to id from editor "auftrag-5"
Then the table has 5 rows
When I set field "ewekurs" to "0.80"
And I set field "ueb" to "ja"
And I set field "mge" to "1" in row 1
And I set field "num3" to "18"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor
 
@EVS-379
@persistent
Scenario: Test 5 Offener Posten der Schlussrechnung ausbuchen
Given I open an editor "OP-Bearbeitung" from table "102:4" with command "NEW" for record ""
And I set field "gkonto" to "18100"
And I set field "beleg" to "1"
And I create a new row at the end of the table
And I set field "tbeleg" to "18" in row 1
And I press button "opladen"
And I set field "opzabetr" to "12913.82" in row 1
And I set field "sksatz" to "0" in row 1
Then field "ofbetr" has value "0.00" in row 1
And I respond with answer "ja" to the dialog with id "588"
And I save the current editor
 
