# *****************************************************************************
#  Name             : behaelter_status.feature
#  Autor            : carue
#  Verantwortlich   : carue
#  Kontrolle        : drpf
#  Funktion         : Testet den Status von Behaeltern und anhaengige Plausis
#
# *****************************************************************************
@persistent
Feature: behaelter_status.feature
Background:
Given I set the fake date to "02.01.1995"

##################################################################################################################

Scenario: 00 a Artikel anlegen
Given I open an editor "teig" from table "(Part):(Product)" with command "STORE" for record "TEIG"
And I set fields
    | nummer | 1teig            |
    | such   | TEIG             |
    | bsart  | Fremdbeschaffung |
And I save the current editor

Given I open an editor "dampfnudel" from table "(Part):(Product)" with command "STORE" for record "DAMPFNUDEL"
And I set fields
    | nummer | 1dn            |
    | such   | DAMPFNUDEL     |
    | bsart  | Eigenfertigung |
And I append rows
    | elex  | elanzahl    |
    | TEIG  | 1           |
    | A AG1 | !dontChange |
And I save the current editor

# Gesperrten Behaelter anlegen
Given I open an editor "behaelter_gesperrt" from table "(Container):(ContainerShell)" with command "NEW" for record ""
And I set field "packm" to "KLT"
And I set field "behstatusaz" to "gesperrt"
And I save the current editor

# Abgelegten Behaelter anlegen
And I create a Container "behaelter_abl" for packaging material "KLT"

Given I open an editor "behaelter_abl" from table "(Container):(ContainerShell)" with command "UPDATE" for record from editor "behaelter_abl"
And I set field "ablagef" to "ja"
And I save the current editor


Scenario: 00 b Behaelter zum Ausliefern anlegen
And I create a Container "behaelter_weg" for packaging material "KLT"

# Befuellen
And I post a receipt via ManualStockAdjustment for Product "DAMPFNUDEL" and quantity "100" on StorageLocation "F1" with document "L00" and Container "behaelter_weg"

# Und ausliefern mit VK-Lieferschein
Given I open an editor "Vkls00" from table "(Sales):(PackingSlip)" with command "NEW" for record ""
And I set fields
    | nummer | 0vkls   |
    | kunde  | RADSHOP |
    | ueb    | ja      |
And I append rows
    | artikel        | mge | behaelter         |
    | !dampfnudel^id | 100 | !behaelter_weg^id |
And I save the current editor

# Plausi: ist der Behaelter wirklich ausser Haus?
Given I open an editor "behaelter_weg" from table "(Container):(ContainerShell)" with command "VIEW" for record from editor "behaelter_weg"
Then field "behstatusaz" has value "Geliefert"
Then field "behleer" has value "nein"
Then the table has 0 rows
And I close the current editor


Scenario: 01 Ein gefuellter Behaelter kann nicht gesperrt werden
And I create a Container "behaelter_01p" for packaging material "KLT"

# Artikel in Behaelter buchen
And I post a receipt via ManualStockAdjustment for Product "PEDALE" and quantity "10" on StorageLocation "F1" with document "L01p" and Container "behaelter_01p"

Given I open an editor "behaelter_01p" from table "(Container):(ContainerShell)" with command "UPDATE" for record from editor "behaelter_01p"
# Fehler 11070: Der Behaelter muss leer sein
Then setting field "behstatusaz" to "gesperrt" throws the exception "11070"
And I close the current editor


Scenario: 02 Bei Bestandskorrektur kann kein gesperrter Behaelter, kein abgelegter Behaelter und kein Behaelter, der ausser Haus ist, eingetragen werden
Given I open an editor "Korrektur" for tip command "(SInventory)" and arguments ""
And I set field "artikel" to "DAMPFNUDEL"
And I set field "beleg" to "K02_p"
And I set field "beldat" to "."
And I set field "platz" to "F1" in row 1
And I set field "mge" to "20" in row 1
# Fehler 11072: Der Behaelter ist gesperrt
Then setting field "behaelter" in row 1 to "id" from editor "behaelter_gesperrt" in row 0 throws the exception "11072"
# Fehler 8413: Behaelter ist ausser Haus
Then setting field "behaelter" in row 1 to "id" from editor "behaelter_weg" in row 0 throws the exception "8413"
# Fehler 2564: Behaelter ist in der Ablage
Then setting field "behaelter" in row 1 to "id" from editor "behaelter_abl" in row 0 throws the exception "2564"
And I close the current editor


Scenario: 03 a Manuelle Lagerbuchung - Zugang. Es kann kein gesperrter Behaelter, kein abgelegter Behaelter und kein Behaelter, der ausser Haus ist, eingetragen werden
Given I open an editor "LbuchZu" for tip command "(Stockadjustment)" and arguments ""
And I set field "artikel" to "DAMPFNUDEL"
And I set field "beleg" to "K03z_p"
And I set field "beldat" to "."
And I set field "buart" to "zugang"

And I set field "mge" to "20" in row 1
And I set field "platz2" to "F1" in row 1
# Fehler 11072: Der Behaelter ist gesperrt
Then setting field "behaelter" in row 1 to "id" from editor "behaelter_gesperrt" in row 0 throws the exception "11072"
# Fehler 8413: Behaelter ist ausser Haus
Then setting field "behaelter" in row 1 to "id" from editor "behaelter_weg" in row 0 throws the exception "8413"
# Fehler 2564: Behaelter ist in der Ablage
Then setting field "behaelter" in row 1 to "id" from editor "behaelter_abl" in row 0 throws the exception "2564"
And I close the current editor


Scenario: 03 b Manuelle Lagerbuchung - Abgang. Es kann kein gesperrter Behaelter, kein abgelegter Behaelter und kein Behaelter, der ausser Haus ist, eingetragen werden
Given I open an editor "LbuchAb" for tip command "(Stockadjustment)" and arguments ""
And I set field "artikel" to "DAMPFNUDEL"
And I set field "beleg" to "K03a_p"
And I set field "beldat" to "."
And I set field "buart" to "Abgang"

And I set field "mge" to "20" in row 1
And I set field "platz" to "F1" in row 1
# Fehler 11072: Der Behaelter ist gesperrt
Then setting field "behaelter" in row 1 to "id" from editor "behaelter_gesperrt" in row 0 throws the exception "11072"
# Fehler 8413: Behaelter ist ausser Haus
Then setting field "behaelter" in row 1 to "id" from editor "behaelter_weg" in row 0 throws the exception "8413"
# Fehler 2564: Behaelter ist in der Ablage
Then setting field "behaelter" in row 1 to "id" from editor "behaelter_abl" in row 0 throws the exception "2564"
And I close the current editor


Scenario: 03 c Manuelle Lagerbuchung - Umbuchung. Es kann kein gesperrter Behaelter, kein abgelegter Behaelter und kein Behaelter, der ausser Haus ist, eingetragen werden
Given I open an editor "LbuchUm" for tip command "(Stockadjustment)" and arguments ""
And I set field "artikel" to "DAMPFNUDEL"
And I set field "beleg" to "K03u_p"
And I set field "beldat" to "."
And I set field "buart" to "Umbuchung"

And I set field "mge" to "20" in row 1
And I set field "platz" to "F1" in row 1
And I set field "platz2" to "F2" in row 1
# Fehler 11072: Der Behaelter ist gesperrt
Then setting field "behaelter" in row 1 to "id" from editor "behaelter_gesperrt" in row 0 throws the exception "11072"
# Fehler 8413: Behaelter ist ausser Haus
Then setting field "behaelter" in row 1 to "id" from editor "behaelter_weg" in row 0 throws the exception "8413"
# Fehler 2564: Behaelter ist in der Ablage
Then setting field "behaelter" in row 1 to "id" from editor "behaelter_abl" in row 0 throws the exception "2564"
And I close the current editor


Scenario: 04 Bei Verkaufslieferschein kann kein gesperrter Behaelter, kein abgelegter Behaelter und kein Behaelter, der ausser Haus ist, eingetragen werden
Given I open an editor "Vkls04p" from table "(Sales):(PackingSlip)" with command "NEW" for record ""
And I set fields
    | nummer | 4vkls   |
    | kunde  | RADSHOP |
And I create a new row at the end of the table
And I set field "artikel" to "DAMPFNUDEL" in row 1
And I set field "mge" to "100" in row 1
# Fehler 11072: Der Behaelter ist gesperrt
Then setting field "behaelter" in row 1 to "id" from editor "behaelter_gesperrt" in row 0 throws the exception "11072"
# Fehler 8413: Behaelter ist ausser Haus
Then setting field "behaelter" in row 1 to "id" from editor "behaelter_weg" in row 0 throws the exception "8413"
# Fehler 2564: Behaelter ist in der Ablage
Then setting field "behaelter" in row 1 to "id" from editor "behaelter_abl" in row 0 throws the exception "2564"
And I close the current editor


Scenario: 05 Bei Einkaufslieferschein kann kein gesperrter Behaelter und kein Behaelter, der ausser Haus ist, eingetragen werden
Given I open an editor "Ekls05p" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set fields
    | nummer | 5ekls   |
    | lief   | PUKY    |
And I create a new row at the end of the table
And I set field "artikel" to "TEIG" in row 1
And I set field "mge" to "100" in row 1
# Fehler 11072: Der Behaelter ist gesperrt
And I respond with answer "no" to the dialog with id "Externe Behälternummer ist bereits vergeben."
Then setting field "exbehnum" in row 1 to "nummer" from editor "behaelter_gesperrt" in row 0 throws the exception "11072"
# Fehler 8413: Behaelter ist ausser Haus
And I respond with answer "no" to the dialog with id "Externe Behälternummer ist bereits vergeben."
Then setting field "exbehnum" in row 1 to "nummer" from editor "behaelter_weg" in row 0 throws the exception "8413"
And I close the current editor


Scenario: 06 Bei Einkaufsbestellung mit MZs kann kein gesperrter Behaelter und kein Behaelter, der ausser Haus ist, eingetragen werden
Given I open an editor "Ekbe06p" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set fields
    | nummer | 6ekbe   |
    | lief   | PUKY    |
And I create a new row at the end of the table
And I set field "artikel" to "TEIG" in row 1
And I set field "mge" to "100" in row 1
And I press button "mzsubm" to open a subeditor for "Mz_06p" in row 1
And I delete all rows
And I append rows
	| lpsuch | zuomge |
	| F1     | 50     |
	| F2     | 50     |
# Fehler 11072: Der Behaelter ist gesperrt
And I respond with answer "no" to the dialog with id "Externe Behälternummer ist bereits vergeben."
Then setting field "exbehnum" in row 1 to "nummer" from editor "behaelter_gesperrt" in row 0 throws the exception "11072"
# Fehler 8413: Behaelter ist ausser Haus
And I respond with answer "no" to the dialog with id "Externe Behälternummer ist bereits vergeben."
Then setting field "exbehnum" in row 2 to "nummer" from editor "behaelter_weg" in row 0 throws the exception "8413"
And I close the current editor
And I switch the current editor to editor "Ekbe06p"
And I close the current editor


Scenario: 07 Bei Rueckmeldung in der Fertiung kann kein gesperrter Behaelter, kein abgelegter Behaelter und kein Behaelter, der ausser Haus ist, eingetragen werden
# Fertigungsvorschlag anlegen und freigeben
Given I open an editor "fv07p" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record "" 
And I create a new row at the end of the table
And I set field "artikel" to "DAMPFNUDEL" in row 1
And I set field "mge" to "160" in row 1
And I set field "bisuch" to "DAMPF_" in row 1
And I set field "mfreig" to "ja" in row 1
And I press button "freig" to open a subeditor for "fertigung"
And I save the current subeditor to switch back to the parent editor
And I close the current editor

# Rueckmeldung
Given I open an editor "As07p" from table "(Workorder):(WorkOrders)" with command "DONE" for record "DAMPF_001"
And I set field "gut" to "1"
And I set field "sofort" to "1"
And I set field "mgr" to "101"
# Fehler 11072: Der Behaelter ist gesperrt
Then setting field "behaelter" in row 0 to "id" from editor "behaelter_gesperrt" in row 0 throws the exception "11072"
# Fehler 8413: Behaelter ist ausser Haus
Then setting field "behaelter" in row 0 to "id" from editor "behaelter_weg" in row 0 throws the exception "8413"
# Fehler 2564: Behaelter ist in der Ablage
Then setting field "behaelter" in row 0 to "id" from editor "behaelter_abl" in row 0 throws the exception "2564"
And I close the current editor


Scenario: 08 Bei Materialentnahme kann kein gesperrter Behaelter, kein abgelegter Behaelter und kein Behaelter, der ausser Haus ist, eingetragen werden
Given I open an editor "manent08p" for tip command "(WOIssue)" and arguments ""
And I set field "auftrag" to "$,,such=DAMPF_001;@richtung=rückwärts;@maxtreffer=1"
And I set field "mgr" to "101"
And I set field "gmgevorschl" to "10"
And I set field "autorment" to "ja"
# Fehler 11072: Der Behaelter ist gesperrt
And I press button "stllad"
And I set field "manbu" to "ja" in row 1
Then setting field "behaelter" in row 1 to "id" from editor "behaelter_gesperrt" in row 0 throws the exception "11072"
# Fehler 8413: Behaelter ist ausser Haus
Then setting field "behaelter" in row 1 to "id" from editor "behaelter_weg" in row 0 throws the exception "8413"
# Fehler 2564: Behaelter ist in der Ablage
Then setting field "behaelter" in row 1 to "id" from editor "behaelter_abl" in row 0 throws the exception "2564"
And I close the current editor


Scenario: 09 Statuswechsel eines Behaelters auf gesperrt erzeugt eine Packmittelbuchung
And I create a Container "behaelter_09p" for packaging material "BEHAELTER"
Given I open an editor "behaelter_09p" from table "(Container):(ContainerShell)" with command "NEW" for record ""
And I set field "nummer" to "9behp"
And I set field "such" to "behaelter_09p"
And I set field "packm" to "BEHAELTER"
And I save the current editor

# Journal pruefen auf Packmittelbuchung
Given I query "artikel, buarta, ursache, detursache, mge, behaelter" from table "(Journal):(Journal)" where "artikel==BEHAELTER;buarta==Abgang"
Then query has no hits

Given I open an editor "behaelter_09p" from table "(Container):(ContainerShell)" with command "UPDATE" for record from editor "behaelter_09p"
And I set field "behstatusaz" to "gesperrt"
And I save the current editor

# Journal pruefen auf Packmittelbuchung
Given I query "artikel, buarta, ursache, detursache, mge, erbtext1" from table "(Journal):(Journal)" where "artikel==BEHAELTER;buarta==Abgang"
Then query has values
    | artikel   | buarta | ursache         | detursache                       | mge | erbtext1                        |
    | BEHAELTER | Abgang | Behälterstatus | Automatische Packmittelkorrektur | 1   | Behälterstatus geändert: 9behp|

