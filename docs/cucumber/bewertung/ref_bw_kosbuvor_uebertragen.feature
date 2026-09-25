# *****************************************************************************
#    Name      : ref_bw_kosbuvor_uebertragen.feature                           
#    Autor     : jeffler                                                       
#    Verantwortlich : uo                                                     
#    Kontrolle:                                                                
#                                                                              
#     Funktion  : Cucumberscript zum uebertragen von kostenbuchungsvorschlaegen
#                 ersetzt Laderscript KOSBUVOR.UEBERTRAGEN.LAD
#                 ABER FIX AM 6.1.96!                 
#                                                                              
# *****************************************************************************

@persistent
Feature: kosbuvor_uebertragen
Background: kosbuuebertr
Given I set the fake date to "6.1.96"

Scenario: 1
Given I open an editor "kosbu-transf" from table "(CostEntriesSuggestion):(CostEntriesSuggestion)" with command "TRANSFER" for record ""
