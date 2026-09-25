@persistant
Feature: Konfiguration Steuerumstellung und Anlegen Buchungen in mehreren Steuerperioden
Background:
Given I set the fake date to "02.01.2002"

# Die Zeilen in denen stdat geändert und die Folgen dokumentiert werden, sind auskommentiert
# Grund ist, das stdat zunächst schreibgeschützt bleibt.
# Der Test wird aufgrund der vorab erzeugten Stammdaten für die Steuerumstellung
# und bereits vorhandener Bewegungsdaten vorab publiziert.

Scenario: Steuerumstellung testen
#Stammdaten anpassen ----- foo.txt fuer die Vorbereitungen

Given I open an editor "Steuerschluessel" from table "(TaxCode):(TaxCodeHead)" with command "UPDATE" for record "1" 
And I set field "gbis" to "31.12.00" in row 2 
And I create a new row at the end of the table
And I set field "gperr" to "PER3" in row 3
And I set field "psatz" to "19.00" in row 3
And I set field "gvon" to "01.01.2001" in row 3
And I set field "gbis" to "30.06.2001" in row 3
And I create a new row at the end of the table
And I set field "gperr" to "PER4" in row 4
And I set field "psatz" to "16.00" in row 4
And I set field "gvon" to "01.07.2001" in row 4
And I save the current editor

Given I open an editor "Skontokonto" from table "(Account):(Account)" with command "COPY" for record "47355" 
And I set field "nummer" to "47357" 
And I set field "name" to "gewährte Skonti 19%" 
And I save the current editor

Given I open an editor "Steuerkonto" from table "(Account):(Account)" with command "COPY" for record "38050" 
And I set field "nummer" to "38069" 
And I set field "name" to "Verkauf Umsatzsteuer 19%"
And I save the current editor

Given I open an editor "Steuerregel" from table "(TaxCode):(TaxRuleHead)" with command "UPDATE" for record "5000"
And I press button "ladestpertab"
And I create a new row at position 4
And I set field "budatstper" to "STS1-PER3" in row 4
And I set field "stdatstper" to "STS1-PER2" in row 4
And I set field "ktoustpos" to "51" in row 4
And I set field "sktoustpos" to "51" in row 4
And I set field "skkto" to "47355" in row 4
And I set field "vstkonto" to "38050" in row 4
And I set field "vkstustpos" to "551" in row 4

And I set field "ktoustpos" to "81" in row 5
And I set field "sktoustpos" to "81" in row 5
And I set field "skkto" to "47357" in row 5
And I set field "vstkonto" to "38069" in row 5
And I set field "vkstustpos" to "581" in row 5

And I create a new row at position 6
And I set field "budatstper" to "STS1-PER4" in row 6
And I set field "stdatstper" to "STS1-PER3" in row 6
And I set field "ktoustpos" to "81" in row 6
And I set field "sktoustpos" to "81" in row 6
And I set field "skkto" to "47357" in row 6
And I set field "vstkonto" to "38069" in row 6
And I set field "vkstustpos" to "581" in row 6

And I set field "ktoustpos" to "35" in row 7
And I set field "sktoustpos" to "35" in row 7
And I set field "skkto" to "47355" in row 7
And I set field "vstkonto" to "38050" in row 7
And I set field "vkstustpos" to "36" in row 7

And I create a new row at the end of the table
And I set field "budatstper" to "STS1-PER3" in row 8
And I set field "stdatstper" to "STS1-PER4" in row 8
And I set field "ktoustpos" to "35" in row 8
And I set field "sktoustpos" to "35" in row 8
And I set field "skkto" to "47355" in row 8
And I set field "vstkonto" to "38050" in row 8
And I set field "vkstustpos" to "36" in row 8
And I save the current editor

Given I open an editor "Steuerschluessel" from table "58:21" with command "STORE" for record "STS3" 
And I set field "such" to "STS3"
And I set field "namebspr" to "Steuer 19 % - Periodenfremd"
And I create a new row at the end of the table
And I set field "gperr" to "PER1" in row 1
And I set field "psatz" to "19" in row 1
And I set field "gvon" to "01.07.2001" in row 1
And I save the current editor

Given I open an editor "Ust" from table "(Evaluation):(ItemNumber)" with command "UPDATE" for record "K81"
And I create a new row at the end of the table 
And I set field "sts" to "3" in row 2
And I save the current editor

Given I open an editor "Ustposition" from table "(Evaluation):(ItemNumber)" with command "UPDATE" for record "P81"
And I create a new row at the end of the table
And I set field "sts" to "3" in row 2
And I save the current editor

Given I open an editor "Skontokonto" from table "(Account):(Account)" with command "COPY" for record "47355" 
And I set field "nummer" to "47369" 
And I set field "namebspr" to "gewährte Skonti 19% - STS 3"
And I save the current editor

Given I open an editor "Steuerkonto" from table "(Account):(Account)" with command "COPY" for record "38050" 
And I set field "nummer" to "38062" 
And I set field "namebspr" to "Verkauf Umsatzsteuer 19% - Sts 3"
And I set field "steuersts" to "STS3"
And I save the current editor

Given I open an editor "Steuerregel" from table "58:25" with command "STORE" for record "VKIN19"
And I set field "such" to "VKIN19"
And I set field "namebspr" to "Inland 19% Steuerschlüssel 3"
And I set field "ev" to "Verkauf"
And I set field "stlaart" to "Inland"
And I set field "ustart" to "steuerpflichtig"
And I set field "sts" to "3"
And I press button "ladestpertab"
And I set field "ktoustpos" to "81" in row 1
And I set field "sktoustpos" to "81" in row 1
And I set field "skkto" to "47369" in row 1
And I set field "vstkonto" to "38062" in row 1
And I set field "vkstustpos" to "581" in row 1
And I save the current editor

Given I open an editor "Kontosteuerregel" from table "58:26" with command "UPDATE" for record "VKINLREGEL"
And I create a new row at position 2
And I set field "vrgstrgl" to "VKINL" in row 2
And I set field "strgl" to "VKIN19" in row 2
And I save the current editor

Given I open an editor "Anzahlungskonto" from table "(Account):(Account)" with command "COPY" for record "32700" 
And I set field "nummer" to "32720" 
And I set field "name" to "erhaltene Anzahlungen 19%"
And I set field "ktostrgl" to "7000"
And I save the current editor

#ab hier Bewegungsdaten ----- FOO ENDE ------
#Gutschrift für Vorperiode (https://jira.abasag.intra/browse/REWE-2456, Beispiel Nr. 6) 
Given I open an editor "Buchung" from table "(Entry):(Entry)" with command "NEW" for record ""
And I set field "text" to "Gutschrift mit altem Steuersatz 19%"
And I set field "beleg" to "1"
And I create a new row at the end of the table
And I set field "konto" to "K 1" in row 1
And I create a new row at the end of the table
And I set field "konto" to "44000" in row 2
And I set field "ewsbetr" to "1000" in row 2
And I set field "kstelle" to "100" in row 2
# And I set field "stdat" to "31.12.01" in row 2 
# Then field "stdat" has value "31.12.01" in row 2
# Then field "ustva" has value "81" in row 2
# Then field "vstkonto" has value "38069" in row 2
# Then field "skkonto" has value "47357" in row 2
# And I set field "stdat" to "." in row 2
# Then field "stdat" has value "02.01.02" in row 2 
# Then field "ustva" has value "35" in row 2
# Then field "skkonto" has value "47355" in row 2
# Then field "vstkonto" has value "38050" in row 2
# And I set field "stdat" to "31.12.01" in row 2 
# Then field "stdat" has value "31.12.01" in row 2
# Then field "ustva" has value "81" in row 2
# Then field "vstkonto" has value "38069" in row 2
# Then field "skkonto" has value "47357" in row 2
And I respond with answer "Ja" to the dialog with id "583"
And I save the current editor

#Buchung 10 in alter Periode schon mal mit Steuersatz der neuen Periode buchen
Given I open an editor "Buchung10" from table "(Entry):(Entry)" with command "NEW" for record ""
And I set field "budat" to "30.12.2001"
And I set field "beleg" to "2"
And I set field "text" to "schon mal mit 16% in alter Periode"
And I create a new row at the end of the table
And I set field "konto" to "k 1" in row 1
And I create a new row at the end of the table
And I set field "konto" to "44000" in row 2
And I set field "ewhbetr" to "1000" in row 2
And I set field "kstelle" to "101" in row 2
# And I set field "stdat" to "31.12.01" in row 2
# Then field "skkonto" has value "47357" in row 2
# Then field "ustva" has value "81" in row 2
# Then field "vstkonto" has value "38069" in row 2
# Then field "vkstustpos" has value "581" in row 2
# And I set field "stdat" to "03.01.02" in row 2 
# Then field "stdat" has value "03.01.02" in row 2
# Then field "skkonto" has value "47355" in row 2
# Then field "vstkonto" has value "38050" in row 2
# Then field "ustva" has value "35" in row 2
# Then field "vkstustpos" has value "36" in row 2
And I respond with answer "Ja" to the dialog with id "583"
And I save the current editor

#Erzeugen einer VK-Rechnung mit Anzahlungsposition zu 19% in neuer Steuerperiode
#Auftrag anlegen
Given I open an editor "Anzahlungsposition" from table "02:04" with command "UPDATE" for record "ANZAHLUNG"
And I set field "vkonto" to "32720"
And I save the current editor

#Verkaufsauftrag Zeitraum alt
Given I open an editor "auftrag" from table "03:22" with command "NEW" for record ""
And I set field "kunde" to "1"
And I set field "betreff" to "Testcase AUO12 (Anzahlungen geplant ohne Faktura)"
And I set field "budat" to "31.12.01"
Then I create a new row at the end of the table
And I set field "artikel" to "ANZ" in row 1
Then I create a new row at the end of the table
And I set field "artikel" to "V2" in row 2
And I set field "mge" to "800" in row 2
And I set field "preis" to "20" in row 2
And I save the current editor

#Uebertragen der Anzahlungsrechnung mit altem Zeitraum - 19%
Given I open an editor "anzahlrech" from table "03:24" with command "NEW" for record ""
And I set field "vorganga" to "Anzahlung"
And I set field "beleg" to id from editor "auftrag"
And I set field "budat" to "31.12.01"
And I set field "tterm" to "31.12.01"
And I set field "ueb" to "ja"
And I set field "pwert" to "4000" in row 1
And I set field "num3" to "7Anz"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

#Bezahlung der Anzahlungsrechnung - alte Steuerperiode mit 19%
Given I open an editor "OPAUSBUCHEN" from table "102:04" with command "NEW" for record "" 
And I set field "gkonto" to "18100"
And I set field "beleg" to "2"
And I set field "kbudat" to "31.12.01"
And I create a new row at the end of the table
And I set field "konto" to "K 4" in row 1
And I set field "tbeleg" to "7Anz" in row 1
And I press button "opladen"
And I press button "tueber" in row 1
Then field "ofbetr" has value "0.00" in row 1
And I respond with answer "ja" to the dialog with id "588"
And I save the current editor

#Erzeugen und Buchen -  Schlussrechnung mit Abzug aus Vorperiode
Given I open an editor "Rechnung 400033" from table "03:24" with command "NEW" for record ""
And I set field "beleg" to id from editor "auftrag"
And I set field "budat" to "."
And I set field "tterm" to "."
And I set field "ueb" to "ja"
And I press button "offueb" in row 1
Then field "artikel" has value "ANZAHLUNG" in row 1
And I set field "strgl" to "VKIN19" in row 1
And I press button "offueb" in row 2
Then field "artikel" has value "V2" in row 2
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

#Manuelle Buchung der Schlussrechnung, die eine Anzahlung mit dem altem Steuersatz enthält 
#(https://jira.abasag.intra/browse/REWE-2456,Beispiel Nr. 9)
Given I open an editor "Buchung19" from table "(Entry):(Entry)" with command "NEW" for record ""
And I set field "budat" to "."
And I set field "text" to "manuelle Buchung Schlussrechnung"
And I create a new row at the end of the table
And I set field "konto" to "k 1" in row 1
And I set field "ewsbetr" to "13800" in row 1 
And I create a new row at the end of the table
And I set field "konto" to "44000" in row 2
# And I set field "ewhbetr" to "16000" in row 2
And I set field "kstelle" to "101" in row 2
Then field "strgl" has value "VKINREGEL" in row 2
Then field "zstrgl" has value "VKINREGEL-7" in row 2
Then field "ustva" has value "35" in row 2
Then field "skkonto" has value "47355" in row 2
Then field "vstkonto" has value "38050" in row 2
Then field "vkstustpos" has value "36" in row 2
# And I create a new row at the end of the table
# And I set field "konto" to "32720" in row 3
# And I set field "ewsbetr" to "4000" in row 3
# And I set field "stdat" to "31.12.01" in row 3 
# Then field "stdat" has value "31.12.01" in row 3
# Then field "strgl" has value "VKINREGEL" in row 3
# Then field "zstrgl" has value "VKINREGEL-6" in row 3
# Then field "ustva" has value "81" in row 3
# Then field "skkonto" has value "47357" in row 3
# Then field "sktoustpos" has value "81" in row 3
# Then field "vstkonto" has value "38069" in row 3
# Then field " vkstustpos" has value "581" in row 3
# And I set field "stdat" to "." in row 3
# Then field "stdat" has value "02.01.02" in row 3
# Then field "zstrgl" has value "VKINREGEL-7" in row 3
# Then field "ustva" has value "35" in row 3
# Then field "vstkonto" has value "38050" in row 3
# And I set field "stdat" to "31.12.01" in row 3
# Then field "zstrgl" has value "VKINREGEL-6" in row 3
# Then field "ustva" has value "81" in row 3
# Then field "skkonto" has value "47357" in row 3
# Then field "sktoustpos" has value "81" in row 3
# Then field "vstkonto" has value "38069" in row 3
# Then field "vkstustpos" has value "581" in row 3
And I respond with answer "Ja" to the dialog with id "1941"
And I save the current editor

#Erzeugen einer VK-Rechnung in alter Steuerperiode (bis 31.12.01 gelten 19%)
Given I open an editor "Rechnung0818" from table "03:24" with command "NEW" for record ""
And I set field "kunde" to "1"
And I set field "nummer" to "0818"
And I set field "zbed" to "201"
And I set field "vom" to "23.12.01"
And I set field "budat" to "23.12.01"
And I create a new row at position 1
And I set field "artikel" to "402" in row 1
And I set field "mge" to "100" in row 1
And I set field "preis" to "10" in row 1
And I set field "ueb" to "ja"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

#Zahlung aus Offenen Posten ausbuchen - Steuerberechnungsperiode 1 - Steuerbuchungsperiode 2
Given I open an editor "OPAUSBUCHEN" from table "102:04" with command "NEW" for record "" 
And I set field "gkonto" to "18100"
And I set field "beleg" to "1"
And I create a new row at the end of the table
And I set field "tbeleg" to "0818" in row 1
And I press button "opladen"
And I set field "sksatz" to "1" in row 1
Then field "ofbetr" has value "0.00" in row 1
And I respond with answer "ja" to the dialog with id "588"
And I save the current editor

#Zahlungssammelbuchung eine Skontorückrechnung mit noch 19% und eine Skontorückrechnung mit 16%
Given I open an editor "OPAUSBUCHEN" from table "102:04" with command "NEW" for record "" 
And I set field "gkonto" to "18100"
And I set field "beleg" to "Gemischt"
And I set field "kbudat" to "."
And I set field "zasammelart" to "Sammelbuchungen"
And I create a new row at the end of the table
And I set field "tbeleg" to "1" in row 1
And I set field "konto" to "K 1" in row 1
And I press button "opladen"
And I set field "sksatz" to "3" in row 1
Then field "ofbetr" has value "0.00" in row 1
And I create a new row at position 2
And I set field "tbeleg" to "2" in row 2
And I set field "konto" to "K 1" in row 2
And I press button "opladen"
And I set field "sksatz" to "1" in row 2
Then field "ofbetr" has value "0.00" in row 2
And I respond with answer "ja" to the dialog with id "588"
And I save the current editor

