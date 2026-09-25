@persistent
Feature: ABS-1512
Background:
Given I set the fake date to "30.12.1995"

# *****************************************************************************
#  Name             : ilv_einmaldatensatz_pruefung.feature
#  Autor            : Silvia Warth
#  Verantwortlich   : sih
#  Kontrolle        : teamfcv
#  Funktion         : Test der Einmaldatensatzprüfung des ILV-Datensatzes (67:5).
#
# *****************************************************************************

Scenario: 01 Umlage neu, ILV
Then opening an editor from table "(Assessment):(IAAA)" with command "NEW" for record "" throws the exception "351"
#
Given I open an editor "Umlage" for tip command "ilv" and arguments ""
And I save the current editor
And I close the current editor
