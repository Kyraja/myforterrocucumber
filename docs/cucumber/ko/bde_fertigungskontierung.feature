# *****************************************************************************
#  Name           : bde_fertigungskontierung.feature             
#  Autor          : sih
#  Verantwortlich : sih
#  Kontrolle      : uo
#  Funktion       : Test des Uebertragens von BDE-Objekten                                                     
#                   fehlende Kostenobjekte                                                                           
#                   fehlende Fertigungskontengruppe
#  Info:            Anstatt die BDE-Objekte über das IS PDCTRANSFER zu buchen, kann in den Objekten
#                   direkt "sofort==ja" gesetzt werden.
#                   Gebuchte Personalzeiten erzeugen KEINE Rückmeldungen. 
#
#  Bug:             FDA-2386
#                   Daher fehlen zwei Rückmeldungen (1003001 und 1013001)
#
# *****************************************************************************
@persistent
Feature: ref_bde_fertigungskontierung_cu 
Background: 
# Zeitraum bzw. aktuelles GJ lt. GJ-Tabelle ist 99, auch im Vorgängertest ref_bde. Dort wird aber im Test mit 2002 gearbeitet.
Given I set the fake date to "31.01.99"

Scenario: 01 Stammdaten
# statistische Konten und Fertigungskontengruppe mit Kostenart "Lohn"
Given I open an editor "Konto" from table "(Account):(Account)" with command "COPY" for record "99900"
And I set field "nummer" to "88900"
And I set field "such" to "k88900"
And I save the current editor

Given I open an editor "Konto" from table "(Account):(Account)" with command "COPY" for record "99900"
And I set field "nummer" to "88910"
And I set field "such" to "k88910"
And I save the current editor

Given I open an editor "fk" from table "(ProductionAccountsGroup):(ProductionAccountsGroup)" with command "NEW" for record ""
And I set field "nummer" to "900"
And I set field "such" to "KFKONT"
And I append rows
    | fertigungskosten     | belast    | entlast   |
    | Lohn                 | 88900     | 88910     |
    | Fertigungskosten un  | 99800     | 99900     |
And I save the current editor

Given I open an editor "Kst2" from table "(Account):(CostCenter)" with command "COPY" for record "100"
And I set field "nummer" to "102"
And I set field "such" to "k102"
And I set field "fertkont" to "900"
And I save the current editor

Given I open an editor "Kst3" from table "(Account):(CostCenter)" with command "COPY" for record "100"
And I set field "nummer" to "103"
And I set field "such" to "k103"
And I save the current editor

Given I open an editor "ma" from table "(Employee):(Employee)" with command "COPY" for record "7801"
And I set field "nummer" to "7803"
And I set field "such" to "M7803"
And I set field "kstelle" to "102"
And I save the current editor

Given I open an editor "kapaz1" from table "(Capacity):(WorkCenter)" with command "UPDATE" for record "111"
And I set field "kstelle" to "103"
And I save the current editor

Given I open an editor "kapaz2" from table "(Capacity):(WorkCenter)" with command "UPDATE" for record "121"
And I set field "kstelle" to "103"
And I save the current editor

# Kostenverteiler
Given I open an editor "kostenverteiler-10" from table "(Account):(CostDistribution)" with command "NEW" for record ""
And I set field "nummer" to "10"
And I set field "such" to "kv"
And I create a new row at the end of the table
And I set field "kstelle" to "101" in row 1
And I set field "proz" to "10" in row 1
And I create a new row at the end of the table
And I set field "kstelle" to "100000" in row 2
And I set field "proz" to "5" in row 2
And I create a new row at the end of the table
And I set field "kstelle" to "100" in row 3
And I set field "proz" to "85" in row 3
And I save the current editor

# Mitarbeiter mit KV
Given I open an editor "ma-neu" from table "(Employee):(Employee)" with command "NEW" for record ""
And I set field "nummer" to "9999"
And I set field "such" to "ma9999"
And I set field "kstelle" to "10"
And I set field "lohn" to "4"
And I set field "splan" to "301"
And I save the current editor


# Personalzeiten
# Mitarbeiter ohne Kst
Given I open an editor "Personalzeit1" from table "(PDC):(TimeAndLaborData)" with command "NEW" for record ""
And I set field "ma" to "7801"
And I set fields
 | tplan   | 104 |
 | anfdat  | .   |
 | anfzeit | 8:00|
 | endzeit | +3  |
And I save the current editor

# Mitarbeiter mit Kst und dort Verweis auf Fertigungskontengruppe
Given I open an editor "Personalzeit2" from table "(PDC):(TimeAndLaborData)" with command "NEW" for record ""
And I set field "ma" to "7803"
And I set fields
 | tplan   | 102 |
 | anfdat  | .   |
 | anfzeit | 6:00|
 | endzeit |14:00|
And I save the current editor

# Was passiert mit übertragener Pesonalzeit in Bezug zur Rückmeldung? Es gibt keinen Bezug zur Rückmeldung.
# PDCTRANSFER starten, 2 Zeilen:
# Zeile 1 und 2: Personalzeit
Given I open the infosystem "PDCTRANSFER"
And I set field "az" to "nein"
And I set field "kl" to "nein"
And I set field "anfdat" to "."
And I set field "enddat" to "."
And I press start
Then the table has 2 rows
Then table has values
    | ttyp           | tnummer  |  tistmge    | tstatusbde     |tstatusrm       |
    | icon:user      |    44    |   0         | icon:lock_open |                |
    | icon:user      |    45    |   0         | icon:lock_open |                |
 #
Then I press button "allean"
Then I press button "uebertragen"
Then table has values
    | ttyp           | tnummer    | tistmge    | tstatusbde     |tstatusrm       |
    | icon:user      |    44      | 0          | icon:ok        |                |
    | icon:user      |    45      | 0          | icon:ok        |                |
And I press start
Then the table has 0 rows 
And I close the current editor


# Auftragszeit
# Mitarbeiter ohne Kst
Given I open an editor "AZ" from table "(PDC):(OrderTime)" with command "NEW" for record ""
And I set fields
 | ma        | 7801     |
 | asma      | 1003001 |
 | mgr       | 111     |
 | anfdat    | .       |
 | anfzeit   | 11:00   |
 | enddat    | .       |
 | endzeit   | 11:15   |
 | automzeit | ja      |
 | istmge    | 1,1     |
And I save the current editor

# Mitarbeiter mit Kst und dort Verweis auf Fertigungskontengruppe
Given I open an editor "AZ" from table "(PDC):(OrderTime)" with command "NEW" for record ""
And I set fields
 | ma        | 7803      |
 | asma      | 1005001 |
 | mgr       | 112     |
 | anfdat    | .       |
 | anfzeit   |  8:00   |
 | enddat    | .       |
 | endzeit   | 14:00   |
 | automzeit | ja      |
 | istmge    | 1,2     |
And I save the current editor

# PDCTRANSFER starten, 2 Zeilen:
# Zeile 1 und 2: Auftragszeit
Given I open the infosystem "PDCTRANSFER"
And I set field "pz" to "nein"
And I set field "kl" to "nein"
And I set field "anfdat" to "."
And I set field "enddat" to "."
And I press start
Then the table has 2 rows
Then table has values
    | ttyp           | tnummer  |  tistmge    | tstatusbde     |tstatusrm       |
    | icon:clock     |    46    |   1.1       | icon:lock_open |icon:lock_open  |
    | icon:clock     |    47    |   1.2       | icon:lock_open |icon:lock_open  |
 #
Then I press button "allean"
Then I press button "uebertragen"
Then table has values
    | ttyp           | tnummer    | tistmge    | tstatusbde     |tstatusrm       |
    | icon:clock     |    46      | 1.1        | icon:ok        |icon:ok         |
    | icon:clock     |    47      | 1.2        | icon:ok        |icon:ok         |
And I press start
Then the table has 0 rows 
And I close the current editor

# Kurzlaeufer
# Mitarbeiter ohne Kst
Given I open an editor "Kurzläufer" from table "(PDC):(ShortProductionOrder)" with command "NEW" for record ""
And I set fields
 | ma        | 7801    |
 | tnr       | 1       |
 | asma      | 1011001 |
 | mgr       | 121     |
 | automzeit | ja      |
 | anfdat    | .       |
 | anfzeit   | 10:16   |
 | istzeit   |  2      |
And I save the current editor 

# Mitarbeiter mit Kst und dort Verweis auf Fertigungskontengruppe
Given I open an editor "Kurzläufer" from table "(PDC):(ShortProductionOrder)" with command "NEW" for record ""
And I set fields
 | ma        | 7803    |
 | tnr       | 1       |
 | asma      | 1013001 |
 | mgr       | 122     |
 | automzeit | ja      |
 | anfdat    | .       |
 | anfzeit   |  6:16   |
 | istzeit   |  4      |
And I save the current editor 
# PDCTRANSFER starten, 2 Zeilen:
# Zeile 1 und 2: Kurzläufer
Given I open the infosystem "PDCTRANSFER"
And I set field "pz" to "nein"
And I set field "az" to "nein"
And I set field "anfdat" to "."
And I set field "enddat" to "."
And I press start
Then the table has 3 rows
Then table has values
    | ttyp                | tnummer  |  tistmge    | tstatusbde     |tstatusrm       |
    | icon:alarmclock     |    16    |  10         | icon:lock_open |icon:lock_open  |
    | icon:alarmclock     |    48    |   0         | icon:lock_open |icon:lock_open  |
    | icon:alarmclock     |    49    |   0         | icon:lock_open |icon:lock_open  |
#
Then I press button "allean"
Then I press button "uebertragen"
Then table has values
#
# Folge von FDA-161: 
# Fuer den Kurzlaeufer mit Nummer 16 gibt es noch ungebuchte Rueckmeldungen. Dies wird ueber den Blitz in der Fehler-Spalte angezeigt. In diesem Fall 
# kann die Auftragszeit nicht uebertragen werden.
# Das Feld "Auswahl" ist schreibgeschuetzt. Ueber den Button "Alle auswaehlen" kann diese Zeile auch nicht ausgewaehlt werden.
# Deswegen bleibt hier im Status-Feld das "offene Schloss" stehen.
# Vor FDA-161 gab es diese Plausis nicht. Es wurde erst beim uebertragen (durch die Kern-Logik) erkannt, dass es noch ungebuchte Rueckmeldungen gab.
# Dann konnte die Auftragszeit auch nicht uebertragen werden. Hier wurde dann im Status-Feld ein "Stop-Zeichen" angezeigt.
#
    | ttyp             | tnummer    | tistmge    | tstatusbde     |tstatusrm       |
    | icon:alarmclock  |    16      | 10         | icon:ok        |icon:ok         |
#   | icon:clock       |    38      | 0          | icon:ok        |icon:ok         |
#   | icon:clock       |    39      | 0          | icon:ok        |icon:ok         |
And I press start
Then the table has 0 rows
And I close the current editor

# Maschinengruppe: Kst leeren und Mgr verwenden
# Auftragszeit/Kurzläufer: MGR eintragen, die keine Kst enthält
Given I'm logged in with password "annette"
Given I enable the flag 71
#
Given I execute FOP "XDELKST"
#
Given I open an editor "AZ" from table "(PDC):(OrderTime)" with command "NEW" for record ""
And I set fields
 | ma        | 7801     |
 | asma      | 1003001 |
 | mgr       | 112     |
 | anfdat    | .       |
 | anfzeit   | 10:00   |
 | enddat    | .       |
 | endzeit   | 12:15   |
 | automzeit | ja      |
 | istmge    | 1,2     |
And I save the current editor
#
# PDCTRANSFER starten, 1 Zeile, Auftragszeit
# Auftragszeit 40: BDE-Objekt lässt sich buchen, RM nicht
Given I open the infosystem "PDCTRANSFER"
And I set field "pz" to "nein"
And I set field "kl" to "nein"
And I set field "anfdat" to "."
And I set field "enddat" to "."
And I press start
Then the table has 1 rows
Then table has values
    | ttyp           | tnummer  |  tistmge    | tstatusbde     |tstatusrm       |
    | icon:clock     |    50    |   1.2       | icon:lock_open |icon:lock_open  |
 #
Then I press button "allean"
Then I press button "uebertragen"
Then table has values
    | ttyp           | tnummer    | tistmge    | tstatusbde     |tstatusrm       |
    | icon:clock     |    50      | 1.2        | icon:ok        |icon:stop       |
And I press start
Then the table has 0 rows 
And I close the current editor
#
Given I open an editor "Kurzläufer" from table "(PDC):(ShortProductionOrder)" with command "NEW" for record ""
And I set fields
 | ma        | 7801    |
 | tnr       | 1       |
 | asma      | 1013001 |
 | mgr       | 112     |
 | automzeit | ja      |
 | anfdat    | .       |
 | anfzeit   | 10:30   |
 | istzeit   | 3       |
And I save the current editor 
#
# PDCTRANSFER starten, 1 Zeile, Kurzläufer
# Kurzläufer 41: BDE-Objekt lässt sich buchen, RM nicht. Reine Zeitbuchung. Rückmeldung bleibt unverbucht gespeichert.
#
# Mgr 122 darf keine Kst haben
#
Given I open the infosystem "PDCTRANSFER"
And I set field "pz" to "nein"
And I set field "az" to "nein"
And I set field "anfdat" to "."
And I set field "enddat" to "."
And I press start
Then the table has 1 rows
Then table has values
    | ttyp                | tnummer  |  tistmge    | tstatusbde     |tstatusrm       |
    | icon:alarmclock     |    51    |   0         | icon:lock_open |icon:lock_open  |

And I set field "tuebertragen" to "ja" in row 1
Then I press button "uebertragen"
Then table has values
    | ttyp             | tnummer    | tistmge    | tstatusbde     |tstatusrm       |
    | icon:alarmclock  |    51      | 0          | icon:ok        |icon:stop       |
And I press start
Then the table has 0 rows
#
And I close the current editor
#
# In der KOREKONF die Fertigungskontengruppe leeren 
# Auftragzeit/Kurzläufer - fehlende Kontierung
#
#
Given I'm logged in with password "annette"
Given I enable the flag 71
#
Given I execute FOP "XDELFKOGRP"
#
Given I disable the flag 71
Given I'm logged in with password "sy"

Scenario: 02 keine Standardfertigungskontengruppe
# folgende Kommandos müssen unter einem neuen Scenario ausgeführt werden, sonst kommt der Fehler
# "No exception occured but was expected!" Client-Umgebung hat noch nichts mitbekommen.

#  1535 de      |Standardkontierung, Steuerschlssel oder Buchungskreise fehlerhaft
Given opening an editor from table "(PDC):(OrderTime)" with command "NEW" for record "" throws the exception "1535"

Given opening an editor from table "(PDC):(ShortProductionOrder)" with command "NEW" for record "" throws the exception "1535"


Scenario: 03 Kostenrechnungskonfiguration ist inkonsistent: Fertigungskontengruppe fehlt

Given I open an editor "korekonf" from table "(CostType):(CostAccountingConfig)" with command "UPDATE" for record "korekonf"

# 2842 de      |Tragen Sie eine Fertigungskontengruppe ein.
Then saving the current editor throws the exception "2842"

# 2703 de      |Die Fertigungskontengruppe kann nicht als Standardfertigungskontengruppe genutzt werden.
Then setting field "fertkont" to "900" throws the exception "2703"

And I set field "fertkont" to "100"
And I save the current editor


Scenario: 04 Kostenobjekt in Abteilung/Maschinengruppe entfernen

Given I open an editor "kapaz1" from table "(Capacity):(Department)" with command "UPDATE" for record "1"
And I set field "kstelle" to ""
# 1415 de      |Bitte Kostenstelle oder Kostentr„ger eintragen
Then saving the current editor throws the exception "1415"
And I close the current editor

Given I open an editor "kapaz1" from table "(Capacity):(WorkCenter)" with command "UPDATE" for record "111"
And I set field "kstelle" to ""
# 1415 de      |Bitte Kostenstelle oder Kostentr„ger eintragen
Then saving the current editor throws the exception "1415"
And I close the current editor

Scenario: 05 MA 9999 (mit KV) in BDE-Objekten
# Personalzeit mit Mitarbeiter mit KV

Scenario: Ende
Given I open an editor "Personalzeit9999" from table "(PDC):(TimeAndLaborData)" with command "NEW" for record ""
And I set field "ma" to "9999"
And I set fields
 | tplan   | 104 |
 | anfdat  | .   |
 | anfzeit | 8:00|
 | endzeit | +3  |
 | sofort  | ja  |
And I save the current editor

# Auftragszeit mit Mitarbeiter mit KV
Given I open an editor "AZ9999" from table "(PDC):(OrderTime)" with command "NEW" for record ""
And I set fields
 | ma        | 9999    |
 | asma      | 1005001 |
 | mgr       | 111     |
 | anfdat    | .       |
 | anfzeit   | 11:00   |
 | enddat    | .       |
 | endzeit   | 11:15   |
 | automzeit | ja      |
 | istmge    | 1,1     |
 | sofort    | ja      |
And I save the current editor

# Kurzaeufer mit Mitarbeiter mit KV
Given I open an editor "Kurzläufer" from table "(PDC):(ShortProductionOrder)" with command "NEW" for record ""
And I set fields
 | ma        | 9999    |
 | tnr       | 1       |
 | asma      | 1011001 |
 | mgr       | 121     |
 | anfdat    | .       |
 | anfzeit   | 10:16   |
 | istzeit   |  2      |
 | automzeit | ja      |
 | sofort    | ja      |
And I save the current editor 


