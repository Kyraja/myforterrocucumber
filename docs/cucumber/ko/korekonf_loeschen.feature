# *****************************************************************************
#  Name           : korekonf_loeschen.feature
#  Autor          : sih
#  Verantwortlich : sih
#  Funktion       : Plausibilisierung des Verbots des Löschens der Kostenrechnungskonfiguration im Normalmodus
# 
# *****************************************************************************
#
@persistent
Feature: Plausibilisierung des Verbots des Löschens der Kostenrechnungskonfiguration  
Background: 
Given I set the fake date to "31.01.2002"


Scenario: 01 Löschen mit Passwort sy
Given I open an editor "korekonf" from table "(CostType):(CostAccountingConfig)" with command "DELETE" for record "KOREKONF"
Then saving the current editor throws the exception "2743"
And I close the current editor

Scenario: 02 Prüfen, ob Kostenrechnungskonfiguration noch vorhanden ist
Given I open an editor "korekonf" from table "(CostType):(CostAccountingConfig)" with command "VIEW" for record "KOREKONF"
Then field "namebspr" has value "Kore-Konfiguration"
Then field "fertkont" has value "100"
And I close the current editor

Scenario: 03 Löschen mit Wartungs-Passwort 
Given I'm logged in with password "annette"
Given I open an editor "korekonf" from table "(CostType):(CostAccountingConfig)" with command "DELETE" for record "KOREKONF"
And I respond with answer "ja" to the dialog with id "826"
And I save the current editor

Scenario: 04 Prüfen, ob Kostenrechnungskonfiguration noch vorhanden ist
Given I'm logged in with password "sy"
Then opening an editor from table "(CostType):(CostAccountingConfig)" with command "VIEW" for record "KOREKONF" throws the exception "149"





