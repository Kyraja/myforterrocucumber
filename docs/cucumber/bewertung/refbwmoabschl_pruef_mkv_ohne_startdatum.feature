# *****************************************************************************
#  Autor          : uo
#  Verantwortlich : uo
#  Kontrolle      : sih
# *****************************************************************************
@persistent
Feature: Monatsabschlussplausibilisierung für Materialkostenverbuchungen 


# Herstellung der notwendigen uE-Verbuchbarkeit vorgelagert im Testbett per fake
# Sofort erfolgreicher Monatsabschluss, da kein Startdatum
# Prüftdaten exportieren separat nachgelagert, weil das hier mal wieder nicht einfach ging. 

Background:
Given I set the fake date to "1.02.2002"

# ---------------------------------------------------------------------------------------------
Scenario: mk-gebucht-mkue-gebucht-moab 
# ---------------------------------------------------------------------------------------------

Given I'm logged in with password "sy"
Given I set the fake date to "1.04.2002"

Given I open an editor "Monatsabschluss_ohne_startdatum" from table "(FiscalYearManagement):(Closings)" with command "NEW" for record ""
And I set fields
    | such | ERFOLGREICH-MAE-MKV |
And I press button "mbbbu" in row 6
And I respond with answer "Ja" to the dialog with id "7626"
And I save the current editor

Given I open an editor "Monatsabschluss3v" from table "(FiscalYearManagement):(Closings)" with command "VIEW" for record "+ERFOLGREICH-MAE-MKV"
And I close the current editor
