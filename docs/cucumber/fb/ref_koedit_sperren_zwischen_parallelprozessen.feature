# *****************************************************************************
#  Autor          : Gisela Koehne
#  Verantwortlich : uo
#  Kontrolle      : hc
#  Funktion       : Sperren beim Editieren des Sachkontenstammes       
#
# *****************************************************************************
@persistent
Feature: Sperrsituationen zwischen verschiedenen Anwendungskommandos (REWE-2464)

Background:
Given I set the fake date to "31.12.2002"


Scenario: Sperrlogik Abschluss vor Kontoeditor 
#
# Abschlussmaske öffnen
#
Given I open an editor "Abschluss" from table "(FiscalYearManagement):(Closings)" with command "NEW" for record ""
#
# Editieren eines Kontos läuft auf eine Sperre
#
Given I'm logged in with password "me" 
Then opening an editor from table "(Account):(Account)" with command "UPDATE" for record "44000" throws the locked object exception "236"
