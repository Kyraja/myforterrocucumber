
# *****************************************************************************
#  Name           : fertleist_konten.feature
#  Autor          : sih
#  Verantwortlich : sih
#  Kontrolle      : wane
#  Funktion       : Test der Plausibilisierung der Fertigungsleistungskonten in der Rückmeldung.
#                   Anlage von Konten und Plausibilisierung beim Eintragen der Konten in die Rückmeldung.
#                   Datenfluss: Stammdaten in Rueckmeldung und Rueckmeldung in Bewertung
#
# *****************************************************************************
@persistent
Feature: REWE-2249 (Plausibilisierung der Fertigungsleistungskonten in der Rückmeldung)
Background:
Given I set the fake date to "02.01.1995"


Scenario: 01 Diverse Konten anlegen

# GuV-Konto ohne Eintrag im Feld "Statistisches Konto"
Given I open an editor "konto" from table "(Account):(Account)" with command "COPY" for record "99800"
And I set field "nummer" to "99001"
And I set field "such" to "K99001"
And I set field "stat" to ""
And I save the current editor

# GuV-Konto mit dem Eintrag "Euro-Eröffnung" im Feld "Statistisches Konto"
Given I open an editor "konto" from table "(Account):(Account)" with command "COPY" for record "99800"
And I set field "nummer" to "99002"
And I set field "such" to "K99002"
And I set field "stata" to "Euro"
And I save the current editor

# Bilanzkonto mit dem Eintrag "Kostenerchnnung" im Feld "Statistisches Konto"
Given I open an editor "konto" from table "(Account):(Account)" with command "COPY" for record "10000"
And I set field "nummer" to "99003"
And I set field "such" to "K99003"
And I set field "stat" to "K"
And I set field "gv" to "nein"
And I save the current editor

# Bilanzkonto ohne Eintrag im Feld "Statistisches Konto"
Given I open an editor "konto" from table "(Account):(Account)" with command "COPY" for record "10000"
And I set field "nummer" to "99004"
And I set field "such" to "K99004"
And I set field "stat" to ""
And I save the current editor

# Bilanzkonto mit dem Eintrag "Euro-Eröffnung" im Feld "Statistisches Konto"
Given I open an editor "konto" from table "(Account):(Account)" with command "COPY" for record "10000"
And I set field "nummer" to "99005"
And I set field "such" to "K99005"
And I set field "stata" to "Euro"
And I save the current editor

# GuV-Verdichtungs-Konto mit dem Eintrag "Kostenrechnung" im Feld "Statistisches Konto"
Given I open an editor "konto" from table "(Account):(Account)" with command "COPY" for record "99800"
And I set field "nummer" to "99006"
And I set field "such" to "K99006"
And I set field "stata" to "K"
And I set field "bebuchbar" to "nein"
And I save the current editor

# Bilanz-Verdichtungskonto mit dem Eintrag "Kostenerchnnung" im Feld "Statistisches Konto"
Given I open an editor "konto" from table "(Account):(Account)" with command "COPY" for record "10000"
And I set field "nummer" to "99007"
And I set field "such" to "K99007"
And I set field "stat" to "K"
And I set field "gv" to "nein"
And I set field "bebuchbar" to "nein"
And I save the current editor


Scenario: 02 Eintrag der Konten in die Kst Bereich Fertigungskostenverbuchung

Given I open an editor "ko" from table "(ProductionAccountsGroup):(ProductionAccountsGroup)" with command "UPDATE" for record "100"
Then setting field "belast" to "99001" in row 1 throws the exception "2986"
Then setting field "belast" to "99002" in row 1 throws the exception "2986"
Then setting field "belast" to "99003" in row 1 throws the exception "259"
Then setting field "belast" to "99004" in row 1 throws the exception "2986"
Then setting field "belast" to "99005" in row 1 throws the exception "2986"
Then setting field "belast" to "99006" in row 1 throws the exception "53"
Then setting field "belast" to "99007" in row 1 throws the exception "259"
And I save the current editor


Scenario: 03 Kontenstamm und Mitarbeiterstamm erweitern

Given I open an editor "Mitarbeiter" from table "(Employee):(Employee)" with command "UPDATE" for record "1"
And I set field "lohn" to " "
And I set field "kstelle" to "100"
And I save the current editor

Given I open an editor "Mitarbeiter" from table "(Employee):(Employee)" with command "UPDATE" for record "7801"
And I set field "kstelle" to "101"
And I set field "lohn" to " "
And I save the current editor

Given I open an editor "Mitarbeiter" from table "(Employee):(Employee)" with command "UPDATE" for record "7802"
And I set field "kstelle" to "100000"
And I set field "lohn" to " "
And I save the current editor



Scenario: 04 Eintrag der Konten in die Rueckmeldung Bereich Fertigungskostenverbuchung

# Fertigungsvorschlag anlegen und freigeben
Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
And I append rows
    | artikel   | netmge    | bisuch    | mfreig    | binoloe   |
    | bg        | 10        | ARTBG_    | ja        | ja        |
And I press button "freig" to open a subeditor for "BA_freigeben"
And I close the current editor
And I switch the current editor to editor "fvor"
And I save the current editor

# Rueckmeldung auf ersten Arbeitsgang
Given I open an editor "Rueckmeldung1" from table "(Workorder):(WorkOrders)" with command "DONE" for record "ARTBG_001"
And I set fields
#    | sofort    | 1     |
    | ma        | 7801  |
    | lgr       | 4     |
    | bzeit     | 1,5   |
    | mzeit     | 1,5   |
    | gut       | 1     |
Then setting field "mkostfixsoll" to "99001" throws the exception "2986"
Then setting field "mkostfixsoll" to "99002" throws the exception "2986"
Then setting field "mkostfixsoll" to "99003" throws the exception "259"
Then setting field "mkostfixsoll" to "99004" throws the exception "2986"
Then setting field "mkostfixsoll" to "99005" throws the exception "2986"
Then setting field "mkostfixsoll" to "99006" throws the exception "53"
Then setting field "mkostfixsoll" to "99007" throws the exception "259"
And I set field "mkostfixsoll" to "99800"
And I set field "mkostfixhaben" to "99900"
And I set field "skostfixsoll" to "99800"
And I set field "skostfixhaben" to "99900"
And I set field "skostvarsoll" to "99800"
And I set field "skostvarhaben" to "99900"
And I set field "mkostvarsoll" to "99800"
And I set field "mkostvarhaben" to "99900"
#And I set field "makstl" to "101"
# Lohnkonten stammen aus Kst 101
And I save the current editor


Scenario: 05 Setzen des Startdatum Kostenrechnung 

# Lohnkonten aus Kst 101 entfernen
# Startdatum Kostenrechnung eintragen, statistiche Kostenart anlegen und neues statistisches Konto anlegen, welches diese Kostenart benutzt
Given I open an editor "Termine" from table "(Company):(FinancialDates)" with command "UPDATE" for record "term"
And I set field "babkoartgj" to "95"
And I set field "babkoartgm" to "1"
And I save the current editor

Given I open an editor "Kostenart" from table "(CostType):(CostType)" with command "NEW" for record ""
And I set field "nummer" to "5aoz"
And I set field "such" to "k"
And I save the current editor

Given I open an editor "Kostenart" from table "(CostType):(CostType)" with command "NEW" for record ""
And I set field "nummer" to "99999"
And I set field "such" to "k"
And I set field "stat" to "ja"
And I save the current editor

Given I open an editor "Konto" from table "(Account):(Account)" with command "COPY" for record "99800"
And I set field "nummer" to "99123"
And I set field "such" to "K99123"
And I set field "stat" to "K"
And I set field "hkost" to "ja"
And I create a new row at the end of the table
And I set field "zkoart" to "99999" in row 1
And I save the current editor

Given I open an editor "Konto" from table "(Account):(Account)" with command "UPDATE" for record "5aoz"
And I create a new row at the end of the table
And I set field "zkoart" to "5aoz" in row 1
And I save the current editor

Given I open an editor "Konto" from table "(Account):(Account)" with command "UPDATE" for record "88100"
And I create a new row at the end of the table
And I set field "zkoart" to "99999" in row 1
And I save the current editor

Given I open an editor "Konto" from table "(Account):(Account)" with command "UPDATE" for record "88101"
And I create a new row at the end of the table
And I set field "zkoart" to "99999" in row 1
And I save the current editor

Given I open an editor "Konto" from table "(Account):(Account)" with command "UPDATE" for record "88200"
And I create a new row at the end of the table
And I set field "zkoart" to "99999" in row 1
And I save the current editor

Given I open an editor "Konto" from table "(Account):(Account)" with command "UPDATE" for record "88201"
And I create a new row at the end of the table
And I set field "zkoart" to "99999" in row 1
And I save the current editor

Given I open an editor "Konto" from table "(Account):(Account)" with command "UPDATE" for record "88300"
And I create a new row at the end of the table
And I set field "zkoart" to "99999" in row 1
And I save the current editor

Given I open an editor "Konto" from table "(Account):(Account)" with command "UPDATE" for record "88301"
And I create a new row at the end of the table
And I set field "zkoart" to "99999" in row 1
And I save the current editor

Given I open an editor "Konto" from table "(Account):(Account)" with command "UPDATE" for record "88400"
And I create a new row at the end of the table
And I set field "zkoart" to "99999" in row 1
And I save the current editor

Given I open an editor "Konto" from table "(Account):(Account)" with command "UPDATE" for record "88401"
And I create a new row at the end of the table
And I set field "zkoart" to "99999" in row 1
And I save the current editor

Given I open an editor "Konto" from table "(Account):(Account)" with command "UPDATE" for record "88500"
And I create a new row at the end of the table
And I set field "zkoart" to "99999" in row 1
And I save the current editor

Given I open an editor "Konto" from table "(Account):(Account)" with command "UPDATE" for record "88501"
And I create a new row at the end of the table
And I set field "zkoart" to "99999" in row 1
And I save the current editor

Given I open an editor "Konto" from table "(Account):(Account)" with command "UPDATE" for record "88889"
And I create a new row at the end of the table
And I set field "zkoart" to "99999" in row 1
And I save the current editor

Scenario: 06 Erfassen einer Rueckmeldung mit einem Mitarbeiter, einer Arbeitszeit, keiner Lohngruppe und keinen Lohnkonten, dann Nachreichen Lohngruppe und Setzen des Lohnsatzes auf null. Es werden trotzdem Konten gefordert.

Given I open an editor "RückmeldungNeu1" from table "(Workorder):(CompletionConfirmations)" with command "NEW" for record ""
And I set field "barmex" to "1sih"
And I set field "mgr" to "121"
And I set field "artikel" to "bg1"
And I set field "kstelle" to "100000"
And I set field "ma" to "7801"
And I set field "bzeit" to "1"
Then saving the current editor throws the exception "161"
And I set field "lgr" to "1"
# Mit Defaultkonten (s. fekost.cpp) gibt es keine exception. Alle notwendigen Konten sind gefüllt.
# Then saving the current editor throws the exception "57"
And I set field "bsatz" to "0"
And I set field "lohnkostsoll" to "99123"
# Then saving the current editor throws the exception "57"
And I set field "lohnkosthaben" to "99900"
# RM kann gespeichert werden. Sie hat Arbeitszeit, aber keinen Lohnsatz und generiert eine Bewertung mit einer Zeile, Kostenart Lohn, Preisstatus direkt, Buchungsstatus verworfen, da der Preis 0 ist.
And I save the current editor

# Bewertung zu RückmeldungNeu1
Given I open an editor "Bewertung" from table "(Valuation):(Valuation)" with command "VIEW" for search criteria "$,,artikel=bg1;typ=2;@richtung=rückwärts;@maxtreffer=1"
Then table has values
    | kart | tmge |   tbewpr     |bewertet | tlbstatus | koreso |koreha | sokoue | hakoue |
    | Lohn |  1   |    0.0000    |  direkt | verworfen | 99123  | 99900 |        |        |
And I close the current editor


Scenario: 07 Erfassen einer Rueckmeldung mit einem Mitarbeiter, einer Maschinenzeit, keinem Maschinenstundensatz, es werden trotzdem Konten gefordert

Given I open an editor "RückmeldungNeu2" from table "(Workorder):(CompletionConfirmations)" with command "NEW" for record ""
And I set field "barmex" to "2sih"
And I set field "mgr" to "121"
And I set field "artikel" to "bg1"
And I set field "kstelle" to "100000"
And I set field "ma" to "7801"
And I set field "mzeit" to "1"
# Kontenfelder abischtlich leeren
And I set field "mkostfixsoll" to ""
And I set field "skostvarhaben" to ""
Then saving the current editor throws the exception "57"
And I set field "mkostfixsoll" to "99123"
And I set field "skostvarhaben" to "99900"
And I save the current editor


Scenario: 08 Erfassen einer Rückmeldung mit einem Mitarbeiter, einer Arbeitszeit, keiner Lohngruppe und keinen Lohnkonten, dann Nachreichen Lohngruppe und Setzen des Lohnsatzes auf null, trotzdem werden Konten gefordert.

Given I open an editor "RueckmeldungNeu1" from table "(Workorder):(CompletionConfirmations)" with command "NEW" for record ""
And I set field "barmex" to "1sih"
And I set field "mgr" to "121"
And I set field "artikel" to "bg1"
And I set field "kstelle" to "100000"
And I set field "ma" to "7801"
And I set field "bzeit" to "1"
Then saving the current editor throws the exception "161"
And I set field "lgr" to "1"
# Mit Defaultkonten (s. fekost.cpp) gibt es keine exception. Alle notwendigen Konten sind gefüllt.
# Then saving the current editor throws the exception "57"
And I set field "bsatz" to "0"
And I set field "mkostfixsoll" to "99800"
# Then saving the current editor throws the exception "57"
And I set field "mkostfixhaben" to "99900"
# RM kann gespeichert werden. Sie hat Arbeitszeit, aber keinen Lohnsatz und generiert eine Bewertung mit einer Zeile, Kostenart Lohn, Preisstatus direkt, Buchungsstatus verworfen, da der Preis 0 ist.
And I save the current editor

# Bewertung zu RueckmeldungNeu1
Given I open an editor "Bewertung" from table "(Valuation):(Valuation)" with command "VIEW" for search criteria "$,,artikel=bg1;typ=2;@richtung=rueckwaerts;@maxtreffer=1"
Then table has values
    | kart | tmge |   tbewpr     |bewertet | tlbstatus | koreso | koreha |
    | Lohn |  1   |    0.0000    |  direkt | verworfen | 88100  | 88101  |

Scenario: 09 Anlegen und Freigeben von Fertigungsvorschlaegen, BAs rueckmelden, Bewertungen pruefen 

# eigene Ktr dafür anlegen
Given I open an editor "Ktr" from table "(Account):(CostObject)" with command "COPY" for record "100000"
And I set field "nummer" to "200000"
And I set field "such" to "K200000"
And I save the current editor
Given I open an editor "Ktr" from table "(Account):(CostObject)" with command "COPY" for record "100000"
And I set field "nummer" to "300000"
And I set field "such" to "K300000"
And I save the current editor

# Fertigungsvorschlag 1 anlegen und freigeben
Given I open an editor "fvor1" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
And I append rows
    | artikel      | mge | mfreig | kstelle | bisuch |
    | bg1          | 10  | ja     | 200000  | BBG1_  |
And I press button "freig" to open a subeditor for "BA_freigeben"
And I close the current editor
And I switch the current editor to editor "fvor1"
And I save the current editor

#  Rueckmeldung 1. AG BA BBG1_
Given I open an editor "Arbeitsschein" from table "(Workorder):(WorkOrders)" with command "DONE" for record "BBG1_001"
And I set field "ma" to "7801"
And I set field "mzeit" to "1"
And I set field "mkostfixsoll" to "99123"
And I set field "mkostfixhaben" to "99900"
And I set field "mkostvarsoll" to "99123"
And I set field "mkostvarhaben" to "99900"
And I set field "skostfixsoll" to "99123"
And I set field "skostfixhaben" to "99900"
And I set field "skostvarsoll" to "99123"
And I set field "skostvarhaben" to "99900"
And I set field "gut" to "1"
And I set field "sofort" to "1"
And I save the current editor

# Bewertung zu Rückmeldung BBG1_001
Given I open an editor "Bewertung" from table "(Valuation):(Valuation)" with command "VIEW" for search criteria "$,,artikel=bg1;typ=2;kostobj=200000;@richtung=rückwärts;@maxtreffer=1"
Then table has values
    | kart                | tmge |   tbewpr     |bewertet | tlbstatus  | koreso |koreha | sokoue | hakoue |
    | Maschinenkosten fix |  1   |   10.0000    |  direkt | verbuchbar | 99123  | 99900 | 10500  | 48100  |
    | Maschinenkosten var |  1   |    5.0000    |  direkt | verbuchbar | 99123  | 99900 | 10500  | 48100  |
    | SK fix              |  1   |   10.0000    |  direkt | verbuchbar | 99123  | 99900 | 10500  | 48100  |
And I close the current editor

# Fertigungsvorschlag 2 anlegen und freigeben

# neuer Artikel BG302 mit MGR 121, die keinen Maschinenstundensatz hat
Given I open an editor "bg2" from table "(Part):(Product)" with command "COPY" for record "301"
And I set field "nummer" to "302"
And I set field "such" to "bg302"
And I set field "mgr" to "121" in row 2
And I set field "mgr" to "121" in row 3
And I save the current editor

Given I open an editor "fvor2" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
And I append rows
    | artikel      | mge | mfreig | kstelle | bisuch |
    | bg302        | 10  | ja     | 300000  | BBG2_  |
And I press button "freig" to open a subeditor for "BA_freigeben"
And I close the current editor
And I switch the current editor to editor "fvor2"
And I save the current editor

#  Rueckmeldung 1. AG zu BA BBG2_
Given I open an editor "Arbeitsschein" from table "(Workorder):(WorkOrders)" with command "DONE" for record "BBG2_001"
And I set field "ma" to "7801"
And I set field "mzeit" to "1"
And I set field "mkostfixsoll" to "99123"
And I set field "mkostfixhaben" to "99800"
And I set field "mkostvarsoll" to "99123"
And I set field "mkostvarhaben" to "99800"
And I set field "skostfixsoll" to "99123"
And I set field "skostfixhaben" to "99800"
And I set field "skostvarsoll" to "99123"
And I set field "skostvarhaben" to "99900"
And I set field "gut" to "1"
And I set field "sofort" to "1"
And I save the current editor

# Bewertung zu Rückmeldung BBG2_001
Given I open an editor "Bewertung" from table "(Valuation):(Valuation)" with command "VIEW" for search criteria "$,,artikel=bg302;typ=2;kostobj=300000;@richtung=rückwärts;@maxtreffer=1"
Then table has values
    | kart                | tmge |   tbewpr     |bewertet     | tlbstatus        | koreso |koreha | sokoue | hakoue |
    | Maschinenkosten fix |  1   |    0.0000    |  unbewertet | nicht verbuchbar | 99123  | 99800 | 10500  | 48100  |
    | Maschinenkosten var |  1   |    0.0000    |  unbewertet | nicht verbuchbar | 99123  | 99800 | 10500  | 48100  |
    | SK fix              |  1   |   10.0000    |  direkt     | verbuchbar       | 99123  | 99800 | 10500  | 48100  |
And I close the current editor


Scenario: 10 Maschinengruppe mit Verweis auf Kostenverteiler, Anlegen und Freigabe eines Fertigungsvorschlags und Rueckmelden von Maschinenzeit
# Kostenobjekt aus KV mit groesstem Prozentanteil liefert statistische Lohnkonten für die Maschinenzeit der RM

Given I open an editor "Konto" from table "(Account):(Account)" with command "COPY" for record "99123"
And I set field "nummer" to "99223"
And I set field "such" to "K99223"
And I save the current editor

Given I open an editor "Konto" from table "(Account):(Account)" with command "COPY" for record "99123"
And I set field "nummer" to "99224"
And I set field "such" to "K99224"
And I save the current editor

Given I open an editor "Ktr" from table "(Account):(CostObject)" with command "COPY" for record "300000"
And I set field "nummer" to "400000"
And I set field "such" to "K400000"
And I save the current editor

Given I open an editor "Ktr" from table "(Account):(CostObject)" with command "COPY" for record "300000"
And I set field "nummer" to "500000"
And I set field "such" to "K500000"
And I save the current editor

# Kostenverteiler 
Given I open an editor "kostenverteiler" from table "(Account):(CostDistribution)" with command "NEW" for record ""
And I set field "nummer" to "10"
And I set field "such" to "kv"
And I create a new row at the end of the table
And I set field "kstelle" to "101" in row 1
And I set field "proz" to "10" in row 1
And I create a new row at the end of the table
And I set field "kstelle" to "100000" in row 2
And I set field "proz" to "5" in row 2
And I create a new row at the end of the table
And I set field "kstelle" to "500000" in row 3
And I set field "proz" to "30" in row 3
And I create a new row at the end of the table
And I set field "kstelle" to "400000" in row 4
And I set field "proz" to "20" in row 4
And I create a new row at the end of the table
And I set field "kstelle" to "300000" in row 5
And I set field "proz" to "5" in row 5
And I create a new row at the end of the table
And I set field "kstelle" to "200000" in row 6
And I set field "proz" to "30" in row 6
And I save the current editor

Given I open an editor "mgr" from table "(Capacity):(WorkCenter)" with command "COPY" for record "101"
And I set field "nummer" to "200"
And I set field "such" to "mgr200"
And I set field "kstelle" to "10"
And I save the current editor

# neuer Artikel BG303 mit MGR 200, die auf einen KV verweist
Given I open an editor "bg303" from table "(Part):(Product)" with command "COPY" for record "301"
And I set field "nummer" to "303"
And I set field "such" to "bg303"
And I set field "mgr" to "200" in row 2
And I set field "mgr" to "200" in row 3
And I save the current editor

Given I open an editor "fvor3" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
And I append rows
    | artikel      | mge | mfreig | kstelle | bisuch |
    | bg303        |   1 | ja     | 300000  | BBG3_  |
And I press button "freig" to open a subeditor for "BA_freigeben"
And I close the current editor
And I switch the current editor to editor "fvor3"
And I save the current editor

#  Rueckmeldung 1. AG zu BA BBG3_
Given I open an editor "Arbeitsschein" from table "(Workorder):(WorkOrders)" with command "DONE" for record "BBG3_001"
And I set field "ma" to "7801"
And I set field "mzeit" to "1"
And I set field "gut" to "1"
And I set field "sofort" to "1"
And I save the current editor

# Bewertung zu Rückmeldung BBG3_001
Given I open an editor "Bewertung" from table "(Valuation):(Valuation)" with command "VIEW" for search criteria "$,,artikel=bg303;typ=2;kostobj=300000;@richtung=rückwärts;@maxtreffer=1"
Then table has values
    | kart                | tmge |   tbewpr     |bewertet     | tlbstatus  | koreso |koreha | sokoue | hakoue | kstellemgr |
    | Maschinenkosten fix |  1   |   10.0000    |  direkt     | verbuchbar | 88200  | 88201 | 10500  | 48100  |     10     |
    | Maschinenkosten var |  1   |    5.0000    |  direkt     | verbuchbar | 88300  | 88301 | 10500  | 48100  |     10     |
    | SK fix              |  1   |   10.0000    |  direkt     | verbuchbar | 88400  | 88401 | 10500  | 48100  |     10     |
And I close the current editor


Scenario: 11 Anlage von Verdichtungskostenstellen, -trägern, von einem Stammkostenverteiler
Given I open an editor "konto" from table "(Account):(CostCenter)" with command "COPY" for record "100"
And I set field "nummer" to "999"
And I set field "such" to "K999"
And I set field "bebuchbar" to "nein"
And I save the current editor

Given I open an editor "konto" from table "(Account):(CostObject)" with command "COPY" for record "100000"
And I set field "nummer" to "999999"
And I set field "such" to "K999999"
And I set field "bebuchbar" to "nein"
And I save the current editor

Scenario: 12 Eintrag Fertigungskontengruppe in Verdichtungsobjekte und in Stammkostenverteiler
Given I open an editor "konto" from table "(Account):(CostCenter)" with command "UPDATE" for record "999"
Then setting field "fertkont" to "100" throws the exception "203"
And I close the current editor

Given I open an editor "konto" from table "(Account):(CostObject)" with command "UPDATE" for record "999999"
Then setting field "fertkont" to "100" throws the exception "203"
And I close the current editor

Given I open an editor "kostenverteiler-10" from table "(Account):(CostDistribution)" with command "UPDATE" for record "10"
And I set field "fertkont" to "100"
# nicht speichern wegen Nachfolgetests
And I close the current editor

Scenario: 13 Editieren der Standardfertigungskontengruppe (2820: Die Standardfertigungskontengruppe ist nicht aenderbar.)
Given I open an editor "ko" from table "(ProductionAccountsGroup):(ProductionAccountsGroup)" with command "VIEW" for record "FK100"
And I close the current editor
Given I open an editor "ko2" from table "(ProductionAccountsGroup):(ProductionAccountsGroup)" with command "UPDATE" for record "100"
And I close the current editor



