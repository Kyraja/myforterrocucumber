# *****************************************************************************
#  Name: bug_85120.feature
#  Verantwortlich: fwester
#  Funktion: Stellt Korrektur von 85120 sicher.
# *****************************************************************************
@persistent
Feature: Bug_85120

# Dem Passwort ERLSYS werden in der Datenbank Erlaubis alle Rechte für die Gruppe
# 15 Bewertungskonfiguration entzogen.

Scenario: RemovePermissions4Group12:15
Given I'm logged in with password "adm"
Given I open an editor "PERMISSION" from table "(Permission):(Permission)" with command "UPDATE" for record "ERLSYS"
And I press button "grzeileeinfuegen" in row 13
And I set field "grliste" to "12:15" in row 14
And I save the current editor
And I close the current editor

# Mit dem so beschränkten Passwort wird im Artikel "V1" der Aktionsbutton geklickt.
# In der Folge muss im berechneten Aktionsmenü der Eintrag für den Aufrufparameter
# 52789 fehlen.

Scenario: Actionmenu4Product
Given I'm logged in with password "sy"
Given I open an editor "PRODUCT_VIEW" from table "(Part):(Product)" with command "VIEW" for record "V1"
And I press button "buaktion" to open a subeditor for "Aktionsmenü"
Then row with rowspec "$,,taufrufparameter^nummer==52789" does not exist
And I close the current editor
And I switch the current editor to editor "PRODUCT_VIEW"
And I close the current editor
