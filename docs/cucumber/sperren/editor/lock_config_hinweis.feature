# *****************************************************************************
#  Name: lock_config_hinweis.feature
#  Autor: fwester
#  Verantwortlich: @forterro-prd/t024-abas-core
#  Funktion: Testet das Editieren des Textarrays hinweis
# *****************************************************************************
@persistent
@LOCK_CONFIGURATION_HINWEIS_TEST
Feature: CRUD 192:1

Given I'm logged in with password "sy"

Scenario: EditHinweisArray

# Eine neue Sperrkonfiguration wird errstellt, aber am Ende nicht gespeichert.
# Vor dem Schließen des Editors werden die Elemente des Hinweis-Arrays gesetzt
# und im Anschluss nachgeschaut, ob im Zielelement der richtige Wert angekommen
# ist.

Given I open an editor "CREATE" from table "(LockConfiguration):(LockConfiguration)" with command "NEW" for record ""

# Setzen des  bediensprachlichen Hinweises
And I set field "hinweisbspr" to "Bediensprache"
Then field "hinweis" has value "Bediensprache" in row 0
And I set field "hinweis" to ""

# Setzen des  ausgabesprachlichen Hinweises
And I set field "hinweisaspr" to "Ausgabesprache"
Then field "hinweis" has value "Ausgabesprache" in row 0
And I set field "hinweis" to ""

# Setzen des  korrespondenzsprachlichen Hinweises
And I set field "hinweiskspr" to "Korrespondenzsprache"
Then field "hinweis" has value "Korrespondenzsprache" in row 0
And I set field "hinweis" to ""

# Setzen des bediensprachlichen Elements
And I set field "hinweis" to "Deutsch"
Then field "hinweisbspr" has value "Deutsch" in row 0
Then field "hinweisaspr" has value "Deutsch" in row 0
Then field "hinweiskspr" has value "Deutsch" in row 0

And I close the current editor
