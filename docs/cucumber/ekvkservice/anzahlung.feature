# *****************************************************************************
#  Name           : anzahlung.feature
#  Autor          : mibr
#  Verantwortlich : teampss
#  Funktion       : Tests fuer Anzahlungen EK/VK
#                   Anzahlungen werden ueber einen Fakturaplan verwaltet
#
# *****************************************************************************
#
Feature: Anzahlungstests EK/VK
Background:
Given I set the fake date to "02.01.1995"

@EVS-165
@persistent
Scenario: Pruefung auf offene Posten auf Anzahlungsebene statt AU/BE-Ebene
Given I open an editor "kunde" from table "(Customer):(Customer)" with command "STORE" for record "Bayram"
And I set fields

 | such     | Rebayram                    |
 | namebspr | Bayram Werkzeugbau, Rastatt |
 | ans      | Bayram Werkzeugbau GmbH     |
 | str      | Riedstr. 24-28              |
 | plz      | 76437                       |
 | nort     | Rastatt                     |
 | region   | BADEN                       |
 | tele     | +49 (0) 7222/9456-0         |
 | email    | info@bayram-corp.de         |
 | betreuer | .                           |
 | ustid    | DE56454651                  |
 | lbed     | EXW                         |
 | zbed     | 201                         |
And I save the current editor
Then field "name" has value "Bayram Werkzeugbau, Rastatt"
Then field "zbed" has value "201"
@EVS-165
@persistent
Scenario: Neuen Artikel anlegen
Given I open an editor "artikel" from table "(Part):(Product)" with command "STORE" for record "traktor10ps"
And I set fields
 |  such     | traktor10ps         |
 |  namebspr | Rasentraktor 10 PS  |
 |  vkbez    | Rasentraktor 10 PS  |
 |  vbez     | Rasentraktor 10 PS  |
 |  ebez     | Rasentraktor 10 PS  |
 |  vpr      | 10000               |
 |  bsart    | Fremdbeschaffung    |
 |  dispoa   | bedarfsbezogen      |
And I save the current editor
Then field "such" has value "TRAKTOR10PS"
@EVS-165
@persistent
Scenario: Testcase AU165 Auftrag anlegen
Given I open an editor "auftrag" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set field "kunde" to id from editor "kunde"
And I set field "betreff" to "Testcase AU165 (Anzahlungen mit Fakturaplan)"
And I create a new row at the end of the table
And I set field "artex" to id from editor "artikel" in row 1
And I set field "mge" to "1" in row 1
And I save the current editor
Then field "fktaplan" is empty
Then field "zbed" has value "201"
@EVS-165
@persistent
Scenario: Testcase AU165 Fakturaplan anlegen
Given I open an editor "fakturaplan" from table "186:3" with command "NEW" for record ""
And I set field "evvorgang" to id from editor "auftrag"
And I set fields
 |  namebspr   | Test-Fakturaplan AU165 |
 |  such       | TF-AU165               |
And I append rows
| reart     | anzpwert | ptext        | zbed |
| Anzahlung | 1000     | 1. Anzahlung | 203  |
| Anzahlung | 2000     | 2. Anzahlung | 203  |
And I press button "anzahlungsrechn" to open a subeditor for "anzrecherstellen" in row 1
And I set field "ueb" to "ja"
And I set field "pwert" to "100.00" in row 1
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor
And I switch the current editor to editor "fakturaplan"
And I press button "anzahlungsrechn" to open a subeditor for "anzrecherstellen" in row 1
And I set field "ueb" to "ja"
And I set field "pwert" to "200.00" in row 1
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor
And I switch the current editor to editor "fakturaplan"
Then the table has 2 rows
And I save the current editor
@EVS-165
@persistent
Scenario: Testcase AU165 Offener Posten ausbuchen
Given I open an editor "OP-Bearbeitung" from table "102:4" with command "NEW" for record ""
And I set field "gkonto" to "18100"
And I set field "beleg" to "1"
And I press button "opladen"
And I set field "opzabetr" to "115" in row 1
And I set field "opzabetr" to "230" in row 2
And I respond with answer "ja" to the dialog with id "588"
And I save the current editor
@EVS-165
@persistent
Scenario: Testcase AU165 Anzahlungsrechnung anlegen
Given I open an editor "fakturaplan" from table "186:3" with command "UPDATE" for record "TF-AU165"
And I press button "anzahlungsrechn" to open a subeditor for "anzrecherstellen" in row 1
And I set field "ueb" to "ja"
And I set field "pwert" to "50.00" in row 1
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor
And I switch the current editor to editor "fakturaplan"
And I save the current editor
@EVS-165
@persistent
Scenario: Testcase AU165 Lieferschein fuer erste Position buchen
Given I open an editor "lieferschein" from table "(Sales):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "auftrag"
And I set field "betreff" to "Testcase AU165 (Lieferschein für erste Position buchen)"
And I set field "ueb" to "ja"
And I set field "mge" to "1" in row 1
And I save the current editor
@EVS-165
Scenario: Testcase AU165 Schlussrechnung erzeugen
Given I open an editor "rechnung" from table "(Sales):(Invoice)" with command "NEW" for record ""
And I set field "betreff" to "Testcase AU165 (Schlussrechnung erzeugen)"
And I set field "beleg" to id from editor "lieferschein"
Then the table has 5 rows
Then field "pwert" has value "-100.00" in row 2
Then field "pwert" has value "-200.00" in row 3
Then field "pwert" has value "-50.00" in row 4
Then field "pwert" has value "0.00" in row 5
When I set field "reanzposbezahltueb" to "ja"
Then the table has 3 rows
Then field "pwert" has value "-100.00" in row 2
Then field "pwert" has value "-200.00" in row 3
When I delete all rows
And I set field "beleg" to id from editor "lieferschein"
Then the table has 3 rows
Then field "pwert" has value "-100.00" in row 2
Then field "pwert" has value "-200.00" in row 3
And I set field "budat" to "."
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

#####################################################################################################################################
# VERKAUF
#####################################################################################################################################

@EVS-166
@persistent
# Auftrag -> Fakturaplan -> Anzahlungsrechnung stornieren
Scenario: STAMMDATEN - Neuen Lieferanten anlegen
Given I open an editor "lieferant" from table "(Vendor):(Vendor)" with command "STORE" for record "REUS"
And I set field "such" to "REUS"
And I set field "namebspr" to "Reus Werkzeugbau, Rastatt"
And I set field "ans" to "Reus Werkzeugbau GmbH"
And I set field "str" to "Riedstr. 24-28"
And I set field "plz" to "76437"
And I set field "nort" to "Rastatt"
And I set field "tele" to "+49 (0) 7222/9456-0"
And I set field "email" to "info@bayram-corp.de"
And I set field "betreuer" to "."
And I set field "ans2" to "Reus Fussball GmbH"
And I set field "str2" to "Bvbstr. 24-28"
And I set field "plz2" to "33333"
And I set field "nort2" to "Dortmund"
And I set field "ustid" to "DE56454651"
And I set field "lbed" to "EXW"
And I set field "zbed" to "201"
And I save the current editor
Then field "name" has value "Reus Werkzeugbau, Rastatt"
Then field "zbed" has value "201"

Scenario Outline: STAMMDATEN - Zwei neue Artikel anlegen
Given I open an editor "<such>" from table "(Part):(Product)" with command "STORE" for record "<such>"
And I set field "such" to "<such>"
And I set field "namebspr" to "<namebspr>"
And I set field "vkbez" to "<vkbez>"
And I set field "vbez" to "<vbez>"
And I set field "ebez" to "<ebez>"
And I set field "vpr" to "<vpr>"
And I set field "bsart" to "<bsart>"
And I set field "dispoa" to "<dispoa>"
And I set field "lief" to "<lief>"
And I set field "epr" to "<epr>"
And I set field "efrist" to "<efrist>"
And I set field "matart" to "<matart>"
And I set field "zmge" to "<zmge>"
And I set field "matvrel" to "<matvrel>"
And I set field "materel" to "<materel>"
And I save the current editor

Examples: Artikel
 |such     |namebspr  |vkbez     |vbez      |ebez      |vpr   |bsart            |dispoa         |lief |epr  |efrist |matart      |zmge       |matvrel    |materel|
 |artikel1 |Artikel 1 |Artikel 1 |Artikel 1 |Artikel 1 |10000 |Fremdbeschaffung |bedarfsbezogen |reus |9000 |15     |CU          |1          |ja         |ja     |
 |artikel2 |Artikel 2 |Artikel 2 |Artikel 2 |Artikel 2 | 9000 |Fremdbeschaffung |bedarfsbezogen |reus |7000 |10     |!dontChange |!dontChange|!dontChange|!dontChange|

@EVS-166
Scenario: Auftrag anlegen mit Anzahlungen in der Schlussrechnung
Given I open an editor "auftrag" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set field "kunde" to id from editor "kunde"
And I set field "betreff" to "Auftrag mit Fakturaplan"
When I create a new row at the end of the table
And I set field "artex" to id from editor "artikel1" in row 1
And I set field "mge" to "1" in row 1
And I create a new row at the end of the table
And I set field "artex" to id from editor "artikel2" in row !lastRow
And I set field "mge" to "1" in row !lastRow
And I save the current editor
Then field "fktaplan" is empty
Then field "zbed" has value "201"

# Fakturaplan fuer Auftrag anlegen
Given I open an editor "vkfakturaplan" from table "(BillingPlan):(BillingPlan)" with command "NEW" for record ""
And I set field "evvorgang" to id from editor "auftrag"
And I set field "namebspr" to "Fakturaplan zu Auftrag"
And I create a new row at the end of the table
And I set field "reart" to "Anzahlung" in row 1
And I set field "proz" to "20" in row 1
And I set field "ptext" to "1. Anzahlung" in row 1
And I set field "zbed" to "203" in row 1
And I create a new row at the end of the table
And I set field "reart" to "Anzahlung" in row 2
And I set field "proz" to "10" in row 2
And I set field "ptext" to "2. Anzahlung" in row 2
And I set field "zbed" to "203" in row 2

# Anzahlungsrechnung anlegen
And I press button "anzahlungsrechn" to open a subeditor for "vkanzahlung" in row 1
And I set field "ueb" to "ja"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor
And I switch the current editor to editor "vkfakturaplan"
Then field "sumfakturiert" has value "1942.91" in row 1
And I save the current editor

# Schlussrechnung anlegen
Given I open an editor "vkrechnung" from table "(Sales):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "auftrag"
And I set field "ueb" to "ja"
And I press button "offueb" in row 1
And I press button "offueb" in row 2
And I press button "offueb" in row 3
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Anzahlungsrechnung stornieren nicht erlaubt, weil in Schlussrechnung vorhanden
Then opening an editor from table "(Sales):(Invoice)" with command "REVERSAL" for record from editor "vkanzahlung" throws the exception "1839"
And I close the current editor

# Schlussrechnung rueckliefern, Anzahlungsrechnung nicht im Ruecklieferschein uebernehmen
Given I open an editor "vkrueck" from table "(Sales):(Invoice)" with command "RETURN" for record from editor "vkrechnung"
Then the table has 2 rows
Then field "artex" has value "ARTIKEL1" in row 1
Then field "artex" has value "ARTIKEL2" in row 2
And I close the current editor

#### VK Anzahlung in einer Barrechnung ####

Scenario: Auftrag anlegen mit Anzahlungen in einer Rechnung  der Art "Barzahlung"
Given I open an editor "auftrag2" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set field "kunde" to id from editor "kunde"
And I set field "betreff" to "Auftrag2 mit Fakturaplan"
When I create a new row at the end of the table
And I set field "artex" to id from editor "artikel1" in row 1
And I set field "mge" to "2" in row 1
And I create a new row at the end of the table
And I set field "artex" to id from editor "artikel2" in row !lastRow
And I set field "mge" to "2" in row !lastRow
And I save the current editor
Then field "fktaplan" is empty
Then field "zbed" has value "201"

# Fakturaplan fuer Auftrag anlegen
Given I open an editor "vkfakturaplan" from table "(BillingPlan):(BillingPlan)" with command "NEW" for record ""
And I set field "evvorgang" to id from editor "auftrag2"
And I set field "namebspr" to "Fakturaplan zu Auftrag 2"
And I create a new row at the end of the table
And I set field "reart" to "Anzahlung" in row 1
And I set field "proz" to "20" in row 1
And I set field "ptext" to "1. Anzahlung" in row 1
And I set field "zbed" to "203" in row 1
And I create a new row at the end of the table
And I set field "reart" to "Anzahlung" in row 2
And I set field "proz" to "10" in row 2
And I set field "ptext" to "2. Anzahlung" in row 2
And I set field "zbed" to "203" in row 2

# Anzahlungsrechnung anlegen
And I press button "anzahlungsrechn" to open a subeditor for "vkanzahlung2" in row 1
And I set field "ueb" to "ja"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor
And I switch the current editor to editor "vkfakturaplan"
Then field "sumfakturiert" has value "3885.82" in row 1
And I save the current editor

# Barrechnung anlegen
Given I open an editor "vkbarrechnung" from table "(Sales):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "auftrag2"
And I set field "ueb" to "ja"
And I press button "offueb" in row 1
And I press button "offueb" in row 2
And I set field "vorganga" to "Barzahlung"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Anzahlungsrechnung stornieren nicht erlaubt, weil in Bar-Rechnung vorhanden
Then opening an editor from table "(Sales):(Invoice)" with command "REVERSAL" for record from editor "vkanzahlung2" throws the exception "1839"
And I close the current editor

# Barrechnung rueckliefern
Given I open an editor "vkbarrueck" from table "(Sales):(Invoice)" with command "RETURN" for record from editor "vkbarrechnung"
Then the table has 2 rows
And I close the current editor

#####################################################################################################################################
# EINKAUF
#####################################################################################################################################

@EVS-167
@persistent
# Bestellung -> Fakturaplan -> Anzahlungsrechnung stornieren
Scenario: Bestellung anlegen
Given I open an editor "bestellung" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set field "lief" to id from editor "lieferant"
And I set field "betreff" to "Bestellung mit Fakturaplan"
When I create a new row at the end of the table
And I set field "artex" to id from editor "artikel1" in row 1
And I set field "mge" to "1" in row 1
And I create a new row at the end of the table
And I set field "artex" to id from editor "artikel2" in row !lastRow
And I set field "mge" to "1" in row !lastRow
And I save the current editor
Then field "fktaplan" is empty
Then field "zbed" has value "201"

# Fakturaplan fuer Bestellung anlegen
Given I open an editor "ekfakturaplan" from table "(BillingPlan):(BillingPlan)" with command "NEW" for record ""
And I set field "evvorgang" to id from editor "bestellung"
And I set field "namebspr" to "Fakturaplan zu Bestellung"
And I create a new row at the end of the table
And I set field "reart" to "Anzahlung" in row 1
And I set field "proz" to "20" in row 1
And I set field "ptext" to "1. Anzahlung" in row 1
And I set field "zbed" to "203" in row 1
And I create a new row at the end of the table
And I set field "reart" to "Anzahlung" in row 2
And I set field "proz" to "10" in row 2
And I set field "ptext" to "2. Anzahlung" in row 2
And I set field "zbed" to "203" in row 2

# Anzahlungsrechnung anlegen
And I press button "anzahlungsrechn" to open a subeditor for "ekanzahlung" in row 1
And I set field "ueb" to "ja"
And I set field "ebeleg" to "EK Anzahlungsrechnung"
And I set field "vom" to "."
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor
And I switch the current editor to editor "ekfakturaplan"
Then field "sumfakturiert" has value "3200.00" in row 1
And I save the current editor

# Schlussrechnung anlegen
Given I open an editor "ekrechnung" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "bestellung"
And I set field "ebeleg" to "Schlussrechnung"
And I set field "vom" to "."
And I set field "ueb" to "ja"
And I press button "offueb" in row 1
And I press button "offueb" in row 2
And I press button "offueb" in row 3
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Anzahlungsrechnung stornieren, wenn Schulssrechnung vorhanden nicht erlauben
Then opening an editor from table "(Purchasing):(Invoice)" with command "REVERSAL" for record from editor "ekanzahlung" throws the exception "1839"
And I close the current editor

# Schlussrechnung rueckliefern, Anzahlungsrechnung nicht im Ruecklieferschein uebernehmen
Given I open an editor "ekrueck" from table "(Purchasing):(Invoice)" with command "RETURN" for record from editor "ekrechnung"
Then the table has 2 rows
Then field "artex" has value "ARTIKEL1" in row 1
Then field "artex" has value "ARTIKEL2" in row 2
And I close the current editor

#### EK Anzahlung in einer Barrechnung ####

Scenario: Bestellung anlegen mit Anzahlungen in einer Rechnung  der Art "Barzahlung"
Given I open an editor "bestellung2" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set field "lief" to id from editor "lieferant"
And I set field "betreff" to "Bestellung2 mit Fakturaplan"
When I create a new row at the end of the table
And I set field "artex" to id from editor "artikel1" in row 1
And I set field "mge" to "2" in row 1
And I create a new row at the end of the table
And I set field "artex" to id from editor "artikel2" in row !lastRow
And I set field "mge" to "2" in row !lastRow
And I save the current editor
Then field "fktaplan" is empty
Then field "zbed" has value "201"

# Fakturaplan fuer Bestellung anlegen
Given I open an editor "ekfakturaplan" from table "(BillingPlan):(BillingPlan)" with command "NEW" for record ""
And I set field "evvorgang" to id from editor "bestellung2"
And I set field "namebspr" to "Fakturaplan zu Bestellung 2"
And I create a new row at the end of the table
And I set field "reart" to "Anzahlung" in row 1
And I set field "proz" to "20" in row 1
And I set field "ptext" to "1. Anzahlung" in row 1
And I set field "zbed" to "203" in row 1
And I create a new row at the end of the table
And I set field "reart" to "Anzahlung" in row 2
And I set field "proz" to "10" in row 2
And I set field "ptext" to "2. Anzahlung" in row 2
And I set field "zbed" to "203" in row 2

# Anzahlungsrechnung anlegen
And I press button "anzahlungsrechn" to open a subeditor for "ekanzahlung2" in row 1
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "ebeleg" to "EK Anzahlungsrechnung 2"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor
And I switch the current editor to editor "ekfakturaplan"
Then field "sumfakturiert" has value "6400.00" in row 1
And I save the current editor

# Barrechnung anlegen
Given I open an editor "ekbarrechnung" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "bestellung2"
And I set field "ebeleg" to "EK Barrechnung"
And I set field "vom" to "."
And I set field "ueb" to "ja"
And I press button "offueb" in row 1
And I press button "offueb" in row 2
And I set field "vorganga" to "Barzahlung"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Anzahlungsrechnung stornieren nicht erlaubt, weil in Bar-Rechnung vorhanden
Then opening an editor from table "(Purchasing):(Invoice)" with command "REVERSAL" for record from editor "ekanzahlung2" throws the exception "1839"
And I close the current editor

# Barrechnung rueckliefern
Given I open an editor "ekbarrueck" from table "(Purchasing):(Invoice)" with command "RETURN" for record from editor "ekbarrechnung"
Then the table has 2 rows
And I close the current editor

#####################################################################################################################################
# EINKAUF - Anzahlungspositionen mit eigener Steuerposition
#####################################################################################################################################

Scenario: Anzahlungspositionen mit eigener Steuerposition

# Bestellung mit Rechnungsabschluss
Given I open an editor "1BE001" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set fields
   | nummer | 1BE001 |
   | lief   | 1      |
And I append rows
   | artikel | mge            |
   | E2      | 10             |
   | NS.     | !dontChange    |
And I save the current editor

# Fakturaplan zur Bestellung
Given I open an editor "fakturaplan" from table "(BillingPlan):(BillingPlan)" with command "NEW" for record ""
And I set fields
   | evvorgang | E 1BE001 |
And I append rows
   | reart     | proz | zbed | ptext        |
   | Anzahlung | 10   | 203  | 1. Anzahlung |
# Anzahlungsrechnung anlegen und buchen
And I press button "anzahlungsrechn" to open a subeditor for "ekanzahlung" in row 1
And I set fields
   | nummer | 1ANZ001 |
   | vom    | .       |
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor
And I switch the current editor to editor "fakturaplan"
And I save the current editor

# Schlussrechnung anlegen
Given I open an editor "1RE001" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set fields
   | beleg          | 1BE001 |
   | nummer         | 1RE001 |
   | vom            | .      |
   | ueb            | ja     |
   | reanzpossteuer | ja     |
And I press button "offueb" in row 1
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Schlussrechnung stornieren
Given I open an editor "1RE001S" from table "(Purchasing):(Invoice)" with command "REVERSAL" for record from editor "1RE001"
And I set field "nummer" to "1RE001S"
And I save the current editor

#####################################################################################################################################
# VERKAUF
#####################################################################################################################################

@EVS-168
@persistent
Scenario: Testcase AU168 Auftrag anlegen
Given I open an editor "auftrag168" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set fields
   | nummer  | 1AU168   |
   | kunde   | Rebayram |
   | such    | AU168    |
   | betreff | Testcase AU168 (Anzahlungen mit Fakturaplan) |
And I append rows
   | artikel    | mge         |
   | ARTIKEL1   | 20          |
   | ANZAHLUNG  | !dontChange |
   | NS         | !dontChange |
Then the table has 5 rows
And I save the current editor

# Testcase AU168 Anzahlungsrechnung erstellen
Given I open an editor "anzrech168" from table "(Sales):(Invoice)" with command "NEW" for record ""
And I set fields
   | vorganga | (Downpayment) |
   | beleg    | 1AU168        |
   | nummer   | 1ANZ168       |
   | such     | ANZ68         |
   | betreff  | Testcase AU168 (Anzahlungsrechnung erzeugen) |
   | vom      | .             |
   | ueb      | ja            |
Then the table has 1 rows
And I set field "pwert" to "10.00" in row 1
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Testcase AU168 Rechnung erzeugen
Given I open an editor "rechnung168" from table "(Sales):(Invoice)" with command "NEW" for record ""
And I set fields
   | beleg   | 1AU168   |
   | nummer  | 1RE168   |
   | such    | RE168    |
   | betreff | Testcase AU168 (Rechnung erzeugen) |
Then the table has 5 rows
And I delete row at position 1
And I delete row at position 2
Then the table has 3 rows
# Es passiert nichts, da nur Steuerpositionen vorhanden sind
Then I set field "reanzposbezahltueb" to "ja"
And I close the current editor

#####################################################################################################################################
Scenario: Fakturaplan und Schlussrechnung zu einem Serviceauftrag
#####################################################################################################################################

Given I open an editor "1AU170" from table "(Sales):(ServiceOrder)" with command "NEW" for record ""
And I set fields
   | nummer  | 1AU170   |
   | kunde   | 1        |
And I append rows
   | artikel    | mge  | preis |
   | ARTIKEL1   | 20   | 10    |
And I save the current editor

# Fakturaplan fuer Auftrag anlegen
Given I open an editor "fakturaplan" from table "(BillingPlan):(BillingPlan)" with command "NEW" for record ""
And I set field "evvorgang" to id from editor "1AU170"
And I append rows
   | reart     | proz | zbed |
	| Anzahlung | 10   | 203  |
# Anzahlungsrechnung anlegen
And I press button "anzahlungsrechn" to open a subeditor for "vkanzahlung" in row 1
And I set fields
	| nummer | 1ANZ170 |
   | ueb    | ja      |
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor
And I switch the current editor to editor "fakturaplan"
And I save the current editor

# Schlussrechnung anlegen
Given I open an editor "1RE170" from table "(Sales):(Invoice)" with command "NEW" for record ""
And I set fields
   | beleg   | 1AU170 |
	| nummer  | 1RE170 |
	| tterm   | .      |
	| ueb     | ja     |
And I press button "offueb" in row 1
Then field "pwert" has value "-20.00" in row 2
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

#####################################################################################################################################
# EINKAUF - Beide Anzahlungspositionen bei Steuersofortabzug in der Schlussrechnung ausweisen
#####################################################################################################################################
# Bestellung -> Fakturaplan -> Anzahlungsrechnung
Scenario: Bestellung anlegen
Given I open an editor "BE01_ANZ" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set fields
   | nummer   | 01BE_ANZ           |
   | lief     | REUS               |
   | betreff  | BE mit Fakturaplan |
   | vrgstrgl | EKINLRC            | # Steuersofortabzug
And I append rows
  | artikel  | mge |
  | artikel1 |   1 |
# Fakturaplan aus/fuer Bestellung anlegen
And I press button "fktaplanabsteigen" to open a subeditor for "FAKTURA_BE01_ANZ"
And I append rows
  | reart     | proz | ptext        | zbed |
  | Anzahlung |  100 | 1. Anzahlung |  203 |
# Anzahlungsrechnung anlegen
And I press button "anzahlungsrechn" to open a subeditor for "ekanzahlung1" in row 1
And I set fields
   | ebeleg | EK Anzahlungsrechnung 1 |
   | vom    | .             |
   | ueb    | ja            |
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor
And I switch the current editor to editor "FAKTURA_BE01_ANZ"
Then field "sumfakturiert" has value "9000.00" in row 1
And I save the current editor
And I switch the current editor to editor "BE01_ANZ"
And I save the current editor

# Schlussrechnung anlegen
Given I open an editor "EK_Rechnung" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "BE01_ANZ"
And I press button "offueb" in row 1
And I set fields
   | nummer         | 01SREBE1        |
   | ebeleg         | Schlussrechnung |
   | vom            | .               |
   | ueb            | ja              |
   | reanzpossteuer | ja              |
   | vdat           | .               |
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor
# Beide Steuerpositionen (neg + pos) werden ausgewiesen
Then field "artikel" has value "ST." in row 7
Then field "pwert" has value "-1350.00" in row 7
Then field "artikel" has value "ST." in row 8
Then field "pwert" has value "1350.00" in row 8
Then field "artikel" has value "ES." in row 9
Then the table has 9 rows

#####################################################################################################################################
Scenario: Setzen des Kennzeichens (ev)faktura im Auftrag bei Anzahlungsrechnungen
#####################################################################################################################################

Given I open an editor "1AU180" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set fields
   | nummer  | 1AU180   |
   | kunde   | 1        |
And I append rows
   | artikel | mge  | preis |
   | V1      | 20   | 10    |
And I press button "fktaplanabsteigen" to open a subeditor for "fakturaplan"
And I append rows
  | reart     | proz | zbed |
  | Anzahlung |   10 | 203  |
And I save the current editor
And I switch the current editor to editor "1AU180"
And I save the current editor

# Anzahlungsrechnung anlegen und buchen
Given I open an editor "1AU180" from table "(Sales):(SalesOrder)" with command "VIEW" for record "1AU180"
And I press button "fktaplanabsteigen" to open a subeditor for "fakturaplan"
And I press button "anzahlungsrechn" to open a subeditor for "anzahlungsrechnung" in row 1
And I set fields
	| nummer | 1ANZ180 |
   | ueb    | ja      |
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor
And I switch the current editor to editor "fakturaplan"
And I save the current editor
And I switch the current editor to editor "1AU180"
And I close the current editor

Then field "faktura" from editor "1AU180" in row 0 has value "nein"

# Auftrag erneut oeffnen und speichern
Given I open an editor "1AU180" from table "(Sales):(SalesOrder)" with command "UPDATE" for record "1AU180"
And I save the current editor

Then field "faktura" from editor "1AU180" in row 0 has value "nein"

#####################################################################################################################################
Scenario: Setzen des Kennzeichens (ev)faktura in der Bestellung bei Anzahlungsrechnungen
#####################################################################################################################################

Given I open an editor "1BE180" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set fields
   | nummer  | 1BE180   |
   | lief    | 1        |
And I append rows
   | artikel | mge  | preis |
   | E2      | 20   | 10    |
And I press button "fktaplanabsteigen" to open a subeditor for "fakturaplan"
And I append rows
  | reart     | proz | zbed |
  | Anzahlung |   10 | 203  |
And I save the current editor
And I switch the current editor to editor "1BE180"
And I save the current editor

# Anzahlungsrechnung anlegen und buchen
Given I open an editor "1BE180" from table "(Purchasing):(PurchaseOrder)" with command "VIEW" for record "1BE180"
And I press button "fktaplanabsteigen" to open a subeditor for "fakturaplan"
And I press button "anzahlungsrechn" to open a subeditor for "anzahlungsrechnung" in row 1
And I set fields
	| nummer | 1ANZ180 |
   | ueb    | ja      |
	| vom	   | .       |
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor
And I switch the current editor to editor "fakturaplan"
And I save the current editor
And I switch the current editor to editor "1BE180"
And I close the current editor

Then field "faktura" from editor "1BE180" in row 0 has value "nein"

# Bestellung erneut oeffnen und speichern
Given I open an editor "1BE180" from table "(Purchasing):(PurchaseOrder)" with command "UPDATE" for record "1BE180"
And I save the current editor

Then field "faktura" from editor "1BE180" in row 0 has value "nein"

#####################################################################################################################################
Scenario: Feld 'reanzposbezahltueb' in der Rechnung zu einem Auftrag mit Anzahlung setzen und zuruecksetzen
#####################################################################################################################################

# Auftrag anlegen mit einer Artikelposition
Given I open an editor "1AU181" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set fields
  | nummer  | 1AU181                              |
  | kunde   | 1                                   |
  | betreff | Auftrag mit Anzahlung und Bezahlung |
And I append rows
  | artikel  | mge |
  | artikel1 |   1 |
And I save the current editor

# Fakturaplan mit Anzahlung anlegen und Anzahlungsrechnung erstellen und buchen
Given I open an editor "fakturaplan" from table "(BillingPlan):(BillingPlan)" with command "NEW" for record ""
And I set field "evvorgang" to id from editor "1AU181"
And I set fields
  | nummer   | 1FP181                     |
  | namebspr | Fakturaplan Anzahlung Test |
And I append rows
  | reart     | anzpwert | ptext        | zbed |
  | Anzahlung |     3000 | 1. Anzahlung |  203 |
And I press button "anzahlungsrechn" to open a subeditor for "anzrecherstellen" in row 1
And I set field "ueb" to "ja"
And I set field "pwert" to "100.00" in row 1
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor
And I switch the current editor to editor "fakturaplan"
And I save the current editor

# Offenen Posten der Anzahlungsrechnung ausgleichen (bezahlen)
Given I open an editor "op_bearbeitung" from table "(OIProcessing):(DebitOutstandingItems)" with command "NEW" for record ""
And I set fields
    | gkonto | 18100 |
    | beleg  |     1 |
And I press button "opladen"
And I set field "opzabetr" to "1000" in row 1
And I respond with answer "ja" to the dialog with id "588"
And I save the current editor

# Lieferschein zu Auftrag anlegen und buchen
Given I open an editor "1LS181" from table "(Sales):(PackingSlip)" with command "NEW" for record ""
And I set fields
  | beleg   | !1AU181                                         |
  | nummer  | 1LS181                                          |
  | betreff | Lieferschein zu Auftrag mit bezahlter Anzahlung |
  | ueb     | ja                                              |
And I set field "mge" to "1" in row 1
And I save the current editor

# Rechnung zu Lieferschein anlegen und reanzposbezahltueb setzen/zuruecksetzen
Given I open an editor "1RE181" from table "(Sales):(Invoice)" with command "NEW" for record ""
And I set fields
  | beleg   | !1LS181 |
  | nummer  | 1RE181  |
  | betreff | Schlussrechnung mit bezahlter Anzahlung |
  | tterm   | .       |
Then the table has 2 rows
Then field "pwert" has value "-100.00" in row 2
And I set field "reanzposbezahltueb" to "ja"
Then the table has 1 rows
And I set field "reanzposbezahltueb" to "nein"
Then field "pwert" has value "-100.00" in row 2
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

Then field "pwert" from editor "1RE181" in row 2 has value "-100.00"

# Rechnung zu Lieferschein aendern und reanzposbezahltueb setzen/zuruecksetzen
Given I open an editor "1RE181" from table "(Sales):(Invoice)" with command "UPDATE" for record from editor "1RE181"
Then the table has 5 rows
Then field "pwert" has value "-100.00" in row 2
And I set field "reanzposbezahltueb" to "ja"
Then the table has 4 rows
And I set field "reanzposbezahltueb" to "nein"
Then the table has 5 rows
Then field "pwert" has value "-100.00" in row 2
And I close the current editor

#####################################################################################################################################
Scenario: Anzahlungsrechnung mit Steuerposition - Kenner reanzpossteuer setzen und zurücksetzen
#####################################################################################################################################

# Auftrag anlegen
Given I open an editor "1AU182" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set fields
   | nummer  | 1AU182 |
   | kunde   | 1      |
And I append rows
   | artikel  | mge | preis |
   | artikel1 | 1   | 10000 |
And I save the current editor

# Fakturaplan mit Anzahlung anlegen
Given I open an editor "fakturaplan182" from table "(BillingPlan):(BillingPlan)" with command "NEW" for record ""
And I set field "evvorgang" to id from editor "1AU182"
And I set fields
   | nummer   | 1FP182           |
   | namebspr | Fakturaplan Test |
And I append rows
   | reart     | proz | zbed |
   | Anzahlung | 10   | 203  |

# Anzahlungsrechnung anlegen und buchen
And I press button "anzahlungsrechn" to open a subeditor for "anzahlungsrechnung182" in row 1
And I set fields
   | nummer | 1ANZ182 |
   | ueb    | ja      |
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor
And I switch the current editor to editor "fakturaplan182"
And I save the current editor

# Rechnung aus Auftrag erzeugen
Given I open an editor "rechnung182" from table "(Sales):(Invoice)" with command "NEW" for record ""
And I set fields
   | beleg          | 1AU182 |
   | nummer         | 1RE182 |
   | tterm          | .      |
And I press button "offueb" in row 1
Then the table has 2 rows
# Kenner reanzpossteuer setzen
And I set field "reanzpossteuer" to "ja"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor
Then the table has 7 rows

# Rechnung wieder bearbeiten und Kenner reanzpossteuer deaktivieren
Given I open an editor "rechnung182" from table "(Sales):(Invoice)" with command "UPDATE" for record from editor "rechnung182"
And I set field "reanzpossteuer" to "nein"
Then the table has 2 rows
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor
Then the table has 5 rows

# ----------------------------------------------------------------------------------------------
Scenario: Auftrag mit Anzahlungsrechnung ueber den vollen Betrag
# ----------------------------------------------------------------------------------------------
# Auftrag anlegen
Given I open an editor "auftrag183" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
# Artikel eintragen mit einer Menge 10 und Preis 10
And I set fields
   | nummer  | 1AU183   |
   | kunde   | Rebayram |
   | such    | AU183    |
   | betreff | TEST AU183 |
And I append rows
   | artikel    | mge         | preis       |
   | ARTIKEL1   | 10          | 10          |
   | ANZAHLUNG  | !dontChange | !dontChange |
   | NS         | !dontChange | !dontChange |
And I save the current editor

# Anzahlungsrechnung über den vollen Betrag erstellen und buchen
Given I open an editor "anzrech183" from table "(Sales):(Invoice)" with command "NEW" for record ""
And I set fields
   | vorganga | (Downpayment) |
   | beleg    | 1AU183        |
   | nummer   | 1ANZ183       |
   | such     | ANZ183        |
   | betreff  | TEST AU183    |
   | vom      | .             |
   | ueb      | ja            |
Then the table has 1 rows
And I set field "pwert" to "100.00" in row 1
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Lieferschein aus Auftrag erstellen
Given I open an editor "1LS183" from table "(Sales):(PackingSlip)" with command "NEW" for record ""
And I set fields
  | beleg   | 1AU183                                          |
  | nummer  | 1LS183                                          |
  | betreff | Lieferschein zu Auftrag mit bezahlter Anzahlung |
  | ueb     | ja                                              |
And I set field "mge" to "10" in row 1
And I save the current editor

# Rechnung aus Lieferschein erstellen => Die Rechnung hat die Gesamtsumme 0
Given I open an editor "1RE183" from table "(Sales):(Invoice)" with command "NEW" for record ""
And I set fields
   | beleg   | 1LS183   |
   | nummer  | 1RE183   |
   | such    | RE183    |
   | betreff | TEST AU183 (Rechnung erzeugen) |
Then the table has 5 rows
# TODO: Die Steuerregel ist in den Steuerpositionen nicht gefuellt
Then field "artikel" has value "NS." in row 3
Then field "strgl" has value "" in row 3
Then field "artikel" has value "ST." in row 4
Then field "strgl" has value "" in row 4
Then field "artikel" has value "ES." in row 5
Then field "strgl" has value "" in row 5
And I save the current editor
