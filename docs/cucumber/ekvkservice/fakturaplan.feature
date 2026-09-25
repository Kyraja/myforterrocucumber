# *****************************************************************************
#  Name           : fakturaplan.feature
#  Autor          : mibr
#  Verantwortlich : teampss
#  Funktion       : Testet Anzahlungsrechnungserstellung mit Hilfe eines Fakturaplans zum Auftrag,
#                   Serviceauftrag und Reparaturauftrag.
#
# *****************************************************************************
#
@persistent
Feature: Auftragsobligo, Positionsverkettung und Verkaufszentrale testen.
# Fakturaplan fuer Auftraege, Service- und Reparaturauftraege
Background:
Given I set the fake date to "02.01.1995"

@FP_TEST
Scenario: Neuen Kunden anlegen
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
And I save the current editor
Then field "name" has value "Bayram Werkzeugbau, Rastatt"
Then field "zbed" has value "201"

@FP_TEST
Scenario: Neuen Verkaufsartikel anlegen
Given I open an editor "artikel" from table "(Part):(Product)" with command "STORE" for record "traktor10ps"
And I set field "such" to "traktor10ps"
And I set field "namebspr" to "Rasentraktor 10 PS"
And I set field "vkbez" to "Rasentraktor 10 PS"
And I set field "vbez" to "Rasentraktor 10 PS"
And I set field "ebez" to "Rasentraktor 10 PS"
And I set field "vpr" to "10000"
And I set field "bsart" to "Fremdbeschaffung"
And I set field "dispoa" to "bedarfsbezogen"
And I set field "efrist" to "15"
And I save the current editor
Then field "such" has value "TRAKTOR10PS"

@FP_TEST
Scenario: Testcase AUO11 Auftrag anlegen
Given I open an editor "auftrag" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set field "kunde" to id from editor "kunde"
And I set field "betreff" to "Testcase AUO10 (Anzahlungen geplant ohne Faktura)"
When I create a new row at the end of the table
And I set field "artex" to id from editor "artikel" in row 1
And I set field "mge" to "1" in row 1
And I save the current editor
Then field "fktaplan" is empty
Then field "zbed" has value "201"

@FP_TEST
Scenario: Testcase AUO11 Fakturaplan anlegen
Given I open an editor "fakturaplan" from table "(BillingPlan):(BillingPlan)" with command "NEW" for record ""
And I set field "evvorgang" to id from editor "auftrag"
And I set field "evvorgang" to id from editor "auftrag"
And I set field "such" to "FP-AUO11"
And I set field "namebspr" to "Test-Fakturaplan AUO10"
And I create a new row at the end of the table
And I set field "reart" to "Anzahlung" in row 1
And I set field "anzpwert" to "1000" in row 1
And I set field "ptext" to "1. Anzahlung" in row 1
And I set field "zbed" to "203" in row 1
And I create a new row at the end of the table
And I set field "reart" to "Anzahlung" in row 2
And I set field "anzpwert" to "2000" in row 2
And I set field "ptext" to "2. Anzahlung" in row 2
And I set field "zbed" to "203" in row 2
And I press button "anzahlungsrechn" to open a subeditor for "fakturaplan_sub" in row 1
And I set field "ueb" to "1"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor
And I switch the current editor to editor "fakturaplan"
Then field "sumfakturiert" has value "1000.00" in row 1

@FP_SERAU_TEST
Scenario: STAMMDATEN - Konsignationslagergruppe anlegen
Given I open an editor "Konsignationslg" from table "(Warehouse):(WarehouseGroup)" with command "STORE" for record "konsi"
And I set field "such" to "konsi"
And I set field "namebspr" to "Konsignationslagergruppe"
And I set field "zkonsilg" to "ja"
Then field "vkruecklieferung" is not modifiable
Then field "vkkundenanlieferung" is not modifiable
And I save the current editor

Scenario: STAMMDATEN - Externe Lagergruppe anlegen
Given I open an editor "Externelg" from table "(Warehouse):(WarehouseGroup)" with command "STORE" for record "extern"
And I set field "such" to "extern"
And I set field "namebspr" to "Externe Lagergruppe"
And I set field "zkonsilg" to "nein"
Then field "vkruecklieferung" is modifiable
Then field "vkkundenanlieferung" is modifiable
And I save the current editor

Scenario Outline: STAMMDATEN - Konsignationslager und externes Lager anlegen
Given I open an editor "<lager>" from table "(Warehouse):(Warehouse)" with command "STORE" for record "<such>"
And I set field "such" to "<such>"
And I set field "namebspr" to "<namebspr>"
And I set field "lgruppe" to id from editor "<lgruppe>"
And I save the current editor

Examples: Lager
|lager           |such   |namebspr           |lgruppe         |
|Konsignationsla |konsi  |Konsignationslager |Konsignationslg |
|Externesla      |extern |Externes Lager     |Externelg       |

Scenario Outline: STAMMDATEN - Konsignationslagerplatz und externen Lagerplatz anlegen
Given I open an editor "<lagerplatz>" from table "(Location):(Location)" with command "STORE" for record "<such>"
And I set field "such" to "<such>"
And I set field "namebspr" to "<namebspr>"
And I set field "lager" to id from editor "<lager>"
And I set field "lgruppe" to id from editor "<lgruppe>"
And I save the current editor

Examples: Lagerplatz
|lagerplatz      |such   |namebspr            |lager           |lgruppe         |
|Konsignationslp |konsi  |Konsignationslager  |Konsignationsla |Konsignationslg |
|Externerlp 	 |extern |Externer Lagerplatz |Externesla      |Externelg       |

Scenario: STAMMDATEN - Konsignationslagerplatz in interne Lagergruppe eintragen
Given I open an editor "internelg" from table "(Warehouse):(WarehouseGroup)" with command "STORE" for record "KARLSRUHE"
And I set field "vkkundenanlieferung" to id from editor "Konsignationslp"
And I save the current editor

Scenario: STAMMDATEN - Schichtplan im Mitarbeiter hinterlegen
Given I open an editor "mitarbeiter" from table "(Employee):(Employee)" with command "UPDATE" for record "Test"
And I set field "splan" to "301"
And I save the current editor

Scenario: STAMMDATEN - Neuen Techniker anlegen
Given I open an editor "techniker" from table "(ServiceEmployees):(EmployeeRole)" with command "STORE" for record "techniker"
And I set field "such" to "techniker"
And I set field "namebspr" to "Techniker"
And I set field "ma" to "test"
And I save the current editor

Scenario: STAMMDATEN - Neue Dienstleistung anlegen
Given I open an editor "dienstl" from table "(Part):(Service)" with command "STORE" for record "dl-analyse"
And I set field "such" to "dl-analyse"
And I set field "namebspr" to "Anlayse"
And I set field "vpr" to "50.00"
And I create a new row at the end of the table
And I set field "elex" to "A AG1" in row 1
And I save the current editor

Scenario Outline: STAMMDATEN - Neue Dienstleistungen mit Preiseinheit h anlegen
Given I open an editor "<ndienstl>" from table "(Part):(Service)" with command "STORE" for record "<such>"
And I set field "such" to "<such>"
And I set field "namebspr" to "<namebspr>"
And I set field "vpr" to "<preis>"
And I set field "vpe" to "h"
And I set field "vhe" to "h"
And I save the current editor

Examples: Dienstleistungen
|ndienstl   |such        |namebspr     |preis |
|hdienstl   |dl-hanalyse |Analyse in h |60.00 |
|repdienstl |dl-reparatur|Reparatur    |70.00 |

Scenario: STAMMDATEN - Neues Einsatzmittel anlegen
Given I open an editor "einsatzm" from table "(ServiceAssignment):(AssignmentResources)" with command "STORE" for record ""
And I set field "such" to "em-pkw"
And I save the current editor

Scenario: STAMMDATEN - Neue Kostenstelle anlegen
Given I open an editor "kostenstelle" from table "(Account):(CostCenter)" with command "STORE" for record ""
And I set field "such" to "KS-TECHN"
And I save the current editor

Scenario: STAMMDATEN - Mitarbeiter TEST um Lohngruppe und Kostenstelle erweitern
Given I open an editor "mitarbiter" from table "(Employee):(Employee)" with command "UPDATE" for record "1"
And I set field "kstelle" to id from editor "kostenstelle"
And I set field "lohn" to "1"
And I save the current editor

Scenario: STAMMDATEN - Servicepflichtigen Artikel anlegen
Given I open an editor "serartikel" from table "(Part):(Product)" with command "STORE" for record ""
And I set field "such" to "SERARTIKEL"
And I set field "namebspr" to "Servicepflichtiger Artikel"
And I set field "vkbez" to "Servicepflichtiger Artikel"
And I set field "vbez" to "Servicepflichtiger Artikel"
And I set field "ebez" to "Servicepflichtiger Artikel"
And I set field "vpr" to "1000"
And I set field "bsart" to "Eigenfertigung"
And I set field "dispoa" to "Auftragsbezogen"
And I set field "chimlager" to "ja"
And I set field "serpflicht" to "ja"
#Stueckliste anlegen
And I create a new row at the end of the table
And I set field "elex" to "E2" in row 1
And I set field "elanzahl" to "2" in row 1
And I set field "tnwpflicht" to "ja" in row 1
And I set field "tersatzt" to "ja" in row 1
And I create a new row at the end of the table
And I set field "elex" to "A AG3" in row 2
And I create a new row at the end of the table
And I set field "elex" to "BG1" in row 3
And I set field "elanzahl" to "1" in row 3
And I set field "tnwpflicht" to "ja" in row 3
And I set field "tverschlt" to "ja" in row 3
And I create a new row at the end of the table
And I set field "elex" to "A AG4" in row 4
And I save the current editor

Scenario: STAMMDATEN - Nachweispflicht in Elementen von BG1 setzen
Given I open an editor "bg1" from table "(Part):(Product)" with command "UPDATE" for record "BG1"
And I set field "tnwpflicht" to "ja" in row 1
And I save the current editor

Scenario Outline: Serviceprodukt als Kunden- und Leihgeraet anlegen
Given I open an editor "charge" from table "(Lots):(Lots)" with command "STORE" for record "LEIH"
And I set field "such" to "LEIH"
And I set field "exnum" to "001"
And I set field "artikel" to id from editor "serartikel"
And I save the current editor

Given I open an editor "<serprodukt>" from table "(ServiceProduct):(ServiceProduct)" with command "STORE" for record "<such>"
And I set field "such" to "<such>"
And I set field "namebspr" to "<namebspr>"
And I set field "artikel" to id from editor "<artikel>"
And I save the current editor
And I switch the current editor to editor "<serprodukt>"
And I set field "serprodtyp" to "<serprodtyp>"
And I set field "zuplatzlg" to "<zuplatzlg>"
And I set field "abplatzlg" to "<abplatzlg>"
And I set field "charge" to "<charge>"
And I save the current editor

Examples: Serviceprodukt
|serprodukt |such  |namebspr |artikel    |serprodtyp |zuplatzlg   |abplatzlg   |charge      |
|kundeng1 	|KGSP1 |KGSP1    |serartikel |Kundenger  |!dontChange |!dontChange |!dontChange |
|kundeng2 	|KGSP2 |KGSP2    |serartikel |Kundenger  |!dontChange |!dontChange |!dontChange |
|kundeng3 	|KGSP3 |KGSP3    |serartikel |Kundenger  |!dontChange |!dontChange |!dontChange |
|kundeng4 	|KGSP4 |KGSP4    |serartikel |Kundenger  |!dontChange |!dontChange |!dontChange |
|kundeng5 	|KGSP5 |KGSP5    |serartikel |Kundenger  |!dontChange |!dontChange |!dontChange |
|leihgeraet |LHSP  |LHSP     |serartikel |Leihgeraet |F4          |F4          |LEIH        |

Scenario: Serviceprodukt ausliefern
Given I open an editor "auftrag1" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set field "kunde" to id from editor "kunde"
And I create a new row at the end of the table
And I set field "artikel" to id from editor "serartikel" in row 1
And I set field "mge" to "1" in row 1
And I set field "serprod" to id from editor "kundeng1" in row 1
And I save the current editor

#Disposition starten
And I run Scheduling
# Fertigungsvorschlaege freigeben
Given I open an editor "freigeben" from table "(Purchasing):(WorkOrderSuggestions)" with command "UPDATE" for record ""
And I set field "artikel" to id from editor "serartikel"
And I press button "ladetab"
Then the table has 1 rows
And I set field "bisuch" to "Service" in row 1
And I set field "mfreig" to "ja" in row 1
And I press button "freig" to open a subeditor for "fertigung"
And I close the current editor
And I switch the current editor to editor "freigeben"
And I close the current editor

#BAs rueckmelden
Given I open an editor "rueckmelden" from table "(Workorder):(WorkOrders)" with command "DONE" for record "service000"
And I set field "gut" to "ja"
And I set field "sofort" to "ja"
And I set field "mgr" to "101"
And I save the current editor

Given I open an editor "lieferschein1" from table "(Sales):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "auftrag1"
And I set field "such" to "liefer1"
And I set field "ueb" to "ja"
And I set field "mge" to "1" in row 1
And I save the current editor

Scenario: Serviceauftrag anlegen
Given I open an editor "serauftrag" from table "(Sales):(ServiceOrder)" with command "NEW" for record ""
And I set field "kunde" to id from editor "kunde"
And I set field "betreff" to "Serviceauftrag mit Fakturaplan"
And I set field "vserprod" to id from editor "kundeng1"
When I create a new row at the end of the table
And I set field "artex" to id from editor "dienstl" in row 1
And I set field "mge" to "1" in row 1
And I set field "ganztag" to "ja" in row 1
And I create a new row at the end of the table
And I set field "artex" to "V1" in row 2
And I set field "mge" to "1" in row 2
And I save the current editor
Then field "fktaplan" is empty
Then field "zbed" has value "201"

Scenario: Fakturaplan fuer Serviceauftrag anlegen
Given I open an editor "fakturaplan" from table "(BillingPlan):(BillingPlan)" with command "NEW" for record ""
And I set field "evvorgang" to id from editor "serauftrag"
And I set field "namebspr" to "Fakturaplan zu Serviceauftrag"
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
And I save the current editor

Scenario: Fakturaplan im Serviceauftrag loeschen
Given I open an editor "sernauftrag" from table "(Sales):(ServiceOrder)" with command "UPDATE" for record from editor "serauftrag"
Then the table has 4 rows
Then field "fktaplanpos" is not empty in row 3
Then field "fktaplanpos" is not empty in row 4
And I press button "fktaplanloeschen" to open a subeditor for "fakturaplan_loe"
And I respond with answer "Ja" to the dialog with id "10378"
And I save the current editor
And I switch the current editor to editor "sernauftrag"
Then field "fktaplan" is empty
And I save the current editor

Scenario: Fakturaplan fuer Serviceauftrag nochmal anlegen
Given I open an editor "fakturaplan" from table "(BillingPlan):(BillingPlan)" with command "NEW" for record ""
And I set field "evvorgang" to id from editor "serauftrag"
And I set field "namebspr" to "Fakturaplan zu Serviceauftrag"
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
#Anzahlungsrechnung anlegen
And I press button "anzahlungsrechn" to open a subeditor for "fakturaplan_ser" in row 1
And I set field "ueb" to "ja"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor
And I switch the current editor to editor "fakturaplan"
Then field "sumfakturiert" has value "7.67" in row 1
Then field "evpos" is not empty in row 1
Then field "evpos" is not empty in row 2
Then field "ptext" is not empty in row 1
Then field "ptext" is not empty in row 2
And I close the current editor

Scenario: Rechnung zu Serviceauftrag anlegen und buchen
Given I open an editor "rechnung" from table "(Sales):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "serauftrag"
And I set field "ueb" to "ja"
And I press button "offueb" in row 1
And I press button "offueb" in row 2
And I set field "serstlsts" to "wird nicht aktualisiert" in row 2
And I press button "offueb" in row 3
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

Scenario: Fakturaplan fuer Serviceauftrag nochmals oeffnen
Given I open an editor "faktplan" from table "(BillingPlan):(BillingPlan)" with command "VIEW" for record from editor "fakturaplan"
Then field "ablagef" has value "ja"
Then field "bezahltico" has value "icon:ball_red" in row 1
Then field "status" has value "*" in row 1
Then field "bezahltico" has value "icon:ball_red" in row 2
Then field "status" has value "*" in row 2
And I close the current editor

Scenario: Reparaturauftrag anlegen
Given I open an editor "repauftrag" from table "(Sales):(RepairOrder)" with command "NEW" for record ""
And I set field "kunde" to id from editor "kunde"
Then the table has 2 rows
#Serviceprodukt annehmen
And I press button "repzug" to open a subeditor for "zugangsls"
And I set field "ueb" to "ja"
Then field "platz" has value "KONSI" in row 1
And I save the current editor
And I switch the current editor to editor "repauftrag"
#Abgang des Leihgeraetes
And I press button "repabgl" to open a subeditor for "abgangsls"
And I set field "such" to "Fall615"
And I set field "ueb" to "ja"
And I set field "umplatz" to "L3F1"
Then field "platz" has value "F4" in row 1
And I save the current editor
And I switch the current editor to editor "repauftrag"
#Dienstleistung aufnehmen
And I create a new row at the end of the table
And I set field "artikel" to id from editor "dienstl" in row 3
And I set field "mge" to "1" in row 3
#Reparatur aufnehmen
And I create a new row at the end of the table
And I set field "artikel" to id from editor "repdienstl" in row 4
And I set field "mge" to "2" in row 4
And I press button "absteig" to open a subeditor for "reparatur" in row 4
And I create a new row at the end of the table
And I set field "elex" to "E2" in row 1
And I set field "elanzahl" to "1" in row 1
And I create a new row at the end of the table
And I set field "elex" to "A AG2" in row 2
And I save the current editor
And I switch the current editor to editor "repauftrag"
And I save the current editor

Scenario: Fakturaplan fuer Reparaturauftrag anlegen
Given I open an editor "fakturaplan" from table "(BillingPlan):(BillingPlan)" with command "NEW" for record ""
And I set field "evvorgang" to id from editor "repauftrag"
And I set field "namebspr" to "Fakturaplan zu Reparaturauftrag"
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
And I press button "anzahlungsrechn" to open a subeditor for "fakturaplan_rep" in row 1
And I set field "ueb" to "ja"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor
And I switch the current editor to editor "fakturaplan"
Then field "evpos" is not empty in row 1
Then field "evpos" is not empty in row 2
Then field "ptext" is not empty in row 1
Then field "ptext" is not empty in row 2
Then field "sumfakturiert" has value "19.43" in row 1
And I close the current editor

Scenario: Reparaturauftrag berechnen
Given I open an editor "reparatur" from table "(Sales):(RepairOrder)" with command "UPDATE" for record from editor "repauftrag"
#Kundengeraet abgeben
And I press button "repabg" to open a subeditor for "abgangsls"
And I set field "ueb" to "ja"
Then field "platz" has value "KONSI" in row 1
And I save the current editor
And I switch the current editor to editor "reparatur"
#Zugang des Leihgeraets
And I press button "repzugl" to open a subeditor for "zugangsls"
And I set field "such" to "Fall615"
And I set field "ueb" to "ja"
Then field "platz" has value "L3F1" in row 1
And I save the current editor
And I switch the current editor to editor "reparatur"
#Rechnung erzeugen
And I press button "reanlegen" to open a subeditor for "rechnung"
And I set field "ueb" to "ja"
And I press button "offueb" in row 1
And I press button "offueb" in row 2
And I press button "offueb" in row 3
And I press button "offueb" in row 4
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor
And I switch the current editor to editor "reparatur"
And I save the current editor

Scenario: Fakturaplan fuer Reparaturauftrag nochmals oeffnen
Given I open an editor "faktplan" from table "(BillingPlan):(BillingPlan)" with command "VIEW" for record from editor "fakturaplan"
Then field "ablagef" has value "ja"
Then field "bezahltico" has value "icon:ball_red" in row 1
Then field "status" has value "*" in row 1
Then field "bezahltico" has value "icon:ball_red" in row 2
Then field "status" has value "*" in row 2
And I close the current editor


Scenario: Testcase AUO12 Auftrag anlegen
Given I open an editor "AU012" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set field "kunde" to id from editor "kunde"
And I set field "betreff" to "Testcase AUO12"
When I create a new row at the end of the table
And I set field "artex" to "E1" in row 1
And I set field "mge" to "10" in row 1
And I set field "preis" to "100" in row 1
And I save the current editor
Then field "fktaplan" is empty
Then field "zbed" has value "201"

Scenario: Testcase AUO12 Fakturaplan anlegen
Given I open an editor "FPLAN012" from table "(BillingPlan):(BillingPlan)" with command "NEW" for record ""
And I set field "evvorgang" to id from editor "AU012"
And I set field "such" to "FP-AUO12"
And I set field "namebspr" to "Test-Fakturaplan AUO12"
And I create a new row at the end of the table
And I set field "reart" to "Anzahlung" in row 1
And I set field "anzpwert" to "200" in row 1
And I set field "ptext" to "1. Anzahlung" in row 1
And I set field "zbed" to "202" in row 1
And I press button "anzahlungsrechn" to open a subeditor for "fplan012_sub" in row 1
And I set field "ueb" to "1"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor
And I switch the current editor to editor "FPLAN012"
Then field "sumfakturiert" has value "200.00" in row 1

Scenario: Lieferschein erstellen
Given I open an editor "LS012" from table "(Sales):(SalesOrder)" with command "DELIVERY" for record from editor "AU012"
And I set fields
   | such    | LS012 |
   | ueb     | ja    |
And I set field "mge" to "10" in row 1
And I save the current editor

Scenario: Rechnung erstellen
Given I open an editor "RE012" from table "(Sales):(PackingSlip)" with command "INVOICE" for record from editor "LS012"
And I set fields
   | such    | RE012 |
   | ueb     | ja    |
And I set field "mge" to "10" in row 1
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Auftrag und Fakturaplan sind abgelegt
Then "(Sales):(SalesOrder)" with the editor id "AU012" is filed
Then "(BillingPlan):(BillingPlan)" with the editor id "FPLAN012" is filed

Scenario: Rechnung stornieren
Given I open an editor "SRE012" from table "(Sales):(Invoice)" with command "REVERSAL" for record from editor "RE012"
And I save the current editor

# Auftrag und Fakturaplan sind wieder lebendig
Then "(Sales):(SalesOrder)" with the editor id "AU012" is not filed
Then "(BillingPlan):(BillingPlan)" with the editor id "FPLAN012" is not filed

Scenario: Aenderbarkeit der Anzahlungs-Zusatzposition im Fakturaplan

# Weitere Zusatzposition
Given I open an editor "zuspos" from table "(Part):(SupplementaryItem)" with command "COPY" for record "ANZAHLUNG"
And I set field "such" to "BNZAHLUNG"
And I save the current editor

# Auftrag mit Fakturaplan
Given I open an editor "1AU013" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set fields
   | nummer  | 1AU013 |
   | kunde   | 1      |
   | such    | AU013  |
And I append rows
   | artikel | mge    |
   | V1      | 50     |
And I press button "fktaplanabsteigen" to open a subeditor for "fakturaplan"
And I append rows
| reart     | anzpwert | ptext        | zbed | zuspos    |
| Anzahlung | 100      | 1. Anzahlung | 201  | BNZAHLUNG |
And I save the current subeditor to switch back to the parent editor
And I save the current editor

# Zusatzposition im Fakturaplan editierbar
Given I open an editor "fakturaplan" from table "(BillingPlan):(BillingPlan)" with command "UPDATE" for record from editor "fakturaplan"
Then field "zuspos" is modifiable in row 1
And I close the current editor

# Anzahlungsrechnung erstellen, nicht buchen
Given I open an editor "fakturaplan" from table "(BillingPlan):(BillingPlan)" with command "VIEW" for record from editor "fakturaplan"
And I press button "anzahlungsrechn" to open a subeditor for "anzahlungsrechnung" in row 1
And I set field "nummer" to "1RE013"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current subeditor to switch back to the parent editor
And I close the current editor

# Zusatzposition im Fakturaplan nicht editierbar
Given I open an editor "fakturaplan" from table "(BillingPlan):(BillingPlan)" with command "UPDATE" for record from editor "fakturaplan"
Then field "zuspos" is not modifiable in row 1
And I close the current editor

# Anzahlungsrechnung buchen
Given I open an editor "1RE013" from table "(Sales):(Invoice)" with command "UPDATE" for record from editor "anzahlungsrechnung"
And I set field "ueb" to "ja"
And I save the current editor

# Zusatzposition im Fakturaplan nicht editierbar
Given I open an editor "fakturaplan" from table "(BillingPlan):(BillingPlan)" with command "UPDATE" for record from editor "fakturaplan"
Then field "zuspos" is not modifiable in row 1
And I close the current editor

# Anzahlungsrechnung stornieren
Given I open an editor "1RE013" from table "(Sales):(Invoice)" with command "REVERSAL" for record from editor "anzahlungsrechnung"
And I save the current editor

# Zusatzposition im Fakturaplan nicht editierbar
Given I open an editor "fakturaplan" from table "(BillingPlan):(BillingPlan)" with command "UPDATE" for record from editor "fakturaplan"
Then field "zuspos" is not modifiable in row 1
And I close the current editor
