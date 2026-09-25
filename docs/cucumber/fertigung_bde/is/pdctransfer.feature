@persistent
Feature: pdctransfer.feature
# *****************************************************************************
#  Name             : pdctransfer
#  Autor            : tiwe
#  Verantwortlich   : teaminfosysteme
#  Kontrolle        : cl
#  Funktion         : Testet das Infosystem PDCTRANSFER. Buchen von Personalzeiten, Auftragszeiten und Kurzlaeufern.
#
# *****************************************************************************

# letzter Test: 
# 01 PRODLIST hat keine Betriebsauftraege fuer den Testartikel
Background:
Given I set the fake date to "12.01.1995" 
Scenario: 1 BDE-Objekte uebertragen
Given I open the infosystem "PRODLIST"
And I set field "kart" to "BG3-BDE"
And I set field "bba" to "ja"
Then I press start
Then the table has 0 rows
And I close the current editor
#
# 02 PDCTRANSFER und WORKLIST starten, es gibt keine Objekte zum uebertragen
Given I open the infosystem "PDCTRANSFER"
And I press start
Then the table has 0 rows 
And I close the current editor
#
# WORKLIST starten 
Given I open the infosystem "WORKLIST"
And I set field "mitarb" to "SCHNEID" 
And I set field "mgr" to "MGR1"
And I set field "endegepl" to ""
And I press start
Then the table has 0 rows
And I close the current editor
#
# 03 FV anlegen fuer BG mit 3 AGs und freigeben
Given I open an editor "fvor_BDE1" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
And I append rows
    | artikel        | netmge     | bisuch    | mfreig    |
    | BG3-BDE        | 100        | BDE1_   | ja        |
And I press button "freig" to open a subeditor for "BA_freigeben"
And I close the current editor
And I switch the current editor to editor "fvor_BDE1"
And I save the current editor
#
# Jetzt ist BA da
Given I open the infosystem "PRODLIST"
And I set field "kart" to "BG3-BDE"
And I set field "bba" to "ja"
Then I press start
Then the table has 1 rows
And I close the current editor
#
# 04 RM auf den ersten und zweiten AG, damit eine Nummer haben
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
# 05 WORKLIST unbearbeiteter Arbeitsschein, 2 Auftragszeiten an und abstempeln
Given I open the infosystem "WORKLIST"
And I set field "mitarb" to "SCHNEID" 
And I set field "mgr" to "MGR1"
And I set field "endegepl" to ""
And I set field "durchbuchen" to "nein"
And I press start
Then the table has 1 rows
#
And I press button "tproduktion" in row 1
And I press button "trueckmeld" in row 1
And I set field "istmge" to "10"
And I press button "fertig"
#
And I press button "tproduktion" in row 1
And I press button "trueckmeld" in row 1
And I set field "istmge" to "20"
And I press button "fertig"
Then field "tofmge" has value "70" in row 1
Then field "tfortschritt" has value "30" in row 1
And I close the current editor
#
# 06 WORKLIST unbearbeiteter Arbeitsschein, 1 Kurzlaeufer melden
Given I open the infosystem "WORKLIST"
And I set field "mitarb" to "MACHNIX" 
And I set field "mgr" to "MGR2"
And I set field "endegepl" to ""
And I set field "durchbuchen" to "nein"
And I press start
Then the table has 1 rows
And I press button "tkurzlauf" in row 1
And I set field "istmge" to "30"
And I press button "fertig"
Then field "tofmge" has value "70" in row 1
And I close the current editor

# 07 Anwesenheit melden
Given I open an editor "Personalzeit" from table "(PDC):(TimeAndLaborData)" with command "NEW" for record ""
And I set fields
    | ma        |MACHNIX|
    | anfdat    | .     |
    | anfzeit   | 8:00  |
    | enddat    | .     |
    | endzeit   | 16:00 |
And I save the current editor
#
#
# 8.1 PDCTRANSFER starten, Selektion ueber Arbeitsschein mit einem Arbeitsschein
Given I open the infosystem "PDCTRANSFER"
And I set field "aschein" to "BDE1_001"
And I set field "transfer" to "ja"
And I press start
# eine Personalzeit wird gefunden
# und 2 Auftragszeiten für den Arbeitsschein BDE_001
Then the table has 2 rows
And I save the current editor
#
# 8.2 PDCTRANSFER starten 3 Zeilen, Selektion ueber Arbeitsschein mit einem BA
# in Feld  aschein die BA-Nummer eingeben
Given I open the infosystem "PDCTRANSFER"
And I set field "aschein" to "BDE1_000"
And I set field "transfer" to "ja"
And I press start
# 3 Zeilen: 2 Auftragszeiten , ein Kurlaeufer
Then the table has 3 rows
Then table has values
    | ttyp           |  tistmge    | tstatusbde     |tstatusrm       |
    | icon:clock     | 10          | icon:lock_open | icon:lock_open |
    | icon:clock     | 20          | icon:lock_open | icon:lock_open |
    | icon:alarmclock| 30          | icon:lock_open | icon:lock_open | 
And I save the current editor
#
# 09 PDCTRANSFER starten, 4 Zeilen:
# Zeile 1: Personalzeit
# Zeile 2 und 3: Auftragszeit
# Zeile 4: Kurzlaeufer
Given I open the infosystem "PDCTRANSFER"
And I press start
Then the table has 4 rows
Then table has values
    | ttyp           |  tistmge    | tstatusbde     |tstatusrm       |
    | icon:user      | 0           | icon:lock_open |                |
    | icon:clock     | 10          | icon:lock_open | icon:lock_open |
    | icon:clock     | 20          | icon:lock_open | icon:lock_open |
    | icon:alarmclock| 30          | icon:lock_open | icon:lock_open |   
#
Then I press button "allean"
Then I press button "uebertragen"
Then table has values
    | ttyp           | tistmge    | tstatusbde     |tstatusrm       |
    | icon:user      | 0          | icon:ok        |                |
    | icon:clock     | 10         | icon:ok        | icon:ok        |
    | icon:clock     | 20         | icon:ok        | icon:ok        |
    | icon:alarmclock| 30         | icon:ok        | icon:ok        | 
And I press start
Then the table has 0 rows 
And I close the current editor
#
# 10 BA Stornieren
Given I open an editor "BA" from table "(Workorder):(WorkOrders)" with command "UPDATE" for record "BDE1_000"
And I respond with answer "ja" to the dialog with id "1483"
And I set field "status" to "S"
And I save the current editor


Scenario: BDE-Objekte durchbuchen oder ungebuchte Rueckmeldungen erstellen ueber PDCTRANSFER

Given I create a work order "WO1_" for Product "BG3-BDE" with quantity "10" and search word "WO1_"
Given I create a work order "WO2_" for Product "BG3-BDE" with quantity "10" and search word "WO2_"
Given I create a work order "WO3_" for Product "BG3-BDE" with quantity "10" and search word "WO3_"

# ungebuchte Auftragszeiten anlegen
Given I open the infosystem "WORKLIST"
And I set fields
    | mitarb        | SCHNEID   |
    | mgr           | MGR1      |
    | endegepl      |           |
    | durchbuchen   | nein      |
And I press start

And I press button "tproduktion" in row 1
And I press button "trueckmeld" in row 1
And I set field "istmge" to "5"
And I press button "fertig"

And I press button "tproduktion" in row 1
And I press button "trueckmeld" in row 1
And I set field "istmge" to "2"
And I press button "fertig"

And I press button "tproduktion" in row 3
And I press button "trueckmeld" in row 3
And I set field "istmge" to "1"
And I press button "fertig"
And I close the current editor

# WORKLIST 1 Kurzlaeufer melden
Given I open the infosystem "WORKLIST"
And I set fields
    | mitarb        | MACHNIX   |
    | mgr           | MGR2      |
    | endegepl      |           |
    | durchbuchen   | nein      |
And I press start
And I press button "tkurzlauf" in row 1
And I set field "istmge" to "5"
And I press button "fertig"
And I close the current editor

Given I open the infosystem "WORKLIST"
And I set fields
    | mitarb        | SCHNEID   |
    | mgr           | MGR2      |
    | endegepl      |           |
    | durchbuchen   | nein      |
And I press start
And I press button "tkurzlauf" in row 1
And I set field "istmge" to "1"
And I press button "fertig"
And I close the current editor

Given I open an editor "Personalzeit" from table "(PDC):(TimeAndLaborData)" with command "NEW" for record ""
And I set fields
    | ma        | MACHNIX |
    | anfdat    | .       |
    | anfzeit   | 16:30   |
    | enddat    | .       |
    | endzeit   | 17:00   |
And I save the current editor

# ungebuchte Rueckmeldung anlegen, ohne BDE-Objekt
Given I open an editor "Rückmeldung1" from table "(Workorder):(WorkOrders)" with command "DONE" for record "WO3_001"
And I set field "sofort" to "nein"
And I set field "gutmge" to "2" in row 1
And I save the current editor

Given I open the infosystem "PDCTRANSFER"
And I press start
Then field "rmbuchen" has value "ja"
Then the table has 6 rows
Then table has values
    | ttyp              |  tistmge    | tstatusbde     |tstatusrm       |
    | icon:user         | 0           | icon:lock_open |                |
    | icon:clock        | 5           | icon:lock_open | icon:lock_open |
    | icon:clock        | 2           | icon:lock_open | icon:lock_open |
    | icon:clock        | 1           | icon:lock_open | icon:lock_open |
    | icon:alarmclock   | 5           | icon:lock_open | icon:lock_open |
    | icon:alarmclock   | 1           | icon:lock_open | icon:lock_open |
Then field "tfehler" has value "icon:flash" in row 4
Then field "tuebertragen" is not modifiable in row 4
# 8808 Nicht gebuchte Rückmeldung vorher übernehmen.
#Then pressing button "tfehler" in row 4 throws the exception "8808"
Then fields in table are modifiable
    | tuebertragen  | trmbuchen  |
    | ja            | nein       |
    | ja            | nein       |
    | ja            | nein       |
    | nein          | nein       |
    | ja            | nein       |
And I press button "allean"
# Personalzeit (Zeile 1) kann gebucht werden, aber es wird keine Rueckmeldung gebucht und Zeile 4 kann wegen ungebuchter Rueckmeldung nicht gebucht werden
Then table has values
    | ttyp              | tuebertragen  | trmbuchen  | tfehler     | taschein^such |
    | icon:user         | ja            | nein       |             |               |
    | icon:clock        | ja            | ja         |             | WO1_001       |
    | icon:clock        | ja            | ja         |             | WO1_001       |
    | icon:clock        | nein          | nein       | icon:flash  | WO3_001       |
    | icon:alarmclock   | ja            | ja         |             | WO1_002       |
    | icon:alarmclock   | ja            | ja         |             | WO1_002       |
# neue Funktion: Rueckmeldung buchen auf nein setzen
And I set field "rmbuchen" to "nein"
And I press start
Then fields in table are modifiable
    | tuebertragen  | trmbuchen  |
    | ja            | nein       |
    | ja            | nein       |
    | ja            | nein       |
    | nein          | nein       |
    | ja            | nein       |
    | ja            | nein       |
# zum gleichen Arbeitsschein darf nur eine ungebuchte Rueckmeldung angelegt werden, egal ob Auftragszeit oder Kurzlaeufer
And I set field "tuebertragen" to "ja" in row 2
Then field "trmbuchen" has value "nein" in row 2
Then field "tuebertragen" is not modifiable in row 3
Then field "tfehler" has value "icon:process" in row 3
And I set field "tuebertragen" to "ja" in row 5
Then field "trmbuchen" has value "nein" in row 5
Then field "tuebertragen" is not modifiable in row 6
Then field "tfehler" has value "icon:process" in row 6
And I close the current editor

# ungebuchte Rueckmeldung buchen
Given I open an editor "RM_buchen" from table "(Workorder):(WorkOrders)" with command "TRANSFER" for search criteria "$,,such=WO3_001;@ablageart=lebendig;@richtung=rückwärts;@maxtreffer=1"
And I save the current editor

# Schichtplan entfernen bei Mitarbeiter MACHNIX
Given I open an editor "MACHNIX" from table "(Employee):(Employee)" with command "UPDATE" for record "MACHNIX"
And I set field "splan" to ""
And I save the current editor

# PDCTRANSFER aufrufen
Given I open the infosystem "PDCTRANSFER"
And I press start
Then field "rmbuchen" has value "ja"
Then the table has 6 rows
Then table has values
    | ttyp           |  tistmge    | tstatusbde     |tstatusrm       | tmitarb^such | tfehler                   |
    | icon:user      | 0           | icon:lock_open |                | MACHNIX      |                           |
    | icon:clock     | 5           | icon:lock_open | icon:lock_open | SCHNEID      |                           |
    | icon:clock     | 2           | icon:lock_open | icon:lock_open | SCHNEID      |                           |
    | icon:clock     | 1           | icon:lock_open | icon:lock_open | SCHNEID      |                           |
    | icon:alarmclock| 5           | icon:lock_open | icon:lock_open | MACHNIX      | icon:preferences_disabled |
    | icon:alarmclock| 1           | icon:lock_open | icon:lock_open | SCHNEID      |                           |
# es gibt keine ungebuchte Rueckmeldung mehr, kein Fehler-Icon in Zeile 4
Then field "tuebertragen" is modifiable in row 4
# Zeile 5 Mitarbeiter MACHNIX hat keinen Schichtplan, deshalb Fehler-Icon und Feld "Rückmeldung buchen" nicht auswählbar
Then field "tuebertragen" is not modifiable in row 5
And I close the current editor

# Schichtplan wieder eintragen bei Mitarbeiter MACHNIX
Given I open an editor "MACHNIX" from table "(Employee):(Employee)" with command "UPDATE" for record "MACHNIX"
And I set field "splan" to "SPEINFACH"
And I save the current editor

# wenn Rueckmeldung buchen nicht vorbelegt ist, dann kann zum gleichen Arbeitsschein nur 1 BDE-Objekt gebucht werden, da es nur 1 ungebuchte Rueckmeldung geben darf
Given I open the infosystem "PDCTRANSFER"
And I set field "mitarb" to "SCHNEID"
And I set field "rmbuchen" to "nein"
And I press start
Then table has values
    | ttyp           |  tistmge    | tstatusbde     |tstatusrm       | tmitarb^such | tfehler   |
    | icon:clock     | 5           | icon:lock_open | icon:lock_open | SCHNEID      |           |
    | icon:clock     | 2           | icon:lock_open | icon:lock_open | SCHNEID      |           |
    | icon:clock     | 1           | icon:lock_open | icon:lock_open | SCHNEID      |           |
Then fields in table are modifiable
    | tuebertragen  | trmbuchen  |
    | ja            | nein       |
    | ja            | nein       |
    | ja            | nein       |
And I set field "tuebertragen" to "ja" in row 1
Then field "tuebertragen" is not modifiable in row 2
And I set field "tuebertragen" to "nein" in row 1
Then field "tuebertragen" is modifiable in row 2
And I press button "alleab"
And I press button "allean"
Then fields in table are modifiable
    | tuebertragen  | trmbuchen  |
    | ja            | nein       |
    | nein          | nein       |
    | ja            | nein       |
Then table has values
    | tuebertragen  | trmbuchen  |
    | ja            | nein       |
    | nein          | nein       |
    | ja            | nein       |
And I set field "mitarb" to ""
And I set field "rmbuchen" to "nein"
And I press start
And I press button "allean"
Then fields in table are modifiable
    | tuebertragen  | trmbuchen  |
    | ja            | nein       |
    | ja            | nein       |
    | nein          | nein       |
    | ja            | nein       |
    | ja            | nein       |
    | nein          | nein       |
Then table has values
    | tuebertragen  | trmbuchen  | tmitarb^such |
    | ja            | nein       | MACHNIX      |
    | ja            | nein       | SCHNEID      |
    | nein          | nein       | SCHNEID      |
    | ja            | nein       | SCHNEID      |
    | ja            | nein       | MACHNIX      |
    | nein          | nein       | SCHNEID      |
And I set field "tuebertragen" to "nein" in row 5
Then field "tuebertragen" is modifiable in row 6
And I press button "uebertragen"
And I press start
Then the table has 3 rows
Then table has values
    | tuebertragen  | trmbuchen  | tmitarb^such |
    | nein          | nein       | SCHNEID      |
    | nein          | nein       | MACHNIX      |
    | nein          | nein       | SCHNEID      |
And I close the current editor
# Aufraeumen von Scenario 2
# ungebuchte Rueckmeldung buchen
Given I open an editor "RM_buchen" from table "(Workorder):(WorkOrders)" with command "TRANSFER" for search criteria "$,,such=WO1_001;@ablageart=lebendig;@richtung=rückwärts;@maxtreffer=1"
And I save the current editor
Given I open an editor "RM_buchen" from table "(Workorder):(WorkOrders)" with command "TRANSFER" for search criteria "$,,such=WO3_001;@ablageart=lebendig;@richtung=rückwärts;@maxtreffer=1"
And I save the current editor

# BDE-Objekte übertragen
Given I open the infosystem "PDCTRANSFER"
And I press start
Then the table has 3 rows
And I press button "allean"
And I press button "uebertragen"
And I press start
Then the table has 0 rows
And I close the current editor

# 10 BA Stornieren
Given I open an editor "BA2" from table "(Workorder):(WorkOrders)" with command "UPDATE" for record "WO1_000"
And I respond with answer "ja" to the dialog with id "1483"
And I set field "status" to "S"
And I save the current editor

Given I open an editor "BA3" from table "(Workorder):(WorkOrders)" with command "UPDATE" for record "WO2_000"
And I respond with answer "ja" to the dialog with id "345"
And I set field "status" to "S"
And I save the current editor

Given I open an editor "BA4" from table "(Workorder):(WorkOrders)" with command "UPDATE" for record "WO3_000"
And I respond with answer "ja" to the dialog with id "1483"
And I set field "status" to "S"
And I save the current editor

Given I open an editor "FV" from table "(Purchasing):(WorkOrderSuggestions)" with command "UPDATE" for record ""
And I set field "artikel" to "BG3-BDE"
And I press button "ladetab"
Then the table has 1 rows
And I set field "netmge" to "0" in row 1
And I save the current editor

Scenario: 3 Unterscheidung Modus Übertragen und Löschen

Given I open the infosystem "PDCTRANSFER"
Then field "transfer" has value "ja"
Then field "delete" has value "nein"
And I press start
Then the table has 0 rows
And I set field "delete" to "ja"
Then field "delete" has value "ja"
Then field "transfer" has value "nein"
And I press start
Then the table has 0 rows
And I close the current editor

Given I create a work order "BDE3_" for Product "BG3-BDE" with quantity "10" and search word "BDE3_"
    
Given I open the infosystem "WORKLIST"
And I set field "mitarb" to "SCHNEID" 
And I set field "mgr" to "MGR1"
And I set field "endegepl" to ""
And I set field "durchbuchen" to "ja"
And I press start
Then the table has 1 rows
And I press button "tproduktion" in row 1
And I press button "trueckmeld" in row 1
And I press button "fertig"
And I close the current editor
# Auftragszeit wurde sofort durchgebeucht, also nichts zum Übertragen oder Löschen im Infosystem PDCTRANSFER

Given I open the infosystem "PDCTRANSFER"
Then field "transfer" has value "ja"
Then field "delete" has value "nein"
And I press start
Then the table has 0 rows
And I set field "delete" to "ja"
Then field "delete" has value "ja"
Then field "transfer" has value "nein"
And I press start
Then the table has 0 rows
And I close the current editor

Given I open the infosystem "WORKLIST"
And I set field "mitarb" to "SCHNEID"
And I set field "mgr" to "MGR1"
And I set field "endegepl" to ""
#BDE-Objekte werden nicht durchgebucht, dann hat PDCTRANSFER etwas zu tun
And I set field "durchbuchen" to "nein"
And I press start
Then the table has 1 rows
And I press button "tproduktion" in row 1
And I press button "trueckmeld" in row 1
And I set field "istmge" to "1"
And I press button "fertig"
And I press button "tproduktion" in row 1
And I press button "trueckmeld" in row 1
And I set field "istmge" to "1"
And I press button "fertig"
# 2 vollständige Auftragszeiten auf AS BDE3_001
And I press button "tkurzlauf" in row 1
And I set field "istmge" to "1"
And I press button "fertig"
# 1 vollständiger Kurzläufer  auf AS BDE3_001
And I set field "mgr" to "MGR2"
And I press start
Then the table has 1 rows
And I press button "tproduktion" in row 1
# 1 nur angestempelte Auftragszeit auf AS BDE3_002, diese AZ kann nur gelöscht werden
And I close the current editor
Given I open the infosystem "PDCTRANSFER"
# Modus Übertragen, hier findet man nur die 3 vollständigen BDE-Objekte (2 AZ + 1 KL)
And I press start
Then the table has 3 rows
Then table has values
    | ttyp           |  tistmge    | tstatusbde     |tstatusrm       |  tmitarb^such |  taschein^such |
    | icon:clock     | 1           | icon:lock_open | icon:lock_open | SCHNEID       | BDE3_001       |
    | icon:clock     | 1           | icon:lock_open | icon:lock_open | SCHNEID       | BDE3_001       |
    | icon:alarmclock| 1           | icon:lock_open | icon:lock_open | SCHNEID       | BDE3_001       |
# nun Modus auf Löschen stellen, hier sieht man auch die nur angestemplete AZ
And I set field "delete" to "ja"
And I set field "mitarb" to "SCHNEID"
And I press start
Then the table has 4 rows
Then table has values
    | ttyp           |  tistmge   |  tmitarb^such |  taschein^such |
    | icon:clock     | 1          | SCHNEID       |  BDE3_001      |
    | icon:clock     | 1          | SCHNEID       |  BDE3_001      |
    | icon:clock     | 0          | SCHNEID       |  BDE3_002      |
    | icon:alarmclock| 1          | SCHNEID       |  BDE3_001      |
And I press button "tloeschen" in row 1
And I press button "tloeschen" in row 2
# Zeile 3 angestempelte AZ kann man momentan noch nicht löschen
And I press button "tloeschen" in row 4
Then the table has 4 rows
Then table has values
    | ttyp           |  tistmge   |  tmitarb^such |  taschein^such |  tstatusloeschen  |
    | icon:clock     | 1          | SCHNEID       |  BDE3_001      |  icon:ok          |
    | icon:clock     | 1          | SCHNEID       |  BDE3_001      |  icon:ok          |
    | icon:clock     | 0          | SCHNEID       |  BDE3_002      |                   |
    | icon:alarmclock| 1          | SCHNEID       |  BDE3_001      |  icon:ok          |
And I press start
Then the table has 1 rows
Then table has values
    | ttyp           |  tistmge   |  tmitarb^such |  taschein^such |  tstatusloeschen  |
    | icon:clock     | 0          | SCHNEID       |  BDE3_002      |                   |
    # Im Modus übertragen gibt es nun keine Zeilen mehr
And I set field "transfer" to "ja"
And I press start
Then the table has 0 rows
# Hier noch erweitern momentan kann man die angestempelte Auftragszeit noch nicht löschen
And I close the current editor
# nun noch Personalzeiten anlegen
Given I open an editor "Personalzeit" from table "(PDC):(TimeAndLaborData)" with command "NEW" for record ""
And I set fields
    | ma        |KAEPSELE|
    | anfdat    | .      |
    | anfzeit   | 8:00   |
    | enddat    | .      |
    | endzeit   | 16:00  |
And I save the current editor
Given I open an editor "Personalzeit" from table "(PDC):(TimeAndLaborData)" with command "NEW" for record ""
And I set fields
    | ma        |SCHNEID|
    | anfdat    | .     |
    | anfzeit   | 8:00  |
And I save the current editor
# 2 Personalzeiten: KAEPSELE hat vollständige PZ, SCHNEIDER hat nur angestempelte PZ
Given I open the infosystem "PDCTRANSFER"
# Modus übertragen 1 PZ ist zu übertragen
And I press start
Then the table has 1 rows
And I set field "delete" to "ja"
And I set field "mitarb" to "SCHNEID"
And I press start
# Diese Zeilen: angestempelte Auftragszeit und angestempelte Personalzeit kann man noch nicht löschen
Then the table has 2 rows
And I set field "mitarb" to "KAEPSELE"
And I press start
Then the table has 1 rows
    And I press button "tloeschen" in row 1
    Then table has values
    | ttyp           |  tistmge   |  tmitarb^such |  taschein^such |  tstatusloeschen  |
    | icon:user      |  0         | KAEPSELE      |                | icon:ok           |
# Nun ist nichts mehr zum Übertragen
And I set field "transfer" to "ja"
And I set field "mitarb" to ""
And I press start
Then the table has 0 rows
And I close the current editor

















