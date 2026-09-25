@persistent
Feature: ref_start_ohne_fkv_ohne fkogrp_cu
Background:
Given I set the fake date to "02.01.2002"

# *****************************************************************************
#  Name             : start_ohne_fkv_ohne_fkogrp.feature
#  Autor            : Silvia Warth
#  Verantwortlich   : sih
#  Kontrolle        : uo
#  Funktion         : Test des Ablaufs eines Geschäftsprozesses (Test soll alle Belegarten (typ279) abbilden: RM, Storno-RM, etc. (alle Fälle))
#
# *****************************************************************************
Scenario: 00 Stammdaten und Bestände für E1
Given I open an editor "konto" from table "(Account):(Account)" with command "COPY" for record "99800"
And I set field "nummer" to "88801"
And I set field "such" to "K88801"
And I save the current editor

Given I open an editor "konto" from table "(Account):(Account)" with command "COPY" for record "99800"
And I set field "nummer" to "88802"
And I set field "such" to "K88802"
And I save the current editor

Given I open an editor "bg" from table "(Part):(Product)" with command "COPY" for record "bg1"
And I set field "nummer" to "666"
And I set field "such" to "bg666"
And I delete row at position !lastRow
And I save the current editor

Given I open an editor "bg" from table "(Part):(Product)" with command "COPY" for record "bg1"
And I set field "nummer" to "999"
And I set field "such" to "bg999"
And I set field "manbu" to "ja" in row 1
And I delete row at position !lastRow
And I save the current editor

Given I open an editor "Lagerbuchung" for tip command "(Stockadjustment)" and arguments ""
And I set field "artikel" to "E1"
And I set field "buart" to "Zugang"
And I set field "beleg" to "L1"
And I set field "beldat" to "."
And I set field "mge" to "100" in row 1
And I set field "platz2" to "F1" in row 1
And I save the current editor

Given I open an editor "Lagerbuchung" for tip command "(Stockadjustment)" and arguments ""
And I set field "artikel" to "E1"
And I set field "buart" to "Zugang"
And I set field "beleg" to "L2"
And I set field "beldat" to "."
And I set field "mge" to "200" in row 1
And I set field "platz2" to "F2" in row 1
And I save the current editor

Scenario: 01 Fertigungsvorschlag anlegen, freigeben und AS rückmelden 
Given I open an editor "fvor1" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
And I append rows
| artikel| netmge| bisuch| mfreig|
| BG1    |     10| BG101_  | ja    |
And I press button "freig" to open a subeditor for "BA_freigeben"
And I close the current editor
And I switch the current editor to editor "fvor1"
And I save the current editor

# Rückmeldung auf ersten Arbeitsgang
Given I open an editor "RückmeldungBG101_001" from table "(Workorder):(WorkOrders)" with command "DONE" for record "BG101_001"
And I set field "bem" to "RueckmeldungBG1"
And I set field "ma" to "1"
And I set field "lgr" to "2"
And I set field "bzeit" to "1"
And I set field "lohnkostsoll" to "99800"
And I set field "lohnkosthaben" to "99900"
And I set field "mzeit" to "1"
And I set field "mkostfixsoll" to "88801"
And I set field "mkostfixhaben" to "88802"
And I set field "skostvarhaben" to "99900"
And I set field "sofort" to "ja"
And I set field "gutmge" to "2" in row 1
And I save the current editor

# Rückmeldung auf zweiten Arbeitsgang
Given I open an editor "RückmeldungBG101_002" from table "(Workorder):(WorkOrders)" with command "DONE" for record "BG101_002"
And I set field "bem" to "RueckmeldungBG1"
And I set field "ma" to "7802"
And I set field "lgr" to "2"
And I set field "bzeit" to "2"
And I set field "mzeit" to "2"
And I set field "skostvarsoll" to "88801"
And I set field "skostvarhaben" to "88802"
And I set field "sofort" to "ja"
And I set field "gutmge" to "2" in row 1
And I save the current editor

Scenario: 01a Fertigungsvorschlag anlegen, freigeben und AS rückmelden 
Given I open an editor "fvor2" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
And I append rows
| artikel| netmge| bisuch| mfreig|
| BG1    |     20| BG1a_  | ja    |
And I press button "freig" to open a subeditor for "BA_freigeben"
And I close the current editor
And I switch the current editor to editor "fvor2"
And I save the current editor

# Rückmeldung auf ersten Arbeitsgang
Given I open an editor "RM_BG1a" from table "(Workorder):(WorkOrders)" with command "DONE" for record "BG1a_001"
And I set field "bem" to "RM_BG1a"
And I set field "ma" to "1"
And I set field "lgr" to "2"
And I set field "bzeit" to "1"
And I set field "lohnkostsoll" to "99800"
And I set field "lohnkosthaben" to "99900"
And I set field "mzeit" to "1"
And I set field "mkostfixsoll" to "88801"
And I set field "mkostfixhaben" to "88802"
And I set field "skostvarhaben" to "99900"
And I set field "sofort" to "ja"
And I set field "gutmge" to "2" in row 1
And I save the current editor

Scenario: 02 Fertigungsvorschlag anlegen, freigeben und Rückmeldung buchen (komplett)
Given I open an editor "fvor2" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
And I append rows
| artikel| netmge| bisuch| mfreig|
| BG1    |     20| BG102_  | ja    |
And I press button "freig" to open a subeditor for "BA_freigeben"
And I close the current editor
And I switch the current editor to editor "fvor2"
And I save the current editor

# Rückmeldung auf ersten Arbeitsgang
Given I open an editor "RückmeldungBG102_001" from table "(Workorder):(WorkOrders)" with command "DONE" for record "BG102_001"
And I set field "bem" to "VollRMBG1_001"
And I set field "ma" to "7801"
And I set field "lgr" to "4"
And I set field "bzeit" to "2"
And I set field "mzeit" to "3"
And I set field "sofort" to "ja"
And I set field "gut" to "ja"
And I set field "lohnkostsoll" to "88801"
And I set field "sofort" to "ja"
And I save the current editor

# Rückmeldung auf zweiten Arbeitsgang
Given I open an editor "RückmeldungBG102_002" from table "(Workorder):(WorkOrders)" with command "DONE" for record "BG102_002"
And I set field "bem" to "VollRMBG1_002"
And I set field "ma" to "7802"
And I set field "lgr" to "3"
And I set field "bzeit" to "1"
And I set field "mzeit" to "2"
And I set field "gut" to "ja"
And I set field "mkostfixsoll" to "99800"
And I set field "mkostfixhaben" to "99900"
And I set field "sofort" to "ja"
And I save the current editor

Scenario: 03 Zeitrückmeldungen
Given I open an editor "Zeitbuchung1" for tip command "Zeitbuchung" and arguments ""
And I set field "barmex" to "1001" 
And I set field "lgr" to "1"
And I set field "bzeit" to "3"
And I set field "mzeit" to "3"
And I save the current editor

Scenario: 04 Zeitkorrektur
Given I open an editor "fvor3" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
And I append rows
| artikel| netmge| bisuch| mfreig|
| BG1    |     10| BG103_  | ja    |
And I press button "freig" to open a subeditor for "BA_freigeben"
And I close the current editor
And I switch the current editor to editor "fvor3"
And I save the current editor

# Rückmeldung auf ersten Arbeitsgang
Given I open an editor "RückmeldungBG103_001" from table "(Workorder):(WorkOrders)" with command "DONE" for record "BG103_001"
And I set field "ma" to "7801"
And I set field "lgr" to "4"
And I set field "bzeit" to "2"
And I set field "mzeit" to "3"
And I set field "sofort" to "ja"
And I set field "gut" to "ja"
And I set field "sofort" to "ja"
And I save the current editor

Given I open an editor "Zeitkorrektur4" for tip command "Zeitbuchung" and arguments ""
And I set field "barmex" to "nummer" from editor "RückmeldungBG103_001"
And I set field "sofort" to "ja"
And I set field "lgr" to "4"
And I set field "bzeit" to "-0,5"
And I set field "lohnkostsoll" to "99800"
And I set field "lohnkosthaben" to "99900"
And I save the current editor

Scenario: 05 Materialentnahme für Betriebsauftrag
Given I open an editor "fvor4" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
And I append rows
| artikel| netmge| bisuch | mfreig|
| BG999  |      5| BG9_   | ja    |
And I press button "freig" to open a subeditor for "BA_freigeben"
And I close the current editor
And I switch the current editor to editor "fvor4"
And I save the current editor

# Materialentnahme für Betriebsauftrag
Given I open an editor "Materialentnahme" for tip command "Fbuchung" and arguments ""
And I set field "auftrag" to "BG9_000" 
And I press button "stllad"
And I save the current editor

Scenario: 06 Zeitkorrektur
#Given I open an editor "Zeitbuchung3" for tip command "Zeitbuchung" and arguments ""
#And I set field "barmex" to "1003"
#And I set field "ma" to "7801"
#And I set field "lgr" to "1"
#And I set field "bzeit" to "-1"
#And I set field "mzeit" to "-0,5"
#And I save the current editor

Scenario: 07 Nachbuchen (Rückmeldung) auf abgelegten Fertigungsvorschlag
Given I open an editor "RM1" from table "(Workorder):(CompletionConfirmations)" with command "NEW" for search criteria "$,,such=BG102_001;@richtung=rückwärts;@ablageart=abgelegt;@maxtreffer=1"             
And I set field "bem" to "VollRMBG1_001"
And I set field "ma" to "7801"
And I set field "lgr" to "4"
And I set field "bzeit" to "4"
And I set field "mzeit" to "4"
And I save the current editor

Scenario: 08 Rückbau auf Betriebsauftrag
Given I open an editor "RM1" from table "(Workorder):(WorkOrders)" with command "RETURN" for record "1001001"
And I set field "sofort" to "ja"
And I set field "bem" to "Rückbau RM1"
And I set field "gutmge" to "-1" in row 1
And I save the current editor

Scenario: 09 Zeitrückmeldung auf abgelegten FV
# Fertigungsvorschlag anlegen, freigeben und Rückmeldung buchen (komplett)
Given I open an editor "fvor10" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
And I append rows
| artikel| mge| bisuch  | mfreig|
| BG666  |   10| BG6_ | ja    |
And I press button "freig" to open a subeditor for "BA_freigeben"
And I close the current editor
And I switch the current editor to editor "fvor10"
And I save the current editor

Scenario: 10 Zeitbuchung und Zeitkorrektur auf abgelegten Fertigungsvorschlag
# Rückmeldung auf BA
Given I open an editor "RückmeldungBA" from table "(Workorder):(WorkOrders)" with command "DONE" for record "BG6_000"
And I set field "ma" to "7801"
And I set field "lgr" to "4"
And I set field "bzeit" to "1"
And I set field "mzeit" to "1"
And I set field "sofort" to "ja"
And I save the current editor

# Komplettrückmeldung auf Arbeitschein
Given I open an editor "RückmeldungBG6_001" from table "(Workorder):(WorkOrders)" with command "DONE" for record "BG6_001"
And I set fields
| sofort| ja|
| gut   | ja|
| bzeit | 1.25|
| mzeit | 1.25|
And I save the current editor

Given I open an editor "Zeitbuchung" for tip command "Zeitbuchung" and arguments ""
And I set field "barmex" to id from editor "RückmeldungBG6_001"
And I set field "mgr" to "101"
And I set field "lgr" to "1"
And I set field "bzeit" to "1"
And I set field "mzeit" to "1"
And I save the current editor

Given I open an editor "Zeitbuchung" for tip command "Zeitbuchung" and arguments ""
And I set field "barmex" to id from editor "RückmeldungBA"
Then field "sofort" has value "ja"
Then field "sofort" is not modifiable
And I set fields
   | lgr    | 4    |
   | bzeit  | -0,5 |
   | mzeit  | -0,5 |
   | mkostvarsoll  | 88801 |
   | mkostvarhaben | 88802 |
And I save the current editor

Scenario: 11 Rückbau auf abgelegten Fertigungsvorschlag 
# Rückbau auf abgelegten BA
Given I open an editor "Rbau1" via ID from editor "RückmeldungBA" from field "id" in row 0 for table "(Workorder):(CompletionConfirmations)" with command "COPY"
And I set field "bem" to "Rückbau Rbau1"
And I modify table
| !row| mge|
| 2   | -1 |
And I save the current editor

Scenario: 12 Rückmeldung ohne Fertigungsvorschlag
Given I open an editor "RM_ohneFV" from table "(Workorder):(CompletionConfirmations)" with command "NEW" for record ""
And I set fields
    | barmex    | 1010   |
    | such      | RM1010 |
    | mgr       | 101    |
    | artikel   | BG666  |
    | kstelle   | 100    |
    | lgr       |    1   |
    | bzeit     |    2   |
    | mzeit     |    2   |
And I append rows
| artikel | mge |
| E1      | 4   |
| E2      | 6   |
And I save the current editor
Then field "typa279" has value "Rückmeldung ohne Fertigungsvorschlag"

Scenario: 13 Rückbau auf Betriebsauftrag
# Fertigungsvorschlag anlegen, freigeben und Rückmeldung buchen (komplett)
Given I open an editor "fvor10" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
And I append rows
| artikel| mge | bisuch   | mfreig|
| BG666  |   20| BG61_ | ja    |
And I press button "freig" to open a subeditor for "BA_freigeben"
And I close the current editor
And I switch the current editor to editor "fvor10"
And I save the current editor

# Rückmeldung auf Arbeitschein
Given I open an editor "Rückmeldung12" from table "(Workorder):(WorkOrders)" with command "DONE" for record "BG61_001"
And I set fields
| sofort| ja|
| bzeit | 1|
| mzeit | 1|
And I set field "gutmge" to "10" in row 1
And I save the current editor

Given I open an editor "RM2" from table "(Workorder):(WorkOrders)" with command "RETURN" for record "BG61_001"
And I set field "sofort" to "ja"
And I set field "gutmge" to "-1" in row 1
And I set field "bem" to "Rückbau RM2"
And I save the current editor

Scenario: 14 nochmal Rückmeldungen (neue FV und RM anlegen)

Given I open an editor "fvor98" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
And I append rows
| artikel| netmge| bisuch| mfreig|
| BG1    |     98| BG198_  | ja    |
And I press button "freig" to open a subeditor for "BA_freigeben"
And I close the current editor
And I switch the current editor to editor "fvor98"
And I save the current editor

Given I open an editor "fvor99" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
And I append rows
| artikel| netmge| bisuch| mfreig|
| BG1    |     99| BG199_  | ja    |
And I press button "freig" to open a subeditor for "BA_freigeben"
And I close the current editor
And I switch the current editor to editor "fvor99"
And I save the current editor

# Rückmeldung auf ersten Arbeitsgang XYZ_001
Given I open an editor "RM_BG198" from table "(Workorder):(WorkOrders)" with command "DONE" for record "BG198_001"
And I set field "bem" to "RM198001_1"
And I set field "ma" to "1"
And I set field "lgr" to "2"
And I set field "bzeit" to "1"
And I set field "mzeit" to "1"
And I set field "lohnkostsoll" to "99800"
And I set field "lohnkosthaben" to "99900"
And I set field "sofort" to "ja"
And I set field "gutmge" to "1" in row 1
And I save the current editor

# Rückmeldung auf ersten Arbeitsgang 1003001
Given I open an editor "RM_BG199" from table "(Workorder):(WorkOrders)" with command "DONE" for record "BG199_001"
And I set field "bem" to "RM199003_1"
And I set field "ma" to "7801"
And I set field "lgr" to "4"
And I set field "bzeit" to "1"
And I set field "mzeit" to "1"
And I set field "mkostfixsoll" to "99800"
And I set field "skostvarhaben" to "99900"
And I set field "sofort" to "ja"
And I set field "gutmge" to "1" in row 1
And I save the current editor

Scenario: 15 Vorbereitung für Zeitkorrektur komplett (d.h. gesamte Zeit wird zurück gesetzt)
Given I open an editor "fvor4" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
And I append rows
| artikel| netmge| bisuch| mfreig|
| BG1    |    120| BG120_  | ja    |
And I press button "freig" to open a subeditor for "BA_freigeben"
And I close the current editor
And I switch the current editor to editor "fvor4"
And I save the current editor

# Rückmeldung auf ersten Arbeitsgang
Given I open an editor "RückmeldungBG120_001" from table "(Workorder):(WorkOrders)" with command "DONE" for record "BG120_001"
And I set field "ma" to "7801"
And I set field "lgr" to "4"
And I set field "bzeit" to "2"
And I set field "mzeit" to "3"
And I set field "sofort" to "ja"
And I set field "gut" to "ja"
And I set field "sofort" to "ja"
And I save the current editor

Scenario: 16 Vorbereitung für Zeitkorrektur teilweise (d.h. Teil der Zeit wird zurück gesetzt)
Given I open an editor "fvor5" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
And I append rows
| artikel| netmge| bisuch| mfreig|
| BG1    |    130| BG130_  | ja    |
And I press button "freig" to open a subeditor for "BA_freigeben"
And I close the current editor
And I switch the current editor to editor "fvor5"
And I save the current editor

# Rückmeldung auf ersten Arbeitsgang
Given I open an editor "RückmeldungBG130_001" from table "(Workorder):(WorkOrders)" with command "DONE" for record "BG130_001"
And I set field "ma" to "7802"
And I set field "lgr" to "4"
And I set field "bzeit" to "4"
And I set field "mzeit" to "8"
And I set field "sofort" to "ja"
And I set field "gut" to "ja"
And I set field "sofort" to "ja"
And I save the current editor

Scenario: 17 Rückmeldung aus Serviceabwicklung
# Stammdaten - Neuen Kunden anlegen
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

# Stammdaten - Techniker anlegen
Given I open an editor "techniker" from table "(ServiceEmployees):(EmployeeRole)" with command "STORE" for record "techniker"
And I set field "such" to "techniker"
And I set field "namebspr" to "Techniker"
And I set field "ma" to "test"
And I save the current editor

# Stammdaten - Dienstleistung anlegen
Given I open an editor "dienstl" from table "(Part):(Service)" with command "STORE" for record "dl-analyse"
And I set field "such" to "dl-analyse"
And I set field "namebspr" to "Anlayse"
And I set field "vpr" to "50.00"
And I create a new row at the end of the table
And I set field "elex" to "A AG1" in row 1
And I save the current editor

# Stammdaten - E1 kopieren
Given I open an editor "E1-17" from table "(Part):(Product)" with command "COPY" for record "E1"
And I set field "such" to "E1-17"
And I set field "losgr" to "0"
And I set field "mindest" to "0"
And I save the current editor
# Stammdaten - E2 kopieren
Given I open an editor "E2-17" from table "(Part):(Product)" with command "COPY" for record "E2"
And I set field "such" to "E2-17"
And I set field "losgr" to "0"
And I set field "mindest" to "0"
And I save the current editor

# Stammdaten - BG1 kopieren
Given I open an editor "BG-17" from table "(Part):(Product)" with command "COPY" for record "BG1"
And I set field "such" to "BG-17"
And I set field "dispoa" to "Auftragsbezogen"
And I set field "mindest" to "0"
And I set field "elex" to "E1-17" in row 1
And I set field "tnwpflicht" to "ja" in row 1
And I save the current editor

# Stammdaten - Servicepflichtigen Artikel anlegen
Given I open an editor "serartikel-17" from table "(Part):(Product)" with command "STORE" for record ""
And I set field "such" to "Scenario-17"
And I set field "namebspr" to "Service Artikel 17"
And I set field "vkbez" to "Service Artikel 17"
And I set field "vbez" to "Service Artikel 17"
And I set field "ebez" to "Service Artikel 17"
And I set field "vpr" to "1000"
And I set field "bsart" to "Eigenfertigung"
And I set field "dispoa" to "Auftragsbezogen"
And I set field "chimlager" to "ja"
And I set field "serpflicht" to "ja"
# Stückliste anlegen
And I create a new row at the end of the table
And I set field "elex" to "E2-17" in row 1
And I set field "elanzahl" to "2" in row 1
And I set field "tnwpflicht" to "ja" in row 1
And I set field "tersatzt" to "ja" in row 1
And I create a new row at the end of the table
And I set field "elex" to "A AG3" in row 2
And I create a new row at the end of the table
And I set field "elex" to "BG-17" in row 3
And I set field "elanzahl" to "1" in row 3
And I set field "tnwpflicht" to "ja" in row 3
And I set field "tverschlt" to "ja" in row 3
And I create a new row at the end of the table
And I set field "elex" to "A AG4" in row 4
And I save the current editor

# Rechnung anlegen
Given I open an editor "rechnung" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "lief" to "1"
And I set field "num4" to "17-RE"
And I set field "fakt" to "ja"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I create a new row at the end of the table
And I set field "artex" to "E1-17" in row 1
And I set field "mge" to "17" in row 1
And I set field "preis" to "17" in row 1
And I set field "platz" to "F2" in row 1
And I set field "kstelle" to "100" in row 1
And I create a new row at the end of the table
And I set field "artex" to "E2-17" in row 2
And I set field "mge" to "17" in row 2
And I set field "preis" to "17" in row 2
And I set field "platz" to "F2" in row 2
And I set field "kenn" to "FALL-17"
And I set field "kstelle" to "100" in row 2
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Charge anlegen
Given I open an editor "charge" from table "(Lots):(Lots)" with command "STORE" for record "FALL-17"
And I set field "such" to "FALL-17"
And I set field "exnum" to "FALL-17"
And I set field "artikel" to id from editor "serartikel-17"
And I save the current editor

# Serviceprodukt als Kunden- und Leihgeraet anlegen
Given I open an editor "kundeng-17" from table "(ServiceProduct):(ServiceProduct)" with command "STORE" for record "KGSP-17"
And I set field "such" to "KGSP-17"
And I set field "namebspr" to "KGSP-17"
And I set field "artikel" to id from editor "serartikel-17"
And I save the current editor
And I switch the current editor to editor "kundeng-17"
And I set field "serprodtyp" to "Kundengerät"
And I set field "zuplatzlg" to ""
And I set field "abplatzlg" to ""
And I set field "charge" to ""
And I save the current editor

# Serviceauftrag erstellen 
Given I open an editor "serauftrag-17" from table "(Sales):(ServiceOrder)" with command "NEW" for record ""
And I set field "kunde" to id from editor "kunde"
And I set field "vserprod" to id from editor "kundeng-17"
And I set field "nummer" to "17-SAU"
And I set field "such" to "SAU-17"
And I create a new row at the end of the table
And I set field "techniker" to id from editor "techniker" in row 1
And I set field "artikel" to id from editor "dienstl" in row 1
And I set field "mge" to "1" in row 1
And I set field "zzvon" to "8" in row 1
And I set field "zzbis" to "12" in row 1
And I set field "kstelle" to "100" in row 1
And I create a new row at the end of the table
And I set field "techniker" to id from editor "techniker" in row 2
And I set field "artikel" to "E2-17" in row 2
And I set field "mge" to "1" in row 2
And I set field "kstelle" to "100" in row 2
And I save the current editor

# Ausgabe Serviceauftrag
Given I open an editor "Serviceauftrag-view" from table "(Sales):(ServiceOrder)" with command "VIEW" for record from editor "serauftrag-17"
And I close the current editor

# Fall/Scenario 17 - Servicerueckmeldung durchfuehren
Given I open an editor "srmeldung-17" from table "(ServiceReservation):(EngineerCompletionConfirmations)" with command "NEW" for record ""
And I set field "techniker" to id from editor "techniker"
And I set field "servau" to id from editor "serauftrag-17"
And I press button "ladetab"
Then the table has 2 rows
And I set field "kstelle" to "101"
And I set field "buchen" to "ja" in row 1
And I set field "dauer" to "4h" in row 1
And I set field "buchen" to "ja" in row 2
And I set field "serstlsts" to "wird aktualisiert" in row 2
And I save the current editor

# Lieferschein erzeugen und buchen
Given I open an editor "lieferschein-17" from table "(Sales):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "serauftrag-17"
And I set field "nummer" to "17-LS"
And I set field "such" to "LS-17"
And I set field "ueb" to "ja"
Then the table has 1 rows
And I set field "mge" to "1" in row 1
And I save the current editor

# Ausgabe Lieferschein
Given I open an editor "Lieferschein-view" from table "(Sales):(PackingSlip)" with command "VIEW" for record from editor "lieferschein-17"
And I close the current editor

