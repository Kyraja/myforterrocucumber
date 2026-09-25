@persistent
Feature: storno_rueckbau_rueckmeldungen_plausichecks.feature

  Background:
    And I set the fake date to "05.02.1995"

# *****************************************************************************
#  Autor            : lschneider
#  Name             : storno_rueckbau_rueckmeldungen_plausichecks
#  Verantwortlich   : drpf
#  Kontrolle        : amk
#  Funktion         : Testet die Prozesse Storno des Rückbaus auf Rückmeldungen
#  Jira-Issue       : FDA-1025
# *****************************************************************************

  Scenario: 01 In einem Rückbau-Storno sind alle Felder zu Mengen-, Zeit-, Artikel- und Buchungsangaben schreibgeschützt
# Auftrag und Fertigungsvorschlag anlegen und freigeben
    Given I create a SalesOrder "auftrag" for Customer "RADSHOP" with Product "BAUGRUPPE" and quantity "10"
    Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
    And I append rows
      | artikel   | netmge | bisuch  | mfreig |
      | BAUGRUPPE | 10     | SCHUTZ_ | ja     |
    And I press button "freig" to open a subeditor for "BA_freigeben"
    And I close the current editor
    And I switch the current editor to editor "fvor"
    And I save the current editor

# Rückmeldung und Rückbau auf ersten Arbeitsgang
    Given I open an editor "Rückmeldung1" from table "(Workorder):(WorkOrders)" with command "DONE" for record "SCHUTZ_001"
    And I set field "sofort" to "1"
    And I set field "gutmge" to "5" in row 1
    And I save the current editor

    Given I open an editor "Rückbau1" from table "(Workorder):(WorkOrders)" with command "RETURN" for record "SCHUTZ_001"
    And I set field "sofort" to "1"
    And I set field "gutmge" to "-3" in row 1
    And I save the current editor

# Rückbau stornieren, Schreibschutz auf Feldern prüfen
    Given I open an editor "Storno1_Rückbau" via ID from editor "Rückbau1" from field "id" in row 0 for table "(Workorder):(CompletionConfirmations)" with command "REVERSAL"
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

# Rückmeldung zweiter Arbeitsgang, Betriebsauftrag abschließen
    Given I open an editor "Rückmeldung2" from table "(Workorder):(WorkOrders)" with command "DONE" for record "SCHUTZ_001"
    And I set field "gut" to "1"
    And I set field "sofort" to "1"
    And I save the current editor

    Given I deliver the SalesOrder "auftrag" with PackingSlip "LS-P01"


  Scenario: 02 Bemerkung im Kopf und Erbtext in Zeile sind in Stornobeleg beschreibbar
# Fertigungsvorschlag anlegen und freigeben
    Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
    And I append rows
      | artikel   | netmge | bisuch   | mfreig |
      | BAUGRUPPE | 10     | SCHREIB_ | ja     |
    And I press button "freig" to open a subeditor for "BA_freigeben"
    And I close the current editor
    And I switch the current editor to editor "fvor"
    And I save the current editor

# Rückmeldung und Rückbau auf ersten Arbeitsgang
    Given I open an editor "Rückmeldung1" from table "(Workorder):(WorkOrders)" with command "DONE" for record "SCHREIB_001"
    And I set field "sofort" to "1"
    And I set field "gutmge" to "5" in row 1
    And I save the current editor

    Given I open an editor "Rückbau1" from table "(Workorder):(WorkOrders)" with command "RETURN" for record "SCHREIB_001"
    And I set field "sofort" to "ja"
    Then field "bem" is modifiable
    And I modify table
      | erbtext1          | gutmge | !row |
      | Erbtext1 Gutmenge | -1     | 1    |
    And I save the current editor

# Rückbau stornieren, Erbtexte für Gutmnege und Material hinterlegen
    Given I open an editor "Storno1_Rückbau" via ID from editor "Rückbau1" from field "id" in row 0 for table "(Workorder):(CompletionConfirmations)" with command "REVERSAL"
    Then field "bem" is modifiable
    And I modify table
      | erbtext1  | !row |
      | Gutmenge1 | 1    |
    And I save the current editor

# Lagerjournaleintrag prüfen
    Given I open the infosystem "LJ"
    And I set fields
      | adatum   | .                    |
      | beleg    | !Rückmeldung1^barmex |
      | artikel  | BAUGRUPPE            |
      | richtung | rückwärts            |
    And I press start
    Then table has values
      | art       | erbtext1          |
      | BAUGRUPPE | Gutmenge1         |
      | BAUGRUPPE | Erbtext1 Gutmenge |
    And I close the current editor

# Betriebsauftrag abschließen
    Given I open an editor "Rückmeldung2" from table "(Workorder):(WorkOrders)" with command "DONE" for record "SCHREIB_001"
    And I set field "gut" to "1"
    And I set field "sofort" to "1"
    And I save the current editor


  Scenario: 03 Eine Rückbau-Storno hat den Typ Storno Rückbau und kennt den Originalbeleg, stornierte Rückmeldung erhält Typ stornierter Rückbau
# Fertigungsvorschlag anlegen und freigeben
    Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
    And I append rows
      | artikel    | netmge | bisuch | mfreig |
      | BAUGRUPPE2 | 10     | TYP_   | ja     |
    And I press button "freig" to open a subeditor for "BA_freigeben"
    And I close the current editor
    And I switch the current editor to editor "fvor"
    And I save the current editor

# Rückmeldung und Rückbau auf ersten Arbeitsgang
    Given I open an editor "Rückmeldung1" from table "(Workorder):(WorkOrders)" with command "DONE" for record "TYP_001"
    And I set field "gutmge" to "5" in row 1
    And I set field "sofort" to "1"
    And I save the current editor

    Given I open an editor "Rückbau1" from table "(Workorder):(WorkOrders)" with command "RETURN" for record "TYP_001"
    And I set field "gutmge" to "-3" in row 1
    And I set field "sofort" to "1"
    And I save the current editor

# Rückbau stornieren, Typen prüfen in Storno-Rückbau auf Betriebsauftrag und stornierter Rückbau auf Betriebsauftrag
    Given I open an editor "Storno1_Rückbau" via ID from editor "Rückbau1" from field "id" in row 0 for table "(Workorder):(CompletionConfirmations)" with command "REVERSAL"
    Then field "typa279" has value "Storno-Rückbau auf Betriebsauftrag"
    Then field "stornopartnervorg^id" has value equal to field "id" from editor "Rückbau1"
    And I save the current editor

    Then field "typa279" from editor "Rückbau1" in row 0 has value "Stornierter Rückbau auf Betriebsauftrag"

# Betriebsauftrag abschließen
    Given I open an editor "Rückmeldung2" from table "(Workorder):(WorkOrders)" with command "DONE" for record "TYP_001"
    And I set field "gut" to "1"
    And I set field "sofort" to "1"
    And I save the current editor


  Scenario: 04 In einem Stornobeleg sind haben die Mengen das gegenteilige Vorzeichen zum Originalbeleg
# Fertigungsvorschlag anlegen und freigeben
    Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
    And I append rows
      | artikel  | netmge | mfreig | bisuch     |
      | BG-UMBAU | 10     | ja     | GEGENTEIL_ |
    And I press button "freig" to open a subeditor for "BA_freigeben"
    And I close the current editor
    And I switch the current editor to editor "fvor"
    And I save the current editor

# Rückmeldung und Rückbau auf ersten Arbeitsgang
    Given I open an editor "Rückmeldung1" from table "(Workorder):(WorkOrders)" with command "DONE" for record "GEGENTEIL_001"
    And I set field "gutmge" to "5" in row 1
    And I set field "sofort" to "1"
    And I save the current editor

    Given I open an editor "Rückbau1" from table "(Workorder):(WorkOrders)" with command "RETURN" for record "GEGENTEIL_001"
    And I set field "gutmge" to "-3" in row 1
    And I set field "sofort" to "1"
    And I save the current editor

# Rückbau stornieren, gegenteilige Vorzeichen prüfen
    Given I open an editor "Storno1_Rückbau" via ID from editor "Rückbau1" from field "id" in row 0 for table "(Workorder):(CompletionConfirmations)" with command "REVERSAL"
    Then the table has 3 rows
    Then table has values
      | !row | mge | gutmge |
      | 1    | 8   | 3      |
      | 2    | 6   | 0      |
      | 3    | 3   | 0      |
    And I save the current editor

# Betriebsauftrag abschließen
    Given I open an editor "Rückmeldung2" from table "(Workorder):(WorkOrders)" with command "DONE" for record "GEGENTEIL_001"
    And I set field "gut" to "1"
    And I set field "sofort" to "1"
    And I save the current editor


  Scenario: 05 Stunden- und Gemeinkostensätze werden im Stornobeleg aus dem Originalbeleg gezogen
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
    And I set field "sofort" to "ja"
    And I set field "gutmge" to "5" in row 1
    And I save the current editor

    Given I open an editor "Rückbau1" from table "(Workorder):(WorkOrders)" with command "RETURN" for record "KOSTEN_001"
    And I set fields
      | bsatz   | 25 |
      | fixkost | 30 |
      | sofort  | 1  |
    And I set field "gutmge" to "-3" in row 1
    And I save the current editor

# Rückbau stornieren, Stunden- und Gemeinkostensätze prüfen
    Given I open an editor "Storno1_Rückbau" via ID from editor "Rückbau1" from field "id" in row 0 for table "(Workorder):(CompletionConfirmations)" with command "REVERSAL"
    Then field "bsatz" has value "25.0000"
    Then field "fixkost" has value "30.00"
    And I save the current editor

# Rückmeldung auf zweiten Arbeitsgang, Betriebsauftrag abschließen
    Given I open an editor "Rückmeldung2" from table "(Workorder):(WorkOrders)" with command "DONE" for record "KOSTEN_001"
    And I set field "gut" to "1"
    And I set field "sofort" to "1"
    And I save the current editor


  Scenario: 06 Eine noch nicht gebuchter Rückbau kann nicht storniert werden
# Fertigungsvorschlag anlegen und freigeben
    Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
    And I append rows
      | artikel   | netmge | mfreig | bisuch    |
      | BAUGRUPPE | 10     | ja     | OFFENERM_ |
    And I press button "freig" to open a subeditor for "BA_freigeben"
    And I close the current editor
    And I switch the current editor to editor "fvor"
    And I save the current editor

# Rückmeldung und Rückbau auf ersten Arbeitsgang speichern
    Given I open an editor "Rückmeldung1" from table "(Workorder):(WorkOrders)" with command "DONE" for record "OFFENERM_001"
    And I set field "sofort" to "ja"
    And I set field "gutmge" to "5" in row 1
    And I save the current editor

    Given I open an editor "Rückbau1" from table "(Workorder):(WorkOrders)" with command "RETURN" for record "OFFENERM_001"
    And I set field "gutmge" to "-3" in row 1
    And I save the current editor

# Storno des Rückbaus führt zu Fehler: Dieser Vorgang ist noch nicht gebucht
    Then opening an editor from table "(Workorder):(CompletionConfirmations)" with command "REVERSAL" for record from editor "Rückbau1" throws the exception "7058"
    And I close the current editor

# Betriebsauftrag abschließen
    And I switch the current editor to editor "Rückbau1" with command "UPDATE"
    And I set field "sofort" to "ja"
    And I save the current editor

    Given I open an editor "Rückmeldung2" from table "(Workorder):(WorkOrders)" with command "DONE" for record "OFFENERM_001"
    And I set field "sofort" to "ja"
    And I set field "gut" to "ja"
    And I save the current editor


  Scenario: 07 Eine stornierter Rückbau kann nicht noch einmal storniert werden
# Fertigungsvorschlag anlegen und freigeben
    Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
    And I append rows
      | artikel   | netmge | mfreig | bisuch      |
      | BAUGRUPPE | 10     | ja     | STORNOZWEI_ |
    And I press button "freig" to open a subeditor for "BA_freigeben"
    And I close the current editor
    And I switch the current editor to editor "fvor"
    And I save the current editor

# Rückmeldung und Rückbau auf ersten Arbeitsgang
    Given I open an editor "Rückmeldung1" from table "(Workorder):(WorkOrders)" with command "DONE" for record "STORNOZWEI_001"
    And I set field "sofort" to "1"
    And I set field "gutmge" to "5" in row 1
    And I save the current editor

    Given I open an editor "Rückbau1" from table "(Workorder):(WorkOrders)" with command "RETURN" for record "STORNOZWEI_001"
    And I set field "sofort" to "1"
    And I set field "gutmge" to "-2" in row 1
    And I save the current editor

    Given I open an editor "Storno1_Rückbau" via ID from editor "Rückbau1" from field "id" in row 0 for table "(Workorder):(CompletionConfirmations)" with command "REVERSAL"
    And I save the current editor

# Stornierter Rückbau kann nicht noch einmal storniert werden
    Then opening an editor from table "(Workorder):(CompletionConfirmations)" with command "REVERSAL" for record from editor "Rückbau1" throws the exception "149"
    And I close the current editor

# Betriebsauftrag abschließen
    Given I open an editor "Rückmeldung2" from table "(Workorder):(WorkOrders)" with command "DONE" for record "STORNOZWEI_001"
    And I set field "sofort" to "ja"
    And I set field "gut" to "ja"
    And I save the current editor


  Scenario: 08 Ein Stornobeleg zu einem Rückbau kann nicht storniert werden
# Fertigungsvorschlag anlegen und freigeben
    Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
    And I append rows
      | artikel   | netmge | mfreig | bisuch       |
      | BAUGRUPPE | 10     | ja     | STORNOZWEI2_ |
    And I press button "freig" to open a subeditor for "BA_freigeben"
    And I close the current editor
    And I switch the current editor to editor "fvor"
    And I save the current editor

# Rückmeldung, Rückbau und Stonro Rückbau auf ersten Arbeitsgang
    Given I open an editor "Rückmeldung1" from table "(Workorder):(WorkOrders)" with command "DONE" for record "STORNOZWEI2_001"
    And I set field "sofort" to "1"
    And I set field "gutmge" to "5" in row 1
    And I save the current editor

    Given I open an editor "Rückbau1" from table "(Workorder):(WorkOrders)" with command "RETURN" for record "STORNOZWEI2_001"
    And I set field "sofort" to "1"
    And I set field "gutmge" to "-3" in row 1
    And I save the current editor

    Given I open an editor "Storno1_Rückbau" via ID from editor "Rückbau1" from field "id" in row 0 for table "(Workorder):(CompletionConfirmations)" with command "REVERSAL"
    And I save the current editor

# Storno stornieren bringt Fehler
    Then opening an editor from table "(Workorder):(CompletionConfirmations)" with command "REVERSAL" for record from editor "Storno1_Rückbau" throws the exception "149"
    And I close the current editor


  Scenario: 09 Storno eines Rückbaus nicht möglich, wenn Gutmenge in Behälter auf einem anderen Lagerplatz liegt
# Behälter anlegen, Fertigungsvorschlag anlegen und freigeben
    Given I create a Container "BEHAELTER_1" for packaging material "BEHAELTER" and search word "BEHAELTER_1"
    Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
    And I append rows
      | artikel        | netmge | bisuch | mfreig |
      | M_BG-BEHAELTER | 10     | ALLES_ | ja     |
    And I press button "freig" to open a subeditor for "BA_freigeben"
    And I close the current editor
    And I switch the current editor to editor "fvor"
    And I save the current editor

# Materialentnahme Behälter
    Given I open an editor "Materialentnahme1" for tip command "Fbuchung" and arguments ""
    And I set field "auftrag" to "$,,such=ALLES_001;@richtung=rückwärts;@maxtreffer=1"
    And I press button "stllad"
    And I save the current editor

# Rückmeldung und Rückbau auf ersten Arbeitsgang
    Given I open an editor "Rückmeldung1" from table "(Workorder):(WorkOrders)" with command "DONE" for record "ALLES_001"
    And I set field "sofort" to "1"
    And I set field "behaelter" to id from editor "BEHAELTER_1"
    And I set field "gutmge" to "5" in row 1
    And I save the current editor

    Given I open an editor "Rückbau1" from table "(Workorder):(WorkOrders)" with command "RETURN" for record "ALLES_001"
    And I set fields
      | sofort    | ja              |
      | behaelter | !BEHAELTER_1^id |
    And I set field "sofort" to "ja"
    And I modify table
      | gutmge | !row |
      | -3     | 1    |
    And I save the current editor

# Behälter auf anderen Lagerplatz umbuchen
    Given I open an editor "Lagerbuchung" for tip command "(Stockadjustment)" and arguments ""
    And I set fields
      | artikel | M_BG-BEHAELTER |
      | beldat  | .              |
      | beleg   | 4711           |
      | buart   | Umbuchung      |
    And I modify table
      | mge | platz | platz2 | !row |
      | 2   | F1    | F2     | 1    |
    And I set field "behaelter" to id from editor "BEHAELTER_1" in row !lastRow
    And I set field "behaelterzu" to id from editor "BEHAELTER_1" in row !lastRow
    And I save the current editor

# Storno des Rückbaus nicht möglich: Behälter liegt nicht auf dem abgangslagerplatz (8334)
    Given I open an editor "Storno1_Rückbau" via ID from editor "Rückbau1" from field "id" in row 0 for table "(Workorder):(CompletionConfirmations)" with command "REVERSAL"
    Then field "behaelter^id" has value "!BEHAELTER_1^id"
    Then field "buplatz" has value "F1" in row 1
    Then saving the current editor throws the exception "8334"
    And I close the current editor

# Betriebsauftrag abschließen
    Given I open an editor "Rückmeldung2" from table "(Workorder):(WorkOrders)" with command "DONE" for record "ALLES_001"
    And I set fields
      | sofort | ja |
      | gut    | ja |
    And I set field "behaelter" to id from editor "BEHAELTER_1"
    Then field "buplatz" has value "F2" in row 1
    And I save the current editor


  Scenario: 10 Fehlermeldung, wenn Gutmenge bei Storno eines Rückbaus wieder zurück in einen gesperrten Behälter gebucht werden soll
# Behälter anlegen und Material
    Given I create a Container "GESPERRT" for packaging material "BEHAELTER"

# Fertigungsvorschlag anlegen und freigeben
    Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
    And I append rows
      | artikel   | mge | mfreig | bisuch     |
      | BAUGRUPPE | 10  | ja     | BEHSPERRE_ |
    And I press button "freig" to open a subeditor for "BA"
    And I close the current editor
    And I switch the current editor to editor "fvor"
    And I close the current editor

# Rückmeldung und Rückbau auf ersten Arbeitsgang
    Given I open an editor "Rückmeldung1" from table "(Workorder):(WorkOrders)" with command "DONE" for record "BEHSPERRE_001"
    And I set fields
      | sofort    | 1            |
      | behaelter | !GESPERRT^id |
    And I set field "gutmge" to "5" in row 1
    And I save the current editor

    Given I open an editor "Rückbau1" from table "(Workorder):(WorkOrders)" with command "RETURN" for record "BEHSPERRE_001"
    And I set fields
      | sofort    | 1            |
      | behaelter | !GESPERRT^id |
    And I set field "gutmge" to "-5" in row 1
    And I save the current editor

# Behaälter sperren
    And I switch the current editor to editor "GESPERRT" with command "UPDATE"
    And I set field "behstatusaz" to "Gesperrt"
    And I save the current editor

# Rückmeldung stornieren
    Then opening an editor from table "(Workorder):(CompletionConfirmations)" with command "REVERSAL" for record from editor "Rückbau1" throws the exception "11072"
    And I close the current editor

# Behälter entsperren und Betriebsauftrag abschließen
    And I switch the current editor to editor "GESPERRT" with command "UPDATE"
    And I set field "behstatusaz" to ""
    And I save the current editor

    Given I open an editor "Rückmeldung2" from table "(Workorder):(WorkOrders)" with command "DONE" for record "BEHSPERRE_001"
    And I set fields
      | sofort    | 1            |
      | gut       | 1            |
      | behaelter | !GESPERRT^id |
    And I save the current editor


  Scenario: A01 Im Stornobeleg sind alle Felder zu Mengen-, Zeit-, Artikel- und Buchungsangaben schreibgeschützt
# Auftrag und Fertigungsvorschlag anlegen und freigeben
    Given I create a SalesOrder "auftrag" for Customer "RADSHOP" with Product "BAUGRUPPE" and quantity "10"
    Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
    And I append rows
      | artikel   | netmge | bisuch   | mfreig |
      | BAUGRUPPE | 10     | SCHUTZA_ | ja     |
    And I press button "freig" to open a subeditor for "BA_freigeben"
    And I close the current editor
    And I switch the current editor to editor "fvor"
    And I save the current editor

# Rückmeldung und Rückbau auf ersten Arbeitsgang
    Given I open an editor "Rückmeldung1" from table "(Workorder):(WorkOrders)" with command "DONE" for record "SCHUTZA_001"
    And I set field "sofort" to "1"
    And I set field "gut" to "1"
    And I save the current editor

    Given I open an editor "Rückbau1" via ID from editor "Rückmeldung1" from field "id" in row 0 for table "(Workorder):(CompletionConfirmations)" with command "COPY"
    And I set field "gutmge" to "-3" in row 1
    And I save the current editor

# Rückbau stornieren, Schreibschutz auf Feldern prüfen
    Given I open an editor "Storno1_Rückbau" via ID from editor "Rückbau1" from field "id" in row 0 for table "(Workorder):(CompletionConfirmations)" with command "REVERSAL"
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

# Auftrag liefern
    Given I deliver the SalesOrder "auftrag" with PackingSlip "LS-P01"


  Scenario: A02 Bemerkung im Kopf und Erbtext in Zeile sind im Stornobeleg beschreibbar
# Fertigungsvorschlag anlegen und freigeben
    Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
    And I append rows
      | artikel   | netmge | bisuch    | mfreig |
      | BAUGRUPPE | 10     | SCHREIBA_ | ja     |
    And I press button "freig" to open a subeditor for "BA_freigeben"
    And I close the current editor
    And I switch the current editor to editor "fvor"
    And I save the current editor

# Rückmeldung und Rückbau auf ersten Arbeitsgang
    Given I open an editor "Rückmeldung1" from table "(Workorder):(WorkOrders)" with command "DONE" for record "SCHREIBA_001"
    And I set field "gut" to "1"
    And I set field "sofort" to "1"
    And I save the current editor

    Given I open an editor "Rückbau1" via ID from editor "Rückmeldung1" from field "id" in row 0 for table "(Workorder):(CompletionConfirmations)" with command "COPY"
    Then field "bem" is modifiable
    And I modify table
      | erbtext1          | gutmge      | mge         | !row |
      | Erbtext1 Gutmenge | -1          | !dontChange | 1    |
      | Erbtext1 Material | !dontChange | -1          | 2    |
      |                   | !dontChange | -1          | 3    |
    And I save the current editor

# Rückbau stornieren, Erbtexte für Gutmnege und Material hinterlegen
    Given I open an editor "Storno1_Rückbau" via ID from editor "Rückbau1" from field "id" in row 0 for table "(Workorder):(CompletionConfirmations)" with command "REVERSAL"
    Then field "bem" is modifiable
    And I modify table
      | erbtext1    | !row |
      | Gutmenge1   | 1    |
      | !dontChange | 2    |
      | Material1   | 3    |
    And I save the current editor

# Lagerjournaleintrag prüfen
    Given I open the infosystem "LJ"
    And I set field "adatum" to "."
    And I set field "beleg" to "barmex" from editor "Rückmeldung1"
    And I set field "richtung" to "rückwärts"
    And I press start
    Then table has values
      | art       | erbtext1          |
      | BAUGRUPPE | Gutmenge1         |
      | EINKAUF-1 | Erbtext1 Material |
      | EINKAUF-2 | Material1         |
    And I close the current editor


  Scenario: A03 Durch den Storno eines Rückbaus auf einen abgelegten FV werden die Belegtypen korrekt gesetzt
# Fertigungsvorschlag anlegen und freigeben
    Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
    And I append rows
      | artikel    | netmge | bisuch | mfreig |
      | BAUGRUPPE2 | 10     | TYPA_  | ja     |
    And I press button "freig" to open a subeditor for "BA_freigeben"
    And I close the current editor
    And I switch the current editor to editor "fvor"
    And I save the current editor

# Rückmeldung und Rückbau auf ersten Arbeitsgang
    Given I open an editor "Rückmeldung1" from table "(Workorder):(WorkOrders)" with command "DONE" for record "TYPA_002"
    And I set field "gut" to "1"
    And I set field "sofort" to "1"
    And I save the current editor

    Given I open an editor "Rückbau1" via ID from editor "Rückmeldung1" from field "id" in row 0 for table "(Workorder):(CompletionConfirmations)" with command "COPY"
    And I set field "gutmge" to "-3" in row 1
    And I save the current editor

# Rückbau stornieren, Typen prüfen in Storno-Rückbau auf Betriebsauftrag und stornierter Rückbau auf Betriebsauftrag
    Given I open an editor "Storno1_Rückbau" via ID from editor "Rückbau1" from field "id" in row 0 for table "(Workorder):(CompletionConfirmations)" with command "REVERSAL"
    Then field "typa279" has value "Storno-Rückbau auf abgelegten Fertigungsvorschlag"
    Then field "stornopartnervorg^id" has value equal to field "id" from editor "Rückbau1"
    And I save the current editor

    Then field "typa279" from editor "Rückbau1" in row 0 has value "Stornierter Rückbau auf abgelegten Fertigungsvorschlag"


  Scenario: A04 Im Stornobeleg haben die Mengen das gegenteilige Vorzeichen zum Originalbeleg
# Fertigungsvorschlag anlegen und freigeben
    Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
    And I append rows
      | artikel  | netmge | mfreig | bisuch      |
      | BG-UMBAU | 10     | ja     | GEGENTEILA_ |
    And I press button "freig" to open a subeditor for "BA_freigeben"
    And I close the current editor
    And I switch the current editor to editor "fvor"
    And I save the current editor

# Rückmeldung und Rückbau auf ersten Arbeitsgang
    Given I open an editor "Rückmeldung1" from table "(Workorder):(WorkOrders)" with command "DONE" for record "GEGENTEILA_001"
    And I set field "gut" to "1"
    And I set field "sofort" to "1"
    And I save the current editor

    Given I open an editor "Rückbau1" via ID from editor "Rückmeldung1" from field "id" in row 0 for table "(Workorder):(CompletionConfirmations)" with command "COPY"
    And I modify table
      | !row | mge         | gutmge      |
      | 1    | !dontChange | -1          |
      | 2    | -1          | !dontChange |
      | 3    | -1          | !dontChange |
    And I save the current editor

# Rückbau stornieren, gegenteilige Vorzeichen prüfen
    Given I open an editor "Storno1_Rückbau" via ID from editor "Rückbau1" from field "id" in row 0 for table "(Workorder):(CompletionConfirmations)" with command "REVERSAL"
    Then the table has 3 rows
    Then table has values
      | !row | mge | gutmge |
      | 1    | 0   | 1      |
      | 2    | 1   | 0      |
      | 3    | 1   | 0      |
    And I save the current editor


  Scenario: A05 Eine stornierter Rückbau kann nicht noch einmal storniert werden
# Fertigungsvorschlag anlegen und freigeben
    Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
    And I append rows
      | artikel   | netmge | mfreig | bisuch       |
      | BAUGRUPPE | 10     | ja     | STORNOZWEIA_ |
    And I press button "freig" to open a subeditor for "BA_freigeben"
    And I close the current editor
    And I switch the current editor to editor "fvor"
    And I save the current editor

# Rückmeldung und Rückbau auf ersten Arbeitsgang
    Given I open an editor "Rückmeldung1" from table "(Workorder):(WorkOrders)" with command "DONE" for record "STORNOZWEIA_001"
    And I set field "sofort" to "1"
    And I set field "gut" to "1"
    And I save the current editor

    Given I open an editor "Rückbau1" via ID from editor "Rückmeldung1" from field "id" in row 0 for table "(Workorder):(CompletionConfirmations)" with command "COPY"
    And I set field "gutmge" to "-2" in row 1
    And I save the current editor

    Given I open an editor "Storno1_Rückbau" via ID from editor "Rückbau1" from field "id" in row 0 for table "(Workorder):(CompletionConfirmations)" with command "REVERSAL"
    And I save the current editor

# Stornierter Rückbau kann nicht noch einmal storniert werden
    Then opening an editor from table "(Workorder):(CompletionConfirmations)" with command "REVERSAL" for record from editor "Rückbau1" throws the exception "149"
    And I close the current editor


  Scenario: A06 Der Storno eines Rückbaus kann nicht storniert werden
# Fertigungsvorschlag anlegen und freigeben
    Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
    And I append rows
      | artikel   | netmge | mfreig | bisuch        |
      | BAUGRUPPE | 10     | ja     | STORNOZWEI2A_ |
    And I press button "freig" to open a subeditor for "BA_freigeben"
    And I close the current editor
    And I switch the current editor to editor "fvor"
    And I save the current editor

# Rückmeldung, Rückbau und Stonro Rückbau auf ersten Arbeitsgang
    Given I open an editor "Rückmeldung1" from table "(Workorder):(WorkOrders)" with command "DONE" for record "STORNOZWEI2A_001"
    And I set field "sofort" to "1"
    And I set field "gut" to "1"
    And I save the current editor

    Given I open an editor "Rückbau1" via ID from editor "Rückmeldung1" from field "id" in row 0 for table "(Workorder):(CompletionConfirmations)" with command "COPY"
    And I set field "gutmge" to "-3" in row 1
    And I save the current editor

    Given I open an editor "Storno1_Rückbau" via ID from editor "Rückbau1" from field "id" in row 0 for table "(Workorder):(CompletionConfirmations)" with command "REVERSAL"
    And I save the current editor

# Storno stornieren bringt Fehler
    Then opening an editor from table "(Workorder):(CompletionConfirmations)" with command "REVERSAL" for record from editor "Storno1_Rückbau" throws the exception "149"
    And I close the current editor


  Scenario: A07 Storno eines Rückbaus auf abgelegte FV nicht möglich, wenn Gutmenge in Behälter auf einem anderen Lagerplatz liegt, Prüfung auf Lagerplatz
# Auftrag und Behälter anlegen
    Given I create a SalesOrder "auftrag" for Customer "RADSHOP" with Product "BG-BEHAELTER" and quantity "10"
    Given I create a Container "LAGERPLATZ" for packaging material "BEHAELTER"

# Fertigungsvorschlag anlegen und freigeben
    Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
    And I append rows
      | artikel      | netmge | mfreig | bisuch   |
      | BG-BEHAELTER | 10     | ja     | LPLATZA_ |
    And I set field "verw" in row !lastRow to "verw" from editor "auftrag" in row 1
    And I press button "freig" to open a subeditor for "BA_freigeben"
    And I close the current editor
    And I switch the current editor to editor "fvor"
    And I save the current editor

# Bedarfe einkaufen
    Given I open an editor "RechnungLager" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
    And I set fields
      | lief   | KETTLER   |
      | vom    | .         |
      | ebeleg | Rückbau24 |
      | ueb    | ja        |
      | fakt   | ja        |
    And I append rows
      | artikel    | mge |
      | EINKAUF-1  | 20  |
      | EINKAUF-2  | 10  |
      | BEHAELTER  | 4   |
      | EU-PALETTE | 1   |
    And I set field "verw" in row 1 to "verw" from editor "auftrag" in row 1
    And I set field "verw" in row 2 to "verw" from editor "auftrag" in row 1
    And I respond with answer "ja" to the dialog with id "4841"
    And I save the current editor

# Rückmeldung1 auf ersten Arbeitsgang und Rückbau
    Given I open an editor "Rückmeldung1" from table "(Workorder):(WorkOrders)" with command "DONE" for record "LPLATZA_001"
    And I set fields
      | sofort    | ja             |
      | gut       | ja             |
      | manrest   | ja             |
      | behaelter | !LAGERPLATZ^id |
    And I save the current editor

    Given I open an editor "Rückbau1" via ID from editor "Rückmeldung1" from field "id" in row 0 for table "(Workorder):(CompletionConfirmations)" with command "COPY"
    And I set field "behaelter" to id from editor "LAGERPLATZ"
    And I set field "gutmge" to "-3" in row 1
    Then field "buplatz" has value "F1" in row 1
    And I save the current editor

# Behälter umlagern
    Given I open an editor "LBuchung" for tip command "LBuchung" and arguments ""
    And I set fields
      | artikel | BG-BEHAELTER |
      | buart   | Umbuchung    |
      | beleg   | 24           |
      | beldat  | .            |
    And I append rows
      | platz2 | platz | mge | behaelter      | behaelterzu    |
      | F2     | F1    | 7   | !LAGERPLATZ^id | !LAGERPLATZ^id |
    And I set field "verw" in row !lastRow to "verw" from editor "auftrag" in row 1
    And I set field "verw2" in row !lastRow to "verw" from editor "auftrag" in row 1
    And I save the current editor

# Storno des Rückbaus: Behälter liegt nicht auf dem abgangslagerplatz (8334)
    Given I open an editor "Storno1_Rückbau" via ID from editor "Rückbau1" from field "id" in row 0 for table "(Workorder):(CompletionConfirmations)" with command "REVERSAL"
    Then fields have values
      | behaelter^id | !LAGERPLATZ^id |
    Then field "buplatz" has value "F1" in row 1
    Then saving the current editor throws the exception "8334"
    And I close the current editor

# Menge nachbuchen und Auftrag liefern
    Given I open an editor "Rückmeldung2" via ID from editor "Rückmeldung1" from field "id" in row 0 for table "(Workorder):(CompletionConfirmations)" with command "COPY"
    And I set field "behaelter" to id from editor "LAGERPLATZ"
    And I set field "gutmge" to "3" in row 1
    Then field "buplatz" has value "F2" in row 1
    And I save the current editor

    And I switch the current editor to editor "auftrag" with command "DELIVERY"
    And I set fields
      | vom | .  |
      | ueb | ja |
    And I modify table
      | !row | mge | platz |
      | 1    | 10  | F2    |
    And I set field "behaelter" to id from editor "LAGERPLATZ" in row 1
    And I press button "packvor"
    And I save the current editor


  Scenario: A08 Beim stornieren des Rueckbaus auf einen letzten Arbeitsschein pruefen, ob auf den BA schon mehr rueckgemeldet wurde
# Fertigungsvorschlag anlegen und freigeben
    Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
    And I append rows
      | artikel   | netmge | bisuch      | mfreig |
      | BAUGRUPPE | 10     | STORNORBR1_ | ja     |
    And I press button "freig" to open a subeditor for "BA_freigeben"
    And I close the current editor
    And I switch the current editor to editor "fvor"
    And I save the current editor

# Rückmeldung auf letzten Arbeitsgang mit Gutmenge 5
    Given I open an editor "Rückmeldung1" from table "(Workorder):(WorkOrders)" with command "DONE" for record "STORNORBR1_001"
    And I set field "sofort" to "1"
    And I modify table
      | gutmge | !row |
      | 5      | 1    |
    And I save the current editor

# Rückmeldung auf Betriebsauftrag mit Gutmenge 8
    Given I open an editor "Rückmeldung2" from table "(Workorder):(WorkOrders)" with command "DONE" for record "STORNORBR1_000"
    And I set field "mgr" to "112"
    And I set field "sofort" to "1"
    And I modify table
      | gutmge | !row |
      | 8      | 1    |
    And I save the current editor

# Rückbau auf letzten Arbeitsgang mit Gutmenge -2
    Given I open an editor "Rückbau1" from table "(Workorder):(WorkOrders)" with command "RETURN" for record "STORNORBR1_001"
    And I set field "sofort" to "1"
    And I modify table
      | gutmge | !row |
      | -2     | 1    |
    And I save the current editor

# Rückbau auf Betriebsauftrag mit Gutmenge -4
    Given I open an editor "Rückbau2" from table "(Workorder):(WorkOrders)" with command "RETURN" for record "STORNORBR1_000"
    And I set field "mgr" to "112"
    And I set field "sofort" to "1"
    And I modify table
      | gutmge | !row |
      | -4     | 1    |
    And I save the current editor

# Rückbau auf letzten Arbeitsschein stornieren bringt Fehler
# Rückmeldung kann nicht storniert werden da bereits eine weitere Buchung auf den letzten Arbeitsschein/Betriebsauftrag erfolgt ist.
    Then opening an editor from table "(Workorder):(CompletionConfirmations)" with command "REVERSAL" for record from editor "Rückbau1" throws the exception "9503"
    And I close the current editor


  Scenario: A09 Beim stornieren des Rueckbaus auf einen letzten Arbeitsschein pruefen, ob der Storno moeglich ist
# Fertigungsvorschlag anlegen und freigeben
    Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
    And I append rows
      | artikel   | netmge | bisuch       | mfreig |
      | BAUGRUPPE | 10     | STORNORBRF2_ | ja     |
    And I press button "freig" to open a subeditor for "BA_freigeben"
    And I close the current editor
    And I switch the current editor to editor "fvor"
    And I save the current editor

# Rückmeldung auf letzten Arbeitsgang mit Gutmenge 2
    Given I open an editor "Rückmeldung1" from table "(Workorder):(WorkOrders)" with command "DONE" for record "STORNORBRF2_001"
    And I set field "sofort" to "1"
    And I modify table
      | gutmge | !row |
      | 2      | 1    |
    And I save the current editor

# Rückmeldung auf Betriebsauftrag mit Gutmenge 3
    Given I open an editor "Rückmeldung2" from table "(Workorder):(WorkOrders)" with command "DONE" for record "STORNORBRF2_000"
    And I set field "mgr" to "112"
    And I set field "sofort" to "1"
    And I modify table
      | gutmge | !row |
      | 3      | 1    |
    And I save the current editor

# Rückmeldung auf letzten Arbeitsgang mit Gutmenge 2
    Given I open an editor "Rückmeldung3" from table "(Workorder):(WorkOrders)" with command "DONE" for record "STORNORBRF2_001"
    And I set field "sofort" to "1"
    And I modify table
      | gutmge | !row |
      | 2      | 1    |
    And I save the current editor

# Rückbau auf letzten Arbeitsgang mit Gutmenge -2
    Given I open an editor "Rückmeldung4" from table "(Workorder):(WorkOrders)" with command "RETURN" for record "STORNORBRF2_001"
    And I set field "sofort" to "1"
    And I modify table
      | gutmge | !row |
      | -2     | 1    |
    And I save the current editor

# Rückbau auf Betriebsauftrag mit Gutmenge -3
    Given I open an editor "Rückmeldung5" from table "(Workorder):(WorkOrders)" with command "RETURN" for record "STORNORBRF2_000"
    And I set field "mgr" to "112"
    And I set field "sofort" to "1"
    And I modify table
      | gutmge | !row |
      | -3     | 1    |
    And I save the current editor

# Rückbau auf letzten Arbeitsschein stornieren
    Given opening an editor from table "(Workorder):(CompletionConfirmations)" with command "REVERSAL" for record from editor "Rückmeldung4" throws the exception "9503"
    And I close the current editor
