# *****************************************************************************
#  Name: filing_system_modifiable.feature
#  Autor: fwester
#  Verantwortlich: @forterro-prd/t024-abas-core
#  Funktion: Testet Auswirkungen dieser Option
# *****************************************************************************
@persistent
Feature: filing_system_modifiable

Scenario: Wiederaufleben

Given I'm logged in with password "adm"

# Bei Neu ist der Datensatz direkt ablegbar, weil die Ablageflagge immer änderbar ist.
Given I open an editor "Erstellen" from table "(File):(File)" with command "NEW" for record ""
Then field "ablagef" is modifiable
And I set field "nummer" to "1"
And I set field "such" to "LEBENDIG"
And I set field "name" to "Ich bin am Leben"
And I save the current editor
And I close the current editor

# Der Datensatz 1 wird im Ändern abgelegt, die Ablageflagge ist immer änderbar.
Given I open an editor "Ablegen" from table "(File):(File)" with command "UPDATE" for record "1"
Then field "ablagef" is modifiable
Then field "nummer" is modifiable
Then field "such" is modifiable
Then field "name" is modifiable
And I set field "such" to "ABGELEGT"
And I set field "name" to "Ich bin in der Ablage"
And I set field "ablagef" to "Ja"
Then field "ablagef" is modifiable
Then field "nummer" is modifiable
Then field "such" is modifiable
Then field "name" is modifiable
And I save the current editor
And I close the current editor

# Erfolgreiches Wiederaufleben des abgelegten Datensatzes 1 mit eindeutiger, aber dennoch änderbarer Nummer
Given I open an editor "Wiederbeleben" from table "(File):(File)" with command "UPDATE" for search criteria "$,,such==ABGELEGT;@ablageart=abgelegt"
Then field "ablagef" is modifiable
And I set field "ablagef" to "Nein"
Then field "nummer" is modifiable
Then field "such" is not modifiable
Then field "name" is not modifiable
And I save the current editor
And I close the current editor

Scenario: NichtEindeutigeIdentnrAbweisen

Given I'm logged in with password "adm"

# Erstellen eines Datensatzes 2
Given I open an editor "Erstellen" from table "(File):(File)" with command "NEW" for record ""
And I set field "nummer" to "2"
And I set field "such" to "ZWEI"
And I set field "name" to "Ich bin die Zwei"
And I save the current editor
And I close the current editor

# Ablegen des Datensatzes 2
Given I open an editor "Ablegen" from table "(File):(File)" with command "UPDATE" for record "2"
And I set field "such" to "ZWEIABGELEGT"
And I set field "name" to "Ich bin in der Ablage"
And I set field "ablagef" to "Ja"
And I save the current editor
And I close the current editor

# Erstellen eines Datensatzes mit der Nummer 2 des vorher abgelegten.
Given I open an editor "Erstellen" from table "(File):(File)" with command "NEW" for record ""
And I set field "nummer" to "2"
And I set field "such" to "ZWEITE_ZWEI"
And I set field "name" to "Ich bin schon wieder die Zwei"
And I save the current editor
And I close the current editor

# Versuch den abgelegten Datensatz 2 mit der inzwischen wieder belegten Nummer 2 wiederaufleben zu lassen.
Given I open an editor "Wiederbeleben" from table "(File):(File)" with command "UPDATE" for search criteria "$,,such==ZWEIABGELEGT;@ablageart=abgelegt"
And I set field "ablagef" to "Nein"
Then saving the current editor throws the exception "10635"
And I close the current editor

# Wiederaufleben des abgelegten Datensatzes 2 mit geänderter und eindeutigen Nummer 3
Given I open an editor "WiederbelebenOk" from table "(File):(File)" with command "UPDATE" for search criteria "$,,such==ZWEIABGELEGT;@ablageart=abgelegt"
And I set field "ablagef" to "Nein"
And I set field "nummer" to "3"
And I save the current editor
And I close the current editor


Scenario: PasswortOhneLoescherlaubnisErstellen

Given I'm logged in with password "adm"

Given I open an editor "Permission" from table "(Permission):(Permission)" with command "NEW" for record ""
And I set field "such" to "TEST"
And I press button "dnmax"
# Löscherlaubnis in DB 15 entfernen
And I set field "dn9p" to "-" in row 15
And I set field "tpp38" to ""
And I save the current editor
And I close the current editor

Given I open an editor "Password" from table "(Company):(Password)" with command "NEW" for record ""
And I set field "such" to "TEST"
And I set field "bezeich" to "test"
And I set field "abaserplogin" to "ja"
And I set field "pw1" to "testen"
And I set field "pw2" to "testen"
And I create a new row at the end of the table
And I set field "rechte" to "TEST" in row !lastRow
And I save the current editor
And I close the current editor

Scenario: AblageflaggeOhneLoescherlaubnisTesten

Given I'm logged in with password "testen"

# Bei Neu/Ändern Ablegen geht aber nach wie vor auch ohne Löscherlaubnis.
Given I open an editor "Erstellen" from table "(File):(File)" with command "NEW" for record ""
Then field "ablagef" is modifiable
And I set field "such" to "VIER"
And I set field "name" to "Ich bin die Vier"
And I save the current editor
And I close the current editor

Given I open an editor "Erstellen" from table "(File):(File)" with command "UPDATE" for record "VIER"
And I set field "ablagef" to "Ja"
And I save the current editor
And I close the current editor

# Ohne Löscherlaubnis wird schon das Bearbeiten des abgelegten Datensatzes bei REVIVABLE verweigert
Given opening an editor from table "(File):(File)" with command "UPDATE" for record "+VIER" throws the exception "9272"
