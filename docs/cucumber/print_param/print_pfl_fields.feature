@persistent
@FP_TEST
Feature: Setzen der Pflichtfelder nach Status im Drucker

Scenario: Starten des Druckdialoges mit verschiedenen Druckern und dem gleichen Layout
Given I open an editor "Drucken" from table "(Sales):(Invoice)" with command "VIEW" for record "4711"
And I press button "budruck2" to open a subeditor for "Druckdialog"
And I set field "layout" to "MASTER"
#BILDSCHIRM
And I set field "drucker" to "BILDSCHIRM"
Then field "vonseite" is not modifiable
Then field "email" is not modifiable
Then field "schacht" is not modifiable
Then field "param1" is not modifiable
#EMAILPRINTER
And I set field "drucker" to "EMAILPRINTER"
Then field "vonseite" is not modifiable
Then field "email" is modifiable
Then field "schacht" is not modifiable
Then field "param1" is not modifiable
#ZUGFERD
And I set field "drucker" to "ZUGFERD"
Then field "vonseite" is not modifiable
Then field "email" is not modifiable
Then field "schacht" is not modifiable
Then field "param1" is modifiable
#DATEI
And I set field "drucker" to "DATEI"
And saving the current editor throws the exception "Bitte eintragen"
