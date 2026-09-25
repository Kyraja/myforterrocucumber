@persistent
Feature: rueckbau_rueckmeldungen_plausichecks.feature

  Background:
    And I set the fake date to "03.02.1995"

# *****************************************************************************
#  Name             : rueckbau_rueckmeldungen_plausichecks
#  Autor            : lschneider
#  Verantwortlich   : drpf
#  Kontrolle        : amk
#  Funktion         : Testet Plausis beim Rückbau
#  Jira-Issue       : FDA-536
# *****************************************************************************

## Rückgaben auf einen lebendigen Betriebsauftrag


  Scenario: 01 Vorbelegung und Schreibschutz in Rückbaubeleg
# Fertigungsvorschlag anlegen und freigeben
    Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
    And I append rows
      | artikel   | netmge | bisuch    | mfreig |
      | BAUGRUPPE | 10     | RUECKBAU_ | ja     |
    And I press button "freig" to open a subeditor for "BA_freigeben"
    And I close the current editor
    And I switch the current editor to editor "fvor"
    And I save the current editor

# Rückmeldung auf ersten Arbeitsgang
    Given I open an editor "Rückmeldung1" from table "(Workorder):(WorkOrders)" with command "DONE" for record "RUECKBAU_001"
    And I set field "sofort" to "1"
    And I set field "gutmge" to "5" in row 1
    And I save the current editor

# Rückbau auf ersten Arbeitsschein, Vorbelegung und Scheibschutz prüfen
    Given I open an editor "Rückbau1" from table "(Workorder):(WorkOrders)" with command "RETURN" for record "RUECKBAU_001"
    Then field "vzeit" has value "0"
    Then field "sofort" is modifiable
    Then field "gut" is not modifiable
    Then field "manrest" is not modifiable
    Then field "stornorest" is not modifiable
    Then field "mgereduzieren" is modifiable
    Then field "status" is modifiable in row 1
    Then field "gutmge" has value "0" in row 1
    And I close the current editor

# Betriebsauftrag abschließen
    Given I open an editor "Betriebsauftrag" from table "(Workorder):(WorkOrders)" with command "UPDATE" for record "RUECKBAU_000"
    And I respond with answer "ja" to the dialog with id "345"
    And I set field "status" to "s"
    And I save the current editor


  Scenario: 02 Rückbaubeleg hat Typ Rückbau auf Betriebsauftrag, es können nur negative Mengen als Mengen eingetragen werden
# Fertigungsvorschlag anlegen und freigeben
    Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
    And I append rows
      | artikel   | netmge | bisuch    | mfreig |
      | BAUGRUPPE | 10     | TYPRUECK_ | ja     |
    And I press button "freig" to open a subeditor for "BA_freigeben"
    And I close the current editor
    And I switch the current editor to editor "fvor"
    And I save the current editor

# Rückmeldung auf ersten Arbeitsgang
    Given I open an editor "Rückmeldung1" from table "(Workorder):(WorkOrders)" with command "DONE" for record "TYPRUECK_001"
    And I set field "sofort" to "1"
    And I set field "gutmge" to "5" in row 1
    And I save the current editor

# Rückbau auf ersten Arbeitsschein, Vorbelegung und Scheibschutz prüfen
    Given I open an editor "Rückbau1" from table "(Workorder):(WorkOrders)" with command "RETURN" for record "TYPRUECK_001"
    Then field "typa279" has value "Rückbau auf Betriebsauftrag"
    And setting field "gutmge" to "2" in row 1 throws the exception "11121"
    And I close the current editor

# Betriebsauftrag abschließen
    Given I open an editor "Betriebsauftrag" from table "(Workorder):(WorkOrders)" with command "UPDATE" for record "TYPRUECK_000"
    And I respond with answer "ja" to the dialog with id "345"
    And I set field "status" to "s"
    And I save the current editor


  Scenario: 03 In Rückmeldebeleg können in neue Zeilen für Komponenten keine negativen Mengen eingetragen werden
# Fertigungsvorschlag anlegen und freigeben
    Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
    And I append rows
      | artikel   | netmge | bisuch   | mfreig |
      | BAUGRUPPE | 10     | NEGATIV_ | ja     |
    And I press button "freig" to open a subeditor for "BA_freigeben"
    And I close the current editor
    And I switch the current editor to editor "fvor"
    And I save the current editor

# Rückmeldung auf ersten Arbeitsgang
    Given I open an editor "Rückmeldung1" from table "(Workorder):(WorkOrders)" with command "DONE" for record "NEGATIV_001"
    And I set field "sofort" to "1"
    And I set field "gutmge" to "5" in row 1
    And I create a new row at the end of the table
    And I set field "artikel" to "EINKAUF-3" in row !lastRow
    And setting field "mge" to "-1" in row !lastRow throws the exception "11120"
    And I close the current editor

# Betriebsauftrag abschließen
    Given I open an editor "Betriebsauftrag" from table "(Workorder):(WorkOrders)" with command "UPDATE" for record "NEGATIV_000"
    And I respond with answer "JA" to the dialog with id "345"
    And I set field "status" to "s"
    And I save the current editor


  Scenario: 04 In Rückbauebeleg können in neue Zeilen für Komponenten keine positiven Mengen eingetragen werden
# Fertigungsvorschlag anlegen und freigeben
    Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
    And I append rows
      | artikel   | netmge | bisuch   | mfreig |
      | BAUGRUPPE | 10     | POSITIV_ | ja     |
    And I press button "freig" to open a subeditor for "BA_freigeben"
    And I close the current editor
    And I switch the current editor to editor "fvor"
    And I save the current editor

# Rückmeldung auf ersten Arbeitsgang
    Given I open an editor "Rückmeldung1" from table "(Workorder):(WorkOrders)" with command "DONE" for record "POSITIV_001"
    And I set field "sofort" to "1"
    And I set field "gutmge" to "5" in row 1
    And I save the current editor

# Rückbau auf ersten Arbeitsschein, es können nur positive Mengen in neuen Zeilen angegeben werden
    Given I open an editor "Rückmeldung1" from table "(Workorder):(WorkOrders)" with command "RETURN" for record "POSITIV_001"
    And I create a new row at the end of the table
    And I set field "artikel" to "EINKAUF-3" in row !lastRow
    And setting field "mge" to "1" in row !lastRow throws the exception "11121"
    And I close the current editor

# Betriebsauftrag abschließen
    Given I open an editor "Betriebsauftrag" from table "(Workorder):(WorkOrders)" with command "UPDATE" for record "POSITIV_000"
    And I respond with answer "JA" to the dialog with id "345"
    And I set field "status" to "s"
    And I save the current editor


  Scenario: 05 In Rückmeldung können keine negativen Arbeits- und Maschinenzeiten eingetragen werden
# Fertigungsvorschlag anlegen und freigeben
    Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
    And I append rows
      | artikel   | netmge | bisuch  | mfreig |
      | BAUGRUPPE | 10     | ZEITEN_ | ja     |
    And I press button "freig" to open a subeditor for "BA_freigeben"
    And I close the current editor
    And I switch the current editor to editor "fvor"
    And I save the current editor

# Rückmeldung auf ersten Arbeitsgang
    Given I open an editor "Rückmeldung1" from table "(Workorder):(WorkOrders)" with command "DONE" for record "ZEITEN_001"
    Then setting field "bzeit" to "-1" throws the exception "11034"
    Then setting field "mzeit" to "-1" throws the exception "11034"
    And I close the current editor

# Betriebsauftrag abschließen
    Given I open an editor "Betriebsauftrag" from table "(Workorder):(WorkOrders)" with command "UPDATE" for record "ZEITEN_000"
    And I respond with answer "JA" to the dialog with id "345"
    And I set field "status" to "s"
    And I save the current editor


  Scenario: 06 Teil-Rückbau auf Betriebsauftrag nach retrograder Buchung über Rückmeldung nicht möglich
# Fertigungsvorschlag anlegen und freigeben
    Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
    And I append rows
      | artikel   | netmge | bisuch    | mfreig |
      | BAUGRUPPE | 10     | BETRIEBS_ | ja     |
    And I press button "freig" to open a subeditor for "BA_freigeben"
    And I close the current editor
    And I switch the current editor to editor "fvor"
    And I save the current editor

# Rückmeldung auf ersten Arbeitsgang
    Given I open an editor "Rückmeldung1" from table "(Workorder):(WorkOrders)" with command "DONE" for record "BETRIEBS_001"
    And I set field "sofort" to "1"
    And I set field "gutmge" to "5" in row 1
    And I save the current editor

# Rückbau auf Betriebsauftrag
    Given I open an editor "Betriebsauftrag" from table "(Workorder):(WorkOrders)" with command "RETURN" for record "BETRIEBS_000"
    Then setting field "gutmge" to "-2" in row 1 throws the exception "1395"
    And I close the current editor

# Betriebsauftrag abschließen
    Given I open an editor "Betriebsauftrag" from table "(Workorder):(WorkOrders)" with command "UPDATE" for record "BETRIEBS_000"
    And I respond with answer "JA" to the dialog with id "345"
    And I set field "status" to "s"
    And I save the current editor


  Scenario: 07 Positive und negative Mengen können nicht im selben Rückmeldebeleg gemischt werden
# Fertigungsvorschlag anlegen und freigeben
    Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
    And I append rows
      | artikel   | netmge | bisuch   | mfreig |
      | BAUGRUPPE | 10     | NEGPOSZ_ | ja     |
    And I press button "freig" to open a subeditor for "BA_freigeben"
    And I close the current editor
    And I switch the current editor to editor "fvor"
    And I save the current editor

# Rückmeldung auf ersten Arbeitsgang
    Given I open an editor "Rückmeldung1" from table "(Workorder):(WorkOrders)" with command "DONE" for record "NEGPOSZ_001"
    And I set fields
      | mzeit  | 5  |
      | bzeit  | 5  |
      | sofort | ja |
    And I set field "gutmge" to "5" in row 1
    And I save the current editor

# Rückbau auf Betriebsauftrag
    Given I open an editor "Betriebsauftrag" from table "(Workorder):(WorkOrders)" with command "RETURN" for record "NEGPOSZ_001"
    And I set field "mzeit" to "3"
    Then setting field "bzeit" to "-1" throws the exception "11034"
    Then setting field "mzeit" to "-1" throws the exception "11034"
    And I set field "bzeit" to "3"
    And I close the current editor

# Betriebsauftrag abschließen
    Given I open an editor "Betriebsauftrag" from table "(Workorder):(WorkOrders)" with command "UPDATE" for record "NEGPOSZ_000"
    And I respond with answer "JA" to the dialog with id "345"
    And I set field "status" to "s"
    And I save the current editor

#Scenario: 08 Negative Zeiten auf eine noch nicht zuvor gebuchte Lohngruppe ist nicht möglich.
# entfällt, da negative Zeiten im Rückbau nicht erlaubt


  Scenario: 09 Es können keine negative Zeiten im Rückbaubeleg gebucht werden
# Fertigungsvorschlag anlegen und freigeben
    Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
    And I append rows
      | artikel   | netmge | bisuch     | mfreig |
      | BAUGRUPPE | 10     | NEGATIVEZ_ | ja     |
    And I press button "freig" to open a subeditor for "BA_freigeben"
    And I close the current editor
    And I switch the current editor to editor "fvor"
    And I save the current editor

# Rückmeldung auf ersten Arbeitsgang
    Given I open an editor "Rückmeldung1" from table "(Workorder):(WorkOrders)" with command "DONE" for record "NEGATIVEZ_001"
    And I set fields
      | mzeit  | 5  |
      | bzeit  | 5  |
      | sofort | ja |
    And I set field "gutmge" to "5" in row 1
    And I save the current editor

# Rückbau auf Betriebsauftrag
    Given I open an editor "Betriebsauftrag" from table "(Workorder):(WorkOrders)" with command "RETURN" for record "NEGATIVEZ_001"
    Then setting field "mzeit" to "-1" throws the exception "11034"
    And I set field "mzeit" to "0"
    Then setting field "bzeit" to "-1" throws the exception "11034"
    And I close the current editor

# Betriebsauftrag abschließen
    Given I open an editor "Betriebsauftrag" from table "(Workorder):(WorkOrders)" with command "UPDATE" for record "NEGATIVEZ_000"
    And I respond with answer "JA" to the dialog with id "345"
    And I set field "status" to "s"
    And I save the current editor


#Scenario: 10 Es kann nicht mehr Arbeitszeit zurückgebucht werden als bisher zu einer Lohngruppe gebucht
# entfällt, da negative Zeiten im Rückbau nicht erlaubt
#Scenario: 11 Es kann nicht mehr Maschinenzeit zurückgebucht werden als bisher zu einer Maschinengruppe gebucht.
# entfällt, da negative Zeiten im Rückbau nicht erlaubt


  Scenario: 12 Es kann in einem zweiten Rückbau nicht mehr rückgebaut werden, als nach dem ersten Rückbau wieder an offener Menge da ist
# Fertigungsvorschlag anlegen und freigeben
    Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
    And I append rows
      | artikel     | netmge | mfreig | bisuch       |
      | B_BAUGRUPPE | 50     | ja     | RUECKFEHLER_ |
    And I press button "freig" to open a subeditor for "BA_freigeben"
    And I close the current editor
    And I switch the current editor to editor "fvor"
    And I save the current editor

# Bedarfe einkaufen
    Given I open an editor "RechnungLager" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
    And I set fields
      | lief   | KETTLER  |
      | vom    | .        |
      | budat  | .        |
      | ebeleg | Rückbau1 |
      | ueb    | ja       |
      | fakt   | ja       |
    And I append rows
      | artikel     | mge |
      | B_EINKAUF-1 | 100 |
      | B_EINKAUF-2 | 50  |
    And I respond with answer "ja" to the dialog with id "4841"
    And I save the current editor

# Rückmeldung1 auf ersten Arbeitsgang
    Given I open an editor "Rückmeldung1" from table "(Workorder):(WorkOrders)" with command "DONE" for record "RUECKFEHLER_001"
    And I set fields
      | sofort | ja |
      | bzeit  | 3  |
      | mzeit  | 3  |
    And I set field "gutmge" to "30" in row 1
    And I save the current editor

# Rückbau1 zu Betriebsauftrag
    Given I open an editor "Rückbau1" from table "(Workorder):(WorkOrders)" with command "RETURN" for record "RUECKFEHLER_001"
    And I set fields
      | sofort | ja |
      | bzeit  | 1  |
      | mzeit  | 1  |
    And I set field "gutmge" to "-20" in row 1
    And I save the current editor

# Rückbau2 zu Betriebsauftrag
    Given I open an editor "Rückbau1" from table "(Workorder):(WorkOrders)" with command "RETURN" for record "RUECKFEHLER_001"
    Then setting field "gutmge" to "-30" in row 1 throws the exception "1395"
    And I close the current editor

# Betriebsauftrag abschließen
    Given I open an editor "Betriebsauftrag" from table "(Workorder):(WorkOrders)" with command "DONE" for record "RUECKFEHLER_000"
    And I set fields
      | gut    | ja  |
      | sofort | ja  |
      | mgr    | 112 |
    And I save the current editor


  Scenario: 13 Im Rückbau auf abgelegten FV können negative und positive Mengenangaben nicht gemischt werden
# Fertigungsvorschlag anlegen und freigeben
    Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
    And I append rows
      | artikel     | netmge | mfreig | bisuch       |
      | B_BAUGRUPPE | 10     | ja     | RUECKABLAGE_ |
    And I press button "freig" to open a subeditor for "BA_freigeben"
    And I close the current editor
    And I switch the current editor to editor "fvor"
    And I save the current editor

# Bedarfe einkaufen
    Given I open an editor "RechnungLager" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
    And I set fields
      | lief   | KETTLER  |
      | vom    | .        |
      | budat  | .        |
      | ebeleg | Rückbau1 |
      | ueb    | ja       |
      | fakt   | ja       |
    And I append rows
      | artikel     | mge |
      | B_EINKAUF-1 | 20  |
      | B_EINKAUF-2 | 10  |
    And I respond with answer "ja" to the dialog with id "4841"
    And I save the current editor

# Rückmeldung1 auf ersten Arbeitsgang
    Given I open an editor "Rückmeldung1" from table "(Workorder):(WorkOrders)" with command "DONE" for record "RUECKABLAGE_001"
    And I set fields
      | sofort | ja |
      | gut    | ja |
    And I save the current editor

# Rückbau1 zu Betriebsauftrag
    And I switch the current editor to editor "Rückmeldung1" with command "COPY"
    And I set field "gutmge" to "-2" in row 1
    And I set field "verlustmge" to "5" in row 1
    Then saving the current editor throws the exception "11121"
    And I close the current editor


  Scenario: 14 Rückbaubeleg zu abgelegtem FV hat Typ Rückbau zu Betriebsauftrag
# Fertigungsvorschlag anlegen und freigeben
    Given I open an editor "fvor" from table "04:11" with command "NEW" for record ""
    And I append rows
      | artikel   | netmge | mfreig | bisuch        |
      | BAUGRUPPE | 10     | ja     | RUECKABLAGE1_ |
    And I press button "freig" to open a subeditor for "BA_freigeben"
    And I close the current editor
    And I switch the current editor to editor "fvor"
    And I save the current editor

# Bedarfe einkaufen
    Given I open an editor "RechnungLager" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
    And I set fields
      | lief   | KETTLER   |
      | vom    | .         |
      | budat  | .         |
      | ebeleg | Rückbau14 |
      | ueb    | ja        |
      | fakt   | ja        |
    And I append rows
      | artikel     | mge |
      | B_EINKAUF-1 | 20  |
      | B_EINKAUF-2 | 10  |
    And I respond with answer "ja" to the dialog with id "4841"
    And I save the current editor

# Rückmeldung1 auf ersten Arbeitsgang
    Given I open an editor "Rückmeldung1" from table "(Workorder):(WorkOrders)" with command "DONE" for record "RUECKABLAGE1_001"
    And I set fields
      | sofort | ja |
      | gut    | ja |
    And I save the current editor

# Rückbau1 zu abgelegten FV
    Given I switch the current editor to editor "Rückmeldung1" with command "COPY"
    And I set field "gutmge" to "-2" in row 1
    Then field "typa279" has value "Rückbau auf abgelegten Fertigungsvorschlag"
    And I save the current editor

# Bestandskorrektur
    Given I open an editor "Bestandskorrektur" for tip command "LBestand" and arguments ""
    And I set fields
      | artikel | BAUGRUPPE |
      | beleg   | 20        |
      | beldat  | .         |
    And I set field "platz" to "F1" in row 1
    And I modify table
      | !row        | mge |
      | platz=="F1" | 0   |
    And I save the current editor


  Scenario: 15 In Rückmeldebeleg auf abgelegten FV können in neue Zeilen für Komponenten keine negativen Mengen eingetragen werden
# Fertigungsvorschlag anlegen und freigeben
    Given I open an editor "fvor" from table "04:11" with command "NEW" for record ""
    And I append rows
      | artikel   | netmge | mfreig | bisuch     |
      | BAUGRUPPE | 10     | ja     | NEUEZEILE_ |
    And I press button "freig" to open a subeditor for "BA_freigeben"
    And I close the current editor
    And I switch the current editor to editor "fvor"
    And I save the current editor

# Bedarfe einkaufen
    Given I open an editor "RechnungLager" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
    And I set fields
      | lief   | KETTLER   |
      | vom    | .         |
      | budat  | .         |
      | ebeleg | Rückbau15 |
      | ueb    | ja        |
      | fakt   | ja        |
    And I append rows
      | artikel     | mge |
      | B_EINKAUF-1 | 20  |
      | B_EINKAUF-2 | 10  |
    And I respond with answer "ja" to the dialog with id "4841"
    And I save the current editor

# Rückmeldung1 auf ersten Arbeitsgang
    Given I open an editor "Rückmeldung1" from table "(Workorder):(WorkOrders)" with command "DONE" for record "NEUEZEILE_001"
    And I set fields
      | sofort | ja |
      | gut    | ja |
    And I save the current editor

# Rückbau1 zu abgelegten FV
# Fehler 11120: Beim Eintragen einer negativen Menge: In einer Rückmeldung sind nur positive Mengen zulässig.
    Given I switch the current editor to editor "Rückmeldung1" with command "COPY"
    And I modify table
      | !row | artikel     | gutmge      | mge         |
      | 1    | !dontChange | 1           | !dontChange |
      | +4   | EINKAUF-3   | !dontChange |             |
    Then setting field "mge" to "-1" in row 4 throws the exception "11120"
    And I close the current editor

# Bestandskorrektur
    Given I open an editor "Bestandskorrektur" for tip command "LBestand" and arguments ""
    And I set fields
      | artikel | BAUGRUPPE |
      | beleg   | 20        |
      | beldat  | .         |
    And I set field "platz" to "F1" in row 1
    And I modify table
      | !row        | mge |
      | platz=="F1" | 0   |
    And I save the current editor


  Scenario: 16 In Rückbauebeleg auf abgelegte FV können in neue Zeilen für Komponenten keine positiven Mengen eingetragen werden
# Fertigungsvorschlag anlegen und freigeben
    Given I open an editor "fvor" from table "04:11" with command "NEW" for record ""
    And I append rows
      | artikel   | netmge | mfreig | bisuch     |
      | BAUGRUPPE | 10     | ja     | NEUEZEILE_ |
    And I press button "freig" to open a subeditor for "BA_freigeben"
    And I close the current editor
    And I switch the current editor to editor "fvor"
    And I save the current editor

# Bedarfe einkaufen
    Given I open an editor "RechnungLager" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
    And I set fields
      | lief   | KETTLER   |
      | vom    | .         |
      | budat  | .         |
      | ebeleg | Rückbau16 |
      | ueb    | ja        |
      | fakt   | ja        |
    And I append rows
      | artikel     | mge |
      | B_EINKAUF-1 | 20  |
      | B_EINKAUF-2 | 10  |
    And I respond with answer "ja" to the dialog with id "4841"
    And I save the current editor

# Rückmeldung1 auf ersten Arbeitsgang
    Given I open an editor "Rückmeldung1" from table "(Workorder):(WorkOrders)" with command "DONE" for record "NEUEZEILE_001"
    And I set fields
      | sofort | ja |
      | gut    | ja |
    And I save the current editor

# Rückbau1 zu abgelegten FV
    Given I switch the current editor to editor "Rückmeldung1" with command "COPY"
    And I modify table
      | !row | artikel     | gutmge      | mge         |
      | 1    | !dontChange | -1          | !dontChange |
      | +4   | EINKAUF-3   | !dontChange | 0           |
    Then setting field "mge" to "1" in row 4 throws the exception "11121"
    And I close the current editor

# Bestandskorrektur
    And I set StorageQuantity to zero for Product "BAUGRUPPE" on StorageLocation "F1"


  Scenario: 17 In Rückbaubeleg auf abgelegten FV können keine negativen Arbeits- und Maschinenzeiten eingetragen werden
# Fertigungsvorschlag anlegen und freigeben
    Given I open an editor "fvor" from table "04:11" with command "NEW" for record ""
    And I append rows
      | artikel   | netmge | mfreig | bisuch  |
      | BAUGRUPPE | 10     | ja     | ZEITEN_ |
    And I press button "freig" to open a subeditor for "BA_freigeben"
    And I close the current editor
    And I switch the current editor to editor "fvor"
    And I save the current editor

# Bedarfe einkaufen
    Given I open an editor "RechnungLager" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
    And I set fields
      | lief   | KETTLER   |
      | vom    | .         |
      | budat  | .         |
      | ebeleg | Rückbau17 |
      | ueb    | ja        |
      | fakt   | ja        |
    And I append rows
      | artikel     | mge |
      | B_EINKAUF-1 | 20  |
      | B_EINKAUF-2 | 10  |
    And I respond with answer "ja" to the dialog with id "4841"
    And I save the current editor

# Rückmeldung1 auf ersten Arbeitsgang
    Given I open an editor "Rückmeldung1" from table "(Workorder):(WorkOrders)" with command "DONE" for record "ZEITEN_001"
    And I set fields
      | sofort | ja |
      | gut    | ja |
      | mzeit  | 2  |
      | bzeit  | 2  |
    And I save the current editor

# Rückbau1 zu abgelegten FV
    Given I switch the current editor to editor "Rückmeldung1" with command "COPY"
    Then setting field "mzeit" to "-1" throws the exception "11034"
    And I set field "mzeit" to "0"
    Then setting field "bzeit" to "-1" throws the exception "11034"
    And I close the current editor

# Bestandskorrektur
    And I set StorageQuantity to zero for Product "BAUGRUPPE" on StorageLocation "F1"


  Scenario: 18 Es kann in einem zweiten Rückbau auf abgelegten nicht mehr rückgebaut werden, als ursprünglich gebucht wurde
# Fertigungsvorschlag anlegen und freigeben
    Given I open an editor "fvor" from table "04:11" with command "NEW" for record ""
    And I append rows
      | artikel   | netmge | mfreig | bisuch     |
      | BAUGRUPPE | 10     | ja     | ZUVIELMGE_ |
    And I press button "freig" to open a subeditor for "BA_freigeben"
    And I close the current editor
    And I switch the current editor to editor "fvor"
    And I save the current editor

# Bedarfe einkaufen
    Given I open an editor "RechnungLager" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
    And I set fields
      | lief   | KETTLER   |
      | vom    | .         |
      | ebeleg | Rückbau18 |
      | ueb    | ja        |
      | fakt   | ja        |
    And I append rows
      | artikel     | mge |
      | B_EINKAUF-1 | 20  |
      | B_EINKAUF-2 | 10  |
    And I respond with answer "ja" to the dialog with id "4841"
    And I save the current editor

# Rückmeldung1 auf ersten Arbeitsgang
    Given I open an editor "Rückmeldung1" from table "(Workorder):(WorkOrders)" with command "DONE" for record "ZUVIELMGE_001"
    And I set fields
      | sofort | ja |
      | gut    | ja |
      | mzeit  | 2  |
      | bzeit  | 2  |
    And I save the current editor

# Rückbau1 zu abgelegten FV
    Given I switch the current editor to editor "Rückmeldung1" with command "COPY"
    And I set field "gutmge" to "-5" in row 1
    And I save the current editor

# Rückbau2 zu abgelegten FV
    Given I switch the current editor to editor "Rückmeldung1" with command "COPY"
    Then setting field "gutmge" to "-6" in row 1 throws the exception "1395"
    And I close the current editor

# Bestandskorrektur
    And I set StorageQuantity to zero for Product "BAUGRUPPE" on StorageLocation "F1"


  Scenario: 19 Im Rückbau auf abgelegten FV bleibt der Status in der Zeile gesetzt
# Fertigungsvorschlag anlegen und freigeben
    Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
    And I append rows
      | artikel   | netmge | bisuch  | mfreig |
      | BAUGRUPPE | 10     | STATUS_ | ja     |
    And I press button "freig" to open a subeditor for "BA_freigeben"
    And I close the current editor
    And I switch the current editor to editor "fvor"
    And I save the current editor

# Rückmeldung auf ersten Arbeitsgang
    Given I open an editor "Rückmeldung1" from table "(Workorder):(WorkOrders)" with command "DONE" for record "STATUS_001"
    And I set field "gut" to "ja"
    And I set field "sofort" to "ja"
    And I save the current editor

# Rückbau auf ersten Arbeitsschein
    And I switch the current editor to editor "Rückmeldung1" with command "COPY"
    And I set field "gutmge" to "-5" in row 1
    Then field "status" has value "*" in row 1
    Then field "status" is not modifiable in row 1
    And I close the current editor

# Bestandskorrektur
    And I set StorageQuantity to zero for Product "BAUGRUPPE" on StorageLocation "F1"


  Scenario: 20 Im Rückbaubeleg auf abgelegte FV können für retrograd gebuchte oder neue Teile keine Zeilen hinzugefügt werden
# Fertigungsvorschlag anlegen und freigeben
    Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
    And I append rows
      | artikel   | netmge | bisuch  | mfreig |
      | BAUGRUPPE | 10     | VERBOT_ | ja     |
    And I press button "freig" to open a subeditor for "BA_freigeben"
    And I close the current editor
    And I switch the current editor to editor "fvor"
    And I save the current editor

# Rückmeldung auf ersten Arbeitsgang
    Given I open an editor "Rückmeldung1" from table "(Workorder):(WorkOrders)" with command "DONE" for record "VERBOT_001"
    And I set field "sofort" to "1"
    And I set field "gut" to "1"
    And I save the current editor

# Rückbau auf ersten Arbeitsschein, in neue Zeilen kann kein neues Teil oder bereits retrograd gebuchte Teile eingetragen werden
    And I switch the current editor to editor "Rückmeldung1" with command "COPY"
    And I create a new row at the end of the table
    And I set field "artikel" to "EINKAUF-3" in row !lastRow
    Then setting field "mge" to "-1" in row !lastRow throws the exception "1395"
    And I set field "artikel" to "EINKAUF-1" in row !lastRow
    Then setting field "mge" to "-1" in row !lastRow throws the exception "1395"
    And I close the current editor

# Bestandskorrektur
    And I set StorageQuantity to zero for Product "BAUGRUPPE" on StorageLocation "F1"


  Scenario: 21 Für Rückbau auf abgelegten FV werden Materialzuordnungen generiert
# Fertigungsvorschlag anlegen, freigeben und Rückmeldung buchen
    Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
    And I append rows
      | artikel   | mge | mfreig | bisuch  |
      | BAUGRUPPE | 10  | ja     | MZUORD_ |
    And I press button "freig" to open a subeditor for "BA_freigeben"
    And I close the current editor
    And I switch the current editor to editor "fvor"
    And I save the current editor

# Rückmeldung
    Given I open an editor "Rückmeldung1" from table "(Workorder):(WorkOrders)" with command "DONE" for record "MZUORD_001"
    And I set fields
      | sofort | ja |
      | gut    | ja |
      | bzeit  | 2  |
      | mzeit  | 2  |
    And I save the current editor

# Rückbau auf abgelegten FV
    Given I open an editor "Rückbau1" from table "(Workorder):(CompletionConfirmations)" with command "COPY" for record from editor "Rückmeldung1"
    And I set field "bem" to "MZ_Rückbau1"
    And I modify table
      | !row | mge |
      | 2    | -3  |
    And I save the current editor

# Materialzuordnung prüfen
    Given I query "artikel, zuomge, abeweg^such, abeweg^bem" from table "(MaterialsAllocation):(MaterialsAllocation)" where "artikel==EINKAUF-1;abeweg^bem==MZ_Rückbau1;lpnum==1;charge=`;zuomge==-3;@richtung=rückwärts"
    Then query has values
      | artikel   | zuomge | abeweg^such | abeweg^bem  |
      | EINKAUF-1 | -3     | MZUORD_001  | MZ_Rückbau1 |


  Scenario: 22 Erbtext wird in Rückbau zu abgelegtem FV übernommen
# Fertigungsvorschlag anlegen, freigeben und Rückmeldung buchen
    Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
    And I append rows
      | artikel   | mge | mfreig | bisuch   |
      | BAUGRUPPE | 10  | ja     | ERBTEXT_ |
    And I press button "freig" to open a subeditor for "BA_freigeben"
    And I close the current editor
    And I switch the current editor to editor "fvor"
    And I save the current editor

# Rückmeldung
    Given I open an editor "Rückmeldung1" from table "(Workorder):(WorkOrders)" with command "DONE" for record "ERBTEXT_001"
    And I set fields
      | sofort | ja |
      | gut    | ja |
      | bzeit  | 2  |
      | mzeit  | 2  |
    And I save the current editor

# Rückbau auf abgelegten FV
    Given I open an editor "Rückbau1" from table "(Workorder):(CompletionConfirmations)" with command "COPY" for record from editor "Rückmeldung1"
    And I modify table
      | !row | erbtext1 | gutmge |
      | 1    | Erbtext1 | -1     |
    And I save the current editor

# LJ prüfen
    Given I open the infosystem "LJ"
    And I set field "beleg" to "barmex" from editor "Rückmeldung1"
    And I set field "richtung" to "rückwärts"
    And I press start
    Then table has values
      | !row | erbtext1 |
      | 1    | Erbtext1 |
    And I close the current editor


  Scenario: 23 Im Rückbaubeleg können für retrograd gebuchte oder neue Teile keine Zeilen hinzugefügt werden, Gutmenge des Fertigteils kann maximal die bereits gebuchte Gutmenge sein
# Bestandskorrektur BAUGRUPPE und Auftrag anlegen
    And I set StorageQuantity to zero for Product "BAUGRUPPE" on StorageLocation "F1"
    Given I create a SalesOrder "auftrag09" for Customer "RADSHOP" with Product "BAUGRUPPE" and quantity "10"

# Fertigungsvorschlag anlegen und freigeben
    Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
    And I append rows
      | artikel   | netmge | bisuch   | mfreig |
      | BAUGRUPPE | 10     | SONICHT_ | ja     |
    And I press button "freig" to open a subeditor for "BA_freigeben"
    And I close the current editor
    And I switch the current editor to editor "fvor"
    And I save the current editor

# Rückmeldung auf ersten Arbeitsgang
    Given I open an editor "Rückmeldung1" from table "(Workorder):(WorkOrders)" with command "DONE" for record "SONICHT_001"
    And I set field "sofort" to "1"
    And I set field "gutmge" to "5" in row 1
    And I save the current editor

# Rückbau auf ersten Arbeitsschein, Ungültiger Feldwert negative Mengen
    Given I open an editor "Rückbau1" from table "(Workorder):(WorkOrders)" with command "RETURN" for record "SONICHT_001"
    And setting field "gutmge" to "-7" in row 1 throws the exception "1361"
    And I create a new row at the end of the table
    And I set field "artikel" to "EINKAUF-1" in row 2
    And setting field "mge" to "-1" in row 2 throws the exception "1361"
    And I set field "artikel" to "EINKAUF-3" in row 2
    And setting field "mge" to "-1" in row 2 throws the exception "1361"
    And I close the current editor

# Betriebsauftrag abschließen
    Given I open an editor "Rückmeldung2" from table "(Workorder):(WorkOrders)" with command "DONE" for record "SONICHT_001"
    And I set fields
      | sofort | ja  |
      | gut    | ja  |
      | mgr    | 112 |
    And I save the current editor

    And I deliver the SalesOrder "auftrag09" with PackingSlip "LS-09"


  Scenario: 24 Kein Rückbau auf abgelegten FV mit Chargen und Behältern für Gutmenge möglich, wenn vom Rückbau mehrere Rückmeldebelege betroffen sind
# Chargen anlegen
    Given I create a Lot "CH_BEH1" for Product "BG-BEHAELTER"
    Given I create a Lot "CH_BEH2" for Product "BG-BEHAELTER"

# Bestand auf 0 korrigieren, Behälter und Auftrag anlegen
    Given I set StorageQuantity to zero for Product "BG-BEHAELTER" on StorageLocation "F1"
    Given I create a Container "BEHAELTER1" for packaging material "BEHAELTER"
    Given I create a Container "BEHAELTER2" for packaging material "BEHAELTER"
    Given I create a SalesOrder "auftrag" for Customer "RADSHOP" with Product "BG-BEHAELTER" and quantity "10"

# Bedarfe einkaufen
    Given I open an editor "RechnungLager" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
    And I set fields
      | lief   | KETTLER   |
      | vom    | .         |
      | ebeleg | Rückbau30 |
      | ueb    | ja        |
      | fakt   | ja        |
    And I append rows
      | artikel   | mge |
      | EINKAUF-1 | 20  |
      | EINKAUF-2 | 10  |
    And I set field "verw" in row 1 to "verw" from editor "auftrag" in row 1
    And I set field "verw" in row 2 to "verw" from editor "auftrag" in row 1
    And I respond with answer "ja" to the dialog with id "4841"
    And I save the current editor

# Fertigungsvorschlag anlegen und freigeben
    Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
    And I append rows
      | artikel      | mge | mfreig |
      | BG-BEHAELTER | 10  | ja     |
    And I set field "verw" in row !lastRow to "verw" from editor "auftrag" in row 1
    And I press button "mzsubm" to open a subeditor for "MZ" in row !lastRow
    And I delete all rows
    And I append rows
      | zuomge | charge      | behaelter      |
      | 5      | !CH_BEH1^id | !BEHAELTER1^id |
      | 5      | !CH_BEH2^id | !BEHAELTER2^id |
    And I save the current editor
    And I switch the current editor to editor "fvor"
    And I set field "bisuch" to "CHARGEBEH_" in row !lastRow
    And I press button "freig" to open a subeditor for "BA_freigeben"
    And I close the current editor
    And I switch the current editor to editor "fvor"
    And I save the current editor

# Rückmeldung1 auf ersten Arbeitsgang und Bestand prüfen
    Given I open an editor "Rückmeldung1" from table "(Workorder):(WorkOrders)" with command "DONE" for record "CHARGEBEH_001"
    And I set fields
      | sofort  | ja |
      | gut     | ja |
      | manrest | ja |
    And I save the current editor

    Given I open the infosystem "BESTAND"
    And I set fields
      | artikel   | BG-BEHAELTER |
      | klplatz   | F1           |
      | behaelter | ja           |
      | details   | nein         |
    And I press start
    Then the table has 2 rows
    Then table has values
      | gebmge | tbehaelter^id  | charge^such |
      | 5      | !BEHAELTER1^id | CH_BEH1     |
      | 5      | !BEHAELTER2^id | CH_BEH2     |
    And I close the current editor

    Given I open an editor "Rückbau1" via ID from editor "Rückmeldung1" from field "id" in row 0 for table "(Workorder):(CompletionConfirmations)" with command "COPY"
    And I set fields
      | behaelter | !BEHAELTER1^id |
      | kcharge   | !CH_BEH1^id    |
    And I set field "gutmge" to "-7" in row 1
    Then saving the current editor throws the exception "1395"
    And I close the current editor


  Scenario: 25 Fehler beim Rueckbau von umgelagertem Material, wenn die Menge nicht stimmt
# Bestandskorrektur BAUGRUPPE
    Given I set StorageQuantity to zero for Product "BAUGRUPPE" on StorageLocation "F1"
    Given I set StorageQuantity to zero for Product "BAUGRUPPE" on StorageLocation "F2"
    Given I set StorageQuantity to zero for Product "BAUGRUPPE" on StorageLocation "F3"

# Auftrag anlegen
    Given I create a SalesOrder "auftrag25" for Customer "RADSHOP" with Product "BAUGRUPPE" and quantity "100"

# Bedarfe einkaufen
    Given I open an editor "RechnungLager25" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
    And I set fields
      | lief   | KETTLER   |
      | vom    | .         |
      | ebeleg | RückbauP1 |
      | ueb    | ja        |
      | fakt   | ja        |
    And I append rows
      | artikel   | mge |
      | EINKAUF-1 | 200 |
      | EINKAUF-2 | 100 |
    Given I set field "verw" in row 1 to "verw" from editor "auftrag" in row 1
    Given I set field "verw" in row 2 to "verw" from editor "auftrag" in row 1
    And I respond with answer "ja" to the dialog with id "4841"
    And I save the current editor

# Fertigungsvorschlag anlegen und freigeben
    Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
    And I append rows
      | artikel   | netmge | bisuch    | mfreig |
      | BAUGRUPPE | 100    | ARBEITSS_ | ja     |
    And I set field "bisuch" to "UM25RUECKBAU_" in row 1
    And I press button "freig" to open a subeditor for "BA_freigeben"
    And I close the current editor
    And I switch the current editor to editor "fvor"
    And I save the current editor

# Rückmeldung auf ersten Arbeitsgang
    Given I open an editor "Rückmeldung25" from table "(Workorder):(WorkOrders)" with command "DONE" for record "UM25RUECKBAU_001"
    And I set field "sofort" to "1"
    And I set field "gutmge" to "50" in row 1
    And I set field "erbtext1" to "Rückmeldung25" in row 1
    And I save the current editor

# Bestandsinfo prüfen
    Given I open the infosystem "BESTAND"
    And I set fields
      | artikel | BAUGRUPPE |
      | klplatz | F1        |
      | details | nein      |
    And I press start
    Then field "lemge" has value "50" in row 1
    And I press button "taufzu" in row 1
    Then field "gebmge" has value "50" in row 2
    And I close the current editor

    Given I open an editor "LBuchung" for tip command "LBuchung" and arguments ""
    And I set fields
      | artikel | BAUGRUPPE |
      | buart   | Umbuchung |
      | beleg   | 25        |
      | beldat  | .         |
    And I append rows
      | platz2 | platz | mge |
      | F3     | F1    | 25  |
      | F2     | F1    | 25  |
    And I save the current editor

    Given I open an editor "LBuchung" for tip command "LBuchung" and arguments ""
    And I set fields
      | artikel | BAUGRUPPE |
      | buart   | Umbuchung |
      | beleg   | 25        |
      | beldat  | .         |
    And I append rows
      | platz2 | platz | mge |
      | F1     | F2    | 25  |
    And I save the current editor

    Given I open an editor "LBuchung" for tip command "LBuchung" and arguments ""
    And I set fields
      | artikel | BAUGRUPPE |
      | buart   | Umbuchung |
      | beleg   | 25        |
      | beldat  | .         |
    And I append rows
      | platz2 | platz | mge |
      | F2     | F1    | 25  |
    And I save the current editor

    Given I open an editor "LBuchung" for tip command "LBuchung" and arguments ""
    And I set fields
      | artikel | BAUGRUPPE |
      | buart   | Umbuchung |
      | beleg   | 25        |
      | beldat  | .         |
    And I append rows
      | platz2 | platz | mge |
      | F3     | F2    | 25  |
    And I save the current editor

# Bestandsinfo prüfen
    Given I open the infosystem "BESTAND"
    And I set fields
      | artikel | BAUGRUPPE |
      | klplatz | F2        |
      | nullmge | nein      |
      | details | nein      |
    And I press start
    Then the table has 0 rows
    And I close the current editor

# Bestandsinfo prüfen
    Given I open the infosystem "BESTAND"
    And I set fields
      | artikel    | BAUGRUPPE |
      | klplatz    | F3        |
      | verdichten | nein      |
      | details    | nein      |
    And I press start
    And I press button "taufzu" in row 1
    Then the table has 3 rows
    Then table has values
      | lemge | gebmge |
      | 50    |        |
      |       | 25     |
      |       | 25     |
    And I close the current editor

# Rückbau auf ersten Arbeitsschein
    Given I open an editor "Rückbau25" from table "(Workorder):(WorkOrders)" with command "RETURN" for record "UM25RUECKBAU_001"
    And I set field "sofort" to "ja"
    And I set field "gutmge" to "-30" in row 1
    And I set field "buplatz" to "F2" in row 1
    And I set field "erbtext1" to "Rückbau25" in row 1
    Then saving the current editor throws the exception "2501"
    And I close the current editor

# Betriebsauftrag abschließen
    Given I open an editor "Rückmeldung25_2" from table "(Workorder):(WorkOrders)" with command "DONE" for record "UM25RUECKBAU_000"
    And I set fields
      | sofort | ja  |
      | gut    | ja  |
      | mgr    | 112 |
    And I save the current editor
    And I deliver the SalesOrder "auftrag25" with PackingSlip "LS-25"

    Given I set StorageQuantity to zero for Product "BAUGRUPPE" on StorageLocation "F1" with document "SCEN-25"
    Given I set StorageQuantity to zero for Product "BAUGRUPPE" on StorageLocation "F2" with document "SCEN-25"
    Given I set StorageQuantity to zero for Product "BAUGRUPPE" on StorageLocation "F3" with document "SCEN-25"


  Scenario: 26 Schreibschutz auf Flags manrest/stornorest im Rückbaubeleg bei Kommando ändern
# Fertigungsvorschlag anlegen und freigeben
    Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
    And I append rows
      | artikel   | netmge | bisuch | mfreig |
      | BAUGRUPPE | 10     | RBUPD_ | ja     |
    And I press button "freig" to open a subeditor for "BA_freigeben"
    And I close the current editor
    And I switch the current editor to editor "fvor"
    And I save the current editor

# Rückmeldung auf ersten Arbeitsgang
    Given I open an editor "Rückmeldung1" from table "(Workorder):(WorkOrders)" with command "DONE" for record "RBUPD_001"
    And I set field "sofort" to "1"
    And I set field "gutmge" to "5" in row 1
    And I save the current editor

# Rückbau auf ersten Arbeitsschein anlegen
    Given I open an editor "RückbauRet" from table "(Workorder):(WorkOrders)" with command "RETURN" for record "RBUPD_001"
    And I set field "sofort" to "0"
    And I set field "gutmge" to "-2" in row 1
    And I save the current editor

# Rückbau auf ersten Arbeitsschein mit ändern öffnen und Scheibschutz prüfen
    Given I open an editor "RückbauUpd" from table "(Workorder):(CompletionConfirmations)" with command "UPDATE" for search criteria "$,,such=RBUPD_001;@richtung=rückwärts;@ablageart=lebendig;@maxtreffer=1"
    Then field "sofort" is modifiable
    Then field "gut" is not modifiable
    Then field "manrest" is not modifiable
    Then field "stornorest" is not modifiable
    Then field "mgereduzieren" is modifiable
    Then field "status" is modifiable in row 1
    And I set field "sofort" to "1"
    And I save the current editor

# Betriebsauftrag abschließen
    Given I open an editor "Betriebsauftrag" from table "(Workorder):(WorkOrders)" with command "UPDATE" for record "RBUPD_000"
    And I respond with answer "ja" to the dialog with id "345"
    And I set field "status" to "s"
    And I save the current editor

