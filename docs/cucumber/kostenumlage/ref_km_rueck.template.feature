# *****************************************************************************
#  Autor          : uo
#  Verantwortlich : uo
#  Kontrolle      : 
# *****************************************************************************
@persistent
Feature: BW2-1520 Kostenumlage rückführen 

Background:
Given I set the fake date to "25.01.2002"

# ---------------------------------------------------------------------------------------------
Scenario: eigentlicher rückführungstest für die kostenquellen 2 und 11
# ---------------------------------------------------------------------------------------------
# Given I'm logged in with password "sy"
Given I set the fake date to "25.01.2002"

# addk-aus-ek ## mit-mkv #Given I open an editor "ap-kopf" from table "(DataExport):(CallParameter)" with command "UPDATE" for record "59997"
# addk-aus-ek ## mit-mkv #And I create a new row at the end of the table
# addk-aus-ek ## mit-mkv #And I set field "zielaktion" to "Kopffeld setzen" in row !lastRow
# addk-aus-ek ## mit-mkv #And I set field "zielvar" to "yreskopfgl" in row !lastRow
# addk-aus-ek ## mit-mkv #And I set field "aufrwtyp" to "Kopffeld" in row !lastRow
# addk-aus-ek ## mit-mkv #And I set field "aufrwert" to "yreskopfgl" in row !lastRow
# addk-aus-ek ## mit-mkv #And I save the current editor

# addk-aus-ek ## mit-mkv #Given I open an editor "ap-kopf" from table "(DataExport):(CallParameter)" with command "UPDATE" for record "59998"
# addk-aus-ek ## mit-mkv #And I create a new row at the end of the table
# addk-aus-ek ## mit-mkv #And I set field "zielaktion" to "Tabellenfeld setzen" in row !lastRow
# addk-aus-ek ## mit-mkv #And I set field "zielvar" to "yrestabip2" in row !lastRow
# addk-aus-ek ## mit-mkv #And I set field "zielwerttyp" to "Aktuelle Zeile" in row !lastRow
# addk-aus-ek ## mit-mkv #And I set field "aufrwtyp" to "Tabellenfeld" in row !lastRow
# addk-aus-ek ## mit-mkv #And I set field "aufrwert" to "yrestabip2" in row !lastRow
# addk-aus-ek ## mit-mkv #And I save the current editor



# Given I open an editor "ap-kopf2" from table "(DataExport):(CallParameter)" with command "UPDATE" for record "59003"
# And I set field "zielaktion" to "Kopffeld setzen" in row !lastRow
# And I set field "zielvar" to "yreskopfgl" in row !lastRow
# And I set field "aufrwtyp" to "Kopffeld" in row !lastRow
# And I set field "aufrwert" to "yreskopfgl" in row !lastRow
# And I save the current editor


# ---------------------------------------------------------------------------------------------
Scenario: eigentlicher rückführungstest für die kostenquellen 2 und 11
# ---------------------------------------------------------------------------------------------
Given I'm logged in with password "sy"
Given I set the fake date to "25.01.2002"

# ------------ kostenquelle 2 -----------
#  km ohne umbuchung  

#  KM---KMRF---MN         offen: ----SKMRF---SKM
#   \         beldat=25.01.        
#    \
#    Zeitraum des Buchungsdatums prüfen (1a, 1b, 1c) 
#

Given I open an editor "kostenumlrueck-200" from table "(CostDistribution):(CostDistributionReturn)" with command "NEW" for record ""
And I set field "num135" to "201" 
And I set field "name" to "KMRF" 
And I set field "such" to "R201" 
And I set field "origvorg" to "+U2-1ZEI-12"
And I set field "budat" to "31.12.2001"
# 2648 de      |Buchungsdatum darf nicht kleiner als das der Kostenumlage und nicht größer als das Systemdatum sein.
# 1a aus graf budat zu früh
And saving the current editor throws the exception "Buchungsdatum darf nicht kleiner als das der Kostenumlage und nicht größer als das Systemdatum sein."

And I set field "budat" to "01.01.2002" 
# 1b aus graf budat zu früh
And saving the current editor throws the exception "Buchungsdatum darf nicht kleiner als das der Kostenumlage und nicht größer als das Systemdatum sein."

And I set field "budat" to "01.01.2003" 
# 1c aus graf budat zuspät
And saving the current editor throws the exception "Buchungsdatum darf nicht kleiner als das der Kostenumlage und nicht größer als das Systemdatum sein."

# 3794 de      |Zeile kann nicht eingefügt werden
And creating a new row at position 1 throws the exception "3794" 
# 40 de
And creating a new row at position 2 throws the exception "Es dürfen keine Zeilen ein- oder angefügt werden" 

And I set field "budat" to "11.01.2002"
And I save the current editor

# --- mn ---- beldat=25.01. 
Given I open an editor "mnb-von-kmzpos3" from table "(CostDistribution):(QuantityRevaluation)" with command "NEW" for record ""
And I set field "such" to "NBzpos3"
And I set field "nummer" to "3zpos"
Then field "vorgang" is modifiable in row 1
And I set field "vorgang" to "$,,buart=1;artikel==E1LO-VO;mge==30;ursache=Rechnung;@datei=10;@gruppe=1;@ablageart=lebendig" in row 1
And I set field "ntbewpr" to "5" in row 1
And I save the current editor
And I close the current editor

# ------ nachbewerten ---------------
Given I open an editor "nachbewerten" for tip command "(Revalue)" and arguments ""
And I close the current editor


# --------- kostenquelle 11 ----------------
#           
#                          (1b)
#                       ___KMRF
#                      /   scheit.      (2a)       (3a)
# kost_qu_ek_11       /     ___________SKMRF______SKMRF 
#                    /     /           scheit.    scheit.
#  fibu:            /     /
#  B134-ADD        /     /           __STO-SKMRF              ___STO-SKMTRF              
#  ek:            /     /           /  scheit.(2b)           /   scheit.(4a)
#  134-add       /     /           /                        / 
#  EKREADDK     /     /_____(2c)__/___KMNIXRF scheit.(2d)  / 
#      \   \   /     //          / /                      /            
#       \   --KM---KMRF---------SKMRF------ KMTRF ------ SKMTRF ----- SKM
#        \ /  110  (1)           (2)          \(3)        (4)         wieder (5)
#  EKREMAT/     \                              \                      möglich 
#  11-15-2 \     \                              \             
#       \   \     \                              \______________SKMTRF
#        \   \     \                                            scheit.(4b) 
#         \   \     \____SKM     ___________________SKM ___________________________SKM
#          \   \         scheitert                  scheit.                        scheit.
#           \   \          (1a)                     (3b)                           (5a)
#            \   \
#             \   \______SEKREADDK
#              \         scheit.(1c) TUT IM EK NICHT IN CUCU, S. UNTEN
#               \
#                \_______SEKREMAT______SEKREMAT____________________________________SEKREMAT
#                        scheit.       scheit.                                     scheitert
#                         (1d)          (2e)                                       wg. KM 300 (seiteneffekt)
#                                                                                  hier KM=110
# (1 aus graf)
Given I open an editor "kostenumlrueck-11" from table "(CostDistribution):(CostDistributionReturn)" with command "NEW" for record ""
And I set field "num135" to "111" 
And I set field "name" to "KMRF" 
And I set field "origvorg" to "+U11-2ZEI"
And I set field "such" to "R110" 
# addk-aus-ek ## mit-mkv #And I set field "yreskopfgl" to "test res-feld yreskopfgl gefuellt?"
# addk-aus-ek ## mit-mkv #And I set field "yrestabip2" to "39" in row 2
And I save the current editor

# ------ nachbewerten ---------------
Given I open an editor "nachbewerten" for tip command "(Revalue)" and arguments ""
And I close the current editor

# (plausi 1a aus graf - keine datenspeicherung)
#  2647 de      |Es existiert mindestens eine aktive Kostenumlagercknahmepostion.
Given opening an editor from table "(CostDistribution):(CostDistribution)" with command "REVERSAL" for record "+U11-2ZEI" throws the exception "2647"
# CUCU-183 (irreführende fehlermeldung)
# Given I open an editor "sto-km-test" from table "(CostDistribution):(CostDistribution)" with command "REVERSAL" for record "+U11-2ZEI"
And I close the current editor

# (plausi 1b aus graf - keine datenspeicherung)
Given I open an editor "kostenumlrueck-test" from table "(CostDistribution):(CostDistributionReturn)" with command "NEW" for record ""
And I set field "num135" to "111" 
And I set field "name" to "KMRF" 
And setting field "origvorg" to "+U11-2ZEI" throws the exception "1643"
And I set field "such" to "R110" 
# die folgende plausi wird verdeckt:
# tabelle bleibt leer
# And saving the current editor throws the exception "1643"
And I close the current editor

# addk-aus-ek ##  #  IN CUCUMBER TUT DAS NICHT - MANUELLER TEST WAR ABER AM 1.10.21 ok
# addk-aus-ek ##  # (plausi 1c aus graf - keine datenspeicherung)      
# addk-aus-ek ##  # Rechnung für add. kosten anlegen
# addk-aus-ek ##  #  TODO: CUCU-184
# addk-aus-ek ##  #     in dem testablauf hier läuft die antworterkennung falsch.
# addk-aus-ek ##  #     eigentlich müsste es so aussehen wie unten im FIBU-Fall und die exception 2647
# addk-aus-ek ##  #     ausgegeben werden.
# addk-aus-ek ##  #  TODO: BW2-1573:  dieses todo bezieht sich nur noch auf den testablauf, wenn CUCU-184
# addk-aus-ek ##  #                   mal erledigt ist und das hier funktioniert.
# addk-aus-ek ##  #
# addk-aus-ek ##  # 1290 de      |Die Rechnung wurde mit einer Kostenumlage umgelegt. Wirklich stornieren?
# addk-aus-ek ##  Given I open an editor "rechn-134-storno-versuch" from table "(Purchasing):(Invoice)" with command "REVERSAL" for search criteria "$,,nummer==134-add;@maxtreffer=1;@ablageart=abgelegt"
# addk-aus-ek ##  And I respond with answer "ja" to the dialog with id "1290"
# addk-aus-ek ##  Then saving the current editor throws the exception "2743"
# addk-aus-ek ##  And I close the current editor

# (plausi 1c aus graf - keine datenspeicherung) 
# zu BW2-1573
# addk-aus-FIBU #And I open an editor "stornoVERSUCH-1-umlagebuchung" from table "(Entry):(Entry)" with command "REVERSAL" for record "B134-ADD"
# addk-aus-FIBU #And saving the current editor throws the exception "2647"
# addk-aus-FIBU #And I close the current editor

# (plausi 1d aus graf - keine datenspeicherung)
#  3335 de      |Stornieren Sie zuerst dieses Objekt.
Given opening an editor from table "(Purchasing):(Invoice)" with command "REVERSAL" for record "+11-15-2" throws the exception "3335"
And I close the current editor


# (2 aus graf - keine datenspeicherung)
Given I open an editor "sto-kostenumlrueck-11" from table "(CostDistribution):(CostDistributionReturn)" with command "REVERSAL" for record "+R110"
And I set field "num135" to "111s" 
And I set field "such" to "S111" 
And I set field "name" to "SKMRF" 
And I save the current editor

# ------ nachbewerten ---------------
Given I open an editor "nachbewerten" for tip command "(Revalue)" and arguments ""
And I close the current editor


# (plausi 2a aus graf - keine datenspeicherung)
# 9311 de      |Der Vorgang ist schon storniert.
Given opening an editor from table "(CostDistribution):(CostDistributionReturn)" with command "REVERSAL" for record "+R110" throws the exception "9311"
And I close the current editor

# (plausi 2b aus graf - keine datenspeicherung)
# 10912 de      |Stornovorgang kann nicht selbst storniert werden.
Given opening an editor from table "(CostDistribution):(CostDistributionReturn)" with command "REVERSAL" for record "+S111" throws the exception "10912"
And I close the current editor

# (plausi 2c + 2d aus graf - keine datenspeicherung)
Given I open an editor "kostenumlrueck-2c" from table "(CostDistribution):(CostDistributionReturn)" with command "NEW" for record ""
# 1361 de      |Ungltiger Feldwert
# (2c aus graf - keine datenspeicherung)
And setting field "origvorg" to "+R110" throws the exception "1361"
# 1361 de      |Ungltiger Feldwert
# (2d aus graf - keine datenspeicherung)
And setting field "origvorg" to "+S111" throws the exception "1361"
And I close the current editor

# (plausi 2e = 1d aus graf - keine datenspeicherung)
Given opening an editor from table "(Purchasing):(Invoice)" with command "REVERSAL" for record "+11-15-2" throws the exception "3335"
And I close the current editor


# (3 aus graf)
Given I open an editor "kostenumlteilrueck-11" from table "(CostDistribution):(CostDistributionReturn)" with command "NEW" for record ""
And I set field "num135" to "112" 
And I set field "name" to "KMTRF" 
And I set field "origvorg" to "+U11-2ZEI"
And I set field "such" to "RT110" 
And I set field "zurueckfuehren" to "nein" in row 1
And I set field "zurueckfuehren" to "nein" in row 2
# 457 de      |Keine Zeile markiert
And saving the current editor throws the exception "457"
# änderung wieder zurück, damit eine zeile markiert ist:
And I set field "zurueckfuehren" to "ja" in row 2
And I save the current editor

# ------ nachbewerten ---------------
Given I open an editor "nachbewerten" for tip command "(Revalue)" and arguments ""
And I close the current editor

# (plausi 3a = 2a aus graf - keine datenspeicherung)
# 9311 de      |Der Vorgang ist schon storniert.
Given opening an editor from table "(CostDistribution):(CostDistributionReturn)" with command "REVERSAL" for record "+R110" throws the exception "9311"
And I close the current editor

# (plausi 3b = 1a aus graf - keine datenspeicherung)
#  2647 de      |Es existiert mindestens eine aktive Kostenumlagercknahmepostion.
Given opening an editor from table "(CostDistribution):(CostDistribution)" with command "REVERSAL" for record "+U11-2ZEI" throws the exception "2647"
And I close the current editor

# (4 aus graf)
Given I open an editor "sto-kostenumlteilrueck-11" from table "(CostDistribution):(CostDistributionReturn)" with command "REVERSAL" for record "+RT110"
And I set field "num135" to "112s" 
And I set field "such" to "S112" 
And I set field "name" to "SKMTRF" 
And I save the current editor

# ------ nachbewerten ---------------
Given I open an editor "nachbewerten" for tip command "(Revalue)" and arguments ""
And I close the current editor


# (plausi 4a = 2b aus graf - keine datenspeicherung)
# 10912 de      |Stornovorgang kann nicht selbst storniert werden.
Given opening an editor from table "(CostDistribution):(CostDistributionReturn)" with command "REVERSAL" for record "+S111" throws the exception "10912"
And I close the current editor

# (plausi 4b = 4 aus graf - keine datenspeicherung)
# 9311 de      |Der Vorgang ist schon storniert.
Given opening an editor from table "(CostDistribution):(CostDistributionReturn)" with command "REVERSAL" for record "+RT110" throws the exception "9311"
And I close the current editor

# (5 aus graf)
Given I open an editor "sto-kostenuml-100" from table "(CostDistribution):(CostDistribution)" with command "REVERSAL" for record "+U11-2ZEI"
And I set field "num135" to "100s" 
And I set field "such" to "S11-1ZEI" 
And I set field "name" to "SKM"
# And I wait for file cucudbg for debugging
And I save the current editor

# ------ nachbewerten ---------------
Given I open an editor "nachbewerten" for tip command "(Revalue)" and arguments ""
And I close the current editor


# (plausi 5a = 3b = 1a aus graf - keine datenspeicherung)
# 9311 de      |Der Vorgang ist schon storniert.
Given opening an editor from table "(CostDistribution):(CostDistribution)" with command "REVERSAL" for record "+U11-2ZEI" throws the exception "9311"
And I close the current editor


# ------------------------------------------------------------------------
Scenario: Monatsabschluß, Jan 02 abschliessen
# ---------------------------------------------------------------------------------------------
Given I set the fake date to "02.02.2002"

Given I open an editor "Monatsabschluss" from table "(FiscalYearManagement):(Closings)" with command "NEW" for record ""
And I set fields
    | such | ABSCHL      |
And I press button "fbbbu" in row 4
And I respond with answer "Ja" to the dialog with id "7626"
And I save the current editor


# ------------------------------------------------------------------------
Scenario: rueckfuehrungen fuer kostenquell-pos 15 (eins-fünf)
# ---------------------------------------------------------------------------------------------
Given I set the fake date to "03.02.2002"

#  rel. einfacher Prozess:
# kost_qu_ek_15
#
#  KM--------MOAB------KMRF----SKMRF---------SMOAB---SKM---RL---SRL
#   \        (1)       (2)     (3)                  (4)
#    \         \                  
#     \         \__KMRF mit orig-budat
#      \           scheitert (1a)
#       \
#        \-------------------------SKM scheitert
#                                  wg. moab (3a)

Given I open an editor "kostenumlrueck-15.1" from table "(CostDistribution):(CostDistributionReturn)" with command "NEW" for record ""
And I set field "num135" to "151" 
# kein name, damit std.text gezogen wird (testrelevant!)    And I set field "name" to "KMRF" 
And I set field "origvorg" to "+U15-1ZEI"
And I set field "such" to "R15.1" 
Then field "budat" has value ""
# 1a aus graf
And I set field "budat" to "10.01.2002"
And saving the current editor throws the exception "Zeitraum ist schon abgeschlossen"
And I set field "budat" to "01.02.2002"
And I save the current editor

Given I open an editor "sto-kostenumlrueck-15.1" from table "(CostDistribution):(CostDistributionReturn)" with command "REVERSAL" for record "+R15.1"
And I set field "num135" to "151s" 
And I set field "such" to "SR15.1" 
# kein name, damit std.text gezogen wird (testrelevant!)  And I set field "name" to "SKMRF" 
And I save the current editor

Given I open an editor "sto-kostenuml-15.scheitert" from table "(CostDistribution):(CostDistribution)" with command "REVERSAL" for record "+U15-1ZEI"
And I set field "num135" to "150err" 
And I set field "such" to "S15-ERR" 
And I set field "name" to "SKM scheitert wegen geschl. monat"
And saving the current editor throws the exception "Zeitraum ist schon abgeschlossen"
And I close the current editor

# Monatsabschluß, Jan 02 für den storn der kostenumlage öffnen
Given I open an editor "Monatsabschluss" from table "(FiscalYearManagement):(Closings)" with command "NEW" for record ""
And I set fields
    | such | ABSCHL      |
And I press button "ekbbu" in row 4
# And I press button "fbbbu" in row 4
And I respond with answer "Ja" to the dialog with id "7626"
And I save the current editor

Given I open an editor "sto-kostenuml-15.1" from table "(CostDistribution):(CostDistribution)" with command "REVERSAL" for record "+U15-1ZEI"
And I set field "num135" to "150s" 
And I set field "such" to "S15-1ZEI" 
And I set field "name" to "SKM"
And I save the current editor

# Rücklieferschein anlegen
Given I open an editor "rls-11-15-2-mge20" from table "(Purchasing):(Invoice)" with command "RETURN" for record "+R11-15-2"
And I set field "num4" to "11152-20"
And I set field "such4" to "RL11mge20"
And I set field "ebeleg" to "RL11-15-2-mge20"
And I set field "vom" to "."
And I set field "mge" to "-15" in row 2
And I save the current editor

# Ruecklieferschein buchen (muss funktionieren, weil keine aktive Kostenumlage mehr)
Given I open an editor "srls-11-15-2-mge20" from table "(Purchasing):(PackingSlip)" with command "UPDATE" for record "11152-20"
And I set field "ueb" to "ja"
And I save the current editor

Given I open an editor "sRL" from table "(Purchasing):(PackingSlip)" with command "REVERSAL" for record "11152-20"
And I save the current editor

# ------ nachbewerten ---------------
Given I open an editor "nachbewerten" for tip command "(Revalue)" and arguments ""
And I close the current editor


# ------------------------------------------------------------------------
# lohnfertigungsteil kann seit 2100r8n00 nicht mehr umgebucht werden.
# scenario entfernt
# --------------------------------------------------------------------------------------
# Given I set the fake date to "04.02.2002"
# 
# Given I open an editor "LBuchung" for tip command "LBuchung" and arguments ""
#   And I set fields
# 	| beleg		| umbuch		|
# 	| beldat	| .				|
# 	| artikel	| E1LO-VO	|
#	| lffert	| EFLO-VO	|
# 	| buart		| Umbuchung		|
# 	| mkvwunsch	| nein			|
#   And I modify table
#    | !row  | mge  | platz	| platz2	|
#    | 1     | 30   | F1  	| F2		|
# And I save the current editor
# 
# # ------ nachbewerten ---------------
# Given I open an editor "nachbewerten" for tip command "(Revalue)" and arguments ""
# And I close the current editor


# ------------------------------------------------------------------------
Scenario: 400 mehrere teilrückführungen mit einem storno und restmengenrückführung + plausis
# -----------------------------------------------------------------------------------------
Given I set the fake date to "05.02.2002"

# quellpos:    zielpos:
#                                     _____________________________SKMTRF1
# kost_qu_ek_3 kmzpos11              /                             scheit.(4a)
#      \       kmzpos2;             / 
#       \      kmzpos4;            /                    ___________STO-SKMRF 
#        \     kmzpos5;           /  ____storno___     /           scheit.(4b)
#         \                      /  /             \   /          
#          \        KM---------KMTRF1----KMTRF2---SKMTRF1---KMRRF----KMRRF
#           \   (400) \         (1)       (2)      (3)       (4)     (4c)
#            \         \         |                  |
#             |         |   Zeile 4 löschen       Budat im Storno
#             |         |   funktioniert(1d)      ändern scheitert (3a)
#             |         |      
#             \         \_____________SKM     ______________________SKM
#              \                      scheitert                     scheit.(4d)
#               \                      (1a)
#                \             
#                 \___________________SEKREADDK      
#                                     scheit.(1b) 
#                                     TUT NICHT IN CUCU
#                              
#                                     Umlagemethode ändern
#                                     scheitert (1c)
#
# (1 aus graf)
Given I open an editor "kostenumlteilrueck-400-1" from table "(CostDistribution):(CostDistributionReturn)" with command "NEW" for record ""
And I set field "num135" to "401" 
And I set field "name" to "KMTRF1 z1" 
And I set field "origvorg" to "+U4-4ZEI"
And I set field "such" to "RT401" 
Then field "budat" has value "10.01.02"
And I set field "budat" to "03.02.2002"
# 1c Umlagemethoden nicht änderbar
And setting field "umlagemeth" to "Wert" throws the exception "Ungültiger Feldname"
And I set field "zurueckfuehren" to "nein" in row 2
And I set field "zurueckfuehren" to "nein" in row 3

And I delete row at position 4
# 1d
# löschen wirkt bis auf w. wie "zurueckfuehren" = "nein"
# And I set field "zurueckfuehren" to "nein" in row 4

And I save the current editor


# (plausi 1a aus graf - keine datenspeicherung)
#  2647 de      |Es existiert mindestens eine aktive Kostenumlagercknahmepostion.
Given opening an editor from table "(CostDistribution):(CostDistribution)" with command "REVERSAL" for record "+U4-4ZEI" throws the exception "2647"
And I close the current editor

# (2 aus graf)
Given I open an editor "kostenumlteilrueck-400-2" from table "(CostDistribution):(CostDistributionReturn)" with command "NEW" for record ""
And I set field "num135" to "402" 
And I set field "name" to "KMTRF2 z1" 
And I set field "origvorg" to "+U4-4ZEI"
And I set field "such" to "RT402" 
Then field "budat" has value "10.01.02"
And I set field "budat" to "03.02.2002"
And I set field "zurueckfuehren" to "nein" in row 3
And I save the current editor

# (3 aus graf)
Given I open an editor "sto-kostenumlrueck-400-1" from table "(CostDistribution):(CostDistributionReturn)" with command "REVERSAL" for record "+RT401"
And I set field "num135" to "401s" 
And I set field "such" to "SR401" 
And I set field "name" to "SKMTRF1 z1" 
# 551 de      |Feld ist nicht änderbar
# (3a aus graf)
And setting field "budat" to "25.02.2002" throws the exception "551"
And I save the current editor

# ------ nachbewerten ---------------
Given I open an editor "nachbewerten" for tip command "(Revalue)" and arguments ""
And I close the current editor

# (4 aus graf)
Given I open an editor "kostenuml-restrueck-400" from table "(CostDistribution):(CostDistributionReturn)" with command "NEW" for record ""
And I set field "num135" to "403" 
# suchwort gewollt leer lassen. test!
And I set field "name" to "KMRRF" 
And I set field "origvorg" to "+U4-4ZEI"
Then field "such" has value "U4-4ZEI"
Then field "budat" has value "10.01.02"
And I set field "budat" to "02.02.2002"
And I save the current editor

# (plausi 4a aus graf - keine datenspeicherung)
#  9311 de      |Der Vorgang ist schon storniert.
Given opening an editor from table "(CostDistribution):(CostDistributionReturn)" with command "REVERSAL" for record "+RT401" throws the exception "9311"
And I close the current editor

# (plausi 4b aus graf - keine datenspeicherung)
# 10912 de      |Stornovorgang kann nicht selbst storniert werden.
Given opening an editor from table "(CostDistribution):(CostDistributionReturn)" with command "REVERSAL" for record "+SR401" throws the exception "10912"
And I close the current editor

# (plausi 4c aus graf - keine datenspeicherung)
Given I open an editor "kostenuml-2te-restrueck-nicht-möglich" from table "(CostDistribution):(CostDistributionReturn)" with command "NEW" for record ""
And I set field "num135" to "499s" 
And I set field "name" to "KMRRF" 
And setting field "origvorg" to "+U4-4ZEI" throws the exception "1643"
And I set field "such" to "RT499" 
# die folgende datensatz-plausi wird durch die feldplausi 1643 verdeckt, ist aber da.
# 3641 de      |Die Tabelle ist leer
# tabelle bleibt leer
# And saving the current editor throws the exception "1643"
And I close the current editor

# (plausi 4d wie 1a aus graf - keine datenspeicherung)
#  2647 de      |Es existiert mindestens eine aktive Kostenumlagercknahmepostion.
Given opening an editor from table "(CostDistribution):(CostDistribution)" with command "REVERSAL" for record "+U4-4ZEI" throws the exception "2647"
And I close the current editor

# ------ nachbewerten ---------------
Given I open an editor "nachbewerten" for tip command "(Revalue)" and arguments ""
And I close the current editor


# ---------------------------------------
Scenario: 500  plausi(s) KMRF gegen MN 
# --------------------------------------
Given I set the fake date to "05.02.2002"

# quellpos:              zielpos:                                        
#                  (500)                                     _______                    _______
#                      __(kmzpos2)---------\                /       \                  /       \
#                     /                     \              /         \                /         \
# kost_qu_ek_5_12-> KM___(kmzpos3)--------------KMRF (2a)-----SMN(3)-----KMRF (3a)------------------ KMRF RT501
#                  (1)\                     /   scheitert  \ 3zpos   /   scheitert    \         /    (5)  
#                      \_(kmzpos6)--- MN --/    wg.MN:      \_______/    wg.MN:        \__SMN__/
#                                    6444       "3zpos"                  6444             6444
#                                     (2)                                                 (4)
#               budat=10.01.       beldat=12.01.          beldat=05.02.                              budat=03.02.
#  
#       bis (2) passiert im basis-test
#
#   !!! MN 3zpos wird in Scenario 2 (oben) angelegt, suche nach 3zpos
#       DESHALB MÜSSEN HIER ZUERST 2 MN STORNIERT WERDEN, BEVOR DIE 
#       RÜCKFÜHRUNG DER KOSTENMLAGE U5... MÖGLICH IST.  
#

Given I open an editor "mn-6444" from table "(CostDistribution):(QuantityRevaluation)" with command "VIEW" for record "+6444"
Then field "vom" has value "12.01.2002 10:54:00"
Then field "budat" has value "10.01.2002" in row 1
And I close the current editor 

# (plausi 2a aus graf - keine datenspeicherung)
Given I open an editor "kostenuml-vollrueck-500-plausi" from table "(CostDistribution):(CostDistributionReturn)" with command "NEW" for record ""
And I set field "num135" to "501" 
And I set field "name" to "KMTRF" 
And I set field "such" to "RT501" 
And I set field "origvorg" to "+U5-3ZEI-12"
Then field "budat" has value "10.01.02"
And I set field "budat" to "03.02.2002"
# fehlernrn: 808 + 3335
# zu jira BW2-1609
And saving the current editor throws the exception
"""
Kostenumlage kann wegen der Mengenneubewertung "3zpos"  nicht storniert/zurückgeführt werden.
Stornieren Sie zuerst dieses Objekt.
"""      
And I close the current editor 

# (3 aus graf)
Given I open an editor "mn-stornieren" from table "(CostDistribution):(QuantityRevaluation)" with command "REVERSAL" for record "+3zpos"
And I set field "such" to "SNBZPOS3" 
And I save the current editor

Given I open an editor "mn-view-SNBZPOS3" from table "(CostDistribution):(QuantityRevaluation)" with command "VIEW" for record "+SNBZPOS3"
Then field "vom" has value "05.02.2002 10:54:00"
And I close the current editor 

# (plausi 3a aus graf - keine datenspeicherung)
Given I open an editor "kostenuml-vollrueck-500-plausi" from table "(CostDistribution):(CostDistributionReturn)" with command "NEW" for record ""
And I set field "num135" to "501" 
And I set field "name" to "KMTRF" 
And I set field "such" to "RT501" 
And I set field "origvorg" to "+U5-3ZEI-12"
Then field "budat" has value "10.01.02"
And I set field "budat" to "03.02.2002"
# fehlernrn: 808 + 3335
# zu jira BW2-1609
And saving the current editor throws the exception
"""
Kostenumlage kann wegen der Mengenneubewertung "6444"  nicht storniert/zurückgeführt werden.
Stornieren Sie zuerst dieses Objekt.
"""      
And I close the current editor 


# (4 aus graf)
Given I open an editor "mn-stornieren2" from table "(CostDistribution):(QuantityRevaluation)" with command "REVERSAL" for record "+6444"
And I save the current editor

# (5 aus graf)
# wie oberhalb vor dem storno der MN
Given I open an editor "kostenuml-vollrueck-500" from table "(CostDistribution):(CostDistributionReturn)" with command "NEW" for record ""
And I set field "num135" to "501" 
And I set field "name" to "KMTRF" 
And I set field "origvorg" to "+U5-3ZEI-12"
And I set field "such" to "RT501" 
Then field "budat" has value "10.01.02"
And I set field "budat" to "03.02.2002"
And I save the current editor 

# Rücklieferschein anlegen
Given I open an editor "rls-5-6-7-mge60" from table "(Purchasing):(Invoice)" with command "RETURN" for record "+R5-6-7"
And I set field "num4" to "567rl"
And I set field "such4" to "RL567"
And I set field "ebeleg" to "RL5-6-7-mge60"
And I set field "vom" to "."
And I set field "mge" to "-60" in row 2
And I save the current editor

# Ruecklieferschein buchen (muss funktionieren, weil keine aktive Kostenumlage mehr)
Given I open an editor "srls-11-15-2-mge20" from table "(Purchasing):(PackingSlip)" with command "UPDATE" for record "RL567"
And I set field "ueb" to "ja"
And I save the current editor

Given I open an editor "sRL" from table "(Purchasing):(PackingSlip)" with command "REVERSAL" for record "RL567"
And I save the current editor

# ------ nachbewerten ---------------
Given I open an editor "nachbewerten" for tip command "(Revalue)" and arguments ""
And I close the current editor


# ------------------------------------------------
Scenario: 300 Teilrückführung mit Budat-Änderung 
# -----------------------------------------------
Given I set the fake date to "06.02.2002"

# quellpos:              zielpos:                                        
#                                        
#                                       
#              U3-2ZEI(300)          ___KMTRF    Teilrückführung belassen!  
# kost_qu_ek_4   -> KM___(kmzpos3)--/    (2)
#                  (1)
                     
Given I open an editor "kostenuml-teilrueck-300" from table "(CostDistribution):(CostDistributionReturn)" with command "NEW" for record ""
And I set field "num135" to "301" 
And I set field "name" to "KMRF" 
And I set field "such" to "RF301" 
And I set field "origvorg" to "+U3-2ZEI"
Then field "budat" has value "10.01.02"
And I set field "budat" to "01.02.2002"
And I set field "zurueckfuehren" to "nein" in row 1
And I save the current editor

# ------ löschprüfung(en) gleich nach dem entstehen -------
#  kommando nicht erlaubt 
Given opening an editor from table "(CostDistribution):(CostDistributionReturn)" with command "DELETE" for record "+RF301" throws the exception "40"

# ------ ändern gleich nach dem entstehen -------
#  kommando nicht erlaubt 
Given opening an editor from table "(CostDistribution):(CostDistributionReturn)" with command "UPDATE" for record "+RF301" throws the exception "40"

# ------ nachbewerten ---------------
Given I open an editor "nachbewerten" for tip command "(Revalue)" and arguments ""
And I close the current editor


# ------------------------------------------------------------------------------------------------
Scenario: kontierung und buchungsbetraege bei negativer kostenumlage mit rueckfuehrung und stornos 
# ------------------------------------------------------------------------------------------------
Given I set the fake date to "07.02.2002"

# -------------- 600 --------------------
# quellpos:              zielpos:
# 
#                 U6-NEG
# kost_qu_ek_6 -> KM_____(kmzpos8)__KMRF__SKMRF__SKM 
#                                   (2)   (3)   (4)

# (2 aus graf)
Given I open an editor "kostenuml-vollrueck-600" from table "(CostDistribution):(CostDistributionReturn)" with command "NEW" for record ""
And I set field "num135" to "601" 
And I set field "name" to "KMRF" 
And I set field "such" to "RF601" 
And I set field "origvorg" to "+U6-NEG"
Then field "budat" has value "10.01.02"
And I set field "budat" to "04.02.2002"
And I save the current editor

# ------ löschprüfung(en) gleich nach dem entstehen ------- 
#  kommando nicht erlaubt 
Given opening an editor from table "(CostDistribution):(CostDistributionReturn)" with command "DELETE" for record "+RF601" throws the exception "40"
# --- kopierverbot prüfen
Given opening an editor from table "(CostDistribution):(CostDistributionReturn)" with command "COPY" for record "+RF601" throws the exception "40"

# ------ nachbewerten ---------------
Given I open an editor "nachbewerten" for tip command "(Revalue)" and arguments ""
And I close the current editor

# (3 aus graf)
Given I open an editor "sto-kostenumlrueck-600" from table "(CostDistribution):(CostDistributionReturn)" with command "REVERSAL" for record "+RF601"
And I set field "num135" to "601s" 
And I set field "such" to "SR601" 
And I save the current editor

# ------ nachbewerten ---------------
Given I open an editor "nachbewerten" for tip command "(Revalue)" and arguments ""
And I close the current editor

# (4 aus graf)
Given I open an editor "km600-stornieren" from table "(CostDistribution):(CostDistribution)" with command "REVERSAL" for record "+U6-NEG"
And I set field "num135" to "600s" 
And I set field "such" to "SU6-NEG" 
And I save the current editor

# ------ nachbewerten ---------------
Given I open an editor "nachbewerten" for tip command "(Revalue)" and arguments ""
And I close the current editor

# ------ löschprüfung(en) nach stornierung --------- 
#  kommando nicht erlaubt 
Given opening an editor from table "(CostDistribution):(CostDistributionReturn)" with command "DELETE" for record "+RF601" throws the exception "40"
Given opening an editor from table "(CostDistribution):(CostDistributionReturn)" with command "DELETE" for record "+SR601" throws the exception "40"

# --- kopierverbot prüfen
Given opening an editor from table "(CostDistribution):(CostDistributionReturn)" with command "COPY" for record "+SR601" throws the exception "40"
