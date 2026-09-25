# *****************************************************************************
#    Name      : ref_bw_mkvaktivieren.feature                                  
#    Autor     : jeffler                                                       
#    Verantwortlich : uo                                                       
#    Kontrolle:                                                                
#                                                                              
#     Funktion  : Aktivieren des Moduls "Materialkostenverbuchung"             
#                 ersetzt Laderscript MKVAKTIVIEREN.LAD                        
#                 ABER FIX AM 8.1.02!                                                                              
# *****************************************************************************

@persistent
Feature: mkvaktivieren
Background: mkvaktivieren
And I set the fake date to "08.01.2002"
Given I enable the flag 39

Scenario: 1

Given I open an editor "konf" from table "(Company):(Configuration)" with command "UPDATE" for record "0k"
And I set field "bew" to "j"
# 2539 : ACHTUNG Langl�ufer: Stammdaten werden gepr�ft - o.k.?
And I respond with answer "ja" to the dialog with id "2539"
# 2540 : Alle Fehlerhinweise aus FOP la/MBFEHL bereinigt - wirklich aktivieren?
And I respond with answer "ja" to the dialog with id "2540"
And I save the current editor
