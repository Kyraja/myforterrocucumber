@persistent
Feature: mz_fixieren.feature

# **********************************************************************************
#  Name             : mz_fixieren.feature
#  Autor            : bheim
#  Verantwortlich   : bheim
#  Kontrolle        : drpf
#  Funktion         : Fixiert fuer ref_dispo_mindbest eine Dispomz
#  ref              : ref_dispo_minbest
#
# **********************************************************************************
Background:
And I set the fake date to "02.01.1995"

Scenario: 01 Dispomz fixieren

Given I open an editor "editPlan" from table "(MaterialsAllocation):(EditableProjectedAvailability)" with command "UPDATE" for record ""
And I set field "artikel" to "TEMIN22"
And I press button "ladetab"
And I set field "fix" to "ja" in row 1
And I save the current editor


And I run Scheduling


