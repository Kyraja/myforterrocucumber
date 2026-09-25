Feature: SER_Vorgangsketten
Background: SER_Vorgangsketten.feature
Given I set the fake date to "02.01.2002"

@Stammdaten
Scenario: STAMMDATEN - Neuen Kunden anlegen
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
| lager           | such   | namebspr           | lgruppe         |
| Konsignationsla | konsi  | Konsignationslager | Konsignationslg |
| Externesla      | extern | Externes Lager     | Externelg       |

Scenario Outline: STAMMDATEN - Konsignationslagerplatz und externen Lagerplatz anlegen
Given I open an editor "<lagerplatz>" from table "(Location):(Location)" with command "STORE" for record "<such>"
And I set field "such" to "<such>"
And I set field "namebspr" to "<namebspr>"
And I set field "lager" to id from editor "<lager>"
And I set field "lgruppe" to id from editor "<lgruppe>"
And I save the current editor

Examples: Lagerplatz
| lagerplatz      | such   | namebspr            | lager           | lgruppe         |
| Konsignationslp | konsi  | Konsignationslager  | Konsignationsla | Konsignationslg | 
| Externerlp      | extern | Externer Lagerplatz | Externesla      | Externelg       |

Scenario: STAMMDATEN - Konsignationslagerplatz in interne Lagergruppe eingragen
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

Scenario: STAMMDATEN - Neue Dienstleistung mit Preiseinheit h anlegen
Given I open an editor "hdienstl" from table "(Part):(Service)" with command "STORE" for record "dl-hanalyse"
And I set field "such" to "dl-hanalyse"
And I set field "namebspr" to "Anlayse mit Preiseinheit h"
And I set field "vpr" to "60.00"
And I set field "vpe" to "h"
And I set field "vhe" to "h"
And I save the current editor

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


#Disposition starten
And I run Scheduling
#####################################################################################################################################

Scenario: Initiale MKV

# Initiale Materialkostenverbuchung fuer die Startdatum Frage
Given I open an editor "mkv-020" from table "(CostEntriesSuggestion):(CostEntriesSuggestion)" with command "NEW" for record ""
And I set field "such" to "FALL-020"
And I set field "kosart" to "Verbuchung Lagerbestand"
And I set field "adat" to "."
And I set field "edat" to "."
# And I set field "labudat" to "01.01.95"
And I press button "kosvor"
#And I press button "kosbu"
# 5567 ist nur das Fragewort Weiter?, JEDOCH SIND EIGENTLICH FOLGENDE FRAGEN INHALTLICH ENTSCHEIDEND, DIE HIER ANGEZEIGT WERDEN MUESSEN!
# Kostenbuchungen ab Startdatum %s erzeugen. oder...
# Kostenbuchungsvorschlag speichern und Startdatum auf den %s setzen.
And I respond with answer "yes" to the dialog with id "5567"
# And I respond with answer "JA" to the dialog with id "2324"
And I save the current editor


#####################################################################################################################################

Scenario: FALL-601
# FALL-601

# STAMMDATEN - E1 kopieren
Given I open an editor "E1-601" from table "(Part):(Product)" with command "COPY" for record "E1"
And I set field "such" to "E1-601"
And I set field "losgr" to "0"
And I set field "mindest" to "0"
And I save the current editor
# STAMMDATEN - E2 kopieren
Given I open an editor "E2-601" from table "(Part):(Product)" with command "COPY" for record "E2"
And I set field "such" to "E2-601"
And I set field "losgr" to "0"
And I set field "mindest" to "0"
And I save the current editor

# STAMMDATEN - BG1 kopieren
Given I open an editor "BG-601" from table "(Part):(Product)" with command "COPY" for record "BG1"
And I set field "such" to "BG-601"
And I set field "dispoa" to "Auftragsbezogen"
And I set field "mindest" to "0"
And I set field "elex" to "E1-601" in row 1
And I set field "tnwpflicht" to "ja" in row 1
And I save the current editor

# STAMMDATEN - Servicepflichtigen Artikel anlegen
Given I open an editor "serartikel-601" from table "(Part):(Product)" with command "STORE" for record ""
And I set field "such" to "FALL-601"
And I set field "namebspr" to "Service Artikel 601"
And I set field "vkbez" to "Service Artikel 601"
And I set field "vbez" to "Service Artikel 601"
And I set field "ebez" to "Service Artikel 601"
And I set field "vpr" to "1000"
And I set field "bsart" to "Eigenfertigung"
And I set field "dispoa" to "Auftragsbezogen"
And I set field "chimlager" to "ja"
And I set field "serpflicht" to "ja"
#Stückliste anlegen
And I create a new row at the end of the table
And I set field "elex" to "E2-601" in row 1
And I set field "elanzahl" to "2" in row 1
And I set field "tnwpflicht" to "ja" in row 1
And I set field "tersatzt" to "ja" in row 1
And I create a new row at the end of the table
And I set field "elex" to "A AG3" in row 2
And I create a new row at the end of the table
And I set field "elex" to "BG-601" in row 3
And I set field "elanzahl" to "1" in row 3
And I set field "tnwpflicht" to "ja" in row 3
And I set field "tverschlt" to "ja" in row 3
And I create a new row at the end of the table
And I set field "elex" to "A AG4" in row 4
And I save the current editor

# Rechnung anlegen
Given I open an editor "rechnung" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "lief" to "1"
And I set field "num4" to "601-RE"
And I set field "fakt" to "ja"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I create a new row at the end of the table
And I set field "artex" to "E1-601" in row 1
And I set field "mge" to "601" in row 1
And I set field "preis" to "601" in row 1
And I set field "platz" to "F2" in row 1
And I create a new row at the end of the table
And I set field "artex" to "E2-601" in row 2
And I set field "mge" to "601" in row 2
And I set field "preis" to "601" in row 2
And I set field "platz" to "F2" in row 2
And I set field "kenn" to "FALL-601"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Charge anlegen
Given I open an editor "charge" from table "(Lots):(Lots)" with command "STORE" for record "FALL-601"
And I set field "such" to "FALL-601"
And I set field "exnum" to "FALL-601"
And I set field "artikel" to id from editor "serartikel-601"
And I save the current editor

# Serviceprodukt als Kunden- und Leihgeraet anlegen
Given I open an editor "kundeng-601" from table "(ServiceProduct):(ServiceProduct)" with command "STORE" for record "KGSP-601"
And I set field "such" to "KGSP-601"
And I set field "namebspr" to "KGSP-601"
And I set field "artikel" to id from editor "serartikel-601"
And I save the current editor
And I switch the current editor to editor "kundeng-601"
And I set field "serprodtyp" to "Kundengerät"
And I set field "zuplatzlg" to ""
And I set field "abplatzlg" to ""
And I set field "charge" to ""
And I save the current editor

# Serviceprodukt Auftrag erfassen 
Given I open an editor "auftrag-601" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set field "kunde" to id from editor "kunde"
And I set field "nummer" to "601-AU"
And I set field "such" to "FALL-601"
And I create a new row at the end of the table
And I set field "artikel" to id from editor "serartikel-601" in row 1
And I set field "mge" to "1" in row 1
And I set field "serprod" to id from editor "kundeng-601" in row 1
And I set field "verw" to "601" in row 1
And I save the current editor

#Disposition starten
And I run Scheduling

#Fertigungsvorschlaege zu BA freigeben
Given I open the infosystem "PRODLIST"
And I set field "kart" to id from editor "BG-601"
And I press start
And I press button "release" in row 1
And I close the current editor

Given I open the infosystem "PRODLIST"
And I set field "kart" to id from editor "serartikel-601"
And I press start
And I press button "release" in row 1
And I close the current editor

#BAs rueckmelden
Given I open an editor "rueckmelden" from table "(Workorder):(WorkOrders)" with command "DONE" for record "$,,artikel=BG-601;verw=601;typ==(WorkSlips);@maxtreffer=1;@richtung=V;"
And I set field "gut" to "ja"
And I set field "sofort" to "ja"
And I save the current editor

#BAs rueckmelden
Given I open an editor "rueckmelden" from table "(Workorder):(WorkOrders)" with command "DONE" for record "$,,artikel=BG-601;verw=601;typ==(WorkSlips);@maxtreffer=1;@richtung=R;"
And I set field "gut" to "ja"
And I set field "sofort" to "ja"
And I save the current editor

Given I open an editor "rueckmelden" from table "(Workorder):(WorkOrders)" with command "DONE" for record "$,,artikel=FALL-601;verw=601;typ==(WorkSlips);@maxtreffer=1;@richtung=V;"
And I set field "gut" to "ja"
And I set field "sofort" to "ja"
And I save the current editor

Given I open an editor "rueckmelden" from table "(Workorder):(WorkOrders)" with command "DONE" for record "$,,artikel=FALL-601;verw=601;typ==(WorkSlips);@maxtreffer=1;@richtung=R;"
And I set field "gut" to "ja"
And I set field "sofort" to "ja"
And I save the current editor

#Fall 601 - Lieferschein erzeugen und buchen
Given I open an editor "lieferschein-601" from table "(Sales):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "auftrag-601"
And I set field "nummer" to "601-LS"
And I set field "such" to "LS-601"
And I set field "ueb" to "ja"
And I set field "mge" to "1" in row 1
And I save the current editor

# Ausgabe Lieferschein
Given I open an editor "Lieferschein-view" from table "(Sales):(PackingSlip)" with command "VIEW" for record from editor "lieferschein-601"
And I close the current editor


#####################################################################################################################################

Scenario: FALL-602
# FALL-602

# STAMMDATEN - E1 kopieren
Given I open an editor "E1-602" from table "(Part):(Product)" with command "COPY" for record "E1"
And I set field "such" to "E1-602"
And I set field "losgr" to "0"
And I set field "mindest" to "0"
And I save the current editor
# STAMMDATEN - E2 kopieren
Given I open an editor "E2-602" from table "(Part):(Product)" with command "COPY" for record "E2"
And I set field "such" to "E2-602"
And I set field "losgr" to "0"
And I set field "mindest" to "0"
And I save the current editor

# STAMMDATEN - BG1 kopieren
Given I open an editor "BG-602" from table "(Part):(Product)" with command "COPY" for record "BG1"
And I set field "such" to "BG-602"
And I set field "dispoa" to "Auftragsbezogen"
And I set field "mindest" to "0"
And I set field "elex" to "E1-602" in row 1
And I set field "tnwpflicht" to "ja" in row 1
And I save the current editor

# STAMMDATEN - Servicepflichtigen Artikel anlegen
Given I open an editor "serartikel-602" from table "(Part):(Product)" with command "STORE" for record ""
And I set field "such" to "FALL-602"
And I set field "namebspr" to "Service Artikel 602"
And I set field "vkbez" to "Service Artikel 602"
And I set field "vbez" to "Service Artikel 602"
And I set field "ebez" to "Service Artikel 602"
And I set field "vpr" to "1000"
And I set field "bsart" to "Eigenfertigung"
And I set field "dispoa" to "Auftragsbezogen"
And I set field "chimlager" to "ja"
And I set field "serpflicht" to "ja"
#Stückliste anlegen
And I create a new row at the end of the table
And I set field "elex" to "E2-602" in row 1
And I set field "elanzahl" to "2" in row 1
And I set field "tnwpflicht" to "ja" in row 1
And I set field "tersatzt" to "ja" in row 1
And I create a new row at the end of the table
And I set field "elex" to "A AG3" in row 2
And I create a new row at the end of the table
And I set field "elex" to "BG-602" in row 3
And I set field "elanzahl" to "1" in row 3
And I set field "tnwpflicht" to "ja" in row 3
And I set field "tverschlt" to "ja" in row 3
And I create a new row at the end of the table
And I set field "elex" to "A AG4" in row 4
And I save the current editor

# Rechnung anlegen
Given I open an editor "rechnung" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "lief" to "1"
And I set field "num4" to "602-RE"
And I set field "fakt" to "ja"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I create a new row at the end of the table
And I set field "artex" to "E1-602" in row 1
And I set field "mge" to "602" in row 1
And I set field "preis" to "602" in row 1
And I set field "platz" to "F2" in row 1
And I create a new row at the end of the table
And I set field "artex" to "E2-602" in row 2
And I set field "mge" to "602" in row 2
And I set field "preis" to "602" in row 2
And I set field "platz" to "F2" in row 2
And I set field "kenn" to "FALL-602"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Charge anlegen
Given I open an editor "charge" from table "(Lots):(Lots)" with command "STORE" for record "FALL-602"
And I set field "such" to "FALL-602"
And I set field "exnum" to "FALL-602"
And I set field "artikel" to id from editor "serartikel-602"
And I save the current editor

# Serviceprodukt als Kunden- und Leihgeraet anlegen
Given I open an editor "kundeng-602" from table "(ServiceProduct):(ServiceProduct)" with command "STORE" for record "KGSP-602"
And I set field "such" to "KGSP-602"
And I set field "namebspr" to "KGSP-602"
And I set field "artikel" to id from editor "serartikel-602"
And I save the current editor
And I switch the current editor to editor "kundeng-602"
And I set field "serprodtyp" to "Kundengerät"
And I set field "zuplatzlg" to ""
And I set field "abplatzlg" to ""
And I set field "charge" to ""
And I save the current editor

# Serviceprodukt Auftrag erfassen 
Given I open an editor "auftrag-602" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set field "kunde" to id from editor "kunde"
And I set field "nummer" to "602-AU"
And I set field "such" to "FALL-602"
And I create a new row at the end of the table
And I set field "artikel" to id from editor "serartikel-602" in row 1
And I set field "mge" to "1" in row 1
And I set field "serprod" to id from editor "kundeng-602" in row 1
And I set field "verw" to "602" in row 1
And I save the current editor

#Disposition starten
And I run Scheduling

#Fertigungsvorschlaege zu BA freigeben
Given I open the infosystem "PRODLIST"
And I set field "kart" to id from editor "BG-602"
And I press start
And I press button "release" in row 1
And I close the current editor

Given I open the infosystem "PRODLIST"
And I set field "kart" to id from editor "serartikel-602"
And I press start
And I press button "release" in row 1
And I close the current editor

#BAs rueckmelden
Given I open an editor "rueckmelden" from table "(Workorder):(WorkOrders)" with command "DONE" for record "$,,artikel=BG-602;verw=602;typ==(WorkSlips);@maxtreffer=1;@richtung=V;"
And I set field "gut" to "ja"
And I set field "sofort" to "ja"
And I save the current editor

#BAs rueckmelden
Given I open an editor "rueckmelden" from table "(Workorder):(WorkOrders)" with command "DONE" for record "$,,artikel=BG-602;verw=602;typ==(WorkSlips);@maxtreffer=1;@richtung=R;"
And I set field "gut" to "ja"
And I set field "sofort" to "ja"
And I save the current editor

Given I open an editor "rueckmelden" from table "(Workorder):(WorkOrders)" with command "DONE" for record "$,,artikel=FALL-602;verw=602;typ==(WorkSlips);@maxtreffer=1;@richtung=V;"
And I set field "gut" to "ja"
And I set field "sofort" to "ja"
And I save the current editor

Given I open an editor "rueckmelden" from table "(Workorder):(WorkOrders)" with command "DONE" for record "$,,artikel=FALL-602;verw=602;typ==(WorkSlips);@maxtreffer=1;@richtung=R;"
And I set field "gut" to "ja"
And I set field "sofort" to "ja"
And I save the current editor

# Lieferschein erzeugen und buchen
Given I open an editor "lieferschein-602" from table "(Sales):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "auftrag-602"
And I set field "nummer" to "602-LS"
And I set field "such" to "LS-602"
And I set field "ueb" to "ja"
And I set field "mge" to "1" in row 1
And I save the current editor

# Ausgabe Lieferschein
Given I open an editor "Lieferschein-view" from table "(Sales):(PackingSlip)" with command "VIEW" for record from editor "lieferschein-602"
And I close the current editor

# Serviceauftrag erstellen 
Given I open an editor "serauftrag-602" from table "(Sales):(ServiceOrder)" with command "NEW" for record ""
And I set field "kunde" to id from editor "kunde"
And I set field "vserprod" to id from editor "kundeng-602"
And I set field "nummer" to "602-SAU"
And I set field "such" to "SAU-602"
And I create a new row at the end of the table
And I set field "artikel" to id from editor "dienstl" in row 1
And I set field "mge" to "1" in row 1
And I set field "zzvon" to "8" in row 1
And I set field "zzbis" to "12" in row 1
And I create a new row at the end of the table
And I set field "artikel" to "E2-602" in row 2
And I set field "mge" to "1" in row 2
And I save the current editor

# Ausgabe Serviceauftrag
Given I open an editor "Serviceauftrag-view" from table "(Sales):(ServiceOrder)" with command "VIEW" for record from editor "serauftrag-602"
And I close the current editor

#Fall 602, Lieferschein erzeugen und buchen
Given I open an editor "lieferschein-602-2" from table "(Sales):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "serauftrag-602"
And I set field "nummer" to "602-LS2"
And I set field "such" to "LS-602-2"
And I set field "ueb" to "ja"
And I set field "mge" to "1" in row 1
# And I set field "mge" to "1" in row 2
And I save the current editor

# Ausgabe Lieferschein
Given I open an editor "Lieferschein-view" from table "(Sales):(PackingSlip)" with command "VIEW" for record from editor "lieferschein-602-2"
And I close the current editor


#####################################################################################################################################

Scenario: FALL-603
# FALL-603

# STAMMDATEN - E1 kopieren
Given I open an editor "E1-603" from table "(Part):(Product)" with command "COPY" for record "E1"
And I set field "such" to "E1-603"
And I set field "losgr" to "0"
And I set field "mindest" to "0"
And I save the current editor
# STAMMDATEN - E2 kopieren
Given I open an editor "E2-603" from table "(Part):(Product)" with command "COPY" for record "E2"
And I set field "such" to "E2-603"
And I set field "losgr" to "0"
And I set field "mindest" to "0"
And I save the current editor

# STAMMDATEN - BG1 kopieren
Given I open an editor "BG-603" from table "(Part):(Product)" with command "COPY" for record "BG1"
And I set field "such" to "BG-603"
And I set field "dispoa" to "Auftragsbezogen"
And I set field "mindest" to "0"
And I set field "elex" to "E1-603" in row 1
And I set field "tnwpflicht" to "ja" in row 1
And I save the current editor

# STAMMDATEN - Servicepflichtigen Artikel anlegen
Given I open an editor "serartikel-603" from table "(Part):(Product)" with command "STORE" for record ""
And I set field "such" to "FALL-603"
And I set field "namebspr" to "Service Artikel 603"
And I set field "vkbez" to "Service Artikel 603"
And I set field "vbez" to "Service Artikel 603"
And I set field "ebez" to "Service Artikel 603"
And I set field "vpr" to "1000"
And I set field "bsart" to "Eigenfertigung"
And I set field "dispoa" to "Auftragsbezogen"
And I set field "chimlager" to "ja"
And I set field "serpflicht" to "ja"
#Stückliste anlegen
And I create a new row at the end of the table
And I set field "elex" to "E2-603" in row 1
And I set field "elanzahl" to "2" in row 1
And I set field "tnwpflicht" to "ja" in row 1
And I set field "tersatzt" to "ja" in row 1
And I create a new row at the end of the table
And I set field "elex" to "A AG3" in row 2
And I create a new row at the end of the table
And I set field "elex" to "BG-603" in row 3
And I set field "elanzahl" to "1" in row 3
And I set field "tnwpflicht" to "ja" in row 3
And I set field "tverschlt" to "ja" in row 3
And I create a new row at the end of the table
And I set field "elex" to "A AG4" in row 4
And I save the current editor

# Rechnung anlegen
Given I open an editor "rechnung" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "lief" to "1"
And I set field "num4" to "603-RE"
And I set field "fakt" to "ja"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I create a new row at the end of the table
And I set field "artex" to "E1-603" in row 1
And I set field "mge" to "603" in row 1
And I set field "preis" to "603" in row 1
And I set field "platz" to "F2" in row 1
And I create a new row at the end of the table
And I set field "artex" to "E2-603" in row 2
And I set field "mge" to "603" in row 2
And I set field "preis" to "603" in row 2
And I set field "platz" to "F2" in row 2
And I set field "kenn" to "FALL-603"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Charge anlegen
Given I open an editor "charge" from table "(Lots):(Lots)" with command "STORE" for record "FALL-603"
And I set field "such" to "FALL-603"
And I set field "exnum" to "FALL-603"
And I set field "artikel" to id from editor "serartikel-603"
And I save the current editor

# Serviceprodukt als Kunden- und Leihgeraet anlegen
Given I open an editor "kundeng-603" from table "(ServiceProduct):(ServiceProduct)" with command "STORE" for record "KGSP-603"
And I set field "such" to "KGSP-603"
And I set field "namebspr" to "KGSP-603"
And I set field "artikel" to id from editor "serartikel-603"
And I save the current editor
And I switch the current editor to editor "kundeng-603"
And I set field "serprodtyp" to "Kundengerät"
And I set field "zuplatzlg" to ""
And I set field "abplatzlg" to ""
And I set field "charge" to ""
And I save the current editor

# Serviceprodukt Auftrag erfassen 
Given I open an editor "auftrag-603" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set field "kunde" to id from editor "kunde"
And I set field "nummer" to "603-AU"
And I set field "such" to "FALL-603"
And I create a new row at the end of the table
And I set field "artikel" to id from editor "serartikel-603" in row 1
And I set field "mge" to "1" in row 1
And I set field "serprod" to id from editor "kundeng-603" in row 1
And I set field "verw" to "603" in row 1
And I save the current editor

#Disposition starten
And I run Scheduling

#Fertigungsvorschlaege zu BA freigeben
Given I open the infosystem "PRODLIST"
And I set field "kart" to id from editor "BG-603"
And I press start
And I press button "release" in row 1
And I close the current editor

Given I open the infosystem "PRODLIST"
And I set field "kart" to id from editor "serartikel-603"
And I press start
And I press button "release" in row 1
And I close the current editor

#BAs rueckmelden
Given I open an editor "rueckmelden" from table "(Workorder):(WorkOrders)" with command "DONE" for record "$,,artikel=BG-603;verw=603;typ==(WorkSlips);@maxtreffer=1;@richtung=V;"
And I set field "gut" to "ja"
And I set field "sofort" to "ja"
And I save the current editor

#BAs rueckmelden
Given I open an editor "rueckmelden" from table "(Workorder):(WorkOrders)" with command "DONE" for record "$,,artikel=BG-603;verw=603;typ==(WorkSlips);@maxtreffer=1;@richtung=R;"
And I set field "gut" to "ja"
And I set field "sofort" to "ja"
And I save the current editor

Given I open an editor "rueckmelden" from table "(Workorder):(WorkOrders)" with command "DONE" for record "$,,artikel=FALL-603;verw=603;typ==(WorkSlips);@maxtreffer=1;@richtung=V;"
And I set field "gut" to "ja"
And I set field "sofort" to "ja"
And I save the current editor

Given I open an editor "rueckmelden" from table "(Workorder):(WorkOrders)" with command "DONE" for record "$,,artikel=FALL-603;verw=603;typ==(WorkSlips);@maxtreffer=1;@richtung=R;"
And I set field "gut" to "ja"
And I set field "sofort" to "ja"
And I save the current editor

# Lieferschein erzeugen und buchen
Given I open an editor "lieferschein-603" from table "(Sales):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "auftrag-603"
And I set field "nummer" to "603-LS"
And I set field "such" to "LS-603"
And I set field "ueb" to "ja"
And I set field "mge" to "1" in row 1
And I save the current editor

# Ausgabe Lieferschein
Given I open an editor "Lieferschein-view" from table "(Sales):(PackingSlip)" with command "VIEW" for record from editor "lieferschein-603"
And I close the current editor

# Serviceauftrag erstellen 
Given I open an editor "serauftrag-603" from table "(Sales):(ServiceOrder)" with command "NEW" for record ""
And I set field "kunde" to id from editor "kunde"
And I set field "vserprod" to id from editor "kundeng-603"
And I set field "nummer" to "603-SAU"
And I set field "such" to "SAU-603"
And I create a new row at the end of the table
And I set field "artikel" to id from editor "dienstl" in row 1
And I set field "mge" to "1" in row 1
And I set field "zzvon" to "8" in row 1
And I set field "zzbis" to "12" in row 1
And I create a new row at the end of the table
And I set field "artikel" to "E2-603" in row 2
And I set field "mge" to "1" in row 2
And I save the current editor

# Ausgabe Serviceauftrag
Given I open an editor "Serviceauftrag-view" from table "(Sales):(ServiceOrder)" with command "VIEW" for record from editor "serauftrag-603"
And I close the current editor

#Fall 603 - Lieferschein erzeugen und buchen
Given I open an editor "lieferschein-603-2" from table "(Sales):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "serauftrag-603"
And I set field "nummer" to "603-LS2"
And I set field "such" to "LS-603-2"
And I set field "ueb" to "ja"
# And I set field "mge" to "1" in row 1
And I set field "mge" to "1" in row 2
And I save the current editor

# Ausgabe Lieferschein
Given I open an editor "Lieferschein-view" from table "(Sales):(PackingSlip)" with command "VIEW" for record from editor "lieferschein-603-2"
And I close the current editor

#####################################################################################################################################

Scenario: FALL-605
# FALL-605

# STAMMDATEN - E1 kopieren
Given I open an editor "E1-605" from table "(Part):(Product)" with command "COPY" for record "E1"
And I set field "such" to "E1-605"
And I set field "losgr" to "0"
And I set field "mindest" to "0"
And I save the current editor
# STAMMDATEN - E2 kopieren
Given I open an editor "E2-605" from table "(Part):(Product)" with command "COPY" for record "E2"
And I set field "such" to "E2-605"
And I set field "losgr" to "0"
And I set field "mindest" to "0"
And I save the current editor

# STAMMDATEN - BG1 kopieren
Given I open an editor "BG-605" from table "(Part):(Product)" with command "COPY" for record "BG1"
And I set field "such" to "BG-605"
And I set field "dispoa" to "Auftragsbezogen"
And I set field "mindest" to "0"
And I set field "elex" to "E1-605" in row 1
And I set field "tnwpflicht" to "ja" in row 1
And I save the current editor

# STAMMDATEN - Servicepflichtigen Artikel anlegen
Given I open an editor "serartikel-605" from table "(Part):(Product)" with command "STORE" for record ""
And I set field "such" to "FALL-605"
And I set field "namebspr" to "Service Artikel 605"
And I set field "vkbez" to "Service Artikel 605"
And I set field "vbez" to "Service Artikel 605"
And I set field "ebez" to "Service Artikel 605"
And I set field "vpr" to "1000"
And I set field "bsart" to "Eigenfertigung"
And I set field "dispoa" to "Auftragsbezogen"
And I set field "chimlager" to "ja"
And I set field "serpflicht" to "ja"
#Stückliste anlegen
And I create a new row at the end of the table
And I set field "elex" to "E2-605" in row 1
And I set field "elanzahl" to "2" in row 1
And I set field "tnwpflicht" to "ja" in row 1
And I set field "tersatzt" to "ja" in row 1
And I create a new row at the end of the table
And I set field "elex" to "A AG3" in row 2
And I create a new row at the end of the table
And I set field "elex" to "BG-605" in row 3
And I set field "elanzahl" to "1" in row 3
And I set field "tnwpflicht" to "ja" in row 3
And I set field "tverschlt" to "ja" in row 3
And I create a new row at the end of the table
And I set field "elex" to "A AG4" in row 4
And I save the current editor

# Rechnung anlegen
Given I open an editor "rechnung" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "lief" to "1"
And I set field "num4" to "605-RE"
And I set field "fakt" to "ja"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I create a new row at the end of the table
And I set field "artex" to "E1-605" in row 1
And I set field "mge" to "605" in row 1
And I set field "preis" to "605" in row 1
And I set field "platz" to "F2" in row 1
And I create a new row at the end of the table
And I set field "artex" to "E2-605" in row 2
And I set field "mge" to "605" in row 2
And I set field "preis" to "605" in row 2
And I set field "platz" to "F2" in row 2
And I set field "kenn" to "FALL-605"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Charge anlegen
Given I open an editor "charge" from table "(Lots):(Lots)" with command "STORE" for record "FALL-605"
And I set field "such" to "FALL-605"
And I set field "exnum" to "FALL-605"
And I set field "artikel" to id from editor "serartikel-605"
And I save the current editor

# Serviceprodukt als Kunden- und Leihgeraet anlegen
Given I open an editor "kundeng-605" from table "(ServiceProduct):(ServiceProduct)" with command "STORE" for record "KGSP-605"
And I set field "such" to "KGSP-605"
And I set field "namebspr" to "KGSP-605"
And I set field "artikel" to id from editor "serartikel-605"
And I save the current editor
And I switch the current editor to editor "kundeng-605"
And I set field "serprodtyp" to "Kundengerät"
And I set field "zuplatzlg" to ""
And I set field "abplatzlg" to ""
And I set field "charge" to ""
And I save the current editor

# Leihgeraet anlegen
Given I open an editor "leihgeraet-605" from table "(ServiceProduct):(ServiceProduct)" with command "STORE" for record "LHSP-605"
And I set field "such" to "LHSP-605"
And I set field "namebspr" to "Leihgeraet 605"
And I set field "artikel" to id from editor "serartikel-605"
And I save the current editor
And I switch the current editor to editor "leihgeraet-605"
And I set field "serprodtyp" to "Leihgeraet"
And I set field "zuplatzlg" to "F4"
And I set field "abplatzlg" to "F4"
And I set field "charge" to "FALL-605"
And I save the current editor

# Leihgeraet fertigen und aus Lager legen
Given I open an editor "fvanlegen" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
And I create a new row at the end of the table
And I set field "artikel" to id from editor "serartikel-605" in row 1
And I set field "mge" to "1" in row 1
And I set field "bisuch" to "LEIHBA" in row 1
And I set field "serprod" to id from editor "leihgeraet-605" in row 1
And I set field "platz" to "F4" in row 1
And I set field "mfreig" to "ja" in row 1
And I press button "freig" to open a subeditor for "fertigung"
And I close the current editor
And I switch the current editor to editor "fvanlegen"
And I close the current editor

#BA fuer Leihgeraet rueckmelden
Given I open an editor "rueckmelden" from table "(Workorder):(WorkOrders)" with command "DONE" for record "LEIHBA000"
And I set field "gut" to "ja"
And I set field "sofort" to "ja"
And I set field "mgr" to "101"
And I save the current editor

# Reparaturauftrag anlegen 
Given I open an editor "repauftrag-605" from table "(Sales):(RepairOrder)" with command "NEW" for record ""
And I set field "kunde" to id from editor "kunde"
And I set field "nummer" to "605-AU"
And I set field "such" to "AU-605"
And I create a new row at the end of the table
And I set field "serprod" to id from editor "kundeng-605" in row 1
Then the table has 2 rows
And I save the current editor

# Ausgabe Reparaturauftrag
Given I open an editor "Auftrag-view" from table "(Sales):(RepairOrder)" with command "VIEW" for record from editor "repauftrag-605"
And I close the current editor

# Zugang Kundengeraet
Given I open an editor "repauftrag-605-2" from table "(Sales):(RepairOrder)" with command "UPDATE" for record from editor "repauftrag-605"
And I press button "repzug" to open a subeditor for "zugangsls-605"
And I set field "nummer" to "605-LS1"
And I set field "such" to "LS-605-1"
And I set field "ueb" to "ja"
And I save the current editor
And I switch the current editor to editor "repauftrag-605-2"
And I save the current editor

#####################################################################################################################################

Scenario: FALL-606
# FALL-606

# STAMMDATEN - E1 kopieren
Given I open an editor "E1-606" from table "(Part):(Product)" with command "COPY" for record "E1"
And I set field "such" to "E1-606"
And I set field "losgr" to "0"
And I set field "mindest" to "0"
And I save the current editor
# STAMMDATEN - E2 kopieren
Given I open an editor "E2-606" from table "(Part):(Product)" with command "COPY" for record "E2"
And I set field "such" to "E2-606"
And I set field "losgr" to "0"
And I set field "mindest" to "0"
And I save the current editor

# STAMMDATEN - BG1 kopieren
Given I open an editor "BG-606" from table "(Part):(Product)" with command "COPY" for record "BG1"
And I set field "such" to "BG-606"
And I set field "dispoa" to "Auftragsbezogen"
And I set field "mindest" to "0"
And I set field "elex" to "E1-606" in row 1
And I set field "tnwpflicht" to "ja" in row 1
And I save the current editor

# STAMMDATEN - Servicepflichtigen Artikel anlegen
Given I open an editor "serartikel-606" from table "(Part):(Product)" with command "STORE" for record ""
And I set field "such" to "FALL-606"
And I set field "namebspr" to "Service Artikel 606"
And I set field "vkbez" to "Service Artikel 606"
And I set field "vbez" to "Service Artikel 606"
And I set field "ebez" to "Service Artikel 606"
And I set field "vpr" to "1000"
And I set field "bsart" to "Eigenfertigung"
And I set field "dispoa" to "Auftragsbezogen"
And I set field "chimlager" to "ja"
And I set field "serpflicht" to "ja"
#Stückliste anlegen
And I create a new row at the end of the table
And I set field "elex" to "E2-606" in row 1
And I set field "elanzahl" to "2" in row 1
And I set field "tnwpflicht" to "ja" in row 1
And I set field "tersatzt" to "ja" in row 1
And I create a new row at the end of the table
And I set field "elex" to "A AG3" in row 2
And I create a new row at the end of the table
And I set field "elex" to "BG-606" in row 3
And I set field "elanzahl" to "1" in row 3
And I set field "tnwpflicht" to "ja" in row 3
And I set field "tverschlt" to "ja" in row 3
And I create a new row at the end of the table
And I set field "elex" to "A AG4" in row 4
And I save the current editor

# Rechnung anlegen
Given I open an editor "rechnung" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "lief" to "1"
And I set field "num4" to "606-RE"
And I set field "fakt" to "ja"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I create a new row at the end of the table
And I set field "artex" to "E1-606" in row 1
And I set field "mge" to "606" in row 1
And I set field "preis" to "606" in row 1
And I set field "platz" to "F2" in row 1
And I create a new row at the end of the table
And I set field "artex" to "E2-606" in row 2
And I set field "mge" to "606" in row 2
And I set field "preis" to "606" in row 2
And I set field "platz" to "F2" in row 2
And I set field "kenn" to "FALL-606"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Charge anlegen
Given I open an editor "charge" from table "(Lots):(Lots)" with command "STORE" for record "FALL-606"
And I set field "such" to "FALL-606"
And I set field "exnum" to "FALL-606"
And I set field "artikel" to id from editor "serartikel-606"
And I save the current editor

# Serviceprodukt als Kunden- und Leihgeraet anlegen
Given I open an editor "kundeng-606" from table "(ServiceProduct):(ServiceProduct)" with command "STORE" for record "KGSP-606"
And I set field "such" to "KGSP-606"
And I set field "namebspr" to "KGSP-606"
And I set field "artikel" to id from editor "serartikel-606"
And I save the current editor
And I switch the current editor to editor "kundeng-606"
And I set field "serprodtyp" to "Kundengerät"
And I set field "zuplatzlg" to ""
And I set field "abplatzlg" to ""
And I set field "charge" to ""
And I save the current editor

# Leihgeraet anlegen
Given I open an editor "leihgeraet-606" from table "(ServiceProduct):(ServiceProduct)" with command "STORE" for record "LHSP-606"
And I set field "such" to "LHSP-606"
And I set field "namebspr" to "Leihgeraet 606"
And I set field "artikel" to id from editor "serartikel-606"
And I save the current editor
And I switch the current editor to editor "leihgeraet-606"
And I set field "serprodtyp" to "Leihgeraet"
And I set field "zuplatzlg" to "F4"
And I set field "abplatzlg" to "F4"
And I set field "charge" to "FALL-606"
And I save the current editor

# Leihgeraet fertigen und aus Lager legen
Given I open an editor "fvanlegen" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
And I create a new row at the end of the table
And I set field "artikel" to id from editor "serartikel-606" in row 1
And I set field "mge" to "1" in row 1
And I set field "bisuch" to "LEIHBA" in row 1
And I set field "serprod" to id from editor "leihgeraet-606" in row 1
And I set field "platz" to "F4" in row 1
And I set field "mfreig" to "ja" in row 1
And I press button "freig" to open a subeditor for "fertigung"
And I close the current editor
And I switch the current editor to editor "fvanlegen"
And I close the current editor

#BA fuer Leihgeraet rueckmelden
Given I open an editor "rueckmelden" from table "(Workorder):(WorkOrders)" with command "DONE" for record "LEIHBA000"
And I set field "gut" to "ja"
And I set field "sofort" to "ja"
And I set field "mgr" to "101"
And I save the current editor

# Reparaturauftrag anlegen 
Given I open an editor "repauftrag-606" from table "(Sales):(RepairOrder)" with command "NEW" for record ""
And I set field "kunde" to id from editor "kunde"
And I set field "nummer" to "606-AU"
And I set field "such" to "AU-606"
And I create a new row at the end of the table
And I set field "serprod" to id from editor "kundeng-606" in row 1
Then the table has 2 rows
And I save the current editor

# Ausgabe Reparaturauftrag
Given I open an editor "Auftrag-view" from table "(Sales):(RepairOrder)" with command "VIEW" for record from editor "repauftrag-606"
And I close the current editor

Given I open an editor "repauftrag-606-2" from table "(Sales):(RepairOrder)" with command "UPDATE" for record from editor "repauftrag-606"
And I press button "repabgl" to open a subeditor for "abgangsls-606"
And I set field "nummer" to "606-LS"
And I set field "such" to "LS-606"
And I set field "ueb" to "ja"
And I set field "umplatz" to "extern"
And I save the current editor
And I switch the current editor to editor "repauftrag-606-2"
And I save the current editor

# Ausgabe Lieferschein
Given I open an editor "Lieferschein-view" from table "(Sales):(PackingSlip)" with command "VIEW" for record from editor "abgangsls-606"
And I close the current editor


#####################################################################################################################################

Scenario: FALL-607
# FALL-607

# STAMMDATEN - E1 kopieren
Given I open an editor "E1-607" from table "(Part):(Product)" with command "COPY" for record "E1"
And I set field "such" to "E1-607"
And I set field "losgr" to "0"
And I set field "mindest" to "0"
And I save the current editor
# STAMMDATEN - E2 kopieren
Given I open an editor "E2-607" from table "(Part):(Product)" with command "COPY" for record "E2"
And I set field "such" to "E2-607"
And I set field "losgr" to "0"
And I set field "mindest" to "0"
And I save the current editor

# STAMMDATEN - BG1 kopieren
Given I open an editor "BG-607" from table "(Part):(Product)" with command "COPY" for record "BG1"
And I set field "such" to "BG-607"
And I set field "dispoa" to "Auftragsbezogen"
And I set field "mindest" to "0"
And I set field "elex" to "E1-607" in row 1
And I set field "tnwpflicht" to "ja" in row 1
And I save the current editor

# STAMMDATEN - Servicepflichtigen Artikel anlegen
Given I open an editor "serartikel-607" from table "(Part):(Product)" with command "STORE" for record ""
And I set field "such" to "FALL-607"
And I set field "namebspr" to "Service Artikel 607"
And I set field "vkbez" to "Service Artikel 607"
And I set field "vbez" to "Service Artikel 607"
And I set field "ebez" to "Service Artikel 607"
And I set field "vpr" to "1000"
And I set field "bsart" to "Eigenfertigung"
And I set field "dispoa" to "Auftragsbezogen"
And I set field "chimlager" to "ja"
And I set field "serpflicht" to "ja"
#Stückliste anlegen
And I create a new row at the end of the table
And I set field "elex" to "E2-607" in row 1
And I set field "elanzahl" to "2" in row 1
And I set field "tnwpflicht" to "ja" in row 1
And I set field "tersatzt" to "ja" in row 1
And I create a new row at the end of the table
And I set field "elex" to "A AG3" in row 2
And I create a new row at the end of the table
And I set field "elex" to "BG-607" in row 3
And I set field "elanzahl" to "1" in row 3
And I set field "tnwpflicht" to "ja" in row 3
And I set field "tverschlt" to "ja" in row 3
And I create a new row at the end of the table
And I set field "elex" to "A AG4" in row 4
And I save the current editor

# Rechnung anlegen
Given I open an editor "rechnung" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "lief" to "1"
And I set field "num4" to "607-RE"
And I set field "fakt" to "ja"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I create a new row at the end of the table
And I set field "artex" to "E1-607" in row 1
And I set field "mge" to "607" in row 1
And I set field "preis" to "607" in row 1
And I set field "platz" to "F2" in row 1
And I create a new row at the end of the table
And I set field "artex" to "E2-607" in row 2
And I set field "mge" to "607" in row 2
And I set field "preis" to "607" in row 2
And I set field "platz" to "F2" in row 2
And I set field "kenn" to "FALL-607"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Charge anlegen
Given I open an editor "charge" from table "(Lots):(Lots)" with command "STORE" for record "FALL-607"
And I set field "such" to "FALL-607"
And I set field "exnum" to "FALL-607"
And I set field "artikel" to id from editor "serartikel-607"
And I save the current editor

# Serviceprodukt als Kunden- und Leihgeraet anlegen
Given I open an editor "kundeng-607" from table "(ServiceProduct):(ServiceProduct)" with command "STORE" for record "KGSP-607"
And I set field "such" to "KGSP-607"
And I set field "namebspr" to "KGSP-607"
And I set field "artikel" to id from editor "serartikel-607"
And I save the current editor
And I switch the current editor to editor "kundeng-607"
And I set field "serprodtyp" to "Kundengerät"
And I set field "zuplatzlg" to ""
And I set field "abplatzlg" to ""
And I set field "charge" to ""
And I save the current editor

# Serviceauftrag erstellen 
Given I open an editor "serauftrag-607" from table "(Sales):(ServiceOrder)" with command "NEW" for record ""
And I set field "kunde" to id from editor "kunde"
And I set field "vserprod" to id from editor "kundeng-607"
And I set field "nummer" to "607-SAU"
And I set field "such" to "SAU-607"
And I create a new row at the end of the table
And I set field "techniker" to id from editor "techniker" in row 1
And I set field "artikel" to id from editor "dienstl" in row 1
And I set field "mge" to "1" in row 1
And I set field "zzvon" to "8" in row 1
And I set field "zzbis" to "12" in row 1
And I create a new row at the end of the table
And I set field "techniker" to id from editor "techniker" in row 2
And I set field "artikel" to "E2-607" in row 2
And I set field "mge" to "1" in row 2
And I save the current editor

# Ausgabe Serviceauftrag
Given I open an editor "Serviceauftrag-view" from table "(Sales):(ServiceOrder)" with command "VIEW" for record from editor "serauftrag-607"
And I close the current editor

#Fall 607 - Servicerueckmeldung durchfuehren
Given I open an editor "srmeldung-607" from table "(ServiceReservation):(EngineerCompletionConfirmations)" with command "NEW" for record ""
And I set field "techniker" to id from editor "techniker"
And I set field "servau" to id from editor "serauftrag-607"
And I press button "ladetab"
Then the table has 2 rows
And I set field "buchen" to "ja" in row 1
And I set field "dauer" to "4h" in row 1
And I set field "buchen" to "ja" in row 2
And I set field "serstlsts" to "wird aktualisiert" in row 2
And I save the current editor

#####################################################################################################################################

Scenario: FALL-608
# FALL-608

# STAMMDATEN - E1 kopieren
Given I open an editor "E1-608" from table "(Part):(Product)" with command "COPY" for record "E1"
And I set field "such" to "E1-608"
And I set field "losgr" to "0"
And I set field "mindest" to "0"
And I save the current editor
# STAMMDATEN - E2 kopieren
Given I open an editor "E2-608" from table "(Part):(Product)" with command "COPY" for record "E2"
And I set field "such" to "E2-608"
And I set field "losgr" to "0"
And I set field "mindest" to "0"
And I save the current editor

# STAMMDATEN - BG1 kopieren
Given I open an editor "BG-608" from table "(Part):(Product)" with command "COPY" for record "BG1"
And I set field "such" to "BG-608"
And I set field "dispoa" to "Auftragsbezogen"
And I set field "mindest" to "0"
And I set field "elex" to "E1-608" in row 1
And I set field "tnwpflicht" to "ja" in row 1
And I save the current editor

# STAMMDATEN - Servicepflichtigen Artikel anlegen
Given I open an editor "serartikel-608" from table "(Part):(Product)" with command "STORE" for record ""
And I set field "such" to "FALL-608"
And I set field "namebspr" to "Service Artikel 608"
And I set field "vkbez" to "Service Artikel 608"
And I set field "vbez" to "Service Artikel 608"
And I set field "ebez" to "Service Artikel 608"
And I set field "vpr" to "1000"
And I set field "bsart" to "Eigenfertigung"
And I set field "dispoa" to "Auftragsbezogen"
And I set field "chimlager" to "ja"
And I set field "serpflicht" to "ja"
#Stückliste anlegen
And I create a new row at the end of the table
And I set field "elex" to "E2-608" in row 1
And I set field "elanzahl" to "2" in row 1
And I set field "tnwpflicht" to "ja" in row 1
And I set field "tersatzt" to "ja" in row 1
And I create a new row at the end of the table
And I set field "elex" to "A AG3" in row 2
And I create a new row at the end of the table
And I set field "elex" to "BG-608" in row 3
And I set field "elanzahl" to "1" in row 3
And I set field "tnwpflicht" to "ja" in row 3
And I set field "tverschlt" to "ja" in row 3
And I create a new row at the end of the table
And I set field "elex" to "A AG4" in row 4
And I save the current editor

# Rechnung anlegen
Given I open an editor "rechnung" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "lief" to "1"
And I set field "num4" to "608-RE"
And I set field "fakt" to "ja"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I create a new row at the end of the table
And I set field "artex" to "E1-608" in row 1
And I set field "mge" to "608" in row 1
And I set field "preis" to "608" in row 1
And I set field "platz" to "F2" in row 1
And I create a new row at the end of the table
And I set field "artex" to "E2-608" in row 2
And I set field "mge" to "608" in row 2
And I set field "preis" to "608" in row 2
And I set field "platz" to "F2" in row 2
And I set field "kenn" to "FALL-608"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Charge anlegen
Given I open an editor "charge" from table "(Lots):(Lots)" with command "STORE" for record "FALL-608"
And I set field "such" to "FALL-608"
And I set field "exnum" to "FALL-608"
And I set field "artikel" to id from editor "serartikel-608"
And I save the current editor

# Serviceprodukt als Kunden- und Leihgeraet anlegen
Given I open an editor "kundeng-608" from table "(ServiceProduct):(ServiceProduct)" with command "STORE" for record "KGSP-608"
And I set field "such" to "KGSP-608"
And I set field "namebspr" to "KGSP-608"
And I set field "artikel" to id from editor "serartikel-608"
And I save the current editor
And I switch the current editor to editor "kundeng-608"
And I set field "serprodtyp" to "Kundengerät"
And I set field "zuplatzlg" to ""
And I set field "abplatzlg" to ""
And I set field "charge" to ""
And I save the current editor

# Serviceprodukt Auftrag erfassen 
Given I open an editor "auftrag-608" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set field "kunde" to id from editor "kunde"
And I set field "nummer" to "608-AU"
And I set field "such" to "FALL-608"
And I create a new row at the end of the table
And I set field "artikel" to id from editor "serartikel-608" in row 1
And I set field "mge" to "1" in row 1
And I set field "serprod" to id from editor "kundeng-608" in row 1
And I set field "verw" to "608" in row 1
And I save the current editor

#Disposition starten
And I run Scheduling

#Fertigungsvorschlaege zu BA freigeben
Given I open the infosystem "PRODLIST"
And I set field "kart" to id from editor "BG-608"
And I press start
And I press button "release" in row 1
And I close the current editor

Given I open the infosystem "PRODLIST"
And I set field "kart" to id from editor "serartikel-608"
And I press start
And I press button "release" in row 1
And I close the current editor

#BAs rueckmelden
Given I open an editor "rueckmelden" from table "(Workorder):(WorkOrders)" with command "DONE" for record "$,,artikel=BG-608;verw=608;typ==(WorkSlips);@maxtreffer=1;@richtung=V;"
And I set field "gut" to "ja"
And I set field "sofort" to "ja"
And I save the current editor

#BAs rueckmelden
Given I open an editor "rueckmelden" from table "(Workorder):(WorkOrders)" with command "DONE" for record "$,,artikel=BG-608;verw=608;typ==(WorkSlips);@maxtreffer=1;@richtung=R;"
And I set field "gut" to "ja"
And I set field "sofort" to "ja"
And I save the current editor

Given I open an editor "rueckmelden" from table "(Workorder):(WorkOrders)" with command "DONE" for record "$,,artikel=FALL-608;verw=608;typ==(WorkSlips);@maxtreffer=1;@richtung=V;"
And I set field "gut" to "ja"
And I set field "sofort" to "ja"
And I save the current editor

Given I open an editor "rueckmelden" from table "(Workorder):(WorkOrders)" with command "DONE" for record "$,,artikel=FALL-608;verw=608;typ==(WorkSlips);@maxtreffer=1;@richtung=R;"
And I set field "gut" to "ja"
And I set field "sofort" to "ja"
And I save the current editor

#Fall 608 - Lieferschein erzeugen und buchen
Given I open an editor "lieferschein-608" from table "(Sales):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "auftrag-608"
And I set field "nummer" to "608-LS"
And I set field "such" to "LS-608"
And I set field "ueb" to "ja"
And I set field "mge" to "1" in row 1
And I save the current editor

# Ausgabe Lieferschein
Given I open an editor "Lieferschein-view" from table "(Sales):(PackingSlip)" with command "VIEW" for record from editor "lieferschein-608"
And I close the current editor

#Fall 608 - Rechnung erzeugen
Given I open an editor "rechnung-608" from table "(Sales):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "lieferschein-608"
And I set field "nummer" to "608-RE"
And I set field "such" to "FALL-608"
And I set field "ueb" to "ja"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Ausgabe Rechnung
Given I open an editor "Rechnung-view" from table "(Sales):(Invoice)" with command "VIEW" for record from editor "rechnung-608"
And I close the current editor

#####################################################################################################################################

Scenario: FALL-609
# FALL-609

# STAMMDATEN - E1 kopieren
Given I open an editor "E1-609" from table "(Part):(Product)" with command "COPY" for record "E1"
And I set field "such" to "E1-609"
And I set field "losgr" to "0"
And I set field "mindest" to "0"
And I save the current editor
# STAMMDATEN - E2 kopieren
Given I open an editor "E2-609" from table "(Part):(Product)" with command "COPY" for record "E2"
And I set field "such" to "E2-609"
And I set field "losgr" to "0"
And I set field "mindest" to "0"
And I save the current editor

# STAMMDATEN - BG1 kopieren
Given I open an editor "BG-609" from table "(Part):(Product)" with command "COPY" for record "BG1"
And I set field "such" to "BG-609"
And I set field "dispoa" to "Auftragsbezogen"
And I set field "mindest" to "0"
And I set field "elex" to "E1-609" in row 1
And I set field "tnwpflicht" to "ja" in row 1
And I save the current editor

# STAMMDATEN - Servicepflichtigen Artikel anlegen
Given I open an editor "serartikel-609" from table "(Part):(Product)" with command "STORE" for record ""
And I set field "such" to "FALL-609"
And I set field "namebspr" to "Service Artikel 609"
And I set field "vkbez" to "Service Artikel 609"
And I set field "vbez" to "Service Artikel 609"
And I set field "ebez" to "Service Artikel 609"
And I set field "vpr" to "1000"
And I set field "bsart" to "Eigenfertigung"
And I set field "dispoa" to "Auftragsbezogen"
And I set field "chimlager" to "ja"
And I set field "serpflicht" to "ja"
#Stückliste anlegen
And I create a new row at the end of the table
And I set field "elex" to "E2-609" in row 1
And I set field "elanzahl" to "2" in row 1
And I set field "tnwpflicht" to "ja" in row 1
And I set field "tersatzt" to "ja" in row 1
And I create a new row at the end of the table
And I set field "elex" to "A AG3" in row 2
And I create a new row at the end of the table
And I set field "elex" to "BG-609" in row 3
And I set field "elanzahl" to "1" in row 3
And I set field "tnwpflicht" to "ja" in row 3
And I set field "tverschlt" to "ja" in row 3
And I create a new row at the end of the table
And I set field "elex" to "A AG4" in row 4
And I save the current editor

# Rechnung anlegen
Given I open an editor "rechnung" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "lief" to "1"
And I set field "num4" to "609-RE"
And I set field "fakt" to "ja"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I create a new row at the end of the table
And I set field "artex" to "E1-609" in row 1
And I set field "mge" to "609" in row 1
And I set field "preis" to "609" in row 1
And I set field "platz" to "F2" in row 1
And I create a new row at the end of the table
And I set field "artex" to "E2-609" in row 2
And I set field "mge" to "609" in row 2
And I set field "preis" to "609" in row 2
And I set field "platz" to "F2" in row 2
And I set field "kenn" to "FALL-609"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Charge anlegen
Given I open an editor "charge" from table "(Lots):(Lots)" with command "STORE" for record "FALL-609"
And I set field "such" to "FALL-609"
And I set field "exnum" to "FALL-609"
And I set field "artikel" to id from editor "serartikel-609"
And I save the current editor

# Serviceprodukt als Kunden- und Leihgeraet anlegen
Given I open an editor "kundeng-609" from table "(ServiceProduct):(ServiceProduct)" with command "STORE" for record "KGSP-609"
And I set field "such" to "KGSP-609"
And I set field "namebspr" to "KGSP-609"
And I set field "artikel" to id from editor "serartikel-609"
And I save the current editor
And I switch the current editor to editor "kundeng-609"
And I set field "serprodtyp" to "Kundengerät"
And I set field "zuplatzlg" to ""
And I set field "abplatzlg" to ""
And I set field "charge" to ""
And I save the current editor

# Serviceprodukt Auftrag erfassen 
Given I open an editor "auftrag-609" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set field "kunde" to id from editor "kunde"
And I set field "nummer" to "609-AU"
And I set field "such" to "FALL-609"
And I create a new row at the end of the table
And I set field "artikel" to id from editor "serartikel-609" in row 1
And I set field "mge" to "1" in row 1
And I set field "serprod" to id from editor "kundeng-609" in row 1
And I set field "verw" to "609" in row 1
And I save the current editor

#Disposition starten
And I run Scheduling

#Fertigungsvorschlaege zu BA freigeben
Given I open the infosystem "PRODLIST"
And I set field "kart" to id from editor "BG-609"
And I press start
And I press button "release" in row 1
And I close the current editor

Given I open the infosystem "PRODLIST"
And I set field "kart" to id from editor "serartikel-609"
And I press start
And I press button "release" in row 1
And I close the current editor

#BAs rueckmelden
Given I open an editor "rueckmelden" from table "(Workorder):(WorkOrders)" with command "DONE" for record "$,,artikel=BG-609;verw=609;typ==(WorkSlips);@maxtreffer=1;@richtung=V;"
And I set field "gut" to "ja"
And I set field "sofort" to "ja"
And I save the current editor

#BAs rueckmelden
Given I open an editor "rueckmelden" from table "(Workorder):(WorkOrders)" with command "DONE" for record "$,,artikel=BG-609;verw=609;typ==(WorkSlips);@maxtreffer=1;@richtung=R;"
And I set field "gut" to "ja"
And I set field "sofort" to "ja"
And I save the current editor

Given I open an editor "rueckmelden" from table "(Workorder):(WorkOrders)" with command "DONE" for record "$,,artikel=FALL-609;verw=609;typ==(WorkSlips);@maxtreffer=1;@richtung=V;"
And I set field "gut" to "ja"
And I set field "sofort" to "ja"
And I save the current editor

Given I open an editor "rueckmelden" from table "(Workorder):(WorkOrders)" with command "DONE" for record "$,,artikel=FALL-609;verw=609;typ==(WorkSlips);@maxtreffer=1;@richtung=R;"
And I set field "gut" to "ja"
And I set field "sofort" to "ja"
And I save the current editor

# Lieferschein erzeugen und buchen
Given I open an editor "lieferschein-609" from table "(Sales):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "auftrag-609"
And I set field "nummer" to "609-LS"
And I set field "such" to "LS-609"
And I set field "ueb" to "ja"
And I set field "mge" to "1" in row 1
And I save the current editor

# Ausgabe Lieferschein
Given I open an editor "Lieferschein-view" from table "(Sales):(PackingSlip)" with command "VIEW" for record from editor "lieferschein-609"
And I close the current editor

# Serviceauftrag erstellen 
Given I open an editor "serauftrag-609" from table "(Sales):(ServiceOrder)" with command "NEW" for record ""
And I set field "kunde" to id from editor "kunde"
And I set field "vserprod" to id from editor "kundeng-609"
And I set field "nummer" to "609-SAU"
And I set field "such" to "SAU-609"
And I create a new row at the end of the table
And I set field "artikel" to id from editor "dienstl" in row 1
And I set field "mge" to "1" in row 1
And I set field "zzvon" to "8" in row 1
And I set field "zzbis" to "12" in row 1
And I create a new row at the end of the table
And I set field "artikel" to "E2-609" in row 2
And I set field "mge" to "1" in row 2
And I save the current editor

# Ausgabe Serviceauftrag
Given I open an editor "Serviceauftrag-view" from table "(Sales):(ServiceOrder)" with command "VIEW" for record from editor "serauftrag-609"
And I close the current editor

#Fall 609, Lieferschein erzeugen und buchen
Given I open an editor "lieferschein-609-2" from table "(Sales):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "serauftrag-609"
And I set field "nummer" to "609-LS2"
And I set field "such" to "LS-609-2"
And I set field "ueb" to "ja"
And I set field "mge" to "1" in row 1
# And I set field "mge" to "1" in row 2
And I save the current editor

# Ausgabe Lieferschein
Given I open an editor "Lieferschein-view" from table "(Sales):(PackingSlip)" with command "VIEW" for record from editor "lieferschein-609-2"
And I close the current editor

#Fall 609 - Rechnung erzeugen
Given I open an editor "rechnung-609-2" from table "(Sales):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "lieferschein-609-2"
And I set field "nummer" to "609-RE-2"
And I set field "such" to "FALL-609"
And I set field "ueb" to "ja"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Ausgabe Rechnung
Given I open an editor "Rechnung-view" from table "(Sales):(Invoice)" with command "VIEW" for record from editor "rechnung-609-2"
And I close the current editor

#####################################################################################################################################

Scenario: FALL-610
# FALL-610

# STAMMDATEN - E1 kopieren
Given I open an editor "E1-610" from table "(Part):(Product)" with command "COPY" for record "E1"
And I set field "such" to "E1-610"
And I set field "losgr" to "0"
And I set field "mindest" to "0"
And I save the current editor
# STAMMDATEN - E2 kopieren
Given I open an editor "E2-610" from table "(Part):(Product)" with command "COPY" for record "E2"
And I set field "such" to "E2-610"
And I set field "losgr" to "0"
And I set field "mindest" to "0"
And I save the current editor

# STAMMDATEN - BG1 kopieren
Given I open an editor "BG-610" from table "(Part):(Product)" with command "COPY" for record "BG1"
And I set field "such" to "BG-610"
And I set field "dispoa" to "Auftragsbezogen"
And I set field "mindest" to "0"
And I set field "elex" to "E1-610" in row 1
And I set field "tnwpflicht" to "ja" in row 1
And I save the current editor

# STAMMDATEN - Servicepflichtigen Artikel anlegen
Given I open an editor "serartikel-610" from table "(Part):(Product)" with command "STORE" for record ""
And I set field "such" to "FALL-610"
And I set field "namebspr" to "Service Artikel 610"
And I set field "vkbez" to "Service Artikel 610"
And I set field "vbez" to "Service Artikel 610"
And I set field "ebez" to "Service Artikel 610"
And I set field "vpr" to "1000"
And I set field "bsart" to "Eigenfertigung"
And I set field "dispoa" to "Auftragsbezogen"
And I set field "chimlager" to "ja"
And I set field "serpflicht" to "ja"
#Stückliste anlegen
And I create a new row at the end of the table
And I set field "elex" to "E2-610" in row 1
And I set field "elanzahl" to "2" in row 1
And I set field "tnwpflicht" to "ja" in row 1
And I set field "tersatzt" to "ja" in row 1
And I create a new row at the end of the table
And I set field "elex" to "A AG3" in row 2
And I create a new row at the end of the table
And I set field "elex" to "BG-610" in row 3
And I set field "elanzahl" to "1" in row 3
And I set field "tnwpflicht" to "ja" in row 3
And I set field "tverschlt" to "ja" in row 3
And I create a new row at the end of the table
And I set field "elex" to "A AG4" in row 4
And I save the current editor

# Rechnung anlegen
Given I open an editor "rechnung" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "lief" to "1"
And I set field "num4" to "610-RE"
And I set field "fakt" to "ja"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I create a new row at the end of the table
And I set field "artex" to "E1-610" in row 1
And I set field "mge" to "610" in row 1
And I set field "preis" to "610" in row 1
And I set field "platz" to "F2" in row 1
And I create a new row at the end of the table
And I set field "artex" to "E2-610" in row 2
And I set field "mge" to "610" in row 2
And I set field "preis" to "610" in row 2
And I set field "platz" to "F2" in row 2
And I set field "kenn" to "FALL-610"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Charge anlegen
Given I open an editor "charge" from table "(Lots):(Lots)" with command "STORE" for record "FALL-610"
And I set field "such" to "FALL-610"
And I set field "exnum" to "FALL-610"
And I set field "artikel" to id from editor "serartikel-610"
And I save the current editor

# Serviceprodukt als Kunden- und Leihgeraet anlegen
Given I open an editor "kundeng-610" from table "(ServiceProduct):(ServiceProduct)" with command "STORE" for record "KGSP-610"
And I set field "such" to "KGSP-610"
And I set field "namebspr" to "KGSP-610"
And I set field "artikel" to id from editor "serartikel-610"
And I save the current editor
And I switch the current editor to editor "kundeng-610"
And I set field "serprodtyp" to "Kundengerät"
And I set field "zuplatzlg" to ""
And I set field "abplatzlg" to ""
And I set field "charge" to ""
And I save the current editor

# Serviceprodukt Auftrag erfassen 
Given I open an editor "auftrag-610" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set field "kunde" to id from editor "kunde"
And I set field "nummer" to "610-AU"
And I set field "such" to "FALL-610"
And I create a new row at the end of the table
And I set field "artikel" to id from editor "serartikel-610" in row 1
And I set field "mge" to "1" in row 1
And I set field "serprod" to id from editor "kundeng-610" in row 1
And I set field "verw" to "610" in row 1
And I save the current editor

#Disposition starten
And I run Scheduling

#Fertigungsvorschlaege zu BA freigeben
Given I open the infosystem "PRODLIST"
And I set field "kart" to id from editor "BG-610"
And I press start
And I press button "release" in row 1
And I close the current editor

Given I open the infosystem "PRODLIST"
And I set field "kart" to id from editor "serartikel-610"
And I press start
And I press button "release" in row 1
And I close the current editor

#BAs rueckmelden
Given I open an editor "rueckmelden" from table "(Workorder):(WorkOrders)" with command "DONE" for record "$,,artikel=BG-610;verw=610;typ==(WorkSlips);@maxtreffer=1;@richtung=V;"
And I set field "gut" to "ja"
And I set field "sofort" to "ja"
And I save the current editor

#BAs rueckmelden
Given I open an editor "rueckmelden" from table "(Workorder):(WorkOrders)" with command "DONE" for record "$,,artikel=BG-610;verw=610;typ==(WorkSlips);@maxtreffer=1;@richtung=R;"
And I set field "gut" to "ja"
And I set field "sofort" to "ja"
And I save the current editor

Given I open an editor "rueckmelden" from table "(Workorder):(WorkOrders)" with command "DONE" for record "$,,artikel=FALL-610;verw=610;typ==(WorkSlips);@maxtreffer=1;@richtung=V;"
And I set field "gut" to "ja"
And I set field "sofort" to "ja"
And I save the current editor

Given I open an editor "rueckmelden" from table "(Workorder):(WorkOrders)" with command "DONE" for record "$,,artikel=FALL-610;verw=610;typ==(WorkSlips);@maxtreffer=1;@richtung=R;"
And I set field "gut" to "ja"
And I set field "sofort" to "ja"
And I save the current editor

# Lieferschein erzeugen und buchen
Given I open an editor "lieferschein-610" from table "(Sales):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "auftrag-610"
And I set field "nummer" to "610-LS"
And I set field "such" to "LS-610"
And I set field "ueb" to "ja"
And I set field "mge" to "1" in row 1
And I save the current editor

# Ausgabe Lieferschein
Given I open an editor "Lieferschein-view" from table "(Sales):(PackingSlip)" with command "VIEW" for record from editor "lieferschein-610"
And I close the current editor

# Serviceauftrag erstellen 
Given I open an editor "serauftrag-610" from table "(Sales):(ServiceOrder)" with command "NEW" for record ""
And I set field "kunde" to id from editor "kunde"
And I set field "vserprod" to id from editor "kundeng-610"
And I set field "nummer" to "610-SAU"
And I set field "such" to "SAU-610"
And I create a new row at the end of the table
And I set field "artikel" to id from editor "dienstl" in row 1
And I set field "mge" to "1" in row 1
And I set field "zzvon" to "8" in row 1
And I set field "zzbis" to "12" in row 1
And I create a new row at the end of the table
And I set field "artikel" to "E2-610" in row 2
And I set field "mge" to "1" in row 2
And I set field "preis" to "610" in row 2
And I save the current editor

# Ausgabe Serviceauftrag
Given I open an editor "Serviceauftrag-view" from table "(Sales):(ServiceOrder)" with command "VIEW" for record from editor "serauftrag-610"
And I close the current editor

#Fall 610 - Lieferschein erzeugen und buchen
Given I open an editor "lieferschein-610-2" from table "(Sales):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "serauftrag-610"
And I set field "nummer" to "610-LS2"
And I set field "such" to "LS-610-2"
And I set field "ueb" to "ja"
# And I set field "mge" to "1" in row 1
And I set field "mge" to "1" in row 2
And I save the current editor

# Ausgabe Lieferschein
Given I open an editor "Lieferschein-view" from table "(Sales):(PackingSlip)" with command "VIEW" for record from editor "lieferschein-610-2"
And I close the current editor

#Fall 610 - Rechnung erzeugen
Given I open an editor "rechnung-610-2" from table "(Sales):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "lieferschein-610-2"
And I set field "nummer" to "610-RE-2"
And I set field "such" to "FALL-610"
And I set field "ueb" to "ja"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Ausgabe Rechnung
Given I open an editor "Rechnung-view" from table "(Sales):(Invoice)" with command "VIEW" for record from editor "rechnung-610-2"
And I close the current editor

#####################################################################################################################################

Scenario: FALL-611
# FALL-611

# STAMMDATEN - E1 kopieren
Given I open an editor "E1-611" from table "(Part):(Product)" with command "COPY" for record "E1"
And I set field "such" to "E1-611"
And I set field "losgr" to "0"
And I set field "mindest" to "0"
And I save the current editor
# STAMMDATEN - E2 kopieren
Given I open an editor "E2-611" from table "(Part):(Product)" with command "COPY" for record "E2"
And I set field "such" to "E2-611"
And I set field "losgr" to "0"
And I set field "mindest" to "0"
And I save the current editor

# STAMMDATEN - BG1 kopieren
Given I open an editor "BG-611" from table "(Part):(Product)" with command "COPY" for record "BG1"
And I set field "such" to "BG-611"
And I set field "dispoa" to "Auftragsbezogen"
And I set field "mindest" to "0"
And I set field "elex" to "E1-611" in row 1
And I set field "tnwpflicht" to "ja" in row 1
And I save the current editor

# STAMMDATEN - Servicepflichtigen Artikel anlegen
Given I open an editor "serartikel-611" from table "(Part):(Product)" with command "STORE" for record ""
And I set field "such" to "FALL-611"
And I set field "namebspr" to "Service Artikel 611"
And I set field "vkbez" to "Service Artikel 611"
And I set field "vbez" to "Service Artikel 611"
And I set field "ebez" to "Service Artikel 611"
And I set field "vpr" to "1000"
And I set field "bsart" to "Eigenfertigung"
And I set field "dispoa" to "Auftragsbezogen"
And I set field "chimlager" to "ja"
And I set field "serpflicht" to "ja"
#Stückliste anlegen
And I create a new row at the end of the table
And I set field "elex" to "E2-611" in row 1
And I set field "elanzahl" to "2" in row 1
And I set field "tnwpflicht" to "ja" in row 1
And I set field "tersatzt" to "ja" in row 1
And I create a new row at the end of the table
And I set field "elex" to "A AG3" in row 2
And I create a new row at the end of the table
And I set field "elex" to "BG-611" in row 3
And I set field "elanzahl" to "1" in row 3
And I set field "tnwpflicht" to "ja" in row 3
And I set field "tverschlt" to "ja" in row 3
And I create a new row at the end of the table
And I set field "elex" to "A AG4" in row 4
And I save the current editor

# Rechnung anlegen
Given I open an editor "rechnung" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "lief" to "1"
And I set field "num4" to "611-RE"
And I set field "fakt" to "ja"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I create a new row at the end of the table
And I set field "artex" to "E1-611" in row 1
And I set field "mge" to "611" in row 1
And I set field "preis" to "611" in row 1
And I set field "platz" to "F2" in row 1
And I create a new row at the end of the table
And I set field "artex" to "E2-611" in row 2
And I set field "mge" to "611" in row 2
And I set field "preis" to "611" in row 2
And I set field "platz" to "F2" in row 2
And I set field "kenn" to "FALL-611"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Charge anlegen
Given I open an editor "charge" from table "(Lots):(Lots)" with command "STORE" for record "FALL-611"
And I set field "such" to "FALL-611"
And I set field "exnum" to "FALL-611"
And I set field "artikel" to id from editor "serartikel-611"
And I save the current editor

# Serviceprodukt als Kunden- und Leihgeraet anlegen
Given I open an editor "kundeng-611" from table "(ServiceProduct):(ServiceProduct)" with command "STORE" for record "KGSP-611"
And I set field "such" to "KGSP-611"
And I set field "namebspr" to "KGSP-611"
And I set field "artikel" to id from editor "serartikel-611"
And I save the current editor
And I switch the current editor to editor "kundeng-611"
And I set field "serprodtyp" to "Kundengerät"
And I set field "zuplatzlg" to ""
And I set field "abplatzlg" to ""
And I set field "charge" to ""
And I save the current editor

# Serviceprodukt Auftrag erfassen 
Given I open an editor "auftrag-611" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set field "kunde" to id from editor "kunde"
And I set field "nummer" to "611-AU"
And I set field "such" to "FALL-611"
And I create a new row at the end of the table
And I set field "artikel" to id from editor "serartikel-611" in row 1
And I set field "mge" to "1" in row 1
And I set field "serprod" to id from editor "kundeng-611" in row 1
And I set field "verw" to "611" in row 1
And I save the current editor

#Disposition starten
And I run Scheduling

#Fertigungsvorschlaege zu BA freigeben
Given I open the infosystem "PRODLIST"
And I set field "kart" to id from editor "BG-611"
And I press start
And I press button "release" in row 1
And I close the current editor

Given I open the infosystem "PRODLIST"
And I set field "kart" to id from editor "serartikel-611"
And I press start
And I press button "release" in row 1
And I close the current editor

#BAs rueckmelden
Given I open an editor "rueckmelden" from table "(Workorder):(WorkOrders)" with command "DONE" for record "$,,artikel=BG-611;verw=611;typ==(WorkSlips);@maxtreffer=1;@richtung=V;"
And I set field "gut" to "ja"
And I set field "sofort" to "ja"
And I save the current editor

#BAs rueckmelden
Given I open an editor "rueckmelden" from table "(Workorder):(WorkOrders)" with command "DONE" for record "$,,artikel=BG-611;verw=611;typ==(WorkSlips);@maxtreffer=1;@richtung=R;"
And I set field "gut" to "ja"
And I set field "sofort" to "ja"
And I save the current editor

Given I open an editor "rueckmelden" from table "(Workorder):(WorkOrders)" with command "DONE" for record "$,,artikel=FALL-611;verw=611;typ==(WorkSlips);@maxtreffer=1;@richtung=V;"
And I set field "gut" to "ja"
And I set field "sofort" to "ja"
And I save the current editor

Given I open an editor "rueckmelden" from table "(Workorder):(WorkOrders)" with command "DONE" for record "$,,artikel=FALL-611;verw=611;typ==(WorkSlips);@maxtreffer=1;@richtung=R;"
And I set field "gut" to "ja"
And I set field "sofort" to "ja"
And I save the current editor

#Fall 611 - Lieferschein erzeugen und buchen
Given I open an editor "lieferschein-611" from table "(Sales):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "auftrag-611"
And I set field "nummer" to "611-LS"
And I set field "such" to "LS-611"
And I set field "ueb" to "ja"
And I set field "mge" to "1" in row 1
And I save the current editor

# Ausgabe Lieferschein
Given I open an editor "Lieferschein-view" from table "(Sales):(PackingSlip)" with command "VIEW" for record from editor "lieferschein-611"
And I close the current editor

#Fall 611 - Liefershein stornieren
Given I open an editor "lieferschein-storno-611" from table "(Sales):(PackingSlip)" with command "REVERSAL" for record from editor "lieferschein-611"
And I set field "nummer" to "611-SLS"
And I save the current editor

# Ausgabe Storno Lieferschein
Given I open an editor "lieferschein-storno-view" from table "(Sales):(PackingSlip)" with command "VIEW" for record from editor "lieferschein-storno-611"
And I close the current editor

#####################################################################################################################################

Scenario: FALL-612
# FALL-612

# STAMMDATEN - E1 kopieren
Given I open an editor "E1-612" from table "(Part):(Product)" with command "COPY" for record "E1"
And I set field "such" to "E1-612"
And I set field "losgr" to "0"
And I set field "mindest" to "0"
And I save the current editor
# STAMMDATEN - E2 kopieren
Given I open an editor "E2-612" from table "(Part):(Product)" with command "COPY" for record "E2"
And I set field "such" to "E2-612"
And I set field "losgr" to "0"
And I set field "mindest" to "0"
And I save the current editor

# STAMMDATEN - BG1 kopieren
Given I open an editor "BG-612" from table "(Part):(Product)" with command "COPY" for record "BG1"
And I set field "such" to "BG-612"
And I set field "dispoa" to "Auftragsbezogen"
And I set field "mindest" to "0"
And I set field "elex" to "E1-612" in row 1
And I set field "tnwpflicht" to "ja" in row 1
And I save the current editor

# STAMMDATEN - Servicepflichtigen Artikel anlegen
Given I open an editor "serartikel-612" from table "(Part):(Product)" with command "STORE" for record ""
And I set field "such" to "FALL-612"
And I set field "namebspr" to "Service Artikel 612"
And I set field "vkbez" to "Service Artikel 612"
And I set field "vbez" to "Service Artikel 612"
And I set field "ebez" to "Service Artikel 612"
And I set field "vpr" to "1000"
And I set field "bsart" to "Eigenfertigung"
And I set field "dispoa" to "Auftragsbezogen"
And I set field "chimlager" to "ja"
And I set field "serpflicht" to "ja"
#Stückliste anlegen
And I create a new row at the end of the table
And I set field "elex" to "E2-612" in row 1
And I set field "elanzahl" to "2" in row 1
And I set field "tnwpflicht" to "ja" in row 1
And I set field "tersatzt" to "ja" in row 1
And I create a new row at the end of the table
And I set field "elex" to "A AG3" in row 2
And I create a new row at the end of the table
And I set field "elex" to "BG-612" in row 3
And I set field "elanzahl" to "1" in row 3
And I set field "tnwpflicht" to "ja" in row 3
And I set field "tverschlt" to "ja" in row 3
And I create a new row at the end of the table
And I set field "elex" to "A AG4" in row 4
And I save the current editor

# Rechnung anlegen
Given I open an editor "rechnung" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "lief" to "1"
And I set field "num4" to "612-RE"
And I set field "fakt" to "ja"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I create a new row at the end of the table
And I set field "artex" to "E1-612" in row 1
And I set field "mge" to "612" in row 1
And I set field "preis" to "612" in row 1
And I set field "platz" to "F2" in row 1
And I create a new row at the end of the table
And I set field "artex" to "E2-612" in row 2
And I set field "mge" to "612" in row 2
And I set field "preis" to "612" in row 2
And I set field "platz" to "F2" in row 2
And I set field "kenn" to "FALL-612"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Charge anlegen
Given I open an editor "charge" from table "(Lots):(Lots)" with command "STORE" for record "FALL-612"
And I set field "such" to "FALL-612"
And I set field "exnum" to "FALL-612"
And I set field "artikel" to id from editor "serartikel-612"
And I save the current editor

# Serviceprodukt als Kunden- und Leihgeraet anlegen
Given I open an editor "kundeng-612" from table "(ServiceProduct):(ServiceProduct)" with command "STORE" for record "KGSP-612"
And I set field "such" to "KGSP-612"
And I set field "namebspr" to "KGSP-612"
And I set field "artikel" to id from editor "serartikel-612"
And I save the current editor
And I switch the current editor to editor "kundeng-612"
And I set field "serprodtyp" to "Kundengerät"
And I set field "zuplatzlg" to ""
And I set field "abplatzlg" to ""
And I set field "charge" to ""
And I save the current editor

# Serviceprodukt Auftrag erfassen 
Given I open an editor "auftrag-612" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set field "kunde" to id from editor "kunde"
And I set field "nummer" to "612-AU"
And I set field "such" to "FALL-612"
And I create a new row at the end of the table
And I set field "artikel" to id from editor "serartikel-612" in row 1
And I set field "mge" to "1" in row 1
And I set field "serprod" to id from editor "kundeng-612" in row 1
And I set field "verw" to "612" in row 1
And I save the current editor

#Disposition starten
And I run Scheduling

#Fertigungsvorschlaege zu BA freigeben
Given I open the infosystem "PRODLIST"
And I set field "kart" to id from editor "BG-612"
And I press start
And I press button "release" in row 1
And I close the current editor

Given I open the infosystem "PRODLIST"
And I set field "kart" to id from editor "serartikel-612"
And I press start
And I press button "release" in row 1
And I close the current editor

#BAs rueckmelden
Given I open an editor "rueckmelden" from table "(Workorder):(WorkOrders)" with command "DONE" for record "$,,artikel=BG-612;verw=612;typ==(WorkSlips);@maxtreffer=1;@richtung=V;"
And I set field "gut" to "ja"
And I set field "sofort" to "ja"
And I save the current editor

#BAs rueckmelden
Given I open an editor "rueckmelden" from table "(Workorder):(WorkOrders)" with command "DONE" for record "$,,artikel=BG-612;verw=612;typ==(WorkSlips);@maxtreffer=1;@richtung=R;"
And I set field "gut" to "ja"
And I set field "sofort" to "ja"
And I save the current editor

Given I open an editor "rueckmelden" from table "(Workorder):(WorkOrders)" with command "DONE" for record "$,,artikel=FALL-612;verw=612;typ==(WorkSlips);@maxtreffer=1;@richtung=V;"
And I set field "gut" to "ja"
And I set field "sofort" to "ja"
And I save the current editor

Given I open an editor "rueckmelden" from table "(Workorder):(WorkOrders)" with command "DONE" for record "$,,artikel=FALL-612;verw=612;typ==(WorkSlips);@maxtreffer=1;@richtung=R;"
And I set field "gut" to "ja"
And I set field "sofort" to "ja"
And I save the current editor

# Lieferschein erzeugen und buchen
Given I open an editor "lieferschein-612" from table "(Sales):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "auftrag-612"
And I set field "nummer" to "612-LS"
And I set field "such" to "LS-612"
And I set field "ueb" to "ja"
And I set field "mge" to "1" in row 1
And I save the current editor

# Ausgabe Lieferschein
Given I open an editor "Lieferschein-view" from table "(Sales):(PackingSlip)" with command "VIEW" for record from editor "lieferschein-612"
And I close the current editor

# Serviceauftrag erstellen 
Given I open an editor "serauftrag-612" from table "(Sales):(ServiceOrder)" with command "NEW" for record ""
And I set field "kunde" to id from editor "kunde"
And I set field "vserprod" to id from editor "kundeng-612"
And I set field "nummer" to "612-SAU"
And I set field "such" to "SAU-612"
And I create a new row at the end of the table
And I set field "artikel" to id from editor "dienstl" in row 1
And I set field "mge" to "1" in row 1
And I set field "zzvon" to "8" in row 1
And I set field "zzbis" to "12" in row 1
And I create a new row at the end of the table
And I set field "artikel" to "E2-612" in row 2
And I set field "mge" to "1" in row 2
And I save the current editor

# Ausgabe Serviceauftrag
Given I open an editor "Serviceauftrag-view" from table "(Sales):(ServiceOrder)" with command "VIEW" for record from editor "serauftrag-612"
And I close the current editor

#Fall 612, Lieferschein erzeugen und buchen
Given I open an editor "lieferschein-612-2" from table "(Sales):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "serauftrag-612"
And I set field "nummer" to "612-LS2"
And I set field "such" to "LS-612-2"
And I set field "ueb" to "ja"
And I set field "mge" to "1" in row 1
# And I set field "mge" to "1" in row 2
And I save the current editor

# Ausgabe Lieferschein
Given I open an editor "Lieferschein-view" from table "(Sales):(PackingSlip)" with command "VIEW" for record from editor "lieferschein-612-2"
And I close the current editor

# Storno Lieferschein
Given I open an editor "lieferschein-storno-612-2" from table "(Sales):(PackingSlip)" with command "REVERSAL" for record from editor "lieferschein-612-2"
And I set field "num3" to "612-SLS"
And I save the current editor

# Ausgabe Storno Lieferschein
Given I open an editor "lieferschein-view" from table "(Sales):(PackingSlip)" with command "VIEW" for record from editor "lieferschein-storno-612-2"
And I close the current editor

#####################################################################################################################################

Scenario: FALL-613
# FALL-613

# STAMMDATEN - E1 kopieren
Given I open an editor "E1-613" from table "(Part):(Product)" with command "COPY" for record "E1"
And I set field "such" to "E1-613"
And I set field "losgr" to "0"
And I set field "mindest" to "0"
And I save the current editor
# STAMMDATEN - E2 kopieren
Given I open an editor "E2-613" from table "(Part):(Product)" with command "COPY" for record "E2"
And I set field "such" to "E2-613"
And I set field "losgr" to "0"
And I set field "mindest" to "0"
And I save the current editor

# STAMMDATEN - BG1 kopieren
Given I open an editor "BG-613" from table "(Part):(Product)" with command "COPY" for record "BG1"
And I set field "such" to "BG-613"
And I set field "dispoa" to "Auftragsbezogen"
And I set field "mindest" to "0"
And I set field "elex" to "E1-613" in row 1
And I set field "tnwpflicht" to "ja" in row 1
And I save the current editor

# STAMMDATEN - Servicepflichtigen Artikel anlegen
Given I open an editor "serartikel-613" from table "(Part):(Product)" with command "STORE" for record ""
And I set field "such" to "FALL-613"
And I set field "namebspr" to "Service Artikel 613"
And I set field "vkbez" to "Service Artikel 613"
And I set field "vbez" to "Service Artikel 613"
And I set field "ebez" to "Service Artikel 613"
And I set field "vpr" to "1000"
And I set field "bsart" to "Eigenfertigung"
And I set field "dispoa" to "Auftragsbezogen"
And I set field "chimlager" to "ja"
And I set field "serpflicht" to "ja"
#Stückliste anlegen
And I create a new row at the end of the table
And I set field "elex" to "E2-613" in row 1
And I set field "elanzahl" to "2" in row 1
And I set field "tnwpflicht" to "ja" in row 1
And I set field "tersatzt" to "ja" in row 1
And I create a new row at the end of the table
And I set field "elex" to "A AG3" in row 2
And I create a new row at the end of the table
And I set field "elex" to "BG-613" in row 3
And I set field "elanzahl" to "1" in row 3
And I set field "tnwpflicht" to "ja" in row 3
And I set field "tverschlt" to "ja" in row 3
And I create a new row at the end of the table
And I set field "elex" to "A AG4" in row 4
And I save the current editor

# Rechnung anlegen
Given I open an editor "rechnung" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "lief" to "1"
And I set field "num4" to "613-RE"
And I set field "fakt" to "ja"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I create a new row at the end of the table
And I set field "artex" to "E1-613" in row 1
And I set field "mge" to "613" in row 1
And I set field "preis" to "613" in row 1
And I set field "platz" to "F2" in row 1
And I create a new row at the end of the table
And I set field "artex" to "E2-613" in row 2
And I set field "mge" to "613" in row 2
And I set field "preis" to "613" in row 2
And I set field "platz" to "F2" in row 2
And I set field "kenn" to "FALL-613"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Charge anlegen
Given I open an editor "charge" from table "(Lots):(Lots)" with command "STORE" for record "FALL-613"
And I set field "such" to "FALL-613"
And I set field "exnum" to "FALL-613"
And I set field "artikel" to id from editor "serartikel-613"
And I save the current editor

# Serviceprodukt als Kunden- und Leihgeraet anlegen
Given I open an editor "kundeng-613" from table "(ServiceProduct):(ServiceProduct)" with command "STORE" for record "KGSP-613"
And I set field "such" to "KGSP-613"
And I set field "namebspr" to "KGSP-613"
And I set field "artikel" to id from editor "serartikel-613"
And I save the current editor
And I switch the current editor to editor "kundeng-613"
And I set field "serprodtyp" to "Kundengerät"
And I set field "zuplatzlg" to ""
And I set field "abplatzlg" to ""
And I set field "charge" to ""
And I save the current editor

# Serviceprodukt Auftrag erfassen 
Given I open an editor "auftrag-613" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set field "kunde" to id from editor "kunde"
And I set field "nummer" to "613-AU"
And I set field "such" to "FALL-613"
And I create a new row at the end of the table
And I set field "artikel" to id from editor "serartikel-613" in row 1
And I set field "mge" to "1" in row 1
And I set field "serprod" to id from editor "kundeng-613" in row 1
And I set field "verw" to "613" in row 1
And I save the current editor

#Disposition starten
And I run Scheduling

#Fertigungsvorschlaege zu BA freigeben
Given I open the infosystem "PRODLIST"
And I set field "kart" to id from editor "BG-613"
And I press start
And I press button "release" in row 1
And I close the current editor

Given I open the infosystem "PRODLIST"
And I set field "kart" to id from editor "serartikel-613"
And I press start
And I press button "release" in row 1
And I close the current editor

#BAs rueckmelden
Given I open an editor "rueckmelden" from table "(Workorder):(WorkOrders)" with command "DONE" for record "$,,artikel=BG-613;verw=613;typ==(WorkSlips);@maxtreffer=1;@richtung=V;"
And I set field "gut" to "ja"
And I set field "sofort" to "ja"
And I save the current editor

#BAs rueckmelden
Given I open an editor "rueckmelden" from table "(Workorder):(WorkOrders)" with command "DONE" for record "$,,artikel=BG-613;verw=613;typ==(WorkSlips);@maxtreffer=1;@richtung=R;"
And I set field "gut" to "ja"
And I set field "sofort" to "ja"
And I save the current editor

Given I open an editor "rueckmelden" from table "(Workorder):(WorkOrders)" with command "DONE" for record "$,,artikel=FALL-613;verw=613;typ==(WorkSlips);@maxtreffer=1;@richtung=V;"
And I set field "gut" to "ja"
And I set field "sofort" to "ja"
And I save the current editor

Given I open an editor "rueckmelden" from table "(Workorder):(WorkOrders)" with command "DONE" for record "$,,artikel=FALL-613;verw=613;typ==(WorkSlips);@maxtreffer=1;@richtung=R;"
And I set field "gut" to "ja"
And I set field "sofort" to "ja"
And I save the current editor

# Lieferschein erzeugen und buchen
Given I open an editor "lieferschein-613" from table "(Sales):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "auftrag-613"
And I set field "nummer" to "613-LS"
And I set field "such" to "LS-613"
And I set field "ueb" to "ja"
And I set field "mge" to "1" in row 1
And I save the current editor

# Ausgabe Lieferschein
Given I open an editor "Lieferschein-view" from table "(Sales):(PackingSlip)" with command "VIEW" for record from editor "lieferschein-613"
And I close the current editor

# Serviceauftrag erstellen 
Given I open an editor "serauftrag-613" from table "(Sales):(ServiceOrder)" with command "NEW" for record ""
And I set field "kunde" to id from editor "kunde"
And I set field "vserprod" to id from editor "kundeng-613"
And I set field "nummer" to "613-SAU"
And I set field "such" to "SAU-613"
And I create a new row at the end of the table
And I set field "artikel" to id from editor "dienstl" in row 1
And I set field "mge" to "1" in row 1
And I set field "zzvon" to "8" in row 1
And I set field "zzbis" to "12" in row 1
And I create a new row at the end of the table
And I set field "artikel" to "E2-613" in row 2
And I set field "mge" to "1" in row 2
And I save the current editor

# Ausgabe Serviceauftrag
Given I open an editor "Serviceauftrag-view" from table "(Sales):(ServiceOrder)" with command "VIEW" for record from editor "serauftrag-613"
And I close the current editor

#Fall 613 - Lieferschein erzeugen und buchen
Given I open an editor "lieferschein-613-2" from table "(Sales):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "serauftrag-613"
And I set field "nummer" to "613-LS2"
And I set field "such" to "LS-613-2"
And I set field "ueb" to "ja"
# And I set field "mge" to "1" in row 1
And I set field "mge" to "1" in row 2
And I save the current editor

# Ausgabe Lieferschein
Given I open an editor "Lieferschein-view" from table "(Sales):(PackingSlip)" with command "VIEW" for record from editor "lieferschein-613-2"
And I close the current editor

# Storno Lieferschein
Given I open an editor "lieferschein-storno-613-2" from table "(Sales):(PackingSlip)" with command "REVERSAL" for record from editor "lieferschein-613-2"
And I set field "num3" to "613-SLS"
And I save the current editor

# Ausgabe Storno Lieferschein
Given I open an editor "lieferschein-view" from table "(Sales):(PackingSlip)" with command "VIEW" for record from editor "lieferschein-storno-613-2"
And I close the current editor

#####################################################################################################################################

Scenario: FALL-614
# FALL-614

# STAMMDATEN - E1 kopieren
Given I open an editor "E1-614" from table "(Part):(Product)" with command "COPY" for record "E1"
And I set field "such" to "E1-614"
And I set field "losgr" to "0"
And I set field "mindest" to "0"
And I save the current editor
# STAMMDATEN - E2 kopieren
Given I open an editor "E2-614" from table "(Part):(Product)" with command "COPY" for record "E2"
And I set field "such" to "E2-614"
And I set field "losgr" to "0"
And I set field "mindest" to "0"
And I save the current editor

# STAMMDATEN - BG1 kopieren
Given I open an editor "BG-614" from table "(Part):(Product)" with command "COPY" for record "BG1"
And I set field "such" to "BG-614"
And I set field "dispoa" to "Auftragsbezogen"
And I set field "mindest" to "0"
And I set field "elex" to "E1-614" in row 1
And I set field "tnwpflicht" to "ja" in row 1
And I save the current editor

# STAMMDATEN - Servicepflichtigen Artikel anlegen
Given I open an editor "serartikel-614" from table "(Part):(Product)" with command "STORE" for record ""
And I set field "such" to "FALL-614"
And I set field "namebspr" to "Service Artikel 614"
And I set field "vkbez" to "Service Artikel 614"
And I set field "vbez" to "Service Artikel 614"
And I set field "ebez" to "Service Artikel 614"
And I set field "vpr" to "1000"
And I set field "bsart" to "Eigenfertigung"
And I set field "dispoa" to "Auftragsbezogen"
And I set field "chimlager" to "ja"
And I set field "serpflicht" to "ja"
#Stückliste anlegen
And I create a new row at the end of the table
And I set field "elex" to "E2-614" in row 1
And I set field "elanzahl" to "2" in row 1
And I set field "tnwpflicht" to "ja" in row 1
And I set field "tersatzt" to "ja" in row 1
And I create a new row at the end of the table
And I set field "elex" to "A AG3" in row 2
And I create a new row at the end of the table
And I set field "elex" to "BG-614" in row 3
And I set field "elanzahl" to "1" in row 3
And I set field "tnwpflicht" to "ja" in row 3
And I set field "tverschlt" to "ja" in row 3
And I create a new row at the end of the table
And I set field "elex" to "A AG4" in row 4
And I save the current editor

# Rechnung anlegen
Given I open an editor "rechnung" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "lief" to "1"
And I set field "num4" to "614-RE"
And I set field "fakt" to "ja"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I create a new row at the end of the table
And I set field "artex" to "E1-614" in row 1
And I set field "mge" to "614" in row 1
And I set field "preis" to "614" in row 1
And I set field "platz" to "F2" in row 1
And I create a new row at the end of the table
And I set field "artex" to "E2-614" in row 2
And I set field "mge" to "614" in row 2
And I set field "preis" to "614" in row 2
And I set field "platz" to "F2" in row 2
And I set field "kenn" to "FALL-614"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Charge anlegen
Given I open an editor "charge" from table "(Lots):(Lots)" with command "STORE" for record "FALL-614"
And I set field "such" to "FALL-614"
And I set field "exnum" to "FALL-614"
And I set field "artikel" to id from editor "serartikel-614"
And I save the current editor

# Serviceprodukt als Kunden- und Leihgeraet anlegen
Given I open an editor "kundeng-614" from table "(ServiceProduct):(ServiceProduct)" with command "STORE" for record "KGSP-614"
And I set field "such" to "KGSP-614"
And I set field "namebspr" to "KGSP-614"
And I set field "artikel" to id from editor "serartikel-614"
And I save the current editor
And I switch the current editor to editor "kundeng-614"
And I set field "serprodtyp" to "Kundengerät"
And I set field "zuplatzlg" to ""
And I set field "abplatzlg" to ""
And I set field "charge" to ""
And I save the current editor

# Leihgeraet anlegen
Given I open an editor "leihgeraet-614" from table "(ServiceProduct):(ServiceProduct)" with command "STORE" for record "LHSP-614"
And I set field "such" to "LHSP-614"
And I set field "namebspr" to "Leihgeraet 614"
And I set field "artikel" to id from editor "serartikel-614"
And I save the current editor
And I switch the current editor to editor "leihgeraet-614"
And I set field "serprodtyp" to "Leihgeraet"
And I set field "zuplatzlg" to "F4"
And I set field "abplatzlg" to "F4"
And I set field "charge" to "FALL-614"
And I save the current editor

# Leihgeraet fertigen und aus Lager legen
Given I open an editor "fvanlegen" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
And I create a new row at the end of the table
And I set field "artikel" to id from editor "serartikel-614" in row 1
And I set field "mge" to "1" in row 1
And I set field "bisuch" to "LEIHBA" in row 1
And I set field "serprod" to id from editor "leihgeraet-614" in row 1
And I set field "platz" to "F4" in row 1
And I set field "mfreig" to "ja" in row 1
And I press button "freig" to open a subeditor for "fertigung"
And I close the current editor
And I switch the current editor to editor "fvanlegen"
And I close the current editor

#BA fuer Leihgeraet rueckmelden
Given I open an editor "rueckmelden" from table "(Workorder):(WorkOrders)" with command "DONE" for record "LEIHBA000"
And I set field "gut" to "ja"
And I set field "sofort" to "ja"
And I set field "mgr" to "101"
And I save the current editor

# Reparaturauftrag anlegen 
Given I open an editor "repauftrag-614" from table "(Sales):(RepairOrder)" with command "NEW" for record ""
And I set field "kunde" to id from editor "kunde"
And I set field "nummer" to "614-AU"
And I set field "such" to "AU-614"
And I create a new row at the end of the table
And I set field "serprod" to id from editor "kundeng-614" in row 1
Then the table has 2 rows
And I save the current editor

# Ausgabe Reparaturauftrag
Given I open an editor "Auftrag-view" from table "(Sales):(RepairOrder)" with command "VIEW" for record from editor "repauftrag-614"
And I close the current editor

# Zugang Kundengeraet
Given I open an editor "repauftrag-614-2" from table "(Sales):(RepairOrder)" with command "UPDATE" for record from editor "repauftrag-614"
And I press button "repzug" to open a subeditor for "zugangsls-614"
And I set field "nummer" to "614-LS1"
And I set field "such" to "LS-614-1"
And I set field "ueb" to "ja"
And I save the current editor
And I switch the current editor to editor "repauftrag-614-2"
And I save the current editor

#Fall 605, 606 - Reparaturauftrag erweitern (Dienstleistung, Kostenvoranschlag)
Given I open an editor "repauftrag-614-3" from table "(Sales):(RepairOrder)" with command "UPDATE" for record from editor "repauftrag-614"
And I set field "bem" to "Jetzt die Reparatur"
And I create a new row at the end of the table
And I set field "artikel" to id from editor "hdienstl" in row 3
And I set field "serprod" to id from editor "kundeng-614" in row 3 
And I set field "mge" to "2" in row 3
#Stueckliste für die Reparatur anlegen
And I press button "absteig" to open a subeditor for "reparatur" in row 3
And I create a new row at the end of the table
And I set field "elex" to "BG-614" in row 1
And I set field "elanzahl" to "1" in row 1
And I create a new row at the end of the table
And I set field "elex" to "A AG2" in row 2
And I save the current editor
And I switch the current editor to editor "repauftrag-614-3"
And I press button "kostenvorb" to open a subeditor for "kvb"
And I set field "nummer" to "614-KV"
And I set field "such" to "KV-614"
And I set field "bem" to "Kostenvoranschlag 614"
Then the table has 1 rows
And I save the current editor
And I switch the current editor to editor "repauftrag-614-3"
And I save the current editor

#Fall 605, 606 - Disposition starten
And I run Scheduling

# FixMe die BG-614 muess hier noch gefertigt werden.

#Fall 605, 606 - Fertigungsvorschlag fuer Dienstleistung freigeben
Given I open an editor "fvanlegen" from table "(Purchasing):(WorkOrderSuggestions)" with command "UPDATE" for record ""
And I set field "artikel" to id from editor "hdienstl"
And I press button "ladetab"
Then the table has 1 rows
And I set field "bisuch" to "REPBA-614" in row 1
And I set field "mfreig" to "ja" in row 1
And I press button "freig" to open a subeditor for "fertigung"
And I close the current editor
And I switch the current editor to editor "fvanlegen"
And I close the current editor

#Fall 605, 606 - Materialentnahme für Dienstleistung durchfuehren
Given I open an editor "Materialentnahme" for tip command "(WOIssue)" and arguments ""
And I set field "auftrag" to "$,,such=REPBA-614000;@richtung=rückwärts;@maxtreffer=1"
And I set field "autorment" to "ja"
And I set field "mgr" to "101"
And I press button "stllad"
And I set field "serstlsts" to "wird aktualisiert" in row 1
And I save the current editor

#Fall 605, 606 - Dienstleistung rueckmelden
Given I open an editor "rueckmelden" from table "(Workorder):(WorkOrders)" with command "DONE" for record "REPBA-614000"
And I set field "gut" to "ja"
And I set field "sofort" to "ja"
And I set field "mgr" to "101"
And I save the current editor

# #Fall 605, 606 - Rechnung erstellen und Lieferschein buchen
Given I open an editor "repauftrag-614-4" from table "(Sales):(RepairOrder)" with command "UPDATE" for record from editor "repauftrag-614"
And I press button "reanlegen" to open a subeditor for "rechnung"
And I set field "ueb" to "ja"
And I set field "nummer" to "614-RE"
And I set field "such" to "RE-614"
And I press button "offueb" in row 1
# And I press button "offueb" in row 2
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor
And I switch the current editor to editor "repauftrag-614-4"
And I press button "repabg" to open a subeditor for "lieferschein-614-2"
And I set field "nummer" to "614-LS3"
And I set field "such" to "LS-614-3"
And I set field "ueb" to "ja"
And I save the current editor
And I switch the current editor to editor "repauftrag-614-4"
And I save the current editor

# Ausgabe Lieferschein
Given I open an editor "Lieferschein-view" from table "(Sales):(PackingSlip)" with command "VIEW" for record from editor "lieferschein-614-2"
And I close the current editor

# Storno Lieferschein
Given I open an editor "lieferschein-614" from table "(Sales):(PackingSlip)" with command "REVERSAL" for record from editor "lieferschein-614-2"
And I set field "num3" to "614-SLS"
And I save the current editor

# Ausgabe Storno Lieferschein
Given I open an editor "lieferschein-view" from table "(Sales):(PackingSlip)" with command "VIEW" for record "+614-SLS"
And I close the current editor

#####################################################################################################################################

Scenario: FALL-615
# FALL-615

# STAMMDATEN - E1 kopieren
Given I open an editor "E1-615" from table "(Part):(Product)" with command "COPY" for record "E1"
And I set field "such" to "E1-615"
And I set field "losgr" to "0"
And I set field "mindest" to "0"
And I save the current editor
# STAMMDATEN - E2 kopieren
Given I open an editor "E2-615" from table "(Part):(Product)" with command "COPY" for record "E2"
And I set field "such" to "E2-615"
And I set field "losgr" to "0"
And I set field "mindest" to "0"
And I save the current editor

# STAMMDATEN - BG1 kopieren
Given I open an editor "BG-615" from table "(Part):(Product)" with command "COPY" for record "BG1"
And I set field "such" to "BG-615"
And I set field "dispoa" to "Auftragsbezogen"
And I set field "mindest" to "0"
And I set field "elex" to "E1-615" in row 1
And I set field "tnwpflicht" to "ja" in row 1
And I save the current editor

# STAMMDATEN - Servicepflichtigen Artikel anlegen
Given I open an editor "serartikel-615" from table "(Part):(Product)" with command "STORE" for record ""
And I set field "such" to "FALL-615"
And I set field "namebspr" to "Service Artikel 615"
And I set field "vkbez" to "Service Artikel 615"
And I set field "vbez" to "Service Artikel 615"
And I set field "ebez" to "Service Artikel 615"
And I set field "vpr" to "1000"
And I set field "bsart" to "Eigenfertigung"
And I set field "dispoa" to "Auftragsbezogen"
And I set field "chimlager" to "ja"
And I set field "serpflicht" to "ja"
#Stückliste anlegen
And I create a new row at the end of the table
And I set field "elex" to "E2-615" in row 1
And I set field "elanzahl" to "2" in row 1
And I set field "tnwpflicht" to "ja" in row 1
And I set field "tersatzt" to "ja" in row 1
And I create a new row at the end of the table
And I set field "elex" to "A AG3" in row 2
And I create a new row at the end of the table
And I set field "elex" to "BG-615" in row 3
And I set field "elanzahl" to "1" in row 3
And I set field "tnwpflicht" to "ja" in row 3
And I set field "tverschlt" to "ja" in row 3
And I create a new row at the end of the table
And I set field "elex" to "A AG4" in row 4
And I save the current editor

# Rechnung anlegen
Given I open an editor "rechnung" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "lief" to "1"
And I set field "num4" to "615-RE"
And I set field "fakt" to "ja"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I create a new row at the end of the table
And I set field "artex" to "E1-615" in row 1
And I set field "mge" to "615" in row 1
And I set field "preis" to "615" in row 1
And I set field "platz" to "F2" in row 1
And I create a new row at the end of the table
And I set field "artex" to "E2-615" in row 2
And I set field "mge" to "615" in row 2
And I set field "preis" to "615" in row 2
And I set field "platz" to "F2" in row 2
And I set field "kenn" to "FALL-615"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Charge anlegen
Given I open an editor "charge" from table "(Lots):(Lots)" with command "STORE" for record "FALL-615"
And I set field "such" to "FALL-615"
And I set field "exnum" to "FALL-615"
And I set field "artikel" to id from editor "serartikel-615"
And I save the current editor

# Serviceprodukt als Kunden- und Leihgeraet anlegen
Given I open an editor "kundeng-615" from table "(ServiceProduct):(ServiceProduct)" with command "STORE" for record "KGSP-615"
And I set field "such" to "KGSP-615"
And I set field "namebspr" to "KGSP-615"
And I set field "artikel" to id from editor "serartikel-615"
And I save the current editor
And I switch the current editor to editor "kundeng-615"
And I set field "serprodtyp" to "Kundengerät"
And I set field "zuplatzlg" to ""
And I set field "abplatzlg" to ""
And I set field "charge" to ""
And I save the current editor

# Leihgeraet anlegen
Given I open an editor "leihgeraet-615" from table "(ServiceProduct):(ServiceProduct)" with command "STORE" for record "LHSP-615"
And I set field "such" to "LHSP-615"
And I set field "namebspr" to "Leihgeraet 615"
And I set field "artikel" to id from editor "serartikel-615"
And I save the current editor
And I switch the current editor to editor "leihgeraet-615"
And I set field "serprodtyp" to "Leihgeraet"
And I set field "zuplatzlg" to "F4"
And I set field "abplatzlg" to "F4"
And I set field "charge" to "FALL-615"
And I save the current editor

# Leihgeraet fertigen und aus Lager legen
Given I open an editor "fvanlegen" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
And I create a new row at the end of the table
And I set field "artikel" to id from editor "serartikel-615" in row 1
And I set field "mge" to "1" in row 1
And I set field "bisuch" to "LEIHBA" in row 1
And I set field "serprod" to id from editor "leihgeraet-615" in row 1
And I set field "platz" to "F4" in row 1
And I set field "mfreig" to "ja" in row 1
And I press button "freig" to open a subeditor for "fertigung"
And I close the current editor
And I switch the current editor to editor "fvanlegen"
And I close the current editor

#BA fuer Leihgeraet rueckmelden
Given I open an editor "rueckmelden" from table "(Workorder):(WorkOrders)" with command "DONE" for record "LEIHBA000"
And I set field "gut" to "ja"
And I set field "sofort" to "ja"
And I set field "mgr" to "101"
And I save the current editor

# Reparaturauftrag anlegen 
Given I open an editor "repauftrag-615" from table "(Sales):(RepairOrder)" with command "NEW" for record ""
And I set field "kunde" to id from editor "kunde"
And I set field "nummer" to "615-AU"
And I set field "such" to "AU-615"
And I create a new row at the end of the table
And I set field "serprod" to id from editor "kundeng-615" in row 1
Then the table has 2 rows
And I save the current editor

# Ausgabe Reparaturauftrag
Given I open an editor "Auftrag-view" from table "(Sales):(RepairOrder)" with command "VIEW" for record from editor "repauftrag-615"
And I close the current editor

Given I open an editor "repauftrag-615-2" from table "(Sales):(RepairOrder)" with command "UPDATE" for record from editor "repauftrag-615"
And I press button "repabgl" to open a subeditor for "abgangsls-615"
And I set field "nummer" to "615-LS"
And I set field "such" to "LS-615"
And I set field "ueb" to "ja"
And I set field "umplatz" to "extern"
And I save the current editor
And I switch the current editor to editor "repauftrag-615-2"
And I save the current editor

# Ausgabe Lieferschein
Given I open an editor "Lieferschein-view" from table "(Sales):(PackingSlip)" with command "VIEW" for record from editor "abgangsls-615"
And I close the current editor

# Storno Lieferschein
Given I open an editor "lieferschein-615" from table "(Sales):(PackingSlip)" with command "REVERSAL" for record from editor "abgangsls-615"
And I set field "num3" to "615-SLS"
And I save the current editor

# Ausgabe Storno Lieferschein
Given I open an editor "lieferschein-view" from table "(Sales):(PackingSlip)" with command "VIEW" for record "+615-SLS"
And I close the current editor

#####################################################################################################################################

Scenario: FALL-616
# FALL-616

# STAMMDATEN - E1 kopieren
Given I open an editor "E1-616" from table "(Part):(Product)" with command "COPY" for record "E1"
And I set field "such" to "E1-616"
And I set field "losgr" to "0"
And I set field "mindest" to "0"
And I save the current editor
# STAMMDATEN - E2 kopieren
Given I open an editor "E2-616" from table "(Part):(Product)" with command "COPY" for record "E2"
And I set field "such" to "E2-616"
And I set field "losgr" to "0"
And I set field "mindest" to "0"
And I save the current editor

# STAMMDATEN - BG1 kopieren
Given I open an editor "BG-616" from table "(Part):(Product)" with command "COPY" for record "BG1"
And I set field "such" to "BG-616"
And I set field "dispoa" to "Auftragsbezogen"
And I set field "mindest" to "0"
And I set field "elex" to "E1-616" in row 1
And I set field "tnwpflicht" to "ja" in row 1
And I save the current editor

# STAMMDATEN - Servicepflichtigen Artikel anlegen
Given I open an editor "serartikel-616" from table "(Part):(Product)" with command "STORE" for record ""
And I set field "such" to "FALL-616"
And I set field "namebspr" to "Service Artikel 616"
And I set field "vkbez" to "Service Artikel 616"
And I set field "vbez" to "Service Artikel 616"
And I set field "ebez" to "Service Artikel 616"
And I set field "vpr" to "1000"
And I set field "bsart" to "Eigenfertigung"
And I set field "dispoa" to "Auftragsbezogen"
And I set field "chimlager" to "ja"
And I set field "serpflicht" to "ja"
#Stückliste anlegen
And I create a new row at the end of the table
And I set field "elex" to "E2-616" in row 1
And I set field "elanzahl" to "2" in row 1
And I set field "tnwpflicht" to "ja" in row 1
And I set field "tersatzt" to "ja" in row 1
And I create a new row at the end of the table
And I set field "elex" to "A AG3" in row 2
And I create a new row at the end of the table
And I set field "elex" to "BG-616" in row 3
And I set field "elanzahl" to "1" in row 3
And I set field "tnwpflicht" to "ja" in row 3
And I set field "tverschlt" to "ja" in row 3
And I create a new row at the end of the table
And I set field "elex" to "A AG4" in row 4
And I save the current editor

# Rechnung anlegen
Given I open an editor "rechnung" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "lief" to "1"
And I set field "num4" to "616-RE"
And I set field "fakt" to "ja"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I create a new row at the end of the table
And I set field "artex" to "E1-616" in row 1
And I set field "mge" to "616" in row 1
And I set field "preis" to "616" in row 1
And I set field "platz" to "F2" in row 1
And I create a new row at the end of the table
And I set field "artex" to "E2-616" in row 2
And I set field "mge" to "616" in row 2
And I set field "preis" to "616" in row 2
And I set field "platz" to "F2" in row 2
And I set field "kenn" to "FALL-616"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Charge anlegen
Given I open an editor "charge" from table "(Lots):(Lots)" with command "STORE" for record "FALL-616"
And I set field "such" to "FALL-616"
And I set field "exnum" to "FALL-616"
And I set field "artikel" to id from editor "serartikel-616"
And I save the current editor

# Serviceprodukt als Kunden- und Leihgeraet anlegen
Given I open an editor "kundeng-616" from table "(ServiceProduct):(ServiceProduct)" with command "STORE" for record "KGSP-616"
And I set field "such" to "KGSP-616"
And I set field "namebspr" to "KGSP-616"
And I set field "artikel" to id from editor "serartikel-616"
And I save the current editor
And I switch the current editor to editor "kundeng-616"
And I set field "serprodtyp" to "Kundengerät"
And I set field "zuplatzlg" to ""
And I set field "abplatzlg" to ""
And I set field "charge" to ""
And I save the current editor

# Serviceprodukt Auftrag erfassen 
Given I open an editor "auftrag-616" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set field "kunde" to id from editor "kunde"
And I set field "nummer" to "616-AU"
And I set field "such" to "FALL-616"
And I create a new row at the end of the table
And I set field "artikel" to id from editor "serartikel-616" in row 1
And I set field "mge" to "1" in row 1
And I set field "serprod" to id from editor "kundeng-616" in row 1
And I set field "verw" to "616" in row 1
And I save the current editor

#Disposition starten
And I run Scheduling

#Fertigungsvorschlaege zu BA freigeben
Given I open the infosystem "PRODLIST"
And I set field "kart" to id from editor "BG-616"
And I press start
And I press button "release" in row 1
And I close the current editor

Given I open the infosystem "PRODLIST"
And I set field "kart" to id from editor "serartikel-616"
And I press start
And I press button "release" in row 1
And I close the current editor

#BAs rueckmelden
Given I open an editor "rueckmelden" from table "(Workorder):(WorkOrders)" with command "DONE" for record "$,,artikel=BG-616;verw=616;typ==(WorkSlips);@maxtreffer=1;@richtung=V;"
And I set field "gut" to "ja"
And I set field "sofort" to "ja"
And I save the current editor

#BAs rueckmelden
Given I open an editor "rueckmelden" from table "(Workorder):(WorkOrders)" with command "DONE" for record "$,,artikel=BG-616;verw=616;typ==(WorkSlips);@maxtreffer=1;@richtung=R;"
And I set field "gut" to "ja"
And I set field "sofort" to "ja"
And I save the current editor

Given I open an editor "rueckmelden" from table "(Workorder):(WorkOrders)" with command "DONE" for record "$,,artikel=FALL-616;verw=616;typ==(WorkSlips);@maxtreffer=1;@richtung=V;"
And I set field "gut" to "ja"
And I set field "sofort" to "ja"
And I save the current editor

Given I open an editor "rueckmelden" from table "(Workorder):(WorkOrders)" with command "DONE" for record "$,,artikel=FALL-616;verw=616;typ==(WorkSlips);@maxtreffer=1;@richtung=R;"
And I set field "gut" to "ja"
And I set field "sofort" to "ja"
And I save the current editor

#Fall 616 - Lieferschein erzeugen und buchen
Given I open an editor "lieferschein-616" from table "(Sales):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "auftrag-616"
And I set field "nummer" to "616-LS"
And I set field "such" to "LS-616"
And I set field "ueb" to "ja"
And I set field "mge" to "1" in row 1
And I save the current editor

# Ausgabe Lieferschein
Given I open an editor "Lieferschein-view" from table "(Sales):(PackingSlip)" with command "VIEW" for record from editor "lieferschein-616"
And I close the current editor

#Fall 616 - Rechnung erzeugen
Given I open an editor "rechnung-616" from table "(Sales):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "lieferschein-616"
And I set field "nummer" to "616-RE"
And I set field "such" to "FALL-616"
And I set field "ueb" to "ja"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Ausgabe Rechnung
Given I open an editor "Rechnung-view" from table "(Sales):(Invoice)" with command "VIEW" for record from editor "rechnung-616"
And I close the current editor

#Fall 616 - Rechnung stornieren
Given I open an editor "st-rechnung-616" from table "(Sales):(Invoice)" with command "REVERSAL" for record from editor "rechnung-616"
And I set field "nummer" to "616-SRE"
And I save the current editor

# Ausgabe Storno Rechnung
Given I open an editor "Rechnung-storno-view" from table "(Sales):(Invoice)" with command "VIEW" for record from editor "st-rechnung-616"
And I close the current editor

#####################################################################################################################################

Scenario: FALL-617
# FALL-617

# STAMMDATEN - E1 kopieren
Given I open an editor "E1-617" from table "(Part):(Product)" with command "COPY" for record "E1"
And I set field "such" to "E1-617"
And I set field "losgr" to "0"
And I set field "mindest" to "0"
And I save the current editor
# STAMMDATEN - E2 kopieren
Given I open an editor "E2-617" from table "(Part):(Product)" with command "COPY" for record "E2"
And I set field "such" to "E2-617"
And I set field "losgr" to "0"
And I set field "mindest" to "0"
And I save the current editor

# STAMMDATEN - BG1 kopieren
Given I open an editor "BG-617" from table "(Part):(Product)" with command "COPY" for record "BG1"
And I set field "such" to "BG-617"
And I set field "dispoa" to "Auftragsbezogen"
And I set field "mindest" to "0"
And I set field "elex" to "E1-617" in row 1
And I set field "tnwpflicht" to "ja" in row 1
And I save the current editor

# STAMMDATEN - Servicepflichtigen Artikel anlegen
Given I open an editor "serartikel-617" from table "(Part):(Product)" with command "STORE" for record ""
And I set field "such" to "FALL-617"
And I set field "namebspr" to "Service Artikel 617"
And I set field "vkbez" to "Service Artikel 617"
And I set field "vbez" to "Service Artikel 617"
And I set field "ebez" to "Service Artikel 617"
And I set field "vpr" to "1000"
And I set field "bsart" to "Eigenfertigung"
And I set field "dispoa" to "Auftragsbezogen"
And I set field "chimlager" to "ja"
And I set field "serpflicht" to "ja"
#Stückliste anlegen
And I create a new row at the end of the table
And I set field "elex" to "E2-617" in row 1
And I set field "elanzahl" to "2" in row 1
And I set field "tnwpflicht" to "ja" in row 1
And I set field "tersatzt" to "ja" in row 1
And I create a new row at the end of the table
And I set field "elex" to "A AG3" in row 2
And I create a new row at the end of the table
And I set field "elex" to "BG-617" in row 3
And I set field "elanzahl" to "1" in row 3
And I set field "tnwpflicht" to "ja" in row 3
And I set field "tverschlt" to "ja" in row 3
And I create a new row at the end of the table
And I set field "elex" to "A AG4" in row 4
And I save the current editor

# Rechnung anlegen
Given I open an editor "rechnung" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "lief" to "1"
And I set field "num4" to "617-RE"
And I set field "fakt" to "ja"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I create a new row at the end of the table
And I set field "artex" to "E1-617" in row 1
And I set field "mge" to "617" in row 1
And I set field "preis" to "617" in row 1
And I set field "platz" to "F2" in row 1
And I create a new row at the end of the table
And I set field "artex" to "E2-617" in row 2
And I set field "mge" to "617" in row 2
And I set field "preis" to "617" in row 2
And I set field "platz" to "F2" in row 2
And I set field "kenn" to "FALL-617"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Charge anlegen
Given I open an editor "charge" from table "(Lots):(Lots)" with command "STORE" for record "FALL-617"
And I set field "such" to "FALL-617"
And I set field "exnum" to "FALL-617"
And I set field "artikel" to id from editor "serartikel-617"
And I save the current editor

# Serviceprodukt als Kunden- und Leihgeraet anlegen
Given I open an editor "kundeng-617" from table "(ServiceProduct):(ServiceProduct)" with command "STORE" for record "KGSP-617"
And I set field "such" to "KGSP-617"
And I set field "namebspr" to "KGSP-617"
And I set field "artikel" to id from editor "serartikel-617"
And I save the current editor
And I switch the current editor to editor "kundeng-617"
And I set field "serprodtyp" to "Kundengerät"
And I set field "zuplatzlg" to ""
And I set field "abplatzlg" to ""
And I set field "charge" to ""
And I save the current editor

# Serviceprodukt Auftrag erfassen 
Given I open an editor "auftrag-617" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set field "kunde" to id from editor "kunde"
And I set field "nummer" to "617-AU"
And I set field "such" to "FALL-617"
And I create a new row at the end of the table
And I set field "artikel" to id from editor "serartikel-617" in row 1
And I set field "mge" to "1" in row 1
And I set field "serprod" to id from editor "kundeng-617" in row 1
And I set field "verw" to "617" in row 1
And I save the current editor

#Disposition starten
And I run Scheduling

#Fertigungsvorschlaege zu BA freigeben
Given I open the infosystem "PRODLIST"
And I set field "kart" to id from editor "BG-617"
And I press start
And I press button "release" in row 1
And I close the current editor

Given I open the infosystem "PRODLIST"
And I set field "kart" to id from editor "serartikel-617"
And I press start
And I press button "release" in row 1
And I close the current editor

#BAs rueckmelden
Given I open an editor "rueckmelden" from table "(Workorder):(WorkOrders)" with command "DONE" for record "$,,artikel=BG-617;verw=617;typ==(WorkSlips);@maxtreffer=1;@richtung=V;"
And I set field "gut" to "ja"
And I set field "sofort" to "ja"
And I save the current editor

#BAs rueckmelden
Given I open an editor "rueckmelden" from table "(Workorder):(WorkOrders)" with command "DONE" for record "$,,artikel=BG-617;verw=617;typ==(WorkSlips);@maxtreffer=1;@richtung=R;"
And I set field "gut" to "ja"
And I set field "sofort" to "ja"
And I save the current editor

Given I open an editor "rueckmelden" from table "(Workorder):(WorkOrders)" with command "DONE" for record "$,,artikel=FALL-617;verw=617;typ==(WorkSlips);@maxtreffer=1;@richtung=V;"
And I set field "gut" to "ja"
And I set field "sofort" to "ja"
And I save the current editor

Given I open an editor "rueckmelden" from table "(Workorder):(WorkOrders)" with command "DONE" for record "$,,artikel=FALL-617;verw=617;typ==(WorkSlips);@maxtreffer=1;@richtung=R;"
And I set field "gut" to "ja"
And I set field "sofort" to "ja"
And I save the current editor

# Lieferschein erzeugen und buchen
Given I open an editor "lieferschein-617" from table "(Sales):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "auftrag-617"
And I set field "nummer" to "617-LS"
And I set field "such" to "LS-617"
And I set field "ueb" to "ja"
And I set field "mge" to "1" in row 1
And I save the current editor

# Ausgabe Lieferschein
Given I open an editor "Lieferschein-view" from table "(Sales):(PackingSlip)" with command "VIEW" for record from editor "lieferschein-617"
And I close the current editor

# Serviceauftrag erstellen 
Given I open an editor "serauftrag-617" from table "(Sales):(ServiceOrder)" with command "NEW" for record ""
And I set field "kunde" to id from editor "kunde"
And I set field "vserprod" to id from editor "kundeng-617"
And I set field "nummer" to "617-SAU"
And I set field "such" to "SAU-617"
And I create a new row at the end of the table
And I set field "artikel" to id from editor "dienstl" in row 1
And I set field "mge" to "1" in row 1
And I set field "zzvon" to "8" in row 1
And I set field "zzbis" to "12" in row 1
And I create a new row at the end of the table
And I set field "artikel" to "E2-617" in row 2
And I set field "mge" to "1" in row 2
And I save the current editor

# Ausgabe Serviceauftrag
Given I open an editor "Serviceauftrag-view" from table "(Sales):(ServiceOrder)" with command "VIEW" for record from editor "serauftrag-617"
And I close the current editor

#Fall 617, Lieferschein erzeugen und buchen
Given I open an editor "lieferschein-617-2" from table "(Sales):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "serauftrag-617"
And I set field "nummer" to "617-LS2"
And I set field "such" to "LS-617-2"
And I set field "ueb" to "ja"
And I set field "mge" to "1" in row 1
# And I set field "mge" to "1" in row 2
And I save the current editor

# Ausgabe Lieferschein
Given I open an editor "Lieferschein-view" from table "(Sales):(PackingSlip)" with command "VIEW" for record from editor "lieferschein-617-2"
And I close the current editor

#Fall 617 - Rechnung erzeugen
Given I open an editor "rechnung-617-2" from table "(Sales):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "lieferschein-617-2"
And I set field "nummer" to "617-RE-2"
And I set field "such" to "FALL-617"
And I set field "ueb" to "ja"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Ausgabe Rechnung
Given I open an editor "Rechnung-view" from table "(Sales):(Invoice)" with command "VIEW" for record from editor "rechnung-617-2"
And I close the current editor

# Storno Rechnung
Given I open an editor "rechnung-storno-617" from table "(Sales):(Invoice)" with command "REVERSAL" for record from editor "rechnung-617-2"
And I set field "num3" to "617-SRE"
And I save the current editor

# Ausgabe Storno Rechnung
Given I open an editor "rechnung-storno-view" from table "(Sales):(Invoice)" with command "VIEW" for record from editor "rechnung-storno-617"
And I close the current editor

#####################################################################################################################################

Scenario: FALL-618
# FALL-618

# STAMMDATEN - E1 kopieren
Given I open an editor "E1-618" from table "(Part):(Product)" with command "COPY" for record "E1"
And I set field "such" to "E1-618"
And I set field "losgr" to "0"
And I set field "mindest" to "0"
And I save the current editor
# STAMMDATEN - E2 kopieren
Given I open an editor "E2-618" from table "(Part):(Product)" with command "COPY" for record "E2"
And I set field "such" to "E2-618"
And I set field "losgr" to "0"
And I set field "mindest" to "0"
And I save the current editor

# STAMMDATEN - BG1 kopieren
Given I open an editor "BG-618" from table "(Part):(Product)" with command "COPY" for record "BG1"
And I set field "such" to "BG-618"
And I set field "dispoa" to "Auftragsbezogen"
And I set field "mindest" to "0"
And I set field "elex" to "E1-618" in row 1
And I set field "tnwpflicht" to "ja" in row 1
And I save the current editor

# STAMMDATEN - Servicepflichtigen Artikel anlegen
Given I open an editor "serartikel-618" from table "(Part):(Product)" with command "STORE" for record ""
And I set field "such" to "FALL-618"
And I set field "namebspr" to "Service Artikel 618"
And I set field "vkbez" to "Service Artikel 618"
And I set field "vbez" to "Service Artikel 618"
And I set field "ebez" to "Service Artikel 618"
And I set field "vpr" to "1000"
And I set field "bsart" to "Eigenfertigung"
And I set field "dispoa" to "Auftragsbezogen"
And I set field "chimlager" to "ja"
And I set field "serpflicht" to "ja"
#Stückliste anlegen
And I create a new row at the end of the table
And I set field "elex" to "E2-618" in row 1
And I set field "elanzahl" to "2" in row 1
And I set field "tnwpflicht" to "ja" in row 1
And I set field "tersatzt" to "ja" in row 1
And I create a new row at the end of the table
And I set field "elex" to "A AG3" in row 2
And I create a new row at the end of the table
And I set field "elex" to "BG-618" in row 3
And I set field "elanzahl" to "1" in row 3
And I set field "tnwpflicht" to "ja" in row 3
And I set field "tverschlt" to "ja" in row 3
And I create a new row at the end of the table
And I set field "elex" to "A AG4" in row 4
And I save the current editor

# Rechnung anlegen
Given I open an editor "rechnung" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "lief" to "1"
And I set field "num4" to "618-RE"
And I set field "fakt" to "ja"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I create a new row at the end of the table
And I set field "artex" to "E1-618" in row 1
And I set field "mge" to "618" in row 1
And I set field "preis" to "618" in row 1
And I set field "platz" to "F2" in row 1
And I create a new row at the end of the table
And I set field "artex" to "E2-618" in row 2
And I set field "mge" to "618" in row 2
And I set field "preis" to "618" in row 2
And I set field "platz" to "F2" in row 2
And I set field "kenn" to "FALL-618"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Charge anlegen
Given I open an editor "charge" from table "(Lots):(Lots)" with command "STORE" for record "FALL-618"
And I set field "such" to "FALL-618"
And I set field "exnum" to "FALL-618"
And I set field "artikel" to id from editor "serartikel-618"
And I save the current editor

# Serviceprodukt als Kunden- und Leihgeraet anlegen
Given I open an editor "kundeng-618" from table "(ServiceProduct):(ServiceProduct)" with command "STORE" for record "KGSP-618"
And I set field "such" to "KGSP-618"
And I set field "namebspr" to "KGSP-618"
And I set field "artikel" to id from editor "serartikel-618"
And I save the current editor
And I switch the current editor to editor "kundeng-618"
And I set field "serprodtyp" to "Kundengerät"
And I set field "zuplatzlg" to ""
And I set field "abplatzlg" to ""
And I set field "charge" to ""
And I save the current editor

# Serviceprodukt Auftrag erfassen 
Given I open an editor "auftrag-618" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set field "kunde" to id from editor "kunde"
And I set field "nummer" to "618-AU"
And I set field "such" to "FALL-618"
And I create a new row at the end of the table
And I set field "artikel" to id from editor "serartikel-618" in row 1
And I set field "mge" to "1" in row 1
And I set field "serprod" to id from editor "kundeng-618" in row 1
And I set field "verw" to "618" in row 1
And I save the current editor

#Disposition starten
And I run Scheduling

#Fertigungsvorschlaege zu BA freigeben
Given I open the infosystem "PRODLIST"
And I set field "kart" to id from editor "BG-618"
And I press start
And I press button "release" in row 1
And I close the current editor

Given I open the infosystem "PRODLIST"
And I set field "kart" to id from editor "serartikel-618"
And I press start
And I press button "release" in row 1
And I close the current editor

#BAs rueckmelden
Given I open an editor "rueckmelden" from table "(Workorder):(WorkOrders)" with command "DONE" for record "$,,artikel=BG-618;verw=618;typ==(WorkSlips);@maxtreffer=1;@richtung=V;"
And I set field "gut" to "ja"
And I set field "sofort" to "ja"
And I save the current editor

#BAs rueckmelden
Given I open an editor "rueckmelden" from table "(Workorder):(WorkOrders)" with command "DONE" for record "$,,artikel=BG-618;verw=618;typ==(WorkSlips);@maxtreffer=1;@richtung=R;"
And I set field "gut" to "ja"
And I set field "sofort" to "ja"
And I save the current editor

Given I open an editor "rueckmelden" from table "(Workorder):(WorkOrders)" with command "DONE" for record "$,,artikel=FALL-618;verw=618;typ==(WorkSlips);@maxtreffer=1;@richtung=V;"
And I set field "gut" to "ja"
And I set field "sofort" to "ja"
And I save the current editor

Given I open an editor "rueckmelden" from table "(Workorder):(WorkOrders)" with command "DONE" for record "$,,artikel=FALL-618;verw=618;typ==(WorkSlips);@maxtreffer=1;@richtung=R;"
And I set field "gut" to "ja"
And I set field "sofort" to "ja"
And I save the current editor

# Lieferschein erzeugen und buchen
Given I open an editor "lieferschein-618" from table "(Sales):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "auftrag-618"
And I set field "nummer" to "618-LS"
And I set field "such" to "LS-618"
And I set field "ueb" to "ja"
And I set field "mge" to "1" in row 1
And I save the current editor

# Ausgabe Lieferschein
Given I open an editor "Lieferschein-view" from table "(Sales):(PackingSlip)" with command "VIEW" for record from editor "lieferschein-618"
And I close the current editor

# Serviceauftrag erstellen 
Given I open an editor "serauftrag-618" from table "(Sales):(ServiceOrder)" with command "NEW" for record ""
And I set field "kunde" to id from editor "kunde"
And I set field "vserprod" to id from editor "kundeng-618"
And I set field "nummer" to "618-SAU"
And I set field "such" to "SAU-618"
And I create a new row at the end of the table
And I set field "artikel" to id from editor "dienstl" in row 1
And I set field "mge" to "1" in row 1
And I set field "zzvon" to "8" in row 1
And I set field "zzbis" to "12" in row 1
And I create a new row at the end of the table
And I set field "artikel" to "E2-618" in row 2
And I set field "mge" to "1" in row 2
And I set field "preis" to "618" in row 2
And I save the current editor

# Ausgabe Serviceauftrag
Given I open an editor "Serviceauftrag-view" from table "(Sales):(ServiceOrder)" with command "VIEW" for record from editor "serauftrag-618"
And I close the current editor

#Fall 618 - Lieferschein erzeugen und buchen
Given I open an editor "lieferschein-618-2" from table "(Sales):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "serauftrag-618"
And I set field "nummer" to "618-LS2"
And I set field "such" to "LS-618-2"
And I set field "ueb" to "ja"
# And I set field "mge" to "1" in row 1
And I set field "mge" to "1" in row 2
And I save the current editor

# Ausgabe Lieferschein
Given I open an editor "Lieferschein-view" from table "(Sales):(PackingSlip)" with command "VIEW" for record from editor "lieferschein-618-2"
And I close the current editor

#Fall 618 - Rechnung erzeugen
Given I open an editor "rechnung-618-2" from table "(Sales):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "lieferschein-618-2"
And I set field "nummer" to "618-RE-2"
And I set field "such" to "FALL-618"
And I set field "ueb" to "ja"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Ausgabe Rechnung
Given I open an editor "Rechnung-view" from table "(Sales):(Invoice)" with command "VIEW" for record from editor "rechnung-618-2"
And I close the current editor

# Storno Rechnung
Given I open an editor "rechnung-storno-618" from table "(Sales):(Invoice)" with command "REVERSAL" for record from editor "rechnung-618-2"
And I set field "num3" to "618-SRE"
And I save the current editor

# Ausgabe Storno Rechnung
Given I open an editor "rechnung-storno-view" from table "(Sales):(Invoice)" with command "VIEW" for record from editor "rechnung-storno-618"
And I close the current editor

#####################################################################################################################################

Scenario: FALL-620
# FALL-620

# STAMMDATEN - E1 kopieren
Given I open an editor "E1-620" from table "(Part):(Product)" with command "COPY" for record "E1"
And I set field "such" to "E1-620"
And I set field "losgr" to "0"
And I set field "mindest" to "0"
And I save the current editor
# STAMMDATEN - E2 kopieren
Given I open an editor "E2-620" from table "(Part):(Product)" with command "COPY" for record "E2"
And I set field "such" to "E2-620"
And I set field "losgr" to "0"
And I set field "mindest" to "0"
And I save the current editor

# STAMMDATEN - BG1 kopieren
Given I open an editor "BG-620" from table "(Part):(Product)" with command "COPY" for record "BG1"
And I set field "such" to "BG-620"
And I set field "dispoa" to "Auftragsbezogen"
And I set field "mindest" to "0"
And I set field "elex" to "E1-620" in row 1
And I set field "tnwpflicht" to "ja" in row 1
And I save the current editor

# STAMMDATEN - Servicepflichtigen Artikel anlegen
Given I open an editor "serartikel-620" from table "(Part):(Product)" with command "STORE" for record ""
And I set field "such" to "FALL-620"
And I set field "namebspr" to "Service Artikel 620"
And I set field "vkbez" to "Service Artikel 620"
And I set field "vbez" to "Service Artikel 620"
And I set field "ebez" to "Service Artikel 620"
And I set field "vpr" to "1000"
And I set field "bsart" to "Eigenfertigung"
And I set field "dispoa" to "Auftragsbezogen"
And I set field "chimlager" to "ja"
And I set field "serpflicht" to "ja"
#Stückliste anlegen
And I create a new row at the end of the table
And I set field "elex" to "E2-620" in row 1
And I set field "elanzahl" to "2" in row 1
And I set field "tnwpflicht" to "ja" in row 1
And I set field "tersatzt" to "ja" in row 1
And I create a new row at the end of the table
And I set field "elex" to "A AG3" in row 2
And I create a new row at the end of the table
And I set field "elex" to "BG-620" in row 3
And I set field "elanzahl" to "1" in row 3
And I set field "tnwpflicht" to "ja" in row 3
And I set field "tverschlt" to "ja" in row 3
And I create a new row at the end of the table
And I set field "elex" to "A AG4" in row 4
And I save the current editor

# Rechnung anlegen
Given I open an editor "rechnung" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "lief" to "1"
And I set field "num4" to "620-RE"
And I set field "fakt" to "ja"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I create a new row at the end of the table
And I set field "artex" to "E1-620" in row 1
And I set field "mge" to "620" in row 1
And I set field "preis" to "620" in row 1
And I set field "platz" to "F2" in row 1
And I create a new row at the end of the table
And I set field "artex" to "E2-620" in row 2
And I set field "mge" to "620" in row 2
And I set field "preis" to "620" in row 2
And I set field "platz" to "F2" in row 2
And I set field "kenn" to "FALL-620"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Charge anlegen
Given I open an editor "charge" from table "(Lots):(Lots)" with command "STORE" for record "FALL-620"
And I set field "such" to "FALL-620"
And I set field "exnum" to "FALL-620"
And I set field "artikel" to id from editor "serartikel-620"
And I save the current editor

# Serviceprodukt als Kunden- und Leihgeraet anlegen
Given I open an editor "kundeng-620" from table "(ServiceProduct):(ServiceProduct)" with command "STORE" for record "KGSP-620"
And I set field "such" to "KGSP-620"
And I set field "namebspr" to "KGSP-620"
And I set field "artikel" to id from editor "serartikel-620"
And I save the current editor
And I switch the current editor to editor "kundeng-620"
And I set field "serprodtyp" to "Kundengerät"
And I set field "zuplatzlg" to ""
And I set field "abplatzlg" to ""
And I set field "charge" to ""
And I save the current editor

# Serviceprodukt Auftrag erfassen 
Given I open an editor "auftrag-620" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set field "kunde" to id from editor "kunde"
And I set field "nummer" to "620-AU"
And I set field "such" to "FALL-620"
And I create a new row at the end of the table
And I set field "artikel" to id from editor "serartikel-620" in row 1
And I set field "mge" to "1" in row 1
And I set field "serprod" to id from editor "kundeng-620" in row 1
And I set field "verw" to "620" in row 1
And I save the current editor

#Disposition starten
And I run Scheduling

#Fertigungsvorschlaege zu BA freigeben
Given I open the infosystem "PRODLIST"
And I set field "kart" to id from editor "BG-620"
And I press start
And I press button "release" in row 1
And I close the current editor

Given I open the infosystem "PRODLIST"
And I set field "kart" to id from editor "serartikel-620"
And I press start
And I press button "release" in row 1
And I close the current editor

#BAs rueckmelden
Given I open an editor "rueckmelden" from table "(Workorder):(WorkOrders)" with command "DONE" for record "$,,artikel=BG-620;verw=620;typ==(WorkSlips);@maxtreffer=1;@richtung=V;"
And I set field "gut" to "ja"
And I set field "sofort" to "ja"
And I save the current editor

#BAs rueckmelden
Given I open an editor "rueckmelden" from table "(Workorder):(WorkOrders)" with command "DONE" for record "$,,artikel=BG-620;verw=620;typ==(WorkSlips);@maxtreffer=1;@richtung=R;"
And I set field "gut" to "ja"
And I set field "sofort" to "ja"
And I save the current editor

Given I open an editor "rueckmelden" from table "(Workorder):(WorkOrders)" with command "DONE" for record "$,,artikel=FALL-620;verw=620;typ==(WorkSlips);@maxtreffer=1;@richtung=V;"
And I set field "gut" to "ja"
And I set field "sofort" to "ja"
And I save the current editor

Given I open an editor "rueckmelden" from table "(Workorder):(WorkOrders)" with command "DONE" for record "$,,artikel=FALL-620;verw=620;typ==(WorkSlips);@maxtreffer=1;@richtung=R;"
And I set field "gut" to "ja"
And I set field "sofort" to "ja"
And I save the current editor

# Lieferschein erzeugen und buchen
Given I open an editor "lieferschein-620" from table "(Sales):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "auftrag-620"
And I set field "nummer" to "620-LS"
And I set field "such" to "LS-620"
And I set field "ueb" to "ja"
And I set field "mge" to "1" in row 1
And I save the current editor

# Ausgabe Lieferschein
Given I open an editor "Lieferschein-view" from table "(Sales):(PackingSlip)" with command "VIEW" for record from editor "lieferschein-620"
And I close the current editor

# Rechnung zu Lieferschein anlegen
Given I open an editor "rechnung-620" from table "(Sales):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "lieferschein-620"
And I set field "num3" to "620-RE"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "1" in row 1
And I set field "preis" to "620" in row 1
And I set field "kenn" to "FALL-620"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Ausgabe Rechnung
Given I open an editor "Rechnung-view" from table "(Sales):(Invoice)" with command "VIEW" for record from editor "rechnung-620"
And I close the current editor

# Lieferschein rueckliefern und buchen
Given I open an editor "r-lieferschein-620" from table "(Sales):(PackingSlip)" with command "RETURN" for record from editor "lieferschein-620"
And I set field "nummer" to "620-RLS"
And I set field "such" to "RLS-620"
And I set field "ueb" to "ja"
Then the table has 1 rows
And I set field "mge" to "-1" in row 1
And I set field "rerelev" to "ja" in row 1
And I save the current editor

# Ausgabe Rücklieferschein
Given I open an editor "Lieferschein-view" from table "(Sales):(PackingSlip)" with command "VIEW" for record from editor "r-lieferschein-620"
And I close the current editor

#####################################################################################################################################

Scenario: FALL-622
# FALL-622

# STAMMDATEN - E1 kopieren
Given I open an editor "E1-622" from table "(Part):(Product)" with command "COPY" for record "E1"
And I set field "such" to "E1-622"
And I set field "losgr" to "0"
And I set field "mindest" to "0"
And I save the current editor
# STAMMDATEN - E2 kopieren
Given I open an editor "E2-622" from table "(Part):(Product)" with command "COPY" for record "E2"
And I set field "such" to "E2-622"
And I set field "losgr" to "0"
And I set field "mindest" to "0"
And I save the current editor

# STAMMDATEN - BG1 kopieren
Given I open an editor "BG-622" from table "(Part):(Product)" with command "COPY" for record "BG1"
And I set field "such" to "BG-622"
And I set field "dispoa" to "Auftragsbezogen"
And I set field "mindest" to "0"
And I set field "elex" to "E1-622" in row 1
And I set field "tnwpflicht" to "ja" in row 1
And I save the current editor

# STAMMDATEN - Servicepflichtigen Artikel anlegen
Given I open an editor "serartikel-622" from table "(Part):(Product)" with command "STORE" for record ""
And I set field "such" to "FALL-622"
And I set field "namebspr" to "Service Artikel 622"
And I set field "vkbez" to "Service Artikel 622"
And I set field "vbez" to "Service Artikel 622"
And I set field "ebez" to "Service Artikel 622"
And I set field "vpr" to "1000"
And I set field "bsart" to "Eigenfertigung"
And I set field "dispoa" to "Auftragsbezogen"
And I set field "chimlager" to "ja"
And I set field "serpflicht" to "ja"
#Stückliste anlegen
And I create a new row at the end of the table
And I set field "elex" to "E2-622" in row 1
And I set field "elanzahl" to "2" in row 1
And I set field "tnwpflicht" to "ja" in row 1
And I set field "tersatzt" to "ja" in row 1
And I create a new row at the end of the table
And I set field "elex" to "A AG3" in row 2
And I create a new row at the end of the table
And I set field "elex" to "BG-622" in row 3
And I set field "elanzahl" to "1" in row 3
And I set field "tnwpflicht" to "ja" in row 3
And I set field "tverschlt" to "ja" in row 3
And I create a new row at the end of the table
And I set field "elex" to "A AG4" in row 4
And I save the current editor

# Rechnung anlegen
Given I open an editor "rechnung" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "lief" to "1"
And I set field "num4" to "622-RE"
And I set field "fakt" to "ja"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I create a new row at the end of the table
And I set field "artex" to "E1-622" in row 1
And I set field "mge" to "622" in row 1
And I set field "preis" to "622" in row 1
And I set field "platz" to "F2" in row 1
And I create a new row at the end of the table
And I set field "artex" to "E2-622" in row 2
And I set field "mge" to "622" in row 2
And I set field "preis" to "622" in row 2
And I set field "platz" to "F2" in row 2
And I set field "kenn" to "FALL-622"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Charge anlegen
Given I open an editor "charge" from table "(Lots):(Lots)" with command "STORE" for record "FALL-622"
And I set field "such" to "FALL-622"
And I set field "exnum" to "FALL-622"
And I set field "artikel" to id from editor "serartikel-622"
And I save the current editor

# Serviceprodukt als Kunden- und Leihgeraet anlegen
Given I open an editor "kundeng-622" from table "(ServiceProduct):(ServiceProduct)" with command "STORE" for record "KGSP-622"
And I set field "such" to "KGSP-622"
And I set field "namebspr" to "KGSP-622"
And I set field "artikel" to id from editor "serartikel-622"
And I save the current editor
And I switch the current editor to editor "kundeng-622"
And I set field "serprodtyp" to "Kundengerät"
And I set field "zuplatzlg" to ""
And I set field "abplatzlg" to ""
And I set field "charge" to ""
And I save the current editor

# Serviceprodukt Auftrag erfassen 
Given I open an editor "auftrag-622" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set field "kunde" to id from editor "kunde"
And I set field "nummer" to "622-AU"
And I set field "such" to "FALL-622"
And I create a new row at the end of the table
And I set field "artikel" to id from editor "serartikel-622" in row 1
And I set field "mge" to "1" in row 1
And I set field "serprod" to id from editor "kundeng-622" in row 1
And I set field "verw" to "622" in row 1
And I save the current editor

#Disposition starten
And I run Scheduling

#Fertigungsvorschlaege zu BA freigeben
Given I open the infosystem "PRODLIST"
And I set field "kart" to id from editor "BG-622"
And I press start
And I press button "release" in row 1
And I close the current editor

Given I open the infosystem "PRODLIST"
And I set field "kart" to id from editor "serartikel-622"
And I press start
And I press button "release" in row 1
And I close the current editor

#BAs rueckmelden
Given I open an editor "rueckmelden" from table "(Workorder):(WorkOrders)" with command "DONE" for record "$,,artikel=BG-622;verw=622;typ==(WorkSlips);@maxtreffer=1;@richtung=V;"
And I set field "gut" to "ja"
And I set field "sofort" to "ja"
And I save the current editor

#BAs rueckmelden
Given I open an editor "rueckmelden" from table "(Workorder):(WorkOrders)" with command "DONE" for record "$,,artikel=BG-622;verw=622;typ==(WorkSlips);@maxtreffer=1;@richtung=R;"
And I set field "gut" to "ja"
And I set field "sofort" to "ja"
And I save the current editor

Given I open an editor "rueckmelden" from table "(Workorder):(WorkOrders)" with command "DONE" for record "$,,artikel=FALL-622;verw=622;typ==(WorkSlips);@maxtreffer=1;@richtung=V;"
And I set field "gut" to "ja"
And I set field "sofort" to "ja"
And I save the current editor

Given I open an editor "rueckmelden" from table "(Workorder):(WorkOrders)" with command "DONE" for record "$,,artikel=FALL-622;verw=622;typ==(WorkSlips);@maxtreffer=1;@richtung=R;"
And I set field "gut" to "ja"
And I set field "sofort" to "ja"
And I save the current editor

# Lieferschein erzeugen und buchen
Given I open an editor "lieferschein-622" from table "(Sales):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "auftrag-622"
And I set field "nummer" to "622-LS"
And I set field "such" to "LS-622"
And I set field "ueb" to "ja"
And I set field "mge" to "1" in row 1
And I save the current editor

# Ausgabe Lieferschein
Given I open an editor "Lieferschein-view" from table "(Sales):(PackingSlip)" with command "VIEW" for record from editor "lieferschein-622"
And I close the current editor

# Serviceauftrag erstellen 
Given I open an editor "serauftrag-622" from table "(Sales):(ServiceOrder)" with command "NEW" for record ""
And I set field "kunde" to id from editor "kunde"
And I set field "vserprod" to id from editor "kundeng-622"
And I set field "nummer" to "622-SAU"
And I set field "such" to "SAU-622"
And I create a new row at the end of the table
And I set field "artikel" to id from editor "dienstl" in row 1
And I set field "mge" to "1" in row 1
And I set field "zzvon" to "8" in row 1
And I set field "zzbis" to "12" in row 1
And I create a new row at the end of the table
And I set field "artikel" to "E2-622" in row 2
And I set field "mge" to "1" in row 2
And I save the current editor

# Ausgabe Serviceauftrag
Given I open an editor "Serviceauftrag-view" from table "(Sales):(ServiceOrder)" with command "VIEW" for record from editor "serauftrag-622"
And I close the current editor

#Fall 602, 622 - Lieferschein erzeugen und buchen
Given I open an editor "lieferschein-622-2" from table "(Sales):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "serauftrag-622"
And I set field "nummer" to "622-LS2"
And I set field "such" to "LS-622-2"
And I set field "ueb" to "ja"
And I set field "mge" to "1" in row 1
# And I set field "mge" to "1" in row 2
And I save the current editor

# Ausgabe Lieferschein
Given I open an editor "Lieferschein-view" from table "(Sales):(PackingSlip)" with command "VIEW" for record from editor "lieferschein-622-2"
And I close the current editor

# Rücklieferschein anlegen
Given I open an editor "Ruecklieferschein-622" from table "(Sales):(PackingSlip)" with command "RETURN" for record from editor "lieferschein-622"
And I set field "num3" to "622-RLS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "-1" in row 1
And I set field "platz" to "F1" in row 1
And I set field "kenn" to "FALL-622 Ruecklieferschein"
#And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Ausgabe Rücklieferschein
Given I open an editor "Lieferschein-view" from table "(Sales):(PackingSlip)" with command "VIEW" for record from editor "Ruecklieferschein-622"
And I close the current editor

#####################################################################################################################################

Scenario: FALL-623
# FALL-623

# STAMMDATEN - E1 kopieren
Given I open an editor "E1-623" from table "(Part):(Product)" with command "COPY" for record "E1"
And I set field "such" to "E1-623"
And I set field "losgr" to "0"
And I set field "mindest" to "0"
And I save the current editor
# STAMMDATEN - E2 kopieren
Given I open an editor "E2-623" from table "(Part):(Product)" with command "COPY" for record "E2"
And I set field "such" to "E2-623"
And I set field "losgr" to "0"
And I set field "mindest" to "0"
And I save the current editor

# STAMMDATEN - BG1 kopieren
Given I open an editor "BG-623" from table "(Part):(Product)" with command "COPY" for record "BG1"
And I set field "such" to "BG-623"
And I set field "dispoa" to "Auftragsbezogen"
And I set field "mindest" to "0"
And I set field "elex" to "E1-623" in row 1
And I set field "tnwpflicht" to "ja" in row 1
And I save the current editor

# STAMMDATEN - Servicepflichtigen Artikel anlegen
Given I open an editor "serartikel-623" from table "(Part):(Product)" with command "STORE" for record ""
And I set field "such" to "FALL-623"
And I set field "namebspr" to "Service Artikel 623"
And I set field "vkbez" to "Service Artikel 623"
And I set field "vbez" to "Service Artikel 623"
And I set field "ebez" to "Service Artikel 623"
And I set field "vpr" to "1000"
And I set field "bsart" to "Eigenfertigung"
And I set field "dispoa" to "Auftragsbezogen"
And I set field "chimlager" to "ja"
And I set field "serpflicht" to "ja"
#Stückliste anlegen
And I create a new row at the end of the table
And I set field "elex" to "E2-623" in row 1
And I set field "elanzahl" to "2" in row 1
And I set field "tnwpflicht" to "ja" in row 1
And I set field "tersatzt" to "ja" in row 1
And I create a new row at the end of the table
And I set field "elex" to "A AG3" in row 2
And I create a new row at the end of the table
And I set field "elex" to "BG-623" in row 3
And I set field "elanzahl" to "1" in row 3
And I set field "tnwpflicht" to "ja" in row 3
And I set field "tverschlt" to "ja" in row 3
And I create a new row at the end of the table
And I set field "elex" to "A AG4" in row 4
And I save the current editor

# Rechnung anlegen
Given I open an editor "rechnung" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "lief" to "1"
And I set field "num4" to "623-RE"
And I set field "fakt" to "ja"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I create a new row at the end of the table
And I set field "artex" to "E1-623" in row 1
And I set field "mge" to "623" in row 1
And I set field "preis" to "623" in row 1
And I set field "platz" to "F2" in row 1
And I create a new row at the end of the table
And I set field "artex" to "E2-623" in row 2
And I set field "mge" to "623" in row 2
And I set field "preis" to "623" in row 2
And I set field "platz" to "F2" in row 2
And I set field "kenn" to "FALL-623"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Charge anlegen
Given I open an editor "charge" from table "(Lots):(Lots)" with command "STORE" for record "FALL-623"
And I set field "such" to "FALL-623"
And I set field "exnum" to "FALL-623"
And I set field "artikel" to id from editor "serartikel-623"
And I save the current editor

# Serviceprodukt als Kunden- und Leihgeraet anlegen
Given I open an editor "kundeng-623" from table "(ServiceProduct):(ServiceProduct)" with command "STORE" for record "KGSP-623"
And I set field "such" to "KGSP-623"
And I set field "namebspr" to "KGSP-623"
And I set field "artikel" to id from editor "serartikel-623"
And I save the current editor
And I switch the current editor to editor "kundeng-623"
And I set field "serprodtyp" to "Kundengerät"
And I set field "zuplatzlg" to ""
And I set field "abplatzlg" to ""
And I set field "charge" to ""
And I save the current editor

# Serviceprodukt Auftrag erfassen 
Given I open an editor "auftrag-623" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set field "kunde" to id from editor "kunde"
And I set field "nummer" to "623-AU"
And I set field "such" to "FALL-623"
And I create a new row at the end of the table
And I set field "artikel" to id from editor "serartikel-623" in row 1
And I set field "mge" to "1" in row 1
And I set field "serprod" to id from editor "kundeng-623" in row 1
And I set field "verw" to "623" in row 1
And I save the current editor

#Disposition starten
And I run Scheduling

#Fertigungsvorschlaege zu BA freigeben
Given I open the infosystem "PRODLIST"
And I set field "kart" to id from editor "BG-623"
And I press start
And I press button "release" in row 1
And I close the current editor

Given I open the infosystem "PRODLIST"
And I set field "kart" to id from editor "serartikel-623"
And I press start
And I press button "release" in row 1
And I close the current editor

#BAs rueckmelden
Given I open an editor "rueckmelden" from table "(Workorder):(WorkOrders)" with command "DONE" for record "$,,artikel=BG-623;verw=623;typ==(WorkSlips);@maxtreffer=1;@richtung=V;"
And I set field "gut" to "ja"
And I set field "sofort" to "ja"
And I save the current editor

#BAs rueckmelden
Given I open an editor "rueckmelden" from table "(Workorder):(WorkOrders)" with command "DONE" for record "$,,artikel=BG-623;verw=623;typ==(WorkSlips);@maxtreffer=1;@richtung=R;"
And I set field "gut" to "ja"
And I set field "sofort" to "ja"
And I save the current editor

Given I open an editor "rueckmelden" from table "(Workorder):(WorkOrders)" with command "DONE" for record "$,,artikel=FALL-623;verw=623;typ==(WorkSlips);@maxtreffer=1;@richtung=V;"
And I set field "gut" to "ja"
And I set field "sofort" to "ja"
And I save the current editor

Given I open an editor "rueckmelden" from table "(Workorder):(WorkOrders)" with command "DONE" for record "$,,artikel=FALL-623;verw=623;typ==(WorkSlips);@maxtreffer=1;@richtung=R;"
And I set field "gut" to "ja"
And I set field "sofort" to "ja"
And I save the current editor

# Lieferschein erzeugen und buchen
Given I open an editor "lieferschein-623" from table "(Sales):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "auftrag-623"
And I set field "nummer" to "623-LS"
And I set field "such" to "LS-623"
And I set field "ueb" to "ja"
And I set field "mge" to "1" in row 1
And I save the current editor

# Ausgabe Lieferschein
Given I open an editor "Lieferschein-view" from table "(Sales):(PackingSlip)" with command "VIEW" for record from editor "lieferschein-623"
And I close the current editor

# Serviceauftrag erstellen 
Given I open an editor "serauftrag-623" from table "(Sales):(ServiceOrder)" with command "NEW" for record ""
And I set field "kunde" to id from editor "kunde"
And I set field "vserprod" to id from editor "kundeng-623"
And I set field "nummer" to "623-SAU"
And I set field "such" to "SAU-623"
And I create a new row at the end of the table
And I set field "artikel" to id from editor "dienstl" in row 1
And I set field "mge" to "1" in row 1
And I set field "zzvon" to "8" in row 1
And I set field "zzbis" to "12" in row 1
And I create a new row at the end of the table
And I set field "artikel" to "E2-623" in row 2
And I set field "mge" to "1" in row 2
And I save the current editor

# Ausgabe Serviceauftrag
Given I open an editor "Serviceauftrag-view" from table "(Sales):(ServiceOrder)" with command "VIEW" for record from editor "serauftrag-623"
And I close the current editor

#Fall 623 - Lieferschein erzeugen und buchen
Given I open an editor "lieferschein-623-2" from table "(Sales):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "serauftrag-623"
And I set field "nummer" to "623-LS2"
And I set field "such" to "LS-623-2"
And I set field "ueb" to "ja"
# And I set field "mge" to "1" in row 1
And I set field "mge" to "1" in row 2
And I save the current editor

# Ausgabe Lieferschein
Given I open an editor "Lieferschein-view" from table "(Sales):(PackingSlip)" with command "VIEW" for record from editor "lieferschein-623-2"
And I close the current editor

# Rücklieferschein anlegen
Given I open an editor "Ruecklieferschein-623" from table "(Sales):(PackingSlip)" with command "RETURN" for record from editor "lieferschein-623"
And I set field "num3" to "623-RLS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "-1" in row 1
And I set field "platz" to "F1" in row 1
And I set field "kenn" to "FALL-623 Ruecklieferschein"
#And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Ausgabe Rücklieferschein
Given I open an editor "Lieferschein-view" from table "(Sales):(PackingSlip)" with command "VIEW" for record from editor "Ruecklieferschein-623"
And I close the current editor

#####################################################################################################################################

Scenario: FALL-626
# FALL-626

# STAMMDATEN - E1 kopieren
Given I open an editor "E1-626" from table "(Part):(Product)" with command "COPY" for record "E1"
And I set field "such" to "E1-626"
And I set field "losgr" to "0"
And I set field "mindest" to "0"
And I save the current editor
# STAMMDATEN - E2 kopieren
Given I open an editor "E2-626" from table "(Part):(Product)" with command "COPY" for record "E2"
And I set field "such" to "E2-626"
And I set field "losgr" to "0"
And I set field "mindest" to "0"
And I save the current editor

# STAMMDATEN - BG1 kopieren
Given I open an editor "BG-626" from table "(Part):(Product)" with command "COPY" for record "BG1"
And I set field "such" to "BG-626"
And I set field "dispoa" to "Auftragsbezogen"
And I set field "mindest" to "0"
And I set field "elex" to "E1-626" in row 1
And I set field "tnwpflicht" to "ja" in row 1
And I save the current editor

# STAMMDATEN - Servicepflichtigen Artikel anlegen
Given I open an editor "serartikel-626" from table "(Part):(Product)" with command "STORE" for record ""
And I set field "such" to "FALL-626"
And I set field "namebspr" to "Service Artikel 626"
And I set field "vkbez" to "Service Artikel 626"
And I set field "vbez" to "Service Artikel 626"
And I set field "ebez" to "Service Artikel 626"
And I set field "vpr" to "1000"
And I set field "bsart" to "Eigenfertigung"
And I set field "dispoa" to "Auftragsbezogen"
And I set field "chimlager" to "ja"
And I set field "serpflicht" to "ja"
#Stückliste anlegen
And I create a new row at the end of the table
And I set field "elex" to "E2-626" in row 1
And I set field "elanzahl" to "2" in row 1
And I set field "tnwpflicht" to "ja" in row 1
And I set field "tersatzt" to "ja" in row 1
And I create a new row at the end of the table
And I set field "elex" to "A AG3" in row 2
And I create a new row at the end of the table
And I set field "elex" to "BG-626" in row 3
And I set field "elanzahl" to "1" in row 3
And I set field "tnwpflicht" to "ja" in row 3
And I set field "tverschlt" to "ja" in row 3
And I create a new row at the end of the table
And I set field "elex" to "A AG4" in row 4
And I save the current editor

# Rechnung anlegen
Given I open an editor "rechnung" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "lief" to "1"
And I set field "num4" to "626-RE"
And I set field "fakt" to "ja"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I create a new row at the end of the table
And I set field "artex" to "E1-626" in row 1
And I set field "mge" to "626" in row 1
And I set field "preis" to "626" in row 1
And I set field "platz" to "F2" in row 1
And I create a new row at the end of the table
And I set field "artex" to "E2-626" in row 2
And I set field "mge" to "626" in row 2
And I set field "preis" to "626" in row 2
And I set field "platz" to "F2" in row 2
And I set field "kenn" to "FALL-626"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Charge anlegen
Given I open an editor "charge" from table "(Lots):(Lots)" with command "STORE" for record "FALL-626"
And I set field "such" to "FALL-626"
And I set field "exnum" to "FALL-626"
And I set field "artikel" to id from editor "serartikel-626"
And I save the current editor

# Serviceprodukt als Kunden- und Leihgeraet anlegen
Given I open an editor "kundeng-626" from table "(ServiceProduct):(ServiceProduct)" with command "STORE" for record "KGSP-626"
And I set field "such" to "KGSP-626"
And I set field "namebspr" to "KGSP-626"
And I set field "artikel" to id from editor "serartikel-626"
And I save the current editor
And I switch the current editor to editor "kundeng-626"
And I set field "serprodtyp" to "Kundengerät"
And I set field "zuplatzlg" to ""
And I set field "abplatzlg" to ""
And I set field "charge" to ""
And I save the current editor

# Serviceprodukt Auftrag erfassen 
Given I open an editor "auftrag-626" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set field "kunde" to id from editor "kunde"
And I set field "nummer" to "626-AU"
And I set field "such" to "FALL-626"
And I create a new row at the end of the table
And I set field "artikel" to id from editor "serartikel-626" in row 1
And I set field "mge" to "1" in row 1
And I set field "serprod" to id from editor "kundeng-626" in row 1
And I set field "verw" to "626" in row 1
And I save the current editor

#Disposition starten
And I run Scheduling

#Fertigungsvorschlaege zu BA freigeben
Given I open the infosystem "PRODLIST"
And I set field "kart" to id from editor "BG-626"
And I press start
And I press button "release" in row 1
And I close the current editor

Given I open the infosystem "PRODLIST"
And I set field "kart" to id from editor "serartikel-626"
And I press start
And I press button "release" in row 1
And I close the current editor

#BAs rueckmelden
Given I open an editor "rueckmelden" from table "(Workorder):(WorkOrders)" with command "DONE" for record "$,,artikel=BG-626;verw=626;typ==(WorkSlips);@maxtreffer=1;@richtung=V;"
And I set field "gut" to "ja"
And I set field "sofort" to "ja"
And I save the current editor

#BAs rueckmelden
Given I open an editor "rueckmelden" from table "(Workorder):(WorkOrders)" with command "DONE" for record "$,,artikel=BG-626;verw=626;typ==(WorkSlips);@maxtreffer=1;@richtung=R;"
And I set field "gut" to "ja"
And I set field "sofort" to "ja"
And I save the current editor

Given I open an editor "rueckmelden" from table "(Workorder):(WorkOrders)" with command "DONE" for record "$,,artikel=FALL-626;verw=626;typ==(WorkSlips);@maxtreffer=1;@richtung=V;"
And I set field "gut" to "ja"
And I set field "sofort" to "ja"
And I save the current editor

Given I open an editor "rueckmelden" from table "(Workorder):(WorkOrders)" with command "DONE" for record "$,,artikel=FALL-626;verw=626;typ==(WorkSlips);@maxtreffer=1;@richtung=R;"
And I set field "gut" to "ja"
And I set field "sofort" to "ja"
And I save the current editor

# Lieferschein erzeugen und buchen
Given I open an editor "lieferschein-626" from table "(Sales):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "auftrag-626"
And I set field "nummer" to "626-LS"
And I set field "such" to "LS-626"
And I set field "ueb" to "ja"
And I set field "mge" to "1" in row 1
And I save the current editor

# Ausgabe Lieferschein
Given I open an editor "Lieferschein-view" from table "(Sales):(PackingSlip)" with command "VIEW" for record from editor "lieferschein-626"
And I close the current editor

# Rechnung zu Lieferschein anlegen
Given I open an editor "rechnung1-626" from table "(Sales):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "lieferschein-626"
And I set field "num3" to "626-RE"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "preis" to "626" in row 1
And I set field "kenn" to "FALL-626"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Lieferschein rueckliefern und buchen
Given I open an editor "r-lieferschein-626" from table "(Sales):(PackingSlip)" with command "RETURN" for record from editor "lieferschein-626"
And I set field "nummer" to "626-RLS"
And I set field "such" to "RLS-626"
And I set field "ueb" to "ja"
Then the table has 1 rows
And I set field "mge" to "-1" in row 1
And I set field "rerelev" to "ja" in row 1
And I save the current editor

# Ausgabe Rücklieferschein
Given I open an editor "Lieferschein-view" from table "(Sales):(PackingSlip)" with command "VIEW" for record from editor "r-lieferschein-626"
And I close the current editor

# Gutschrift anlegen
Given I open an editor "Gutschrift-626" from table "(Sales):(Invoice)" with command "COPY" for record from editor "r-lieferschein-626"
And I set field "num3" to "626-GS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "kenn" to "FALL-626"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Ausgabe Gutschrift
Given I open an editor "Gutschrift-view" from table "(Sales):(Invoice)" with command "VIEW" for record from editor "Gutschrift-626"
And I close the current editor
 
#####################################################################################################################################

Scenario: FALL-627
# FALL-627

# STAMMDATEN - E1 kopieren
Given I open an editor "E1-627" from table "(Part):(Product)" with command "COPY" for record "E1"
And I set field "such" to "E1-627"
And I set field "losgr" to "0"
And I set field "mindest" to "0"
And I save the current editor
# STAMMDATEN - E2 kopieren
Given I open an editor "E2-627" from table "(Part):(Product)" with command "COPY" for record "E2"
And I set field "such" to "E2-627"
And I set field "losgr" to "0"
And I set field "mindest" to "0"
And I save the current editor

# STAMMDATEN - BG1 kopieren
Given I open an editor "BG-627" from table "(Part):(Product)" with command "COPY" for record "BG1"
And I set field "such" to "BG-627"
And I set field "dispoa" to "Auftragsbezogen"
And I set field "mindest" to "0"
And I set field "elex" to "E1-627" in row 1
And I set field "tnwpflicht" to "ja" in row 1
And I save the current editor

# STAMMDATEN - Servicepflichtigen Artikel anlegen
Given I open an editor "serartikel-627" from table "(Part):(Product)" with command "STORE" for record ""
And I set field "such" to "FALL-627"
And I set field "namebspr" to "Service Artikel 627"
And I set field "vkbez" to "Service Artikel 627"
And I set field "vbez" to "Service Artikel 627"
And I set field "ebez" to "Service Artikel 627"
And I set field "vpr" to "1000"
And I set field "bsart" to "Eigenfertigung"
And I set field "dispoa" to "Auftragsbezogen"
And I set field "chimlager" to "ja"
And I set field "serpflicht" to "ja"
#Stückliste anlegen
And I create a new row at the end of the table
And I set field "elex" to "E2-627" in row 1
And I set field "elanzahl" to "2" in row 1
And I set field "tnwpflicht" to "ja" in row 1
And I set field "tersatzt" to "ja" in row 1
And I create a new row at the end of the table
And I set field "elex" to "A AG3" in row 2
And I create a new row at the end of the table
And I set field "elex" to "BG-627" in row 3
And I set field "elanzahl" to "1" in row 3
And I set field "tnwpflicht" to "ja" in row 3
And I set field "tverschlt" to "ja" in row 3
And I create a new row at the end of the table
And I set field "elex" to "A AG4" in row 4
And I save the current editor

# Rechnung anlegen
Given I open an editor "rechnung" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "lief" to "1"
And I set field "num4" to "627-RE"
And I set field "fakt" to "ja"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I create a new row at the end of the table
And I set field "artex" to "E1-627" in row 1
And I set field "mge" to "627" in row 1
And I set field "preis" to "627" in row 1
And I set field "platz" to "F2" in row 1
And I create a new row at the end of the table
And I set field "artex" to "E2-627" in row 2
And I set field "mge" to "627" in row 2
And I set field "preis" to "627" in row 2
And I set field "platz" to "F2" in row 2
And I set field "kenn" to "FALL-627"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Charge anlegen
Given I open an editor "charge" from table "(Lots):(Lots)" with command "STORE" for record "FALL-627"
And I set field "such" to "FALL-627"
And I set field "exnum" to "FALL-627"
And I set field "artikel" to id from editor "serartikel-627"
And I save the current editor

# Serviceprodukt als Kunden- und Leihgeraet anlegen
Given I open an editor "kundeng-627" from table "(ServiceProduct):(ServiceProduct)" with command "STORE" for record "KGSP-627"
And I set field "such" to "KGSP-627"
And I set field "namebspr" to "KGSP-627"
And I set field "artikel" to id from editor "serartikel-627"
And I save the current editor
And I switch the current editor to editor "kundeng-627"
And I set field "serprodtyp" to "Kundengerät"
And I set field "zuplatzlg" to ""
And I set field "abplatzlg" to ""
And I set field "charge" to ""
And I save the current editor

# Serviceprodukt Auftrag erfassen 
Given I open an editor "auftrag-627" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set field "kunde" to id from editor "kunde"
And I set field "nummer" to "627-AU"
And I set field "such" to "FALL-627"
And I create a new row at the end of the table
And I set field "artikel" to id from editor "serartikel-627" in row 1
And I set field "mge" to "1" in row 1
And I set field "serprod" to id from editor "kundeng-627" in row 1
And I set field "verw" to "627" in row 1
And I save the current editor

#Disposition starten
And I run Scheduling

#Fertigungsvorschlaege zu BA freigeben
Given I open the infosystem "PRODLIST"
And I set field "kart" to id from editor "BG-627"
And I press start
And I press button "release" in row 1
And I close the current editor

Given I open the infosystem "PRODLIST"
And I set field "kart" to id from editor "serartikel-627"
And I press start
And I press button "release" in row 1
And I close the current editor

#BAs rueckmelden
Given I open an editor "rueckmelden" from table "(Workorder):(WorkOrders)" with command "DONE" for record "$,,artikel=BG-627;verw=627;typ==(WorkSlips);@maxtreffer=1;@richtung=V;"
And I set field "gut" to "ja"
And I set field "sofort" to "ja"
And I save the current editor

#BAs rueckmelden
Given I open an editor "rueckmelden" from table "(Workorder):(WorkOrders)" with command "DONE" for record "$,,artikel=BG-627;verw=627;typ==(WorkSlips);@maxtreffer=1;@richtung=R;"
And I set field "gut" to "ja"
And I set field "sofort" to "ja"
And I save the current editor

Given I open an editor "rueckmelden" from table "(Workorder):(WorkOrders)" with command "DONE" for record "$,,artikel=FALL-627;verw=627;typ==(WorkSlips);@maxtreffer=1;@richtung=V;"
And I set field "gut" to "ja"
And I set field "sofort" to "ja"
And I save the current editor

Given I open an editor "rueckmelden" from table "(Workorder):(WorkOrders)" with command "DONE" for record "$,,artikel=FALL-627;verw=627;typ==(WorkSlips);@maxtreffer=1;@richtung=R;"
And I set field "gut" to "ja"
And I set field "sofort" to "ja"
And I save the current editor

# Lieferschein erzeugen und buchen
Given I open an editor "lieferschein-627" from table "(Sales):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "auftrag-627"
And I set field "nummer" to "627-LS"
And I set field "such" to "LS-627"
And I set field "ueb" to "ja"
And I set field "mge" to "1" in row 1
And I save the current editor

# Ausgabe Lieferschein
Given I open an editor "Lieferschein-view" from table "(Sales):(PackingSlip)" with command "VIEW" for record from editor "lieferschein-627"
And I close the current editor

# Serviceauftrag erstellen 
Given I open an editor "serauftrag-627" from table "(Sales):(ServiceOrder)" with command "NEW" for record ""
And I set field "kunde" to id from editor "kunde"
And I set field "vserprod" to id from editor "kundeng-627"
And I set field "nummer" to "627-SAU"
And I set field "such" to "SAU-627"
And I create a new row at the end of the table
And I set field "artikel" to id from editor "dienstl" in row 1
And I set field "mge" to "1" in row 1
And I set field "zzvon" to "8" in row 1
And I set field "zzbis" to "12" in row 1
And I create a new row at the end of the table
And I set field "artikel" to "E2-627" in row 2
And I set field "mge" to "1" in row 2
And I save the current editor

# Ausgabe Serviceauftrag
Given I open an editor "Serviceauftrag-view" from table "(Sales):(ServiceOrder)" with command "VIEW" for record from editor "serauftrag-627"
And I close the current editor

#Fall 602, 627 - Lieferschein erzeugen und buchen
Given I open an editor "lieferschein-627-2" from table "(Sales):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "serauftrag-627"
And I set field "nummer" to "627-LS2"
And I set field "such" to "LS-627-2"
And I set field "ueb" to "ja"
And I set field "mge" to "1" in row 1
# And I set field "mge" to "1" in row 2
And I save the current editor

# Ausgabe Lieferschein
Given I open an editor "Lieferschein-view" from table "(Sales):(PackingSlip)" with command "VIEW" for record from editor "lieferschein-627-2"
And I close the current editor

# Rechnung zu Lieferschein anlegen
Given I open an editor "rechnung1-627" from table "(Sales):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "lieferschein-627"
And I set field "num3" to "627-RE"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "preis" to "627" in row 1
And I set field "kenn" to "FALL-627"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Rücklieferschein anlegen
Given I open an editor "Ruecklieferschein-627" from table "(Sales):(PackingSlip)" with command "RETURN" for record from editor "lieferschein-627"
And I set field "num3" to "627-RLS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "-1" in row 1
And I set field "platz" to "F1" in row 1
And I set field "kenn" to "FALL-627 Ruecklieferschein"
And I save the current editor

# Ausgabe Rücklieferschein
Given I open an editor "Lieferschein-view" from table "(Sales):(PackingSlip)" with command "VIEW" for record from editor "Ruecklieferschein-627"
And I close the current editor

# Gutschrift anlegen
Given I open an editor "Gutschrift-627" from table "(Sales):(Invoice)" with command "COPY" for record from editor "Ruecklieferschein-627"
And I set field "nummer" to "627-GS"
And I set field "such" to "GS-627"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "kenn" to "FALL-627"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Ausgabe Gutschrift
Given I open an editor "Gutschrift-view" from table "(Sales):(Invoice)" with command "VIEW" for record from editor "Gutschrift-627"
And I close the current editor
 
#####################################################################################################################################

Scenario: FALL-628
# FALL-628

# STAMMDATEN - E1 kopieren
Given I open an editor "E1-628" from table "(Part):(Product)" with command "COPY" for record "E1"
And I set field "such" to "E1-628"
And I set field "losgr" to "0"
And I set field "mindest" to "0"
And I save the current editor
# STAMMDATEN - E2 kopieren
Given I open an editor "E2-628" from table "(Part):(Product)" with command "COPY" for record "E2"
And I set field "such" to "E2-628"
And I set field "losgr" to "0"
And I set field "mindest" to "0"
And I save the current editor

# STAMMDATEN - BG1 kopieren
Given I open an editor "BG-628" from table "(Part):(Product)" with command "COPY" for record "BG1"
And I set field "such" to "BG-628"
And I set field "dispoa" to "Auftragsbezogen"
And I set field "mindest" to "0"
And I set field "elex" to "E1-628" in row 1
And I set field "tnwpflicht" to "ja" in row 1
And I save the current editor

# STAMMDATEN - Servicepflichtigen Artikel anlegen
Given I open an editor "serartikel-628" from table "(Part):(Product)" with command "STORE" for record ""
And I set field "such" to "FALL-628"
And I set field "namebspr" to "Service Artikel 628"
And I set field "vkbez" to "Service Artikel 628"
And I set field "vbez" to "Service Artikel 628"
And I set field "ebez" to "Service Artikel 628"
And I set field "vpr" to "1000"
And I set field "bsart" to "Eigenfertigung"
And I set field "dispoa" to "Auftragsbezogen"
And I set field "chimlager" to "ja"
And I set field "serpflicht" to "ja"
#Stückliste anlegen
And I create a new row at the end of the table
And I set field "elex" to "E2-628" in row 1
And I set field "elanzahl" to "2" in row 1
And I set field "tnwpflicht" to "ja" in row 1
And I set field "tersatzt" to "ja" in row 1
And I create a new row at the end of the table
And I set field "elex" to "A AG3" in row 2
And I create a new row at the end of the table
And I set field "elex" to "BG-628" in row 3
And I set field "elanzahl" to "1" in row 3
And I set field "tnwpflicht" to "ja" in row 3
And I set field "tverschlt" to "ja" in row 3
And I create a new row at the end of the table
And I set field "elex" to "A AG4" in row 4
And I save the current editor

# Rechnung anlegen
Given I open an editor "rechnung" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "lief" to "1"
And I set field "num4" to "628-RE"
And I set field "fakt" to "ja"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I create a new row at the end of the table
And I set field "artex" to "E1-628" in row 1
And I set field "mge" to "628" in row 1
And I set field "preis" to "628" in row 1
And I set field "platz" to "F2" in row 1
And I create a new row at the end of the table
And I set field "artex" to "E2-628" in row 2
And I set field "mge" to "628" in row 2
And I set field "preis" to "628" in row 2
And I set field "platz" to "F2" in row 2
And I set field "kenn" to "FALL-628"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Charge anlegen
Given I open an editor "charge" from table "(Lots):(Lots)" with command "STORE" for record "FALL-628"
And I set field "such" to "FALL-628"
And I set field "exnum" to "FALL-628"
And I set field "artikel" to id from editor "serartikel-628"
And I save the current editor

# Serviceprodukt als Kunden- und Leihgeraet anlegen
Given I open an editor "kundeng-628" from table "(ServiceProduct):(ServiceProduct)" with command "STORE" for record "KGSP-628"
And I set field "such" to "KGSP-628"
And I set field "namebspr" to "KGSP-628"
And I set field "artikel" to id from editor "serartikel-628"
And I save the current editor
And I switch the current editor to editor "kundeng-628"
And I set field "serprodtyp" to "Kundengerät"
And I set field "zuplatzlg" to ""
And I set field "abplatzlg" to ""
And I set field "charge" to ""
And I save the current editor

# Serviceprodukt Auftrag erfassen 
Given I open an editor "auftrag-628" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set field "kunde" to id from editor "kunde"
And I set field "nummer" to "628-AU"
And I set field "such" to "FALL-628"
And I create a new row at the end of the table
And I set field "artikel" to id from editor "serartikel-628" in row 1
And I set field "mge" to "1" in row 1
And I set field "serprod" to id from editor "kundeng-628" in row 1
And I set field "verw" to "628" in row 1
And I save the current editor

#Disposition starten
And I run Scheduling

#Fertigungsvorschlaege zu BA freigeben
Given I open the infosystem "PRODLIST"
And I set field "kart" to id from editor "BG-628"
And I press start
And I press button "release" in row 1
And I close the current editor

Given I open the infosystem "PRODLIST"
And I set field "kart" to id from editor "serartikel-628"
And I press start
And I press button "release" in row 1
And I close the current editor

#BAs rueckmelden
Given I open an editor "rueckmelden" from table "(Workorder):(WorkOrders)" with command "DONE" for record "$,,artikel=BG-628;verw=628;typ==(WorkSlips);@maxtreffer=1;@richtung=V;"
And I set field "gut" to "ja"
And I set field "sofort" to "ja"
And I save the current editor

#BAs rueckmelden
Given I open an editor "rueckmelden" from table "(Workorder):(WorkOrders)" with command "DONE" for record "$,,artikel=BG-628;verw=628;typ==(WorkSlips);@maxtreffer=1;@richtung=R;"
And I set field "gut" to "ja"
And I set field "sofort" to "ja"
And I save the current editor

Given I open an editor "rueckmelden" from table "(Workorder):(WorkOrders)" with command "DONE" for record "$,,artikel=FALL-628;verw=628;typ==(WorkSlips);@maxtreffer=1;@richtung=V;"
And I set field "gut" to "ja"
And I set field "sofort" to "ja"
And I save the current editor

Given I open an editor "rueckmelden" from table "(Workorder):(WorkOrders)" with command "DONE" for record "$,,artikel=FALL-628;verw=628;typ==(WorkSlips);@maxtreffer=1;@richtung=R;"
And I set field "gut" to "ja"
And I set field "sofort" to "ja"
And I save the current editor

# Lieferschein erzeugen und buchen
Given I open an editor "lieferschein-628" from table "(Sales):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "auftrag-628"
And I set field "nummer" to "628-LS"
And I set field "such" to "LS-628"
And I set field "ueb" to "ja"
And I set field "mge" to "1" in row 1
And I save the current editor

# Ausgabe Lieferschein
Given I open an editor "Lieferschein-view" from table "(Sales):(PackingSlip)" with command "VIEW" for record from editor "lieferschein-628"
And I close the current editor

# Serviceauftrag erstellen 
Given I open an editor "serauftrag-628" from table "(Sales):(ServiceOrder)" with command "NEW" for record ""
And I set field "kunde" to id from editor "kunde"
And I set field "vserprod" to id from editor "kundeng-628"
And I set field "nummer" to "628-SAU"
And I set field "such" to "SAU-628"
And I create a new row at the end of the table
And I set field "artikel" to id from editor "dienstl" in row 1
And I set field "mge" to "1" in row 1
And I set field "zzvon" to "8" in row 1
And I set field "zzbis" to "12" in row 1
And I create a new row at the end of the table
And I set field "artikel" to "E2-628" in row 2
And I set field "mge" to "1" in row 2
And I save the current editor

# Ausgabe Serviceauftrag
Given I open an editor "Serviceauftrag-view" from table "(Sales):(ServiceOrder)" with command "VIEW" for record from editor "serauftrag-628"
And I close the current editor

#Fall 628 - Lieferschein erzeugen und buchen
Given I open an editor "lieferschein-628-2" from table "(Sales):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "serauftrag-628"
And I set field "nummer" to "628-LS2"
And I set field "such" to "LS-628-2"
And I set field "ueb" to "ja"
# And I set field "mge" to "1" in row 1
And I set field "mge" to "1" in row 2
And I save the current editor

# Ausgabe Lieferschein
Given I open an editor "Lieferschein-view" from table "(Sales):(PackingSlip)" with command "VIEW" for record from editor "lieferschein-628-2"
And I close the current editor

# Rechnung zu Lieferschein anlegen
Given I open an editor "rechnung1-628" from table "(Sales):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "lieferschein-628"
And I set field "num3" to "628-RE"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "preis" to "628" in row 1
And I set field "kenn" to "FALL-628"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Rücklieferschein anlegen
Given I open an editor "Ruecklieferschein-628" from table "(Sales):(PackingSlip)" with command "RETURN" for record from editor "lieferschein-628"
And I set field "num3" to "628-RLS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "-1" in row 1
And I set field "platz" to "F1" in row 1
And I set field "kenn" to "FALL-628 Ruecklieferschein"
#And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Ausgabe Rücklieferschein
Given I open an editor "Lieferschein-view" from table "(Sales):(PackingSlip)" with command "VIEW" for record from editor "Ruecklieferschein-628"
And I close the current editor

# Gutschrift anlegen
Given I open an editor "Gutschrift-628" from table "(Sales):(Invoice)" with command "COPY" for record from editor "Ruecklieferschein-628"
And I set field "nummer" to "628-GS"
And I set field "such" to "GS-628"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "kenn" to "FALL-628"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Ausgabe Gutschrift
Given I open an editor "Gutschrift-view" from table "(Sales):(Invoice)" with command "VIEW" for record from editor "Gutschrift-628"
And I close the current editor
 
#####################################################################################################################################

Scenario: FALL-629
# FALL-629

# STAMMDATEN - E1 kopieren
Given I open an editor "E1-629" from table "(Part):(Product)" with command "COPY" for record "E1"
And I set field "such" to "E1-629"
And I set field "losgr" to "0"
And I set field "mindest" to "0"
And I save the current editor
# STAMMDATEN - E2 kopieren
Given I open an editor "E2-629" from table "(Part):(Product)" with command "COPY" for record "E2"
And I set field "such" to "E2-629"
And I set field "losgr" to "0"
And I set field "mindest" to "0"
And I save the current editor

# STAMMDATEN - BG1 kopieren
Given I open an editor "BG-629" from table "(Part):(Product)" with command "COPY" for record "BG1"
And I set field "such" to "BG-629"
And I set field "dispoa" to "Auftragsbezogen"
And I set field "mindest" to "0"
And I set field "elex" to "E1-629" in row 1
And I set field "tnwpflicht" to "ja" in row 1
And I save the current editor

# STAMMDATEN - Servicepflichtigen Artikel anlegen
Given I open an editor "serartikel-629" from table "(Part):(Product)" with command "STORE" for record ""
And I set field "such" to "FALL-629"
And I set field "namebspr" to "Service Artikel 629"
And I set field "vkbez" to "Service Artikel 629"
And I set field "vbez" to "Service Artikel 629"
And I set field "ebez" to "Service Artikel 629"
And I set field "vpr" to "1000"
And I set field "bsart" to "Eigenfertigung"
And I set field "dispoa" to "Auftragsbezogen"
And I set field "chimlager" to "ja"
And I set field "serpflicht" to "ja"
#Stückliste anlegen
And I create a new row at the end of the table
And I set field "elex" to "E2-629" in row 1
And I set field "elanzahl" to "2" in row 1
And I set field "tnwpflicht" to "ja" in row 1
And I set field "tersatzt" to "ja" in row 1
And I create a new row at the end of the table
And I set field "elex" to "A AG3" in row 2
And I create a new row at the end of the table
And I set field "elex" to "BG-629" in row 3
And I set field "elanzahl" to "1" in row 3
And I set field "tnwpflicht" to "ja" in row 3
And I set field "tverschlt" to "ja" in row 3
And I create a new row at the end of the table
And I set field "elex" to "A AG4" in row 4
And I save the current editor

# Rechnung anlegen
Given I open an editor "rechnung" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "lief" to "1"
And I set field "num4" to "629-RE"
And I set field "fakt" to "ja"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I create a new row at the end of the table
And I set field "artex" to "E1-629" in row 1
And I set field "mge" to "629" in row 1
And I set field "preis" to "629" in row 1
And I set field "platz" to "F2" in row 1
And I create a new row at the end of the table
And I set field "artex" to "E2-629" in row 2
And I set field "mge" to "629" in row 2
And I set field "preis" to "629" in row 2
And I set field "platz" to "F2" in row 2
And I set field "kenn" to "FALL-629"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Charge anlegen
Given I open an editor "charge" from table "(Lots):(Lots)" with command "STORE" for record "FALL-629"
And I set field "such" to "FALL-629"
And I set field "exnum" to "FALL-629"
And I set field "artikel" to id from editor "serartikel-629"
And I save the current editor

# Serviceprodukt als Kunden- und Leihgeraet anlegen
Given I open an editor "kundeng-629" from table "(ServiceProduct):(ServiceProduct)" with command "STORE" for record "KGSP-629"
And I set field "such" to "KGSP-629"
And I set field "namebspr" to "KGSP-629"
And I set field "artikel" to id from editor "serartikel-629"
And I save the current editor
And I switch the current editor to editor "kundeng-629"
And I set field "serprodtyp" to "Kundengerät"
And I set field "zuplatzlg" to ""
And I set field "abplatzlg" to ""
And I set field "charge" to ""
And I save the current editor

# Serviceprodukt Auftrag erfassen 
Given I open an editor "auftrag-629" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set field "kunde" to id from editor "kunde"
And I set field "nummer" to "629-AU"
And I set field "such" to "FALL-629"
And I create a new row at the end of the table
And I set field "artikel" to id from editor "serartikel-629" in row 1
And I set field "mge" to "1" in row 1
And I set field "serprod" to id from editor "kundeng-629" in row 1
And I set field "verw" to "629" in row 1
And I save the current editor

#Disposition starten
And I run Scheduling

#Fertigungsvorschlaege zu BA freigeben
Given I open the infosystem "PRODLIST"
And I set field "kart" to id from editor "BG-629"
And I press start
And I press button "release" in row 1
And I close the current editor

Given I open the infosystem "PRODLIST"
And I set field "kart" to id from editor "serartikel-629"
And I press start
And I press button "release" in row 1
And I close the current editor

#BAs rueckmelden
Given I open an editor "rueckmelden" from table "(Workorder):(WorkOrders)" with command "DONE" for record "$,,artikel=BG-629;verw=629;typ==(WorkSlips);@maxtreffer=1;@richtung=V;"
And I set field "gut" to "ja"
And I set field "sofort" to "ja"
And I save the current editor

#BAs rueckmelden
Given I open an editor "rueckmelden" from table "(Workorder):(WorkOrders)" with command "DONE" for record "$,,artikel=BG-629;verw=629;typ==(WorkSlips);@maxtreffer=1;@richtung=R;"
And I set field "gut" to "ja"
And I set field "sofort" to "ja"
And I save the current editor

Given I open an editor "rueckmelden" from table "(Workorder):(WorkOrders)" with command "DONE" for record "$,,artikel=FALL-629;verw=629;typ==(WorkSlips);@maxtreffer=1;@richtung=V;"
And I set field "gut" to "ja"
And I set field "sofort" to "ja"
And I save the current editor

Given I open an editor "rueckmelden" from table "(Workorder):(WorkOrders)" with command "DONE" for record "$,,artikel=FALL-629;verw=629;typ==(WorkSlips);@maxtreffer=1;@richtung=R;"
And I set field "gut" to "ja"
And I set field "sofort" to "ja"
And I save the current editor

#Fall 629 - Lieferschein erzeugen und buchen
Given I open an editor "lieferschein-629" from table "(Sales):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "auftrag-629"
And I set field "nummer" to "629-LS"
And I set field "such" to "LS-629"
And I set field "ueb" to "ja"
And I set field "mge" to "1" in row 1
And I save the current editor

# Ausgabe Lieferschein
Given I open an editor "Lieferschein-view" from table "(Sales):(PackingSlip)" with command "VIEW" for record from editor "lieferschein-629"
And I close the current editor

# Lieferschein rueckliefern und buchen
Given I open an editor "r-lieferschein-629" from table "(Sales):(PackingSlip)" with command "RETURN" for record from editor "lieferschein-629"
And I set field "nummer" to "629-RLS"
And I set field "such" to "RLS-629"
And I set field "ueb" to "ja"
Then the table has 1 rows
And I set field "mge" to "-1" in row 1
And I set field "rerelev" to "ja" in row 1
And I save the current editor

# Ausgabe Rücklieferschein
Given I open an editor "Lieferschein-view" from table "(Sales):(PackingSlip)" with command "VIEW" for record from editor "r-lieferschein-629"
And I close the current editor

# Ruecklieferung stornieren
Given I open an editor "srlieferschein-629" from table "(Sales):(PackingSlip)" with command "REVERSAL" for record from editor "r-lieferschein-629"
And I set field "nummer" to "629-SRL"
And I save the current editor

# Ausgabe Storno Rücklieferschein
Given I open an editor "Rechnung-storno-view" from table "(Sales):(PackingSlip)" with command "VIEW" for record from editor "srlieferschein-629"
And I close the current editor

#####################################################################################################################################

Scenario: FALL-633
# FALL-633

# STAMMDATEN - E1 kopieren
Given I open an editor "E1-633" from table "(Part):(Product)" with command "COPY" for record "E1"
And I set field "such" to "E1-633"
And I set field "losgr" to "0"
And I set field "mindest" to "0"
And I save the current editor
# STAMMDATEN - E2 kopieren
Given I open an editor "E2-633" from table "(Part):(Product)" with command "COPY" for record "E2"
And I set field "such" to "E2-633"
And I set field "losgr" to "0"
And I set field "mindest" to "0"
And I save the current editor

# STAMMDATEN - BG1 kopieren
Given I open an editor "BG-633" from table "(Part):(Product)" with command "COPY" for record "BG1"
And I set field "such" to "BG-633"
And I set field "dispoa" to "Auftragsbezogen"
And I set field "mindest" to "0"
And I set field "elex" to "E1-633" in row 1
And I set field "tnwpflicht" to "ja" in row 1
And I save the current editor

# STAMMDATEN - Servicepflichtigen Artikel anlegen
Given I open an editor "serartikel-633" from table "(Part):(Product)" with command "STORE" for record ""
And I set field "such" to "FALL-633"
And I set field "namebspr" to "Service Artikel 633"
And I set field "vkbez" to "Service Artikel 633"
And I set field "vbez" to "Service Artikel 633"
And I set field "ebez" to "Service Artikel 633"
And I set field "vpr" to "1000"
And I set field "bsart" to "Eigenfertigung"
And I set field "dispoa" to "Auftragsbezogen"
And I set field "chimlager" to "ja"
And I set field "serpflicht" to "ja"
#Stückliste anlegen
And I create a new row at the end of the table
And I set field "elex" to "E2-633" in row 1
And I set field "elanzahl" to "2" in row 1
And I set field "tnwpflicht" to "ja" in row 1
And I set field "tersatzt" to "ja" in row 1
And I create a new row at the end of the table
And I set field "elex" to "A AG3" in row 2
And I create a new row at the end of the table
And I set field "elex" to "BG-633" in row 3
And I set field "elanzahl" to "1" in row 3
And I set field "tnwpflicht" to "ja" in row 3
And I set field "tverschlt" to "ja" in row 3
And I create a new row at the end of the table
And I set field "elex" to "A AG4" in row 4
And I save the current editor

# Rechnung anlegen
Given I open an editor "rechnung" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "lief" to "1"
And I set field "num4" to "633-RE"
And I set field "fakt" to "ja"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I create a new row at the end of the table
And I set field "artex" to "E1-633" in row 1
And I set field "mge" to "633" in row 1
And I set field "preis" to "633" in row 1
And I set field "platz" to "F2" in row 1
And I create a new row at the end of the table
And I set field "artex" to "E2-633" in row 2
And I set field "mge" to "633" in row 2
And I set field "preis" to "633" in row 2
And I set field "platz" to "F2" in row 2
And I set field "kenn" to "FALL-633"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Charge anlegen
Given I open an editor "charge" from table "(Lots):(Lots)" with command "STORE" for record "FALL-633"
And I set field "such" to "FALL-633"
And I set field "exnum" to "FALL-633"
And I set field "artikel" to id from editor "serartikel-633"
And I save the current editor

# Serviceprodukt als Kunden- und Leihgeraet anlegen
Given I open an editor "kundeng-633" from table "(ServiceProduct):(ServiceProduct)" with command "STORE" for record "KGSP-633"
And I set field "such" to "KGSP-633"
And I set field "namebspr" to "KGSP-633"
And I set field "artikel" to id from editor "serartikel-633"
And I save the current editor
And I switch the current editor to editor "kundeng-633"
And I set field "serprodtyp" to "Kundengerät"
And I set field "zuplatzlg" to ""
And I set field "abplatzlg" to ""
And I set field "charge" to ""
And I save the current editor

# Serviceprodukt Auftrag erfassen 
Given I open an editor "auftrag-633" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set field "kunde" to id from editor "kunde"
And I set field "nummer" to "633-AU"
And I set field "such" to "FALL-633"
And I create a new row at the end of the table
And I set field "artikel" to id from editor "serartikel-633" in row 1
And I set field "mge" to "1" in row 1
And I set field "serprod" to id from editor "kundeng-633" in row 1
And I set field "verw" to "633" in row 1
And I save the current editor

#Disposition starten
And I run Scheduling

#Fertigungsvorschlaege zu BA freigeben
Given I open the infosystem "PRODLIST"
And I set field "kart" to id from editor "BG-633"
And I press start
And I press button "release" in row 1
And I close the current editor

Given I open the infosystem "PRODLIST"
And I set field "kart" to id from editor "serartikel-633"
And I press start
And I press button "release" in row 1
And I close the current editor

#BAs rueckmelden
Given I open an editor "rueckmelden" from table "(Workorder):(WorkOrders)" with command "DONE" for record "$,,artikel=BG-633;verw=633;typ==(WorkSlips);@maxtreffer=1;@richtung=V;"
And I set field "gut" to "ja"
And I set field "sofort" to "ja"
And I save the current editor

#BAs rueckmelden
Given I open an editor "rueckmelden" from table "(Workorder):(WorkOrders)" with command "DONE" for record "$,,artikel=BG-633;verw=633;typ==(WorkSlips);@maxtreffer=1;@richtung=R;"
And I set field "gut" to "ja"
And I set field "sofort" to "ja"
And I save the current editor

Given I open an editor "rueckmelden" from table "(Workorder):(WorkOrders)" with command "DONE" for record "$,,artikel=FALL-633;verw=633;typ==(WorkSlips);@maxtreffer=1;@richtung=V;"
And I set field "gut" to "ja"
And I set field "sofort" to "ja"
And I save the current editor

Given I open an editor "rueckmelden" from table "(Workorder):(WorkOrders)" with command "DONE" for record "$,,artikel=FALL-633;verw=633;typ==(WorkSlips);@maxtreffer=1;@richtung=R;"
And I set field "gut" to "ja"
And I set field "sofort" to "ja"
And I save the current editor

# Lieferschein erzeugen und buchen
Given I open an editor "lieferschein-633" from table "(Sales):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "auftrag-633"
And I set field "nummer" to "633-LS"
And I set field "such" to "LS-633"
And I set field "ueb" to "ja"
And I set field "mge" to "1" in row 1
And I save the current editor

# Ausgabe Lieferschein
Given I open an editor "Lieferschein-view" from table "(Sales):(PackingSlip)" with command "VIEW" for record from editor "lieferschein-633"
And I close the current editor

# Serviceauftrag erstellen 
Given I open an editor "serauftrag-633" from table "(Sales):(ServiceOrder)" with command "NEW" for record ""
And I set field "kunde" to id from editor "kunde"
And I set field "vserprod" to id from editor "kundeng-633"
And I set field "nummer" to "633-SAU"
And I set field "such" to "SAU-633"
And I create a new row at the end of the table
And I set field "artikel" to id from editor "dienstl" in row 1
And I set field "mge" to "1" in row 1
And I set field "zzvon" to "8" in row 1
And I set field "zzbis" to "12" in row 1
And I create a new row at the end of the table
And I set field "artikel" to "E2" in row 2
And I set field "mge" to "1" in row 2
And I save the current editor

# Ausgabe Serviceauftrag
Given I open an editor "Serviceauftrag-view" from table "(Sales):(ServiceOrder)" with command "VIEW" for record from editor "serauftrag-633"
And I close the current editor


#####################################################################################################################################

Scenario: FALL-634
# FALL-634

# STAMMDATEN - E1 kopieren
Given I open an editor "E1-634" from table "(Part):(Product)" with command "COPY" for record "E1"
And I set field "such" to "E1-634"
And I set field "losgr" to "0"
And I set field "mindest" to "0"
And I save the current editor
# STAMMDATEN - E2 kopieren
Given I open an editor "E2-634" from table "(Part):(Product)" with command "COPY" for record "E2"
And I set field "such" to "E2-634"
And I set field "losgr" to "0"
And I set field "mindest" to "0"
And I save the current editor

# STAMMDATEN - BG1 kopieren
Given I open an editor "BG-634" from table "(Part):(Product)" with command "COPY" for record "BG1"
And I set field "such" to "BG-634"
And I set field "dispoa" to "Auftragsbezogen"
And I set field "mindest" to "0"
And I set field "elex" to "E1-634" in row 1
And I set field "tnwpflicht" to "ja" in row 1
And I save the current editor

# STAMMDATEN - Servicepflichtigen Artikel anlegen
Given I open an editor "serartikel-634" from table "(Part):(Product)" with command "STORE" for record ""
And I set field "such" to "FALL-634"
And I set field "namebspr" to "Service Artikel 634"
And I set field "vkbez" to "Service Artikel 634"
And I set field "vbez" to "Service Artikel 634"
And I set field "ebez" to "Service Artikel 634"
And I set field "vpr" to "1000"
And I set field "bsart" to "Eigenfertigung"
And I set field "dispoa" to "Auftragsbezogen"
And I set field "chimlager" to "ja"
And I set field "serpflicht" to "ja"
#Stückliste anlegen
And I create a new row at the end of the table
And I set field "elex" to "E2-634" in row 1
And I set field "elanzahl" to "2" in row 1
And I set field "tnwpflicht" to "ja" in row 1
And I set field "tersatzt" to "ja" in row 1
And I create a new row at the end of the table
And I set field "elex" to "A AG3" in row 2
And I create a new row at the end of the table
And I set field "elex" to "BG-634" in row 3
And I set field "elanzahl" to "1" in row 3
And I set field "tnwpflicht" to "ja" in row 3
And I set field "tverschlt" to "ja" in row 3
And I create a new row at the end of the table
And I set field "elex" to "A AG4" in row 4
And I save the current editor

# Rechnung anlegen
Given I open an editor "rechnung" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "lief" to "1"
And I set field "num4" to "634-RE"
And I set field "fakt" to "ja"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I create a new row at the end of the table
And I set field "artex" to "E1-634" in row 1
And I set field "mge" to "634" in row 1
And I set field "preis" to "634" in row 1
And I set field "platz" to "F2" in row 1
And I create a new row at the end of the table
And I set field "artex" to "E2-634" in row 2
And I set field "mge" to "634" in row 2
And I set field "preis" to "634" in row 2
And I set field "platz" to "F2" in row 2
And I set field "kenn" to "FALL-634"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Charge anlegen
Given I open an editor "charge" from table "(Lots):(Lots)" with command "STORE" for record "FALL-634"
And I set field "such" to "FALL-634"
And I set field "exnum" to "FALL-634"
And I set field "artikel" to id from editor "serartikel-634"
And I save the current editor

# Serviceprodukt als Kunden- und Leihgeraet anlegen
Given I open an editor "kundeng-634" from table "(ServiceProduct):(ServiceProduct)" with command "STORE" for record "KGSP-634"
And I set field "such" to "KGSP-634"
And I set field "namebspr" to "KGSP-634"
And I set field "artikel" to id from editor "serartikel-634"
And I save the current editor
And I switch the current editor to editor "kundeng-634"
And I set field "serprodtyp" to "Kundengerät"
And I set field "zuplatzlg" to ""
And I set field "abplatzlg" to ""
And I set field "charge" to ""
And I save the current editor

# Serviceauftrag erstellen 
Given I open an editor "serauftrag-634" from table "(Sales):(ServiceOrder)" with command "NEW" for record ""
And I set field "kunde" to id from editor "kunde"
And I set field "vserprod" to id from editor "kundeng-634"
And I set field "nummer" to "634-SAU"
And I set field "such" to "SAU-634"
And I create a new row at the end of the table
And I set field "techniker" to id from editor "techniker" in row 1
And I set field "artikel" to id from editor "dienstl" in row 1
And I set field "mge" to "1" in row 1
And I set field "zzvon" to "8" in row 1
And I set field "zzbis" to "12" in row 1
And I create a new row at the end of the table
And I set field "techniker" to id from editor "techniker" in row 2
And I set field "artikel" to "E2-634" in row 2
And I set field "mge" to "1" in row 2
And I save the current editor

# Ausgabe Serviceauftrag
Given I open an editor "Serviceauftrag-view" from table "(Sales):(ServiceOrder)" with command "VIEW" for record from editor "serauftrag-634"
And I close the current editor

#####################################################################################################################################

Scenario: FALL-635
# FALL-635

# STAMMDATEN - E1 kopieren
Given I open an editor "E1-635" from table "(Part):(Product)" with command "COPY" for record "E1"
And I set field "such" to "E1-635"
And I set field "losgr" to "0"
And I set field "mindest" to "0"
And I save the current editor
# STAMMDATEN - E2 kopieren
Given I open an editor "E2-635" from table "(Part):(Product)" with command "COPY" for record "E2"
And I set field "such" to "E2-635"
And I set field "losgr" to "0"
And I set field "mindest" to "0"
And I save the current editor

# STAMMDATEN - BG1 kopieren
Given I open an editor "BG-635" from table "(Part):(Product)" with command "COPY" for record "BG1"
And I set field "such" to "BG-635"
And I set field "dispoa" to "Auftragsbezogen"
And I set field "mindest" to "0"
And I set field "elex" to "E1-635" in row 1
And I set field "tnwpflicht" to "ja" in row 1
And I save the current editor

# STAMMDATEN - Servicepflichtigen Artikel anlegen
Given I open an editor "serartikel-635" from table "(Part):(Product)" with command "STORE" for record ""
And I set field "such" to "FALL-635"
And I set field "namebspr" to "Service Artikel 635"
And I set field "vkbez" to "Service Artikel 635"
And I set field "vbez" to "Service Artikel 635"
And I set field "ebez" to "Service Artikel 635"
And I set field "vpr" to "1000"
And I set field "bsart" to "Eigenfertigung"
And I set field "dispoa" to "Auftragsbezogen"
And I set field "chimlager" to "ja"
And I set field "serpflicht" to "ja"
#Stückliste anlegen
And I create a new row at the end of the table
And I set field "elex" to "E2-635" in row 1
And I set field "elanzahl" to "2" in row 1
And I set field "tnwpflicht" to "ja" in row 1
And I set field "tersatzt" to "ja" in row 1
And I create a new row at the end of the table
And I set field "elex" to "A AG3" in row 2
And I create a new row at the end of the table
And I set field "elex" to "BG-635" in row 3
And I set field "elanzahl" to "1" in row 3
And I set field "tnwpflicht" to "ja" in row 3
And I set field "tverschlt" to "ja" in row 3
And I create a new row at the end of the table
And I set field "elex" to "A AG4" in row 4
And I save the current editor

# Rechnung anlegen
Given I open an editor "rechnung" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "lief" to "1"
And I set field "num4" to "635-RE"
And I set field "fakt" to "ja"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I create a new row at the end of the table
And I set field "artex" to "E1-635" in row 1
And I set field "mge" to "635" in row 1
And I set field "preis" to "635" in row 1
And I set field "platz" to "F2" in row 1
And I create a new row at the end of the table
And I set field "artex" to "E2-635" in row 2
And I set field "mge" to "635" in row 2
And I set field "preis" to "635" in row 2
And I set field "platz" to "F2" in row 2
And I set field "kenn" to "FALL-635"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Charge anlegen
Given I open an editor "charge" from table "(Lots):(Lots)" with command "STORE" for record "FALL-635"
And I set field "such" to "FALL-635"
And I set field "exnum" to "FALL-635"
And I set field "artikel" to id from editor "serartikel-635"
And I save the current editor

# Serviceprodukt als Kunden- und Leihgeraet anlegen
Given I open an editor "kundeng-635" from table "(ServiceProduct):(ServiceProduct)" with command "STORE" for record "KGSP-635"
And I set field "such" to "KGSP-635"
And I set field "namebspr" to "KGSP-635"
And I set field "artikel" to id from editor "serartikel-635"
And I save the current editor
And I switch the current editor to editor "kundeng-635"
And I set field "serprodtyp" to "Kundengerät"
And I set field "zuplatzlg" to ""
And I set field "abplatzlg" to ""
And I set field "charge" to ""
And I save the current editor

# Serviceauftrag erstellen 
Given I open an editor "serauftrag-635" from table "(Sales):(ServiceOrder)" with command "NEW" for record ""
And I set field "kunde" to id from editor "kunde"
And I set field "vserprod" to id from editor "kundeng-635"
And I set field "nummer" to "635-SAU"
And I set field "such" to "SAU-635"
And I create a new row at the end of the table
And I set field "techniker" to id from editor "techniker" in row 1
And I set field "artikel" to id from editor "dienstl" in row 1
And I set field "mge" to "1" in row 1
And I set field "zzvon" to "8" in row 1
And I set field "zzbis" to "12" in row 1
And I create a new row at the end of the table
And I set field "techniker" to id from editor "techniker" in row 2
And I set field "artikel" to "E2-635" in row 2
And I set field "mge" to "1" in row 2
And I save the current editor

# Ausgabe Serviceauftrag
Given I open an editor "Serviceauftrag-view" from table "(Sales):(ServiceOrder)" with command "VIEW" for record from editor "serauftrag-635"
And I close the current editor

#Fall 635 - Servicerueckmeldung durchfuehren
Given I open an editor "srmeldung-635" from table "(ServiceReservation):(EngineerCompletionConfirmations)" with command "NEW" for record ""
And I set field "techniker" to id from editor "techniker"
And I set field "servau" to id from editor "serauftrag-635"
And I press button "ladetab"
Then the table has 2 rows
And I set field "buchen" to "ja" in row 1
And I set field "dauer" to "4h" in row 1
And I set field "buchen" to "ja" in row 2
And I set field "serstlsts" to "wird aktualisiert" in row 2
And I save the current editor

#Lieferschein erzeugen und buchen
Given I open an editor "lieferschein-635" from table "(Sales):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "serauftrag-635"
And I set field "nummer" to "635-LS"
And I set field "such" to "LS-635"
And I set field "ueb" to "ja"
Then the table has 1 rows
And I set field "mge" to "1" in row 1
And I save the current editor

# Ausgabe Lieferschein
Given I open an editor "Lieferschein-view" from table "(Sales):(PackingSlip)" with command "VIEW" for record from editor "lieferschein-635"
And I close the current editor

#####################################################################################################################################

Scenario: FALL-636
# FALL-636

# STAMMDATEN - E1 kopieren
Given I open an editor "E1-636" from table "(Part):(Product)" with command "COPY" for record "E1"
And I set field "such" to "E1-636"
And I set field "losgr" to "0"
And I set field "mindest" to "0"
And I save the current editor
# STAMMDATEN - E2 kopieren
Given I open an editor "E2-636" from table "(Part):(Product)" with command "COPY" for record "E2"
And I set field "such" to "E2-636"
And I set field "losgr" to "0"
And I set field "mindest" to "0"
And I save the current editor

# STAMMDATEN - BG1 kopieren
Given I open an editor "BG-636" from table "(Part):(Product)" with command "COPY" for record "BG1"
And I set field "such" to "BG-636"
And I set field "dispoa" to "Auftragsbezogen"
And I set field "mindest" to "0"
And I set field "elex" to "E1-636" in row 1
And I set field "tnwpflicht" to "ja" in row 1
And I save the current editor

# STAMMDATEN - Servicepflichtigen Artikel anlegen
Given I open an editor "serartikel-636" from table "(Part):(Product)" with command "STORE" for record ""
And I set field "such" to "FALL-636"
And I set field "namebspr" to "Service Artikel 636"
And I set field "vkbez" to "Service Artikel 636"
And I set field "vbez" to "Service Artikel 636"
And I set field "ebez" to "Service Artikel 636"
And I set field "vpr" to "1000"
And I set field "bsart" to "Eigenfertigung"
And I set field "dispoa" to "Auftragsbezogen"
And I set field "chimlager" to "ja"
And I set field "serpflicht" to "ja"
#Stückliste anlegen
And I create a new row at the end of the table
And I set field "elex" to "E2-636" in row 1
And I set field "elanzahl" to "2" in row 1
And I set field "tnwpflicht" to "ja" in row 1
And I set field "tersatzt" to "ja" in row 1
And I create a new row at the end of the table
And I set field "elex" to "A AG3" in row 2
And I create a new row at the end of the table
And I set field "elex" to "BG-636" in row 3
And I set field "elanzahl" to "1" in row 3
And I set field "tnwpflicht" to "ja" in row 3
And I set field "tverschlt" to "ja" in row 3
And I create a new row at the end of the table
And I set field "elex" to "A AG4" in row 4
And I save the current editor

# Rechnung anlegen
Given I open an editor "rechnung" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "lief" to "1"
And I set field "num4" to "636-RE"
And I set field "fakt" to "ja"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I create a new row at the end of the table
And I set field "artex" to "E1-636" in row 1
And I set field "mge" to "636" in row 1
And I set field "preis" to "636" in row 1
And I set field "platz" to "F2" in row 1
And I create a new row at the end of the table
And I set field "artex" to "E2-636" in row 2
And I set field "mge" to "636" in row 2
And I set field "preis" to "636" in row 2
And I set field "platz" to "F2" in row 2
And I set field "kenn" to "FALL-636"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Charge anlegen
Given I open an editor "charge" from table "(Lots):(Lots)" with command "STORE" for record "FALL-636"
And I set field "such" to "FALL-636"
And I set field "exnum" to "FALL-636"
And I set field "artikel" to id from editor "serartikel-636"
And I save the current editor

# Serviceprodukt als Kunden- und Leihgeraet anlegen
Given I open an editor "kundeng-636" from table "(ServiceProduct):(ServiceProduct)" with command "STORE" for record "KGSP-636"
And I set field "such" to "KGSP-636"
And I set field "namebspr" to "KGSP-636"
And I set field "artikel" to id from editor "serartikel-636"
And I save the current editor
And I switch the current editor to editor "kundeng-636"
And I set field "serprodtyp" to "Kundengerät"
And I set field "zuplatzlg" to ""
And I set field "abplatzlg" to ""
And I set field "charge" to ""
And I save the current editor

# Serviceauftrag erstellen 
Given I open an editor "serauftrag-636" from table "(Sales):(ServiceOrder)" with command "NEW" for record ""
And I set field "kunde" to id from editor "kunde"
And I set field "vserprod" to id from editor "kundeng-636"
And I set field "nummer" to "636-SAU"
And I set field "such" to "SAU-636"
And I create a new row at the end of the table
And I set field "techniker" to id from editor "techniker" in row 1
And I set field "artikel" to id from editor "dienstl" in row 1
And I set field "mge" to "1" in row 1
And I set field "zzvon" to "8" in row 1
And I set field "zzbis" to "12" in row 1
And I create a new row at the end of the table
And I set field "techniker" to id from editor "techniker" in row 2
And I set field "artikel" to "E2-636" in row 2
And I set field "mge" to "1" in row 2
And I save the current editor

# Ausgabe Serviceauftrag
Given I open an editor "Serviceauftrag-view" from table "(Sales):(ServiceOrder)" with command "VIEW" for record from editor "serauftrag-636"
And I close the current editor

#Fall 636 - Servicerueckmeldung durchfuehren
Given I open an editor "srmeldung-636" from table "(ServiceReservation):(EngineerCompletionConfirmations)" with command "NEW" for record ""
And I set field "techniker" to id from editor "techniker"
And I set field "servau" to id from editor "serauftrag-636"
And I press button "ladetab"
Then the table has 2 rows
And I set field "buchen" to "ja" in row 1
And I set field "dauer" to "4h" in row 1
And I set field "buchen" to "ja" in row 2
And I set field "serstlsts" to "wird aktualisiert" in row 2
And I save the current editor

#Lieferschein erzeugen und buchen
Given I open an editor "lieferschein-636" from table "(Sales):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "serauftrag-636"
And I set field "nummer" to "636-LS"
And I set field "such" to "LS-636"
And I set field "ueb" to "ja"
Then the table has 1 rows
And I set field "mge" to "1" in row 1
And I save the current editor

# Ausgabe Lieferschein
Given I open an editor "Lieferschein-view" from table "(Sales):(PackingSlip)" with command "VIEW" for record from editor "lieferschein-636"
And I close the current editor

# Rücklieferschein anlegen
Given I open an editor "Ruecklieferschein-636" from table "(Sales):(PackingSlip)" with command "RETURN" for record from editor "lieferschein-636"
And I set field "num3" to "636-RLS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "-1" in row 1
And I set field "platz" to "F1" in row 1
And I set field "kenn" to "FALL-636 Ruecklieferschein"
#And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Ausgabe Rücklieferschein 
Given I open an editor "Rücklieferschein-view" from table "(Sales):(PackingSlip)" with command "VIEW" for record from editor "Ruecklieferschein-636"
And I close the current editor
 
#####################################################################################################################################

Scenario: FALL-637
# FALL-637

# STAMMDATEN - E1 kopieren
Given I open an editor "E1-637" from table "(Part):(Product)" with command "COPY" for record "E1"
And I set field "such" to "E1-637"
And I set field "losgr" to "0"
And I set field "mindest" to "0"
And I save the current editor
# STAMMDATEN - E2 kopieren
Given I open an editor "E2-637" from table "(Part):(Product)" with command "COPY" for record "E2"
And I set field "such" to "E2-637"
And I set field "losgr" to "0"
And I set field "mindest" to "0"
And I save the current editor

# STAMMDATEN - BG1 kopieren
Given I open an editor "BG-637" from table "(Part):(Product)" with command "COPY" for record "BG1"
And I set field "such" to "BG-637"
And I set field "dispoa" to "Auftragsbezogen"
And I set field "mindest" to "0"
And I set field "elex" to "E1-637" in row 1
And I set field "tnwpflicht" to "ja" in row 1
And I save the current editor

# STAMMDATEN - Servicepflichtigen Artikel anlegen
Given I open an editor "serartikel-637" from table "(Part):(Product)" with command "STORE" for record ""
And I set field "such" to "FALL-637"
And I set field "namebspr" to "Service Artikel 637"
And I set field "vkbez" to "Service Artikel 637"
And I set field "vbez" to "Service Artikel 637"
And I set field "ebez" to "Service Artikel 637"
And I set field "vpr" to "1000"
And I set field "bsart" to "Eigenfertigung"
And I set field "dispoa" to "Auftragsbezogen"
And I set field "chimlager" to "ja"
And I set field "serpflicht" to "ja"
#Stückliste anlegen
And I create a new row at the end of the table
And I set field "elex" to "E2-637" in row 1
And I set field "elanzahl" to "2" in row 1
And I set field "tnwpflicht" to "ja" in row 1
And I set field "tersatzt" to "ja" in row 1
And I create a new row at the end of the table
And I set field "elex" to "A AG3" in row 2
And I create a new row at the end of the table
And I set field "elex" to "BG-637" in row 3
And I set field "elanzahl" to "1" in row 3
And I set field "tnwpflicht" to "ja" in row 3
And I set field "tverschlt" to "ja" in row 3
And I create a new row at the end of the table
And I set field "elex" to "A AG4" in row 4
And I save the current editor

# Rechnung anlegen
Given I open an editor "rechnung" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "lief" to "1"
And I set field "num4" to "637-RE"
And I set field "fakt" to "ja"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I create a new row at the end of the table
And I set field "artex" to "E1-637" in row 1
And I set field "mge" to "637" in row 1
And I set field "preis" to "637" in row 1
And I set field "platz" to "F2" in row 1
And I create a new row at the end of the table
And I set field "artex" to "E2-637" in row 2
And I set field "mge" to "637" in row 2
And I set field "preis" to "637" in row 2
And I set field "platz" to "F2" in row 2
And I set field "kenn" to "FALL-637"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Charge anlegen
Given I open an editor "charge" from table "(Lots):(Lots)" with command "STORE" for record "FALL-637"
And I set field "such" to "FALL-637"
And I set field "exnum" to "FALL-637"
And I set field "artikel" to id from editor "serartikel-637"
And I save the current editor

# Serviceprodukt als Kunden- und Leihgeraet anlegen
Given I open an editor "kundeng-637" from table "(ServiceProduct):(ServiceProduct)" with command "STORE" for record "KGSP-637"
And I set field "such" to "KGSP-637"
And I set field "namebspr" to "KGSP-637"
And I set field "artikel" to id from editor "serartikel-637"
And I save the current editor
And I switch the current editor to editor "kundeng-637"
And I set field "serprodtyp" to "Kundengerät"
And I set field "zuplatzlg" to ""
And I set field "abplatzlg" to ""
And I set field "charge" to ""
And I save the current editor

# Serviceauftrag erstellen 
Given I open an editor "serauftrag-637" from table "(Sales):(ServiceOrder)" with command "NEW" for record ""
And I set field "kunde" to id from editor "kunde"
And I set field "vserprod" to id from editor "kundeng-637"
And I set field "nummer" to "637-SAU"
And I set field "such" to "SAU-637"
And I create a new row at the end of the table
And I set field "techniker" to id from editor "techniker" in row 1
And I set field "artikel" to id from editor "dienstl" in row 1
And I set field "mge" to "1" in row 1
And I set field "zzvon" to "8" in row 1
And I set field "zzbis" to "12" in row 1
And I create a new row at the end of the table
And I set field "techniker" to id from editor "techniker" in row 2
And I set field "artikel" to "E2-637" in row 2
And I set field "mge" to "1" in row 2
And I save the current editor

# Ausgabe Serviceauftrag
Given I open an editor "Serviceauftrag-view" from table "(Sales):(ServiceOrder)" with command "VIEW" for record from editor "serauftrag-637"
And I close the current editor

#Fall 637 - Servicerueckmeldung durchfuehren
Given I open an editor "srmeldung-637" from table "(ServiceReservation):(EngineerCompletionConfirmations)" with command "NEW" for record ""
And I set field "techniker" to id from editor "techniker"
And I set field "servau" to id from editor "serauftrag-637"
And I press button "ladetab"
Then the table has 2 rows
And I set field "buchen" to "ja" in row 1
And I set field "dauer" to "4h" in row 1
And I set field "buchen" to "ja" in row 2
And I set field "serstlsts" to "wird aktualisiert" in row 2
And I save the current editor

#Lieferschein erzeugen und buchen
Given I open an editor "lieferschein-637" from table "(Sales):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "serauftrag-637"
And I set field "nummer" to "637-LS"
And I set field "such" to "LS-637"
And I set field "ueb" to "ja"
Then the table has 1 rows
And I set field "mge" to "1" in row 1
And I save the current editor

# Ausgabe Lieferschein
Given I open an editor "Lieferschein-view" from table "(Sales):(PackingSlip)" with command "VIEW" for record from editor "lieferschein-637"
And I close the current editor

# Rücklieferschein anlegen
Given I open an editor "Ruecklieferschein-637" from table "(Sales):(PackingSlip)" with command "RETURN" for record from editor "lieferschein-637"
And I set field "num3" to "637-RLS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "-1" in row 1
And I set field "platz" to "F1" in row 1
And I set field "kenn" to "FALL-637 Ruecklieferschein"
#And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Ausgabe Rücklieferschein 
Given I open an editor "Rücklieferschein-view" from table "(Sales):(PackingSlip)" with command "VIEW" for record from editor "Ruecklieferschein-637"
And I close the current editor
 
# Storno Rücklieferschein
Given I open an editor "Ruecklieferschein-storno-637" from table "(Sales):(PackingSlip)" with command "REVERSAL" for record from editor "Ruecklieferschein-637"
And I set field "num3" to "637-SRL"
And I save the current editor

# Ausgabe Storno Rücklieferschein
Given I open an editor "Rechnung-storno-view" from table "(Sales):(PackingSlip)" with command "VIEW" for record from editor "Ruecklieferschein-storno-637"
And I close the current editor

#####################################################################################################################################

Scenario: FALL-638
# FALL-638

# STAMMDATEN - E1 kopieren
Given I open an editor "E1-638" from table "(Part):(Product)" with command "COPY" for record "E1"
And I set field "such" to "E1-638"
And I set field "losgr" to "0"
And I set field "mindest" to "0"
And I save the current editor
# STAMMDATEN - E2 kopieren
Given I open an editor "E2-638" from table "(Part):(Product)" with command "COPY" for record "E2"
And I set field "such" to "E2-638"
And I set field "losgr" to "0"
And I set field "mindest" to "0"
And I save the current editor

# STAMMDATEN - BG1 kopieren
Given I open an editor "BG-638" from table "(Part):(Product)" with command "COPY" for record "BG1"
And I set field "such" to "BG-638"
And I set field "dispoa" to "Auftragsbezogen"
And I set field "mindest" to "0"
And I set field "elex" to "E1-638" in row 1
And I set field "tnwpflicht" to "ja" in row 1
And I save the current editor

# STAMMDATEN - Servicepflichtigen Artikel anlegen
Given I open an editor "serartikel-638" from table "(Part):(Product)" with command "STORE" for record ""
And I set field "such" to "FALL-638"
And I set field "namebspr" to "Service Artikel 638"
And I set field "vkbez" to "Service Artikel 638"
And I set field "vbez" to "Service Artikel 638"
And I set field "ebez" to "Service Artikel 638"
And I set field "vpr" to "1000"
And I set field "bsart" to "Eigenfertigung"
And I set field "dispoa" to "Auftragsbezogen"
And I set field "chimlager" to "ja"
And I set field "serpflicht" to "ja"
#Stückliste anlegen
And I create a new row at the end of the table
And I set field "elex" to "E2-638" in row 1
And I set field "elanzahl" to "2" in row 1
And I set field "tnwpflicht" to "ja" in row 1
And I set field "tersatzt" to "ja" in row 1
And I create a new row at the end of the table
And I set field "elex" to "A AG3" in row 2
And I create a new row at the end of the table
And I set field "elex" to "BG-638" in row 3
And I set field "elanzahl" to "1" in row 3
And I set field "tnwpflicht" to "ja" in row 3
And I set field "tverschlt" to "ja" in row 3
And I create a new row at the end of the table
And I set field "elex" to "A AG4" in row 4
And I save the current editor

# Rechnung anlegen
Given I open an editor "rechnung" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "lief" to "1"
And I set field "num4" to "638-RE"
And I set field "fakt" to "ja"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I create a new row at the end of the table
And I set field "artex" to "E1-638" in row 1
And I set field "mge" to "638" in row 1
And I set field "preis" to "638" in row 1
And I set field "platz" to "F2" in row 1
And I create a new row at the end of the table
And I set field "artex" to "E2-638" in row 2
And I set field "mge" to "638" in row 2
And I set field "preis" to "638" in row 2
And I set field "platz" to "F2" in row 2
And I set field "kenn" to "FALL-638"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Charge anlegen
Given I open an editor "charge" from table "(Lots):(Lots)" with command "STORE" for record "FALL-638"
And I set field "such" to "FALL-638"
And I set field "exnum" to "FALL-638"
And I set field "artikel" to id from editor "serartikel-638"
And I save the current editor

# Serviceprodukt als Kunden- und Leihgeraet anlegen
Given I open an editor "kundeng-638" from table "(ServiceProduct):(ServiceProduct)" with command "STORE" for record "KGSP-638"
And I set field "such" to "KGSP-638"
And I set field "namebspr" to "KGSP-638"
And I set field "artikel" to id from editor "serartikel-638"
And I save the current editor
And I switch the current editor to editor "kundeng-638"
And I set field "serprodtyp" to "Kundengerät"
And I set field "zuplatzlg" to ""
And I set field "abplatzlg" to ""
And I set field "charge" to ""
And I save the current editor

Given I open an editor "leihgeraet-638" from table "(ServiceProduct):(ServiceProduct)" with command "STORE" for record "LHSP-638"
And I set field "such" to "LHSP-638"
And I set field "namebspr" to "Leihgeraet 638"
And I set field "artikel" to id from editor "serartikel-638"
And I save the current editor
And I switch the current editor to editor "leihgeraet-638"
And I set field "serprodtyp" to "Leihgeraet"
And I set field "zuplatzlg" to "F4"
And I set field "abplatzlg" to "F4"
And I set field "charge" to "FALL-638"
And I save the current editor

# Leihgeraet fertigen und aus Lager legen
Given I open an editor "fvanlegen" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
And I create a new row at the end of the table
And I set field "artikel" to id from editor "serartikel-638" in row 1
And I set field "mge" to "1" in row 1
And I set field "bisuch" to "LEIHBA" in row 1
And I set field "serprod" to id from editor "leihgeraet-638" in row 1
And I set field "platz" to "F4" in row 1
And I set field "mfreig" to "ja" in row 1
And I press button "freig" to open a subeditor for "fertigung"
And I close the current editor
And I switch the current editor to editor "fvanlegen"
And I close the current editor

#BA fuer Leihgeraet rueckmelden
Given I open an editor "rueckmelden" from table "(Workorder):(WorkOrders)" with command "DONE" for record "LEIHBA000"
And I set field "gut" to "ja"
And I set field "sofort" to "ja"
And I set field "mgr" to "101"
And I save the current editor

#####################################################################################################################################

Scenario: FALL-639
# FALL-639

# STAMMDATEN - E1 kopieren
Given I open an editor "E1-639" from table "(Part):(Product)" with command "COPY" for record "E1"
And I set field "such" to "E1-639"
And I set field "losgr" to "0"
And I set field "mindest" to "0"
And I save the current editor
# STAMMDATEN - E2 kopieren
Given I open an editor "E2-639" from table "(Part):(Product)" with command "COPY" for record "E2"
And I set field "such" to "E2-639"
And I set field "losgr" to "0"
And I set field "mindest" to "0"
And I save the current editor

# STAMMDATEN - BG1 kopieren
Given I open an editor "BG-639" from table "(Part):(Product)" with command "COPY" for record "BG1"
And I set field "such" to "BG-639"
And I set field "dispoa" to "Auftragsbezogen"
And I set field "mindest" to "0"
And I set field "elex" to "E1-639" in row 1
And I set field "tnwpflicht" to "ja" in row 1
And I save the current editor

# STAMMDATEN - Servicepflichtigen Artikel anlegen
Given I open an editor "serartikel-639" from table "(Part):(Product)" with command "STORE" for record ""
And I set field "such" to "FALL-639"
And I set field "namebspr" to "Service Artikel 639"
And I set field "vkbez" to "Service Artikel 639"
And I set field "vbez" to "Service Artikel 639"
And I set field "ebez" to "Service Artikel 639"
And I set field "vpr" to "1000"
And I set field "bsart" to "Eigenfertigung"
And I set field "dispoa" to "Auftragsbezogen"
And I set field "chimlager" to "ja"
And I set field "serpflicht" to "ja"
#Stückliste anlegen
And I create a new row at the end of the table
And I set field "elex" to "E2-639" in row 1
And I set field "elanzahl" to "2" in row 1
And I set field "tnwpflicht" to "ja" in row 1
And I set field "tersatzt" to "ja" in row 1
And I create a new row at the end of the table
And I set field "elex" to "A AG3" in row 2
And I create a new row at the end of the table
And I set field "elex" to "BG-639" in row 3
And I set field "elanzahl" to "1" in row 3
And I set field "tnwpflicht" to "ja" in row 3
And I set field "tverschlt" to "ja" in row 3
And I create a new row at the end of the table
And I set field "elex" to "A AG4" in row 4
And I save the current editor

# Rechnung anlegen
Given I open an editor "rechnung" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "lief" to "1"
And I set field "num4" to "639-RE"
And I set field "fakt" to "ja"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I create a new row at the end of the table
And I set field "artex" to "E1-639" in row 1
And I set field "mge" to "639" in row 1
And I set field "preis" to "639" in row 1
And I set field "platz" to "F2" in row 1
And I create a new row at the end of the table
And I set field "artex" to "E2-639" in row 2
And I set field "mge" to "639" in row 2
And I set field "preis" to "639" in row 2
And I set field "platz" to "F2" in row 2
And I set field "kenn" to "FALL-639"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Charge anlegen
Given I open an editor "charge" from table "(Lots):(Lots)" with command "STORE" for record "FALL-639"
And I set field "such" to "FALL-639"
And I set field "exnum" to "FALL-639"
And I set field "artikel" to id from editor "serartikel-639"
And I save the current editor

# Serviceprodukt als Kunden- und Leihgeraet anlegen
Given I open an editor "kundeng-639" from table "(ServiceProduct):(ServiceProduct)" with command "STORE" for record "KGSP-639"
And I set field "such" to "KGSP-639"
And I set field "namebspr" to "KGSP-639"
And I set field "artikel" to id from editor "serartikel-639"
And I save the current editor
And I switch the current editor to editor "kundeng-639"
And I set field "serprodtyp" to "Kundengerät"
And I set field "zuplatzlg" to ""
And I set field "abplatzlg" to ""
And I set field "charge" to ""
And I save the current editor

# Leihgeraet anlegen
Given I open an editor "leihgeraet-639" from table "(ServiceProduct):(ServiceProduct)" with command "STORE" for record "LHSP-639"
And I set field "such" to "LHSP-639"
And I set field "namebspr" to "Leihgeraet 639"
And I set field "artikel" to id from editor "serartikel-639"
And I save the current editor
And I switch the current editor to editor "leihgeraet-639"
And I set field "serprodtyp" to "Leihgeraet"
And I set field "zuplatzlg" to "F4"
And I set field "abplatzlg" to "F4"
And I set field "charge" to "FALL-639"
And I save the current editor

# Leihgeraet fertigen und aus Lager legen
Given I open an editor "fvanlegen" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
And I create a new row at the end of the table
And I set field "artikel" to id from editor "serartikel-639" in row 1
And I set field "mge" to "1" in row 1
And I set field "bisuch" to "LEIHBA" in row 1
And I set field "serprod" to id from editor "leihgeraet-639" in row 1
And I set field "platz" to "F4" in row 1
And I set field "mfreig" to "ja" in row 1
And I press button "freig" to open a subeditor for "fertigung"
And I close the current editor
And I switch the current editor to editor "fvanlegen"
And I close the current editor

#BA fuer Leihgeraet rueckmelden
Given I open an editor "rueckmelden" from table "(Workorder):(WorkOrders)" with command "DONE" for record "LEIHBA000"
And I set field "gut" to "ja"
And I set field "sofort" to "ja"
And I set field "mgr" to "101"
And I save the current editor

# Reparaturauftrag anlegen 
Given I open an editor "repauftrag-639" from table "(Sales):(RepairOrder)" with command "NEW" for record ""
And I set field "kunde" to id from editor "kunde"
And I set field "nummer" to "639-AU"
And I set field "such" to "AU-639"
And I create a new row at the end of the table
And I set field "serprod" to id from editor "kundeng-639" in row 1
Then the table has 2 rows
And I save the current editor

# Ausgabe Reparaturauftrag
Given I open an editor "Auftrag-view" from table "(Sales):(RepairOrder)" with command "VIEW" for record from editor "repauftrag-639"
And I close the current editor


#####################################################################################################################################

Scenario: FALL-640
# FALL-640

# STAMMDATEN - E1 kopieren
Given I open an editor "E1-640" from table "(Part):(Product)" with command "COPY" for record "E1"
And I set field "such" to "E1-640"
And I set field "losgr" to "0"
And I set field "mindest" to "0"
And I save the current editor
# STAMMDATEN - E2 kopieren
Given I open an editor "E2-640" from table "(Part):(Product)" with command "COPY" for record "E2"
And I set field "such" to "E2-640"
And I set field "losgr" to "0"
And I set field "mindest" to "0"
And I save the current editor

# STAMMDATEN - BG1 kopieren
Given I open an editor "BG-640" from table "(Part):(Product)" with command "COPY" for record "BG1"
And I set field "such" to "BG-640"
And I set field "dispoa" to "Auftragsbezogen"
And I set field "mindest" to "0"
And I set field "elex" to "E1-640" in row 1
And I set field "tnwpflicht" to "ja" in row 1
And I save the current editor

# STAMMDATEN - Servicepflichtigen Artikel anlegen
Given I open an editor "serartikel-640" from table "(Part):(Product)" with command "STORE" for record ""
And I set field "such" to "FALL-640"
And I set field "namebspr" to "Service Artikel 640"
And I set field "vkbez" to "Service Artikel 640"
And I set field "vbez" to "Service Artikel 640"
And I set field "ebez" to "Service Artikel 640"
And I set field "vpr" to "1000"
And I set field "bsart" to "Eigenfertigung"
And I set field "dispoa" to "Auftragsbezogen"
And I set field "chimlager" to "ja"
And I set field "serpflicht" to "ja"
#Stückliste anlegen
And I create a new row at the end of the table
And I set field "elex" to "E2-640" in row 1
And I set field "elanzahl" to "2" in row 1
And I set field "tnwpflicht" to "ja" in row 1
And I set field "tersatzt" to "ja" in row 1
And I create a new row at the end of the table
And I set field "elex" to "A AG3" in row 2
And I create a new row at the end of the table
And I set field "elex" to "BG-640" in row 3
And I set field "elanzahl" to "1" in row 3
And I set field "tnwpflicht" to "ja" in row 3
And I set field "tverschlt" to "ja" in row 3
And I create a new row at the end of the table
And I set field "elex" to "A AG4" in row 4
And I save the current editor

# Rechnung anlegen
Given I open an editor "rechnung" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "lief" to "1"
And I set field "num4" to "640-RE"
And I set field "fakt" to "ja"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I create a new row at the end of the table
And I set field "artex" to "E1-640" in row 1
And I set field "mge" to "640" in row 1
And I set field "preis" to "640" in row 1
And I set field "platz" to "F2" in row 1
And I create a new row at the end of the table
And I set field "artex" to "E2-640" in row 2
And I set field "mge" to "640" in row 2
And I set field "preis" to "640" in row 2
And I set field "platz" to "F2" in row 2
And I set field "kenn" to "FALL-640"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Charge anlegen
Given I open an editor "charge" from table "(Lots):(Lots)" with command "STORE" for record "FALL-640"
And I set field "such" to "FALL-640"
And I set field "exnum" to "FALL-640"
And I set field "artikel" to id from editor "serartikel-640"
And I save the current editor

# Serviceprodukt als Kunden- und Leihgeraet anlegen
Given I open an editor "kundeng-640" from table "(ServiceProduct):(ServiceProduct)" with command "STORE" for record "KGSP-640"
And I set field "such" to "KGSP-640"
And I set field "namebspr" to "KGSP-640"
And I set field "artikel" to id from editor "serartikel-640"
And I save the current editor
And I switch the current editor to editor "kundeng-640"
And I set field "serprodtyp" to "Kundengerät"
And I set field "zuplatzlg" to ""
And I set field "abplatzlg" to ""
And I set field "charge" to ""
And I save the current editor

# Leihgeraet anlegen
Given I open an editor "leihgeraet-640" from table "(ServiceProduct):(ServiceProduct)" with command "STORE" for record "LHSP-640"
And I set field "such" to "LHSP-640"
And I set field "namebspr" to "Leihgeraet 640"
And I set field "artikel" to id from editor "serartikel-640"
And I save the current editor
And I switch the current editor to editor "leihgeraet-640"
And I set field "serprodtyp" to "Leihgeraet"
And I set field "zuplatzlg" to "F4"
And I set field "abplatzlg" to "F4"
And I set field "charge" to "FALL-640"
And I save the current editor

# Leihgeraet fertigen und aus Lager legen
Given I open an editor "fvanlegen" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
And I create a new row at the end of the table
And I set field "artikel" to id from editor "serartikel-640" in row 1
And I set field "mge" to "1" in row 1
And I set field "bisuch" to "LEIHBA" in row 1
And I set field "serprod" to id from editor "leihgeraet-640" in row 1
And I set field "platz" to "F4" in row 1
And I set field "mfreig" to "ja" in row 1
And I press button "freig" to open a subeditor for "fertigung"
And I close the current editor
And I switch the current editor to editor "fvanlegen"
And I close the current editor

#BA fuer Leihgeraet rueckmelden
Given I open an editor "rueckmelden" from table "(Workorder):(WorkOrders)" with command "DONE" for record "LEIHBA000"
And I set field "gut" to "ja"
And I set field "sofort" to "ja"
And I set field "mgr" to "101"
And I save the current editor

# Reparaturauftrag anlegen 
Given I open an editor "repauftrag-640" from table "(Sales):(RepairOrder)" with command "NEW" for record ""
And I set field "kunde" to id from editor "kunde"
And I set field "nummer" to "640-AU"
And I set field "such" to "AU-640"
And I create a new row at the end of the table
And I set field "serprod" to id from editor "kundeng-640" in row 1
Then the table has 2 rows
And I save the current editor

# Ausgabe Reparaturauftrag
Given I open an editor "Auftrag-view" from table "(Sales):(RepairOrder)" with command "VIEW" for record from editor "repauftrag-640"
And I close the current editor

Given I open an editor "repauftrag-640-2" from table "(Sales):(RepairOrder)" with command "UPDATE" for record from editor "repauftrag-640"
And I press button "repabgl" to open a subeditor for "abgangsls-640"
And I set field "nummer" to "640-LS"
And I set field "such" to "LS-640"
And I set field "umplatz" to "extern"
And I set field "ueb" to "ja"
And I save the current editor
And I switch the current editor to editor "repauftrag-640-2"
And I save the current editor

# Ausgabe Lieferschein
Given I open an editor "Lieferschein-view" from table "(Sales):(PackingSlip)" with command "VIEW" for record from editor "abgangsls-640"
And I close the current editor

Given I open an editor "repauftrag-640-3" from table "(Sales):(RepairOrder)" with command "UPDATE" for record from editor "repauftrag-640"
And I press button "repzugl" to open a subeditor for "zugangsls-640"
And I set field "nummer" to "640-LS2"
And I set field "such" to "LS-640-2"
And I set field "ueb" to "ja"
And I save the current editor 
And I switch the current editor to editor "repauftrag-640-3"
And I save the current editor

# Ausgabe Lieferschein
Given I open an editor "Lieferschein-view" from table "(Sales):(PackingSlip)" with command "VIEW" for record from editor "zugangsls-640"
And I close the current editor

#####################################################################################################################################

Scenario: FALL-641
# FALL-641

# STAMMDATEN - E1 kopieren
Given I open an editor "E1-641" from table "(Part):(Product)" with command "COPY" for record "E1"
And I set field "such" to "E1-641"
And I set field "losgr" to "0"
And I set field "mindest" to "0"
And I save the current editor
# STAMMDATEN - E2 kopieren
Given I open an editor "E2-641" from table "(Part):(Product)" with command "COPY" for record "E2"
And I set field "such" to "E2-641"
And I set field "losgr" to "0"
And I set field "mindest" to "0"
And I save the current editor

# STAMMDATEN - BG1 kopieren
Given I open an editor "BG-641" from table "(Part):(Product)" with command "COPY" for record "BG1"
And I set field "such" to "BG-641"
And I set field "dispoa" to "Auftragsbezogen"
And I set field "mindest" to "0"
And I set field "elex" to "E1-641" in row 1
And I set field "tnwpflicht" to "ja" in row 1
And I save the current editor

# STAMMDATEN - Servicepflichtigen Artikel anlegen
Given I open an editor "serartikel-641" from table "(Part):(Product)" with command "STORE" for record ""
And I set field "such" to "FALL-641"
And I set field "namebspr" to "Service Artikel 641"
And I set field "vkbez" to "Service Artikel 641"
And I set field "vbez" to "Service Artikel 641"
And I set field "ebez" to "Service Artikel 641"
And I set field "vpr" to "1000"
And I set field "bsart" to "Eigenfertigung"
And I set field "dispoa" to "Auftragsbezogen"
And I set field "chimlager" to "ja"
And I set field "serpflicht" to "ja"
#Stückliste anlegen
And I create a new row at the end of the table
And I set field "elex" to "E2-641" in row 1
And I set field "elanzahl" to "2" in row 1
And I set field "tnwpflicht" to "ja" in row 1
And I set field "tersatzt" to "ja" in row 1
And I create a new row at the end of the table
And I set field "elex" to "A AG3" in row 2
And I create a new row at the end of the table
And I set field "elex" to "BG-641" in row 3
And I set field "elanzahl" to "1" in row 3
And I set field "tnwpflicht" to "ja" in row 3
And I set field "tverschlt" to "ja" in row 3
And I create a new row at the end of the table
And I set field "elex" to "A AG4" in row 4
And I save the current editor

# Rechnung anlegen
Given I open an editor "rechnung" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "lief" to "1"
And I set field "num4" to "641-RE"
And I set field "fakt" to "ja"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I create a new row at the end of the table
And I set field "artex" to "E1-641" in row 1
And I set field "mge" to "641" in row 1
And I set field "preis" to "641" in row 1
And I set field "platz" to "F2" in row 1
And I create a new row at the end of the table
And I set field "artex" to "E2-641" in row 2
And I set field "mge" to "641" in row 2
And I set field "preis" to "641" in row 2
And I set field "platz" to "F2" in row 2
And I set field "kenn" to "FALL-641"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Charge anlegen
Given I open an editor "charge" from table "(Lots):(Lots)" with command "STORE" for record "FALL-641"
And I set field "such" to "FALL-641"
And I set field "exnum" to "FALL-641"
And I set field "artikel" to id from editor "serartikel-641"
And I save the current editor

# Serviceprodukt als Kunden- und Leihgeraet anlegen
Given I open an editor "kundeng-641" from table "(ServiceProduct):(ServiceProduct)" with command "STORE" for record "KGSP-641"
And I set field "such" to "KGSP-641"
And I set field "namebspr" to "KGSP-641"
And I set field "artikel" to id from editor "serartikel-641"
And I save the current editor
And I switch the current editor to editor "kundeng-641"
And I set field "serprodtyp" to "Kundengerät"
And I set field "zuplatzlg" to ""
And I set field "abplatzlg" to ""
And I set field "charge" to ""
And I save the current editor

# Leihgeraet anlegen
Given I open an editor "leihgeraet-641" from table "(ServiceProduct):(ServiceProduct)" with command "STORE" for record "LHSP-641"
And I set field "such" to "LHSP-641"
And I set field "namebspr" to "Leihgeraet 641"
And I set field "artikel" to id from editor "serartikel-641"
And I save the current editor
And I switch the current editor to editor "leihgeraet-641"
And I set field "serprodtyp" to "Leihgeraet"
And I set field "zuplatzlg" to "F4"
And I set field "abplatzlg" to "F4"
And I set field "charge" to "FALL-641"
And I save the current editor

# Leihgeraet fertigen und aus Lager legen
Given I open an editor "fvanlegen" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
And I create a new row at the end of the table
And I set field "artikel" to id from editor "serartikel-641" in row 1
And I set field "mge" to "1" in row 1
And I set field "bisuch" to "LEIHBA" in row 1
And I set field "serprod" to id from editor "leihgeraet-641" in row 1
And I set field "platz" to "F4" in row 1
And I set field "mfreig" to "ja" in row 1
And I press button "freig" to open a subeditor for "fertigung"
And I close the current editor
And I switch the current editor to editor "fvanlegen"
And I close the current editor

#BA fuer Leihgeraet rueckmelden
Given I open an editor "rueckmelden" from table "(Workorder):(WorkOrders)" with command "DONE" for record "LEIHBA000"
And I set field "gut" to "ja"
And I set field "sofort" to "ja"
And I set field "mgr" to "101"
And I save the current editor

# Reparaturauftrag anlegen 
Given I open an editor "repauftrag-641" from table "(Sales):(RepairOrder)" with command "NEW" for record ""
And I set field "kunde" to id from editor "kunde"
And I set field "nummer" to "641-AU"
And I set field "such" to "AU-641"
And I create a new row at the end of the table
And I set field "serprod" to id from editor "kundeng-641" in row 1
Then the table has 2 rows
And I save the current editor

# Ausgabe Reparaturauftrag
Given I open an editor "Auftrag-view" from table "(Sales):(RepairOrder)" with command "VIEW" for record from editor "repauftrag-641"
And I close the current editor

# Zugang Kundengeraet
Given I open an editor "repauftrag-641-2" from table "(Sales):(RepairOrder)" with command "UPDATE" for record from editor "repauftrag-641"
And I press button "repzug" to open a subeditor for "zugangsls-641"
And I set field "nummer" to "641-LS2"
And I set field "such" to "LS-641-2"
And I set field "ueb" to "ja"
And I save the current editor
And I switch the current editor to editor "repauftrag-641-2"
And I save the current editor

# Storno Zugang Kundengeraet
Given I open an editor "lieferschein" from table "(Sales):(PackingSlip)" with command "REVERSAL" for record from editor "zugangsls-641"
And I set field "num3" to "641-SLS"
And I save the current editor

# Ausgabe Storno Lieferschein
Given I open an editor "lieferschein-view" from table "(Sales):(PackingSlip)" with command "VIEW" for record "+641-SLS"
And I close the current editor

#####################################################################################################################################

Scenario: FALL-643
# FALL-643

# STAMMDATEN - E1 kopieren
Given I open an editor "E1-643" from table "(Part):(Product)" with command "COPY" for record "E1"
And I set field "such" to "E1-643"
And I set field "losgr" to "0"
And I set field "mindest" to "0"
And I save the current editor
# STAMMDATEN - E2 kopieren
Given I open an editor "E2-643" from table "(Part):(Product)" with command "COPY" for record "E2"
And I set field "such" to "E2-643"
And I set field "losgr" to "0"
And I set field "mindest" to "0"
And I save the current editor

# STAMMDATEN - BG1 kopieren
Given I open an editor "BG-643" from table "(Part):(Product)" with command "COPY" for record "BG1"
And I set field "such" to "BG-643"
And I set field "dispoa" to "Auftragsbezogen"
And I set field "mindest" to "0"
And I set field "elex" to "E1-643" in row 1
And I set field "tnwpflicht" to "ja" in row 1
And I save the current editor

# STAMMDATEN - Servicepflichtigen Artikel anlegen
Given I open an editor "serartikel-643" from table "(Part):(Product)" with command "STORE" for record ""
And I set field "such" to "FALL-643"
And I set field "namebspr" to "Service Artikel 643"
And I set field "vkbez" to "Service Artikel 643"
And I set field "vbez" to "Service Artikel 643"
And I set field "ebez" to "Service Artikel 643"
And I set field "vpr" to "1000"
And I set field "bsart" to "Eigenfertigung"
And I set field "dispoa" to "Auftragsbezogen"
And I set field "chimlager" to "ja"
And I set field "serpflicht" to "ja"
#Stückliste anlegen
And I create a new row at the end of the table
And I set field "elex" to "E2-643" in row 1
And I set field "elanzahl" to "2" in row 1
And I set field "tnwpflicht" to "ja" in row 1
And I set field "tersatzt" to "ja" in row 1
And I create a new row at the end of the table
And I set field "elex" to "A AG3" in row 2
And I create a new row at the end of the table
And I set field "elex" to "BG-643" in row 3
And I set field "elanzahl" to "1" in row 3
And I set field "tnwpflicht" to "ja" in row 3
And I set field "tverschlt" to "ja" in row 3
And I create a new row at the end of the table
And I set field "elex" to "A AG4" in row 4
And I save the current editor

# Rechnung anlegen
Given I open an editor "rechnung" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "lief" to "1"
And I set field "num4" to "643-RE"
And I set field "fakt" to "ja"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I create a new row at the end of the table
And I set field "artex" to "E1-643" in row 1
And I set field "mge" to "643" in row 1
And I set field "preis" to "643" in row 1
And I set field "platz" to "F2" in row 1
And I create a new row at the end of the table
And I set field "artex" to "E2-643" in row 2
And I set field "mge" to "643" in row 2
And I set field "preis" to "643" in row 2
And I set field "platz" to "F2" in row 2
And I set field "kenn" to "FALL-643"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Charge anlegen
Given I open an editor "charge" from table "(Lots):(Lots)" with command "STORE" for record "FALL-643"
And I set field "such" to "FALL-643"
And I set field "exnum" to "FALL-643"
And I set field "artikel" to id from editor "serartikel-643"
And I save the current editor

# Serviceprodukt als Kunden- und Leihgeraet anlegen
Given I open an editor "kundeng-643" from table "(ServiceProduct):(ServiceProduct)" with command "STORE" for record "KGSP-643"
And I set field "such" to "KGSP-643"
And I set field "namebspr" to "KGSP-643"
And I set field "artikel" to id from editor "serartikel-643"
And I save the current editor
And I switch the current editor to editor "kundeng-643"
And I set field "serprodtyp" to "Kundengerät"
And I set field "zuplatzlg" to ""
And I set field "abplatzlg" to ""
And I set field "charge" to ""
And I save the current editor

# Leihgeraet anlegen
Given I open an editor "leihgeraet-643" from table "(ServiceProduct):(ServiceProduct)" with command "STORE" for record "LHSP-643"
And I set field "such" to "LHSP-643"
And I set field "namebspr" to "Leihgeraet 643"
And I set field "artikel" to id from editor "serartikel-643"
And I save the current editor
And I switch the current editor to editor "leihgeraet-643"
And I set field "serprodtyp" to "Leihgeraet"
And I set field "zuplatzlg" to "F4"
And I set field "abplatzlg" to "F4"
And I set field "charge" to "FALL-643"
And I save the current editor

# Leihgeraet fertigen und aus Lager legen
Given I open an editor "fvanlegen" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
And I create a new row at the end of the table
And I set field "artikel" to id from editor "serartikel-643" in row 1
And I set field "mge" to "1" in row 1
And I set field "bisuch" to "LEIHBA" in row 1
And I set field "serprod" to id from editor "leihgeraet-643" in row 1
And I set field "platz" to "F4" in row 1
And I set field "mfreig" to "ja" in row 1
And I press button "freig" to open a subeditor for "fertigung"
And I close the current editor
And I switch the current editor to editor "fvanlegen"
And I close the current editor

#BA fuer Leihgeraet rueckmelden
Given I open an editor "rueckmelden" from table "(Workorder):(WorkOrders)" with command "DONE" for record "LEIHBA000"
And I set field "gut" to "ja"
And I set field "sofort" to "ja"
And I set field "mgr" to "101"
And I save the current editor

# Reparaturauftrag anlegen 
Given I open an editor "repauftrag-643" from table "(Sales):(RepairOrder)" with command "NEW" for record ""
And I set field "kunde" to id from editor "kunde"
And I set field "nummer" to "643-AU"
And I set field "such" to "AU-643"
And I create a new row at the end of the table
And I set field "serprod" to id from editor "kundeng-643" in row 1
Then the table has 2 rows
And I save the current editor

# Ausgabe Reparaturauftrag
Given I open an editor "Auftrag-view" from table "(Sales):(RepairOrder)" with command "VIEW" for record from editor "repauftrag-643"
And I close the current editor

# Zugang Kundengeraet
Given I open an editor "repauftrag-643-2" from table "(Sales):(RepairOrder)" with command "UPDATE" for record from editor "repauftrag-643"
And I press button "repzug" to open a subeditor for "zugangsls-643"
And I set field "nummer" to "643-LS2"
And I set field "such" to "LS-643-2"
And I set field "ueb" to "ja"
And I save the current editor
And I switch the current editor to editor "repauftrag-643-2"
And I save the current editor

#Fall 605, 606 - Reparaturauftrag erweitern (Dienstleistung, Kostenvoranschlag)
Given I open an editor "repauftrag-643-3" from table "(Sales):(RepairOrder)" with command "UPDATE" for record from editor "repauftrag-643"
And I set field "bem" to "Jetzt die Reparatur"
And I create a new row at the end of the table
And I set field "artikel" to id from editor "hdienstl" in row 3
And I set field "serprod" to id from editor "kundeng-643" in row 3 
And I set field "mge" to "2" in row 3
#Stueckliste für die Reparatur anlegen
And I press button "absteig" to open a subeditor for "reparatur" in row 3
And I create a new row at the end of the table
And I set field "elex" to "BG-643" in row 1
And I set field "elanzahl" to "1" in row 1
And I create a new row at the end of the table
And I set field "elex" to "A AG2" in row 2
And I save the current editor
And I switch the current editor to editor "repauftrag-643-3"
And I press button "kostenvorb" to open a subeditor for "kvb"
And I set field "nummer" to "643-KV"
And I set field "such" to "KV-643"
And I set field "bem" to "Kostenvoranschlag 643"
Then the table has 1 rows
And I save the current editor
And I switch the current editor to editor "repauftrag-643-3"
And I save the current editor

#Fall 605, 606 - Disposition starten
And I run Scheduling

# FixMe die BG-643 muess hier noch gefertigt werden.

#Fall 605, 606 - Fertigungsvorschlag fuer Dienstleistung freigeben
Given I open an editor "fvanlegen" from table "(Purchasing):(WorkOrderSuggestions)" with command "UPDATE" for record ""
And I set field "artikel" to id from editor "hdienstl"
And I press button "ladetab"
Then the table has 1 rows
And I set field "bisuch" to "REPBA-643" in row 1
And I set field "mfreig" to "ja" in row 1
And I press button "freig" to open a subeditor for "fertigung"
And I close the current editor
And I switch the current editor to editor "fvanlegen"
And I close the current editor

#Fall 605, 606 - Materialentnahme für Dienstleistung durchfuehren
Given I open an editor "Materialentnahme" for tip command "(WOIssue)" and arguments ""
And I set field "auftrag" to "$,,such=REPBA-643000;@richtung=rückwärts;@maxtreffer=1"
And I set field "autorment" to "ja"
And I set field "mgr" to "101"
And I press button "stllad"
And I set field "serstlsts" to "wird aktualisiert" in row 1
And I save the current editor

#Fall 605, 606 - Dienstleistung rueckmelden
Given I open an editor "rueckmelden" from table "(Workorder):(WorkOrders)" with command "DONE" for record "REPBA-643000"
And I set field "gut" to "ja"
And I set field "sofort" to "ja"
And I set field "mgr" to "101"
And I save the current editor

# #Fall 605, 606 - Rechnung erstellen und Lieferschein buchen
Given I open an editor "repauftrag-643-4" from table "(Sales):(RepairOrder)" with command "UPDATE" for record from editor "repauftrag-643"
And I press button "reanlegen" to open a subeditor for "rechnung"
And I set field "ueb" to "ja"
And I set field "nummer" to "643-RE"
And I set field "such" to "RE-643"
And I press button "offueb" in row 1
# And I press button "offueb" in row 2
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor
And I switch the current editor to editor "repauftrag-643-4"
And I press button "repabg" to open a subeditor for "lieferschein-643"
And I set field "nummer" to "643-LS3"
And I set field "such" to "LS-643-3"
And I set field "ueb" to "ja"
And I save the current editor
And I switch the current editor to editor "repauftrag-643-4"
And I save the current editor

#####################################################################################################################################

Scenario: FALL-644
# FALL-644
# Reparaturauftrag	Zugang Kundengeraet	Storno Lieferschein	Zugang Kundengeraet
# Lieferschein Leihgeraet	Storno Lieferschein	Lieferschein Leihgeraet
# Fertigung Reparatur
# Abgang Kundengeraet	Storno Abgang Kundengeraet	Abgang Kundengeraet
# Zugang Leihgeraet	Storno Zugang Leihgeraet	Zugang Leihgeraet
# Rechnung	Storno Rechnung	Rechnung


# STAMMDATEN - E1 kopieren
Given I open an editor "E1-644" from table "(Part):(Product)" with command "COPY" for record "E1"
And I set field "such" to "E1-644"
And I set field "losgr" to "0"
And I set field "mindest" to "0"
And I save the current editor
# STAMMDATEN - E2 kopieren
Given I open an editor "E2-644" from table "(Part):(Product)" with command "COPY" for record "E2"
And I set field "such" to "E2-644"
And I set field "losgr" to "0"
And I set field "mindest" to "0"
And I save the current editor

# STAMMDATEN - BG1 kopieren
Given I open an editor "BG-644" from table "(Part):(Product)" with command "COPY" for record "BG1"
And I set field "such" to "BG-644"
And I set field "dispoa" to "Auftragsbezogen"
And I set field "mindest" to "0"
And I set field "elex" to "E1-644" in row 1
And I set field "tnwpflicht" to "ja" in row 1
And I save the current editor

# STAMMDATEN - Servicepflichtigen Artikel anlegen
Given I open an editor "serartikel-644" from table "(Part):(Product)" with command "STORE" for record ""
And I set field "such" to "FALL-644"
And I set field "namebspr" to "Service Artikel 644"
And I set field "vkbez" to "Service Artikel 644"
And I set field "vbez" to "Service Artikel 644"
And I set field "ebez" to "Service Artikel 644"
And I set field "vpr" to "1000"
And I set field "bsart" to "Eigenfertigung"
And I set field "dispoa" to "Auftragsbezogen"
And I set field "chimlager" to "ja"
And I set field "serpflicht" to "ja"
#Stückliste anlegen
And I create a new row at the end of the table
And I set field "elex" to "E2-644" in row 1
And I set field "elanzahl" to "2" in row 1
And I set field "tnwpflicht" to "ja" in row 1
And I set field "tersatzt" to "ja" in row 1
And I create a new row at the end of the table
And I set field "elex" to "A AG3" in row 2
And I create a new row at the end of the table
And I set field "elex" to "BG-644" in row 3
And I set field "elanzahl" to "1" in row 3
And I set field "tnwpflicht" to "ja" in row 3
And I set field "tverschlt" to "ja" in row 3
And I create a new row at the end of the table
And I set field "elex" to "A AG4" in row 4
And I save the current editor

# Rechnung anlegen
Given I open an editor "rechnung" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "lief" to "1"
And I set field "num4" to "644-RE"
And I set field "fakt" to "ja"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I create a new row at the end of the table
And I set field "artex" to "E1-644" in row 1
And I set field "mge" to "644" in row 1
And I set field "preis" to "644" in row 1
And I set field "platz" to "F2" in row 1
And I create a new row at the end of the table
And I set field "artex" to "E2-644" in row 2
And I set field "mge" to "644" in row 2
And I set field "preis" to "644" in row 2
And I set field "platz" to "F2" in row 2
And I set field "kenn" to "FALL-644"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Charge anlegen
Given I open an editor "charge" from table "(Lots):(Lots)" with command "STORE" for record "FALL-644"
And I set field "such" to "FALL-644"
And I set field "exnum" to "FALL-644"
And I set field "artikel" to id from editor "serartikel-644"
And I save the current editor

# Serviceprodukt als Kunden- und Leihgeraet anlegen
Given I open an editor "kundeng-644" from table "(ServiceProduct):(ServiceProduct)" with command "STORE" for record "KGSP-644"
And I set field "such" to "KGSP-644"
And I set field "namebspr" to "KGSP-644"
And I set field "artikel" to id from editor "serartikel-644"
And I save the current editor
And I switch the current editor to editor "kundeng-644"
And I set field "serprodtyp" to "Kundengerät"
And I set field "zuplatzlg" to ""
And I set field "abplatzlg" to ""
And I set field "charge" to ""
And I save the current editor

# Leihgeraet anlegen
Given I open an editor "leihgeraet-644" from table "(ServiceProduct):(ServiceProduct)" with command "STORE" for record "LHSP-644"
And I set field "such" to "LHSP-644"
And I set field "namebspr" to "Leihgeraet 644"
And I set field "artikel" to id from editor "serartikel-644"
And I save the current editor
And I switch the current editor to editor "leihgeraet-644"
And I set field "serprodtyp" to "Leihgeraet"
And I set field "zuplatzlg" to "F4"
And I set field "abplatzlg" to "F4"
And I set field "charge" to "FALL-644"
And I save the current editor

# Leihgeraet fertigen und aus Lager legen
Given I open an editor "fvanlegen" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
And I create a new row at the end of the table
And I set field "artikel" to id from editor "serartikel-644" in row 1
And I set field "mge" to "1" in row 1
And I set field "bisuch" to "LEIHBA" in row 1
And I set field "serprod" to id from editor "leihgeraet-644" in row 1
And I set field "platz" to "F4" in row 1
And I set field "mfreig" to "ja" in row 1
And I press button "freig" to open a subeditor for "fertigung"
And I close the current editor
And I switch the current editor to editor "fvanlegen"
And I close the current editor

#BA fuer Leihgeraet rueckmelden
Given I open an editor "rueckmelden" from table "(Workorder):(WorkOrders)" with command "DONE" for record "LEIHBA000"
And I set field "gut" to "ja"
And I set field "sofort" to "ja"
And I set field "mgr" to "101"
And I save the current editor

# Reparaturauftrag anlegen 
Given I open an editor "repauftrag-644" from table "(Sales):(RepairOrder)" with command "NEW" for record ""
And I set field "kunde" to id from editor "kunde"
And I set field "nummer" to "644-AU"
And I set field "such" to "AU-644"
And I create a new row at the end of the table
And I set field "serprod" to id from editor "kundeng-644" in row 1
Then the table has 2 rows
And I save the current editor

# Ausgabe Reparaturauftrag
Given I open an editor "Auftrag-view" from table "(Sales):(RepairOrder)" with command "VIEW" for record from editor "repauftrag-644"
And I close the current editor

# Zugang Kundengeraet
Given I open an editor "repauftrag-644-2" from table "(Sales):(RepairOrder)" with command "UPDATE" for record from editor "repauftrag-644"
And I press button "repzug" to open a subeditor for "zugangsls-644"
And I set field "nummer" to "644-LS1"
And I set field "such" to "LS-644-1"
And I set field "ueb" to "ja"
And I save the current editor
And I switch the current editor to editor "repauftrag-644-2"
And I save the current editor

# Storno Zugang Kundengeraet
Given I open an editor "lieferschein" from table "(Sales):(PackingSlip)" with command "REVERSAL" for record from editor "zugangsls-644"
And I set field "num3" to "644-SLS1"
And I save the current editor

# Ausgabe Storno Lieferschein
Given I open an editor "lieferschein-view" from table "(Sales):(PackingSlip)" with command "VIEW" for record "+644-SLS1"
And I close the current editor

# Zugang Kundengeraet
Given I open an editor "repauftrag-644-2" from table "(Sales):(RepairOrder)" with command "UPDATE" for record from editor "repauftrag-644"
And I press button "repzug" to open a subeditor for "zugangsls-644"
And I set field "nummer" to "644-LS2"
And I set field "such" to "LS-644-2"
And I set field "ueb" to "ja"
And I save the current editor
And I switch the current editor to editor "repauftrag-644-2"
And I save the current editor

# Abgang Leihgeraet
Given I open an editor "repauftrag-644-2" from table "(Sales):(RepairOrder)" with command "UPDATE" for record from editor "repauftrag-644"
And I press button "repabgl" to open a subeditor for "abgangsls-644"
And I set field "nummer" to "644-LS3"
And I set field "such" to "LS-644-3"
And I set field "ueb" to "ja"
And I set field "umplatz" to "extern"
And I save the current editor
And I switch the current editor to editor "repauftrag-644-2"
And I save the current editor

# Ausgabe Lieferschein
Given I open an editor "Lieferschein-view" from table "(Sales):(PackingSlip)" with command "VIEW" for record from editor "abgangsls-644"
And I close the current editor

# Storno Lieferschein
Given I open an editor "lieferschein" from table "(Sales):(PackingSlip)" with command "REVERSAL" for record from editor "abgangsls-644"
And I set field "num3" to "644-SLS2"
And I save the current editor

# Ausgabe Storno Lieferschein
Given I open an editor "lieferschein-view" from table "(Sales):(PackingSlip)" with command "VIEW" for record "+644-SLS2"
And I close the current editor

Given I open an editor "repauftrag-644-2" from table "(Sales):(RepairOrder)" with command "UPDATE" for record from editor "repauftrag-644"
And I press button "repabgl" to open a subeditor for "abgangsls-644"
And I set field "nummer" to "644-LS4"
And I set field "such" to "LS-644-4"
And I set field "ueb" to "ja"
And I set field "umplatz" to "extern"
And I save the current editor
And I switch the current editor to editor "repauftrag-644-2"
And I save the current editor

# Ausgabe Lieferschein
Given I open an editor "Lieferschein-view" from table "(Sales):(PackingSlip)" with command "VIEW" for record from editor "abgangsls-644"
And I close the current editor

#Fall 605, 606 - Reparaturauftrag erweitern (Dienstleistung, Kostenvoranschlag)
Given I open an editor "repauftrag-644-3" from table "(Sales):(RepairOrder)" with command "UPDATE" for record from editor "repauftrag-644"
And I set field "bem" to "Jetzt die Reparatur"
And I create a new row at the end of the table
And I set field "artikel" to id from editor "hdienstl" in row 3
And I set field "serprod" to id from editor "kundeng-644" in row 3 
And I set field "mge" to "2" in row 3
#Stueckliste für die Reparatur anlegen
And I press button "absteig" to open a subeditor for "reparatur" in row 3
And I create a new row at the end of the table
And I set field "elex" to "BG-644" in row 1
And I set field "elanzahl" to "1" in row 1
And I create a new row at the end of the table
And I set field "elex" to "A AG2" in row 2
And I save the current editor
And I switch the current editor to editor "repauftrag-644-3"
And I press button "kostenvorb" to open a subeditor for "kvb"
And I set field "nummer" to "644-KV"
And I set field "such" to "KV-644"
And I set field "bem" to "Kostenvoranschlag 644"
Then the table has 1 rows
And I save the current editor
And I switch the current editor to editor "repauftrag-644-3"
And I save the current editor

#Fall 605, 606 - Disposition starten
And I run Scheduling

# FixMe die BG-644 muess hier noch gefertigt werden.

#Fall 605, 606 - Fertigungsvorschlag fuer Dienstleistung freigeben
Given I open an editor "fvanlegen" from table "(Purchasing):(WorkOrderSuggestions)" with command "UPDATE" for record ""
And I set field "artikel" to id from editor "hdienstl"
And I press button "ladetab"
Then the table has 1 rows
And I set field "bisuch" to "REPBA-644" in row 1
And I set field "mfreig" to "ja" in row 1
And I press button "freig" to open a subeditor for "fertigung"
And I close the current editor
And I switch the current editor to editor "fvanlegen"
And I close the current editor

#Fall 605, 606 - Materialentnahme für Dienstleistung durchfuehren
Given I open an editor "Materialentnahme" for tip command "(WOIssue)" and arguments ""
And I set field "auftrag" to "$,,such=REPBA-644000;@richtung=rückwärts;@maxtreffer=1"
And I set field "autorment" to "ja"
And I set field "mgr" to "101"
And I press button "stllad"
And I set field "serstlsts" to "wird aktualisiert" in row 1
And I save the current editor

#Fall 605, 606 - Dienstleistung rueckmelden
Given I open an editor "rueckmelden" from table "(Workorder):(WorkOrders)" with command "DONE" for record "REPBA-644000"
And I set field "gut" to "ja"
And I set field "sofort" to "ja"
And I set field "mgr" to "101"
And I save the current editor

# Abgang Kundengeraet Lieferschein
Given I open an editor "repauftrag-644-5" from table "(Sales):(RepairOrder)" with command "UPDATE" for record from editor "repauftrag-644"
And I press button "repabg" to open a subeditor for "lieferschein-644-3"
And I set field "nummer" to "644-LS5"
And I set field "such" to "LS-644-5"
And I set field "ueb" to "ja"
And I save the current editor
And I switch the current editor to editor "repauftrag-644-5"
And I save the current editor

# Ausgabe Lieferschein
Given I open an editor "Lieferschein-view" from table "(Sales):(PackingSlip)" with command "VIEW" for record from editor "lieferschein-644-3"
And I close the current editor

# Storno Lieferschein
Given I open an editor "lieferschein" from table "(Sales):(PackingSlip)" with command "REVERSAL" for record from editor "lieferschein-644-3"
And I set field "num3" to "644-SLS3"
And I save the current editor

# Ausgabe Storno Lieferschein
Given I open an editor "lieferschein-view" from table "(Sales):(PackingSlip)" with command "VIEW" for record "+644-SLS3"
And I close the current editor

# Abgang Kundengeraet Lieferschein
Given I open an editor "repauftrag-644-5" from table "(Sales):(RepairOrder)" with command "UPDATE" for record from editor "repauftrag-644"
And I press button "repabg" to open a subeditor for "lieferschein-644-4"
And I set field "nummer" to "644-LS6"
And I set field "such" to "LS-644-6"
And I set field "ueb" to "ja"
And I save the current editor
And I switch the current editor to editor "repauftrag-644-5"
And I save the current editor

# Ausgabe Lieferschein
Given I open an editor "Lieferschein-view" from table "(Sales):(PackingSlip)" with command "VIEW" for record from editor "lieferschein-644-4"
And I close the current editor

# Fixme manuell Testen
# # Zugang Leihgeraet 
# Given I open an editor "repauftrag-640-6" from table "(Sales):(RepairOrder)" with command "UPDATE" for record from editor "repauftrag-640"
# And I press button "repzugl" to open a subeditor for "zugangsls-640-1"
# And I set field "nummer" to "640-LS7"
# And I set field "such" to "LS-640-7"
# And I set field "ueb" to "ja"
# And I save the current editor 
# And I switch the current editor to editor "repauftrag-640-6"
# And I save the current editor
# 
# # Ausgabe Lieferschein
# Given I open an editor "Lieferschein-view" from table "(Sales):(PackingSlip)" with command "VIEW" for record from editor "zugangsls-640-1"
# And I close the current editor
# 
# # Storno Lieferschein
# Given I open an editor "lieferschein" from table "(Sales):(PackingSlip)" with command "REVERSAL" for record from editor "zugangsls-640-1"
# And I set field "num3" to "644-SLS4"
# And I save the current editor
#
# # Ausgabe Storno Lieferschein
# Given I open an editor "lieferschein-view" from table "(Sales):(PackingSlip)" with command "VIEW" for record "+644-SLS4"
# And I close the current editor
#
# # Zugang Leihgeraet
# Given I open an editor "repauftrag-640-7" from table "(Sales):(RepairOrder)" with command "UPDATE" for record from editor "repauftrag-640"
# And I press button "repzugl" to open a subeditor for "zugangsls-640-2"
# And I set field "nummer" to "640-LS8"
# And I set field "such" to "LS-640-8"
# And I set field "ueb" to "ja"
# And I save the current editor
# And I switch the current editor to editor "repauftrag-640-7"
# And I save the current editor
# 
# # Ausgabe Lieferschein
# Given I open an editor "Lieferschein-view" from table "(Sales):(PackingSlip)" with command "VIEW" for record from editor "zugangsls-640-2"
# And I close the current editor

# Rechnung erstellen buchen
Given I open an editor "repauftrag-644-8" from table "(Sales):(RepairOrder)" with command "UPDATE" for record from editor "repauftrag-644"
And I press button "reanlegen" to open a subeditor for "rechnung-644"
And I set field "ueb" to "ja"
And I set field "nummer" to "644-RE"
And I set field "such" to "RE-644"
And I press button "offueb" in row 1
# And I press button "offueb" in row 2
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor
And I switch the current editor to editor "repauftrag-644-8"
And I save the current editor

# Ausgabe Rechnung
Given I open an editor "Rechnung-storno-view" from table "(Sales):(Invoice)" with command "VIEW" for record from editor "rechnung-644"
And I close the current editor

# Rechnung stornieren
Given I open an editor "st-rechnung-644" from table "(Sales):(Invoice)" with command "REVERSAL" for record from editor "rechnung-644"
And I set field "nummer" to "644-SRE"
And I save the current editor

# Ausgabe Storno Rechnung
Given I open an editor "Rechnung-storno-view" from table "(Sales):(Invoice)" with command "VIEW" for record from editor "st-rechnung-644"
And I close the current editor

# Rechnung erstellen buchen
Given I open an editor "repauftrag-644-9" from table "(Sales):(RepairOrder)" with command "UPDATE" for record from editor "repauftrag-644"
And I press button "reanlegen" to open a subeditor for "rechnung-644-2"
And I set field "ueb" to "ja"
And I set field "nummer" to "644-RE2"
And I set field "such" to "RE-644-2"
And I press button "offueb" in row 1
# And I press button "offueb" in row 2
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor
And I switch the current editor to editor "repauftrag-644-9"
And I save the current editor

# Ausgabe Rechnung
Given I open an editor "Rechnung-storno-view" from table "(Sales):(Invoice)" with command "VIEW" for record from editor "rechnung-644-2"
And I close the current editor

#####################################################################################################################################

Scenario: FALL-645
# FALL-645 Reparaturauftrag	Abgang Kundengeraet

# STAMMDATEN - E1 kopieren
Given I open an editor "E1-645" from table "(Part):(Product)" with command "COPY" for record "E1"
And I set field "such" to "E1-645"
And I set field "losgr" to "0"
And I set field "mindest" to "0"
And I save the current editor
# STAMMDATEN - E2 kopieren
Given I open an editor "E2-645" from table "(Part):(Product)" with command "COPY" for record "E2"
And I set field "such" to "E2-645"
And I set field "losgr" to "0"
And I set field "mindest" to "0"
And I save the current editor

# STAMMDATEN - BG1 kopieren
Given I open an editor "BG-645" from table "(Part):(Product)" with command "COPY" for record "BG1"
And I set field "such" to "BG-645"
And I set field "dispoa" to "Auftragsbezogen"
And I set field "mindest" to "0"
And I set field "elex" to "E1-645" in row 1
And I set field "tnwpflicht" to "ja" in row 1
And I save the current editor

# STAMMDATEN - Servicepflichtigen Artikel anlegen
Given I open an editor "serartikel-645" from table "(Part):(Product)" with command "STORE" for record ""
And I set field "such" to "FALL-645"
And I set field "namebspr" to "Service Artikel 645"
And I set field "vkbez" to "Service Artikel 645"
And I set field "vbez" to "Service Artikel 645"
And I set field "ebez" to "Service Artikel 645"
And I set field "vpr" to "1000"
And I set field "bsart" to "Eigenfertigung"
And I set field "dispoa" to "Auftragsbezogen"
And I set field "chimlager" to "ja"
And I set field "serpflicht" to "ja"
#Stückliste anlegen
And I create a new row at the end of the table
And I set field "elex" to "E2-645" in row 1
And I set field "elanzahl" to "2" in row 1
And I set field "tnwpflicht" to "ja" in row 1
And I set field "tersatzt" to "ja" in row 1
And I create a new row at the end of the table
And I set field "elex" to "A AG3" in row 2
And I create a new row at the end of the table
And I set field "elex" to "BG-645" in row 3
And I set field "elanzahl" to "1" in row 3
And I set field "tnwpflicht" to "ja" in row 3
And I set field "tverschlt" to "ja" in row 3
And I create a new row at the end of the table
And I set field "elex" to "A AG4" in row 4
And I save the current editor

# Rechnung anlegen
Given I open an editor "rechnung" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "lief" to "1"
And I set field "num4" to "645-RE"
And I set field "fakt" to "ja"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I create a new row at the end of the table
And I set field "artex" to "E1-645" in row 1
And I set field "mge" to "645" in row 1
And I set field "preis" to "645" in row 1
And I set field "platz" to "F2" in row 1
And I create a new row at the end of the table
And I set field "artex" to "E2-645" in row 2
And I set field "mge" to "645" in row 2
And I set field "preis" to "645" in row 2
And I set field "platz" to "F2" in row 2
And I set field "kenn" to "FALL-645"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Charge anlegen
Given I open an editor "charge" from table "(Lots):(Lots)" with command "STORE" for record "FALL-645"
And I set field "such" to "FALL-645"
And I set field "exnum" to "FALL-645"
And I set field "artikel" to id from editor "serartikel-645"
And I save the current editor

# Serviceprodukt als Kunden- und Leihgeraet anlegen
Given I open an editor "kundeng-645" from table "(ServiceProduct):(ServiceProduct)" with command "STORE" for record "KGSP-645"
And I set field "such" to "KGSP-645"
And I set field "namebspr" to "KGSP-645"
And I set field "artikel" to id from editor "serartikel-645"
And I save the current editor
And I switch the current editor to editor "kundeng-645"
And I set field "serprodtyp" to "Kundengerät"
And I set field "zuplatzlg" to ""
And I set field "abplatzlg" to ""
And I set field "charge" to ""
And I save the current editor

# Leihgeraet anlegen
Given I open an editor "leihgeraet-645" from table "(ServiceProduct):(ServiceProduct)" with command "STORE" for record "LHSP-645"
And I set field "such" to "LHSP-645"
And I set field "namebspr" to "Leihgeraet 645"
And I set field "artikel" to id from editor "serartikel-645"
And I save the current editor
And I switch the current editor to editor "leihgeraet-645"
And I set field "serprodtyp" to "Leihgeraet"
And I set field "zuplatzlg" to "F4"
And I set field "abplatzlg" to "F4"
And I set field "charge" to "FALL-645"
And I save the current editor

# Leihgeraet fertigen und aus Lager legen
Given I open an editor "fvanlegen" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
And I create a new row at the end of the table
And I set field "artikel" to id from editor "serartikel-645" in row 1
And I set field "mge" to "1" in row 1
And I set field "bisuch" to "LEIHBA" in row 1
And I set field "serprod" to id from editor "leihgeraet-645" in row 1
And I set field "platz" to "F4" in row 1
And I set field "mfreig" to "ja" in row 1
And I press button "freig" to open a subeditor for "fertigung"
And I close the current editor
And I switch the current editor to editor "fvanlegen"
And I close the current editor

#BA fuer Leihgeraet rueckmelden
Given I open an editor "rueckmelden" from table "(Workorder):(WorkOrders)" with command "DONE" for record "LEIHBA000"
And I set field "gut" to "ja"
And I set field "sofort" to "ja"
And I set field "mgr" to "101"
And I save the current editor

# Reparaturauftrag anlegen 
Given I open an editor "repauftrag-645" from table "(Sales):(RepairOrder)" with command "NEW" for record ""
And I set field "kunde" to id from editor "kunde"
And I set field "nummer" to "645-AU"
And I set field "such" to "AU-645"
And I create a new row at the end of the table
And I set field "serprod" to id from editor "kundeng-645" in row 1
Then the table has 2 rows
And I save the current editor

# Ausgabe Reparaturauftrag
Given I open an editor "Auftrag-view" from table "(Sales):(RepairOrder)" with command "VIEW" for record from editor "repauftrag-645"
And I close the current editor

# Zugang Kundengeraet
Given I open an editor "repauftrag-645-2" from table "(Sales):(RepairOrder)" with command "UPDATE" for record from editor "repauftrag-645"
And I press button "repzug" to open a subeditor for "zugangsls-645"
And I set field "nummer" to "645-LS1"
And I set field "such" to "LS-645-1"
And I set field "ueb" to "ja"
And I save the current editor
And I switch the current editor to editor "repauftrag-645-2"
And I save the current editor

# Abgang Kundengeraet Lieferschein
Given I open an editor "repauftrag-645-5" from table "(Sales):(RepairOrder)" with command "UPDATE" for record from editor "repauftrag-645"
And I press button "repabg" to open a subeditor for "lieferschein-645-3"
And I set field "nummer" to "645-LS2"
And I set field "such" to "LS-645-2"
And I set field "ueb" to "ja"
And I save the current editor
And I switch the current editor to editor "repauftrag-645-5"
And I save the current editor

# Ausgabe Lieferschein
Given I open an editor "Lieferschein-view" from table "(Sales):(PackingSlip)" with command "VIEW" for record from editor "lieferschein-645-3"
And I close the current editor

#####################################################################################################################################

Scenario: FALL-646
# FALL-646 Reparaturauftrag	Abgang Kundengeraet	Storno Lieferschein

# STAMMDATEN - E1 kopieren
Given I open an editor "E1-646" from table "(Part):(Product)" with command "COPY" for record "E1"
And I set field "such" to "E1-646"
And I set field "losgr" to "0"
And I set field "mindest" to "0"
And I save the current editor
# STAMMDATEN - E2 kopieren
Given I open an editor "E2-646" from table "(Part):(Product)" with command "COPY" for record "E2"
And I set field "such" to "E2-646"
And I set field "losgr" to "0"
And I set field "mindest" to "0"
And I save the current editor

# STAMMDATEN - BG1 kopieren
Given I open an editor "BG-646" from table "(Part):(Product)" with command "COPY" for record "BG1"
And I set field "such" to "BG-646"
And I set field "dispoa" to "Auftragsbezogen"
And I set field "mindest" to "0"
And I set field "elex" to "E1-646" in row 1
And I set field "tnwpflicht" to "ja" in row 1
And I save the current editor

# STAMMDATEN - Servicepflichtigen Artikel anlegen
Given I open an editor "serartikel-646" from table "(Part):(Product)" with command "STORE" for record ""
And I set field "such" to "FALL-646"
And I set field "namebspr" to "Service Artikel 646"
And I set field "vkbez" to "Service Artikel 646"
And I set field "vbez" to "Service Artikel 646"
And I set field "ebez" to "Service Artikel 646"
And I set field "vpr" to "1000"
And I set field "bsart" to "Eigenfertigung"
And I set field "dispoa" to "Auftragsbezogen"
And I set field "chimlager" to "ja"
And I set field "serpflicht" to "ja"
# Stueckliste anlegen
And I create a new row at the end of the table
And I set field "elex" to "E2-646" in row 1
And I set field "elanzahl" to "2" in row 1
And I set field "tnwpflicht" to "ja" in row 1
And I set field "tersatzt" to "ja" in row 1
And I create a new row at the end of the table
And I set field "elex" to "A AG3" in row 2
And I create a new row at the end of the table
And I set field "elex" to "BG-646" in row 3
And I set field "elanzahl" to "1" in row 3
And I set field "tnwpflicht" to "ja" in row 3
And I set field "tverschlt" to "ja" in row 3
And I create a new row at the end of the table
And I set field "elex" to "A AG4" in row 4
And I save the current editor

# Rechnung anlegen
Given I open an editor "rechnung" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "lief" to "1"
And I set field "num4" to "646-RE"
And I set field "fakt" to "ja"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I create a new row at the end of the table
And I set field "artex" to "E1-646" in row 1
And I set field "mge" to "646" in row 1
And I set field "preis" to "646" in row 1
And I set field "platz" to "F2" in row 1
And I create a new row at the end of the table
And I set field "artex" to "E2-646" in row 2
And I set field "mge" to "646" in row 2
And I set field "preis" to "646" in row 2
And I set field "platz" to "F2" in row 2
And I set field "kenn" to "FALL-646"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Charge anlegen
Given I open an editor "charge" from table "(Lots):(Lots)" with command "STORE" for record "FALL-646"
And I set field "such" to "FALL-646"
And I set field "exnum" to "FALL-646"
And I set field "artikel" to id from editor "serartikel-646"
And I save the current editor

# Serviceprodukt als Kunden- und Leihgeraet anlegen
Given I open an editor "kundeng-646" from table "(ServiceProduct):(ServiceProduct)" with command "STORE" for record "KGSP-646"
And I set field "such" to "KGSP-646"
And I set field "namebspr" to "KGSP-646"
And I set field "artikel" to id from editor "serartikel-646"
And I save the current editor
And I switch the current editor to editor "kundeng-646"
And I set field "serprodtyp" to "Kundengerät"
And I set field "zuplatzlg" to ""
And I set field "abplatzlg" to ""
And I set field "charge" to ""
And I save the current editor

# Leihgeraet anlegen
Given I open an editor "leihgeraet-646" from table "(ServiceProduct):(ServiceProduct)" with command "STORE" for record "LHSP-646"
And I set field "such" to "LHSP-646"
And I set field "namebspr" to "Leihgeraet 646"
And I set field "artikel" to id from editor "serartikel-646"
And I save the current editor
And I switch the current editor to editor "leihgeraet-646"
And I set field "serprodtyp" to "Leihgeraet"
And I set field "zuplatzlg" to "F4"
And I set field "abplatzlg" to "F4"
And I set field "charge" to "FALL-646"
And I save the current editor

# Leihgeraet fertigen und aus Lager legen
Given I open an editor "fvanlegen" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
And I create a new row at the end of the table
And I set field "artikel" to id from editor "serartikel-646" in row 1
And I set field "mge" to "1" in row 1
And I set field "bisuch" to "LEIHBA" in row 1
And I set field "serprod" to id from editor "leihgeraet-646" in row 1
And I set field "platz" to "F4" in row 1
And I set field "mfreig" to "ja" in row 1
And I press button "freig" to open a subeditor for "fertigung"
And I close the current editor
And I switch the current editor to editor "fvanlegen"
And I close the current editor

# BA fuer Leihgeraet rueckmelden
Given I open an editor "rueckmelden" from table "(Workorder):(WorkOrders)" with command "DONE" for record "LEIHBA000"
And I set field "gut" to "ja"
And I set field "sofort" to "ja"
And I set field "mgr" to "101"
And I save the current editor

# Reparaturauftrag anlegen 
Given I open an editor "repauftrag-646" from table "(Sales):(RepairOrder)" with command "NEW" for record ""
And I set field "kunde" to id from editor "kunde"
And I set field "nummer" to "646-AU"
And I set field "such" to "AU-646"
And I create a new row at the end of the table
And I set field "serprod" to id from editor "kundeng-646" in row 1
Then the table has 2 rows
And I save the current editor

# Ausgabe Reparaturauftrag
Given I open an editor "Auftrag-view" from table "(Sales):(RepairOrder)" with command "VIEW" for record from editor "repauftrag-646"
And I close the current editor

# Zugang Kundengeraet
Given I open an editor "repauftrag-646-2" from table "(Sales):(RepairOrder)" with command "UPDATE" for record from editor "repauftrag-646"
And I press button "repzug" to open a subeditor for "zugangsls-646"
And I set field "nummer" to "646-LS1"
And I set field "such" to "LS-646-1"
And I set field "ueb" to "ja"
And I save the current editor
And I switch the current editor to editor "repauftrag-646-2"
And I save the current editor

# Abgang Kundengeraet Lieferschein
Given I open an editor "repauftrag-646-5" from table "(Sales):(RepairOrder)" with command "UPDATE" for record from editor "repauftrag-646"
And I press button "repabg" to open a subeditor for "lieferschein-646-3"
And I set field "nummer" to "646-LS2"
And I set field "such" to "LS-646-2"
And I set field "ueb" to "ja"
And I save the current editor
And I switch the current editor to editor "repauftrag-646-5"
And I save the current editor

# Ausgabe Lieferschein
Given I open an editor "Lieferschein-view" from table "(Sales):(PackingSlip)" with command "VIEW" for record from editor "lieferschein-646-3"
And I close the current editor

# Storno Lieferschein
Given I open an editor "lieferschein" from table "(Sales):(PackingSlip)" with command "REVERSAL" for record from editor "lieferschein-646-3"
And I set field "num3" to "646-SLS1"
And I save the current editor

# Ausgabe Storno Lieferschein
Given I open an editor "lieferschein-view" from table "(Sales):(PackingSlip)" with command "VIEW" for record "+646-SLS1"
And I close the current editor

#####################################################################################################################################

# Reparaturauftrag anlegen, Storno der Zugangslieferschein fuer das Kundengeraet bzw. Abgangslieferscheins fuer das Leihgeraet pruefen

Scenario: STAMMDATEN - Neuen Kunden anlegen
Given I open an editor "kunde1" from table "(Customer):(Customer)" with command "STORE" for record "Bayram1"
And I set field "such" to "Bayram1"
And I set field "namebspr" to "Bayram1 Werkzeugbau, Rastatt"
And I set field "ans" to "Bayram1 Werkzeugbau GmbH"
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
Then field "name" has value "Bayram1 Werkzeugbau, Rastatt"
Then field "zbed" has value "201"

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
| ndienstl   | such         | namebspr     | preis |
| hdienstl   | dl-hanalyse  | Analyse in h | 60.00 |
| repdienstl | dl-reparatur | Reparatur    | 70.00 |

Scenario: STAMMDATEN - Servicepflichtigen Artikel anlegen
Given I open an editor "serart1" from table "(Part):(Product)" with command "STORE" for record ""
And I set field "such" to "SERART1"
And I set field "namebspr" to "Servicepflichtiger Artikel 1"
And I set field "vkbez" to "Servicepflichtiger Artikel 1"
And I set field "vbez" to "Servicepflichtiger Artikel 1"
And I set field "ebez" to "Servicepflichtiger Artikel 1"
And I set field "vpr" to "1000"
And I set field "bsart" to "Eigenfertigung"
And I set field "dispoa" to "Auftragsbezogen"
And I set field "chimlager" to "ja"
And I set field "serpflicht" to "ja"
And I save the current editor

Given I open an editor "charge" from table "(Lots):(Lots)" with command "NEW" for record ""
And I set field "such" to "LEIH"
And I set field "exnum" to "001"
And I set field "artikel" to id from editor "serart1"
And I save the current editor

Scenario Outline: Serviceprodukt als Kunden- und Leihgeraet anlegen
Given I open an editor "<serprodukt>" from table "(ServiceProduct):(ServiceProduct)" with command "NEW" for record ""
And I set field "such" to "<such>"
And I set field "namebspr" to "<namebspr>"
And I set field "artikel" to id from editor "<artikel>"
And I save the current editor
And I switch the current editor to editor "<serprodukt>"
And I set field "serprodtyp" to "<serprodtyp>"
And I set field "zuplatzlg" to "<zuplatzlg>"
And I set field "abplatzlg" to "<abplatzlg>"
And I set field "charge" to id from editor "<charge>"
And I save the current editor

Examples: Serviceprodukt
| serprodukt   | such  | namebspr | artikel | serprodtyp  | zuplatzlg | abplatzlg | charge      |
| kundeng1     | KGSP1 | KGSP1    | serart1 | Kundengerät |           |           | !dontChange |
| leihgeraet   | LHSP  | LHSP     | serart1 | Leihgerät   | F4        | F4        | charge      |

Scenario: Serviceprodukt ausliefern
Given I open an editor "auftrag1" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set field "kunde" to id from editor "kunde1"
And I create a new row at the end of the table
And I set field "artikel" to id from editor "serart1" in row 1
And I set field "mge" to "1" in row 1
And I set field "serprod" to id from editor "kundeng1" in row 1
And I save the current editor

# Disposition starten
And I run Scheduling

Scenario: Reparaturauftrag anlegen, Storno der Zugangsls und Abgangsls pruefen
Given I open an editor "repauf1" from table "(Sales):(RepairOrder)" with command "NEW" for record ""
And I set field "kunde" to id from editor "kunde1"
And I set field "nummer" to "1-RAU"
And I set field "such" to "RAU-1"
And I create a new row at the end of the table
And I set field "artex" to id from editor "serart1" in row 1
# Dienstleistung aufnehmen
And I create a new row at the end of the table
And I set field "artikel" to id from editor "dienstl" in row 3
And I set field "mge" to "1" in row 3
# Reparatur aufnehmen
And I create a new row at the end of the table
And I set field "artikel" to id from editor "repdienstl" in row 4
And I set field "mge" to "2" in row 4
# Kundengeraet annehmen
And I press button "repzug" to open a subeditor for "zugangsls-0"
And I set field "such" to "LS-1-ZUK1"
And I set field "nummer" to "1-LSZUK1"
And I set field "ueb" to "ja"
Then field "platz" has value "KONSI" in row 1
And I save the current editor
And I switch the current editor to editor "repauf1"
# Abgang des Leihgeraetes
And I press button "repabgl" to open a subeditor for "abgangsls-0"
And I set field "such" to "LS-1-ABL1"
And I set field "nummer" to "1-LSABL1"
And I set field "umplatz" to id from editor "Externerlp"
And I set field "ueb" to "ja"
Then field "platz" has value "F4" in row 1
And I save the current editor
And I switch the current editor to editor "repauf1"
And I save the current editor

Scenario: Abgangslieferschein fuer Leihgeraet stornieren, neu anlegen

# Abgangslieferschein für Leihgeraet stornieren
Given I open an editor "StornoLHABLS" from table "(Sales):(PackingSlip)" with command "REVERSAL" for record from editor "abgangsls-0"
And I set field "num3" to "1LSABL1S"
And I save the current editor

# Abgangslieferschein fuer das Leihgeraet nochmal anlegen
Given I open an editor "reparatur2" from table "(Sales):(RepairOrder)" with command "UPDATE" for record from editor "repauf1"
# Leihgeraet Abgangslieferschein nochmal anlegen
And I press button "repabgl" to open a subeditor for "abgangslls-2"
And I set field "nummer" to "1-LSABL2"
And I set field "such" to "LS-1-ABL2"
And I set field "umplatz" to id from editor "Externerlp"
And I set field "ueb" to "ja"
And I save the current editor
And I switch the current editor to editor "reparatur2"
And I save the current editor

# Nach Reparatur, Kundengeraet an Kunden zurueckgeben, Leihgeraet zurueckbekommen
Given I open an editor "repauftrag1" from table "(Sales):(RepairOrder)" with command "UPDATE" for record from editor "repauf1"
# Kundengeraet zurueckgeben: Abgangslieferschein fuer das Kundengeraet
And I press button "repabg" to open a subeditor for "abgangsls-1"
And I set field "nummer" to "1-LSABK1"
And I set field "such" to "LS-1-ABK1"
And I set field "ueb" to "ja"
Then field "platz" has value "KONSI" in row 1
And I save the current editor
And I switch the current editor to editor "repauftrag1"
# Zugang des Leihgeraets - Leihgeraet kommt zurueck
And I press button "repzugl" to open a subeditor for "zugangslls-1"
And I set field "nummer" to "1-LSZUL1"
And I set field "such" to "LS-1-ZUL1"
And I set field "ueb" to "ja"
Then field "umplatz" has value "F4"
Then field "platz" has value "EXTERN" in row 1
And I save the current editor
And I switch the current editor to editor "repauftrag1"
And I save the current editor

Scenario: Abgangslieferschein fuer Kunden bzw. Zugangslieferschein fuer Leihgeraet stornieren, neu anlegen

# Abgangslieferschein fuer Kundengeraet stornieren
Given I open an editor "1-LSABK1-Storno" from table "(Sales):(PackingSlip)" with command "REVERSAL" for record "+1-LSABK1"
And I set field "num3" to "1-SABK1"
And I save the current editor

# Zugangslieferschein fuer Leihgeraet stornieren
Given I open an editor "1-LSZUL1-Strono" from table "(Sales):(PackingSlip)" with command "REVERSAL" for record from editor "zugangslls-1"
And I set field "num3" to "1-SZUL1"
And I save the current editor

# Abgangs- und Zugangslieferschein nochmal anlegen
Given I open an editor "reparatur2" from table "(Sales):(RepairOrder)" with command "UPDATE" for record from editor "repauf1"
# Abgangslieferschein fuer Kundengeraet nochmal anlegen
And I press button "repabg" to open a subeditor for "abgangsls-2"
And I set field "nummer" to "1-LSABK2"
And I set field "such" to "LS-1-ABK2"
And I set field "ueb" to "ja"
Then field "platz" has value "KONSI" in row 1
And I save the current editor
And I switch the current editor to editor "reparatur2"
And I save the current editor

Given I open an editor "reparatur3" from table "(Sales):(RepairOrder)" with command "UPDATE" for record from editor "repauf1"
# Zugangslieferschein fuer Leihgeraet nochmal anlegen
And I press button "repzugl" to open a subeditor for "zugangslls-2"
And I set field "nummer" to "1-LSZUL2"
And I set field "such" to "LS-1-ZUL2"
And I set field "ueb" to "ja"
And I set field "umplatz" to "F4"
And I save the current editor
And I switch the current editor to editor "reparatur3"
And I save the current editor


Scenario: Zugangslieferschein kann nicht storniert werden (Fehlermeldung) weil inzwischen wurde es weiter verwendet

# Weiteren Raparatur-Auftrag anlegen fuer das Leihgeraet aus repau1
Given I open an editor "reparatur4" from table "(Sales):(RepairOrder)" with command "NEW" for record ""
And I set field "kunde" to id from editor "kunde1"
And I set field "nummer" to "4-RAU"
And I set field "such" to "RAU-4"
And I create a new row at the end of the table
And I set field "artex" to id from editor "serart1" in row 1
# Abgang des Leihgeraetes
And I press button "repabgl" to open a subeditor for "abgangsls-4"
And I set field "such" to "LS-4-ABL1"
And I set field "nummer" to "4-LSABL1"
And I set field "umplatz" to id from editor "Externerlp"
And I set field "ueb" to "ja"
Then field "platz" has value "F4" in row 1
And I save the current editor
And I switch the current editor to editor "reparatur4"
# Reparatur aufnehmen
And I create a new row at the end of the table
And I set field "artikel" to id from editor "repdienstl" in row 3
And I set field "mge" to "4" in row 3
And I save the current editor

# Zugangslieferschein aus reparatur3 fuer Leihgeraet darf nicht storniert werden
# "Storno nicht erlaubt. Leihgeraet ist einem anderen Vorgang zugeordnet."
And opening an editor from table "(Sales):(PackingSlip)" with command "REVERSAL" for record from editor "zugangslls-2" throws the exception "1875"


#####################################################################################################################################
Scenario: Reparaturauftrag und Kostenvoranschlag mit Rechnungspositionen

# Reparaturauftrag anlegen
Given I open an editor "repauftrag-5-RAU" from table "(Sales):(RepairOrder)" with command "NEW" for record ""
And I set field "kunde" to id from editor "kunde"
And I set field "nummer" to "5-RAU"
And I set field "such" to "RAU-5"
And I create a new row at the end of the table
And I set field "artikel" to "V1" in row 1
And I create a new row at the end of the table
And I set field "artikel" to "dl-hanalyse" in row 2
And I set field "mge" to "1" in row 2
And I create a new row at the end of the table
And I set field "artikel" to "NS" in row 3
Then the table has 5 rows
And I save the current editor

# Kostenvoranschlag zu Reparaturauftrag erzeugen
Given I open an editor "repauftrag-5-RAU-KV" from table "(Sales):(RepairOrder)" with command "UPDATE" for record from editor "repauftrag-5-RAU"
And I press button "kostenvorb" to open a subeditor for "kvb"
And I set field "nummer" to "5-RAU-KV"
And I set field "such" to "KV-5-RAU"
And I set field "bem" to "Kostenvoranschlag 5-RAU"
Then the table has 4 rows
And I save the current editor
And I switch the current editor to editor "repauftrag-5-RAU-KV"
And I save the current editor

# Rechnung erstellen
Given I open an editor "repauftrag-5-RAU-RE" from table "(Sales):(RepairOrder)" with command "UPDATE" for record from editor "repauftrag-5-RAU"
And I press button "reanlegen" to open a subeditor for "rechnung"
And I set field "ueb" to "ja"
And I set field "nummer" to "5-RAU-RE"
And I set field "such" to "RE-5-RAU"
And I press button "offueb" in row 1
Then the table has 4 rows
And I save the current editor

#####################################################################################################################################
Scenario: Angebot und Auftrag mit servicepflichtigen Artikel

# Servicepflichtigen Artikel anlegen
Given I open an editor "serart2" from table "(Part):(Product)" with command "STORE" for record ""
And I set field "such" to "SERART2"
And I set field "namebspr" to "Servicepflichtiger Artikel 2"
And I set field "vpr" to "200"
And I set field "bsart" to "Eigenfertigung"
And I set field "dispoa" to "Auftragsbezogen"
And I set field "serpflicht" to "ja"
# Stueckliste anlegen
And I create a new row at the end of the table
And I set field "elex" to "E3" in row 1
And I set field "elanzahl" to "2" in row 1
And I create a new row at the end of the table
And I set field "elex" to "A AG1" in row 2
And I save the current editor

Given I open an editor "serprod2A" from table "(ServiceProduct):(ServiceProduct)" with command "NEW" for record ""
And I set field "such" to "SP2A"
And I set field "namebspr" to "SP2A"
And I set field "artikel" to id from editor "serart2"
And I save the current editor

Given I open an editor "serprod2B" from table "(ServiceProduct):(ServiceProduct)" with command "NEW" for record ""
And I set field "such" to "SP2B"
And I set field "namebspr" to "SP2B"
And I set field "artikel" to id from editor "serart2"
And I save the current editor

# Angebot anlegen
Given I open an editor "ANSA2" from table "(Sales):(Quotation)" with command "NEW" for record ""
And I set fields
   | kunde   | 1        |
   | such    | ANSERV2  |
And I append rows
   | artikel | he     |
   | SERART2 | Stueck |
And I set field "mge" to "3" in row 1
# Fertigungsliste anlegen
And I press button "absteig" to open a subeditor for "AFL_Stufe_1" in row 1
Then the table has 1 rows
And I descend to a lower level of the BOM in row 1
Then the table has 2 rows
And I set field "anzahl" to "3" in row 1
And I ascend to a higher level of the BOM
And I save the current editor
And I switch the current editor to editor "ANSA2"
And I save the current editor

# Auftrag aus Angebot erzeugen
Given I open an editor "AUSA2" from table "(Sales):(Quotation)" with command "RELEASE" for record from editor "ANSA2"
And I set field "such" to "AUSERV2"
And I set field "mge" to "2" in row 1
And I set field "einplan" to "ja" in row 1
And I press button "mzsubm" to open a subeditor for "mzuord" in row 1
And I set field "zuomge" to "1" in row 1
And I set field "serprod" to id from editor "serprod2A" in row 1
And I create a new row at the end of the table
And I set field "zuomge" to "1" in row 2
And I set field "serprod" to id from editor "serprod2B" in row 2
And I save the current editor
And I switch the current editor to editor "AUSA2"
And I set field "beleg" to id from editor "ANSA2"
And I set field "mge" to "1" in row 2
And I set field "einplan" to "ja" in row 2
And I set field "serpflicht" to "nein" in row 2
And I save the current editor

# Auftrag aendern
Given I open an editor "AUSA2UP" from table "(Sales):(SalesOrder)" with command "UPDATE" for record from editor "AUSA2"
And I set field "mge" to "2" in row 2
And I save the current editor


#####################################################################################################################################

Scenario: Finale MKV
# Final noch mal eine Materialkostenverbuchung

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-000" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

 
#####################################################################################################################################
# 
# Hier ist dann das ENDE
# 
# 
