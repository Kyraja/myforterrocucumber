# ***************************************************************************
#  Name      : 
#  Datum     : 2025
#  Autor     : uo
#  Verantwortlich : uo
#  Kontrolle :
#
#  Funktion  : Entstehung war
#              Cucumber Skript zum Zwischenkonto "Berechnet, nicht geliefert" - nach dem Upgrade
#
# ***************************************************************************
@persistent
Feature: Plausi Std.Kontierung
Background:
Given I set the fake date to "06.01.2002"

# =====================================================================================

Scenario: Ausgangszustand Standardkontierung (std.kont.) ohne Zwischenkonto

Given I open an editor "stdkont" from table "(Company):(StandardChartOfAccounts)" with command "VIEW" for record "4"
Then field "btekls" has value ""
And I close the current editor

# =====================================================================================

Scenario: Erfassungsversuch eines EK LS ohne Kennzeichen btekls in der Standardkontierung

#  1535 de      |Standardkontierung, Steuerschlssel oder Buchungskreise fehlerhaft
Given opening an editor from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record "" throws the exception "1535"
