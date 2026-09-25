# *****************************************************************************
#  Name             : ref_apuffer.feature
#  Autor            : jeffler
#  Verantwortlich   : jeffler
#  Kontrolle        : 
#  Funktion         : Test zu EAF-6970 : Wird ein Subeditor über einen BU10 aufgerufen
#                     führte .setze amaske + zu einer Diag aufgrund eines nullptr.
#                     Hier wird die Korrektur dazu getestet.
#
# *****************************************************************************

Feature: ref_apuffer

Scenario: Artikel Editor öffnen und Programm ausführen
Given I open an editor "artikel" from table "(Part):(Product)" with command "UPDATE" for record "201"
And I press button "akle" to open a subeditor for "Kundenartikeleigenschaften"
And I close the current subeditor to switch back to the parent editor
And I close the current editor
