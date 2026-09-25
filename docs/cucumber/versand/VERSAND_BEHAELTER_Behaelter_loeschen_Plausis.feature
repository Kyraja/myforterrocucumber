
@persistent
Feature: VERSAND_BEHAELTER_Behaelter_loeschen_Plausis.feature

# *****************************************************************************
#  Name             : VERSAND_BEHAELTER_Behaelter_loeschen_Plausis.feature
#  Autor            : drpf
#  Verantwortlich   : drpf
#  Kontrolle        : carue
#  Funktion         : Testet Inventur Plausi
#  ref              : ref_behaelter_loeschen_cu
#
# *****************************************************************************

# Vorgaenger basis_stammdaten.feature

Background:
Given I set the fake date to "02.01.1995"

@testvorbereitung
Scenario: Behaelter anlegen

Given I create a Container "LOESCH01" for packaging material "KLT"
Given I create a Container "LOESCH02" for packaging material "KLT"
Given I create a Container "LOESCH03" for packaging material "KLT"

@testvorbereitung
Scenario: Bestaende zubuchen in LOESCH02 und LOESCH03, LOESCH01 bleibt leer

Given I set StorageQuantity to zero for Product "EINK" on StorageLocation "F1"

Given I open an editor "Lagerbuchung" for tip command "(Stockadjustment)" and arguments ""
And I set fields
    | artikel   | EINK          |
    | buart     | Zugang        |
    | beleg     | TEST_LOESCH   |
    | beldat    | .             |
And I delete all rows
And I append rows
    | mge    | platz2   | behaelter     |
    | 10     | F1       | !LOESCH02^id  |
    | 15     | F2       |               |
And I save the current editor

Scenario: 01 Behaelter kann nicht geloescht oder abgelegt werden, wenn auf lebendiger Zaehlliste

# Zaehlliste anlegen und leeren Behaelter eintragen
Given I open an editor "ZAEHL_01" from table "(Stocktaking):(EnterQuantitiesCounted)" with command "NEW" for record ""
And I set field "such" to "ZAEHL_01"
And I delete all rows
And I append rows
    | artikel   | platz   | behaelter     |
    | EINK      | F2      | !LOESCH01^id  |
And I save the current editor

Given I open an editor "Invbearb" from table "(Stocktaking):(EnterQuantitiesCounted)" with command "RELEASE" for record "ZAEHL_01" and menu choice "Ja"
And I save the current editor

# Behaelter ablegen oder loeschen ist nicht moeglich
Given I switch the current editor to editor "LOESCH01" with command "UPDATE"
And I set field "ablagef" to "ja"
Then saving the current editor throws the exception "10373"
And I close the current editor

Given I switch the current editor to editor "LOESCH01" with command "DELETE"
Then saving the current editor throws the exception "10373"
And I close the current editor

# Aufraeumen Zaehlliste abschliessen
Given I open an editor "BestAbschluss" from table "(Stocktaking):(EnterQuantitiesCounted)" with command "DONE" for record "ZAEHL_01" and menu choice "Ja"
And I save the current editor

Given I open an editor "BestAbschluss" from table "(Stocktaking):(EnterQuantitiesCounted)" with command "TRANSFER" for record "ZAEHL_01" and menu choice "Ja"
And I save the current editor

# Behaelter ablegen moeglich
Given I switch the current editor to editor "LOESCH01" with command "UPDATE"
And I set field "ablagef" to "ja"
And I save the current editor

# Behaelter Ablageflag wieder erntfernen f�r n�chsten Test
Given I switch the current editor to editor "LOESCH01" with command "UPDATE"
And I set field "ablagef" to "nein"
And I save the current editor

Scenario: 02 Behaelter in ungebuchtem EK-LS darf nicht abgelegt oder geloescht werden

Given I open an editor "EKLS02" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set fields
    | lief      | LIEFER1   |
    | vom       | .         |
    | ebeleg    | EKLS02    |
And I delete all rows
And I append rows
    | artikel   | mge   | !dialogId                                     | !dialogAnswer | exbehnum  |
    | EINK      | 30    | Externe Behälternummer ist bereits vergeben. | nein          | LOESCH01  |
And I save the current editor

# Behaelter ablegen oder loeschen ist nicht moeglich
Given I switch the current editor to editor "LOESCH01" with command "UPDATE"
And I set field "ablagef" to "ja"
Then saving the current editor throws the exception "10373"
And I close the current editor

And I switch the current editor to editor "LOESCH01" with command "DELETE"
Then saving the current editor throws the exception "10373"
And I close the current editor

# Aufrauemen Lieferschein loeschen
And I switch the current editor to editor "EKLS02" with command "UPDATE"
And I delete all rows
And I save the current editor

# Behaelter ablegen moeglich
Given I switch the current editor to editor "LOESCH01" with command "UPDATE"
And I set field "ablagef" to "ja"
And I save the current editor

# Behaelter Ablageflag wieder erntfernen f�r n�chsten Test
Given I switch the current editor to editor "LOESCH01" with command "UPDATE"
And I set field "ablagef" to "nein"
And I save the current editor

Scenario: 03 Behaelter in ungebuchter EK-RE mit Lagerbewegung darf nicht abgelegt oder geloescht werden

Given I open an editor "EKRE03" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set fields
    | lief      | LIEFER1   |
    | vom       | .         |
    | ebeleg    | EKRE03    |
    | budat     | .         |
    | fakt      | ja        |
And I delete all rows
And I append rows
    | artikel   | mge   | !dialogId                                     | !dialogAnswer | exbehnum  |
    | EINK      | 30    | Externe Behälternummer ist bereits vergeben. | nein          | LOESCH01  |
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# Behaelter ablegen oder loeschen ist nicht moeglich
Given I switch the current editor to editor "LOESCH01" with command "UPDATE"
And I set field "ablagef" to "ja"
Then saving the current editor throws the exception "10373"
And I close the current editor

And I switch the current editor to editor "LOESCH01" with command "DELETE"
Then saving the current editor throws the exception "10373"
And I close the current editor

# Aufrauemen Rechnung loeschen
And I switch the current editor to editor "EKRE03" with command "UPDATE"
And I delete all rows
And I save the current editor

# Behaelter ablegen moeglich
Given I switch the current editor to editor "LOESCH01" with command "UPDATE"
And I set field "ablagef" to "ja"
And I save the current editor

# Behaelter Ablageflag wieder erntfernen f�r n�chsten Test
Given I switch the current editor to editor "LOESCH01" with command "UPDATE"
And I set field "ablagef" to "nein"
And I save the current editor

Scenario: 04 Behaelter der in MZ in EK-Bestellung eingetragen, darf nicht abgelegt oder geloescht werden

Given I open an editor "EKBE_MZ" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set fields
    | lief      | LIEFER1   |
    | such      | EKBE_MZ   |
And I delete all rows
And I append rows
    | artikel   | mge   |
    | EINK      | 30    |
And I press button "mzsubm" to open a subeditor for "Materialzuordnung_04" in row 1
And I delete all rows
And I append rows
    | lpsuch | zuomge | !dialogId                                     | !dialogAnswer | exbehnum  |
    | F1     | 20     | Externe Behälternummer ist bereits vergeben. | nein          | LOESCH01  |
    | F2     | 10     |                                               |               |           |
And I save the current subeditor to switch back to the parent editor
And I save the current editor

# Behaelter ablegen oder loeschen ist nicht moeglich
Given I switch the current editor to editor "LOESCH01" with command "UPDATE"
And I set field "ablagef" to "ja"
Then saving the current editor throws the exception "10373"
And I close the current editor

And I switch the current editor to editor "LOESCH01" with command "DELETE"
Then saving the current editor throws the exception "10373"
And I close the current editor

# Aufrauemen Bestellung loeschen
And I switch the current editor to editor "EKBE_MZ" with command "UPDATE"
And I respond with answer "ja" to the dialog with id "3180"
And I set field "mge" to "0" in row 1
And I save the current editor

# Behaelter ablegen moeglich
Given I switch the current editor to editor "LOESCH01" with command "UPDATE"
And I set field "ablagef" to "ja"
And I save the current editor

# Behaelter Ablageflag wieder erntfernen f�r n�chsten Test
Given I switch the current editor to editor "LOESCH01" with command "UPDATE"
And I set field "ablagef" to "nein"
And I save the current editor

Scenario: 05 Behaelter der in MZ in EK-Lieferschein eingetragen, darf nicht abgelegt oder geloescht werden

Given I open an editor "EKLS_MZ05" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set fields
    | lief      | LIEFER1   |
    | vom       | .         |
    | ebeleg    | EKLS_MZ05 |
And I delete all rows
And I append rows
    | artikel   | mge   |
    | EINK      | 30    |
And I press button "mzsubm" to open a subeditor for "Materialzuordnung_05" in row 1
And I delete all rows
And I append rows
    | lpsuch | zuomge | !dialogId                                     | !dialogAnswer | exbehnum  |
    | F1     | 20     | Externe Behälternummer ist bereits vergeben. | nein          | LOESCH01  |
    | F2     | 10     |                                               |               |           |
And I save the current subeditor to switch back to the parent editor
And I save the current editor

# Behaelter ablegen oder loeschen ist nicht moeglich
Given I switch the current editor to editor "LOESCH01" with command "UPDATE"
And I set field "ablagef" to "ja"
Then saving the current editor throws the exception "10373"
And I close the current editor

And I switch the current editor to editor "LOESCH01" with command "DELETE"
Then saving the current editor throws the exception "10373"
And I close the current editor

# Aufrauemen Lieferschein loeschen
And I switch the current editor to editor "EKLS_MZ05" with command "UPDATE"
And I delete all rows
And I save the current editor

# Behaelter ablegen moeglich
Given I switch the current editor to editor "LOESCH01" with command "UPDATE"
And I set field "ablagef" to "ja"
And I save the current editor

# Behaelter Ablageflag wieder erntfernen f�r n�chsten Test
Given I switch the current editor to editor "LOESCH01" with command "UPDATE"
And I set field "ablagef" to "nein"
And I save the current editor
 
Scenario: 06 Behaelter der in MZ in EK-Rechnung mit Lagerbewegung eingetragen, darf nicht abgelegt oder geloescht werden

Given I open an editor "EKRE_MZ06" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set fields
    | lief      | LIEFER1   |
    | vom       | .         |
    | ebeleg    | EKRE_MZ06 |
    | budat     | .         |
    | fakt      | ja        |
And I delete all rows
And I append rows
    | artikel   | mge   |
    | EINK      | 30    |
And I press button "mzsubm" to open a subeditor for "Materialzuordnung_06" in row 1
And I delete all rows
And I append rows
    | lpsuch | zuomge | !dialogId                                     | !dialogAnswer | exbehnum  |
    | F1     | 20     | Externe Behälternummer ist bereits vergeben. | nein          | LOESCH01  |
    | F2     | 10     |                                               |               |           |
And I save the current subeditor to switch back to the parent editor
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# Behaelter ablegen oder loeschen ist nicht moeglich
Given I switch the current editor to editor "LOESCH01" with command "UPDATE"
And I set field "ablagef" to "ja"
Then saving the current editor throws the exception "10373"
And I close the current editor

And I switch the current editor to editor "LOESCH01" with command "DELETE"
Then saving the current editor throws the exception "10373"
And I close the current editor

# Aufrauemen Rechnung loeschen
And I switch the current editor to editor "EKRE_MZ06" with command "UPDATE"
And I delete all rows
And I save the current editor

# Behaelter ablegen moeglich
Given I switch the current editor to editor "LOESCH01" with command "UPDATE"
And I set field "ablagef" to "ja"
And I save the current editor

# Behaelter Ablageflag wieder erntfernen f�r n�chsten Test
Given I switch the current editor to editor "LOESCH01" with command "UPDATE"
And I set field "ablagef" to "nein"
And I save the current editor

Scenario: 07 Behaelter in MZ Zugang Fertigteil darf nicht abgelegt oder geloescht werden

# Fertigungsvorschlag und MZ anlegen
Given I open an editor "FV07" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record "" 
And I append rows
    | artikel   | mge   | bisuch | mfreig    |
    | BG1       | 10    | FV07_  | ja        |
And I press button "mzsubm" to open a subeditor for "Materialzuordnung" in row 1
And I delete all rows
And I append rows
    | zuomge  | behaelter        |
    | 10      | !LOESCH01^nummer |
And I save the current subeditor to switch back to the parent editor
And I press button "freig" to open a subeditor for "BA_freigeben"
And I save the current subeditor to switch back to the parent editor
And I close the current editor

# Behaelter ablegen oder loeschen ist nicht moeglich
Given I switch the current editor to editor "LOESCH01" with command "UPDATE"
And I set field "ablagef" to "ja"
Then saving the current editor throws the exception "10373"
And I close the current editor

And I switch the current editor to editor "LOESCH01" with command "DELETE"
Then saving the current editor throws the exception "10373"
And I close the current editor

# MZ loeschen
Given I open an editor "FV07" from table "(Purchasing):(WorkOrderSuggestions)" with command "UPDATE" for record "" 
And I press button "ladetab"
And I press button "mzsubm" to open a subeditor for "Materialzuordnung" in row 1
And I delete all rows
And I save the current subeditor to switch back to the parent editor
And I close the current editor

# Aufrauemen BA loeschen
Given I open an editor "Betriebsauftrag" from table "(Workorder):(WorkOrders)" with command "UPDATE" for record "FV07_000"
And I respond with answer "ja" to the dialog with id "345"
And I set field "status" to "s"
And I save the current editor

# Behaelter ablegen moeglich
Given I switch the current editor to editor "LOESCH01" with command "UPDATE"
And I set field "ablagef" to "ja"
And I save the current editor

# Behaelter Ablageflag wieder erntfernen f�r n�chsten Test
Given I switch the current editor to editor "LOESCH01" with command "UPDATE"
And I set field "ablagef" to "nein"
And I save the current editor

Scenario: 08 Behaelter in ungebuchter Rueckmeldung darf nicht abgelegt oder geloescht werden

Given I create a work order "FV08" for Product "BG1" with quantity "10" and search word "FV08_"

# Rueckmeldung ohne buchen speichern, Behaelter im Kopf eingetragen
Given I open an editor "RM_AS2" from table "(Workorder):(WorkOrders)" with command "DONE" for record "FV08_002"
And I set field "behaelter" to "!LOESCH01^id"
And I set field "gutmge" to "5" in row 1
And I save the current editor

# Behaelter ablegen oder loeschen ist nicht moeglich
Given I switch the current editor to editor "LOESCH01" with command "UPDATE"
And I set field "ablagef" to "ja"
Then saving the current editor throws the exception "10373"
And I close the current editor

And I switch the current editor to editor "LOESCH01" with command "DELETE"
Then saving the current editor throws the exception "10373"
And I close the current editor

# Aufraeumen Rueckmeldung und BA loeschen
Given I switch the current editor to editor "RM_AS2" with command "DELETE"
And I respond with answer "ja" to the dialog with id "826"
And I save the current editor

Given I open an editor "Betriebsauftrag" from table "(Workorder):(WorkOrders)" with command "UPDATE" for record "FV08_000"
And I respond with answer "ja" to the dialog with id "345"
And I set field "status" to "s"
And I save the current editor

# Behaelter ablegen moeglich
Given I switch the current editor to editor "LOESCH01" with command "UPDATE"
And I set field "ablagef" to "ja"
And I save the current editor

# Behaelter Ablageflag wieder erntfernen f�r n�chsten Test
Given I switch the current editor to editor "LOESCH01" with command "UPDATE"
And I set field "ablagef" to "nein"
And I save the current editor

Scenario: 09 Behaelter in MZ fuer Koppelprodukt darf nicht abgelegt oder geloescht werden

# Fertigungsvorschlag und MZ anlegen
Given I open an editor "FV09" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record "" 
And I append rows
    | artikel       | mge   | mfreig    |
    | BG-KOPPELPROD | 10    | ja        |
And I press button "mzabsm" to open a subeditor for "Materialzuordnung" in row 1
And I press button for next product 
Then field "artikel" has value "KOPPELPROD"
And I delete all rows
And I append rows
    | lpsuch | zuomge  | behaelter        |
    | F1     | 10      | !LOESCH01^nummer |
And I save the current editor
And I switch the current editor to editor "FV09"
And I set field "bisuch" to "FV09_" in row 1
And I press button "freig" to open a subeditor for "BA_freigeben"
And I save the current subeditor to switch back to the parent editor
And I close the current editor

# Behaelter ablegen oder loeschen ist nicht moeglich
Given I switch the current editor to editor "LOESCH01" with command "UPDATE"
And I set field "ablagef" to "ja"
Then saving the current editor throws the exception "10373"
And I close the current editor

#Given I switch the current editor to editor "LOESCH01" with command "DELETE"
Given I open an editor "LOESCH01" from table "(Container):(ContainerShell)" with command "DELETE" for record "LOESCH01"
Then saving the current editor throws the exception "10373"
And I close the current editor

# MZ loeschen
Given I open an editor "FV09" from table "(Purchasing):(WorkOrderSuggestions)" with command "UPDATE" for record "" 
And I press button "ladetab"
Then field "artikel" has value "BG-KOPPELPROD" in row 3
And I press button "mzabsm" to open a subeditor for "Materialzuordnung" in row 3
And I press button for next product 
Then field "artikel" has value "KOPPELPROD"
And I delete all rows
And I save the current editor
And I switch the current editor to editor "FV09"
And I close the current editor

# Aufrauemen BA loeschen
Given I open an editor "Betriebsauftrag" from table "(Workorder):(WorkOrders)" with command "UPDATE" for record "FV09_000"
And I respond with answer "ja" to the dialog with id "345"
And I set field "status" to "s"
And I save the current editor

# Behaelter ablegen moeglich
Given I switch the current editor to editor "LOESCH01" with command "UPDATE"
And I set field "ablagef" to "ja"
And I save the current editor

# Behaelter Ablageflag wieder erntfernen f�r n�chsten Test
Given I switch the current editor to editor "LOESCH01" with command "UPDATE"
And I set field "ablagef" to "nein"
And I save the current editor

Scenario: 10 geloeschter Behaelter geht in Ablage, Verweise in Vorgaengen und LJ bleiben vorhanden, Ablageflag kann entfernt werden

Given I create a Container "BEH_ABLAGE" for packaging material "KLT"

Given I create a work order "FV10" for Product "BG1" with quantity "10" and search word "FV10_"

# Teilrueckmeldung buchen, Behaelter im Kopf eingetragen
Given I open an editor "RM_AS2" from table "(Workorder):(WorkOrders)" with command "DONE" for record "FV10_002"
And I set fields
    | behaelter | !BEH_ABLAGE^id |
    | sofort    | ja             |
And I set field "gutmge" to "5" in row 1
And I save the current editor

# Behaelter leeren
Given I open an editor "Lagerbuchung" for tip command "(Stockadjustment)" and arguments ""
And I set fields
    | artikel     | BG1         |
    | beleg       | UML         |
    | beldat      | .           |
    | buart       | Umbuchung   |
And I modify table
    | !row  | mge   | platz | platz2  | behaelter       | behaelterzu   |
    | +1    | 5     | F1    | F1      | !BEH_ABLAGE^id  |               |
And I save the current editor

# Behaelter loeschen bringt ihn in die Ablage
And I switch the current editor to editor "BEH_ABLAGE" with command "DELETE"
And I respond with answer "ja" to the dialog with id "826"
And I save the current editor
Then field "ablagef" has value "ja"

# Behaelter-Verweis ist in Rueckmeldung weiterhin vorhanden
Given I open an editor "RM_AS2" from table "(Workorder):(CompletionConfirmations)" with command "VIEW" for search criteria "$,,such=FV10_002;@ablageart=abgelegt;@richtung=rückwärts;@maxtreffer=1"
Then field "behaelter^id" has value "!BEH_ABLAGE^id"
Then field "behaelter" contains value "+"
And I close the current editor

# Behaelter-Verweis ist im LJ-Eintrag weiterhin vorhanden
Given I open the infosystem "LJ"
And I set field "beleg" to "barmex" from editor "RM_AS2"
And I set field "richtung" to "rückwärts"
And I press start
Then table has values
	| art   | zmge  | behaelter^id	 |
	| BG1  	|  5    | !BEH_ABLAGE^id |
Then field "behaelter" contains value "+" in row 1
And I close the current editor

# Behaelter Ablageflag kann wieder entfernen werden
Given I switch the current editor to editor "BEH_ABLAGE" with command "UPDATE"
And I set field "ablagef" to "nein"
And I save the current editor

# Rueckmeldung buchen, Behaelter kann wieder verwendet werden
Given I open an editor "RM_AS2" from table "(Workorder):(WorkOrders)" with command "DONE" for record "FV10_002"
And I set field "behaelter" to "!BEH_ABLAGE^id"
And I set field "gutmge" to "5" in row 1
And I save the current editor

#######################################
### dafuer wird es ein neues Issue geben
#
#Scenario: 11 Storno eines VK-LS mit abgelegtem oder geloeschten Behaelter ist moeglich, Behaelter wird wiederbelebt
#
#Given I open an editor "VKLS_10" from table "(Sales):(PackingSlip)" with command "NEW" for record ""
#And I set fields
#    | kunde     | KUNDE1    |
#    | such      | VKLS_10   |
#    | vom       | .         |
#    | ueb       | ja        |
#And I delete all rows
#And I append rows
#    | artikel   | mge   | behaelter    |
#    | EINK      | 10    | !LOESCH02^id |
#And I save the current editor
#
## Behaelter ablegen
#And I switch the current editor to editor "LOESCH02" with command "UPDATE"
#Then field "behstatusaz" has value "Geliefert"
#And I set field "ablagef" to "ja"
#And I save the current editor

#And I reverse the PackingSlip "VKLS_10"
#
## Behaelter ist wieder lebendig und korrekt gefuellt
#And I switch the current editor to editor "LOESCH02" with command "VIEW"
#Then fields have values
#    | ablagef   | nein  |
#    | platz     | F1    |
#Then table has values
#    | artikel   | mge   |
#    | EINK      | 10    |
#And I close the current editor
