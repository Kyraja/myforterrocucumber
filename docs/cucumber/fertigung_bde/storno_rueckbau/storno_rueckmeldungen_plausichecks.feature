@persistent
Feature: storno_rueckmeldungen_plausichecks.feature

  Background:
    And I set the fake date to "04.01.1995"

# *****************************************************************************
#  Name             : storno_rueckmeldungen_plausichecks
#  Autor            : lschneider
#  Verantwortlich   : drpf
#  Kontrolle        : amk
#  Funktion         : Testet die Plausis im Storno von Rückmeldungen
#  Jira-Issue       : FDA-543
# *****************************************************************************

## Rückmeldungen eines lebendigen Betriebsauftrags

  Scenario: 01 In einer Storno-Rückmeldung sind alle Felder zu Mengen-, Zeit- und Artikelangaben schreibgeschützt
# Fertigungsvorschlag anlegen und freigeben
    Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
    And I append rows
      | artikel   | netmge | bisuch  | mfreig |
      | BAUGRUPPE | 10     | SCHUTZ_ | ja     |
    And I press button "freig" to open a subeditor for "BA_freigeben"
    And I close the current editor
    And I switch the current editor to editor "fvor"
    And I save the current editor

# Rückmeldung auf ersten Arbeitsgang
    Given I open an editor "Rückmeldung1" from table "(Workorder):(WorkOrders)" with command "DONE" for record "SCHUTZ_001"
    And I set field "sofort" to "1"
    And I set field "gutmge" to "5" in row 1
    And I save the current editor

# Erste Rückmeldung stornieren, Schreibschutz auf Feldern prüfen
    And I switch the current editor to editor "Rückmeldung1" with command "REVERSAL"
    Then fields have values
      | sofort | ja |
    Then field "sofort" is not modifiable
    Then field "artikel" is not modifiable in row 1
    Then field "mge" is not modifiable in row 1
    Then field "status" is empty in row 1
    Then field "gut" is not modifiable
    Then field "mgereduzieren" is not modifiable
    Then field "mzeit" is not modifiable
    Then field "bzeit" is not modifiable
    Then field "manrest" is not modifiable
    Then field "stornorest" is not modifiable
    And I close the current editor

# Rückmeldung zweiter Arbeitsgang, Betriebsauftrag abschließen
    Given I open an editor "Rückmeldung2" from table "(Workorder):(WorkOrders)" with command "DONE" for record "SCHUTZ_001"
    And I set field "gut" to "1"
    And I set field "sofort" to "1"
    And I save the current editor


  Scenario: 02 Bemerkung im Kopf und Erbtext in Zeile sind in Storno-Rückmeldung beschreibbar, Erbtext wird ins LJ übernommen
# Fertigungsvorschlag anlegen und freigeben
    Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
    And I append rows
      | artikel   | netmge | bisuch   | mfreig |
      | BAUGRUPPE | 10     | SCHREIB_ | ja     |
    And I press button "freig" to open a subeditor for "BA_freigeben"
    And I close the current editor
    And I switch the current editor to editor "fvor"
    And I save the current editor

# Rückmeldung auf ersten Arbeitsgang
    Given I open an editor "Rückmeldung1" from table "(Workorder):(WorkOrders)" with command "DONE" for record "SCHREIB_001"
    And I set field "gutmge" to "5" in row 1
    And I set field "sofort" to "1"
    And I save the current editor

# Erste Rückmeldung stornieren, Erbtexte für Gutmnege und Material hinterlegen
    And I switch the current editor to editor "Rückmeldung1" with command "REVERSAL"
    Then field "bem" is modifiable
    Then field "erbtext1" is modifiable in row 1
    And I set field "erbtext1" to "Erbtext1 Gutmenge" in row 1
    And I set field "erbtext1" to "Erbtext1 Material" in row 2
    And I set field "erbtext1" to "" in row 3
    And I save the current editor

# Lagerjournaleintrag prüfen
    Given I open the infosystem "LJ"
    And I set field "adatum" to "."
    And I set field "beleg" to "barmex" from editor "Rückmeldung1"
    And I set field "richtung" to "rückwärts"
    And I press start
    Then table has values
      | art       | erbtext1          |
      | BAUGRUPPE | Erbtext1 Gutmenge |
      | EINKAUF-1 |                   |
      | EINKAUF-2 | Erbtext1 Material |
    And I close the current editor

# Betriebsauftrag abschließen
    Given I open an editor "Rückmeldung1" from table "(Workorder):(WorkOrders)" with command "DONE" for record "SCHREIB_000"
    And I set field "gut" to "1"
    And I set field "sofort" to "1"
    And I set field "mgr" to "112"
    And I save the current editor


  Scenario: 03 Eine Sorno-Rückmeldung hat den Typ Storno Rückmeldung und kennt den Originalbeleg, stornierte Rückmeldung erhält Typ stornierte Rückmeldung
# Fertigungsvorschlag anlegen und freigeben
    Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
    And I append rows
      | artikel    | netmge | bisuch | mfreig |
      | BAUGRUPPE2 | 10     | TYP_   | ja     |
    And I press button "freig" to open a subeditor for "BA_freigeben"
    And I close the current editor
    And I switch the current editor to editor "fvor"
    And I save the current editor

# Rückmeldung auf ersten Arbeitsgang
    Given I open an editor "Rückmeldung1" from table "(Workorder):(WorkOrders)" with command "DONE" for record "TYP_001"
    And I set field "gutmge" to "5" in row 1
    And I set field "sofort" to "1"
    And I save the current editor

# Erste Rückmeldung stornieren, Typen prüfen in Storno Rückmeldung und stornierter Rückmeldung
    Given I open an editor "Storno1" from table "(Workorder):(CompletionConfirmations)" with command "REVERSAL" for search criteria "$,, such=TYP_001;@richtung=rückwärts;@ablageart=abgelegt;@maxtreffer=1"
    Then field "typa279" has value "Storno-Rückmeldung"
    Then field "stornopartnervorg^id" has value equal to field "id" from editor "Rückmeldung1"
    And I save the current editor

    Given I switch the current editor to editor "Rückmeldung1" with command "VIEW"
    Then field "typa279" has value "Stornierte Rückmeldung"
    Then field "stornopartnervorg^id" has value equal to field "id" from editor "Storno1"
    And I close the current editor

# Betriebsauftrag abschließen
    Given I open an editor "Rückmeldung2" from table "(Workorder):(WorkOrders)" with command "DONE" for record "TYP_000"
    And I set field "gut" to "1"
    And I set field "sofort" to "1"
    And I set field "mgr" to "112"
    And I save the current editor


  Scenario: 04 In einer Storno-Rückmeldung haben die Mengen das gegenteile Vorzeichen zum Originalbeleg
# Fertigungsvorschlag anlegen und freigeben
    Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
    And I append rows
      | artikel  | netmge | mfreig | bisuch     |
      | BG-UMBAU | 10     | ja     | GEGENTEIL_ |
    And I press button "freig" to open a subeditor for "BA_freigeben"
    And I close the current editor
    And I switch the current editor to editor "fvor"
    And I save the current editor

# Rückmeldung auf ersten Arbeitsgang
    Given I open an editor "Rückmeldung1" from table "(Workorder):(WorkOrders)" with command "DONE" for record "GEGENTEIL_001"
    And I set field "gutmge" to "5" in row 1
    And I set field "sofort" to "1"
    And I save the current editor

# Erste Rückmeldung stornieren, gegenteilige Vorzeichen prüfen
    And I switch the current editor to editor "Rückmeldung1" with command "REVERSAL"
    Then the table has 3 rows
    Then field "mge" has value "5" in row 1
    Then field "gutmge" has value "-5" in row 1
    Then field "mge" has value "-10" in row 2
    Then field "mge" has value "-5" in row 3
    And I save the current editor

# Betriebsauftrag abschließen
    Given I open an editor "Rückmeldung2" from table "(Workorder):(WorkOrders)" with command "DONE" for record "GEGENTEIL_000"
    And I set field "gut" to "1"
    And I set field "sofort" to "1"
    And I set field "mgr" to "112"
    And I save the current editor


  Scenario: 05 Stunden- und Gemeinkostensätze werden in Storno-Rückmeldung aus dem Originalbeleg gezogen
# Fertigungsvorschlag anlegen und freigeben
    Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
    And I append rows
      | artikel   | netmge | bisuch  | mfreig |
      | BAUGRUPPE | 10     | KOSTEN_ | ja     |
    And I press button "freig" to open a subeditor for "BA_freigeben"
    And I close the current editor
    And I switch the current editor to editor "fvor"
    And I save the current editor

# Rückmeldung auf ersten Arbeitsgang, Änderung in Stunden- und Geimeinkostensatz
    Given I open an editor "Rückmeldung1" from table "(Workorder):(WorkOrders)" with command "DONE" for record "KOSTEN_001"
    And I set fields
      | bsatz   | 25 |
      | fixkost | 30 |
      | sofort  | 1  |
    And I set field "gutmge" to "5" in row 1
    And I save the current editor

# Erste Rückmeldung stornieren, Stunden- und Gemeinkostensätze prüfen
    Given I switch the current editor to editor "Rückmeldung1" with command "REVERSAL"
    Then field "bsatz" has value "25.0000"
    Then field "fixkost" has value "30.00"
    And I save the current editor

# Rückmeldung auf zweiten Arbeitsgang, Betriebsauftrag abschließen
    Given I open an editor "Rückmeldung2" from table "(Workorder):(WorkOrders)" with command "DONE" for record "KOSTEN_000"
    And I set field "gut" to "1"
    And I set field "sofort" to "1"
    And I set field "mgr" to "112"
    And I save the current editor


  Scenario: 06 Eine noch nicht gebuchte Rückmeldung kann nicht storniert werden
# Fertigungsvorschlag anlegen und freigeben
    Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
    And I append rows
      | artikel   | netmge | mfreig | bisuch    |
      | BAUGRUPPE | 10     | ja     | OFFENERM_ |
    And I press button "freig" to open a subeditor for "BA_freigeben"
    And I close the current editor
    And I switch the current editor to editor "fvor"
    And I save the current editor

# Rückmeldung auf ersten Arbeitsgang speichern und Fehler bei Rückmeldung stornieren: Dieser Vorgang ist noch nicht gebucht
    Given I open an editor "Rückmeldung1" from table "(Workorder):(WorkOrders)" with command "DONE" for record "OFFENERM_001"
    And I set field "gutmge" to "5" in row 1
    And I save the current editor

    Then opening an editor from table "(Workorder):(CompletionConfirmations)" with command "REVERSAL" for record from editor "Rückmeldung1" throws the exception "7058"
    And I close the current editor

    And I switch the current editor to editor "Rückmeldung1" with command "UPDATE"
    And I set fields
      | gut    | ja |
      | sofort | ja |
    And I save the current editor


#Scenario: 07 Storno möglich, wenn es noch ungebuchte Rückmeldungen zum gleichen oder einem anderen Arbeitsschein gibt
# Storno ist möglich --> zu Prozesstests


  Scenario: 08 Eine stornierte Rückmeldung kann nicht noch einmal storniert werden
# Fertigungsvorschlag anlegen und freigeben
    Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
    And I append rows
      | artikel   | netmge | mfreig | bisuch      |
      | BAUGRUPPE | 10     | ja     | STORNOZWEI_ |
    And I press button "freig" to open a subeditor for "BA_freigeben"
    And I close the current editor
    And I switch the current editor to editor "fvor"
    And I save the current editor

# Rückmeldung auf ersten Arbeitsgang und Rückmeldung stornieren
    Given I open an editor "Rückmeldung1" from table "(Workorder):(WorkOrders)" with command "DONE" for record "STORNOZWEI_001"
    And I set field "sofort" to "1"
    And I set field "gutmge" to "5" in row 1
    And I save the current editor

    Given I open an editor "Storno1" via ID from editor "Rückmeldung1" from field "id" in row 0 for table "(Workorder):(CompletionConfirmations)" with command "REVERSAL"
    And I save the current editor

    Then opening an editor from table "(Workorder):(CompletionConfirmations)" with command "REVERSAL" for record from editor "Rückmeldung1" throws the exception "149"
    And I close the current editor


  Scenario: 09 Eine Storno-Rückmeldung kann nicht storniert werden
# Fertigungsvorschlag anlegen und freigeben
    Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
    And I append rows
      | artikel   | netmge | mfreig | bisuch       |
      | BAUGRUPPE | 10     | ja     | STORNOZWEI2_ |
    And I press button "freig" to open a subeditor for "BA_freigeben"
    And I close the current editor
    And I switch the current editor to editor "fvor"
    And I save the current editor

# Rückmeldung auf ersten Arbeitsgang und Rückmeldung stornieren
    Given I open an editor "Rückmeldung1" from table "(Workorder):(WorkOrders)" with command "DONE" for record "STORNOZWEI2_001"
    And I set field "sofort" to "1"
    And I set field "gutmge" to "5" in row 1
    And I save the current editor

    Given I open an editor "Storno1" via ID from editor "Rückmeldung1" from field "id" in row 0 for table "(Workorder):(CompletionConfirmations)" with command "REVERSAL"
    And I save the current editor

# Storno stornieren bringt Fehler
    Then opening an editor from table "(Workorder):(CompletionConfirmations)" with command "REVERSAL" for record from editor "Storno1" throws the exception "149"
    And I close the current editor


  Scenario: 10 Kein Storno der Rückmeldung möglich, wenn bereits Rückgabe erfolgt ist
# Fertigungsvorschlag anlegen und freigeben
    Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
    And I append rows
      | artikel   | netmge | bisuch    | mfreig |
      | BAUGRUPPE | 10     | MATERIAL_ | ja     |
    And I press button "freig" to open a subeditor for "BA_freigeben"
    And I close the current editor
    And I switch the current editor to editor "fvor"
    And I save the current editor

# Rückmeldung auf ersten Arbeitsgang
    Given I open an editor "Rückmeldung1" from table "(Workorder):(WorkOrders)" with command "DONE" for record "MATERIAL_001"
    And I set field "sofort" to "1"
    And I set field "gutmge" to "5" in row 1
    And I save the current editor

# Rückbau auf ersten Arbeitsschein
    Given I open an editor "Rückbau1" from table "(Workorder):(WorkOrders)" with command "RETURN" for record "MATERIAL_001"
    And I set field "sofort" to "ja"
    And I set field "gutmge" to "-5" in row 1
    And I save the current editor

# Rückmeldung stornieren nicht möglich
    Given opening an editor from table "(Workorder):(CompletionConfirmations)" with command "REVERSAL" for record from editor "Rückmeldung1" throws the exception "2199"
    And I close the current editor

# Betriebsauftrag abschließen
    Given I open an editor "Betriebsauftrag" from table "(Workorder):(WorkOrders)" with command "UPDATE" for record "MATERIAL_000"
    And I respond with answer "ja" to the dialog with id "345"
    And I set field "status" to "s"
    And I save the current editor


  Scenario: 11 Wurden über die Rückmeldung Restmengen storniert, werden diese bei einem Storno nicht wieder erhöht
# Fertigungsvorschlag anlegen und freigeben
    Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
    And I append rows
      | artikel    | netmge | mfreig |
      | BAUGRUPPE2 | 10     | ja     |
    And I press button "absteig" to open a subeditor for "AFL" in row 1
    And I set field "manbu" to "ja" in row 1
    And I save the current editor
    And I switch the current editor to editor "fvor"
    And I set field "bisuch" to "RESTMENGE_" in row 1
    And I press button "freig" to open a subeditor for "BA_freigeben"
    And I close the current editor
    And I switch the current editor to editor "fvor"
    And I save the current editor

# Teil-Rückmeldung auf ersten Arbeitsgang, Restmengen stornieren
    Given I open an editor "Rückmeldung1" from table "(Workorder):(WorkOrders)" with command "DONE" for record "RESTMENGE_001"
    And I set field "gutmge" to "5" in row 1
    And I set field "stornorest" to "ja"
    And I set field "sofort" to "1"
    And I save the current editor

# Erste Rückmeldung stornieren
    And I switch the current editor to editor "Rückmeldung1" with command "REVERSAL"
    And I save the current editor

# Offene Menge in AFL prüfen und BA abschließen
    Given I open an editor "Betriebsauftrag" from table "(Workorder):(WorkOrders)" with command "UPDATE" for record "RESTMENGE_000"
    And I press button "absteig" to open a subeditor for "AFL_pruef"
    Then field "limge" has value "0" in row 1
    Then field "limge" has value "10" in row 2
    And I close the current editor
    And I switch the current editor to editor "Betriebsauftrag"
    And I respond with answer "JA" to the dialog with id "345"
    And I set field "status" to "s"
    And I save the current editor


  Scenario: 12 Wenn zu stornierende Rückmeldung den Arbeitsgang erledigt hat, hat Storno-Rückmeldung keinen Status und Status in Originalbeleg wird geleert
# Fertigungsvorschlag anlegen und freigeben
    Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
    And I append rows
      | artikel    | netmge | bisuch  | mfreig | binoloe |
      | BAUGRUPPE2 | 10     | STATUS_ | ja     | ja      |
    And I press button "freig" to open a subeditor for "BA_freigeben"
    And I close the current editor
    And I switch the current editor to editor "fvor"
    And I save the current editor

# Rückmeldung auf ersten Arbeitsgang
    Given I open an editor "Rückmeldung1" from table "(Workorder):(WorkOrders)" with command "DONE" for record "STATUS_001"
    And I set field "gut" to "1"
    And I set field "sofort" to "1"
    And I save the current editor

# Erste Rückmeldung stornieren
    And I switch the current editor to editor "Rückmeldung1" with command "REVERSAL"
    Then field "status" is empty in row 1
    And I save the current editor

# Status in Originalbeleg prüfen
    And I switch the current editor to editor "Rückmeldung1" with command "VIEW"
    Then field "status" is empty in row 1
    And I close the current editor

# Betriebsauftrag abschließen
    Given I open an editor "Arbeitsschein2" from table "(Workorder):(WorkOrders)" with command "DONE" for record "STATUS_000"
    And I set field "gut" to "1"
    And I set field "sofort" to "1"
    And I set field "mgr" to "112"
    And I save the current editor


  Scenario: 13 Fehlermeldung, wenn Material wird bei Storno einer Rückmeldung wieder zurück in einen gesperrten Behälter gebucht werden soll
# Behälter anlegen
    Given I open an editor "GESPERRT" from table "(Container):(ContainerShell)" with command "NEW" for record ""
    And I set fields
      | such  | GESPERRT  |
      | packm | BEHAELTER |
    And I save the current editor

# Material in Behälter buchen
    Given I open an editor "Lagerbuchung" for tip command "LBuchung" and arguments ""
    And I set fields
      | artikel | EINKAUF-1 |
      | beleg   | 13-L      |
      | beldat  | .         |
      | buart   | Zugang    |
    And I create a new row at the end of the table
    And I set field "mge" to "20" in row 1
    And I set field "behaelter" to id from editor "GESPERRT" in row 1
    And I save the current editor

# Fertigungsvorschlag anlegen und freigeben
    Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
    And I append rows
      | artikel    | mge | mfreig |
      | BAUGRUPPE2 | 10  | ja     |
    And I press button "mzabsm" to open a subeditor for "MZMaterial" in row 1
    And I create a new row at the end of the table
    And I set field "zuomge" to "20" in row 1
    And I set field "behaelter" to id from editor "GESPERRT" in row 1
    And I save the current editor
    And I switch the current editor to editor "fvor"
    And I set field "bisuch" to "BEHSPERRE_" in row 1
    And I press button "freig" to open a subeditor for "BA"
    And I close the current editor
    And I switch the current editor to editor "fvor"
    And I close the current editor

# Rückmeldung auf ersten Arbeitsgang
    Given I open an editor "Rückmeldung1" from table "(Workorder):(WorkOrders)" with command "DONE" for record "BEHSPERRE_001"
    And I set fields
      | sofort | 1 |
      | gut    | 1 |
    And I set field "behaelter" to id from editor "GESPERRT"
    And I save the current editor

# Behaälter sperren
    And I switch the current editor to editor "GESPERRT" with command "UPDATE"
    And I set field "behstatusaz" to "Gesperrt"
    And I save the current editor

# Rückmeldung stornieren
    Then opening an editor from table "(Workorder):(CompletionConfirmations)" with command "REVERSAL" for record from editor "Rückmeldung1" throws the exception "11072"
    And I close the current editor

# Betriebsauftrag abschließen
    Given I open an editor "Betriebsauftrag" from table "(Workorder):(WorkOrders)" with command "UPDATE" for record "BEHSPERRE_000"
    And I respond with answer "ja" to the dialog with id "1483"
    And I set field "status" to "s"
    And I save the current editor


  Scenario: 14 Hinweis beim Abbruch eines BAs auf erhöhte Herstellkosten pro Fertigteil
# Fertigungsvorschlag anlegen und freigeben
    Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
    And I append rows
      | artikel    | netmge | bisuch | mfreig |
      | BAUGRUPPE2 | 50     | HEKO_  | ja     |
    And I press button "freig" to open a subeditor for "BA_freigeben"
    And I close the current editor
    And I switch the current editor to editor "fvor"
    And I save the current editor

# Betriebsauftrag abschließen
    Given I open an editor "Betriebsauftrag1" from table "(Workorder):(WorkOrders)" with command "UPDATE" for record "HEKO_000"
    And I respond with answer "nein" to the dialog with id "345"
    Then setting field "status" to "s" throws the exception "1361"
    And I save the current editor

# Rückmeldung auf ersten Arbeitsgang
    Given I open an editor "Rückmeldung1" from table "(Workorder):(WorkOrders)" with command "DONE" for record "HEKO_001"
    And I set field "sofort" to "1"
    And I set field "gutmge" to "10" in row 1
    And I save the current editor

# Betriebsauftrag abschließen
    Given I open an editor "Betriebsauftrag2" from table "(Workorder):(WorkOrders)" with command "UPDATE" for record "HEKO_000"
    And I respond with answer "Ja" to the dialog with id "1483"
    And I set field "status" to "s"
    And I set field "status" to " "
    And I save the current editor

# Rückmeldung auf ersten Arbeitsgang
    Given I open an editor "Rückmeldung2" from table "(Workorder):(WorkOrders)" with command "DONE" for record "HEKO_000"
    And I set field "mgr" to "112"
    And I set field "sofort" to "1"
    And I set field "status" to "s" in row 1
    And I set field "gutmge" to "9" in row 1
    And I respond with answer "nein" to the dialog with id "1483"
    And saving the current editor throws the exception "2743"
    And I set field "gutmge" to "10" in row 1
    And I save the current editor




## Rückmeldungen eines lebendigen Betriebsauftrags

  Scenario: A01 In einer Storno-Rückmeldung sind alle Felder zu Mengen-, Zeit-, Artikel- und Buchungsangaben schreibgeschützt
# Fertigungsvorschlag anlegen und freigeben
    Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
    And I append rows
      | artikel   | netmge | bisuch   | mfreig |
      | BAUGRUPPE | 10     | SCHUTZA_ | ja     |
    And I press button "freig" to open a subeditor for "BA_freigeben"
    And I close the current editor
    And I switch the current editor to editor "fvor"
    And I save the current editor

# Rückmeldung auf ersten Arbeitsgang
    Given I open an editor "Rückmeldung1" from table "(Workorder):(WorkOrders)" with command "DONE" for record "SCHUTZA_001"
    And I set field "sofort" to "1"
    And I set field "gut" to "1"
    And I save the current editor

# Erste Rückmeldung stornieren, Schreibschutz auf Feldern prüfen
    And I switch the current editor to editor "Rückmeldung1" with command "REVERSAL"
    Then fields have values
      | sofort | ja |
    Then field "sofort" is not modifiable
    Then field "artikel" is not modifiable in row 1
    Then field "mge" is not modifiable in row 1
    Then field "status" is empty in row 1
    Then field "gut" is not modifiable
    Then field "mgereduzieren" is not modifiable
    Then field "mzeit" is not modifiable
    Then field "bzeit" is not modifiable
    Then field "manrest" is not modifiable
    Then field "stornorest" is not modifiable
    And I save the current editor


  Scenario: A02 Bemerkung im Kopf und Erbtext in Zeile sind in Storno-Rückmeldung beschreibbar
# Fertigungsvorschlag anlegen und freigeben
    Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
    And I append rows
      | artikel   | netmge | bisuch    | mfreig |
      | BAUGRUPPE | 10     | SCHREIBA_ | ja     |
    And I press button "freig" to open a subeditor for "BA_freigeben"
    And I close the current editor
    And I switch the current editor to editor "fvor"
    And I save the current editor

# Rückmeldung auf ersten Arbeitsgang
    Given I open an editor "Rückmeldung1" from table "(Workorder):(WorkOrders)" with command "DONE" for record "SCHREIBA_001"
    And I set field "sofort" to "1"
    And I set field "gut" to "1"
    And I save the current editor

# Erste Rückmeldung stornieren, Erbtexte für Gutmnege und Material hinterlegen
    And I switch the current editor to editor "Rückmeldung1" with command "REVERSAL"
    Then field "bem" is modifiable
    Then field "erbtext1" is modifiable in row 1
    And I set field "erbtext1" to "Erbtext1 Gutmenge" in row 1
    And I set field "erbtext1" to "Erbtext1 Material" in row 2
    And I set field "erbtext1" to "" in row 3
    And I save the current editor

# Lagerjournaleintrag prüfen
    Given I open the infosystem "LJ"
    And I set field "beleg" to "barmex" from editor "Rückmeldung1"
    And I set field "richtung" to "rückwärts"
    And I press start
    Then table has values
      | art       | erbtext1          |
      | BAUGRUPPE | Erbtext1 Gutmenge |
      | EINKAUF-1 |                   |
      | EINKAUF-2 | Erbtext1 Material |
    And I close the current editor

# FDA-980: Typ im Storno-Beleg wird falsch gesetzt (Zeile 579)
  Scenario: A03 Durch den Storno auf einen abgelegten FV werden die Belegtypen korrekt gesetzt
# Fertigungsvorschlag anlegen und freigeben
    Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
    And I append rows
      | artikel   | netmge | bisuch | mfreig |
      | BAUGRUPPE | 10     | TYPA_  | ja     |
    And I press button "freig" to open a subeditor for "BA_freigeben"
    And I close the current editor
    And I switch the current editor to editor "fvor"
    And I save the current editor

# Rückmeldungen auf ersten Arbeitsgang
    Given I open an editor "Rückmeldung1" from table "(Workorder):(WorkOrders)" with command "DONE" for record "TYPA_001"
    And I set field "sofort" to "1"
    And I set field "gutmge" to "5" in row 1
    And I save the current editor
    And I set the fake date to "05.01.1995"
    And I wait 1 time units to move the time forward

    Given I open an editor "Rückmeldung2" from table "(Workorder):(WorkOrders)" with command "DONE" for record "TYPA_001"
    And I set field "sofort" to "1"
    And I set field "gutmge" to "5" in row 1
    And I save the current editor

# Erste Rückmeldung stornieren, Typen prüfen: Storno-Rückmeldung auf abeglegten FV und stornierte Rückmeldung
    Given I open an editor "Storno1" via ID from editor "Rückmeldung1" from field "id" in row 0 for table "(Workorder):(CompletionConfirmations)" with command "REVERSAL"
    Then field "typa279" has value "Storno-Rückmeldung auf abgelegten Fertigungsvorschlag"
    Then field "stornopartnervorg^id" has value equal to field "id" from editor "Rückmeldung1"
    And I save the current editor
    Then field "typa279" from editor "Rückmeldung1" in row 0 has value "Stornierte Rückmeldung"

# Nachbuchen auf abgelegten FV
    Given I open an editor "Rückmeldung3" via ID from editor "Rückmeldung2" from field "id" in row 0 for table "(Workorder):(CompletionConfirmations)" with command "COPY"
    And I set field "gutmge" to "5" in row 1
    Then field "typa279" has value "Rückmeldung auf abgelegten Fertigungsvorschlag"
    And I save the current editor

# Nachgebuchte Rückmeldung stornieren, Typen prüfen: Storno-Rückmeldung auf abeglegten FV und stornierte Rückmeldung auf abgelegten FV
    Given I open an editor "Storno2" via ID from editor "Rückmeldung3" from field "id" in row 0 for table "(Workorder):(CompletionConfirmations)" with command "REVERSAL"
    Then field "typa279" has value "Storno-Rückmeldung auf abgelegten Fertigungsvorschlag"
    Then field "stornopartnervorg^id" has value equal to field "id" from editor "Rückmeldung3"
    And I save the current editor
    Then field "typa279" from editor "Rückmeldung3" in row 0 has value "Stornierte Rückmeldung auf abgelegten Fertigungsvorschlag"


  Scenario: A04 In einer Storno-Rückmeldung haben die Mengen das gegenteilige Vorzeichen zum Originalbeleg
# Fertigungsvorschlag anlegen und freigeben
    Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
    And I append rows
      | artikel  | netmge | mfreig | bisuch      |
      | BG-UMBAU | 10     | ja     | GEGENTEILA_ |
    And I press button "freig" to open a subeditor for "BA_freigeben"
    And I close the current editor
    And I switch the current editor to editor "fvor"
    And I save the current editor

# Rückmeldung auf ersten Arbeitsgang
    Given I open an editor "Rückmeldung1" from table "(Workorder):(WorkOrders)" with command "DONE" for record "GEGENTEILA_001"
    And I set field "sofort" to "1"
    And I set field "gut" to "1"
    And I save the current editor

# Erste Rückmeldung stornieren, gegenteilige Vorzeichen prüfen, LJ prüfen
    And I switch the current editor to editor "Rückmeldung1" with command "REVERSAL"
    Then the table has 3 rows
    Then table has values
      | artikel   | mge | gutmge |
      | BG-UMBAU  | 0   | -10    |
      | EINKAUF-1 | -20 | 0      |
      | UMBAUART  | -10 | 0      |
    And I save the current editor

    Given I open the infosystem "LJ"
    And I set field "beleg" to "nummer" from editor "Rückmeldung1"
    And I set field "richtung" to "rückwärts"
    And I press start
    Then table has values
      | art       | amge | zmge | !row |
      | BG-UMBAU  |      | -10  | 1    |
      | UMBAUART  |      | -10  | 2    |
      | EINKAUF-1 | -20  |      | 3    |
      | BG-UMBAU  |      | 10   | 4    |
      | UMBAUART  |      | 10   | 5    |
      | EINKAUF-1 | 20   |      | 6    |
    And I close the current editor


  Scenario: A05 Stunden- und Gemeinkostensätze werden in Storno-Rückmeldung aus dem Originalbeleg gezogen
# Fertigungsvorschlag anlegen und freigeben
    Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
    And I append rows
      | artikel   | netmge | bisuch   | mfreig |
      | BAUGRUPPE | 10     | KOSTENA_ | ja     |
    And I press button "freig" to open a subeditor for "BA_freigeben"
    And I close the current editor
    And I switch the current editor to editor "fvor"
    And I save the current editor

# Rückmeldung auf ersten Arbeitsgang, Änderung in Stunden- und Geimeinkostensatz
    Given I open an editor "Rückmeldung1" from table "(Workorder):(WorkOrders)" with command "DONE" for record "KOSTENA_001"
    And I set fields
      | bsatz   | 25 |
      | fixkost | 30 |
      | sofort  | 1  |
      | gut     | 1  |
    And I save the current editor

# Erste Rückmeldung stornieren, Stunden- und Gemeinkostensätze prüfen
    Given I switch the current editor to editor "Rückmeldung1" with command "REVERSAL"
    Then field "bsatz" has value "25.0000"
    Then field "fixkost" has value "30.00"
    And I save the current editor


  Scenario: A06 Eine stornierte Rückmeldung kann nicht noch einmal storniert werden
# Fertigungsvorschlag anlegen und freigeben
    Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
    And I append rows
      | artikel   | netmge | bisuch   | mfreig |
      | BAUGRUPPE | 10     | DOPPELA_ | ja     |
    And I press button "freig" to open a subeditor for "BA_freigeben"
    And I close the current editor
    And I switch the current editor to editor "fvor"
    And I save the current editor

# Rückmeldung auf ersten Arbeitsgang, Änderung in Stunden- und Geimeinkostensatz
    Given I open an editor "Rückmeldung1" from table "(Workorder):(WorkOrders)" with command "DONE" for record "DOPPELA_001"
    And I set fields
      | sofort | 1 |
      | gut    | 1 |
    And I save the current editor

    Given I open an editor "Storno1" via ID from editor "Rückmeldung1" from field "id" in row 0 for table "(Workorder):(CompletionConfirmations)" with command "REVERSAL"
    And I save the current editor

    Given opening an editor from table "(Workorder):(CompletionConfirmations)" with command "REVERSAL" for record from editor "Rückmeldung1" throws the exception "149"
    And I close the current editor


  Scenario: A07 Eine Storno-Rückmeldung kann nicht storniert werden
# Fertigungsvorschlag anlegen und freigeben
    Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
    And I append rows
      | artikel   | netmge | bisuch   | mfreig |
      | BAUGRUPPE | 10     | DOPPELA_ | ja     |
    And I press button "freig" to open a subeditor for "BA_freigeben"
    And I close the current editor
    And I switch the current editor to editor "fvor"
    And I save the current editor

# Rückmeldung auf ersten Arbeitsgang, Änderung in Stunden- und Geimeinkostensatz
    Given I open an editor "Rückmeldung1" from table "(Workorder):(WorkOrders)" with command "DONE" for record "DOPPELA_001"
    And I set fields
      | sofort | 1 |
      | gut    | 1 |
    And I save the current editor

    Given I open an editor "Storno1" via ID from editor "Rückmeldung1" from field "id" in row 0 for table "(Workorder):(CompletionConfirmations)" with command "REVERSAL"
    And I save the current editor

    Given opening an editor from table "(Workorder):(CompletionConfirmations)" with command "REVERSAL" for record from editor "Storno1" throws the exception "149"
    And I close the current editor


  Scenario: A08 Kein Storno der Rückmeldung möglich, wenn bereits Rückgabe erfolgt ist
# Fertigungsvorschlag anlegen und freigeben
    Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
    And I append rows
      | artikel   | netmge | bisuch     | mfreig |
      | BAUGRUPPE | 10     | MATERIALA_ | ja     |
    And I press button "freig" to open a subeditor for "BA_freigeben"
    And I close the current editor
    And I switch the current editor to editor "fvor"
    And I save the current editor

# Rückmeldung auf ersten Arbeitsgang
    Given I open an editor "Rückmeldung1" from table "(Workorder):(WorkOrders)" with command "DONE" for record "MATERIALA_001"
    And I set field "sofort" to "1"
    And I set field "gut" to "1"
    And I save the current editor

# Rückbau auf ersten Arbeitsschein
    Given I open an editor "Rückbau1" via ID from editor "Rückmeldung1" from field "id" in row 0 for table "(Workorder):(CompletionConfirmations)" with command "COPY"
    And I set field "gutmge" to "-5" in row 1
    And I save the current editor

# Rückmeldung stornieren nicht möglich
    Then opening an editor from table "(Workorder):(CompletionConfirmations)" with command "REVERSAL" for record from editor "Rückmeldung1" throws the exception "2199"
    And I close the current editor


  Scenario: A09 Durch einen Storno verbleibt der FV in der Ablage, die offenen Mengen bleiben 0
# Fertigungsvorschlag anlegen und freigeben
    Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
    And I append rows
      | artikel   | netmge | bisuch      | mfreig |
      | BAUGRUPPE | 10     | OFFENEMGEA_ | ja     |
    And I press button "freig" to open a subeditor for "BA_freigeben"
    And I close the current editor
    And I switch the current editor to editor "fvor"
    And I save the current editor
    Given I open an editor "Rückmeldung1" from table "(Workorder):(WorkOrders)" with command "VIEW" for record "OFFENEMGEA_000"
    And I save value from field "nummer" in row 0
    And I close the current editor

# Rückmeldung auf ersten Arbeitsgang und Storno der Rückmeldung
    Given I open an editor "Rückmeldung1" from table "(Workorder):(WorkOrders)" with command "DONE" for record "OFFENEMGEA_001"
    And I set field "sofort" to "1"
    And I set field "gut" to "1"
    And I save the current editor

    Given I switch the current editor to editor "Rückmeldung1" with command "REVERSAL"
    And I save the current editor

# FV ist weiter in der Ablage und die offenen Mengen sind 0
    Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "VIEW" for record ""
    And I set field "banummer" in row 0 to saved value
    And I press button "ladetab"
    Then table has values
      | artikel   | netlimge | limge |
      | BAUGRUPPE | 0        | 0     |
    And I press button "absteig" to open a subeditor for "AFL" in row 1
    Then table has values
      | elex      | limge | frgmge |
      | EINKAUF-1 | 0     | 0      |
      | EINKAUF-2 | 0     | 0      |
    And I close the current editor
    And I switch the current editor to editor "fvor"
    And I close the current editor


  Scenario: A10 Beim stornieren der Rueckmeldung auf den letzten Arbeitsschein pruefen, ob auf den BA schon mehr rueckgemeldet wurde
# Fertigungsvorschlag anlegen und freigeben
    Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
    And I append rows
      | artikel   | netmge | bisuch    | mfreig |
      | BAUGRUPPE | 10     | STORNORF_ | ja     |
    And I press button "freig" to open a subeditor for "BA_freigeben"
    And I close the current editor
    And I switch the current editor to editor "fvor"
    And I save the current editor

# Rückmeldung auf letzten Arbeitsgang mit Gutmenge 7
    Given I open an editor "Rückmeldung1" from table "(Workorder):(WorkOrders)" with command "DONE" for record "STORNORF_001"
    And I set field "sofort" to "1"
    And I modify table
      | gutmge | !row |
      | 7      | 1    |
    And I save the current editor

# Rückmeldung auf Betriebsauftrag mit Gutmenge 5
    Given I open an editor "Rückmeldung2" from table "(Workorder):(WorkOrders)" with command "DONE" for record "STORNORF_000"
    And I set field "mgr" to "112"
    And I set field "sofort" to "1"
    And I modify table
      | gutmge | !row |
      | 5      | 1    |
    And I save the current editor

# Rückmeldung auf letzten Arbeitsschein stornieren
    Given opening an editor from table "(Workorder):(CompletionConfirmations)" with command "REVERSAL" for record from editor "Rückmeldung1" throws the exception "9503"
    And I close the current editor


