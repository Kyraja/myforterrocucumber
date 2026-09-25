@persistent
Feature: Storno-/Rueckgabezentrale ccwo
# Test des Infosystems CCWO
Background: 
Given I set the fake date to "05.01.1995"

# *****************************************************************************
#  Name             : ccwo.feature
#  Autor            : jbraun
#  Verantwortlich   : amk
#  Kontrolle        : drpf
#  Funktion         : Testet das Infosystem CCWO
#  Jira-Issue       : 
# *****************************************************************************

Scenario Outline: STAMMDATEN - Drei Komponenten anlegen
Given I open an editor "<such>" from table "(Part):(Product)" with command "STORE" for record "<such>"
And I set field "such" to "<such>"
And I set field "namebspr" to "<namebspr>"
And I save the current editor

Examples: Artikel
| such  | namebspr          | 
| Komp1 | Komponente 1 CCWO |
| Komp2 | Komponente 2 CCWO |
| Komp3 | Komponente 3 CCWO | 

Scenario:
Given I open an editor "Maschinengruppe" from table "(Capacity):(WorkCenter)" with command "STORE" for record "Masch333"
And I set field "such" to "Masch333"
And I set field "namebspr" to "Maschinengruppe 333"
And I set field "abtlg" to "10"
And I set field "kstelle" to "101"
And I save the current editor


Scenario Outline: Stammdaten - Drei Arbeitsgänge anlegen
Given I open an editor "<such>" from table "(Operation):(Operation)" with command "STORE" for record "<such>"
And I set field "such" to "<such>"
And I set field "namebspr" to "<namebspr>"
And I set field "mgr" to "Masch333"
And I set field "aschein" to "ja"
And I set field "lgr" to "1"
And I save the current editor

Examples: Artikel
| such  | namebspr           | 
| AS1   | Arbeitsgang 1 CCWO |
| AS2   | Arbeitsgang 2 CCWO |
| AS3   | Arbeitsgang 3 CCWO | 


Scenario: STAMMDATEN - Einen neuen Artikel anlegen
Given I open an editor "fertiguartikel1" from table "(Part):(Product)" with command "STORE" for record "fertiguartikel1"
And I set field "such" to "fertiguartikel1"
And I set field "namebspr" to "Fertigungsartikel 1"
And I set field "vkbez" to "Fertigungsartikel 1"
And I set field "vbez" to "Fertigungsartikel 1"
And I set field "ebez" to "Fertigungsartikel 1"
And I set field "vpr" to "200"
And I set field "bsart" to "Eigenfertigung"
And I set field "dispoa" to "bedarfsbezogen"
And I set field "elex" to "Komp1" in row 1
And I set field "elanzahl" to "1" in row 1
And I create a new row at the end of the table
And I set field "elex" to "A AS1" in row 2
And I set field "elanzahl" to "1" in row 2
And I create a new row at the end of the table
And I set field "elex" to "Komp2" in row 3
And I set field "elanzahl" to "1" in row 3
And I create a new row at the end of the table
And I set field "elex" to "A AS2" in row 4
And I set field "elanzahl" to "1" in row 4 
And I create a new row at the end of the table
And I set field "elex" to "Komp3" in row 5
And I set field "elanzahl" to "1" in row 5
And I create a new row at the end of the table
And I set field "elex" to "A AS3" in row 6
And I set field "elanzahl" to "1" in row 6
And I save the current editor

Scenario: STAMMDATEN - Einen neue Dienstleistung anlegen
Given I open an editor "Dienstleistung" from table "(Part):(Service)" with command "STORE" for record "DL-CCWO"
And I set field "such" to "DL-CCWO"
And I set field "namebspr" to "Dienstleistung"
And I set field "elex" to "Komp1" in row 1
And I set field "elanzahl" to "1" in row 1
And I create a new row at the end of the table
And I set field "elex" to "A AS1" in row 2
And I set field "elanzahl" to "1" in row 2
And I save the current editor

Scenario: Einen neuen Fertigungsvorschlag anlegen und freigeben
Given I open an editor "Fvor1" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record "" 
And I append rows                                            
    | artikel           | netmge    | bisuch  | mfreig    | binoloe     | projekt   |
    | fertiguartikel1   | 100       | TEST1_  | ja        | nein        | 111       |
    | fertiguartikel1   | 100       | TEST2_  | ja        | nein        |           |
    | fertiguartikel1   | 100       | TEST3_  | ja        | ja          |           |
    | fertiguartikel1   | 100       | TEST4_  | ja        | nein        |           |
    | fertiguartikel1   | 100       | TEST5_  | ja        | nein        |           |
    | fertiguartikel1   | 100       | TEST6_  | ja        | nein        |           |  
    | DL-CCWO           | 100       | TEST7_  | ja        | nein        |           | 
                                                             
And I press button "freig" to open a subeditor for "fertigung"
And I close the current editor
And I switch the current editor to editor "Fvor1"
And I save the current editor

Scenario Outline: Öffnen der Fertigungsvorschläge
Given I open an editor "<editor>" from table "(Workorder):(WorkOrders)" with command "VIEW" for record "<editor>"
And I close the current editor

Examples:
    | editor    |
    | TEST1_000 |
    | TEST2_000 |
    | TEST3_000 |
    | TEST4_000 |
    | TEST5_000 |
    | TEST6_000 |
    | TEST7_000 |    

    
####################################################
#              Betriebsauftraege                   #
####################################################
#                                                  #  
#   Testfall 1: es gibt einen bebuchten BA         #
#                                                  #
####################################################
# 1. AS volle Gutmenge 
Scenario: Rueckmeldebeleg erfassen
Given I open an editor "rueckmeld" from table "(Workorder):(WorkOrders)" with command "DONE" for record "TEST1_001"
And I set field "gut" to "ja"
And I set field "sofort" to "ja"
And I save the current editor

# 2. AS halbe Gutemenge + Zeit buchen
Scenario: Rueckmeldebeleg erfassen
Given I open an editor "rueckmeld2" from table "(Workorder):(WorkOrders)" with command "DONE" for record "TEST1_002"
And I set field "gutmge" to "55" in row 1
And I set field "verlustmge" to "1" in row 1
And I set field "bzeit" to "2"
And I set field "mzeit" to "3"
And I set field "sofort" to "ja"
And I set field "lgr" to "1"
And I save the current editor

#Pruefung Testfall 1
Scenario: Infosystem abfragen 1
Given I open the infosystem "CCWO" 
And I set field "banr" to "nummer" from editor "TEST1_000" 
And I press button "bstart"
Then the table has 4 rows
Then table has values
    | zeit       | komponente         | gutmge | mge  | verlustmge | tprojekt    |
    |            | icon:cubes_yellow  | 100    | 0    |    0       | TESTPROJEKT |
    |            |                    | 0      | 100  |    0       |             |
    | icon:clock | icon:cubes_yellow  | 55     | 0    |    1       | TESTPROJEKT |
    |            |                    | 0      | 56   |    0       |             |


####################################################
#                                                  #  
#   Testfall 2: Es wird durcheinander gebucht      #
#                                                  #
####################################################

# RM auf BA halbe Gutmenge 
Scenario: Rueckmeldebeleg erfassen
Given I open an editor "rueckmeld3" from table "(Workorder):(WorkOrders)" with command "DONE" for record "TEST2_000"
And I set field "mgr" to "Masch333"
And I set field "gutmge" to "50" in row 1
And I set field "sofort" to "ja"
And I save the current editor

# 1. AS volle Gutmenge buchen
Scenario: Rueckmeldebeleg erfassen
Given I open an editor "rueckmeld4" from table "(Workorder):(WorkOrders)" with command "DONE" for record "TEST2_001"
And I set field "gut" to "ja"
And I set field "sofort" to "ja"
And I save the current editor

# 2. AS halbe Gutmenge & Zeit buchen 
Scenario: Rueckmeldebeleg erfassen
Given I open an editor "rueckmeld5" from table "(Workorder):(WorkOrders)" with command "DONE" for record "TEST2_002"
And I set field "gutmge" to "50" in row 1
And I set field "bzeit" to "2"
And I set field "mzeit" to "3"
And I set field "lgr" to "1"
And I set field "sofort" to "ja"
And I save the current editor

#Pruefung Testfall 2
Scenario: Infosystem abfragen 2
Given I open the infosystem "CCWO" 
And I set field "banr" to "nummer" from editor "TEST2_000" 
And I press button "bstart"
Then the table has 8 rows
Then table has values
    | zeit         | komponente          | fertigprodukt      | gutmge | mge  | artikel         |
    |              | icon:cubes_yellow   | icon:cube_yellow   | 50     | 0    |                 |
    |              |                     |                    | 0      | 50   | KOMP1           |
    |              |                     |                    | 0      | 50   | KOMP2           |
    |              |                     |                    | 0      | 50   | KOMP3           |
    |              |                     |                    | 0      | 50   | FERTIGUARTIKEL1 |
    |              | icon:cubes_yellow   |                    | 100    | 0    |                 |
    |              |                     |                    | 0      | 50   | KOMP1           |
    | icon:clock   |                     |                    | 50     | 0    |                 |


####################################################
#                                                  #  
#  Testfall 3: Materialentnahme und Rueckmeldungen #
#                                                  #
####################################################

# Materialentnahme auf BA volle Entnahme
Scenario: Rueckmeldebeleg erfassen
Given I open an editor "Materialentnahme" for tip command "Fbuchung" and arguments ""
And I set field "autorment" to "ja"
And I set field "auftrag" to "nummer" from editor "TEST3_000"
And I press button "stllad"
And I set field "mgr" to "Masch333"
And I save the current editor

# 1. AS volle Gutmenge & Zeit buchen
Scenario: Rueckmeldebeleg erfassen
Given I open an editor "rueckmeld6" from table "(Workorder):(WorkOrders)" with command "DONE" for record "TEST3_001"
And I set field "gut" to "ja"
And I set field "bzeit" to "4"
And I set field "mzeit" to "5"
And I set field "lgr" to "1"
And I set field "sofort" to "ja"
And I save the current editor

# 3. AS volle Gutmenge & Zeit buchen
Scenario: Rueckmeldebeleg erfassen
Given I open an editor "rueckmeld7" from table "(Workorder):(WorkOrders)" with command "DONE" for record "TEST3_003"
And I set field "gut" to "ja"
And I set field "bzeit" to "4"
And I set field "mzeit" to "5"
And I set field "lgr" to "1"
And I set field "sofort" to "ja"
And I save the current editor

#Pruefung Testfall 3
Scenario: Infosystem abfragen 3
Given I open the infosystem "CCWO" 
And I set field "banr" to "nummer" from editor "TEST3_000"
And I press button "bstart"
Then the table has 7 rows
Then table has values
    | zeit         | komponente          | fertigprodukt      | gutmge | mge  | artikel         |
    |              | icon:cubes_yellow   |                    | 0      | 0    |                 |
    |              |                     |                    | 0      | 100  | KOMP1           |
    |              |                     |                    | 0      | 100  | KOMP2           |
    |              |                     |                    | 0      | 100  | KOMP3           |
    | icon:clock   |                     |                    | 100    | 0    |                 |
    | icon:clock   |                     | icon:cube_yellow   | 100    | 0    |                 |
    |              |                     |                    | 0      | 100  | FERTIGUARTIKEL1 |


####################################################
#                                                  #  
#   Testfall 4: Storno Rueckmeldung                #
#                                                  #
####################################################

# 1. AS Rueckmeldung mit viel zu hoher Zeit buchen
Scenario: Rueckmeldebeleg erfassen
Given I open an editor "rueckmeld7" from table "(Workorder):(WorkOrders)" with command "DONE" for record "TEST4_001"
And I set field "bzeit" to "20"
And I set field "mzeit" to "30"
And I set field "lgr" to "1"
And I set field "sofort" to "ja"
And I save the current editor

# 1. RM Stornieren
Given I open an editor "Storno1" from table "(Workorder):(CompletionConfirmations)" with command "REVERSAL" for search criteria "$,,such=TEST4_001;@richtung=rueckwärts;@ablageart=abgelegt;@maxtreffer=1;typa279=Rueckmeldung"
And I save the current editor

# 1. AS korrekte RM mit der richtigen Zeit
Scenario: Rueckmeldebeleg erfassen
Given I open an editor "rueckmeld8" from table "(Workorder):(WorkOrders)" with command "DONE" for record "TEST4_001"
And I set field "bzeit" to "5"
And I set field "mzeit" to "5"
And I set field "lgr" to "1"
And I set field "sofort" to "ja"
And I save the current editor

#Pruefung Testfall 4
Scenario: Infosystem abfragen 4
Given I open the infosystem "CCWO" 
And I set field "banr" to "nummer" from editor "TEST4_000" 
And I press button "bstart"
Then the table has 3 rows
Then table has values
    | zeit         | komponente       | fertigprodukt | typ                    | gutmge | mge  | artikel     |
    | icon:clock   |                  |               | Stornierte Rückmeldung | 0      | 0    |             |
    | icon:clock   |                  |               | Storno-Rückmeldung     | 0      | 0    |             |
    | icon:clock   |                  |               | Rückmeldung            | 0      | 0    |             |

####################################################
#                                                  #  
#   Testfall 5: Volle Gutmenge buchen              #
#                                                  #
####################################################

# RM auf BA volle Gutmenge 
Scenario: Rueckmeldebeleg erfassen
Given I open an editor "rueckmeld9" from table "(Workorder):(WorkOrders)" with command "DONE" for record "TEST5_000"
And I set field "mgr" to "Masch333"
And I set field "gut" to "ja"
And I set field "sofort" to "ja"
Then field "barmex" has value "1005" 
Then field "gutmge" has value "100" in row 1
And I save the current editor

# Pruefung Testfall 5
Scenario: Infosystem abfragen 5
Given I open the infosystem "CCWO" 
And I set field "banr" to "1005"  
Then field "ablage" has value "ja" 
And I press button "bstart"
Then the table has 6 rows
Then table has values
    | zeit         | komponente          | fertigprodukt      | gutmge | mge  | artikel         |
    |              | icon:cubes_yellow   | icon:cube_yellow   | 100    | 0    |                 |
    |              |                     |                    | 0      | 100  | KOMP1           |
    |              |                     |                    | 0      | 100  | KOMP2           |
    |              |                     |                    | 0      | 100  | KOMP3           |
    |              |                     |                    | 0      | 100  | FERTIGUARTIKEL1 |
    |              |                     |                    | 0      | 0    |                 |
And I close the current editor	
########################################################################
#                                                                      #  
#   Testfall 6: Rückmeldungen sind sortiert nach den Erstellungsdatum  #
#                                                                      #
########################################################################    
# 1. AS volle Gutmenge + Datum heute
Scenario: Rueckmeldebeleg erfassen
Given I open an editor "rueckmeld10" from table "(Workorder):(WorkOrders)" with command "DONE" for record "TEST6_001"
And I set field "gut" to "ja"
And I set field "sofort" to "ja"
And I set field "vom" to "."
And I save the current editor
# 1. AS Datum gestern + Zeitmeldung
Given I open an editor "rueckmeld11" from table "(Workorder):(WorkOrders)" with command "DONE" for record "TEST6_001"
And I set field "bzeit" to "1"
And I set field "mzeit" to "1"
And I set field "lgr" to "1"
And I set field "sofort" to "ja"
And I set field "vom" to "-1"
And I save the current editor
# 1. AS Datum gestern + Zeitmeldung
Given I open an editor "rueckmeld12" from table "(Workorder):(WorkOrders)" with command "DONE" for record "TEST6_001"
And I set field "bzeit" to "2"
And I set field "mzeit" to "2"
And I set field "lgr" to "1"
And I set field "sofort" to "ja"
And I set field "vom" to "-1"
And I save the current editor
# 1. AS Datum gestern + Zeitmeldung
Given I open an editor "rueckmeld13" from table "(Workorder):(WorkOrders)" with command "DONE" for record "TEST6_001"
And I set field "bzeit" to "3"
And I set field "mzeit" to "3"
And I set field "lgr" to "1"
And I set field "sofort" to "ja"
And I set field "vom" to "-1"
And I save the current editor
# 1. AS Datum heute + Zeitmeldung
Given I open an editor "rueckmeld14" from table "(Workorder):(WorkOrders)" with command "DONE" for record "TEST6_001"
And I set field "bzeit" to "4"
And I set field "mzeit" to "4"
And I set field "lgr" to "1"
And I set field "sofort" to "ja"
And I set field "vom" to "."
And I save the current editor
# auf den BA heute + Zeitmeldung
Given I open an editor "rueckmeld15" from table "(Workorder):(WorkOrders)" with command "DONE" for record "TEST6_000"
And I set field "bzeit" to "1"
And I set field "mzeit" to "1"
And I set field "lgr" to "1"
And I set field "sofort" to "ja"
And I set field "vom" to "."
And I set field "mgr" to "1"
And I save the current editor
# auf den BA gestern + Zeitmeldung
Given I open an editor "rueckmeld16" from table "(Workorder):(WorkOrders)" with command "DONE" for record "TEST6_000"
And I set field "bzeit" to "2"
And I set field "mzeit" to "2"
And I set field "lgr" to "1"
And I set field "sofort" to "ja"
And I set field "vom" to "-1"
And I set field "mgr" to "1"
And I save the current editor
# Pruefung Testfall 6
Scenario: Infosystem abfragen 6
Given I open the infosystem "CCWO" 
And I set field "banr" to "1006"
And I press button "bstart"
Then the table has 8 rows 
Then table has values
 | rueckmeldung | zeit       | komponente        | fertigprodukt | vom      | gutmge  | objekt       |
 | +1006        | icon:clock |                   |               | 04.01.95 |   0     | icon:text    |
 | +1006        | icon:clock |                   |               | 05.01.95 |   0     | icon:text    |
 | +1006001     | icon:clock |                   |               | 04.01.95 |   0     | icon:text    |
 | +1006001     | icon:clock |                   |               | 04.01.95 |   0     | icon:text    |
 | +1006001     | icon:clock |                   |               | 04.01.95 |   0     | icon:text    |
 | +1006001     |            | icon:cubes_yellow |               | 05.01.95 | 100     | icon:text    |
 |              |            |                   |               |          |   0     | icon:process |
 | +1006001     | icon:clock |                   |               | 05.01.95 |   0     | icon:text    |

And I save the current editor

Given I open the infosystem "CCWO" 
And I set field "banr" to "1006"
And I set field "kvom" to "04.01.95"
And I set field "kbis" to "05.01.95"
And I press button "bstart"
Then the table has 8 rows 
Then table has values
 | rueckmeldung | zeit       | komponente        | fertigprodukt | vom      | gutmge  | objekt       |
 | +1006        | icon:clock |                   |               | 04.01.95 |   0     | icon:text    |
 | +1006        | icon:clock |                   |               | 05.01.95 |   0     | icon:text    |
 | +1006001     | icon:clock |                   |               | 04.01.95 |   0     | icon:text    |
 | +1006001     | icon:clock |                   |               | 04.01.95 |   0     | icon:text    |
 | +1006001     | icon:clock |                   |               | 04.01.95 |   0     | icon:text    |
 | +1006001     |            | icon:cubes_yellow |               | 05.01.95 | 100     | icon:text    |
 |              |            |                   |               |          |   0     | icon:process |
 | +1006001     | icon:clock |                   |               | 05.01.95 |   0     | icon:text    |

And I save the current editor

Given I open the infosystem "CCWO" 
And I set field "banr" to "1006"
And I set field "kvom" to "04.01.95"
And I set field "kbis" to "04.01.95"
And I press button "bstart"
Then the table has 4 rows 
Then table has values
 | rueckmeldung | zeit       | komponente        | fertigprodukt | vom      | gutmge  | objekt       |
 | +1006        | icon:clock |                   |               | 04.01.95 |   0     | icon:text    |
 | +1006001     | icon:clock |                   |               | 04.01.95 |   0     | icon:text    |
 | +1006001     | icon:clock |                   |               | 04.01.95 |   0     | icon:text    |
 | +1006001     | icon:clock |                   |               | 04.01.95 |   0     | icon:text    |

And I save the current editor

Given I open the infosystem "CCWO" 
And I set field "banr" to "1006"
And I set field "kvom" to "04.01.95"
And I press button "bstart"
Then the table has 8 rows 
Then table has values
 | rueckmeldung | zeit       | komponente        | fertigprodukt | vom      | gutmge  | objekt       |
 | +1006        | icon:clock |                   |               | 04.01.95 |   0     | icon:text    |
 | +1006        | icon:clock |                   |               | 05.01.95 |   0     | icon:text    |
 | +1006001     | icon:clock |                   |               | 04.01.95 |   0     | icon:text    |
 | +1006001     | icon:clock |                   |               | 04.01.95 |   0     | icon:text    |
 | +1006001     | icon:clock |                   |               | 04.01.95 |   0     | icon:text    |
 | +1006001     |            | icon:cubes_yellow |               | 05.01.95 | 100     | icon:text    |
 |              |            |                   |               |          |   0     | icon:process |
 | +1006001     | icon:clock |                   |               | 05.01.95 |   0     | icon:text    |

And I save the current editor

##########################################################################
#                                                                        #  
#   Testfall 7: Rückmeldungen auf einen Dienstleistungs-Betriebsauftrag  #
#                                                                        #
##########################################################################  
# auf den AS heute + Zeitmeldung
Given I open an editor "rueckmeld17" from table "(Workorder):(WorkOrders)" with command "DONE" for record "TEST7_001"
And I set field "bzeit" to "2"
And I set field "mzeit" to "2"
And I set field "lgr" to "1"
And I set field "sofort" to "ja"
And I set field "vom" to "."
And I save the current editor
# auf den AS gestern + Gutmenge
Given I open an editor "rueckmeld18" from table "(Workorder):(WorkOrders)" with command "DONE" for record "TEST7_001"
And I set field "gutmge" to "10" in row 1
And I set field "sofort" to "ja"
And I set field "vom" to "-1"
And I save the current editor
# auf den BA heute + Zeitmeldung
Given I open an editor "rueckmeld17" from table "(Workorder):(WorkOrders)" with command "DONE" for record "TEST7_000"
And I set field "bzeit" to "2"
And I set field "mzeit" to "2"
And I set field "lgr" to "1"
And I set field "sofort" to "ja"
And I set field "vom" to "."
And I set field "mgr" to "1"
And I save the current editor
# auf den BA gestern + Gutmenge
Given I open an editor "rueckmeld18" from table "(Workorder):(WorkOrders)" with command "DONE" for record "TEST7_000"
And I set field "gutmge" to "10" in row 1
And I set field "sofort" to "ja"
And I set field "vom" to "-1"
And I set field "mgr" to "1"
And I save the current editor

Scenario: Infosystem abfragen 7
# keine Materialabbuchung, da manuelle Entnahme bei Dienstleistung
Given I open the infosystem "CCWO" 
And I set field "service" to "DL-CCWO"
And I press button "bstart"
Then the table has 4 rows 
Then table has values
 | rueckmeldung | zeit       | komponente        | fertigprodukt | vom      | gutmge  | objekt       |
 | +1007001     |            |                   |               | 04.01.95 |   10    | icon:text    |
 | +1007        |            |                   |               | 04.01.95 |   10    | icon:text    |
 | +1007001     | icon:clock |                   |               | 05.01.95 |   0     | icon:text    |
 | +1007        | icon:clock |                   |               | 05.01.95 |   0     | icon:text    |
 And I save the current editor
 
 Given I open the infosystem "CCWO" 
And I set field "service" to "DL-CCWO"
And I set field "kvom" to "04.01.95"
And I set field "kbis" to "04.01.95"
And I press button "bstart"
Then the table has 2 rows 
Then table has values
 | rueckmeldung | zeit       | komponente        | fertigprodukt | vom      | gutmge  | objekt       |
 | +1007001     |            |                   |               | 04.01.95 |   10    | icon:text    |
 | +1007        |            |                   |               | 04.01.95 |   10    | icon:text    |
And I save the current editor


