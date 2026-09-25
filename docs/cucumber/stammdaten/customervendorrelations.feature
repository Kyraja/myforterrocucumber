# *****************************************************************************
#  Name           : customervendorrelations.feature
#  Autor          : foe
#  Verantwortlich : teampss
#  Funktion       : Testet Kunden/Lieferantenbeziehungen
#                   Die Gruppe 5 aus Datei 1 steht in einer 1:1-Beziehung zum
#                   Lieferanten. Wenn der Lieferant geloescht wird, so muss
#                   auch die Gruppe geloescht werden.
#                   Die Gruppe kann mit einem Button aus dem Lieferant heraus
#                   angelegt werden. Kehrt man aus der Submaske in den Lieferanten
#                   zurueck und hat man damit eine solche Gruppe angelegt, so muss
#                   diese geloescht werden, wenn jetzt der Lieferant mit Abbruch
#                   verlassen wird.
# Getestete Phaenomene:
#  1. Loeschen der Gruppe beim Verlassen des Lieferanten mit Abbruch
#     nachdem die Gruppe angelegt wurde.
#  2. Anlegen einer solchen Gruppe
#  3. Kunden-Lieferantenbeziehung fuer Lieferant direkt anlegen
#
# *****************************************************************************
#
@persistent
Feature: EDI-Nachnachrichten zu Kunden/Lieferanten
Background:
Given I set the fake date to "02.01.1995"
Given I enable the flag 39

# ----------------------------------------------------------------------------------------------
Scenario: EDI einschalten
# ----------------------------------------------------------------------------------------------
Given I open an editor "Firma" from table "(Company):(Configuration)" with command "UPDATE" for record "KONFIG"
And I set field "edi" to "ja"
# And I set field "automotive" to "ja"
And I save the current editor

# ----------------------------------------------------------------------------------------------
Scenario:  Anlegen aber mit Abbruch verlassen
# Lieferant ohne Kunden-Lieferantenbeziehung aendern -> Kunden-Lieferantenbeziehung speichern -> Lieferant Dialog abbrechen -> Kunden-Lieferantenbeziehung ist nicht gespeichert
# ----------------------------------------------------------------------------------------------
Given I open an editor "Lief" from table "(Vendor):(Vendor)" with command "UPDATE" for record "1"
And I press button "liekun" to open a subeditor for "LIEKUND"
And I create a new row at the end of the table
And I set field "kunlie" to "1" in row 1
And I set field "bemkl" to "test1" in row 1
And I create a new row at the end of the table
And I set field "kunlie" to "1" in row 2
And I set field "bemkl" to "der muss geloescht werden" in row 2
And I save the current editor
And I switch the current editor to editor "Lief"
And I close the current editor

# Kunden-Lieferantenbeziehung fuer Lieferant ist nicht vorhanden
Given I open an editor "liefv" from table "(Vendor):(Vendor)" with command "VIEW" for record "1"
# Vorgang nicht moeglich, keine passende Daten vorhanden (1397)
Then pressing button "liekun" in row 0 to open a subeditor throws the exception "2619"
And I close the current editor

# ----------------------------------------------------------------------------------------------
Scenario: Kunden-Lieferantenbeziehung fuer Lieferant anlegen
# ----------------------------------------------------------------------------------------------
Given I open an editor "Lief2" from table "(Vendor):(Vendor)" with command "UPDATE" for record "1"
And I press button "liekun" to open a subeditor for "LIEKUND"
And I create a new row at the end of the table
And I set field "kunlie" to "1" in row 1
And I set field "bemkl" to "test1" in row 1
And I create a new row at the end of the table
And I set field "kunlie" to "1" in row 2
And I set field "bemkl" to "der bleibt erhalten" in row 2
And I save the current editor
And I switch the current editor to editor "Lief2"
And I save the current editor

# Neue Kunden-Lieferantenbeziehung fuer Lieferant anzeigen
Given I open an editor "lief2v" from table "(Vendor):(Vendor)" with command "VIEW" for record "1"
And I press button "liekun" to open a subeditor for "LIEKUND"
Then the table has 2 rows
And I close the current editor
And I switch the current editor to editor "lief2v"
And I close the current editor

# ----------------------------------------------------------------------------------------------
Scenario: Kunden-Lieferantenbeziehung fuer Lieferant aendern
# ----------------------------------------------------------------------------------------------
Given I open an editor "lief3" from table "(Vendor):(Vendor)" with command "UPDATE" for record "1"
And I press button "liekun" to open a subeditor for "LIEKUND"
And I create a new row at the end of the table
And I set field "kunlie" to "4" in row 3
And I set field "bemkl" to "der wurde ergaenzt" in row 3
And I save the current editor
And I switch the current editor to editor "lief3"
And I save the current editor

# Geaenderte Kunden-Lieferantenbeziehung fuer Lieferant anzeigen
Given I open an editor "lief3v" from table "(Vendor):(Vendor)" with command "VIEW" for record "1"
And I press button "liekun" to open a subeditor for "LIEKUND"
Then the table has 3 rows
And I close the current editor
And I switch the current editor to editor "lief3v"
And I close the current editor

# ----------------------------------------------------------------------------------------------
Scenario: Kunden-Lieferantenbeziehung anlegen fuer neuen Lieferanten nicht sofort moeglich
# ----------------------------------------------------------------------------------------------
Given I open an editor "liefneu" from table "(Vendor):(Vendor)" with command "NEW" for record ""
Then pressing button "liekun" in row 0 to open a subeditor throws the exception "203"
And I close the current editor

# ----------------------------------------------------------------------------------------------
Scenario: Neue Kunden-Lieferantenbeziehung fuer Lieferant direkt anlegen
# ----------------------------------------------------------------------------------------------

# Neuen Lieferant 04 als Kopie anlegen
Given I open an editor "lief4" from table "(Vendor):(Vendor)" with command "COPY" for record "1"
And I set field "nummer" to "04"
And I set field "such" to "LIEF04"
And I save the current editor

# Neue Kunden-Lieferantenbeziehung direkt anlegen
Given I open an editor "kulibez" from table "(Vendor):(CustomerVendorRelations)" with command "NEW" for record ""
# Eintragen des Lieferanten nicht moeglich, da der Lieferant schon eine Kunden-Lieferantenbeziehung hat
Then setting field "klnum" to "1" in row 0 throws the exception "3229"
# Neuen Lieferanten eingetragen
And I set field "klnum" to "LIEF04" in row 0
And I create a new row at the end of the table
And I set field "kunlie" to "1" in row 1
And I set field "bemkl" to "der direkt angelegt wurde" in row 1
And I save the current editor

# Neue Kunden-Lieferantenbeziehung fuer Lieferant 04 anzeigen
Given I open an editor "lief4v" from table "(Vendor):(Vendor)" with command "VIEW" for record "04"
And I press button "liekun" to open a subeditor for "LIEKUND"
Then the table has 1 rows
Then field "kunlie" has value "1" in row 1
Then field "bemkl" has value "der direkt angelegt wurde" in row 1
And I close the current editor
And I switch the current editor to editor "lief4v"
And I close the current editor

# ----------------------------------------------------------------------------------------------
Scenario: Neue Kunden-Lieferantenbeziehung ohne Lieferant nicht erlaubt
# ----------------------------------------------------------------------------------------------

# Neue Kunden-Lieferantenbeziehung direkt anlegen
Given I open an editor "kulibezohneli" from table "(Vendor):(CustomerVendorRelations)" with command "NEW" for record ""
And I set field "bemerk" to "xxx"
And I create a new row at the end of the table
And I set field "kunlie" to "1" in row 1
And I set field "bemkl" to "der direkt angelegt wurde" in row 1
# Pflichtfeld Lieferant ist nicht gefuellt
Then saving the current editor throws the exception "10179"
And I close the current editor

# ----------------------------------------------------------------------------------------------
Scenario: Neue Kunden-Lieferantenbeziehung fuer Lieferant, der schon eine hat, nicht moeglich
# ----------------------------------------------------------------------------------------------

# Neue Kunden-Lieferantenbeziehung direkt anlegen
Given I open an editor "kulibezneu" from table "(Vendor):(CustomerVendorRelations)" with command "NEW" for record ""
# Fuer diesen Lieferanten existiert bereits eine Kunden-Lieferanten-Beziehung.
Then setting field "klnum" to "1" throws the exception "3229"
And I close the current editor

