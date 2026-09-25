@persistent
Feature: scanordertime.feature

# *****************************************************************************
#  Name             : scanordertime
#  Autor            : tiwe
#  Verantwortlich   : teaminfosysteme
#  Kontrolle        : cl
#  Funktion         : Testet das Infosystem SCANORDERTIME. An- und abstempeln von Auftragszeiten (scanorientiert).
#
# *****************************************************************************

# letzter Test: 20191011 Status: läuft ohne Fehler durch
Background:
Given I set the fake date to "12.01.1995" 
Scenario: 1 Rüsten und Bearbeitung beginnen und erste Teilrückmeldungen
# Debug: 4 Auftragszeiten, 2x fertstatus Rüsten, 2 ferstatus Bearbeitung beginnen, eine davon hat keine Endzeit
#        Rückmeldenummern: RM1_BDE1 und RM2_BDE1
#        Auftragszeiten:   AZ1_BDE1_Rüsten, AZ2_BDE1_Rüsten, AZ3_BDE1_Bearbeitung, AZ4_BDE1_Bearbeitung
################################################################################
# 00 als erstes es darf keine offenen BAs für den Artikel BG3-BDE geben
Given I'm logged in with password "sfloor"
Given I set the fake date to "12.01.1995" 
Given I open the infosystem "PRODLIST"
And I set field "kart" to "BG3-BDE"
And I set field "bba" to "ja"
Then I press start
Then the table has 0 rows
And I close the current editor
##############################################
# 01 FV anlegen für BG mit 3 AGs und freigeben
Given I'm logged in with password "sy"
Given I set the fake date to "12.01.1995" 
Given I open an editor "fvor_BDE1" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
And I append rows
    | artikel        | netmge     | bisuch    | mfreig    |
    | BG3-BDE        | 100        | BDE1_   | ja        |
And I press button "freig" to open a subeditor for "BA_freigeben"
And I close the current editor
And I switch the current editor to editor "fvor_BDE1"
And I save the current editor
##############################################
# 02 Dispo  starten
And I run Scheduling
#############################################
# 03 RM auf den ersten und zweiten AG, damit eine Nummer haben
Given I open an editor "RM1_BDE1" from table "(Workorder):(WorkOrders)" with command "DONE" for record "BDE1_001"
And I set fields
    | sofort    | ja         |
    | bem       | Nummer         | 
And I save the current editor 
Given I open an editor "RM2_BDE1" from table "(Workorder):(WorkOrders)" with command "DONE" for record "BDE1_002"
And I set fields
    | sofort    | ja         |
    | bem       | Nummer         | 
And I save the current editor 
#############################################
# 03.01 SCANORDERTIME unbearbeiteter Arbeitsschein, Rüsten anstempeln
Given I'm logged in with password "sfloor"
Given I set the fake date to "12.01.1995" 
Given I open the infosystem "SCANORDERTIME"
And I set field "mitarb" to "SCHNEID" 
And I set field "asnr" to "nummer" from editor "RM1_BDE1"
Then the table has 2 rows
Then table has values
   |neu|aznr | tartikel       | tofmge  | fbu           |truesten | tproduktion | tbeenden  | tkurzlauf   |ttextstatus | tfortschritt|tabbruch|tunterbrechen|
   | ja|     | BG3-BDE        | 100     | icon:product  |icon:plus|icon:plus    |           |icon:plus    |            | 0           |        |             | 
   | ja|     |                | 0       |               |         |             |           |             |---         | 0           |        |             | 
And I press button "truesten" in row 1
Then the table has 0 rows
Then field "bdestatus" has value "icon:ball_green"
And I close the current editor
##############################################
# 03.02 entstandene Auftragszeit prüfen
Given I open an editor "AZ1_BDE1_Rüsten" from table "(PDC):(OrderTime)" with command "UPDATE" for search criteria "$,,ma=SCHNEID;endzeit=`;fertstatus=Rüsten;@richtung=rückwärts;@sort=offen;@maxtreffer=1"
#Then field "asnr" has value "nummer" from editor "RM1_BDE1"
#Then field "([^"]*)" has value equal to field "([^"]*)" from editor "([^"]*)" in row (\d+|!lastRow)
Then field "asnr" has value equal to field "nummer" from editor "RM1_BDE1"
Then field "ma^such" has value "SCHNEID"
Then field "fertstatus" has value "Rüsten"
#And I set field "sofort" to "ja"
And I save the current editor
##############################################
# 03.03 SCANORDERTIME Erneut Rüsten anstempeln geht nicht, er rüstet ja schon
Given I open the infosystem "SCANORDERTIME"
And I set field "mitarb" to "SCHNEID" 
Then the table has 1 rows
Then table has values
 |neu | aznr                       | tartikel       | tofmge  | fbu           |truesten             | tproduktion | tbeenden  | tkurzlauf   |ttextstatus | tfortschritt|tunterbrechen                      |tabbruch                      |
 |nein| !AZ1_BDE1_Rüsten^nummer   | BG3-BDE        | 100     | icon:product  |icon:media_play_green| icon:plus   | icon:plus |icon:plus    |Rüsten      | 0           |icon:media_pause_green        |icon:media_stop_green         |
And I set field "asnr" to "nummer" from editor "RM1_BDE1"
Then field "bdestatus" has value "icon:ball_red"
And I press button "truesten" in row 1
Then field "bdestatus" has value "icon:ball_red"
And I close the current editor
##############################################
# 03.04 SCANORDERTIME Paralleles Rüsten eines 2. MAs
Given I open the infosystem "SCANORDERTIME"
And I set field "mitarb" to "MACHNIX" 
And I set field "asnr" to "nummer" from editor "RM1_BDE1"
Then the table has 2 rows
Then table has values
   |neu|aznr | tartikel       | tofmge  | fbu           |truesten | tproduktion | tbeenden  | tkurzlauf   |ttextstatus | tfortschritt|tabbruch|tunterbrechen|
   | ja|     | BG3-BDE        | 100     | icon:product  |icon:plus|icon:plus    |           |icon:plus    |Rüsten     | 0           |        |             | 
   | ja|     |                | 0       |               |         |             |           |             |---         |  0          |        |             |
And I press button "truesten" in row 1
Then the table has 0 rows
Then field "bdestatus" has value "icon:ball_green"
And I close the current editor
##############################################
# 03.05 entstandene Auftragszeit prüfen
Given I open an editor "AZ2_BDE1_Rüsten" from table "(PDC):(OrderTime)" with command "UPDATE" for search criteria "$,,ma=MACHNIX;endzeit=`;fertstatus=Rüsten;@richtung=rückwärts;@sort=offen;@maxtreffer=1"
Then field "asnr" has value equal to field "nummer" from editor "RM1_BDE1"
Then field "ma^such" has value "MACHNIX"
Then field "fertstatus" has value "Rüsten"
#And I set field "sofort" to "ja"
And I save the current editor
##############################################
#03.06 SCANORDERTIME Bearbeitung beginnen
Given I open the infosystem "SCANORDERTIME"
And I set field "mitarb" to "SCHNEID" 
And I set field "asnr" to "nummer" from editor "RM1_BDE1"
Then table has values
   |neu  |aznr                     | tartikel       | tofmge  | fbu           |truesten             | tproduktion |tbeenden    | tkurzlauf   |ttextstatus | tfortschritt|tunterbrechen            |tabbruch                |
   |nein |!AZ1_BDE1_Rüsten^nummer | BG3-BDE        | 100     | icon:product  |icon:media_play_green|icon:plus    | icon:plus  |icon:plus    |Rüsten     | 0           |icon:media_pause_green   |icon:media_stop_green   |
And I press button "tproduktion" in row 1
Then the table has 0 rows
Then field "bdestatus" has value "icon:ball_green"
And I close the current editor
##############################################
#03.07 entstandene Rüst-Auftragszeiten überprüfen
Given I open an editor "AZ1_BDE1_Rüsten" from table "(PDC):(OrderTime)" with command "VIEW" for search criteria "$,,ma=SCHNEID;endzeit<>`;fertstatus=Rüsten;@richtung=rückwärts;@maxtreffer=1"
Then field "asnr" has value equal to field "nummer" from editor "RM1_BDE1"
Then field "ma^such" has value "SCHNEID"
Then field "enddat" is not empty
Then field "endzeit" is not empty
Then field "fertstatus" has value "Rüsten"
And I save the current editor
Given I open an editor "AZ2_BDE1_Rüsten" from table "(PDC):(OrderTime)" with command "VIEW" for search criteria "$,,ma=MACHNIX;endzeit<>`;fertstatus=Rüsten;@richtung=rückwärts;@maxtreffer=1"
Then field "asnr" has value equal to field "nummer" from editor "RM1_BDE1"
Then field "ma^such" has value "MACHNIX"
Then field "enddat" is not empty
Then field "endzeit" is not empty
Then field "fertstatus" has value "Rüsten"
And I save the current editor
### entstandende Bearbeitungs-Auftragszeiten überprüfen
Given I open an editor "AZ3_BDE1_Bearbeitung" from table "(PDC):(OrderTime)" with command "UPDATE" for search criteria "$,,ma=SCHNEID;endzeit=`;fertstatus=Bearbeitung;@richtung=rückwärts;@sort=offen;@maxtreffer=1"
Then field "asnr" has value equal to field "nummer" from editor "RM1_BDE1"
Then field "ma^such" has value "SCHNEID"
Then field "fertstatus" has value "Bearbeitung"
#And I set field "sofort" to "ja"
And I save the current editor
##############################################
#03.08 SCANORDERTIME Rüsten melden nachdem die Bearbeitung begonnen hat
Given I open the infosystem "SCANORDERTIME"
And I set field "mitarb" to "MACHNIX" 
And I set field "asnr" to "nummer" from editor "RM1_BDE1"
And I press button "truesten" in row 1
Then field "bdestatus" has value "icon:ball_red"
And I close the current editor
##############################################
#03.09 SCANORDERTIME Sofort Bearbeitung melden. Es Gibt kein Rüsten
Given I open the infosystem "SCANORDERTIME"
And I set field "mitarb" to "MACHNIX" 
And I set field "asnr" to "nummer" from editor "RM2_BDE1"
Then the table has 2 rows
Then table has values
   |neu|aznr | tartikel       | tofmge  | fbu           |truesten | tproduktion  |tbeenden | tkurzlauf   |ttextstatus | tfortschritt|tabbruch|tunterbrechen|
   | ja|     | BG3-BDE        | 100     | icon:product  |icon:plus|icon:plus     |         |icon:plus    |            | 0           |        |             | 
   | ja|     |                | 0       |               |         |              |         |             |---         | 0           |        |             | 
Then I press button "tproduktion" in row 1
Then the table has 0 rows
Then field "bdestatus" has value "icon:ball_green"
And I close the current editor
###############################################
#03.10 entstandene Auftragszeit prüfen
Given I open an editor "AZ4_BDE1_Bearbeitung" from table "(PDC):(OrderTime)" with command "UPDATE" for search criteria "$,,ma=MACHNIX;endzeit=`;fertstatus=Bearbeitung;@richtung=rückwärts;@sort=offen;@maxtreffer=1"
Then field "asnr" has value equal to field "nummer" from editor "RM2_BDE1"
Then field "ma^such" has value "MACHNIX"
Then field "enddat" is empty
Then field "endzeit" is empty
Then field "fertstatus" has value "Bearbeitung"
#And I set field "sofort" to "ja"
And I save the current editor
###############################################
#3.11 Teilrückmeldung über 20 Stück
Given I open the infosystem "SCANORDERTIME"
And I set field "mitarb" to "MACHNIX" 
Then the table has 1 rows
Then table has values
 |neu | aznr                          | tartikel       | tofmge  | fbu           |truesten   | tproduktion          |tbeenden  | tkurzlauf   |ttextstatus | tfortschritt|tunterbrechen                 |tabbruch                      |
 |nein| !AZ4_BDE1_Bearbeitung^nummer  | BG3-BDE        | 100     | icon:product  |icon:ok    |icon:media_play_green | icon:plus| icon:plus   |Bearbeitung | 0           |icon:media_pause_green        |icon:media_stop_green         |
And I press button "trueckmeld" in row 1
And I set field "istmge" to "20"
And I press button "fertig"
Then the table has 0 rows
Then field "bdestatus" has value "icon:ball_green"
And I close the current editor
###############################################
#3.12 Auftragzeit mit zu alter Anfangszeit
Given I open an editor "AZ3_BDE1_Bearbeitung" from table "(PDC):(OrderTime)" with command "UPDATE" for search criteria "$,,ma=SCHNEID;endzeit=`;fertstatus=Bearbeitung;@richtung=rückwärts;@sort=offen;@maxtreffer=1"
Then field "asnr" has value equal to field "nummer" from editor "RM1_BDE1"
Then field "ma^such" has value "SCHNEID"
Then field "fertstatus" has value "Bearbeitung"
And I set field "anfdat" to "-2"
And I save the current editor
## Für diese Auftragszeit nun eine Teilrückmeldung über SCANORDERTIME buchen
Given I open the infosystem "SCANORDERTIME"
And I set field "mitarb" to "SCHNEID" 
And I press button "trueckmeld" in row 1
And I set field "istmge" to "20"
And I press button "fertig"
Then the table has 1 rows
# Dies Auftragszeit bleibt in der Tabelle stehen
Then field "bdestatus" has value "icon:ball_red"
And I close the current editor
# Diese Auftragszeit ablegen, damit man BA stornieren kann
Given I open an editor "AZ3_BDE1_Bearbeitung" from table "(PDC):(OrderTime)" with command "UPDATE" for search criteria "$,,ma=SCHNEID;endzeit=`;fertstatus=Bearbeitung;@richtung=rückwärts;@sort=offen;@maxtreffer=1"
Then field "asnr" has value equal to field "nummer" from editor "RM1_BDE1"
Then field "ma^such" has value "SCHNEID"
Then field "fertstatus" has value "Bearbeitung"
And I set field "ablagef" to "ja"
And I save the current editor
##############################################
# 3.13 BA Stornieren
Given I'm logged in with password "sy"
Given I set the fake date to "12.01.1995" 
Given I open an editor "BA" from table "(Workorder):(WorkOrders)" with command "UPDATE" for record "BDE1_000"
And I respond with answer "ja" to the dialog with id "1483"
And I set field "status" to "S"
And I save the current editor


Scenario: 2 Teilrückmeldungen überbuchen und nicht überbuchen 
# Debug
#        Rückmeldenummern: RM1_BDE2 und RM2_BDE2
#        Auftragszeiten: werden im ID-Cache nicht abgefragt 
# 01 FV anlegen für BG mit 3 AGs und freigeben
Given I'm logged in with password "sy"
Given I set the fake date to "12.01.1995" 
Given I open an editor "fvor_BDE2" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
And I append rows
    | artikel        | netmge     | bisuch    | mfreig    |
    | BG3-BDE        | 100        | BDE2_   | ja        |
And I press button "freig" to open a subeditor for "BA_freigeben"
And I close the current editor
And I switch the current editor to editor "fvor_BDE2"
And I save the current editor
##############################################
# 02 Dispo  starten
And I run Scheduling
#############################################
# 03 RM auf den ersten und zweiten AG, damit eine Nummer haben
Given I open an editor "RM1_BDE2" from table "(Workorder):(WorkOrders)" with command "DONE" for record "BDE2_001"
And I set fields
    | sofort    | ja         |
    | bem       | Nummer         | 
And I save the current editor 
Given I open an editor "RM2_BDE2" from table "(Workorder):(WorkOrders)" with command "DONE" for record "BDE2_002"
And I set fields
    | sofort    | ja         |
    | bem       | Nummer         | 
And I save the current editor 
##############################################
# 03.01 SCANORDERTIME Arbeitsschein überbuchen
Given I'm logged in with password "sfloor"
Given I set the fake date to "12.01.1995" 
Given I open the infosystem "SCANORDERTIME"
Then field "ueberbuchen" has value "ja"
And I set field "mitarb" to "SCHNEID" 
And I set field "asnr" to "nummer" from editor "RM1_BDE2"
Then the table has 2 rows
Then table has values
 |neu  |aznr   | tartikel       | tofmge  | fbu           |truesten | tproduktion  | tbeenden | tkurzlauf   |ttextstatus | tfortschritt|
 | ja  |       | BG3-BDE        | 100     | icon:product  |icon:plus|icon:plus     |          |icon:plus    |            | 0           |
 | ja  |       |                | 0       |               |         |              |          |             | ---        | 0           |
# erste Teilrückmeldung über 50 Stück        
And I press button "tproduktion" in row 1
Then the table has 0 rows
And I set field "mitarb" to "SCHNEID" 
And I press button "trueckmeld" in row 1 
And I set field "istmge" to "50"
And I press button "fertig"
# zweite Teilrückmeldung über 60 Stück 
And I set field "mitarb" to "SCHNEID" 
And I set field "asnr" to "nummer" from editor "RM1_BDE2"
And I press button "tproduktion" in row 1
Then the table has 0 rows
And I set field "mitarb" to "SCHNEID" 
And I press button "trueckmeld" in row 1 
And I set field "istmge" to "60"
And I press button "fertig"
# dritte Teilrückmeldung über 20 Stück
And I set field "mitarb" to "SCHNEID" 
And I set field "asnr" to "nummer" from editor "RM1_BDE2" 
And I press button "tproduktion" in row 1
Then the table has 0 rows
And I set field "mitarb" to "SCHNEID" 
And I press button "trueckmeld" in row 1 
And I set field "istmge" to "20"
And I press button "fertig"
# nun die Daten im Infosystem bei einer erneuten Anstemplung prüfen
And I set field "mitarb" to "SCHNEID" 
And I set field "asnr" to "nummer" from editor "RM1_BDE2"
Then the table has 2 rows
Then table has values
|neu  | aznr  | tartikel       | tofmge  | fbu           |truesten             |tproduktion | tbeenden    |tkurzlauf    |ttextstatus  |trueckmeld|tkomplettrueck| tfortschritt|tunterbrechen  |tabbruch|
| ja  |       | BG3-BDE        |   0     | icon:product  |icon:ok              |icon:plus   |             |icon:plus    |Bearbeitung  |          |              | 130         |               |        |
| ja  |       |                |   0     |               |                     |            |             |             |---          |          |              | 0           |               |        |
And I close the current editor
##############################################
# 03.02 SCANORDERTIME lässt sich nicht überbuchen
Given I open the infosystem "SCANORDERTIME"
And I set field "ueberbuchen" to "nein"
And I set field "mitarb" to "SCHNEID" 
And I set field "asnr" to "nummer" from editor "RM2_BDE2"
Then the table has 2 rows
Then table has values
|neu|aznr    | tartikel       | tofmge  | fbu           |truesten | tproduktion | tbeenden  | tkurzlauf   |ttextstatus | tfortschritt|
|ja |        | BG3-BDE        | 100     | icon:product  |icon:plus|icon:plus    |           |icon:plus    |            | 0           |
|ja |        |                |  0      |               |         |             |           |             | ---        | 0           |
# erste Teilrückmeldung über 50 Stück        
And I press button "tproduktion" in row 1
Then the table has 0 rows
And I set field "mitarb" to "SCHNEID" 
And I press button "trueckmeld" in row 1
And I set field "istmge" to "50"
And I press button "fertig"
# zweite Teilrückmeldung über 60 Stück 
And I set field "mitarb" to "SCHNEID" 
And I set field "asnr" to "nummer" from editor "RM2_BDE2"
And I press button "tproduktion" in row 1
Then the table has 0 rows
And I set field "mitarb" to "SCHNEID"
And I press button "trueckmeld" in row 1
And I set field "istmge" to "60" 
#hier kommen jetzt Meldungen, dass man nicht überbuchen darf
#Then setting field "istmge" to "60" throws the exception "45353535345345"
And I press button "fertig"
#hier kommen jetzt Meldungen, dass man nicht überbuchen darf
# hier im IS die Felder prüfen, wenn man neu anstempelt
And I set field "mitarb" to "SCHNEID" 
And I set field "asnr" to "nummer" from editor "RM2_BDE2"
Then the table has 1 rows
Then table has values
|neu   | tartikel       | tofmge  | fbu           |truesten | tproduktion          | tbeenden    | tkurzlauf   |ttextstatus | tfortschritt|
|nein  | BG3-BDE        | 50      | icon:product  |icon:ok  |icon:media_play_green | icon:plus   |icon:plus    |Bearbeitung | 50          | 
# nun nochmal 50 melden, damit man den BA stornieren kann
And I set field "mitarb" to "SCHNEID" 
And I set field "asnr" to "nummer" from editor "RM2_BDE2"
And I press button "trueckmeld" in row 1
And I set field "istmge" to "50" 
And I press button "fertig"
And I close the current editor
##############################################
# BA Stornieren
Given I'm logged in with password "sy"
Given I set the fake date to "12.01.1995" 
Given I open an editor "BA" from table "(Workorder):(WorkOrders)" with command "UPDATE" for record "BDE2_000"
And I respond with answer "ja" to the dialog with id "1483"
And I set field "status" to "S"
And I save the current editor

##############################################
Scenario: 3 Komplettrückmeldungen rmimdialog = ja und nein
# Debug
#       Rückmeldungen : RM1_BDE3  RM2_BDE3
#       Auftragszeiten: AZ1_BDE3_Bearbeitung AZ2_BDE3_Bearbeitung
# 01 FV anlegen für BG mit 3 AGs und freigeben
Given I'm logged in with password "sy"
Given I set the fake date to "12.01.1995" 
Given I open an editor "fvor_BDE3" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
And I append rows
    | artikel        | netmge     | bisuch    | mfreig    |
    | BG3-BDE        | 100        | BDE3_   | ja        |
And I press button "freig" to open a subeditor for "BA_freigeben"
And I close the current editor
And I switch the current editor to editor "fvor_BDE3"
And I save the current editor
##############################################
# 02 Dispo  starten
And I run Scheduling
#############################################
# 03 RM auf den ersten und zweiten AG, damit eine Nummer haben
Given I open an editor "RM1_BDE3" from table "(Workorder):(WorkOrders)" with command "DONE" for record "BDE3_001"
And I set fields
    | sofort    | ja         |
    | bem       | Nummer         | 
And I save the current editor 
Given I open an editor "RM2_BDE3" from table "(Workorder):(WorkOrders)" with command "DONE" for record "BDE3_002"
And I set fields
    | sofort    | ja         |
    | bem       | Nummer         | 
And I save the current editor 
##############################################
# 03.01 SCANORDERTIME rmimdialog = nein
Given I'm logged in with password "sfloor"
Given I set the fake date to "12.01.1995" 
Given I open the infosystem "SCANORDERTIME"
And I set field "sicherheit" to "nein"
And I set field "mitarb" to "SCHNEID" 
And I set field "asnr" to "nummer" from editor "RM1_BDE3"
And I press button "tproduktion" in row 1
Then the table has 0 rows
And I set field "mitarb" to "SCHNEID"
Then the table has 1 rows
And I press button "tkomplettrueck" in row 1
And I set field "mitarb" to "SCHNEID" 
And I set field "asnr" to "nummer" from editor "RM1_BDE3"
Then table has values
    | tartikel       | tofmge  | fbu           |truesten             |tproduktion | tbeenden|tkurzlauf    |ttextstatus  |trueckmeld|tkomplettrueck| tfortschritt|tunterbrechen  |tabbruch|
    | BG3-BDE        | 0       | icon:product  |icon:ok              |icon:ok     | icon:ok |icon:ok      |abgeschlossen|icon:ok   | icon:ok      | 100         |          |        |
    |                | 0       |               |                     |            |         |             | ---         |          |              | 0           |          |        |
And I close the current editor
#############################################
#03.02 Auftragszeit überprüfen
Given I open an editor "AZ1_BDE3_Bearbeitung" from table "(PDC):(OrderTime)" with command "VIEW" for search criteria "$,,ma=SCHNEID;endzeit<>`;fertstatus=Bearbeitung;@richtung=rückwärts;@maxtreffer=1"
Then field "asnr" has value equal to field "nummer" from editor "RM1_BDE3"
Then field "endzeit" has value equal to field "anfzeit" from editor "AZ1_BDE3_Bearbeitung"
Then field "korr" has value "16.67"
Then field "bzeit" has value "16.67"
Then field "istzeit" has value "0"
And I close the current editor
##############################################
# 03.03 SCANORDERTIME rmimdialog = ja
Given I open the infosystem "SCANORDERTIME"
And I set field "sicherheit" to "nein"
And I set field "mitarb" to "MACHNIX" 
And I set field "asnr" to "nummer" from editor "RM2_BDE3"
And I press button "tproduktion" in row 1
Then the table has 0 rows
And I set field "mitarb" to "MACHNIX"
Then the table has 1 rows
And I press button "tkomplettrueck" in row 1
And I press button "fertig"
Then the table has 0 rows
And I set field "mitarb" to "MACHNIX" 
And I set field "asnr" to "nummer" from editor "RM2_BDE3"
Then table has values
    | tartikel       | tofmge  | fbu           |truesten             |tproduktion   |tbeenden         |tkurzlauf    |ttextstatus  |trueckmeld|tkomplettrueck| tfortschritt|tunterbrechen  |tabbruch|
    | BG3-BDE        | 0       | icon:product  |icon:ok              |icon:ok       | icon:ok         |icon:ok      |abgeschlossen|icon:ok   | icon:ok      | 100         |               |        |
    |                | 0       |               |                     |              |                 |             | ---         |          |              | 0           |               |        |
And I close the current editor
###############################################
#03.02 Auftragszeit überprüfen
Given I open an editor "AZ2_BDE3_Bearbeitung" from table "(PDC):(OrderTime)" with command "VIEW" for search criteria "$,,ma=MACHNIX;endzeit<>`;fertstatus=Bearbeitung;@richtung=rückwärts;@maxtreffer=1"
Then field "asnr" has value equal to field "nummer" from editor "RM2_BDE3"
Then field "korr" has value "0"
And I close the current editor
##############################################
# 3.12 BA Stornieren
Given I'm logged in with password "sy"
Given I set the fake date to "12.01.1995" 
Given I open an editor "BA" from table "(Workorder):(WorkOrders)" with command "UPDATE" for record "BDE3_000"
And I respond with answer "ja" to the dialog with id "1483"
And I set field "status" to "S"
And I save the current editor

###############################################################
Scenario: 4 Komplettrückmeldungen rmimdialog = ja und nein Auftragszeiten aus der Vergangenheit
# Debug
#      Rückmeldenummern: RM1_BDE4   RM2_BDE4   RM3_BDE4
#      Auftragszeiten:   AZ1_BDE4_Bearbeitung    AZ2_BDE4_Bearbeitung   AZ3_BDE4_Bearbeitung
# 01 FV anlegen für BG mit 3 AGs und freigeben
Given I'm logged in with password "sy"
Given I set the fake date to "12.01.1995" 
Given I open an editor "fvor_BDE4" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
And I append rows
    | artikel        | netmge     | bisuch    | mfreig    |
    | BG3-BDE        | 100        | BDE4_   | ja        |
And I press button "freig" to open a subeditor for "BA_freigeben"
And I close the current editor
And I switch the current editor to editor "fvor_BDE4"
And I save the current editor
##############################################
# 02 Dispo  starten
And I run Scheduling
#############################################
# 03 RM auf den ersten und zweiten AG, damit eine Nummer haben
Given I open an editor "RM1_BDE4" from table "(Workorder):(WorkOrders)" with command "DONE" for record "BDE4_001"
And I set fields
    | sofort    | ja         |
    | bem       | Nummer         | 
And I save the current editor 
Given I open an editor "RM2_BDE4" from table "(Workorder):(WorkOrders)" with command "DONE" for record "BDE4_002"
And I set fields
    | sofort    | ja         |
    | bem       | Nummer         | 
And I save the current editor 
Given I open an editor "RM3_BDE4" from table "(Workorder):(WorkOrders)" with command "DONE" for record "BDE4_003"
And I set fields
    | sofort    | ja         |
    | bem       | Nummer         | 
And I save the current editor 
##############################################
# 03.01 SCANORDERTIME rmimdialog = nein
Given I'm logged in with password "sfloor"
Given I set the fake date to "12.01.1995" 
Given I open the infosystem "SCANORDERTIME"
And I set field "sicherheit" to "nein"
And I set field "mitarb" to "SCHNEID" 
And I set field "asnr" to "nummer" from editor "RM1_BDE4"
And I press button "tproduktion" in row 1
Then the table has 0 rows
And I close the current editor
###############################################
#03.02 Auftragszeit in die Vergangenheit setzen
Given I open an editor "AZ1_BDE4_Bearbeitung" from table "(PDC):(OrderTime)" with command "UPDATE" for search criteria "$,,ma=SCHNEID;endzeit=`;fertstatus=Bearbeitung;@richtung=rückwärts;@maxtreffer=1"
Then field "asnr" has value equal to field "nummer" from editor "RM1_BDE4"
And I set field "anfdat" to "-2"
And I save the current editor
#################################################
Given I open the infosystem "SCANORDERTIME"
And I set field "sicherheit" to "nein"
And I set field "mitarb" to "SCHNEID" 
Then the table has 1 rows
And I press button "tkomplettrueck" in row 1
Then field "bdestatus" has value "icon:ball_red"
And I close the current editor
# Auftragszeit in der Vergangenheit wieder ablegen
Given I open an editor "AZ1_BDE4_Bearbeitung" from table "(PDC):(OrderTime)" with command "UPDATE" for search criteria "$,,ma=SCHNEID;endzeit=`;fertstatus=Bearbeitung;@richtung=rückwärts;@maxtreffer=1"
Then field "asnr" has value equal to field "nummer" from editor "RM1_BDE4"
And I set field "ablagef" to "ja"
And I save the current editor
##############################################
# 03.01 SCANORDERTIME rmimdialog = ja
Given I open the infosystem "SCANORDERTIME"
And I set field "sicherheit" to "nein"
And I set field "mitarb" to "MACHNIX" 
And I set field "asnr" to "nummer" from editor "RM2_BDE4"
And I press button "tproduktion" in row 1
Then the table has 0 rows
And I close the current editor
###############################################
#03.02 Auftragszeit in die Vergangenheit setzen
Given I open an editor "AZ2_BDE4_Bearbeitung" from table "(PDC):(OrderTime)" with command "UPDATE" for search criteria "$,,ma=MACHNIX;endzeit=`;fertstatus=Bearbeitung;@richtung=rückwärts;@maxtreffer=1"
Then field "asnr" has value equal to field "nummer" from editor "RM2_BDE4"
And I set field "anfdat" to "-2"
And I save the current editor
#################################################
# 03.01 SCANORDERTIME rmimdialog = ja
Given I open the infosystem "SCANORDERTIME"
And I set field "sicherheit" to "nein"
And I set field "mitarb" to "MACHNIX" 
And I press button "tkomplettrueck" in row 1
And I press button "fertig"
Then field "bdestatus" has value "icon:ball_red"
And I close the current editor
# Auftragszeit in der Vergangenheit wieder ablegen
Given I open an editor "AZ2_BDE4_Bearbeitung" from table "(PDC):(OrderTime)" with command "UPDATE" for search criteria "$,,ma=MACHNIX;endzeit=`;fertstatus=Bearbeitung;@richtung=rückwärts;@maxtreffer=1"
Then field "asnr" has value equal to field "nummer" from editor "RM2_BDE4"
And I set field "ablagef" to "ja"
And I save the current editor
#############################################
# SCANORDERTIME Teilrückmeldung und Komplettrückmeldung
Given I open the infosystem "SCANORDERTIME"
And I set field "sicherheit" to "nein"
And I set field "mitarb" to "SCHNEID" 
And I set field "asnr" to "nummer" from editor "RM3_BDE4"
# 1. Zeile Neuanstemplung
# 2. Zeile Trennzeile
# 3. Zeile bestehende Stempelung
Then the table has 2 rows
And I press button "tproduktion" in row 1
And I set field "mitarb" to "SCHNEID"
Then the table has 1 rows
And I press button "trueckmeld" in row 1
And I set field "istmge" to "5"
And I press button "fertig"
Then the table has 0 rows
And I set field "mitarb" to "SCHNEID" 
And I set field "asnr" to "nummer" from editor "RM3_BDE4"
Then table has values
    | tartikel       | tofmge  | fbu           |truesten | tproduktion         | tbeenden   | tkurzlauf   |ttextstatus | tfortschritt|
    | BG3-BDE        | 95      | icon:product  |icon:ok  |icon:plus            |            |icon:plus    |Bearbeitung | 5           |
	|                | 0       |               |         |                     |            |             | ---        | 0           | 
# Durch das Durchbuchen hat sich die offene Menge von 100 auf 95 fuer den ersten Arbeitsschein veraendert
# Der 3. AS wurde mit 5 Stueck Gutmenge bebucht    
And I press button "tproduktion" in row 1  
And I set field "mitarb" to "SCHNEID"
Then the table has 1 rows 
And I press button "tkomplettrueck" in row 1
And I set field "mitarb" to "SCHNEID" 
And I set field "asnr" to "nummer" from editor "RM3_BDE4"
# Der letzte Arbeitsgang wurde über die vollstaendige Menge zurueckgemeldet
Then the table has 0 rows
Then field "bdestatus" has value "icon:ball_red"
And I close the current editor
# enstandene Auftragszeit prüfen    
Given I open an editor "AZ3_BDE4_Bearbeitung" from table "(PDC):(OrderTime)" with command "VIEW" for search criteria "$,,ma=SCHNEID;endzeit<>`;fertstatus=Bearbeitung;@richtung=rückwärts;@maxtreffer=1"
Then field "asnr" has value equal to field "nummer" from editor "RM3_BDE4"
Then field "anfzeit" has value equal to field "endzeit" from editor "AZ3_BDE4_Bearbeitung" 
Then field "korr" has value "31.67"
And I save the current editor  
# Der BA ist schon voll zurueck gemeldet. Er muss nicht mehr storniert werden.  
#############################################################
Scenario: 5 Mitarbeiter 1 hat offene Bearbeitungzeit, Mitarbeiter 2 möchte sofort teilrückmelden, das geht nicht
# Debug:
#          Rückmeldenummern:  RM1_BDE5   
# 01 FV anlegen für BG mit 3 AGs und freigeben
Given I'm logged in with password "sy"
Given I set the fake date to "12.01.1995" 
Given I open an editor "fvor_BDE5" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
And I append rows
    | artikel        | netmge     | bisuch    | mfreig    |
    | BG3-BDE        | 100        | BDE5_   | ja        |
And I press button "freig" to open a subeditor for "BA_freigeben"
And I close the current editor
And I switch the current editor to editor "fvor_BDE5"
And I save the current editor
##############################################
# 02 Dispo  starten
And I run Scheduling
#############################################
# 03 RM auf den ersten AG, damit eine Nummer haben
Given I open an editor "RM1_BDE5" from table "(Workorder):(WorkOrders)" with command "DONE" for record "BDE5_001"
And I set fields
    | sofort    | ja         |
    | bem       | Nummer     |  
And I save the current editor
############################################
# SCANORDERTIME
Given I'm logged in with password "sfloor"
Given I set the fake date to "12.01.1995" 
Given I open the infosystem "SCANORDERTIME"
And I set field "mitarb" to "SCHNEID" 
And I set field "asnr" to "nummer" from editor "RM1_BDE5"
And I press button "tproduktion" in row 1
And I set field "mitarb" to "MACHNIX" 
And I set field "asnr" to "nummer" from editor "RM1_BDE5"
Then the table has 2 rows
Then table has values
    | tartikel       | tofmge  | fbu           |truesten             |tproduktion | tbeenden | tkurzlauf    |ttextstatus  |trueckmeld|tkomplettrueck| tfortschritt|tunterbrechen  |tabbruch|
    | BG3-BDE        | 100     | icon:product  |icon:ok              |icon:plus   |          | icon:plus    |Bearbeitung  |          |              | 0           |               |        |
    |                | 0       |               |                     |            |          |              | ---         |          |              | 0           |               |        | 
# offene Auftragszeit von Mitarbeiter Schneider beenden, damit man BA stornieren kann
And I set field "mitarb" to "SCHNEID"   
And I press button "tbeenden" in row 1
And I close the current editor
#############################################
# 3.12 BA Stornieren
Given I'm logged in with password "sy"
Given I set the fake date to "12.01.1995" 
Given I open an editor "BA" from table "(Workorder):(WorkOrders)" with command "UPDATE" for record "BDE5_000"
And I respond with answer "ja" to the dialog with id "345"
And I set field "status" to "S"
And I save the current editor
#############################################

#############################################
Scenario: 6 Kurzläufer
# Debug
#        Rückmeldenummern  RM1_BDE6    RM2_BDE6    RM3_BDE6
#        Kurzläufer        KL1_BDE6    KL2_BDE6
# 01 FV anlegen für BG mit 3 AGs und freigeben
Given I'm logged in with password "sy"
Given I set the fake date to "12.01.1995" 
Given I open an editor "fvor_BDE6" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
And I append rows
    | artikel        | netmge     | bisuch    | mfreig    |
    | BG3-BDE        | 100        | BDE6_   | ja        |
And I press button "freig" to open a subeditor for "BA_freigeben"
And I close the current editor
And I switch the current editor to editor "fvor_BDE6"
And I save the current editor
##############################################
# 02 Dispo  starten
And I run Scheduling
#############################################
# 03 RM auf den ersten und zweiten AG, damit eine Nummer haben
Given I open an editor "RM1_BDE6" from table "(Workorder):(WorkOrders)" with command "DONE" for record "BDE6_001"
And I set fields
    | sofort    | ja         |
    | bem       | Nummer         | 
And I save the current editor 
Given I open an editor "RM2_BDE6" from table "(Workorder):(WorkOrders)" with command "DONE" for record "BDE6_002"
And I set fields
    | sofort    | ja         |
    | bem       | Nummer         | 
And I save the current editor 
Given I open an editor "RM3_BDE6" from table "(Workorder):(WorkOrders)" with command "DONE" for record "BDE6_003"
And I set fields
    | sofort    | ja         |
    | bem       | Nummer         | 
And I save the current editor 
#################################################
# 04 SCANORDERTIME erster Kurzläufer
Given I'm logged in with password "sfloor"
Given I set the fake date to "12.01.1995" 
Given I open the infosystem "SCANORDERTIME"
And I set field "mitarb" to "SCHNEID" 
And I set field "asnr" to "nummer" from editor "RM1_BDE6"
And I press button "tkurzlauf" in row 1
And I set field "istzeit" to "3"
And I set field "istmge" to "20"
And I press button "fertig"
And I set field "mitarb" to "SCHNEID" 
And I set field "asnr" to "nummer" from editor "RM1_BDE6"
Then the table has 2 rows
Then table has values
    | tartikel       | tofmge  | fbu           |truesten | tproduktion | tbeenden | tkurzlauf    |ttextstatus   | tfortschritt|
    | BG3-BDE        | 80      | icon:product  |icon:plus|icon:plus    |          | icon:plus    |              | 20          |
    |                | 0       |               |         |             |          |              | ---          | 0           |
And I close the current editor
# entstandenen Kurläufer prüfen
Given I open an editor "KL1_BDE6" from table "(PDC):(ShortProductionOrder)" with command "VIEW" for search criteria "$,,ma=SCHNEID;@richtung=rückwärts;@maxtreffer=1"
Then field "asnr" has value equal to field "nummer" from editor "RM1_BDE6"
Then field "istzeit" has value "3"
Then field "istmge" has value "20"
And I save the current editor  
################################################
#05 SCANORDERTIME zweiter Kurzläufer, es gibt schon eine offene Bearbeitungzeit
Given I open the infosystem "SCANORDERTIME"
And I set field "mitarb" to "MACHNIX" 
And I set field "asnr" to "nummer" from editor "RM2_BDE6"
And I press button "tproduktion" in row 1
And I set field "mitarb" to "MACHNIX" 
And I press button "tkurzlauf" in row 1
And I set field "istzeit" to "7"
And I set field "istmge" to "50"
And I press button "fertig"
And I set field "mitarb" to "MACHNIX" 
And I set field "asnr" to "nummer" from editor "RM2_BDE6"
# Der Mitarbeiter ist ja schon auf diesem Arbeitsschein angemeldet
Then field "bdestatus" has value "icon:ball_red"
Then the table has 1 rows
Then table has values
    | tartikel       | tofmge  | fbu           |truesten | tproduktion         |tbeenden     |tkurzlauf    |ttextstatus   | tfortschritt|
    | BG3-BDE        | 50      | icon:product  |icon:ok  |icon:media_play_green|icon:plus    |icon:plus    |Bearbeitung   | 50          |
# offene Auftragszeit abmelden
And I press button "tbeenden" in row 1
And I close the current editor
#################################################
# entstandenen Kurzläufer prüfen
Given I open an editor "KL2_BDE6" from table "(PDC):(ShortProductionOrder)" with command "VIEW" for search criteria "$,,ma=MACHNIX;@richtung=rückwärts;@maxtreffer=1"
Then field "asnr" has value equal to field "nummer" from editor "RM2_BDE6"
Then field "istzeit" has value "7"
Then field "istmge" has value "50"
And I save the current editor 
##################################################
# 3.12 BA Stornieren
Given I'm logged in with password "sy"
Given I set the fake date to "12.01.1995" 
Given I open an editor "BA" from table "(Workorder):(WorkOrders)" with command "UPDATE" for record "BDE6_000"
And I respond with answer "ja" to the dialog with id "1483"
And I set field "status" to "S"
And I save the current editor

##################################################
Scenario: 7 Abbruch / Unterbrechen / Beenden
# Debug:
#          Rückmeldenummern  RM1_BDE7   RM2_BDE7  RM3_BDE7
#          Auftragszeiten    AZ1_BDE7_Bearbeitung
# 01 FV anlegen für BG mit 3 AGs und freigeben
Given I'm logged in with password "sy"
Given I set the fake date to "12.01.1995" 
Given I open an editor "fvor_BDE7" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
And I append rows
    | artikel        | netmge     | bisuch    | mfreig    |
    | BG3-BDE        | 100        | BDE7_   | ja        |
And I press button "freig" to open a subeditor for "BA_freigeben"
And I close the current editor
And I switch the current editor to editor "fvor_BDE7"
And I save the current editor
##############################################
# 02 Dispo  starten
And I run Scheduling
#############################################
# 03 RM auf den ersten und zweiten AG, damit eine Nummer haben
Given I open an editor "RM1_BDE7" from table "(Workorder):(WorkOrders)" with command "DONE" for record "BDE7_001"
And I set fields
    | sofort    | ja         |
    | bem       | Nummer         | 
And I save the current editor 
Given I open an editor "RM2_BDE7" from table "(Workorder):(WorkOrders)" with command "DONE" for record "BDE7_002"
And I set fields
    | sofort    | ja         |
    | bem       | Nummer         | 
And I save the current editor 
Given I open an editor "RM3_BDE7" from table "(Workorder):(WorkOrders)" with command "DONE" for record "BDE7_003"
And I set fields
    | sofort    | ja         |
    | bem       | Nummer         | 
And I save the current editor 
################################################
#04 SCANORDERTIME Rüstzeit anstempeln und die Rüstzeit abbrechen
Given I'm logged in with password "sfloor"
Given I set the fake date to "12.01.1995" 
Given I open the infosystem "SCANORDERTIME"
And I set field "sicherheit" to "nein"
And I set field "mitarb" to "SCHNEID" 
And I set field "asnr" to "nummer" from editor "RM1_BDE7"
And I press button "truesten" in row 1
Then the table has 0 rows
And I set field "mitarb" to "SCHNEID" 
And I press button "tabbruch" in row 1
And I set field "mitarb" to "SCHNEID" 
And I set field "asnr" to "nummer" from editor "RM1_BDE7"
Then the table has 2 rows
Then table has values
    | tartikel       | tofmge  | fbu           |truesten   | tproduktion| tbeenden  |tkurzlauf    |ttextstatus   | tfortschritt|tabbruch|tunterbrechen|
    | BG3-BDE        | 100     | icon:product  |icon:plus  |icon:plus   |           |icon:plus    |              | 0           |        |             |
    |                | 0       |               |           |            |           |             | ---          | 0           |        |             |
And I close the current editor
#05 SCANORDERTIME Bearbeitungszeit anstempeln und Bearbeitungszeit unterbrechen
Given I open the infosystem "SCANORDERTIME"
And I set field "sicherheit" to "nein"
And I set field "mitarb" to "SCHNEID" 
And I set field "asnr" to "nummer" from editor "RM1_BDE7"
And I press button "tproduktion" in row 1
And I set field "mitarb" to "SCHNEID" 
And I press button "tunterbrechen" in row 1
And I set field "mitarb" to "SCHNEID" 
And I set field "asnr" to "nummer" from editor "RM1_BDE7"
Then table has values
    | tartikel       | tofmge  | fbu           |truesten   | tproduktion |tbeenden   |tkurzlauf  |ttextstatus   | tfortschritt|tabbruch|tunterbrechen|
    | BG3-BDE        | 100     | icon:product  |icon:ok    |icon:plus    |           |icon:plus  |Bearbeitung   | 0           |        |             |
    |                | 0       |               |           |             |           |           | ---          | 0           |        |             |
And I close the current editor
#06 SCANORDERTIME Bearbeitungszeit anstempeln und Bearbeitungszeit abbrechen
Given I open the infosystem "SCANORDERTIME"
And I set field "sicherheit" to "nein"
And I set field "mitarb" to "SCHNEID" 
And I set field "asnr" to "nummer" from editor "RM1_BDE7"
And I press button "tproduktion" in row 1
And I set field "mitarb" to "SCHNEID" 
And I press button "tabbruch" in row 1
And I set field "mitarb" to "SCHNEID" 
And I set field "asnr" to "nummer" from editor "RM1_BDE7"
Then table has values
    | tartikel       | tofmge  | fbu           |truesten   | tproduktion           |tkurzlauf    |ttextstatus   | tfortschritt|tabbruch|tunterbrechen|
    | BG3-BDE        | 100     | icon:product  |icon:plus  |icon:plus              |icon:plus    |              | 0           |        |        |
    |                | 0       |               |           |                       |             | ---          | 0           |        |        |
And I close the current editor
#6.1 SCANORDERTIME Bearbeitungszeit anstempeln und beenden
Given I open the infosystem "SCANORDERTIME"
And I set field "mitarb" to "SCHNEID" 
And I set field "asnr" to "nummer" from editor "RM1_BDE7"
And I press button "tproduktion" in row 1
And I set field "mitarb" to "SCHNEID" 
And I press button "tbeenden" in row 1
And I set field "mitarb" to "SCHNEID" 
And I set field "asnr" to "nummer" from editor "RM1_BDE7"
Then table has values
    | tartikel       | tofmge  | fbu           |truesten   | tproduktion |tbeenden   |tkurzlauf  |ttextstatus   | tfortschritt|tabbruch|tunterbrechen|
    | BG3-BDE        | 100     | icon:product  |icon:ok    |icon:plus    |           |icon:plus  |Bearbeitung   | 0           |        |             |
    |                | 0       |               |           |             |           |           | ---          | 0           |        |             |
And I close the current editor
# 06.02 entstandene Auftragszeit prüfen
Given I open an editor "AZ1_BDE7_Beenden" from table "(PDC):(OrderTime)" with command "VIEW" for search criteria "$,,ma=SCHNEID;endzeit<>`;fertstatus=Bearbeitung;@richtung=rückwärts;@maxtreffer=1"
Then field "asnr" has value equal to field "nummer" from editor "RM1_BDE7"
Then field "ma^such" has value "SCHNEID"
Then field "fertstatus" has value "Bearbeitung"
Then field "istmge" has value "0"
Then field "sofort" has value "ja"
And I save the current editor

#07 zu alte Auftragszeit abbrechen / beenden
Given I open the infosystem "SCANORDERTIME"
And I set field "mitarb" to "MACHNIX" 
And I set field "asnr" to "nummer" from editor "RM2_BDE7"
And I press button "tproduktion" in row 1
And I close the current editor
# Auftragszeit in die Vergangenheit setzen
Given I open an editor "AZ1_BDE7_Bearbeitung" from table "(PDC):(OrderTime)" with command "UPDATE" for search criteria "$,,ma=MACHNIX;endzeit=`;fertstatus=Bearbeitung;@richtung=rückwärts;@maxtreffer=1"
Then field "asnr" has value equal to field "nummer" from editor "RM2_BDE7"
And I set field "anfdat" to "-2"
And I save the current editor
# SCANORDERTIME Fortsetzung
Given I open the infosystem "SCANORDERTIME"
And I set field "sicherheit" to "nein"
And I set field "mitarb" to "MACHNIX" 
And I press button "tabbruch" in row 1
Then field "bdestatus" has value "icon:ball_red"
And I press button "tunterbrechen" in row 1
Then field "bdestatus" has value "icon:ball_red"
And I close the current editor
#alte Auftragszeit ablegen, damit man BA stornieren kann
Given I open an editor "AZ1_BDE7_Bearbeitung" from table "(PDC):(OrderTime)" with command "UPDATE" for search criteria "$,,ma=MACHNIX;endzeit=`;fertstatus=Bearbeitung;@richtung=rückwärts;@maxtreffer=1"
Then field "asnr" has value equal to field "nummer" from editor "RM2_BDE7"
And I set field "ablagef" to "ja"
And I save the current editor
###################################################
# 3.12 BA Stornieren
Given I'm logged in with password "sy"
Given I set the fake date to "12.01.1995" 
Given I open an editor "BA" from table "(Workorder):(WorkOrders)" with command "UPDATE" for record "BDE7_000"
And I respond with answer "ja" to the dialog with id "345"
And I set field "status" to "S"
And I save the current editor

##################################################   
Scenario: 8 Mehrfaches Rüsten
# Debug:
#          Rückmeldenummern  RM1_BDE8   RM2_BDE8  RM3_BDE8
Given I'm logged in with password "sy"
Given I set the fake date to "12.01.1995" 
Given I open an editor "fvor_BDE8" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
And I append rows
    | artikel        | netmge     | bisuch    | mfreig    |
    | BG3-BDE        | 100        | BDE8_   | ja        |
And I press button "freig" to open a subeditor for "BA_freigeben"
And I close the current editor
And I switch the current editor to editor "fvor_BDE8"
And I save the current editor
##############################################
# 02 Dispo  starten
And I run Scheduling
#############################################
# 03 RM auf den ersten und zweiten AG, damit eine Nummer haben
Given I open an editor "RM1_BDE8" from table "(Workorder):(WorkOrders)" with command "DONE" for record "BDE8_001"
And I set fields
    | sofort    | ja         |
    | bem       | Nummer         | 
And I save the current editor 
Given I open an editor "RM2_BDE8" from table "(Workorder):(WorkOrders)" with command "DONE" for record "BDE8_002"
And I set fields
    | sofort    | ja         |
    | bem       | Nummer         | 
And I save the current editor 
Given I open an editor "RM3_BDE8" from table "(Workorder):(WorkOrders)" with command "DONE" for record "BDE8_003"
And I set fields
    | sofort    | ja         |
    | bem       | Nummer     | 
And I save the current editor 
# 04 Scanordertime auf Mehrfaches Rüsten setzen
Given I'm logged in with password "sfloor"
Given I set the fake date to "12.01.1995" 
Given I open the infosystem "SCANORDERTIME"
And I set field "mehrruesten" to "ja"
And I set field "sicherheit" to "nein"
And I set field "mitarb" to "MACHNIX"
And I set field "asnr" to "nummer" from editor "RM1_BDE8"
Then the table has 2 rows
Then table has values
   |neu|aznr | tartikel       | tofmge  | fbu           |truesten | tproduktion | tbeenden  | tkurzlauf   |ttextstatus | tfortschritt|tabbruch|tunterbrechen|
   | ja|     | BG3-BDE        | 100     | icon:product  |icon:plus|icon:plus    |           |icon:plus    |            | 0           |        |             | 
   | ja|     |                | 0       |               |         |             |           |             |---         | 0           |        |             | 
And I press button "truesten" in row 1
And I set field "mitarb" to "MACHNIX"
Then the table has 1 rows
Then table has values
   |neu | tartikel       | tofmge  | fbu           |truesten                 | tproduktion  | tbeenden  | tkurzlauf   |ttextstatus | tfortschritt|tabbruch              |tunterbrechen              |
   |nein| BG3-BDE        | 100     | icon:product  |icon:media_play_green    |icon:plus     | icon:plus |icon:plus    |Rüsten     | 0           |icon:media_stop_green |icon:media_pause_green     |     
And I press button "tproduktion" in row 1
And I set field "mitarb" to "SCHNEID"
And I set field "asnr" to "nummer" from editor "RM1_BDE8"
Then the table has 2 rows
Then table has values
   |neu|aznr | tartikel       | tofmge  | fbu           |truesten | tproduktion |tbeenden | tkurzlauf   |ttextstatus | tfortschritt|tabbruch|tunterbrechen|
   | ja|     | BG3-BDE        | 100     | icon:product  |icon:plus|icon:plus    |         |icon:plus    |Bearbeitung | 0           |        |             | 
   | ja|     |                | 0       |               |         |             |         |             |---         | 0           |        |             | 
And I press button "truesten" in row 1
And I set field "mitarb" to "SCHNEID"
Then the table has 1 rows
Then table has values
   |neu | tartikel       | tofmge  | fbu           |truesten                 | tproduktion |tbeenden   | tkurzlauf   |ttextstatus | tfortschritt|tabbruch              |tunterbrechen              |
   |nein| BG3-BDE        | 100     | icon:product  |icon:media_play_green    | icon:plus   | icon:plus |icon:plus    |Bearbeitung | 0           |icon:media_stop_green |icon:media_pause_green     | 
And I press button "tunterbrechen" in row 1
And I set field "mitarb" to "MACHNIX"
Then the table has 1 rows
Then table has values
   |neu | tartikel       | tofmge  | fbu           |truesten | tproduktion          | tbeenden  | tkurzlauf   |ttextstatus | tfortschritt|tabbruch              |tunterbrechen              |
   |nein| BG3-BDE        | 100     | icon:product  |         |icon:media_play_green | icon:plus |icon:plus    |Bearbeitung | 0           |icon:media_stop_green |icon:media_pause_green     |     
And I press button "tkomplettrueck" in row 1
And I close the current editor

###################################################
# BA Stornieren
Given I'm logged in with password "sy"
Given I set the fake date to "12.01.1995" 
Given I open an editor "BA" from table "(Workorder):(WorkOrders)" with command "UPDATE" for record "BDE8_000"
#And I respond with answer "ja" to the dialog with id "345"
And I respond with answer "ja" to the dialog with id "1483"
And I set field "status" to "S"
And I save the current editor

###################################################
Scenario: SNR01 Seriennummer erneut verwenden

Given I open an editor "AG1" from table "(Operation):(Operation)" with command "UPDATE" for record "AG1"
And I set field "rmimdialog" to "ja"
And I save the current editor

# seriennummernpflichtige Baugruppe, Komponenten keine Chargen- oder SNR-Pflicht
Given I open an editor "BG1" from table "(Part):(Product)" with command "COPY" for record "BG1"
And I set fields
    | such          | BG123_SNR                  |
    | chverfolgung  | Seriennummernverfolgung    |
And I delete row at position !lastRow
Then field "elex^id" has value "!AG1^id" in row !lastRow
And I save the current editor

Given I create a Lot "SNR_OK" for Product "BG123_SNR"
Given I create a Lot "SNR_NOT_OK" for Product "BG123_SNR"

Given I create a work order "SNR_BA1" for Product "BG123_SNR" with quantity "2" and search word "SNR_BA1_"
Given I create a work order "SNR_BA2" for Product "BG123_SNR" with quantity "1" and search word "SNR_BA2_"

# Rueckmeldung auf Arbeitsschein 1 mit Angabe einer zugehenden Seriennummer
Given I open an editor "RM1_SNR_BA1" from table "(Workorder):(WorkOrders)" with command "DONE" for search criteria "$,,such=SNR_BA1_001;@richtung=rückwärts;@maxordtreffer=1"
And I set fields
    | kcharge   | !SNR_NOT_OK^id    |
    | sofort    | ja                |
    | bem       | RM1_SNR_BA1       |
And I set field "gutmge" to "1" in row 1
And I save the current editor

# Rueckmeldung auf Arbeitsschein 1 mit Angabe einer zugehenden Seriennummer
Given I open an editor "RM2_SNR_BA1" from table "(Workorder):(WorkOrders)" with command "DONE" for search criteria "$,,such=SNR_BA1_001;@richtung=rückwärts;@maxordtreffer=1"
And I set fields
    | kcharge   | !SNR_OK^id    |
    | sofort    | ja            |
    | bem       | RM2_SNR_BA1   |
And I set field "gutmge" to "1" in row 1
And I save the current editor

# Abgang buchen, damit die SNR erneut zugebucht werden kann
Given I open an editor "Lagerbuchung" for tip command "(Stockadjustment)" and arguments ""
And I set fields
    | artikel   | BG123_SNR     |
    | buart     | Abgang        |
    | beleg     | LBU_SNR_OK1   |
    | beldat    | .             |
And I delete all rows
And I append rows
    | mge    | platz    | charge1       |
    | 1      | F1       | !SNR_OK^id    |
And I save the current editor

# SNR hat keinen Bestand, sngebzugang ist gefuellt
Given I open an editor "SNR_OK" from table "(Lots):(Lots)" with command "VIEW" for search criteria "$,,exnum=SNR_OK;@maxtreffer=1;@ablageart=lebendig"
Then field "mge" has value "0"
Then field "sngebzugang" is not empty
And I close the current editor

# SNR hat Bestand, sngebzugang ist gefuellt
Given I open an editor "SNR_NOT_OK" from table "(Lots):(Lots)" with command "VIEW" for search criteria "$,,exnum=SNR_NOT_OK;@maxtreffer=1;@ablageart=lebendig"
Then field "mge" has value "1"
Then field "sngebzugang" is not empty
And I close the current editor

# Arbeitsschein1 öffnen
Given I open an editor "AS1" from table "(Workorder):(WorkOrders)" with command "VIEW" for record "SNR_BA2_001"
And I close the current editor

# SCANORDERTIME rmimdialog = ja, Komplettrueckmeldung
Given I open the infosystem "SCANORDERTIME"
And I set field "sicherheit" to "nein"
And I set field "mitarb" to "MACHNIX"
And I set field "asnr" to "!AS1^nummer"
And I press button "tproduktion" in row 1
Then the table has 0 rows
And I set field "mitarb" to "MACHNIX"
Then the table has 1 rows
And I press button "tkomplettrueck" in row 1
And I set field "charge" to "!SNR_OK^id"
And I set field "bsnerneutverwend" to "ja"
# bei einer SNR die Bestand <> 0 hat, wird bsnerneutverwend geleert und schreibgeschuetzt
And I set field "charge" to "!SNR_NOT_OK^id"
Then field "bsnerneutverwend" is not modifiable
Then field "bsnerneutverwend" has value "nein"
And I set field "charge" to "!SNR_OK^id"
And I set field "bsnerneutverwend" to "ja"
And I press button "fertig"
And I close the current editor

# im gebuchten Rueckmeldebeleg ist ersichtlich, dass die SNR erneut verwendet wurde
Given I open an editor "RM_WORK_PRUEF" from table "(Workorder):(CompletionConfirmations)" with command "VIEW" for search criteria "$,,such=SNR_BA2_001;bdeobjekt<>`;@ablage=abgelegt;@richtung=rückwärts;@maxordtreffer=1"
Then field "ksnerneutverwend" has value "ja"
Then field "kcharge^id" has value "!SNR_OK^id"
And I close the current editor


Scenario: MZEIT01 Maschinenzeit automatisch berechnen wird aus Maschinengruppe uebernommen und an Rueckmeldung uebergeben

Given I set the fake date to "12.01.1995"

Given I open an editor "M101" from table "(Capacity):(WorkCenter)" with command "UPDATE" for record "M101"
And I set field "automzeit" to "ja"
And I save the current editor

Given I create a work order "MZEIT01_" for Product "BG1" with quantity "10" and search word "MZEIT01_"

# Arbeitsschein oeffnen, um Zugriff auf Nummer zu haben
Given I open an editor "AS_MZEIT01_001" from table "(Workorder):(WorkOrders)" with command "UPDATE" for record "MZEIT01_001"
And I close the current editor

# SCANORDERTIME Kurzlaeufer
Given I'm logged in with password "sfloor"
Given I set the fake date to "12.01.1995"
Given I open the infosystem "SCANORDERTIME"
And I set fields
    | mzeitberechnen    | ja                        |
    | mitarb            | SCHNEID                   |
    | asnr              | !AS_MZEIT01_001^nummer    |
And I press button "tkurzlauf" in row 1
And I set field "istzeit" to "3"
And I set field "istmge" to "5"
And I press button "fertig"
And I close the current editor

# entstandenen Kurlaeufer pruefen
Given I open an editor "KURZL_MZEIT01_001" from table "(PDC):(ShortProductionOrder)" with command "VIEW" for search criteria "$,,ma=SCHNEID;@richtung=rückwärts;@maxtreffer=1"
Then field "asnr" has value equal to field "nummer" from editor "AS_MZEIT01_001"
Then field "istzeit" has value "3"
Then field "mzeit" has value "3"
Then field "istmge" has value "5"
And I save the current editor

Given I set the fake date to "12.01.1995"
Given I open the infosystem "SCANORDERTIME"
And I set fields
    | sicherheit        | nein                      |
    | mzeitberechnen    | ja                        |
    | mitarb            | SCHNEID                   |
    | asnr              | !AS_MZEIT01_001^nummer    |
And I press button "tproduktion" in row 1
And I close the current editor

Given I set the fake date to "12.01.1995"
And I wait 2 time units to move the time forward
Given I open the infosystem "SCANORDERTIME"
And I set fields
    | sicherheit        | nein                      |
    | mzeitberechnen    | ja                        |
    | mitarb            | SCHNEID                   |
    | asnr              | !AS_MZEIT01_001^nummer    |
And I set field "mitarb" to "SCHNEID"
And I press button "tkomplettrueck" in row 1
Then field "automzeit" is modifiable
Then field "automzeit" has value "ja"
And I press button "fertig"
And I close the current editor

# Maschinenzeit in Rueckmeldung pruefen
Given I open an editor "RM_MZEIT01_PRUEF" from table "(Workorder):(CompletionConfirmations)" with command "VIEW" for search criteria "$,,such=MZEIT01_001;bdeobjekt<>`;@ablage=abgelegt;@richtung=rückwärts;@maxordtreffer=1"
Then field "mzeit" has value "2"
And I close the current editor
