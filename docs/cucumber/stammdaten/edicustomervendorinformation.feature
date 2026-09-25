# *****************************************************************************
#  Name           : edicustomervendorinformation.feature
#  Autor          : foe
#  Verantwortlich : teampss
#  Funktion       : Testet EDI-Nachrichten-Konfiguration zu Kunden/Lieferanten
#                   Die Gruppe 4 und 5 aus Datei 0 und 1 stehen in einer 1:1
#                   Beziehung zum Kunden. Wenn der Kunde geloescht wird, so muss
#                   auch die Gruppe geloescht werden.
#                   Die Gruppe kann nur mit einem Button aus dem Kunden heraus
#                   angelegt werden. Kehrt man aus der Submaske in den Kunden
#                   zurueck und hat man damit eine solche Gruppe angelegt, so muss
#                   diese geloescht werden, wenn jetzt der Kunde mit Abbruch
#                   verlassen wird.
# Getestete Phaenomene:
#  1.Loeschen der Gruppe beim verlassen des Kunden mit Abbruch nachdem
#    die Gruppe angelegt wurde.
#  2.Anlegen einer solchen Gruppe
#
# *****************************************************************************
#
@persistent
Feature: EDI-Nachrichten-Konfiguration zu Kunden/Lieferanten
Background:
Given I set the fake date to "02.01.1995"
Given I enable the flag 39

# ----------------------------------------------------------------------------------------------
Scenario: EDI einschalten
# ----------------------------------------------------------------------------------------------
Given I open an editor "Firma" from table "(Company):(Configuration)" with command "UPDATE" for record "KONFIG"
And I set field "edi" to "ja"
And I save the current editor

# ----------------------------------------------------------------------------------------------
Scenario: EDI-Nachrichten-Konfiguration fuer Lieferant anlegen aber mit Abbruch verlassen
# Lieferant ohne EDI Nachricht aendern -> EDI Nachricht Speichern -> Lieferant Dialog abbrechen -> EDI Nachricht ist nicht gespeichert
# ----------------------------------------------------------------------------------------------
Given I open an editor "Lief" from table "(Vendor):(Vendor)" with command "UPDATE" for record "1"
And I press button "edinfo" to open a subeditor for "EDIInfo"
And I create a new row at the end of the table
And I set field "startdat" to "." in row 1
And I create a new row at the end of the table
And I set field "startdat" to "16.03" in row 1
And I save the current editor
And I switch the current editor to editor "Lief"
And I close the current editor

# EDI-Nachrichten-Konfiguration fuer Lieferant ist nicht vorhanden
Given I open an editor "liefv" from table "(Vendor):(Vendor)" with command "VIEW" for record "1"
# Vorgang nicht moeglich, keine passende Daten vorhanden (1397)
Then pressing button "edinfo" in row 0 to open a subeditor throws the exception "2619"
And I close the current editor

# ----------------------------------------------------------------------------------------------
Scenario: EDI-Nachrichten-Konfiguration fuer Lieferant anlegen
# ----------------------------------------------------------------------------------------------
Given I open an editor "Lief2" from table "(Vendor):(Vendor)" with command "UPDATE" for record "1"
And I press button "edinfo" to open a subeditor for "EDIInfo"
And I create a new row at the end of the table
And I set field "startdat" to "." in row 1
And I create a new row at the end of the table
And I set field "startdat" to "17.03" in row 2
And I save the current editor
And I switch the current editor to editor "Lief2"
And I save the current editor

# Neue EDI-Nachrichten-Konfiguration fuer Lieferant anzeigen
Given I open an editor "lief2v" from table "(Vendor):(Vendor)" with command "VIEW" for record "1"
And I press button "edinfo" to open a subeditor for "EDIInfo"
Then the table has 2 rows
And I close the current editor
And I switch the current editor to editor "lief2v"
And I close the current editor

# ----------------------------------------------------------------------------------------------
Scenario: EDI-Nachrichten-Konfiguration fuer Lieferant aendern
# ----------------------------------------------------------------------------------------------
Given I open an editor "lief3" from table "(Vendor):(Vendor)" with command "UPDATE" for record "1"
And I press button "edinfo" to open a subeditor for "EDIInfo"
And I create a new row at the end of the table
And I set field "startdat" to "21.3" in row 3
And I save the current editor
And I switch the current editor to editor "lief3"
And I save the current editor

# Geaenderte EDI-Nachrichten-Konfiguration fuer Lieferant anzeigen
Given I open an editor "lief3v" from table "(Vendor):(Vendor)" with command "VIEW" for record "1"
And I press button "edinfo" to open a subeditor for "EDIInfo"
Then the table has 3 rows
And I close the current editor
And I switch the current editor to editor "lief3v"
And I close the current editor

# ----------------------------------------------------------------------------------------------
Scenario: EDI-Nachrichten-Konfiguration anlegen fuer neuen Lieferanten nicht sofort moeglich
# ----------------------------------------------------------------------------------------------
Given I open an editor "liefneu" from table "(Vendor):(Vendor)" with command "NEW" for record ""
# Bitte Speichern - Erst wenn Kunde angelegt ist, darf eine EDI-Nachricht verfasst werden
Then pressing button "edinfo" in row 0 to open a subeditor throws the exception "11064"
And I close the current editor

# ----------------------------------------------------------------------------------------------
Scenario: EDI-Nachricht fuer einen Lieferanten, der bereits eine hat, anzulegen, ist nicht moeglich
# ----------------------------------------------------------------------------------------------
Given I open an editor "edilinachr" from table "(Vendor):(EDICustomerVendorInformation)" with command "NEW" for record ""
# Fuer diesen Kunden/Lieferanten existiert bereits eine EDI-Nachricht.
Then setting field "klnum" to "1" throws the exception "5340"
And I close the current editor

# ----------------------------------------------------------------------------------------------
Scenario: EDI-Nachrichten-Konfiguration fuer Kunde anlegen aber mit Abbruch verlassen
# ----------------------------------------------------------------------------------------------
# Kunde ohne EDI Nachricht aendern -> EDI Nachricht Speichern -> Kunde Dialog abbrechen -> EDI Nachricht ist nicht gespeichert

Given I open an editor "kunde" from table "(Customer):(Customer)" with command "STORE" for record "1"
And I press button "edinfo" to open a subeditor for "EDIInfo"
And I create a new row at the end of the table
And I set field "startdat" to "." in row 1
And I create a new row at the end of the table
And I set field "startdat" to "16.03" in row 1
And I save the current editor
And I switch the current editor to editor "kunde"
And I close the current editor

# EDI-Nachrichten-Konfiguration fuer Lieferant ist nicht vorhanden
Given I open an editor "kundev" from table "(Customer):(Customer)" with command "VIEW" for record "1"
# Vorgang nicht moeglich, keine passende Daten vorhanden (1397)
Then pressing button "edinfo" in row 0 to open a subeditor throws the exception "2619"
And I close the current editor

# ----------------------------------------------------------------------------------------------
Scenario: EDI-Nachrichten-Konfiguration fuer Kunde anlegen
# ----------------------------------------------------------------------------------------------
Given I open an editor "kunde2" from table "(Customer):(Customer)" with command "UPDATE" for record "1"
And I press button "edinfo" to open a subeditor for "EDIInfo"
And I create a new row at the end of the table
And I set field "startdat" to "." in row 1
And I create a new row at the end of the table
And I set field "startdat" to "17.03" in row 2
And I save the current editor
And I switch the current editor to editor "kunde2"
And I save the current editor

# Neue EDI-Nachrichten-Konfiguration fuer Lieferant anzeigen
Given I open an editor "kunde2v" from table "(Customer):(Customer)" with command "VIEW" for record "1"
And I press button "edinfo" to open a subeditor for "EDIInfo"
Then the table has 2 rows
And I close the current editor
And I switch the current editor to editor "kunde2v"
And I close the current editor

# ----------------------------------------------------------------------------------------------
Scenario: EDI-Nachrichten-Konfiguration fuer Kunde aendern
# ----------------------------------------------------------------------------------------------
Given I open an editor "kunde3" from table "(Customer):(Customer)" with command "UPDATE" for record "1"
And I press button "edinfo" to open a subeditor for "EDIInfo"
And I create a new row at the end of the table
And I set field "startdat" to "21.3" in row 3
And I save the current editor
And I switch the current editor to editor "kunde3"
And I save the current editor

# Geaenderte EDI-Nachrichten-Konfiguration fuer Lieferant anzeigen
Given I open an editor "kunde3v" from table "(Customer):(Customer)" with command "VIEW" for record "1"
And I press button "edinfo" to open a subeditor for "EDIInfo"
Then the table has 3 rows
And I close the current editor
And I switch the current editor to editor "kunde3v"
And I close the current editor

# ----------------------------------------------------------------------------------------------
Scenario: EDI-Nachrichten-Konfiguration anlegen fuer neuen Kunden nicht sofort moeglich
# ----------------------------------------------------------------------------------------------
Given I open an editor "kundeneu" from table "(Customer):(Customer)" with command "NEW" for record ""
# Bitte Speichern - Erst wenn Kunde angelegt ist, darf eine EDI-Nachricht verfasst werden
Then pressing button "edinfo" in row 0 to open a subeditor throws the exception "11064"
And I close the current editor

# ----------------------------------------------------------------------------------------------
Scenario: EDI-Nachricht fuer einen Kunden, der bereits eine hat, anzulegen, ist nicht moeglich
# ----------------------------------------------------------------------------------------------
Given I open an editor "edikunachr" from table "(Customer):(EDICustomerVendorInformation)" with command "NEW" for record ""
# Fuer diesen Kunden/Lieferanten existiert bereits eine EDI-Nachricht.
Then setting field "klnum" to "1" throws the exception "5340"
And I close the current editor
