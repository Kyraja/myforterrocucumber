# *****************************************************************************
#  Name           : field_exit.feature
#  Verantwortlich : @forterro-prd/t024-abas-core
#  Funktion       : Testet Feldaustritte
# *****************************************************************************
@persistent
@EXIT_FIELD_TEST
Feature: CRUD_65:1

Scenario: Exit_field

Given I'm logged in with password "sy"
Given I open an editor "Infosystem neu" from table "(Infosystem):(Infosystem)" with command "NEW" for record ""
#
# Beim Arbeitsbereich wird normiert
#
And I set field "arb" to "OW1"
Then field "arb" has value "ow1"
#
# Das Setzen der DB beeinflusst die Gruppenangaben
# Die erste Gruppe ist standard.
#
And I set field "datnr" to "0"
Then field "grliste" has value "0:1"
Then field "grtxt" has value "Kunde"
#
# Das Setzen und Lesen von Gruppen via Menü wird in der Gurke leider
# nur ungenügend unterstützt. Deswegen existiert ref_infosys_grliste.
# Das Setzen der Gruppenliste ohne Gruppen beeinflusst die DB
# Die selektierbaren Gruppen sind standard.
#
And I set field "grliste" to "1:"
Then field "grliste" has value "1:1.2.3.4.5"
Then field "datnr" has value "1"
#
# Das Setzen der Gruppenliste mit Gruppen beeinflusst die DB/Gruppen
#
And I set field "grliste" to "0:1.2"
Then field "datnr" has value "0"
#
# Beim Typ Menü werden die Zeilenaktionen verboten; sonst passiert nichts.
#
And I set field "zeilereinerlaubt" to "ja"
And I set field "zeilerauserlaubt" to "ja"
And I set field "zeilebewerlaubt" to "ja"
And I set field "typ" to ""
Then field "zeilereinerlaubt" has value "ja"
Then field "zeilerauserlaubt" has value "ja"
Then field "zeilebewerlaubt" has value "ja"
And I set field "typ" to "(TypeMenu)"
Then field "zeilereinerlaubt" has value "nein"
Then field "zeilerauserlaubt" has value "nein"
Then field "zeilebewerlaubt" has value "nein"
And I set field "typ" to ""
Then field "zeilereinerlaubt" has value "nein"
Then field "zeilerauserlaubt" has value "nein"
Then field "zeilebewerlaubt" has value "nein"
And I close the current editor
