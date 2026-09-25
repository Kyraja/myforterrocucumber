# *****************************************************************************
#    Name      : fibu_refkbbab_kbbab.kob.tabbyselbutt_cu.feature               
#    Autor     : Jan Effler                                                    
#    Verantwortlich : uo                                                       
#    Kontrolle:                                                                
#                                                                              
#     Funktion : Script fÜr Test refkbbab; ersetzt Lader KBBAB.KOB.TABBYSELBUTT
#                ACHTUNG FESTES DATUM AM 2.1.02                                                              
# *****************************************************************************

@persistent
Feature: kob.tabbyselbutt
Background: refkbbab

Given I set the fake date to "02.01.2002"

Scenario: tabelle wird mit hilfe der buttons befuellt

Given I open an editor "kob" from table "(AccountRange):(CostElementRange)" with command "UPDATE" for record "78"
And I set field "such" to "ko.sel.but"
And I set field "namebspr" to "mit hilfe der buttons gefuellte tabelle"
And I set field "kssaldoalle" to "ja"
And I respond with answer "@letztername=ja;@lang=de;@ordnung=nummer;.nummer=!;.such=!;.bu==ja;.gv=;.bereicha=;.hilfsks=" to the dialog with id ""
And I press button "selbearb"
Then field "selkonfig" has value "ja"
And I press button "seltab" in row 0
And I save the current editor
