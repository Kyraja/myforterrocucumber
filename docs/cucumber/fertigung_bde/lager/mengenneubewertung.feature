@persistent
Feature: mengenneubewertung.feature

Background:
And I set the fake date to "03.02.1995"

# *****************************************************************************
#  Name           : mengenneubewertung.feature
#  Autor          : lschneider   
#  Verantwortlich : drpf
#  Kontrolle      : carue
#  Funktion       : Testet Erweiterungen in der Neubewertung
#                   Es dürfen keine Setartikel verwendet werden
#  Jira-Issue     : FDA-816
# *****************************************************************************

Scenario: 01 Setartikel sind nicht erlaubt
Given I open an editor "Bestandskor" for tip command "Lneubewertung" and arguments ""
Then setting field "artikel" to "SET-ARTIKEL" throws the exception "10680"
And I close the current editor
