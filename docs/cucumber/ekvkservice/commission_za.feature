@include @persistent
Feature: Daten fuer Provisionsabrechnung erstellen nach Zahlungseingang
Background:
Given I set the fake date to "02.01.1995"
Given I set saved value "REF_FILE" to "VK.COMMISSION.CU.ZA.REF"
Given I set saved value "Feldliste" to "iwaehraend,vertret,vkre,ophist,land,rebetr,provisoffen,pzrech,prza,vom,kunde,artikel,mge,heinheit,pwert,pros,provision,rezn,prob,bezprovibetr,provnummer,provnrtabelle^nummer"

Scenario: STAMMDATEN - Neue Provisionsgruppe anlegen
Given I open an editor "provision" from table "(Commission):(Commission)" with command "STORE" for record "PB"
And I set field "such" to "PB"
And I set field "namebspr" to "Provision B-Vertreter, alle Artikel"
And I set field "vetpg" to "B"
And I set field "provis" to "15"
And I save the current editor

Scenario: STAMMDATEN - Vertreter und Kunde anlegen
Given I open an editor "vertreter" from table "(Customer):(Customer)" with command "STORE" for record "vertreter"
And I set field "such" to "vertret"
And I set field "namebspr" to "Vertreter, Rastatt"
And I set field "ans" to "Bayram Werkzeugbau GmbH"
And I set field "str" to "Riedstr. 24-28"
And I set field "plz" to "76437"
And I set field "nort" to "Rastatt"
And I set field "region" to "BADEN"
And I set field "tele" to "+49 (0) 7222/9456-0"
And I set field "email" to "info@bayram-corp.de"
And I set field "betreuer" to "."
And I set field "ustid" to "DE56454651"
And I set field "lbed" to "EXW"
And I set field "zbed" to "201"
And I set field "rab" to "A"
And I save the current editor

#Kunde anlegen
Given I open an editor "kunde" from table "(Customer):(Customer)" with command "STORE" for record "Bayram"
And I set field "such" to "Bayram"
And I set field "namebspr" to "Bayram Werkzeugbau, Rastatt"
And I set field "ans" to "Bayram Werkzeugbau GmbH"
And I set field "str" to "Riedstr. 24-28"
And I set field "plz" to "76437"
And I set field "nort" to "Rastatt"
And I set field "region" to "BADEN"
And I set field "tele" to "+49 (0) 7222/9456-0"
And I set field "email" to "info@bayram-corp.de"
And I set field "betreuer" to "."
And I set field "ustid" to "DE56454651"
And I set field "lbed" to "EXW"
And I set field "zbed" to "201"
And I set field "vertret" to id from editor "vertreter"
And I save the current editor 

#Provisionsgruppe in Vertreter Maier eintragen
Given I open an editor "maier" from table "(Customer):(Customer)" with command "UPDATE" for record "4"
And I set field "rab" to "B"
And I save the current editor

Scenario: STAMMDATEN -  Materialzuschlag anlegen
Given I open an editor "matzu" from table "(Company):(MaterialSurchargeHeader)" with command "UPDATE" for record "30"
And I create a new row at the end of the table
And I set field "matart" to "CU" in row !lastRow
And I set field "matbasis" to "100" in row !lastRow
And I set field "matnotiz" to "110" in row !lastRow
And I save the current editor

Scenario: STAMMDATEN - Artikel um Materialzuschlag erweitern
Given I open an editor "artikel" from table "(Part):(Product)" with command "UPDATE" for record "V2"
And I set field "matart" to "CU"
And I set field "zmge" to "1"
And I set field "matvrel" to "ja"
And I save the current editor

Scenario: Normale Rechnung anlegen
Given I open an editor "rechnung1" from table "(Sales):(Invoice)" with command "NEW" for record ""
And I set field "kunde" to id from editor "kunde"
And I set field "betreff" to "Daten für Provisionsabrechnung"
And I set field "ueb" to "ja"
And I append rows
 | artex           | mge         | preis       | proz        | pwert       | pros  |
 | v1              | 10          | 25          | -5          |             | 5     |
 | a.              | 10          | 10          | 10          |             | 8     |
 | text            | !dontChange | !dontChange | !dontChange | 100         | 11    |
And I create a new row at the end of the table
And I set field "artex" to "V2" in row 4
And I set field "mge" to "10" in row 4
And I set field "pros" to "13" in row 4
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor
 
#Rechnung teilgutschreiben
Given I open an editor "twg1" from table "(Sales):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "rechnung1"
And I set field "ueb" to "ja"
And I set field "mge" to "-3" in row 1
And I set field "pwert" to "-20" in row 3
And I set field "mge" to "-4" in row 4
And I save the current editor

Scenario: Normale Rechnung anlegen
Given I open an editor "rechnung2" from table "(Sales):(Invoice)" with command "NEW" for record ""
And I set field "kunde" to id from editor "kunde"
And I set field "betreff" to "Daten für Provisionsabrechnung"
And I set field "ueb" to "ja"
And I append rows
 | artex           | mge         | preis       | proz        | pwert       |
 | v1              | 10          | 25          | -5          |             |
 | a.              | 10          | 10          | 10          |             |
 | text            | !dontChange | !dontChange | !dontChange | 100         |
And I create a new row at the end of the table
And I set field "artex" to "V2" in row 4
And I set field "mge" to "10" in row 4
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

#Rechnung teilweise rueckliefern
Given I open an editor "rlieferschein1" from table "(Sales):(Invoice)" with command "RETURN" for record from editor "rechnung2"
And I set field "ueb" to "ja"
And I set field "mge" to "-3" in row 1
And I set field "mge" to "-2" in row 2
And I set field "mge" to "-4" in row 4
And I save the current editor

#KGS zu Ruecklieferung
Given I open an editor "KGS1" from table "(Sales):(PackingSlip)" with command "INVOICE" for record from editor "rlieferschein1"
And I set field "ueb" to "ja"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

Scenario: Auftrag mit Fakturaplan anlegen
Given I open an editor "auftrag1" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set field "kunde" to id from editor "kunde"
And I set field "betreff" to "Daten für Provisionsabrechnung"
And I append rows
 | artex           | mge         | preis       | proz        | pwert       |
 | v1              | 10          | 25          | -5          |             |
 | a.              | 10          | 10          | 10          |             |
 | text            | !dontChange | !dontChange | !dontChange | 100         |
 And I create a new row at the end of the table
 And I set field "artex" to "v2" in row 4
 And I set field "mge" to "10" in row 4
 And I set field "proz" to "15" in row 4
 And I save the current editor
  
#Fakturaplan anlegen
Given I open an editor "fakturaplan1" from table "(BillingPlan):(BillingPlan)" with command "NEW" for record ""
And I set field "evvorgang" to id from editor "auftrag1"
And I set field "namebspr" to "Fakturaplan zu Auftrag für Provision"
And I append rows
 | reart     | proz | ptext        | zbed |
 | Anzahlung | 60   | 1. Anzahlung | 203  |
 | Anzahlung | 40   | 2. Anzahlung | 203  |

#Anzahlungsrechnungen anlegen und buchen
And I press button "anzahlungsrechn" to open a subeditor for "anzfakturaplan1" in row 1
And I set field "ueb" to "ja"
And I respond with answer "Ja" to the dialog with id "4841" 
And I save the current editor
And I switch the current editor to editor "fakturaplan1"
And I press button "anzahlungsrechn" to open a subeditor for "anzfakturaplan1" in row 2
And I set field "ueb" to "ja"
And I respond with answer "Ja" to the dialog with id "4841" 
And I save the current editor
And I switch the current editor to editor "fakturaplan1"
And I save the current editor

#Lieferschein aus Auftrag erzeugen
Given I open an editor "lieferschein1" from table "(Sales):(SalesOrder)" with command "DELIVERY" for record from editor "auftrag1"
And I set field "ueb" to "ja"
And I press button "offueb" in row 1
And I press button "offueb" in row 2
And I press button "offueb" in row 4
And I save the current editor

#Rechnung aus Lieferschein erzeugen
Given I open an editor "rechnung3" from table "(Sales):(PackingSlip)" with command "INVOICE" for record from editor "lieferschein1"
And I set field "ueb" to "ja"
And I respond with answer "Ja" to the dialog with id "4841" 
And I save the current editor

#Vertreter Maier
Scenario: Normale Rechnung anlegen
Given I open an editor "rechnung4" from table "(Sales):(Invoice)" with command "NEW" for record ""
And I set field "kunde" to "1"
And I set field "betreff" to "Daten für Provisionsabrechnung"
And I set field "zbed" to "200"
And I set field "ueb" to "ja"
And I append rows
 | artex           | mge         | preis       | proz        | pwert       |
 | v1              | 10          | 25          | -5          |             |
 | a.              | 10          | 10          | 10          |             |
 | text            | !dontChange | !dontChange | !dontChange | 100         |
And I create a new row at the end of the table
And I set field "artex" to "V2" in row 4
And I set field "mge" to "10" in row 4
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor
 
#Rechnung teilgutschreiben
Given I open an editor "twg2" from table "(Sales):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "rechnung4"
And I set field "ueb" to "ja"
And I set field "mge" to "-6" in row 1
And I set field "pwert" to "-40" in row 3
And I set field "mge" to "-2" in row 4
And I save the current editor

Scenario: Normale Rechnung anlegen
Given I open an editor "rechnung5" from table "(Sales):(Invoice)" with command "NEW" for record ""
And I set field "kunde" to "1"
And I set field "betreff" to "Daten für Provisionsabrechnung"
And I set field "zbed" to "200"
And I set field "ueb" to "ja"
And I append rows
 | artex           | mge         | preis       | proz        | pwert       |
 | v1              | 10          | 25          | -5          |             |
 | a.              | 10          | 10          | 10          |             |
 | text            | !dontChange | !dontChange | !dontChange | 100         |
And I create a new row at the end of the table
And I set field "artex" to "V2" in row 4
And I set field "mge" to "10" in row 4
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

#Rechnung teilweise rueckliefern
Given I open an editor "rlieferschein2" from table "(Sales):(Invoice)" with command "RETURN" for record from editor "rechnung5"
And I set field "ueb" to "ja"
And I set field "mge" to "-5" in row 1
And I set field "mge" to "-4" in row 2
And I set field "mge" to "-6" in row 4
And I save the current editor

#KGS zu Ruecklieferung
Given I open an editor "KGS2" from table "(Sales):(PackingSlip)" with command "INVOICE" for record from editor "rlieferschein2"
And I set field "ueb" to "ja"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

Scenario: Auftrag mit Fakturaplan anlegen
Given I open an editor "auftrag2" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set field "kunde" to "1"
And I set field "betreff" to "Daten für Provisionsabrechnung"
And I set field "zbed" to "200"
And I set field "budat" to "."
And I append rows
 | artex           | mge         | preis       | proz        | pwert       |
 | v1              | 10          | 25          | -5          |             |
 | a.              | 10          | 10          | 10          |             |
 | text            | !dontChange | !dontChange | !dontChange | 100         |
 And I create a new row at the end of the table
 And I set field "artex" to "v2" in row 4
 And I set field "mge" to "10" in row 4
 And I set field "proz" to "12" in row 4
 And I save the current editor
 
#Fakturaplan anlegen
Given I open an editor "fakturaplan2" from table "(BillingPlan):(BillingPlan)" with command "NEW" for record ""
And I set field "evvorgang" to id from editor "auftrag2"
And I set field "namebspr" to "Fakturaplan zu Auftrag für Provision"
And I append rows
 | reart     | proz | ptext        | zbed |
 | Anzahlung | 55   | 1. Anzahlung | 203  |
 | Anzahlung | 45   | 2. Anzahlung | 203  |

#Anzahlungsrechnungen anlegen
And I press button "anzahlungsrechn" to open a subeditor for "anzfakturaplan2" in row 1
And I set field "ueb" to "ja"
And I respond with answer "Ja" to the dialog with id "4841" 
And I save the current editor
And I switch the current editor to editor "fakturaplan2"
And I press button "anzahlungsrechn" to open a subeditor for "anzfakturaplan2" in row 2
And I set field "ueb" to "ja"
And I respond with answer "Ja" to the dialog with id "4841" 
And I save the current editor
And I switch the current editor to editor "fakturaplan2"
And I save the current editor

#Lieferschein aus Auftrag erzeugen
Given I open an editor "lieferschein2" from table "(Sales):(SalesOrder)" with command "DELIVERY" for record from editor "auftrag2"
And I set field "ueb" to "ja"
And I press button "offueb" in row 1
And I press button "offueb" in row 2
And I press button "offueb" in row 4
And I save the current editor

#Rechnung aus Lieferschein erzeugen
Given I open an editor "rechnung6" from table "(Sales):(PackingSlip)" with command "INVOICE" for record from editor "lieferschein2"
And I set field "ueb" to "ja"
And I respond with answer "Ja" to the dialog with id "4841" 
And I save the current editor

#Rechnung stornieren
Scenario: Normale Rechnung anlegen
Given I open an editor "rechnung7" from table "(Sales):(Invoice)" with command "NEW" for record ""
And I set field "kunde" to id from editor "kunde"
And I set field "betreff" to "Daten für Provisionsabrechnung"
And I set field "ueb" to "ja"
And I append rows
 | artex           | mge         | preis       | proz        | pwert       |
 | v1              | 10          | 25          | -5          |             |
 | a.              | 10          | 10          | 10          |             |
 | text            | !dontChange | !dontChange | !dontChange | 100         |
And I create a new row at the end of the table
And I set field "artex" to "V2" in row 4
And I set field "mge" to "10" in row 4
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

#Rechnung stornieren
Given I open an editor "stornorech1" from table "(Sales):(Invoice)" with command "REVERSAL" for record from editor "rechnung7"
And I save the current editor 

Scenario: Offene Posten ausbuchen
Given I open an editor "opausbuchen" from table "(OIProcessing):(DebitOutstandingItems)" with command "NEW" for record ""
And I set field "gkonto" to "18100"
And I set field "beleg" to "provi"
And I set field "opausgleich" to "ja"
And I press button "opladen"
And I respond with answer "Ja" to the dialog with id "588"
And I save the current editor

Scenario:  Infosystem starten COMMISSION zum Tagesdatum
Given I open the infosystem "COMMISSION"
And I set field "provibis" to "."
And I set field "zahleingang" to "1"
And I press start
Then the table has 82 rows
And I append ScenarioHeadline to output file "$REF_FILE"
And I export fields "$Feldliste" from table content to output file "$REF_FILE"
And I close the current editor

Scenario:  Infosystem starten COMMISSION zum Tagesdatum mit Verteter 70001
Given I open the infosystem "COMMISSION"
And I set field "provibis" to "1.1.95"
And I set field "provibis" to "."
And I set field "kvertret" to "70001"
And I press start
Then the table has 47 rows
And I append ScenarioHeadline to output file "$REF_FILE"
And I export fields "$Feldliste" from table content to output file "$REF_FILE"
And I close the current editor

Scenario:  Infosystem starten COMMISSION zum Tagesdatum und verbuchen
Given I open the infosystem "COMMISSION"
And I set field "provivon" to "1.1.95"
And I set field "provibis" to "."
And I set field "kvertret" to "4"
And I press start
Then the table has 35 rows
And I append ScenarioHeadline to output file "$REF_FILE"
And I export fields "$Feldliste" from table content to output file "$REF_FILE"
# Vertreter 4 verbuchen -> dies erzeugt Datenbanknummer 1
And I set field "bprovverbuchen" to "1"
And I press button "bupovis"
Then the table has 35 rows
And I append ScenarioHeadline to output file "$REF_FILE"
And I export fields "$Feldliste" from table content to output file "$REF_FILE"

And I set field "provis" to "1"
And I press start
Then the table has 28 rows
And I append ScenarioHeadline to output file "$REF_FILE"
And I export fields "$Feldliste" from table content to output file "$REF_FILE"

And I set field "lang" to "1"
And I press start
Then the table has 35 rows
And I append ScenarioHeadline to output file "$REF_FILE"
And I export fields "$Feldliste" from table content to output file "$REF_FILE"
And I close the current editor

Scenario:  Infosystem starten COMMISSION zum Tagesdatum nach verbuchen von Vertreter 4 nochmal laden. Es bleibt nur Vertreter 70001
Given I open the infosystem "COMMISSION"
And I set field "provibis" to "."
And I set field "bprovverbuchen" to "1"
And I press start
And I press button "bupovis"
Then the table has 47 rows
And I append ScenarioHeadline to output file "$REF_FILE"
And I export fields "$Feldliste" from table content to output file "$REF_FILE"

And I set field "provis" to "2"
And I press start
Then the table has 38 rows
And I append ScenarioHeadline to output file "$REF_FILE"
And I export fields "$Feldliste" from table content to output file "$REF_FILE"
And I close the current editor

Scenario:  Infosystem starten COMMISSION zum Tagesdatum nach verbuchen nochmal laden
Given I open the infosystem "COMMISSION"
And I set field "provibis" to "."
And I press start
Then the table has 0 rows

Scenario: Neuen Zahlungsverteiler anlegen
Given I open an editor "zahlvert" from table "(PaymentMasterFiles):(PaymentDistributor)" with command "STORE" for record "zahlvert"
And I set field "such" to "zahlvert"
And I set field "namebspr" to "Zahlungsverteiler für Provisionsabrechnung"
And I create a new row at the end of the table
And I set field "proz" to "40" in row 1
And I set field "zbed" to "200" in row 1
And I create a new row at the end of the table
And I set field "proz" to "60" in row 2
And I set field "zbed" to "201" in row 2
And I save the current editor

#Rechnung mit Zahlungsverteiler anlegen
Scenario: Rechnung mit Zahlungsverteiler anlegen
Given I open an editor "rechnung8" from table "(Sales):(Invoice)" with command "NEW" for record ""
And I set field "kunde" to id from editor "kunde"
And I set field "betreff" to "Daten für Provisionsabrechnung"
And I set field "zbedvert" to id from editor "zahlvert"
And I set field "ueb" to "ja"
And I append rows
 | artex           | mge         | preis       | proz        | pwert       |
 | v1              | 10          | 25          | -5          |             |
 | a.              | 10          | 10          | 10          |             |
 | text            | !dontChange | !dontChange | !dontChange | 100         |
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

Scenario:  Infosystem starten COMMISSION zum Tagesdatum Rechnung mit Zahlungsverteiler
Given I open the infosystem "COMMISSION"
And I set field "provibis" to "."
And I set field "zahleingang" to "1"
And I press start
Then the table has 4 rows
And I append ScenarioHeadline to output file "$REF_FILE"
And I export fields "$Feldliste" from table content to output file "$REF_FILE"
And I close the current editor

Scenario: Erster Offener Posten ausbuchen
Given I open an editor "opausbuchen" from table "(OIProcessing):(DebitOutstandingItems)" with command "NEW" for record ""
And I set field "gkonto" to "18100"
And I set field "beleg" to "provi"
And I press button "opladen"
And the table has 2 rows
And I press button "tueber" in row 1
And I respond with answer "Ja" to the dialog with id "588"
And I save the current editor

Scenario:  Infosystem starten COMMISSION zum Tagesdatum, erster OP ausgebucht
Given I open the infosystem "COMMISSION"
And I set field "provibis" to "."
And I set field "zahleingang" to "1"
And I press start
Then the table has 4 rows
And I append ScenarioHeadline to output file "$REF_FILE"
And I export fields "$Feldliste" from table content to output file "$REF_FILE"

And I set field "bprovverbuchen" to "1"
And I press button "bupovis"
Then the table has 4 rows

# die Provisionsdatenbankfelder sind gefuellt
And I append ScenarioHeadline to output file "$REF_FILE"
And I export fields "$Feldliste" from table content to output file "$REF_FILE"

And I press start
Then the table has 4 rows
# pzrech ist jetzt leer
And I append ScenarioHeadline to output file "$REF_FILE"
And I export fields "$Feldliste" from table content to output file "$REF_FILE"

And I set field "datefrom" to "-10"
And I press start
Then the table has 69 rows
And I append ScenarioHeadline to output file "$REF_FILE"
And I export fields "$Feldliste" from table content to output file "$REF_FILE"
And I set field "provis" to "3"
And I press start
Then the table has 3 rows
And I append ScenarioHeadline to output file "$REF_FILE"
And I export fields "$Feldliste" from table content to output file "$REF_FILE"
And I close the current editor

Scenario: zweiter Offener Posten ausbuchen
Given I open an editor "opausbuchen" from table "(OIProcessing):(DebitOutstandingItems)" with command "NEW" for record ""
And I set field "gkonto" to "18100"
And I set field "beleg" to "provi"
And I press button "opladen"
And the table has 1 rows
And I press button "tueber" in row 1
And I respond with answer "Ja" to the dialog with id "588"
And I save the current editor

Scenario:  Infosystem starten COMMISSION zum Tagesdatum, zweiter OP ausgebucht
Given I open the infosystem "COMMISSION"
And I set field "provibis" to "."
And I set field "zahleingang" to "1"
And I press start
Then the table has 4 rows
And I append ScenarioHeadline to output file "$REF_FILE"
And I export fields "$Feldliste" from table content to output file "$REF_FILE"
And I set field "bprovverbuchen" to "1"
And I press button "bupovis"
Then the table has 4 rows
And I close the current editor

#Rechnung anlegen und teilweise ausbuchen
Scenario: Rechnung anlegen
Given I open an editor "rechnung9" from table "(Sales):(Invoice)" with command "NEW" for record ""
And I set field "kunde" to id from editor "kunde"
And I set field "betreff" to "Daten für Provisionsabrechnung"
And I set field "ueb" to "ja"
And I append rows
 | artex           | mge         | preis       | proz        | pwert       |
 | v1              | 10          | 25          | -5          |             |
 | a.              | 10          | 10          | 10          |             |
 | text            | !dontChange | !dontChange | !dontChange | 100         |
 | v2              | 10          |             |             | !dontChange |
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

#Rechnung teilweise ausbuchen
Given I open an editor "opausbuchen" from table "(OIProcessing):(DebitOutstandingItems)" with command "NEW" for record ""
And I set field "gkonto" to "18100"
And I set field "beleg" to "provi"
And I press button "opladen"
And the table has 1 rows
And I press button "tueber" in row 1
And I set field "opzabetr" to "400" in row 1
And I respond with answer "Ja" to the dialog with id "588"
And I save the current editor

Scenario:  Infosystem starten COMMISSION zum Tagesdatum, Rechnung teilweise ausgebucht (400 Euro + 12,37 Euro Skonto)
Given I open the infosystem "COMMISSION"
And I set field "provibis" to "."
And I set field "zahleingang" to "1"
And I press start
Then the table has 6 rows
And I append ScenarioHeadline to output file "$REF_FILE"
And I export fields "$Feldliste" from table content to output file "$REF_FILE"
#Jetzt Provisionsabrechnung durchführen
And I set field "bprovverbuchen" to "1"
And I press button "bupovis"
Then the table has 6 rows
And I append ScenarioHeadline to output file "$REF_FILE"
And I export fields "$Feldliste" from table content to output file "$REF_FILE"
# Provisionierung Nr. 5
And I close the current editor

#Restzahlung ausbuchen
Given I open an editor "opausbuchen" from table "(OIProcessing):(DebitOutstandingItems)" with command "NEW" for record ""
And I set field "gkonto" to "18100"
And I set field "beleg" to "provi"
And I press button "opladen"
And the table has 1 rows
And I press button "tueber" in row 1
And I respond with answer "Ja" to the dialog with id "588"
And I save the current editor

Scenario:  Infosystem starten COMMISSION zum Tagesdatum, Rechnung rest gebucht (219,90 Euro)
Given I open the infosystem "COMMISSION"
And I set field "provibis" to "."
And I set field "zahleingang" to "1"
And I press start
Then the table has 6 rows
And I append ScenarioHeadline to output file "$REF_FILE"
And I export fields "$Feldliste" from table content to output file "$REF_FILE"
#Jetzt wieder Provisionsabrechnung durchführen
And I set field "bprovverbuchen" to "1"
And I press button "bupovis"
Then the table has 6 rows
And I append ScenarioHeadline to output file "$REF_FILE"
And I export fields "$Feldliste" from table content to output file "$REF_FILE"
And I close the current editor
