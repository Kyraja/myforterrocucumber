#  Verantwortlich   : uo

@persistent
Feature: Fibu eroeffnen

Background: Fibueroeff

Given I set the fake date to "02.01.95"

Scenario: scen_fibueroeff

Given I open an editor "eroeffnungsphase_beenden" from table "(Company):(FinancialDates)" with command "UPDATE" for record "TERM"
And I set field "erend" to "31.12.94"
And I save the current editor
