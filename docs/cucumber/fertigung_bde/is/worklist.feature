@persistent
Feature: worklist.feature

# *****************************************************************************
#  Name             : worklist
#  Autor            : tiwe
#  Verantwortlich   : teaminfosysteme
#  Kontrolle        : cl
#  Funktion         : Testet das Infosystem WORKLIST. An- und abstempeln von Auftragszeiten.
#
# *****************************************************************************
#
#
Background:
Given I set the fake date to "12.01.1995" 
Scenario: 1 Rüsten und Bearbeitung beginnen und erste Teilrückmeldungen
# Debug: 4 Auftragszeiten, 2x fertstatus Rüsten, 2 ferstatus Bearbeitung beginnen, eine davon hat keine Endzeit
#        Rückmeldenummern: RM1_BDE1 und RM2_BDE1
#        Auftragszeiten:   AZ1_BDE1_Rüsten, AZ2_BDE1_Rüsten, AZ3_BDE1_Bearbeitung, AZ4_BDE1_Bearbeitung
################################################################################
# 00 als erstes es darf keine offenen BAs für den Artikel BG3-BDE geben
Given I'm logged in with password "sy"
Given I set the fake date to "12.01.1995" 
Given I open the infosystem "PRODLIST"
And I set field "kart" to "BG3-BDE"
And I set field "bba" to "ja"
Then I press start
Then the table has 0 rows
And I close the current editor
##############################################
# 01 FV anlegen für BG mit 3 AGs und freigeben
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
##############################################
# 03.01 WORKLIST unbearbeiteter Arbeitsschein
Given I'm logged in with password "sfloor"
Given I set the fake date to "12.01.1995" 
Given I open the infosystem "WORKLIST"
And I set field "mitarb" to "SCHNEID" 
And I set field "mgr" to "MGR1"
And I press start
Then the table has 1 rows
Then table has values
    | tartikel       | tofmge  | fbu           |truesten | tproduktion  | tbeenden | tkurzlauf   |ttextstatus | tfortschritt|tabbruch|tunterbrechen|
    | BG3-BDE        | 100     | icon:product  |icon:plus|icon:plus     |          | icon:plus   |            | 0           |        |        | 
And I close the current editor
##############################################
# 03.02 WORKLIST Rüsten Anstempeln
Given I open the infosystem "WORKLIST"
And I set field "mitarb" to "SCHNEID" 
And I set field "mgr" to "MGR1"
And I press start
And I press button "truesten" in row 1
Then table has values
    | tartikel       | tofmge  | fbu           |truesten             | tproduktion  | tbeenden | tkurzlauf   |ttextstatus | tfortschritt|tunterbrechen                      |tabbruch                      |
    | BG3-BDE        | 100     | icon:product  |icon:media_play_green|icon:plus     | icon:plus|  icon:plus  |Rüsten      | 0           |icon:media_pause_green        |icon:media_stop_green         |
And I close the current editor
##############################################
# 03.03 entstandene Auftragszeit prüfen
Given I open an editor "AZ1_BDE1_Rüsten" from table "(PDC):(OrderTime)" with command "UPDATE" for search criteria "$,,ma=SCHNEID;endzeit=`;fertstatus=Rüsten;@richtung=rückwärts;@sort=offen;@maxtreffer=1"
#Then field "asnr" has value "nummer" from editor "RM1_BDE1"
#Then field "([^"]*)" has value equal to field "([^"]*)" from editor "([^"]*)" in row (\d+|!lastRow)
Then field "asnr" has value equal to field "nummer" from editor "RM1_BDE1"
Then field "ma^such" has value "SCHNEID"
Then field "fertstatus" has value "Rüsten"
# Verhaltensänderung amk, mann sofort nur setzen, wenn Endzeit eingetragen ist
#And I set field "sofort" to "ja"
And I save the current editor
##############################################
# 03.04 WORKLIST Erneut Rüsten anstempeln geht nicht, er rüstet ja schon
Given I open the infosystem "WORKLIST"
And I set field "mitarb" to "SCHNEID" 
And I set field "mgr" to "MGR1"
And I press start
And I press button "truesten" in row 1
Then field "bdestatus" has value "icon:ball_red"
And I close the current editor
##############################################
# 03.04 WORKLIST Paralleles Rüsten eines 2. MAs
Given I open the infosystem "WORKLIST"
And I set field "mitarb" to "MACHNIX" 
And I set field "mgr" to "MGR1"
And I press start
Then the table has 1 rows
Then table has values
    | tartikel       | tofmge  | fbu           |truesten | tproduktion  |tbeenden  | tkurzlauf   |ttextstatus | tfortschritt|
    | BG3-BDE        | 100     | icon:product  |icon:plus|icon:plus     |          | icon:plus   |Rüsten      | 0           |
And I press button "truesten" in row 1
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
#03.06 WORKLIST Bearbeitung beginnen
Given I open the infosystem "WORKLIST"
And I set field "mitarb" to "SCHNEID" 
And I set field "mgr" to "MGR1"
And I press start
Then table has values
    | tartikel       | tofmge  | fbu           |truesten             | tproduktion  | tbeenden | tkurzlauf   |ttextstatus | tfortschritt|tunterbrechen                      |tabbruch                      |
    | BG3-BDE        | 100     | icon:product  |icon:media_play_green|icon:plus     | icon:plus| icon:plus    |Rüsten      | 0           |icon:media_pause_green        |icon:media_stop_green         |
And I press button "tproduktion" in row 1
Then table has values
    | tartikel       | tofmge  | fbu           |truesten             |tproduktion           | tbeenden  |tkurzlauf    |ttextstatus  |trueckmeld|tkomplettrueck| tfortschritt|tunterbrechen                      |tabbruch                      |
    | BG3-BDE        | 100     | icon:product  |icon:ok              |icon:media_play_green | icon:plus | icon:plus    |Bearbeitung  |icon:plus |icon:plus     | 0           |icon:media_pause_green        |icon:media_stop_green         |
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
#03.08 WORKLIST Rüsten melden nachdem die Bearbeitung begonnen hat
Given I open the infosystem "WORKLIST"
And I set field "mitarb" to "MACHNIX" 
And I set field "mgr" to "MGR1"
And I press start
And I press button "truesten" in row 1
Then field "bdestatus" has value "icon:ball_red"
And I close the current editor
##############################################
#03.09 WORKLIST Sofort Bearbeitung melden. Es Gibt kein Rüsten
Given I open the infosystem "WORKLIST"
And I set field "mitarb" to "MACHNIX" 
And I set field "mgr" to "MGR2"
And I press start
Then the table has 1 rows
Then table has values
    | tartikel       | tofmge  | fbu           |truesten | tproduktion  | tbeenden | tkurzlauf   |ttextstatus | tfortschritt|
    | BG3-BDE        | 100     | icon:product  |icon:plus|icon:plus     |          | icon:plus   |            | 0           |
Then I press button "tproduktion" in row 1
Then table has values
    | tartikel       | tofmge  | fbu           |truesten             |tproduktion           | tbeenden  |tkurzlauf    |ttextstatus  |trueckmeld|tkomplettrueck| tfortschritt|tunterbrechen                      |tabbruch                      |
    | BG3-BDE        | 100     | icon:product  |icon:ok              |icon:media_play_green | icon:plus |icon:plus    |Bearbeitung  |icon:plus |icon:plus     | 0           |icon:media_pause_green        |icon:media_stop_green         |
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
Given I open the infosystem "WORKLIST"
And I set field "mitarb" to "MACHNIX" 
And I set field "mgr" to "MGR2"
And I press start
Then the table has 1 rows
And I press button "trueckmeld" in row 1
And I set field "istmge" to "20"
And I press button "fertig"
Then the table has 1 rows
Then table has values
    | tartikel       | tofmge  | fbu           |truesten | tproduktion  | tbeenden    | tkurzlauf   |ttextstatus | tfortschritt|
    | BG3-BDE        | 80      | icon:product  |icon:ok  |icon:plus     |             |icon:plus    |Bearbeitung | 20          |
And I close the current editor
###############################################
#3.12 Auftragzeit mit zu alter Anfangszeit
Given I open an editor "AZ3_BDE1_Bearbeitung" from table "(PDC):(OrderTime)" with command "UPDATE" for search criteria "$,,ma=SCHNEID;endzeit=`;fertstatus=Bearbeitung;@richtung=rückwärts;@sort=offen;@maxtreffer=1"
Then field "asnr" has value equal to field "nummer" from editor "RM1_BDE1"
Then field "ma^such" has value "SCHNEID"
Then field "fertstatus" has value "Bearbeitung"
And I set field "anfdat" to "-2"
And I save the current editor
## Für diese Auftragszeit nun eine Teilrückmeldung über die WORKLIST buchen
Given I open the infosystem "WORKLIST"
And I set field "mitarb" to "SCHNEID" 
And I set field "mgr" to "MGR1"
And I press start
And I press button "trueckmeld" in row 1
And I set field "istmge" to "20"
And I press button "fertig"
Then field "bdestatus" has value "icon:ball_red"
And I close the current editor
## Nun diese Auftragszeit ablegen
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
#And I respond with answer "ja" to the dialog with id "345"
And I respond with answer "ja" to the dialog with id "1483"
And I set field "status" to "S"
And I save the current editor

#########################################################################
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
# 03.01 WORKLIST Arbeitsschein überbuchen
Given I'm logged in with password "sfloor"
Given I set the fake date to "12.01.1995" 
Given I open the infosystem "WORKLIST"
And I set field "mitarb" to "SCHNEID" 
And I set field "mgr" to "MGR1"
And I set field "durchbuchen" to "nein"
Then field "ueberbuchen" has value "ja"
And I press start
Then the table has 1 rows
Then table has values
    | tartikel       | tofmge  | fbu           |truesten | tproduktion  |tbeenden | tkurzlauf   |ttextstatus | tfortschritt|
    | BG3-BDE        | 100     | icon:product  |icon:plus|icon:plus     |         |icon:plus    |            | 0           |
# erste Teilrückmeldung über 50 Stück        
And I press button "tproduktion" in row 1
And I press button "trueckmeld" in row 1
And I set field "istmge" to "50"
And I press button "fertig"
# zweite Teilrückmeldung über 60 Stück 
And I press button "tproduktion" in row 1
And I press button "trueckmeld" in row 1
And I set field "istmge" to "60"
And I press button "fertig"
# zweite Teilrückmeldung über 20 Stück 
And I press button "tproduktion" in row 1
And I press button "trueckmeld" in row 1
And I set field "istmge" to "20"
And I press button "fertig"
Then the table has 1 rows
Then table has values
    | tartikel       | tofmge  | fbu           |truesten             |tproduktion |tbeenden |tkurzlauf    |ttextstatus  |trueckmeld|tkomplettrueck| tfortschritt|tunterbrechen  |tabbruch|
    | BG3-BDE        | -30     | icon:product  |icon:ok              |icon:plus   |         |icon:plus    |Bearbeitung  |          |              | 130         |          |        |
And I close the current editor

# mit PDCTRANSFER die BDE-Objekte uebertragen, damit sich der BA stornieren laesst
Given I open the infosystem "PDCTRANSFER"
And I set field "aschein" to "BDE2_001" 
And I press start
Then the table has 3 rows
Then I press button "allean"
Then I press button "uebertragen"
And I press start
Then the table has 0 rows
And I close the current editor

##############################################
# 03.02 WORKLIST Worklist lässt sich nicht überbuchen
Given I open the infosystem "WORKLIST"
And I set field "mitarb" to "SCHNEID" 
And I set field "mgr" to "MGR2"
And I set field "ueberbuchen" to "nein"
And I press start
Then the table has 1 rows
Then table has values
    | tartikel       | tofmge  | fbu           |truesten | tproduktion |tbeenden  | tkurzlauf   |ttextstatus | tfortschritt|
    | BG3-BDE        | 100     | icon:product  |icon:plus|icon:plus    |          |icon:plus    |            | 0           |
# erste Teilrückmeldung über 50 Stück        
And I press button "tproduktion" in row 1
And I press button "trueckmeld" in row 1
And I set field "istmge" to "50"
And I press button "fertig"
# zweite Teilrückmeldung über 60 Stück 
And I press button "tproduktion" in row 1
And I press button "trueckmeld" in row 1
And I set field "istmge" to "60" 
#hier kommen jetzt Meldungen, dass man nicht überbuchen darf
#Then setting field "istmge" to "60" throws the exception "45353535345345"
And I press button "fertig"
#hier kommen jetzt Meldungen, dass man nicht überbuchen darf
Then the table has 1 rows
Then table has values
    | tartikel       | tofmge  | fbu           |truesten | tproduktion           |tbeenden     | tkurzlauf   |ttextstatus | tfortschritt|
    | BG3-BDE        | 50      | icon:product  |icon:ok  |icon:media_play_green  | icon:plus   |icon:plus    |Bearbeitung | 50          |
# Nun nochmal 50 melden , damit man den BA stornieren kann
And I press button "trueckmeld" in row 1
And I set field "istmge" to "50" 
And I press button "fertig"
And I close the current editor
##############################################
# BA Stornieren
Given I'm logged in with password "sy"
Given I set the fake date to "12.01.1995" 
Given I open an editor "BA" from table "(Workorder):(WorkOrders)" with command "UPDATE" for record "BDE2_000"
#And I respond with answer "ja" to the dialog with id "345"
And I respond with answer "ja" to the dialog with id "1483"
And I set field "status" to "S"
And I save the current editor




##################################################
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
# 03.01 WORKLIST rmimdialog = nein
Given I'm logged in with password "sfloor"
Given I set the fake date to "12.01.1995" 
Given I open the infosystem "WORKLIST"
And I set field "mitarb" to "SCHNEID" 
And I set field "mgr" to "MGR1"
And I set field "sicherheit" to "nein"
And I set field "durchbuchen" to "nein"
And I press start
And I press button "tproduktion" in row 1
And I press button "tkomplettrueck" in row 1
Then the table has 1 rows
Then table has values
    | tartikel       | tofmge  | fbu           |truesten             |tproduktion | tbeenden |tkurzlauf    |ttextstatus  |trueckmeld|tkomplettrueck| tfortschritt|tunterbrechen  |tabbruch|
    | BG3-BDE        | 0       | icon:product  |icon:ok              |icon:ok     | icon:ok  |icon:ok      |abgeschlossen|icon:ok   | icon:ok      | 100         |          |        |
And I close the current editor
#############################################
#03.02 Auftragszeit überprüfen
Given I open an editor "AZ1_BDE3_Bearbeitung" from table "(PDC):(OrderTime)" with command "UPDATE" for search criteria "$,,ma=SCHNEID;endzeit<>`;fertstatus=Bearbeitung;@richtung=rückwärts;@maxtreffer=1"
Then field "asnr" has value equal to field "nummer" from editor "RM1_BDE3"
Then field "endzeit" has value equal to field "anfzeit" from editor "AZ1_BDE3_Bearbeitung"
Then field "korr" has value "16.67"
Then field "bzeit" has value "16.67"
Then field "istzeit" has value "0"
And I set field "sofort" to "ja"
And I save the current editor
##############################################
# 03.03 WORKLIST rmimdialog = ja
Given I open the infosystem "WORKLIST"
And I set field "mitarb" to "MACHNIX" 
And I set field "mgr" to "MGR2"
And I set field "sicherheit" to "nein"
And I set field "durchbuchen" to "nein"
And I press start
And I press button "tproduktion" in row 1
And I press button "tkomplettrueck" in row 1
And I press button "fertig"
Then the table has 1 rows
Then table has values
    | tartikel       | tofmge  | fbu           |truesten             |tproduktion       | tbeenden    |tkurzlauf    |ttextstatus  |trueckmeld|tkomplettrueck| tfortschritt|tunterbrechen  |tabbruch|
    | BG3-BDE        | 0       | icon:product  |icon:ok              |icon:ok           | icon:ok     |icon:ok      |abgeschlossen|icon:ok   | icon:ok      | 100         |          |        |
And I close the current editor
###############################################
#03.02 Auftragszeit überprüfen
Given I open an editor "AZ2_BDE3_Bearbeitung" from table "(PDC):(OrderTime)" with command "UPDATE" for search criteria "$,,ma=MACHNIX;endzeit<>`;fertstatus=Bearbeitung;@richtung=rückwärts;@maxtreffer=1"
Then field "asnr" has value equal to field "nummer" from editor "RM2_BDE3"
Then field "korr" has value "0"
And I set field "sofort" to "ja"
And I save the current editor
##############################################
# 3.12 BA Stornieren
Given I'm logged in with password "sy"
Given I set the fake date to "12.01.1995" 
Given I open an editor "BA" from table "(Workorder):(WorkOrders)" with command "UPDATE" for record "BDE3_000"
#And I respond with answer "ja" to the dialog with id "345"
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
# 03.01 WORKLIST rmimdialog = nein
Given I'm logged in with password "sfloor"
Given I set the fake date to "12.01.1995" 
Given I open the infosystem "WORKLIST"
And I set field "mitarb" to "SCHNEID" 
And I set field "mgr" to "MGR1"
And I set field "sicherheit" to "nein"
And I press start
And I press button "tproduktion" in row 1
And I close the current editor
###############################################
#03.02 Auftragszeit in die Vergangenheit setzen
Given I open an editor "AZ1_BDE4_Bearbeitung" from table "(PDC):(OrderTime)" with command "UPDATE" for search criteria "$,,ma=SCHNEID;endzeit=`;fertstatus=Bearbeitung;@richtung=rückwärts;@maxtreffer=1"
Then field "asnr" has value equal to field "nummer" from editor "RM1_BDE4"
And I set field "anfdat" to "-2"
And I save the current editor
#################################################
Given I open the infosystem "WORKLIST"
And I set field "mitarb" to "SCHNEID" 
And I set field "mgr" to "MGR1"
And I set field "sicherheit" to "nein"
And I press start
And I press button "tkomplettrueck" in row 1
Then field "bdestatus" has value "icon:ball_red"
And I close the current editor
# Auftragszeit aus der Vergangenheit nun ablegen
Given I open an editor "AZ1_BDE4_Bearbeitung" from table "(PDC):(OrderTime)" with command "UPDATE" for search criteria "$,,ma=SCHNEID;endzeit=`;fertstatus=Bearbeitung;@richtung=rückwärts;@maxtreffer=1"
Then field "asnr" has value equal to field "nummer" from editor "RM1_BDE4"
And I set field "ablagef" to "ja"
And I save the current editor
##############################################
# 03.01 WORKLIST rmimdialog = ja
Given I open the infosystem "WORKLIST"
And I set field "mitarb" to "MACHNIX" 
And I set field "mgr" to "MGR2"
And I set field "sicherheit" to "nein"
And I press start
And I press button "tproduktion" in row 1
And I close the current editor
###############################################
#03.02 Auftragszeit in die Vergangenheit setzen
Given I open an editor "AZ2_BDE4_Bearbeitung" from table "(PDC):(OrderTime)" with command "UPDATE" for search criteria "$,,ma=MACHNIX;endzeit=`;fertstatus=Bearbeitung;@richtung=rückwärts;@maxtreffer=1"
Then field "asnr" has value equal to field "nummer" from editor "RM2_BDE4"
And I set field "anfdat" to "-2"
And I save the current editor
#################################################
# 03.01 WORKLIST rmimdialog = ja
Given I open the infosystem "WORKLIST"
And I set field "mitarb" to "MACHNIX" 
And I set field "mgr" to "MGR2"
And I set field "sicherheit" to "nein"
And I press start
And I press button "tkomplettrueck" in row 1
And I press button "fertig"
Then field "bdestatus" has value "icon:ball_red"
And I close the current editor
# Auftragszeit aus der Vergangenheit nun ablegen
Given I open an editor "AZ2_BDE4_Bearbeitung" from table "(PDC):(OrderTime)" with command "UPDATE" for search criteria "$,,ma=MACHNIX;endzeit=`;fertstatus=Bearbeitung;@richtung=rückwärts;@maxtreffer=1"
Then field "asnr" has value equal to field "nummer" from editor "RM2_BDE4"
And I set field "ablagef" to "ja"
And I save the current editor
#############################################
# Worklist Teilrückmeldung und Komplettrückmeldung
Given I open the infosystem "WORKLIST"
And I set field "mitarb" to "SCHNEID" 
And I set field "mgr" to "MGR3"
And I set field "sicherheit" to "nein"
And I set field "durchbuchen" to "nein"
And I press start
And I press button "tproduktion" in row 1
And I press button "trueckmeld" in row 1
And I set field "istmge" to "5"
And I press button "fertig"
Then the table has 1 rows
Then table has values
    | tartikel       | tofmge  | fbu           |truesten | tproduktion     |tbeenden   | tkurzlauf   |ttextstatus | tfortschritt|
    | BG3-BDE        | 95      | icon:product  |icon:ok  |icon:plus        |           |icon:plus    |Bearbeitung | 5           |
And I press button "tproduktion" in row 1    
And I press button "tkomplettrueck" in row 1
Then table has values
    | tartikel       | tofmge  | fbu           |truesten | tproduktion   |tbeenden          |tkurzlauf    |ttextstatus   | tfortschritt|
    | BG3-BDE        | 0       | icon:product  |icon:ok  |icon:ok        | icon:ok          |icon:ok      |abgeschlossen | 100         |
And I close the current editor
# enstandene Auftragszeit prüfen    
Given I open an editor "AZ3_BDE4_Bearbeitung" from table "(PDC):(OrderTime)" with command "VIEW" for search criteria "$,,ma=SCHNEID;endzeit<>`;fertstatus=Bearbeitung;@richtung=rückwärts;@maxtreffer=1"
Then field "asnr" has value equal to field "nummer" from editor "RM3_BDE4"
Then field "anfzeit" has value equal to field "endzeit" from editor "AZ3_BDE4_Bearbeitung" 
Then field "korr" has value "31.67"
And I save the current editor 

# mit PDCTRANSFER die BDE-Objekte uebertragen, damit sich der BA stornieren laesst
Given I open the infosystem "PDCTRANSFER"
And I set field "aschein" to "BDE4_003" 
And I press start
Then the table has 2 rows
Then I press button "allean"
Then I press button "uebertragen"
And I press start
Then the table has 0 rows
And I close the current editor
# BA ist jetzt fertig: Rueckmeldung auf letzten AG mit voller Menge

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
# 03 RM auf den ersten und zweiten AG, damit eine Nummer haben
Given I open an editor "RM1_BDE5" from table "(Workorder):(WorkOrders)" with command "DONE" for record "BDE5_001"
And I set fields
    | sofort    | ja         |
    | bem       | Nummer     |  
And I save the current editor
############################################
# Worklist
Given I'm logged in with password "sfloor" 
Given I set the fake date to "12.01.1995" 
Given I open the infosystem "WORKLIST"
And I set field "mitarb" to "SCHNEID" 
And I set field "mgr" to "MGR1"
And I press start
And I press button "tproduktion" in row 1
And I set field "mitarb" to "MACHNIX" 
And I set field "mgr" to "MGR1"
And I press start
And I press button "trueckmeld" in row 1
# Button hat kein Icon und damit keine Funktion
Then table has values
    | tartikel       | tofmge  | fbu           |truesten             |tproduktion  |tbeenden    |tkurzlauf    |ttextstatus  |trueckmeld|tkomplettrueck| tfortschritt|tunterbrechen  |tabbruch|
    | BG3-BDE        | 100     | icon:product  |icon:ok              |icon:plus    |            |icon:plus    |Bearbeitung  |          |              | 0           |               |        |
# Auftragszeit von MA Schneider beenden damit man BA stornieren darf
And I set field "mitarb" to "SCHNEID" 
And I set field "mgr" to "MGR1"
And I press start
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
# 04 Worklist erster Kurzläufer
Given I'm logged in with password "sfloor"
Given I set the fake date to "12.01.1995" 
Given I open the infosystem "WORKLIST"
And I set field "mitarb" to "SCHNEID" 
And I set field "mgr" to "MGR1"
And I press start
And I press button "tkurzlauf" in row 1
And I set field "istzeit" to "3"
And I set field "istmge" to "20"
And I press button "fertig"
Then the table has 1 rows
Then table has values
    | tartikel       | tofmge  | fbu           |truesten | tproduktion  |tbeenden    |tkurzlauf    |ttextstatus   | tfortschritt|
    | BG3-BDE        | 80      | icon:product  |icon:plus|icon:plus     |            |icon:plus    |              | 20          |
And I close the current editor
# entstandenen Kurläufer prüfen
Given I open an editor "KL1_BDE6" from table "(PDC):(ShortProductionOrder)" with command "VIEW" for search criteria "$,,ma=SCHNEID;@richtung=rückwärts;@maxtreffer=1"
Then field "asnr" has value equal to field "nummer" from editor "RM1_BDE6"
Then field "istzeit" has value "3"
Then field "istmge" has value "20"
And I save the current editor  
################################################
#05 Worklist zweiter Kurzläufer, es gibt schon eine offene Bearbeitungzeit
Given I open the infosystem "WORKLIST"
And I set field "mitarb" to "MACHNIX" 
And I set field "mgr" to "MGR2"
And I press start
And I press button "tproduktion" in row 1
And I press button "tkurzlauf" in row 1
And I set field "istzeit" to "7"
And I set field "istmge" to "50"
And I press button "fertig"
Then the table has 1 rows
Then table has values
    | tartikel       | tofmge  | fbu           |truesten | tproduktion          |tbeenden   |tkurzlauf    |ttextstatus   | tfortschritt|
    | BG3-BDE        | 50      | icon:product  |icon:ok  |icon:media_play_green |icon:plus  |icon:plus    |Bearbeitung   | 50          |
# offene Auftragszeit abmelden, damit man BA stornieren darf
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
#And I respond with answer "ja" to the dialog with id "345"
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
#04 Worklist Rüstzeit anstempeln und die Rüstzeit abbrechen
Given I'm logged in with password "sfloor"
Given I set the fake date to "12.01.1995" 
Given I open the infosystem "WORKLIST"
And I set field "mitarb" to "SCHNEID" 
And I set field "mgr" to "MGR1"
And I set field "sicherheit" to "nein"
And I press start
And I press button "truesten" in row 1
And I press button "tabbruch" in row 1
Then the table has 1 rows
Then table has values
    | tartikel       | tofmge  | fbu           |truesten   | tproduktion  |tbeenden   |tkurzlauf    |ttextstatus   | tfortschritt|tabbruch|tunterbrechen|
    | BG3-BDE        | 100     | icon:product  |icon:plus  |icon:plus     |           |icon:plus    |              | 0           |        |        |
And I close the current editor
#05 Worklist Bearbeitungszeit anstempeln und Bearbeitungszeit unterbrechen
Given I open the infosystem "WORKLIST"
And I set field "mitarb" to "SCHNEID" 
And I set field "mgr" to "MGR1"
And I set field "sicherheit" to "nein"
And I press start
And I press button "tproduktion" in row 1
And I press button "tunterbrechen" in row 1
Then table has values
    | tartikel       | tofmge  | fbu           |truesten   | tproduktion   |tbeenden |tkurzlauf    |ttextstatus   | tfortschritt|tabbruch|tunterbrechen|
    | BG3-BDE        | 100     | icon:product  |icon:ok    |icon:plus      |         |icon:plus    |Bearbeitung   | 0           |        |        |
And I close the current editor
#06 Worklist Bearbeitungszeit anstempeln und Bearbeitungszeit abbrechen
Given I open the infosystem "WORKLIST"
And I set field "mitarb" to "SCHNEID" 
And I set field "mgr" to "MGR1"
And I set field "sicherheit" to "nein"
And I press start
And I press button "tproduktion" in row 1
And I press button "tabbruch" in row 1
Then table has values
    | tartikel       | tofmge  | fbu           |truesten   | tproduktion   |tbeenden  |tkurzlauf    |ttextstatus   | tfortschritt|tabbruch|tunterbrechen|
    | BG3-BDE        | 100     | icon:product  |icon:plus  |icon:plus      |          |icon:plus    |              | 0           |        |        |
And I close the current editor
#6.1 Worklist Bearbeitungszeit anstempeln und Bearbeitungszeit beenden
Given I open the infosystem "WORKLIST"
And I set field "mitarb" to "SCHNEID" 
And I set field "mgr" to "MGR1"
And I press start
And I press button "tproduktion" in row 1
And I press button "tbeenden" in row 1
Then table has values
    | tartikel       | tofmge  | fbu           |truesten   | tproduktion   |tbeenden  |tkurzlauf    |ttextstatus   | tfortschritt|tabbruch|tunterbrechen|
    | BG3-BDE        | 100     | icon:product  |icon:ok    |icon:plus      |          |icon:plus    |Bearbeitung   | 0           |        |        |
And I close the current editor
# 06.02 entstandene Auftragszeit prüfen
Given I open an editor "AZ1_BDE7_Beenden" from table "(PDC):(OrderTime)" with command "VIEW" for search criteria "$,,ma=SCHNEID;endzeit<>`;fertstatus=Bearbeitung;@richtung=rückwärts;@maxtreffer=1"
Then field "asnr" has value equal to field "nummer" from editor "RM1_BDE7"
Then field "ma^such" has value "SCHNEID"
Then field "fertstatus" has value "Bearbeitung"
Then field "istmge" has value "0"
Then field "sofort" has value "ja"
And I save the current editor
#07 zu alte Auftragszeit abbrechen
Given I open the infosystem "WORKLIST"
And I set field "mitarb" to "MACHNIX" 
And I set field "mgr" to "MGR2"
And I press start
And I press button "tproduktion" in row 1
And I close the current editor
# Auftragszeit in die Vergangenheit setzen
Given I open an editor "AZ1_BDE7_Bearbeitung" from table "(PDC):(OrderTime)" with command "UPDATE" for search criteria "$,,ma=MACHNIX;endzeit=`;fertstatus=Bearbeitung;@richtung=rückwärts;@maxtreffer=1"
Then field "asnr" has value equal to field "nummer" from editor "RM2_BDE7"
And I set field "anfdat" to "-2"
And I set field "anfzeit" to "10:00"
And I save the current editor
# WORKLIST Fortsetzung
Given I open the infosystem "WORKLIST"
And I set field "mitarb" to "MACHNIX" 
And I set field "mgr" to "MGR2"
And I set field "sicherheit" to "nein"
And I press start
And I press button "tabbruch" in row 1
Then field "bdestatus" has value "icon:ball_red"
And I press button "tunterbrechen" in row 1
Then field "bdestatus" has value "icon:ball_red"
And I close the current editor
#Auftragszeit aus der Vergangenheit ablegen
Given I open an editor "AZ1_BDE7_Bearbeitung" from table "(PDC):(OrderTime)" with command "UPDATE" for search criteria "$,,ma=MACHNIX;anfdat=-2;anfzeit=10:00;endzeit=`;fertstatus=Bearbeitung;@richtung=rückwärts;@maxtreffer=1"
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



#################################################
Scenario: 8 Qualifikationsliste
# Debug: keine IDs
# 01 FV anlegen für BG mit 3 AGs und freigeben
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
#03 Worklist mit Qualifikationsliste
Given I'm logged in with password "sfloor"
Given I set the fake date to "12.01.1995" 
Given I open the infosystem "WORKLIST"
And I set field "mitarb" to "KAEPSELE" 
Then field "qualliste" has value "ja"
And I set field "sicherheit" to "nein"
And I set field "durchbuchen" to "nein"
And I set field "nuroffeneaz" to "ja"
And I press start
Then the table has 0 rows
And I set field "nuroffeneaz" to "nein"
And I press start
Then the table has 6 rows
Then table has values
    | tartikel       | tofmge  | fbu           |truesten         |tproduktion|tbeenden|tkurzlauf    |ttextstatus   | tfortschritt|
    | BG3-BDE        | 100     | icon:product  |icon:plus        |icon:plus  |        |icon:plus    |              | 0           |            
    |                | 0       |               |                 |           |        |             |              | 0           |
    | BG3-BDE        | 100     | icon:product  |icon:plus        |icon:plus  |        | icon:plus   |              | 0           |
    |                | 0       |               |                 |           |        |             |              | 0           |
    | BG3-BDE        | 100     | icon:product  |icon:plus_black  |icon:plus  |        |icon:plus    |              | 0           |
    |                | 0       |               |                 |           |        |             |              | 0           |
And I press button "tproduktion" in row 1   
And I press button "tkomplettrueck" in row 1
Then the table has 6 rows
Then table has values
    | tartikel       | tofmge  | fbu           |truesten         |tproduktion | tbeenden   |tkurzlauf    |ttextstatus   | tfortschritt|
    | BG3-BDE        | 0       | icon:product  |icon:ok          |icon:ok     |  icon:ok   | icon:ok     |abgeschlossen | 100         |            
    |                | 0       |               |                 |            |            |             |              | 0           |
    | BG3-BDE        | 100     | icon:product  |icon:plus        |icon:plus   |            |icon:plus    |              | 0           |
    |                | 0       |               |                 |            |            |             |              | 0           |
    | BG3-BDE        | 100     | icon:product  |icon:plus_black  |icon:plus   |            |icon:plus    |              | 0           |
    |                | 0       |               |                 |            |            |             |              | 0           |
And I press button "tproduktion" in row 3
And I press button "tproduktion" in row 5
And I set field "nuroffeneaz" to "ja"
And I press start
Then the table has 2 rows
Then table has values
    | tartikel       | tofmge  | fbu           |truesten  |tproduktion             | tbeenden   |tkurzlauf    |ttextstatus   | tfortschritt|
    | BG3-BDE        | 100     | icon:product  |icon:ok   |icon:media_play_green   | icon:plus  |icon:plus    | Bearbeitung  | 0           |
    | BG3-BDE        | 100     | icon:product  |icon:ok   |icon:media_play_green   | icon:plus  |icon:plus    | Bearbeitung  | 0           |
And I press button "tbeenden" in row 1
Then the table has 1 rows
And I press button "tbeenden" in row 1
Then the table has 0 rows
And I close the current editor

# 04 Worklist mit Qualifikationsliste, aber auf Maschinengruppe setzen
Given I open the infosystem "WORKLIST"
And I set field "mitarb" to "KAEPSELE" 
Then field "qualliste" has value "ja"
And I set field "mgr" to "MGR1"
Then field "qualliste" has value "nein"
And I press start
Then the table has 1 rows
Then table has values
    | tartikel       | tofmge  | fbu           |truesten         |tproduktion |tbeenden |tkurzlauf    |ttextstatus   | tfortschritt|
    | BG3-BDE        | 0       | icon:product  |icon:ok          |icon:ok     | icon:ok | icon:ok     |abgeschlossen | 100         | 
And I close the current editor
# 05 Worklist auf anderen MA ohne Qualifikationsliste setzen
Given I open the infosystem "WORKLIST"
And I set field "mitarb" to "MACHNIX" 
Then field "qualliste" has value "nein"
And I set field "mgr" to "MGR1"
Then field "qualliste" has value "nein"
And I press start
Then the table has 1 rows
Then table has values
    | tartikel       | tofmge  | fbu           |truesten         |tproduktion|tbeenden |tkurzlauf    |ttextstatus   | tfortschritt|
    | BG3-BDE        | 0       | icon:product  |icon:ok          |icon:ok    | icon:ok |icon:ok      |abgeschlossen | 100         |
And I close the current editor 

# mit PDCTRANSFER die BDE-Objekte uebertragen, damit sich der BA stornieren laesst
Given I open the infosystem "PDCTRANSFER"
And I set field "aschein" to "BDE8_000" 
And I press start
Then the table has 3 rows
Then I press button "allean"
Then I press button "uebertragen"
And I press start
Then the table has 0 rows
And I close the current editor

###################################################
# 3.12 BA Stornieren
Given I'm logged in with password "sy"
Given I set the fake date to "12.01.1995" 
Given I open an editor "BA" from table "(Workorder):(WorkOrders)" with command "UPDATE" for record "BDE8_000"
#And I respond with answer "ja" to the dialog with id "345"
And I respond with answer "ja" to the dialog with id "1483"
And I set field "status" to "S"
And I save the current editor



##################################################
Scenario: 9 Maschinenstillstand melden / aufheben
# Debug: keine IDs
# 05 Worklist Maschinenstillstand melden / aufheben
Given I'm logged in with password "sfloor"
Given I set the fake date to "12.01.1995" 
Given I open the infosystem "WORKLIST"
And I set field "mitarb" to "SCHNEID"
And I set field "mgr" to "MGR1"
And I set field "sicherheit" to "nein"
Then field "maschstatus" has value "ok"
Then I press button "bumastill"
Then field "maschstatus" has value "S T I L L S T A N D"
Then the table has 0 rows
Then field "bdestatus" has value "icon:ball_green"
Then I press button "bustopmastill"
Then field "maschstatus" has value "ok"
Then field "bdestatus" has value "icon:ball_green"
And I close the current editor
##################################################

##################################################   
Scenario: 10 Mehrfaches Rüsten
# Debug:
#          Rückmeldenummern  RM1_BDE9   RM2_BDE9  RM3_BDE9
Given I'm logged in with password "sy"
Given I set the fake date to "12.01.1995" 
Given I open an editor "fvor_BDE9" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
And I append rows
    | artikel        | netmge     | bisuch    | mfreig    |
    | BG3-BDE        | 100        | BDE9_   | ja        |
And I press button "freig" to open a subeditor for "BA_freigeben"
And I close the current editor
And I switch the current editor to editor "fvor_BDE9"
And I save the current editor
##############################################
# 02 Dispo  starten
And I run Scheduling
#############################################
# 03 RM auf den ersten und zweiten AG, damit eine Nummer haben
Given I open an editor "RM1_BDE9" from table "(Workorder):(WorkOrders)" with command "DONE" for record "BDE9_001"
And I set fields
    | sofort    | ja         |
    | bem       | Nummer         | 
And I save the current editor 
Given I open an editor "RM2_BDE9" from table "(Workorder):(WorkOrders)" with command "DONE" for record "BDE9_002"
And I set fields
    | sofort    | ja         |
    | bem       | Nummer         | 
And I save the current editor 
Given I open an editor "RM3_BDE9" from table "(Workorder):(WorkOrders)" with command "DONE" for record "BDE9_003"
And I set fields
    | sofort    | ja         |
    | bem       | Nummer     | 
And I save the current editor 
# 04 Worklist mit auf Mehrfaches Rüsten setzen
Given I'm logged in with password "sfloor"
Given I set the fake date to "12.01.1995" 
Given I open the infosystem "WORKLIST"
And I set field "mehrruesten" to "ja"
And I set field "sicherheit" to "nein"
And I set field "mitarb" to "MACHNIX"
And I set field "mgr" to "MGR1"
And I press start
Then the table has 1 rows
Then table has values
    | tartikel       | tofmge  | fbu           |truesten         |tproduktion|tbeenden|tkurzlauf    |ttextstatus   | tfortschritt|
    | BG3-BDE        | 100     | icon:product  |icon:plus        |icon:plus  |        |icon:plus    |              | 0           |
And I press button "truesten" in row 1 
Then table has values
    | tartikel       | tofmge  | fbu           |truesten               |tproduktion|tbeenden |tkurzlauf    |ttextstatus   | tfortschritt|
    | BG3-BDE        | 100     | icon:product  |icon:media_play_green  |icon:plus  |icon:plus|icon:plus    |Rüsten        | 0           |
And I press button "tproduktion" in row 1
Then table has values
    | tartikel       | tofmge  | fbu           |truesten         |tproduktion             |tbeenden  |tkurzlauf    |ttextstatus   | tfortschritt|
    | BG3-BDE        | 100     | icon:product  |                 |icon:media_play_green   |icon:plus |icon:plus    |Bearbeitung   | 0           |
And I set field "mitarb" to "SCHNEID"
And I set field "mgr" to "MGR1"
And I press start
Then the table has 1 rows
Then table has values
    | tartikel       | tofmge  | fbu           |truesten         |tproduktion |tbeenden |tkurzlauf    |ttextstatus   | tfortschritt|
    | BG3-BDE        | 100     | icon:product  |icon:plus        |icon:plus   |         |icon:plus    |Bearbeitung   | 0           |
And I press button "truesten" in row 1 
Then table has values
    | tartikel       | tofmge  | fbu           |truesten              |tproduktion|tbeenden   |tkurzlauf    |ttextstatus   | tfortschritt|
    | BG3-BDE        | 100     | icon:product  |icon:media_play_green |icon:plus  | icon:plus |icon:plus    |Bearbeitung   | 0           |
And I press button "tunterbrechen" in row 1
Then table has values
    | tartikel       | tofmge  | fbu           |truesten  |tproduktion|tbeenden|tkurzlauf    |ttextstatus   | tfortschritt|
    | BG3-BDE        | 100     | icon:product  |icon:plus |icon:plus  |        |icon:plus    |Bearbeitung   | 0           |
And I set field "mitarb" to "MACHNIX"
And I set field "mgr" to "MGR1"
And I press start
Then table has values
    | tartikel       | tofmge  | fbu           |truesten         |tproduktion           | tbeenden   |tkurzlauf    |ttextstatus   | tfortschritt|
    | BG3-BDE        | 100     | icon:product  |                 |icon:media_play_green | icon:plus  |icon:plus    |Bearbeitung   | 0           |
And I press button "tkomplettrueck" in row 1    
And I close the current editor

###################################################
# BA Stornieren
Given I'm logged in with password "sy"
Given I set the fake date to "12.01.1995" 
Given I open an editor "BA" from table "(Workorder):(WorkOrders)" with command "UPDATE" for record "BDE9_000"
#And I respond with answer "ja" to the dialog with id "345"
And I respond with answer "ja" to the dialog with id "1483"
And I set field "status" to "S"
And I save the current editor

###########################################################################################################
## FDA-2408 Fertigungsstatus in Auftragszeit/Kurzläufer/Rückmeldung wird bei Storno aktualisiert

Scenario: 11 Fertigungsstatus in Auftragszeit wird bei Storno oder bei Rückbau aktualisiert

# als erstes es darf keine offenen BAs für den Artikel BG3-BDE geben
Given I'm logged in with password "sy"
Given I set the fake date to "07.01.1995" 
Given I query "artikel" from table "(Workorder):(WorkOrders)" where "artikel=BG3-BDE"
Then query has no hits

# Fertigungsvorschlag anlegen
Given I open an editor "fvor_BDE11" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
And I append rows
| artikel | netmge  | mfreig  | bisuch |
| BG3-BDE | 50    | ja    | BDE11_ |
And I press button "freig" to open a subeditor for "BA_freigeben"
And I close the current subeditor to switch back to the parent editor
And I close the current editor

# Auftragszeit mit Gutmenge buchen über Infosystem WORKLIST
Given I'm logged in with password "sfloor"
Given I set the fake date to "07.01.1995" 
Given I open the infosystem "WORKLIST"
And I set fields
  | mitarb  | MACHNIX |
  | mgr   | MGR1    |
And I press start
And I press button "tproduktion" in row 1
And I close the current editor

Given I open the infosystem "WORKLIST"
And I set fields
  | mitarb    | MACHNIX |
  | mgr     | MGR1    |
  | endegepl    | +30   |
  | sicherheit  | nein    |
And I press start
And I press button "tkomplettrueck" in row 1
And I close the current editor

# Offene Menge prüfen, Zeile 1 Material zu AS1 und Zeile 2 AG1
Given I'm logged in with password "sy"
Given I set the fake date to "07.01.1995" 
Given I open an editor "BA" from table "(Workorder):(WorkOrders)" with command "VIEW" for search criteria "$,,such=BDE11_000;@richtung=rückwärts;@maxordtreffer=1"
And I press button "absteig" to open a subeditor for "AFL11"
Then table has values
  | limge | frgmge |
  |  0  |  0   |
  |  0  |  0   |
And I close the current subeditor to switch back to the parent editor
And I close the current editor

# Fertigungsstatus im Arbeitsschein 1 prüfen
Given I open an editor "Arbeitsschein1" from table "(Workorder):(WorkOrders)" with command "VIEW" for search criteria "$,,such=BDE11_001;@richtung=rückwärts;@maxordtreffer=1"
Then field "fertstatus" has value "abgeschlossen"
And I close the current editor

# Rueckmeldung oeffnen, um Zugriff auf ID vom BDE-Objekt zu haben
Given I open an editor "Rueckmeldung1" from table "(Workorder):(CompletionConfirmations)" with command "VIEW" for search criteria "$,,such=BDE11_001;@richtung=rückwärts;@maxordtreffer=1;@ablageart=abgelegt"
And I close the current editor

# Rueckmeldung aus BDE-Objekt stornieren
Given I open an editor "STORNO_PDC" via ID from editor "Rueckmeldung1" from field "bdeobjekt" in row 0 for table "(PDC):(OrderTime)" with command "REVERSAL"
And I save the current editor

# Offene Menge prüfen, Zeile 1 Material zu AS1 und Zeile 2 AG1
Given I open an editor "BA" from table "(Workorder):(WorkOrders)" with command "VIEW" for search criteria "$,,such=BDE11_000;@richtung=rückwärts;@maxordtreffer=1"
And I press button "absteig" to open a subeditor for "AFL11"
Then table has values
  | limge | frgmge |
  | 50  | 50   |
  | 50  | 50   |
And I close the current subeditor to switch back to the parent editor
And I close the current editor

# im IS WORKLIST ist der Arbeitsschein wieder offen zur Bearbeitung
Given I'm logged in with password "sfloor"
Given I set the fake date to "07.01.1995" 
Given I open the infosystem "WORKLIST"
And I set fields
  | mitarb    | MACHNIX |
  | mgr     | MGR1    |
  | endegepl    | +30   |
  | sicherheit  | nein    |
And I press start
Then table has values
    | tartikel  | tofmge  | fbu           | truesten  | tproduktion | tbeenden | tkurzlauf    | ttextstatus   | tfortschritt|
    | BG3-BDE | 50      | icon:product  | icon:ok   | icon:plus     |          | icon:plus    | Bearbeitung   |  0          |
And I close the current editor

# Fertigungsstatus im Arbeitsschein 1 prüfen, wurde aktualisiert durch Erneutes Laden in WORKLIST
Given I'm logged in with password "sy"
Given I set the fake date to "07.01.1995" 
Given I open an editor "Arbeitsschein1" from table "(Workorder):(WorkOrders)" with command "VIEW" for search criteria "$,,such=BDE11_001;@richtung=rückwärts;@maxordtreffer=1"
Then field "fertstatus" has value "Bearbeitung"
And I close the current editor

# erneute Rückmeldung auf Arbeitsschein 1 buchen über Infosystem WORKLIST
Given I'm logged in with password "sfloor"
Given I set the fake date to "07.01.1995" 
Given I open the infosystem "WORKLIST"
And I set fields
  | mitarb  | MACHNIX |
  | mgr   | MGR1    |
And I press start
And I press button "tproduktion" in row 1
And I close the current editor

Given I open the infosystem "WORKLIST"
And I set fields
  | mitarb    | MACHNIX |
  | mgr     | MGR1    |
  | endegepl    | +30   |
  | sicherheit  | nein    |
And I press start
And I press button "tkomplettrueck" in row 1
And I close the current editor

# Fertigungsstatus im Arbeitsschein 1 prüfen
Given I'm logged in with password "sy"
Given I set the fake date to "07.01.1995" 
Given I open an editor "Arbeitsschein1" from table "(Workorder):(WorkOrders)" with command "VIEW" for search criteria "$,,such=BDE11_001;@richtung=rückwärts;@maxordtreffer=1"
Then field "fertstatus" has value "abgeschlossen"
And I close the current editor

## Rueckbau ueber BDE, Auftragszeit NEU mit negativer Gutmenge, antatt Rueckbau in der Fertigung, dann wird Fortschritt korrekt angezeigt in WORKLIST
Given I open an editor "Auftragszeit" from table "(PDC):(OrderTime)" with command "NEW" for record ""
And I set field "ma" to "MACHNIX"
And I set field "asma" to "nummer" from editor "Arbeitsschein1"
And I set fields
  | anfdat  | .     |
  | anfzeit | 15:00   |
  | enddat  | .     |
  | endzeit | 16:00   |
  | istmge  | -10   |
  | sofort  | ja    |
And I save the current editor

## Rueckbau ueber Fertigung, anstatt ueber BDE, funktioniert auch, nur wird der Fortschritt in der WORKLIST nicht aktualisiert
#Given I open an editor "Rueckbau_AS1" from table "(Workorder):(WorkOrders)" with command "RETURN" for search criteria "$,,such=BDE11_001;@richtung=rückwärts;@maxordtreffer=1"
#And I set fields
#  | mzeit   | 1      |
#  | bzeit   | 1      |
#  | sofort  | ja     |
#And I set field "gutmge" to "-10" in row 1
#And I save the current editor


# im IS WORKLIST ist der Arbeitsschein wieder offen zur Bearbeitung
Given I'm logged in with password "sfloor"
Given I set the fake date to "07.01.1995" 
Given I open the infosystem "WORKLIST"
And I set fields
  | mitarb    | MACHNIX |
  | mgr     | MGR1    |
  | endegepl    | +30   |
  | sicherheit  | nein    |
And I press start
Then table has values
    | tartikel  | tofmge  | fbu           | truesten  | tproduktion | tbeenden | tkurzlauf    | ttextstatus   | tfortschritt|
    | BG3-BDE   | 10      | icon:product  | icon:ok   | icon:plus   |          | icon:plus    | Bearbeitung   |  80         |
And I close the current editor

# Fertigungsstatus im Arbeitsschein 1 prüfen
Given I open an editor "Arbeitsschein1" from table "(Workorder):(WorkOrders)" with command "VIEW" for search criteria "$,,such=BDE11_001;@richtung=rückwärts;@maxordtreffer=1"
Then field "fertstatus" has value "Bearbeitung"
And I close the current editor

# BA Stornieren
Given I open an editor "BA" from table "(Workorder):(WorkOrders)" with command "UPDATE" for record "BDE11_000"
And I respond with answer "ja" to the dialog with id "1483"
And I set field "status" to "S"
And I save the current editor

##################################################################################################
Scenario: 12 Fertigungsstatus in Kurzläufer wird bei Storno aktualisiert

## als erstes es darf keine offenen BAs für den Artikel BG3-BDE geben
Given I'm logged in with password "sy"
Given I set the fake date to "12.01.1995" 
Given I query "artikel" from table "(Workorder):(WorkOrders)" where "artikel=BG3-BDE"
Then query has no hits

# Fertigungsvorschlag anlegen
Given I open an editor "fvor_BDE12" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
And I append rows
| artikel | netmge  | mfreig  | bisuch  |
| BG3-BDE | 50    | ja    | BDE12_  |
And I press button "freig" to open a subeditor for "BA_freigeben"
And I close the current subeditor to switch back to the parent editor
And I close the current editor

# Kurzläufer mit kompletter Gutmenge buchen über Infosystem WORKLIST
Given I'm logged in with password "sfloor"
Given I set the fake date to "12.01.1995" 
Given I open the infosystem "WORKLIST"
And I set fields
    | mitarb        | MACHNIX |
    | mgr           | MGR1    |
    | ueberbuchen   | nein    |
And I press start
And I press button "tkurzlauf" in row 1
And I set field "istzeit" to "2"
And I set field "istmge" to "50"
And I press button "fertig"
And I close the current editor

# Offene Menge prüfen, Zeile 1 Material zu AS1 und Zeile 2 AG1
Given I'm logged in with password "sy"
Given I set the fake date to "12.01.1995"
Given I open an editor "BA" from table "(Workorder):(WorkOrders)" with command "VIEW" for search criteria "$,,such=BDE12_000;@richtung=rückwärts;@maxordtreffer=1"
And I press button "absteig" to open a subeditor for "AFL12"
Then table has values
  | limge | frgmge |
  |  0  |  0   |
  |  0  |  0   |
And I close the current subeditor to switch back to the parent editor
And I close the current editor

# Fertigungsstatus im Arbeitsschein 1 prüfen
Given I open an editor "Arbeitsschein1" from table "(Workorder):(WorkOrders)" with command "VIEW" for search criteria "$,,such=BDE12_001;@richtung=rückwärts;@maxordtreffer=1"
Then field "fertstatus" has value "abgeschlossen"
And I close the current editor

# Rueckmeldung oeffnen, um Zugriff auf ID vom BDE-Objekt zu haben
Given I open an editor "Rueckmeldung1" from table "(Workorder):(CompletionConfirmations)" with command "VIEW" for search criteria "$,,such=BDE12_001;@richtung=rückwärts;@maxordtreffer=1;@ablageart=abgelegt"
And I close the current editor

# Rueckmeldung aus BDE-Objekt stornieren
Given I open an editor "STORNO_PDC" via ID from editor "Rueckmeldung1" from field "bdeobjekt" in row 0 for table "(PDC):(ShortProductionOrder)" with command "REVERSAL"
And I save the current editor

# Offene Menge prüfen, Zeile 1 Material zu AS1 und Zeile 2 AG1
Given I open an editor "BA" from table "(Workorder):(WorkOrders)" with command "VIEW" for search criteria "$,,such=BDE12_000;@richtung=rückwärts;@maxordtreffer=1"
And I press button "absteig" to open a subeditor for "AFL12"
Then table has values
  | limge | frgmge |
  | 50  | 50   |
  | 50  | 50   |
And I close the current subeditor to switch back to the parent editor
And I close the current editor

# im IS WORKLIST ist der Arbeitsschein wieder offen zur Bearbeitung
Given I'm logged in with password "sfloor"
Given I set the fake date to "12.01.1995"
Given I open the infosystem "WORKLIST"
And I set fields
  | mitarb    | MACHNIX |
  | mgr     | MGR1    |
  | endegepl    | +30   |
  | sicherheit  | nein    |
And I press start
Then table has values
    | tartikel  | tofmge  | fbu           | truesten  | tproduktion | tbeenden   | tkurzlauf    | ttextstatus   | tfortschritt|
    | BG3-BDE   | 50      | icon:product  | icon:ok   | icon:plus   |            | icon:plus    | Bearbeitung   |  0          |
And I close the current editor

# Fertigungsstatus im Arbeitsschein 1 prüfen, wurde aktualisiert durch Erneutes Laden in WORKLIST
Given I'm logged in with password "sy"
Given I set the fake date to "12.01.1995"
Given I open an editor "Arbeitsschein1" from table "(Workorder):(WorkOrders)" with command "VIEW" for search criteria "$,,such=BDE12_001;@richtung=rückwärts;@maxordtreffer=1"
Then field "fertstatus" has value "Bearbeitung"
And I close the current editor

# BA Stornieren
Given I open an editor "BA" from table "(Workorder):(WorkOrders)" with command "UPDATE" for record "BDE12_000"
And I respond with answer "ja" to the dialog with id "345"
And I set field "status" to "S"
And I save the current editor

#################################################################################################################
Scenario: 13 Fertigungsstatus in Auftragszeit wird bei Storno aktualisiert, Rückmeldung und Storno auf 2 Arbeitsscheine

# als erstes es darf keine offenen BAs für den Artikel BG3-BDE geben
Given I'm logged in with password "sy"
Given I set the fake date to "12.01.1995" 
Given I query "artikel" from table "(Workorder):(WorkOrders)" where "artikel=BG3-BDE"
Then query has no hits

# Fertigungsvorschlag anlegen
Given I open an editor "fvor_BDE13" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
And I append rows
| artikel | netmge  | mfreig  | bisuch  | binoloe |
| BG3-BDE | 50    | ja    | BDE13_  | ja    |
And I press button "freig" to open a subeditor for "BA_freigeben"
And I close the current subeditor to switch back to the parent editor
And I close the current editor

# Auftragszeit mit Gutmenge buchen über Infosystem WORKLIST, 2 Teilrückmeldungen
# Bearbeitung beginnen AS1
Given I'm logged in with password "sfloor"
Given I set the fake date to "12.01.1995" 
Given I open the infosystem "WORKLIST"
And I set fields
  | mitarb  | SCHNEID |
  | mgr   | MGR1    |
And I press start
And I press button "tproduktion" in row 1
And I close the current editor

# Teilrückmeldung 20 Stück AS1
Given I open the infosystem "WORKLIST"
And I set fields
  | mitarb    | SCHNEID |
  | mgr     | MGR1    |
  | sicherheit  | nein    |
And I press start
And I press button "trueckmeld" in row 1
And I set field "istmge" to "20"
And I press button "fertig"
And I close the current editor

# Bearbeitung beginnen AS2
Given I open the infosystem "WORKLIST"
And I set fields
  | mitarb  | SCHNEID |
  | mgr   | MGR2    |
And I press start
And I press button "tproduktion" in row 1
And I close the current editor

# Teilrückmeldung 20 Stück AS2
Given I open the infosystem "WORKLIST"
And I set fields
  | mitarb    | SCHNEID |
  | mgr     | MGR2    |
  | sicherheit  | nein    |
And I press start
And I press button "trueckmeld" in row 1
And I set field "istmge" to "20"
And I press button "fertig"
And I close the current editor

# Offene Menge prüfen
Given I'm logged in with password "sy"
Given I set the fake date to "12.01.1995"
Given I open an editor "BA" from table "(Workorder):(WorkOrders)" with command "VIEW" for search criteria "$,,such=BDE13_000;@richtung=rückwärts;@maxordtreffer=1"
And I press button "absteig" to open a subeditor for "AFL13"
Then table has values
  | limge | frgmge |
  | 30  | 30   |
  | 30  | 30   |
  | 30  | 30   |
  | 30  | 30   |
And I close the current subeditor to switch back to the parent editor
And I close the current editor

# Fertigungsstatus im Arbeitsschein 1 prüfen
Given I open an editor "Arbeitsschein1" from table "(Workorder):(WorkOrders)" with command "VIEW" for search criteria "$,,such=BDE13_001;@richtung=rückwärts;@maxordtreffer=1"
Then field "fertstatus" has value "Bearbeitung"
And I close the current editor

# Fertigungsstatus im Arbeitsschein 2 prüfen
Given I open an editor "Arbeitsschein1" from table "(Workorder):(WorkOrders)" with command "VIEW" for search criteria "$,,such=BDE13_002;@richtung=rückwärts;@maxordtreffer=1"
Then field "fertstatus" has value "Bearbeitung"
And I close the current editor

# Bearbeitung beginnen AS1
Given I'm logged in with password "sfloor"
Given I set the fake date to "12.01.1995"
Given I open the infosystem "WORKLIST"
And I set fields
  | mitarb  | SCHNEID |
  | mgr   | MGR1    |
And I press start
And I press button "tproduktion" in row 1
And I close the current editor

# Rückmeldung Restmenge 30 Stück AS1
Given I open the infosystem "WORKLIST"
And I set fields
  | mitarb    | SCHNEID |
  | mgr     | MGR1    |
  | endegepl    | +30   |
  | sicherheit  | nein    |
And I press start
#And I press button "trueckmeld" in row 1
#And I set field "istmge" to "30"
#And I press button "fertig"
And I press button "tkomplettrueck" in row 1
And I close the current editor

# Bearbeitung beginnen AS2
Given I open the infosystem "WORKLIST"
And I set fields
  | mitarb  | SCHNEID |
  | mgr   | MGR2    |
And I press start
And I press button "tproduktion" in row 1
And I close the current editor

# Rückmeldung Restmenge 30 Stück AS2
Given I open the infosystem "WORKLIST"
And I set fields
  | mitarb    | SCHNEID |
  | mgr     | MGR2    |
  | endegepl    | +30   |
  | sicherheit  | nein    |
And I press start
#And I press button "trueckmeld" in row 1
#And I set field "istmge" to "30"
#And I press button "fertig"
And I press button "tkomplettrueck" in row 1
And I press button "fertig"
And I close the current editor

# Fertigungsstatus im Arbeitsschein 1 prüfen
Given I'm logged in with password "sy"
Given I set the fake date to "12.01.1995"
Given I open an editor "Arbeitsschein1" from table "(Workorder):(WorkOrders)" with command "VIEW" for search criteria "$,,such=BDE13_001;@richtung=rückwärts;@maxordtreffer=1"
Then field "fertstatus" has value "abgeschlossen"
And I close the current editor

# Fertigungsstatus im Arbeitsschein 2 prüfen
Given I open an editor "Arbeitsschein1" from table "(Workorder):(WorkOrders)" with command "VIEW" for search criteria "$,,such=BDE13_002;@richtung=rückwärts;@maxordtreffer=1"
Then field "fertstatus" has value "abgeschlossen"
And I close the current editor

# Offene Menge prüfen
Given I open an editor "BA" from table "(Workorder):(WorkOrders)" with command "VIEW" for search criteria "$,,such=BDE13_000;@richtung=rückwärts;@maxordtreffer=1"
And I press button "absteig" to open a subeditor for "AFL13"
Then table has values
  | limge | frgmge |
  |  0  |  0   |
  |  0  |  0   |
  |  0  |  0   |
  |  0  |  0   |
And I close the current subeditor to switch back to the parent editor
And I close the current editor

# Rueckmeldung oeffnen, um Zugriff auf ID vom BDE-Objekt zu haben
Given I open an editor "Rueckmeldung2" from table "(Workorder):(CompletionConfirmations)" with command "VIEW" for search criteria "$,,such=BDE13_002;gutmge=30;@richtung=rückwärts;@maxordtreffer=1;@ablageart=abgelegt"
And I close the current editor

# zweite Rueckmeldung AS2 30 Stück BDE-Objekt stornieren
Given I open an editor "STORNO_PDC" via ID from editor "Rueckmeldung2" from field "bdeobjekt" in row 0 for table "(PDC):(OrderTime)" with command "REVERSAL"
And I save the current editor

# Rueckmeldung oeffnen, um Zugriff auf ID vom BDE-Objekt zu haben
Given I open an editor "Rueckmeldung1" from table "(Workorder):(CompletionConfirmations)" with command "VIEW" for search criteria "$,,such=BDE13_001;gutmge=20;@richtung=rückwärts;@maxordtreffer=1;@ablageart=abgelegt"
And I close the current editor

# erste Rueckmeldung AS1 20 Stück BDE-Objekt stornieren
Given I open an editor "STORNO_PDC" via ID from editor "Rueckmeldung1" from field "bdeobjekt" in row 0 for table "(PDC):(OrderTime)" with command "REVERSAL"
And I save the current editor

# Offene Menge prüfen, Zeile 1 Material zu AS1 und Zeile 2 AG1
Given I open an editor "BA" from table "(Workorder):(WorkOrders)" with command "VIEW" for search criteria "$,,such=BDE13_000;@richtung=rückwärts;@maxordtreffer=1"
And I press button "absteig" to open a subeditor for "AFL13"
Then table has values
  | limge | frgmge |
  | 20  | 20   |
  | 20  | 20   |
  | 30  | 30   |
  | 30  | 30   |
And I close the current subeditor to switch back to the parent editor
And I close the current editor

# im IS WORKLIST ist der Arbeitsschein wieder offen zur Bearbeitung
Given I open the infosystem "WORKLIST"
And I set fields
  | mitarb    | SCHNEID |
  | mgr     | MGR1    |
  | endegepl    | +30   |
  | sicherheit  | nein    |
And I press start
Then table has values
    | tartikel  | tofmge  | fbu           | truesten  | tproduktion |tbeenden | tkurzlauf    | ttextstatus   | tfortschritt|
    | BG3-BDE   | 20      | icon:product  | icon:ok   | icon:plus   |         | icon:plus    | Bearbeitung   |  60         |
And I close the current editor

# im IS WORKLIST ist der Arbeitsschein wieder offen zur Bearbeitung
Given I open the infosystem "WORKLIST"
And I set fields
  | mitarb    | SCHNEID |
  | mgr     | MGR2    |
  | endegepl    | +30   |
  | sicherheit  | nein    |
And I press start
Then table has values
    | tartikel  | tofmge  | fbu           | truesten  | tproduktion | tbeenden | tkurzlauf    | ttextstatus   | tfortschritt|
    | BG3-BDE   | 30      | icon:product  | icon:ok   | icon:plus   |          | icon:plus    | Bearbeitung   |  40         |
And I close the current editor

# Fertigungsstatus im Arbeitsschein 1 prüfen, wurde aktualisiert durch Erneutes Laden in WORKLIST
Given I open an editor "Arbeitsschein1" from table "(Workorder):(WorkOrders)" with command "VIEW" for search criteria "$,,such=BDE13_001;@richtung=rückwärts;@maxordtreffer=1"
Then field "fertstatus" has value "Bearbeitung"
And I close the current editor

# Fertigungsstatus im Arbeitsschein 2 prüfen, wurde aktualisiert durch Erneutes Laden in WORKLIST
Given I open an editor "Arbeitsschein1" from table "(Workorder):(WorkOrders)" with command "VIEW" for search criteria "$,,such=BDE13_002;@richtung=rückwärts;@maxordtreffer=1"
Then field "fertstatus" has value "Bearbeitung"
And I close the current editor

# Löschschutz entfernen und BA Stornieren
Given I open an editor "Betriebsauftrag" from table "(Workorder):(WorkOrders)" with command "UPDATE" for record "BDE13_000"
And I set field "noloesch" to "nein"
#And I respond with answer "ja" to the dialog with id "345"
And I respond with answer "ja" to the dialog with id "1483"
And I set field "status" to "S"
And I save the current editor


################################################################################################################
Scenario: 14 Behaelter - Auftragszeit mit Behaelterangabe buchen, Gutmenge in Behaelter

Given I create a Container "BDE01" for packaging material "BEHAELTER"

# Fertigungsvorschlag anlegen
Given I open an editor "FV_BDE01" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
And I append rows
    | artikel   | netmge    | mfreig    | bisuch    |
    | BAUT      | 100       | ja        | BDE01_    |
And I press button "freig" to open a subeditor for "BA_freigeben"
And I close the current subeditor to switch back to the parent editor
And I close the current editor

# Auftragszeit mit Gutmenge und Behaelterangabe buchen
#Given I'm logged in with password "sfloor"
Given I set the fake date to "15.01.1995"
Given I open the infosystem "WORKLIST"
And I set fields
    | mitarb  | SCHNEID   |
    | mgr     | 122       |
And I press start
And I press button "tproduktion" in row 1
And I close the current editor

# Teilrueckmeldung auf Arbeitsschein 2 bucht Gutmenge an Lager
Given I open the infosystem "WORKLIST"
And I set fields
    | mitarb        | SCHNEID   |
    | mgr           | 122       |
    | sicherheit    | nein      |
And I press start
Then field "taschein^such" has value "BDE01_002" in row 1
And I press button "trueckmeld" in row 1
And I set field "istmge" to "20"
And I set field "behaelter" to "BDE01"
And I press button "fertig"
And I close the current editor

# Behaelter in Rueckmeldung pruefen
Given I open an editor "RMPruef" from table "(Workorder):(CompletionConfirmations)" with command "VIEW" for search criteria "$,,such=BDE01_002;@ablage=abgelegt;@richtung=rückwärts;@maxordtreffer=1"
Then field "behaelter^id" has value "!BDE01^id"
And I close the current editor

Given I open an editor "BDE01" from table "(Container):(ContainerShell)" with command "VIEW" for record "BDE01"
Then fields have values
    | behstatusaz   |       |
    | platz         | F1    |
    | behleer       | nein  |
Then table has values
    | artikel   | mge |
    | BAUT      | 20  |
And I close the current editor

###############################################################################################################
Scenario: 15 Behaelter - mit Behaelterangabe buchen, Gutmenge in Behaelter

Given I create a Container "BDE01K" for packaging material "BEHAELTER"

# Arbeitsschein aus Scenario BDEO1 nehmen, Kurzlauefer buchen mit Behaelterangabe
#Given I'm logged in with password "sfloor"
Given I set the fake date to "15.01.1995"
Given I open the infosystem "WORKLIST"
And I set fields
    | mitarb        | SCHNEID   |
    | mgr           | 122       |
And I press start
And I press button "tkurzlauf" in row 1
And I set field "istzeit" to "2"
And I set field "istmge" to "5"
And I set field "behaelter" to "BDE01K"
And I press button "fertig"
And I close the current editor

# Behaelter in Rueckmeldung pruefen
Given I open an editor "RMPruef" from table "(Workorder):(CompletionConfirmations)" with command "VIEW" for search criteria "$,,such=BDE01_002;gutmge==5;@ablage=abgelegt;@richtung=rückwärts;@maxordtreffer=1"
Then field "behaelter^id" has value "!BDE01K^id"
And I close the current editor

Given I open an editor "BDE01K" from table "(Container):(ContainerShell)" with command "VIEW" for record "BDE01K"
Then fields have values
    | behstatusaz   |       |
    | platz         | F1    |
    | behleer       | nein  |
Then table has values
    | artikel   | mge |
    | BAUT      | 5   |
And I close the current editor

#################################################################################################
Scenario: 16 Behaelter - Plausis - Behaelterstatus leer, abgelegter Behaelter wird nicht bebucht

Given I create a Container "BDE02SPERR" for packaging material "BEHAELTER"
Given I create a Container "BDE02LPF2" for packaging material "BEHAELTER"
Given I create a Container "BDE02LPF1" for packaging material "BEHAELTER"
Given I create a Container "BDE02ABLAGE" for packaging material "BEHAELTER"
Given I create a Container "BDE02LIEFER" for packaging material "BEHAELTER"

And I post a receipt via ManualStockAdjustment for Product "BG1" and quantity "10" on StorageLocation "F1" with document "LBU1BDE02" and Container "!BDE02LPF1"
And I post a receipt via ManualStockAdjustment for Product "BG1" and quantity "12" on StorageLocation "F2" with document "LBU2BDE02" and Container "!BDE02LPF2"
And I post a receipt via ManualStockAdjustment for Product "BG1" and quantity "5" on StorageLocation "F2" with document "LBU3BDE02" and Container "!BDE02LIEFER"

# Behaelter sperren
Given I open an editor "BDE02SPERR" from table "(Container):(ContainerShell)" with command "UPDATE" for record "BDE02SPERR"
And I set field "behstatusaz" to "Gesperrt"
And I save the current editor

# Behaelter ablegen
Given I open an editor "BDE02ABLAGE" from table "(Container):(ContainerShell)" with command "UPDATE" for record "BDE02ABLAGE"
And I set field "ablagef" to "ja"
And I save the current editor

# Behaelter liefern
Given I create a SalesOrder "AUF1" for Customer "TEST" with Product "BG1" and quantity "5"

Given I open an editor "AUF1" from table "(Sales):(SalesOrder)" with command "DELIVERY" for record "AUF1"
And I set fields
    | such   | VKLS_16  |
    | vom    | .        |
    | ueb    | ja       |
And I modify table
    | !row  | platz  | mge  | behaelter     |
    | 1     | F2     | 5    | !BDE02LIEFER  |
And I save the current editor

Given I open an editor "BDE02LIEFER" from table "(Container):(ContainerShell)" with command "VIEW" for record "BDE02LIEFER"
Then fields have values
    | behstatusaz   | Geliefert      |
And I close the current editor

# Arbeitsschein aus Scenario BDE01 verwenden, Behaelter mit Status "Gesperrt" oder Status "Geliefert" wird abgelehnt
Given I set the fake date to "15.01.1995"
Given I open the infosystem "WORKLIST"
And I set fields
  | mitarb  | SCHNEID   |
  | mgr     | 122       |
And I press start
And I press button "tproduktion" in row 1
And I close the current editor

Given I set the fake date to "15.01.1995"
Given I open the infosystem "WORKLIST"
And I set fields
    | mitarb        | SCHNEID   |
    | mgr           | 122       |
    | sicherheit    | nein      |
And I press start
Then field "taschein^such" has value "BDE01_002" in row 1
And I press button "trueckmeld" in row 1
And I set field "istmge" to "8"
And I set field "behaelter" to "!BDE02LIEFER^id"
Then field "behaelter" is empty
# Fehlermeldung wird im Feld bdetext angegeben
Then field "bdetext" has value "Der Behälterstatus muss leer sein."
And I set field "behaelter" to "!BDE02SPERR^id"
Then field "behaelter" is empty
# Fehlermeldung wird im Feld bdetext angegeben
Then field "bdetext" has value "Der Behälterstatus muss leer sein."
# abgelegter Behaelter kann eingetragen werden, aber nicht gebucht
And I set field "behaelter" to "!BDE02ABLAGE^id"
And I press button "fertig"
# Fehlermeldung kann nicht abgefragt werden, ACK anstatt NAK
# Buchung nicht erfolgreich! rmtmp/KURZL.1011002.ERR beachten.
# es wurde keine Buchung durchgefuehrt
And I close the current editor

# Behaelter pruefen, war bereits gefuellt und liegt auf Platz F1, BAUT wurde nicht in den Behaelter gebucht
Given I open an editor "BDE02LPF1" from table "(Container):(ContainerShell)" with command "VIEW" for record "BDE02LPF1"
Then fields have values
    | behstatusaz   |       |
    | platz         | F1    |
    | behleer       | nein  |
Then the table has 1 rows
Then table has values
    | artikel   | mge |
    | BG1       | 10  |
And I close the current editor

# gleiche Plausis auch bei Kurzlaeufer pruefen
Given I set the fake date to "15.01.1995"
Given I open the infosystem "WORKLIST"
And I set fields
    | mitarb        | SCHNEID   |
    | mgr           | 122       |
And I press start
And I press button "tkurzlauf" in row 1
And I set field "istzeit" to "2"
And I set field "istmge" to "8"
And I set field "behaelter" to "!BDE02LIEFER^id"
Then field "behaelter" is empty
# Fehlermeldung wird im Feld bdetext angegeben
Then field "bdetext" has value "Der Behälterstatus muss leer sein."
And I set field "behaelter" to "!BDE02SPERR^id"
Then field "behaelter" is empty
# Fehlermeldung wird im Feld bdetext angegeben
Then field "bdetext" has value "Der Behälterstatus muss leer sein."
# abgelegter Behaelter kann eingetragen werden, aber nicht gebucht
And I set field "behaelter" to "!BDE02ABLAGE^id"
And I press button "fertig"
# Fehlermeldung kann nicht abgefragt werden, ACK anstatt NAK
# Buchung nicht erfolgreich! rmtmp/KURZL.1011002.ERR beachten.
# es wurde keine Buchung durchgefuehrt
And I close the current editor

# Behaelter pruefen, war bereits gefuellt und liegt auf Platz F1, BAUT wurde nicht in den Behaelter gebucht
Given I open an editor "BDE02LPF1" from table "(Container):(ContainerShell)" with command "VIEW" for record "BDE02LPF1"
Then fields have values
    | behstatusaz   |       |
    | platz         | F1    |
    | behleer       | nein  |
Then the table has 1 rows
Then table has values
    | artikel   | mge |
    | BG1       | 10  |
And I close the current editor

#######################################################################################################
Scenario: 17 Behaelter - Auftragszeit buchen, gefuellter Behaelter mit abweichendem Platz ist moeglich

# BA-Nummer zwischenspeichern
Given I open an editor "BA" from table "(Workorder):(WorkOrders)" with command "VIEW" for search criteria "$,,such=BDE01_000;@richtung=rückwärts;@maxordtreffer=1"
And I save value from field "nummer" in row 0
And I close the current editor

# Platz im Fertigungsvorschlag ist F1
Given I open an editor "FV" from table "(Purchasing):(WorkOrderSuggestions)" with command "VIEW" for record ""
And I set field "artikel" to "BAUT"
And I set field "banummer" in row 0 to saved value
And I press button "ladetab"
Then the table has 1 rows
Then field "platz" has value "F1" in row 1
And I close the current editor

# Arbeitsschein aus Scenario BDE01 verwenden, gefuellter Behaelter mit abweichendem Platz ist moeglich
Given I set the fake date to "15.01.1995"
Given I open the infosystem "WORKLIST"
And I set fields
  | mitarb  | SCHNEID   |
  | mgr     | 122       |
And I press start
And I press button "tproduktion" in row 1
And I close the current editor

Given I set the fake date to "15.01.1995"
Given I open the infosystem "WORKLIST"
And I set fields
    | mitarb        | SCHNEID   |
    | mgr           | 122       |
    | sicherheit    | nein      |
And I press start
Then field "taschein^such" has value "BDE01_002" in row 1
And I press button "trueckmeld" in row 1
And I set field "istmge" to "7"
And I set field "behaelter" to "BDE02LPF2"
And I press button "fertig"
And I close the current editor

# Rueckmeldung wurde gebucht und Lagerplatz geaendert
Given I open an editor "RM_F2" from table "(Workorder):(CompletionConfirmations)" with command "VIEW" for search criteria "$,,such=BDE01_002;gutmge==7;@ablage=abgelegt;@richtung=rückwärts;@maxordtreffer=1"
Then field "behaelter^id" has value "!BDE02LPF2^id"
Then field "buplatz" has value "F2" in row 1
And I close the current editor

# Behaelter pruefen, war bereits gefuellt und liegt auf Platz F2
Given I open an editor "BDE02LPF2" from table "(Container):(ContainerShell)" with command "VIEW" for record "BDE02LPF2"
Then fields have values
    | behstatusaz   |       |
    | platz         | F2    |
    | behleer       | nein  |
Then table has values
    | artikel   | mge |
    | BG1       | 12  |
    | BAUT      | 7   |
And I close the current editor

######################################################################################################
Scenario: 18 Behaelter - Kurzlaeufer buchen, gefuellter Behaelter mit abweichendem Platz ist moeglich

# BA-Nummer zwischenspeichern
Given I open an editor "BA" from table "(Workorder):(WorkOrders)" with command "VIEW" for search criteria "$,,such=BDE01_000;@richtung=rückwärts;@maxordtreffer=1"
And I save value from field "nummer" in row 0
And I close the current editor

# Platz im Fertigungsvorschlag ist F1
Given I open an editor "FV" from table "(Purchasing):(WorkOrderSuggestions)" with command "VIEW" for record ""
And I set field "artikel" to "BAUT"
And I set field "banummer" in row 0 to saved value
And I press button "ladetab"
Then the table has 1 rows
Then field "platz" has value "F1" in row 1
And I close the current editor

# Arbeitsschein aus Scenario BDE01 verwenden, gefuellter Behaelter mit abweichendem Platz ist moeglich
Given I set the fake date to "17.01.1995"
Given I open the infosystem "WORKLIST"
And I set fields
    | mitarb        | SCHNEID   |
    | mgr           | 122       |
And I press start
Then field "taschein^such" has value "BDE01_002" in row 1
And I press button "tkurzlauf" in row 1
And I set field "istzeit" to "2"
And I set field "istmge" to "1"
And I set field "behaelter" to "!BDE02LPF2"
And I press button "fertig"
And I close the current editor

# Rueckmeldung wurde gebucht und Lagerplatz geaendert
Given I open an editor "RM1_F2" from table "(Workorder):(CompletionConfirmations)" with command "VIEW" for search criteria "$,,such=BDE01_002;gutmge==1;@ablage=abgelegt;@richtung=rückwärts;@maxordtreffer=1"
Then field "behaelter^id" has value "!BDE02LPF2^id"
Then field "buplatz" has value "F2" in row 1
And I close the current editor

# Behaelter pruefen, war bereits gefuellt und liegt auf Platz F2, Menge 8 weil schon vorher 7 Stk BAUT drin war
Given I open an editor "BDE02LPF2" from table "(Container):(ContainerShell)" with command "VIEW" for record "BDE02LPF2"
Then fields have values
    | behstatusaz   |       |
    | platz         | F2    |
    | behleer       | nein  |
Then table has values
    | artikel   | mge |
    | BG1       | 12  |
    | BAUT      | 8   |
And I close the current editor

#######################################################################################################################
Scenario: 19 Behaelter - Kurzlaeufer und Auftragszeit Behaelter mit Platz aus abweichender Lagergruppe nicht zulaessig

Given I create a Container "BDE19EXTERN" for packaging material "BEHAELTER"

And I post a receipt via ManualStockAdjustment for Product "BG1" and quantity "10" on StorageLocation "L3F1" with document "LBU1BDE18" and Container "!BDE19EXTERN"

# BA-Nummer zwischenspeichern
Given I open an editor "BA" from table "(Workorder):(WorkOrders)" with command "VIEW" for search criteria "$,,such=BDE01_000;@richtung=rückwärts;@maxordtreffer=1"
And I save value from field "nummer" in row 0
And I close the current editor

# Platz im Fertigungsvorschlag ist F1
Given I open an editor "FV" from table "(Purchasing):(WorkOrderSuggestions)" with command "VIEW" for record ""
And I set field "artikel" to "BAUT"
And I set field "banummer" in row 0 to saved value
And I press button "ladetab"
Then the table has 1 rows
Then field "platz" has value "F1" in row 1
And I close the current editor

# Kurzlaeufer, Arbeitsschein aus Scenario BDE01 verwenden, gefuellter Behaelter mit Platz aus abweichender Lagergruppe ist NICHT moeglich
Given I set the fake date to "17.01.1995"
Given I open the infosystem "WORKLIST"
And I set fields
    | mitarb        | SCHNEID   |
    | mgr           | 122       |
And I press start
Then field "taschein^such" has value "BDE01_002" in row 1
And I press button "tkurzlauf" in row 1
And I set field "istzeit" to "2"
And I set field "istmge" to "2"
And I set field "behaelter" to "!BDE19EXTERN^id"
# Behaelter, der auf einem Lagerplatz mit abweichender Lagergruppe liegt, kann nicht eingetragen werden, Feld wird geleert
Then field "behaelter" is empty
Then field "bdetext" has value "Der Behälter muss auf einem Lagerplatz der Lagergruppe KARLSRUHE stehen."
And I press button "fertig"
And I close the current editor

# Rueckmeldung wurde gebucht, aber ohne Behaelter
Given I open an editor "RMPruef" from table "(Workorder):(CompletionConfirmations)" with command "VIEW" for search criteria "$,,such=BDE01_002;gutmge==2;@ablage=abgelegt;@richtung=rückwärts;@maxordtreffer=1"
Then field "behaelter" is empty
And I close the current editor

# Behaelter pruefen, war bereits gefuellt und liegt auf Platz L3F1; BG1 wurde NICHT in den Behaelter gebucht
Given I open an editor "BDE19EXTERN" from table "(Container):(ContainerShell)" with command "VIEW" for record "BDE19EXTERN"
Then fields have values
    | behstatusaz   |       |
    | platz         | L3F1  |
    | behleer       | nein  |
Then the table has 1 rows
Then table has values
    | artikel   | mge |
    | BG1       | 10  |
And I close the current editor

# Auftragszeit
Given I set the fake date to "17.01.1995"
Given I open the infosystem "WORKLIST"
And I set fields
  | mitarb  | SCHNEID   |
  | mgr     | 122       |
And I press start
And I press button "tproduktion" in row 1
And I close the current editor

Given I set the fake date to "17.01.1995"
Given I open the infosystem "WORKLIST"
And I set fields
    | mitarb        | SCHNEID   |
    | mgr           | 122       |
    | sicherheit    | nein      |
And I press start
Then field "taschein^such" has value "BDE01_002" in row 1
And I press button "trueckmeld" in row 1
And I set field "istmge" to "6"
And I set field "behaelter" to "BDE19EXTERN"
# Behaelter, der auf einem Lagerplatz mit abweichender Lagergruppe liegt, kann nicht eingetragen werden, Feld wird geleert
Then field "behaelter" is empty
Then field "bdetext" has value "Der Behälter muss auf einem Lagerplatz der Lagergruppe KARLSRUHE stehen."
And I press button "fertig"
And I close the current editor

# Rueckmeldung wurde gebucht, aber ohne Behaelter
Given I open an editor "RMPruef" from table "(Workorder):(CompletionConfirmations)" with command "VIEW" for search criteria "$,,such=BDE01_002;gutmge==6;@ablage=abgelegt;@richtung=rückwärts;@maxordtreffer=1"
Then field "behaelter" is empty
And I close the current editor

# Behaelter pruefen, war bereits gefuellt und liegt auf Platz L3F1; BG1 wurde NICHT in den Behaelter gebucht
Given I open an editor "BDE19EXTERN" from table "(Container):(ContainerShell)" with command "VIEW" for record "BDE19EXTERN"
Then fields have values
    | behstatusaz   |       |
    | platz         | L3F1  |
    | behleer       | nein  |
Then the table has 1 rows
Then table has values
    | artikel   | mge |
    | BG1       | 10  |
And I close the current editor

#########################################################################################################################
Scenario: 20 Behaelter - Feld behaelter schreibgeschuetzt in Auftragszeit und Kurzlaeufer, wenn kein Zugang gebucht wird

#Given I'm logged in with password "sfloor"
Given I set the fake date to "17.01.1995"
Given I open the infosystem "WORKLIST"
And I set fields
    | mitarb  | SCHNEID   |
    | mgr     | 121       |
And I press start
And I press button "tproduktion" in row 1
And I close the current editor

# Auftragszeit Teilrueckmeldung, Gutmenge kein Zugang an Lager
Given I open the infosystem "WORKLIST"
And I set fields
    | mitarb        | SCHNEID   |
    | mgr           | 121       |
    | sicherheit    | nein      |
And I press start
Then field "taschein^such" has value "BDE01_001" in row 1
And I press button "trueckmeld" in row 1
And I set field "istmge" to "3"
Then field "behaelter" is not modifiable
And I press button "fertig"
And I close the current editor

# Rueckmeldung pruefen, kein Behaelter eingetragen
Given I open an editor "RMPruef" from table "(Workorder):(CompletionConfirmations)" with command "VIEW" for search criteria "$,,such=BDE01_001;gutmge==3;@ablage=abgelegt;@richtung=rückwärts;@maxordtreffer=1"
Then field "behaelter" is empty
And I close the current editor

# Kurzlauefer buchen, keine Gutmenge an Lager zubuchen
#Given I'm logged in with password "sfloor"
Given I set the fake date to "17.01.1995"
Given I open the infosystem "WORKLIST"
And I set fields
    | mitarb        | SCHNEID   |
    | mgr           | 121       |
And I press start
And I press button "tkurzlauf" in row 1
And I set field "istzeit" to "2"
And I set field "istmge" to "4"
Then field "behaelter" is not modifiable
And I press button "fertig"
And I close the current editor

# Behaelter in Rueckmeldung pruefen
Given I open an editor "RMPruef" from table "(Workorder):(CompletionConfirmations)" with command "VIEW" for search criteria "$,,such=BDE01_001;gutmge==4;@ablage=abgelegt;@richtung=rückwärts;@maxordtreffer=1"
Then field "behaelter" is empty
And I close the current editor

# Loeschschutz entfernen und BA Stornieren
Given I open an editor "Betriebsauftrag" from table "(Workorder):(WorkOrders)" with command "UPDATE" for record "BDE01_000"
And I respond with answer "ja" to the dialog with id "345"
And I set field "status" to "S"
And I save the current editor

##############################################################################################################
#Scenario: 21 Anstempeln wenn Arbeitsschein im Aendern geoeffnet, setzt roten Ball und Meldung im Textfeld
#
#Given I set the fake date to "19.01.1995"
#Given I'm logged in with password "sy"
#
#Given I create a work order "BA21" for Product "BG1" with quantity "10" and search word "BA21_"
#
## Arbeitsschein im Aendern-Modus offen lassen
#Given I open an editor "BA21" from table "(Workorder):(WorkOrders)" with command "UPDATE" for search criteria "$,,such=BA21_001;@richtung=rückwärts;@maxordtreffer=1"
#
#Given I'm logged in with password "sfloor"
#
#Given I set the fake date to "19.01.1995"
#Given I open the infosystem "WORKLIST"
#And I set fields
#    | mitarb  | SCHNEID   |
#    | mgr     | 101       |
#And I press start
#And I press button "tproduktion" in row 1
#Then field "bdestatus" has value "icon:ball_red"
#Then field "bdetext" contains value "Buchung nicht erfolgreich"
#And I close the current editor
#
#Given I'm logged in with password "sy"
#And I switch the current editor to editor "BA21" with command "UPDATE"
#And I close the current editor
#
#Given I'm logged in with password "sfloor"
#
#Given I set the fake date to "19.01.1995"
#Given I open the infosystem "WORKLIST"
#And I set fields
#    | mitarb  | SCHNEID   |
#    | mgr     | 101       |
#And I press start
#Then field "tproduktion" has value "icon:media_play_green" in row 1
##And I wait 1 time units to move the time forward
#And I press button "tbeenden" in row 1
#And I close the current editor
#
#Given I open an editor "Betriebsauftrag" from table "(Workorder):(WorkOrders)" with command "UPDATE" for record "BA21_000"
#And I respond with answer "ja" to the dialog with id "345"
#And I set field "status" to "S"
#And I save the current editor

##################################################################################
Scenario: 22 Rueckmelden auf einen Arbeitsschein zu dem es eine ungebuchte RM gibt

Given I set the fake date to "23.01.1995"

Given I create a work order "BA22" for Product "BG1" with quantity "10" and search word "BA22_"

Given I open an editor "RM1_SCEN22" from table "(Workorder):(WorkOrders)" with command "DONE" for search criteria "$,,such=BA22_001;@richtung=rückwärts;@maxordtreffer=1"
And I set fields
    | sofort    | nein          |
    | bem       | RM1_SCEN22    |
And I set field "gutmge" to "2" in row 1
And I save the current editor

# ungebuchte Rueckmeldung vorhanden
Given I open an editor "RM1_SCEN22" from table "(Workorder):(CompletionConfirmations)" with command "VIEW" for search criteria "$,,such=BA22_001;@richtung=rückwärts;@ablageart=lebendig;@maxordtreffer=1"
Then field "bem" has value "RM1_SCEN22"
And I close the current editor

Given I open the infosystem "WORKLIST"
And I set fields
    | mitarb        | SCHNEID   |
    | mgr           | 101       |
    | durchbuchen   | ja        |
And I press start
And I press button "tproduktion" in row 1
And I press button "trueckmeld" in row 1
And I set field "istmge" to "14"
And I press button "fertig"
And I close the current editor

# Auftragszeit wurde nicht uebertragen
Given I open an editor "Auftragszeit" from table "(PDC):(OrderTime)" with command "VIEW" for search criteria "$,,istmge==14;@richtung=rückwärts;@maxordtreffer=1"
Then field "sofort" has value "nein"
Then field "uebertr" has value "ja"
And I close the current editor

Given I open an editor "AuftragszeitBuchen" from table "(PDC):(OrderTime)" with command "UPDATE" for record from editor "Auftragszeit"
And I set field "sofort" to "ja"
And I save the current editor

Given I open an editor "Auftragszeit" from table "(PDC):(OrderTime)" with command "VIEW" for search criteria "$,,istmge==14;@richtung=rückwärts;@maxordtreffer=1"
Then field "uebertr" has value "ja"
And I close the current editor

# ungebuchte Rueckmeldung buchen
Given I open an editor "RM1_SCEN22" from table "(Workorder):(CompletionConfirmations)" with command "UPDATE" for record "BA22_001"
And I set field "sofort" to "ja"
And I save the current editor

Given I open an editor "AuftragszeitBuchen" from table "(PDC):(OrderTime)" with command "UPDATE" for record from editor "Auftragszeit"
And I set field "sofort" to "ja"
And I save the current editor

# Auftragszeit wurde uebertragen
Given I open an editor "AuftragszeitUEB" from table "(PDC):(OrderTime)" with command "VIEW" for search criteria "$,,istmge==14;@richtung=rückwärts;@maxordtreffer=1"
Then field "uebertr" has value "nein"
And I close the current editor

# 1013 TX=de   |Objekt ist bereits übertragen - Ändern nicht erlaubt
Then opening an editor from table "(PDC):(OrderTime)" with command "UPDATE" for record from editor "AuftragszeitUEB" throws the exception "1013"
And I close the current editor

Given I open an editor "RM1_SCEN22_GEBUCHT" from table "(Workorder):(CompletionConfirmations)" with command "VIEW" for search criteria "$,,gutmge==14;@richtung=rückwärts;@ablage=abgelegt;@maxordtreffer=1"
Then field "bdeobjekt^id" has value "!AuftragszeitBuchen^id"
And I close the current editor

Given I open an editor "Betriebsauftrag" from table "(Workorder):(WorkOrders)" with command "UPDATE" for record "BA22_000"
And I respond with answer "ja" to the dialog with id "1483"
And I set field "status" to "S"
And I save the current editor


Scenario: WORK1 Seriennummer erneut verwenden in der WORKLIST

Given I set the fake date to "12.01.1995"

# seriennummernpflichtige Baugruppe, Komponenten keine Chargen- oder SNR-Pflicht
Given I open an editor "BG1" from table "(Part):(Product)" with command "COPY" for record "BG1"
And I set fields
    | such          | BG123_SNR                  |
    | chverfolgung  | Seriennummernverfolgung    |
And I set field "mgr" to "M112" in row !lastRow
And I save the current editor

Given I open an editor "BG1" from table "(Part):(Product)" with command "COPY" for record "BG1"
And I set fields
    | such          | BG111_SNR                  |
    | chverfolgung  | Seriennummernverfolgung    |
And I save the current editor

Given I open an editor "BG1" from table "(Part):(Product)" with command "COPY" for record "BG1"
And I set fields
    | such          | BG1_CHARGE           |
    | chverfolgung  | Chargenverfolgung    |
And I save the current editor

Given I create a Lot "SNR_OK1" for Product "BG123_SNR"
Given I create a Lot "SNR_BESTAND" for Product "BG123_SNR"
Given I create a Lot "SNR_KEINZUGANG" for Product "BG123_SNR"
Given I create a Lot "SNR_BG_FALSCH" for Product "BG111_SNR"
Given I create a Lot "CHARGE_1" for Product "BG1_CHARGE"

Given I create a work order "SNR_WORK1" for Product "BG123_SNR" with quantity "5" and search word "SNR_WORK1_"

# Rueckmeldung auf Arbeitsschein 2 mit Angabe einer zugehenden Seriennummer
Given I open an editor "RM1_SNR_WORK1" from table "(Workorder):(WorkOrders)" with command "DONE" for search criteria "$,,such=SNR_WORK1_002;@richtung=rückwärts;@maxordtreffer=1"
And I set fields
    | kcharge   | !SNR_OK1^id   |
    | sofort    | ja            |
    | bem       | RM1_SNR_WORK1 |
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
    | 1      | F1       | !SNR_OK1^id   |
And I save the current editor

# SNR hat keinen Bestand, sngebzugang ist gefuellt
Given I open an editor "SNR_OK1" from table "(Lots):(Lots)" with command "VIEW" for search criteria "$,,exnum=SNR_OK1;@maxtreffer=1;@ablageart=lebendig"
Then field "mge" has value "0"
Then field "sngebzugang" is not empty
And I close the current editor

# Rueckmeldung auf Arbeitsschein 2 mit Angabe einer zugehenden Seriennummer
Given I open an editor "RM2_SNR_WORK1" from table "(Workorder):(WorkOrders)" with command "DONE" for search criteria "$,,such=SNR_WORK1_002;@richtung=rückwärts;@maxordtreffer=1"
And I set fields
    | kcharge   | !SNR_BESTAND^id   |
    | sofort    | ja                |
    | bem       | RM2_SNR_WORK1     |
And I set field "gutmge" to "1" in row 1
And I save the current editor

# SNR hat Bestand > 0, sngebzugang ist gefuellt
Given I open an editor "SNR_BESTAND" from table "(Lots):(Lots)" with command "VIEW" for search criteria "$,,exnum=SNR_BESTAND;@maxtreffer=1;@ablageart=lebendig"
Then field "mge" has value "1"
Then field "sngebzugang" is not empty
And I close the current editor

# SNR hat keinen Bestand, sngebzugang ist leer
Given I open an editor "SNR_KEINZUGANG" from table "(Lots):(Lots)" with command "VIEW" for search criteria "$,,exnum=SNR_KEINZUGANG;@maxtreffer=1;@ablageart=lebendig"
Then field "mge" has value "0"
Then field "sngebzugang" is empty
And I close the current editor

# Plausis im IS WORKLIST pruefen, bsnerneutverwend ist schreibgeschuetzt oder nicht, wird geleert bei Feldaustritt charge oder istmge
Given I set the fake date to "12.01.1995"
Given I open the infosystem "WORKLIST"
And I set fields
    | mitarb  | SCHNEID |
    | mgr     | M112    |
And I press start
And I press button "tproduktion" in row 1
And I close the current editor

# Teilrueckmeldung auf Arbeitsschein 2 bucht Gutmenge an Lager
Given I set the fake date to "12.01.1995"
Given I open the infosystem "WORKLIST"
And I set fields
    | mitarb        | SCHNEID |
    | mgr           | M112    |
    | sicherheit    | nein    |
And I press start
Then field "taschein^such" has value "SNR_WORK1_002" in row 1
And I press button "trueckmeld" in row 1
And I set field "istmge" to "2"
Then field "charge" is not modifiable
# bei istmge <> 1 darf bsnerneutverwend nicht gesetzt werden
Then field "bsnerneutverwend" is not modifiable
And I set field "istmge" to "1"
And I set field "charge" to "SNR_OK1"
Then field "bsnerneutverwend" is modifiable
And I set field "bsnerneutverwend" to "ja"
# wird istmge geaendert auf Wert <> 1, dann wird bsnerneutverwend geleert und schreibgeschuetzt
And I set field "istmge" to "2"
Then field "bsnerneutverwend" is not modifiable
Then field "bsnerneutverwend" has value "nein"
And I set field "istmge" to "1"
And I set field "charge" to "SNR_OK1"
Then field "bsnerneutverwend" is modifiable
And I set field "bsnerneutverwend" to "ja"
# bei einer SNR die Bestand <> 0 hat, wird bsnerneutverwend geleert und schreibgeschuetzt
And I set field "charge" to "SNR_BESTAND"
Then field "bsnerneutverwend" is not modifiable
Then field "bsnerneutverwend" has value "nein"
And I press button "fertig"
# Buchen wird abgelehnt mit einer Meldung
# Meldung kann nicht abgefragt werden, weil ACK statt NAK, "SN kann nicht erneut gebucht werden, weil der Bestand falsch ist."
# Buchen wird abgebrochen, Maske bleibt offen und Eingaben koennen korrigiert werden
And I set field "charge" to "SNR_OK1"
And I set field "bsnerneutverwend" to "ja"
# bei einer SNR mit Bestand 0, aber noch kein Zugang gebucht (sngebzugang ist leer), wird bsnerneutverwend geleert und schreibgeschuetzt
And I set field "charge" to "SNR_KEINZUGANG"
Then field "bsnerneutverwend" is not modifiable
Then field "bsnerneutverwend" has value "nein"
And I set field "charge" to "SNR_OK1"
And I set field "bsnerneutverwend" to "ja"
# wenn die SNR nicht zum Artikel passt, wird Feld geleert und bei leerer Charge wird bsnerneutverwend geleert und schreibgeschuetzt
And I set field "charge" to "SNR_BG_FALSCH"
Then field "bsnerneutverwend" is not modifiable
Then field "bsnerneutverwend" has value "nein"
And I set field "charge" to "SNR_OK1"
And I set field "bsnerneutverwend" to "ja"
# wird Feld charge geleert, dann wird bsnerneutverwend geleert und schreibgeschuetzt
And I set field "charge" to ""
Then field "bsnerneutverwend" is not modifiable
Then field "bsnerneutverwend" has value "nein"
And I set field "charge" to "SNR_OK1"
And I press button "fertig"
# Buchen wird abgelehnt mit einer Meldung
# Meldung kann nicht abgefragt werden, weil ACK statt NAK, "Diese Seriennummer wird bereits in einem anderen Vorgang verwendet."
# Buchen wird abgebrochen, Maske bleibt offen und Eingaben koennen korrigiert werden
And I set field "bsnerneutverwend" to "ja"
And I press button "fertig"
And I save the current editor

# im gebuchten Rueckmeldebeleg ist ersichtlich, dass die SNR erneut verwendet wurde
Given I open an editor "RM_WORK_PRUEF" from table "(Workorder):(CompletionConfirmations)" with command "VIEW" for search criteria "$,,such=SNR_WORK1_002;bdeobjekt<>`;@ablage=abgelegt;@richtung=rückwärts;@maxordtreffer=1"
Then field "ksnerneutverwend" has value "ja"
And I close the current editor


Scenario: MZEIT1 Maschinenzeit automatisch berechnen wird aus Maschinengruppe vorbelegt und Zeiten in Rueckmeldung gebucht

# in Maschinengruppe den Haken automzeit setzen
Given I open an editor "M101" from table "(Capacity):(WorkCenter)" with command "COPY" for record "M101"
And I set field "such" to "MGR123"
And I set field "automzeit" to "ja"
And I save the current editor

Given I open an editor "M101" from table "(Capacity):(WorkCenter)" with command "COPY" for record "M101"
And I set field "such" to "MGR456"
And I set field "automzeit" to "ja"
And I save the current editor

Given I open an editor "AG1" from table "(Operation):(Operation)" with command "COPY" for record "AG1"
And I set fields
    | such       | AG123      |
    | namebspr   | AG Testen  |
    | mgr        | MGR123     |
    | lgr        | 1          |
    | lgrruesten | 1          |
    | aschein    | ja         |
    | tr         | 5          |
    | te         | 15         |
    | rmimdialog | ja         |
And I save the current editor

Given I open an editor "BG1" from table "(Part):(Product)" with command "COPY" for record "BG1"
And I set field "such" to "BG_MZEIT"
And I set field "elex" to "A AG123" in row 2
And I set field "mgr" to "MGR456" in row 3
And I save the current editor

Given I create a work order "BA_MZEIT" for Product "BG_MZEIT" with quantity "10" and search word "BA_MZEIT_"

# Ruesten anstempeln
Given I set the fake date to "12.01.1995"
Given I open the infosystem "WORKLIST"
And I set fields
    | mitarb  | SCHNEID |
    | mgr     | MGR123  |
And I press start
And I press button "truesten" in row 1
And I close the current editor

# Produktion anstempeln meldet Ruesten ab
Given I set the fake date to "12.01.1995"
And I wait 1 time units to move the time forward
Given I open the infosystem "WORKLIST"
And I set fields
    | mitarb            | SCHNEID |
    | mgr               | MGR123  |
    | mzeitberechnen    | ja      |
And I press start
And I press button "tproduktion" in row 1
And I close the current editor

# entstandene Auftragszeit Ruesten pruefen, enthaelt mzeit
Given I open an editor "BA_MZEIT_RUESTEN" from table "(PDC):(OrderTime)" with command "VIEW" for search criteria "$,,ma=SCHNEID;endzeit<>`;fertstatus=Rüsten;mgr==MGR123;@richtung=rückwärts;@maxtreffer=1"
Then field "mzeit" has value "1"
And I save the current editor

Given I set the fake date to "12.01.1995"
# die Zeit faengt immer wieder um 10:54 an, Ruesten wurde aber um 11:54 abgestempelt
And I wait 3 time units to move the time forward
Given I open the infosystem "WORKLIST"
And I set fields
    | mitarb            | SCHNEID |
    | mgr               | MGR123  |
    | mzeitberechnen    | ja      |
And I press start
Then field "taschein^such" has value "BA_MZEIT_001" in row 1
And I press button "trueckmeld" in row 1
Then field "automzeit" has value "ja"
Then field "automzeit" is modifiable
And I set field "istmge" to "2"
And I press button "fertig"
And I save the current editor

# im gebuchten Rueckmeldebeleg ist die Maschinenzeit gefuellt
Given I open an editor "RM_WORK_PRUEF" from table "(Workorder):(CompletionConfirmations)" with command "VIEW" for search criteria "$,,such=BA_MZEIT_001;gutmge==2;bdeobjekt<>`;@ablage=abgelegt;@richtung=rückwärts;@maxordtreffer=1"
Then field "mzeit" has value "2"
And I close the current editor

Given I set the fake date to "14.01.1995"
Given I open the infosystem "WORKLIST"
And I set fields
    | mitarb            | SCHNEID |
    | mgr               | MGR123  |
    | mzeitberechnen    | ja      |
And I press start
And I press button "tkurzlauf" in row 1
And I set field "istzeit" to "1"
And I set field "istmge" to "1"
Then field "automzeit" has value "ja"
Then field "automzeit" is modifiable
And I press button "fertig"
And I close the current editor

# im gebuchten Rueckmeldebeleg ist die Maschinenzeit gefuellt
Given I open an editor "RM_WORK_PRUEF" from table "(Workorder):(CompletionConfirmations)" with command "VIEW" for search criteria "$,,such=BA_MZEIT_001;gutmge==1;bdeobjekt<>`;@ablage=abgelegt;@richtung=rückwärts;@maxordtreffer=1"
Then field "mzeit" has value "1"
And I close the current editor


Scenario: MZEIT2 Plausis, automzeit aus Maschinengruppe kann ueberstimmt werden, kann nicht gesetzt werden wenn Konfig auf nein

# mzeitberechnen nicht setzen, automzeit ist schreibgeschuetzt
Given I set the fake date to "13.01.1995"
Given I open the infosystem "WORKLIST"
And I set fields
    | mitarb            | SCHNEID |
    | mgr               | MGR123  |
Then field "mzeitberechnen" has value "nein"
And I press start
Then field "taschein^such" has value "BA_MZEIT_001" in row 1
And I press button "tproduktion" in row 1
And I press button "trueckmeld" in row 1
Then field "automzeit" has value "nein"
Then field "automzeit" is not modifiable
And I close the current editor

# Vorbelegung aus Maschinengruppe kann ueberstimmt werden
Given I set the fake date to "14.01.1995"
Given I open the infosystem "WORKLIST"
And I set fields
    | mitarb            | SCHNEID |
    | mgr               | MGR123  |
    | mzeitberechnen    | ja      |
And I press start
And I press button "tkurzlauf" in row 1
And I set field "istzeit" to "2"
And I set field "istmge" to "3"
Then field "automzeit" has value "ja"
And I set field "automzeit" to "nein"
And I press button "fertig"
And I close the current editor

Given I open an editor "RM_WORK_PRUEF" from table "(Workorder):(CompletionConfirmations)" with command "VIEW" for search criteria "$,,such=BA_MZEIT_001;;gutmge==3;bdeobjekt<>`;@ablage=abgelegt;@richtung=rückwärts;@maxordtreffer=1"
Then field "mzeit" has value "0"
And I close the current editor

# in einer mgr den Haken automzeit rausnehmen
Given I open an editor "MGR123" from table "(Capacity):(WorkCenter)" with command "UPDATE" for record "MGR123"
And I set field "automzeit" to "nein"
And I save the current editor

# in der Maschinengruppe ist automzeit nicht gesetzt, kann in der WORKLIST gesetzt werden, wenn Konfigschalter an
Given I set the fake date to "14.01.1995"
Given I open the infosystem "WORKLIST"
And I set fields
    | mitarb            | SCHNEID |
    | mgr               | MGR123  |
    | mzeitberechnen    | ja      |
And I press start
Then field "taschein^such" has value "BA_MZEIT_001" in row 1
And I press button "tproduktion" in row 1
And I press button "trueckmeld" in row 1
Then field "automzeit" has value "nein"
Then field "automzeit" is modifiable
And I set field "istmge" to "1"
And I press button "fertig"
And I close the current editor


Scenario: MZEIT3 mzeitberechnen ja bei Komplettrueckmeldung mit Dialog

# in mgr den Haken automzeit wieder setzen
Given I open an editor "MGR123" from table "(Capacity):(WorkCenter)" with command "UPDATE" for record "MGR123"
And I set field "automzeit" to "ja"
And I save the current editor

Given I set the fake date to "15.01.1995"
Given I open the infosystem "WORKLIST"
And I set fields
    | mitarb  | SCHNEID |
    | mgr     | MGR123  |
And I press start
And I press button "tproduktion" in row 1
And I close the current editor

# Komplettrueckmeldung mit Dialog, noch Menge 3 offen
Given I set the fake date to "15.01.1995"
And I wait 3 time units to move the time forward
Given I open the infosystem "WORKLIST"
And I set fields
    | mitarb            | SCHNEID |
    | mgr               | MGR123  |
    | mzeitberechnen    | ja      |
And I press start
And I press button "tkomplettrueck" in row 1
Then field "automzeit" has value "ja"
Then field "automzeit" is modifiable
And I press button "fertig"
And I close the current editor

# im gebuchten Rueckmeldebeleg ist die Maschinenzeit gefuellt
Given I open an editor "RM_WORK_PRUEF" from table "(Workorder):(CompletionConfirmations)" with command "VIEW" for search criteria "$,,such=BA_MZEIT_001;gutmge==3;bdeobjekt<>`;@ablage=abgelegt;@richtung=rückwärts;@maxordtreffer=1"
Then field "mzeit" has value "3"
And I close the current editor


Scenario: MZEIT4 mzeitberechnen ja bei Komplettrueckmeldung ohne Dialog

# in der mgr zu Arbeitsschein 2 ist der Haken automzeit gesetzt
Given I open an editor "MGR456" from table "(Capacity):(WorkCenter)" with command "VIEW" for record "MGR456"
Then field "automzeit" has value "ja"
And I save the current editor

# Arbeitsschein 2 anstempeln
Given I set the fake date to "16.01.1995"
Given I open the infosystem "WORKLIST"
And I set fields
    | mitarb  | SCHNEID |
    | mgr     | MGR456  |
And I press start
And I press button "tproduktion" in row 1
And I close the current editor

# Komplettrueckmeldung ohne Dialog
Given I set the fake date to "16.01.1995"
And I wait 1 time units to move the time forward
Given I open the infosystem "WORKLIST"
And I set fields
    | mitarb            | SCHNEID |
    | mgr               | MGR456  |
    | sicherheit        | nein    |
    | mzeitberechnen    | ja      |
And I press start
And I press button "tkomplettrueck" in row 1
And I press button "fertig"
And I close the current editor

# im gebuchten Rueckmeldebeleg ist die Maschinenzeit gefuellt
Given I open an editor "RM_WORK_PRUEF" from table "(Workorder):(CompletionConfirmations)" with command "VIEW" for search criteria "$,,such=BA_MZEIT_002;gutmge==10;bdeobjekt<>`;@ablage=abgelegt;@richtung=rückwärts;@maxordtreffer=1"
Then field "mzeit" has value "2.5"
And I close the current editor


Scenario: MZEIT5 mzeitberechnen ja bei Bearbeiten anstempeln und Beenden

Given I create a work order "BA_MZEIT" for Product "BG_MZEIT" with quantity "10" and search word "BA_MZEIT2_"

Given I set the fake date to "17.01.1995"
Given I open the infosystem "WORKLIST"
And I set fields
    | mitarb  | SCHNEID |
    | mgr     | MGR123  |
And I press start
And I press button "tproduktion" in row 1
And I close the current editor

# Beenden ohne Gutmenge
Given I set the fake date to "17.01.1995"
And I wait 1 time units to move the time forward
Given I open the infosystem "WORKLIST"
And I set fields
    | mitarb            | SCHNEID |
    | mgr               | MGR123  |
    | mzeitberechnen    | ja      |
And I press start
And I press button "tbeenden" in row 1
And I close the current editor

# entstandene Auftragszeit pruefen, enthaelt mzeit
Given I open an editor "BA_MZEIT2_BEENDEN" from table "(PDC):(OrderTime)" with command "VIEW" for search criteria "$,,ma=SCHNEID;anfdat==17.01.95;endzeit<>`;mgr==MGR123;@richtung=rückwärts;@maxtreffer=1"
Then field "mzeit" has value "1"
And I save the current editor


Scenario: MZEIT6 mzeitberechnen nein, aber automzeit in Maschinengruppe angehakt

# in mgr zu Arbeitsschein 1 ist Haken automzeit gesetzt
Given I open an editor "MGR123" from table "(Capacity):(WorkCenter)" with command "VIEW" for record "MGR123"
Then field "automzeit" has value "ja"
And I save the current editor

# in mgr zu Arbeitsschein 2 ist Haken automzeit gesetzt
Given I open an editor "MGR456" from table "(Capacity):(WorkCenter)" with command "VIEW" for record "MGR456"
Then field "automzeit" has value "ja"
And I save the current editor

Given I set the fake date to "18.01.1995"
Given I open the infosystem "WORKLIST"
And I set fields
    | mitarb  | SCHNEID |
    | mgr     | MGR123  |
And I press start
And I press button "tproduktion" in row 1
And I close the current editor

# Beenden ohne Gutmenge und mzeitberechnen nein
Given I set the fake date to "18.01.1995"
And I wait 1 time units to move the time forward
Given I open the infosystem "WORKLIST"
And I set fields
    | mitarb            | SCHNEID |
    | mgr               | MGR123  |
Then field "mzeitberechnen" has value "nein"
And I press start
And I press button "tbeenden" in row 1
And I close the current editor

# entstandene Auftragszeit pruefen, mzeit ist nicht gefuellt
Given I open an editor "BA_MZEIT2_BEENDEN" from table "(PDC):(OrderTime)" with command "VIEW" for search criteria "$,,ma=SCHNEID;anfdat==18.01.95;endzeit<>`;mgr==MGR123;@richtung=rückwärts;@maxtreffer=1"
Then field "mzeit" has value "0"
And I save the current editor

# Arbeitsschein 2 anstempeln
Given I set the fake date to "19.01.1995"
Given I open the infosystem "WORKLIST"
And I set fields
    | mitarb  | SCHNEID |
    | mgr     | MGR456  |
Then field "mzeitberechnen" has value "nein"
And I press start
And I press button "tproduktion" in row 1
And I close the current editor

# Komplettrueckmeldung ohne Dialog und mzeitberechnen nein
Given I set the fake date to "19.01.1995"
And I wait 1 time units to move the time forward
Given I open the infosystem "WORKLIST"
And I set fields
    | mitarb            | SCHNEID |
    | mgr               | MGR456  |
    | sicherheit        | nein    |
Then field "mzeitberechnen" has value "nein"
And I press start
And I press button "tkomplettrueck" in row 1
And I press button "fertig"
And I close the current editor

# im gebuchten Rueckmeldebeleg ist die Maschinenzeit nicht gefuellt
Given I open an editor "RM_MZEIT2_PRUEF" from table "(Workorder):(CompletionConfirmations)" with command "VIEW" for search criteria "$,,such=BA_MZEIT2_002;gutmge==10;bdeobjekt<>`;@ablage=abgelegt;@richtung=rückwärts;@maxordtreffer=1"
Then field "mzeit" has value "0"
And I close the current editor


Scenario: SNRMZ01 - Plausis MZ anlegen bei Seriennummernverfolgung

Given I open an editor "M101" from table "(Capacity):(WorkCenter)" with command "COPY" for record "M101"
And I set field "such" to "MGR321MZ"
And I save the current editor

Given I open an editor "AG1" from table "(Operation):(Operation)" with command "COPY" for record "AG1"
And I set fields
    | such       | AG321MZ    |
    | namebspr   | AG Test MZ |
    | mgr        | MGR321MZ   |
    | lgr        | 1          |
    | lgrruesten | 1          |
    | aschein    | ja         |
    | tr         | 5          |
    | te         | 15         |
    | rmimdialog | ja         |
And I save the current editor

Given I open an editor "BG1" from table "(Part):(Product)" with command "COPY" for record "BG1"
And I set field "such" to "BG_MZSNR"
And I set field "chverfolgung" to "Seriennummernverfolgung"
And I set field "elex" to "A AG321MZ" in row 2
And I delete row at position 3
And I save the current editor

Given I create a work order "BA_MZSNR" for Product "BG_MZSNR" with quantity "7" and search word "BA_MZSNR_"

Given I set the fake date to "20.01.1995"
Given I open the infosystem "WORKLIST"
And I set fields
    | mitarb            | SCHNEID   |
    | mgr               | MGR321MZ  |
	| endegepl          |           |
And I press start
Then field "taschein^such" has value "BA_MZSNR_001" in row 1
And I press button "tproduktion" in row 1
And I press button "trueckmeld" in row 1
Then field "freitextseriennr" is modifiable
Then field "mzanlegen" is modifiable
Then field "ofmge" has value "7"
#Then setting field "istmge" to "8" throws the exception "Gutmenge hoeher als offene Menge bei Seriennummernpflicht nicht erlaubt."
# Fehlermeldung kann nicht abgefragt werden, istmge wird auf 0 gesetzt
And I set field "istmge" to "8"
Then field "istmge" has value "0"
And I set field "istmge" to "3"
# Leerzeilen werden ignoriert
And I set field "freitextseriennr" to
"""
SNRZEILE1

SNRZEILE2

SNRZEILE3
"""
Then field "freitextseriennr" has value
"""
SNRZEILE1

SNRZEILE2

SNRZEILE3
"""
And I press button "mzanlegen"
And I press button "fertig"
And I close the current editor

Given I open an editor "RM_MZSNR_PRUEF" from table "(Workorder):(CompletionConfirmations)" with command "VIEW" for search criteria "$,,such=BA_MZSNR_001;gutmge==3;bdeobjekt<>`;@ablage=abgelegt;@richtung=rückwärts;@maxordtreffer=1"
And I press button "mzsubm" to open a subeditor for "ZugangsMZ" in row 1
Then the table has 3 rows
Then table has values
    | tcharge   |
    | SNRZEILE1 |
    | SNRZEILE2 |
    | SNRZEILE3 |
And I close the current editor
And I switch the current editor to editor "RM_MZSNR_PRUEF"
And I close the current editor

Given I set the fake date to "21.01.1995"
Given I open the infosystem "WORKLIST"
And I set fields
    | mitarb            | SCHNEID   |
    | mgr               | MGR321MZ  |
	| endegepl          |           |
And I press start
Then field "taschein^such" has value "BA_MZSNR_001" in row 1
And I press button "tproduktion" in row 1
And I press button "trueckmeld" in row 1
And I set field "istmge" to "2"
And I set field "freitextseriennr" to
"""
SNRZEILE1
SNRZEILE5
"""
# Fehlermeldung kann nicht abgefragt werden, ACK statt NAK im EDP
#Then pressing button "mzanlegen" throws the exception "MZ anlegen gescheitert! Diese Seriennummer wird bereits in einem anderen Vorgang verwendet oder wurde zugebucht. - charge(1)"
And I set field "freitextseriennr" to
"""
SNRZEILE4
SNRZEILE5
"""
And I press button "mzanlegen"
And I press button "fertig"
And I close the current editor

Given I set the fake date to "22.01.1995"
Given I open the infosystem "WORKLIST"
And I set fields
    | mitarb            | SCHNEID   |
    | mgr               | MGR321MZ  |
    | endegepl          |           |
And I press start
And I press button "tkurzlauf" in row 1
And I set field "istzeit" to "2"
And I set field "istmge" to "2"
And I set field "freitextseriennr" to
"""
SNRZEILE6
SNRZEILE7
"""
And I press button "mzanlegen"
And I press button "fertig"
And I close the current editor

Given I open an editor "RM3_MZSNR_PRUEF" from table "(Workorder):(CompletionConfirmations)" with command "VIEW" for search criteria "$,,such=BA_MZSNR_001;gutmge==2;bdeobjekt<>`;vom==22.01.95;@ablage=abgelegt;@richtung=rückwärts;@maxordtreffer=1"
And I press button "mzsubm" to open a subeditor for "ZugangsMZ" in row 1
Then the table has 2 rows
Then table has values
    | tcharge   |
    | SNRZEILE6 |
    | SNRZEILE7 |
And I close the current editor
And I switch the current editor to editor "RM3_MZSNR_PRUEF"
And I close the current editor


Scenario: SNRMZ02 - MZ anlegen und Komplettrueckmeldung mit mehreren Seriennummern

Given I create a work order "BA_MZSNR02" for Product "BG_MZSNR" with quantity "5" and search word "BA_MZSNR02_"

Given I set the fake date to "23.01.1995"
Given I open the infosystem "WORKLIST"
And I set fields
    | mitarb            | SCHNEID   |
    | mgr               | MGR321MZ  |
	| sicherheit        | nein      |
    | endegepl          |           |
And I press start
Then field "taschein^such" has value "BA_MZSNR02_001" in row 1
And I press button "tproduktion" in row 1
And I press button "tkomplettrueck" in row 1
Then field "freitextseriennr" is modifiable
Then field "mzanlegen" is modifiable
Then field "ofmge" has value "5"
Then field "istmge" has value "5"
And I set field "freitextseriennr" to
"""
SNR111
SNR222
SNR333
SNR444
SNR555
"""
And I press button "mzanlegen"
And I press button "fertig"
And I close the current editor

Given I open an editor "RM_MZSNR02_PRUEF" from table "(Workorder):(CompletionConfirmations)" with command "VIEW" for search criteria "$,,such=BA_MZSNR02_001;gutmge==5;bdeobjekt<>`;@ablage=abgelegt;@richtung=rückwärts;@maxordtreffer=1"
And I press button "mzsubm" to open a subeditor for "ZugangsMZ" in row 1
Then the table has 5 rows
Then table has values
    | tcharge   |
    | SNR111    |
    | SNR222    |
    | SNR333    |
    | SNR444    |
    | SNR555    |
And I close the current editor
And I switch the current editor to editor "RM_MZSNR02_PRUEF"
And I close the current editor


Scenario: SNRMZ03 - MZ anlegen nicht moeglich bei Chargenverfolgung

Given I open an editor "BG1_CHARGE" from table "(Part):(Product)" with command "UPDATE" for record "BG1_CHARGE"
And I set field "mgr" to "M111" in row 2
And I delete row at position 3
And I save the current editor

Given I create a work order "BA_MZCHA01" for Product "BG1_CHARGE" with quantity "5" and search word "BA_MZCHA01_"

Given I set the fake date to "25.01.1995"
Given I open the infosystem "WORKLIST"
And I set fields
    | mitarb            | SCHNEID   |
    | mgr               | M111      |
    | endegepl          |           |
And I press start
Then field "taschein^such" has value "BA_MZCHA01_001" in row 1
And I press button "tproduktion" in row 1
And I press button "trueckmeld" in row 1
Then field "freitextseriennr" is not modifiable
Then field "mzanlegen" is not modifiable
And I close the current editor


Scenario: SNRMZ04 - MZ anlegen ueber WORKLIST nicht moeglich, wenn bereits MZ vorhanden

Given I create a work order "BA_MZSNR04" for Product "BG_MZSNR" with quantity "4" and search word "BA_MZSNR04_"

Given I open an editor "BA_MZSNR04" from table "(Workorder):(WorkOrders)" with command "UPDATE" for record "BA_MZSNR04_000"
And I set field "noloesch" to "ja"
And I save the current editor

# nur MZ anlegen, nicht buchen
Given I set the fake date to "27.01.1995"
Given I open the infosystem "WORKLIST"
And I set fields
    | mitarb            | SCHNEID   |
    | mgr               | MGR321MZ  |
    | endegepl          |           |
And I press start
Then field "taschein^such" has value "BA_MZSNR04_001" in row 1
And I press button "tproduktion" in row 1
And I press button "trueckmeld" in row 1
And I set field "freitextseriennr" to
"""
123SNR
456SNR
"""
And I set field "istmge" to "2"
And I press button "mzanlegen"
And I close the current editor

# Freitextfeld und Button sind schreibgeschutzt, da MZ bereits vorhanden
Given I set the fake date to "27.01.1995"
Given I open the infosystem "WORKLIST"
And I set fields
    | mitarb            | SCHNEID   |
    | mgr               | MGR321MZ  |
    | endegepl          |           |
And I press start
Then field "taschein^such" has value "BA_MZSNR04_001" in row 1
And I press button "tproduktion" in row 1
And I press button "trueckmeld" in row 1
Then field "freitextseriennr" is not modifiable
Then field "mzanlegen" is not modifiable
And I close the current editor

# Gutmenge > 1 kann direkt gebucht werden, da MZ bereits vorhanden
Given I set the fake date to "27.01.1995"
Given I open the infosystem "WORKLIST"
And I set fields
    | mitarb            | SCHNEID   |
    | mgr               | MGR321MZ  |
    | endegepl          |           |
And I press start
Then field "taschein^such" has value "BA_MZSNR04_001" in row 1
And I press button "tproduktion" in row 1
And I press button "trueckmeld" in row 1
And I set field "istmge" to "2"
And I press button "fertig"
And I close the current editor

Given I open an editor "RM_MZSNR04_PRUEF" from table "(Workorder):(CompletionConfirmations)" with command "VIEW" for search criteria "$,,such=BA_MZSNR04_001;gutmge==2;bdeobjekt<>`;@ablage=abgelegt;@richtung=rückwärts;@maxordtreffer=1"
And I press button "mzsubm" to open a subeditor for "ZugangsMZ" in row 1
Then the table has 2 rows
Then table has values
    | tcharge   |
    | 123SNR    |
    | 456SNR    |
And I close the current editor
And I switch the current editor to editor "RM_MZSNR04_PRUEF"
And I close the current editor

Given I create a Lot "SNR_MZ04" for Product "BG_MZSNR"

Given I set the fake date to "27.01.1995"
Given I open the infosystem "WORKLIST"
And I set fields
    | mitarb            | SCHNEID   |
    | mgr               | MGR321MZ  |
    | endegepl          |           |
And I press start
Then field "taschein^such" has value "BA_MZSNR04_001" in row 1
And I press button "tproduktion" in row 1
And I press button "trueckmeld" in row 1
And I set field "charge" to "SNR_MZ04"
And I set field "freitextseriennr" to
"""
NEU123SNR
NEU456SNR
"""
Then field "charge" has value ""
Then field "charge" is not modifiable
And I set field "istmge" to "2"
And I press button "mzanlegen"
And I press button "fertig"
And I close the current editor


Scenario: NUTZEN01 Nutzen im Arbeitsgang bei Komplettrueckmeldung ohne Dialog

Given I create a work order "BA_NUTZEN01A" for Product "BG01_NUTZEN" with quantity "50" and search word "BA_NUTZEN01A_"

# Arbeitsschein 1 anstempeln
Given I set the fake date to "30.01.1995"
Given I open the infosystem "WORKLIST"
And I set fields
    | mitarb  | SCHNEID |
    | mgr     | MGR4    |
And I press start
And I press button "tproduktion" in row 1
And I close the current editor

# Komplettrueckmeldung ohne Dialog
Given I set the fake date to "30.01.1995"
And I wait 1 time units to move the time forward
Given I open the infosystem "WORKLIST"
And I set fields
    | mitarb            | SCHNEID |
    | mgr               | MGR4    |
    | sicherheit        | nein    |
And I press start
And I press button "tkomplettrueck" in row 1
And I press button "fertig"
And I close the current editor

Given I open an editor "RM1_PRUEF" from table "(Workorder):(CompletionConfirmations)" with command "VIEW" for search criteria "$,,such=BA_NUTZEN01A_001;gutmge==50;bdeobjekt<>`;@ablage=abgelegt;@richtung=rückwärts;@maxordtreffer=1"
And I close the current editor

Given I open an editor "Auftragszeit" via ID from editor "RM1_PRUEF" from field "bdeobjekt" in row 0 for table "(PDC):(OrderTime)" with command "VIEW"
Then field "korr" has value "1"
And I close the current editor

Given I create a work order "BA_NUTZEN01B" for Product "BG01_NUTZEN" with quantity "50" and search word "BA_NUTZEN01B_"

Given I open the infosystem "WORKLIST"
And I set fields
    | mitarb            | SCHNEID |
    | mgr               | MGR4    |
    | sicherheit        | nein    |
And I press start
Then the table has 1 rows
And I press button "tproduktion" in row 1
And I press button "trueckmeld" in row 1
And I set field "istmge" to "12"
And I press button "fertig"
Then the table has 1 rows
And I press button "tproduktion" in row 1
And I press button "tkomplettrueck" in row 1
And I press button "fertig"
And I close the current editor

Given I open an editor "RM2_PRUEF" from table "(Workorder):(CompletionConfirmations)" with command "VIEW" for search criteria "$,,such=BA_NUTZEN01B_001;gutmge==38;bdeobjekt<>`;@ablage=abgelegt;@richtung=rückwärts;@maxordtreffer=1"
And I close the current editor

Given I open an editor "Auftragszeit" via ID from editor "RM2_PRUEF" from field "bdeobjekt" in row 0 for table "(PDC):(OrderTime)" with command "VIEW"
Then field "korr" has value "0.8"
And I close the current editor


Scenario: NUTZEN02 Nutzen im Arbeitsgang und Fertigungslistenbasis groesser 1 bei Komplettrueckmeldung ohne Dialog

Given I create a work order "BA_NUTZEN02" for Product "BG02_NUTZEN_FLBASIS" with quantity "50" and search word "BA_NUTZEN02_"

# Arbeitsschein 1 anstempeln
Given I set the fake date to "31.01.1995"
Given I open the infosystem "WORKLIST"
And I set fields
    | mitarb  | SCHNEID |
    | mgr     | MGR4    |
And I press start
And I press button "tproduktion" in row 1
And I close the current editor

# Komplettrueckmeldung ohne Dialog
Given I set the fake date to "31.01.1995"
And I wait 1 time units to move the time forward
Given I open the infosystem "WORKLIST"
And I set fields
    | mitarb            | SCHNEID |
    | mgr               | MGR4    |
    | sicherheit        | nein    |
And I press start
And I press button "tkomplettrueck" in row 1
And I press button "fertig"
And I close the current editor

Given I open an editor "RM1_PRUEF" from table "(Workorder):(CompletionConfirmations)" with command "VIEW" for search criteria "$,,such=BA_NUTZEN02_001;gutmge==50;bdeobjekt<>`;@ablage=abgelegt;@richtung=rückwärts;@maxordtreffer=1"
And I close the current editor

Given I open an editor "Auftragszeit" via ID from editor "RM1_PRUEF" from field "bdeobjekt" in row 0 for table "(PDC):(OrderTime)" with command "VIEW"
Then field "korr" has value "0.1"
And I close the current editor


Scenario: NUTZEN03 Nutzen kleiner 1 im Arbeitsgang bei Komplettrueckmeldung ohne Dialog

Given I open an editor "BG01_NUTZEN" from table "(Part):(Product)" with command "UPDATE" for record "BG01_NUTZEN"
And I set field "nutzen" to "0.5" in row 2
And I save the current editor

Given I create a work order "BA_NUTZEN03" for Product "BG01_NUTZEN" with quantity "50" and search word "BA_NUTZEN03_"

# Arbeitsschein 1 anstempeln
Given I set the fake date to "01.02.1995"
Given I open the infosystem "WORKLIST"
And I set fields
    | mitarb  | SCHNEID |
    | mgr     | MGR4    |
And I press start
And I press button "tproduktion" in row 1
And I close the current editor

# Komplettrueckmeldung ohne Dialog
Given I set the fake date to "01.02.1995"
And I wait 1 time units to move the time forward
Given I open the infosystem "WORKLIST"
And I set fields
    | mitarb            | SCHNEID |
    | mgr               | MGR4    |
    | sicherheit        | nein    |
And I press start
And I press button "tkomplettrueck" in row 1
And I press button "fertig"
And I close the current editor

Given I open an editor "RM1_PRUEF" from table "(Workorder):(CompletionConfirmations)" with command "VIEW" for search criteria "$,,such=BA_NUTZEN03_001;gutmge==50;bdeobjekt<>`;@ablage=abgelegt;@richtung=rückwärts;@maxordtreffer=1"
And I close the current editor

Given I open an editor "Auftragszeit" via ID from editor "RM1_PRUEF" from field "bdeobjekt" in row 0 for table "(PDC):(OrderTime)" with command "VIEW"
Then field "korr" has value "10"
And I close the current editor


Scenario: FLBASIS01 Fertigungslistenbasis groesser 1 bei Komplettrueckmeldung ohne Dialog

Given I create a work order "BA_FLBASIS01" for Product "BG03_FLBASIS" with quantity "50" and search word "BA_FLBASIS01_"

# Arbeitsschein 1 anstempeln
Given I set the fake date to "02.02.1995"
Given I open the infosystem "WORKLIST"
And I set fields
    | mitarb  | SCHNEID |
    | mgr     | MGR4    |
And I press start
And I press button "tproduktion" in row 1
And I close the current editor

# Komplettrueckmeldung ohne Dialog
Given I set the fake date to "02.02.1995"
And I wait 1 time units to move the time forward
Given I open the infosystem "WORKLIST"
And I set fields
    | mitarb            | SCHNEID |
    | mgr               | MGR4    |
    | sicherheit        | nein    |
And I press start
And I press button "tkomplettrueck" in row 1
And I press button "fertig"
And I close the current editor

Given I open an editor "RM1_PRUEF" from table "(Workorder):(CompletionConfirmations)" with command "VIEW" for search criteria "$,,such=BA_FLBASIS01_001;gutmge==50;bdeobjekt<>`;@ablage=abgelegt;@richtung=rückwärts;@maxordtreffer=1"
And I close the current editor

Given I open an editor "Auftragszeit" via ID from editor "RM1_PRUEF" from field "bdeobjekt" in row 0 for table "(PDC):(OrderTime)" with command "VIEW"
Then field "korr" has value "0.5"
And I close the current editor
