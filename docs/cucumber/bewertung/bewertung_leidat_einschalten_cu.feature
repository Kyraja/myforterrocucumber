# *****************************************************************************
#    Name      : bewertung_leidat_einschalten_cu.feature                       
#    Autor     : Jan Effler                                                    
#    Verantwortlich : uo                                                       
#    Kontrolle:                                                                
#                                                                              
#     Funktion  : ersetzt den Lader LEIDAT.EINSCHALTEN                         
#                                                                              
# *****************************************************************************

@persistent
Feature: leidat_einschalten
Background: bewertung
Given I enable the flag 39

Scenario: 1

Given I open an editor "config" from table "(Company):(Configuration)" with command "UPDATE" for record "0k"
And I set field "bewlei" to "ja"
# <#> Aktivierung Bewertung nach Leistungsdatum - ACHTUNG Langl�ufer:Pr�fung der Buchungsb�ume - o.k.? ?
# <?> ja
# <#> Aktivierung Bewertung nach Leistungsdatum - Hinweise in Datei LEIFEHL beachtet - wirklich aktivieren? ?
# <?> ja
And I save the current editor
