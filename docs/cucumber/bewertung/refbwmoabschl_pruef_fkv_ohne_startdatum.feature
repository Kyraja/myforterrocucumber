# *****************************************************************************
#  Autor          : uo
#  Verantwortlich : uo
#  Kontrolle      : sih
# *****************************************************************************
@persistent
Feature: Monatsabschlussplausibilisierung für Fertigungskostenverbuchungen 

# Sofort eerfolgreicher Monatsabschluss, da kein Startdatum
# Prüftdaten separat, weil das hier mal wieder nicht ging. 

Background:
Given I set the fake date to "1.02.2002"


# ---------------------------------------------------------------------------------------------
Scenario: kein startdatum 
# ---------------------------------------------------------------------------------------------
Given I'm logged in with password "sy"
Given I set the fake date to "1.02.2002"

Given I open an editor "Monatsabschluss-ohne-Kostenbuchungen" from table "(FiscalYearManagement):(Closings)" with command "NEW" for record ""
And I set fields
    | such | ERFOLGREICH-JAN-FKV |
And I press button "fbbbu" in row 4
And I respond with answer "Ja" to the dialog with id "7626"
And I save the current editor

Given I open an editor "Monatsabschluss3v" from table "(FiscalYearManagement):(Closings)" with command "VIEW" for record "+ERFOLGREICH-JAN-FKV"
And I close the current editor
