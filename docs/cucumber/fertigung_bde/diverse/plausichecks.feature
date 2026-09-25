@persistent
Feature: plausichecks.feature

  Background:
    Given I set the fake date to "02.01.1995"

# *****************************************************************************
#  Name             : plausichecks.feature
#  Autor            : lschneider
#  Verantwortlich   : drpf
#  Kontrolle        : amk
#  Funktion         : Testet Plausibilitäten im Bereich Fertigung
#  ref              : ref_fe_plausichecks_cu
#
# *****************************************************************************

  Scenario: 01 Rückmeldung auf abgelegten FV mit Gutmenge erzeugt eine Rückmeldung typ=Rückmeldung zu abgelegtem Betriebsauftrag

# Fertigungsvorschlag anlegen und freigeben
    Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
    And I append rows
      | artikel     | netmge | mfreig | bisuch     |
      | B_BAUGRUPPE | 10     | ja     | ABLAGETYP_ |
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
    And I run Scheduling

# Rückmeldung1 auf ersten Arbeitsgang
    Given I open an editor "Rückmeldung1" from table "(Workorder):(WorkOrders)" with command "DONE" for record "ABLAGETYP_001"
    And I set fields
      | sofort | ja |
      | gut    | ja |
    And I save the current editor

# Rückmeldung zu abgelegtem Fertigungsvorschlag
    And I switch the current editor to editor "Rückmeldung1" with command "COPY"
    And I set field "gutmge" to "2" in row 1
    And I save the current editor
    Then field "typa279" has value "Rückmeldung auf abgelegten Fertigungsvorschlag"


  Scenario: 02 In einer Rückmeldung auf abgelegten FV dürfen negative und positive Vorzeichen nicht gemischt werden

    Given I set the fake date to "03.01.1995"
# Fertigungsvorschlag anlegen und freigeben
    Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
    And I append rows
      | artikel     | netmge | mfreig | bisuch     |
      | B_BAUGRUPPE | 10     | ja     | MENGEZEIT_ |
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
    And I run Scheduling

# Rückmeldung1 auf ersten Arbeitsgang
    Given I open an editor "Rückmeldung1" from table "(Workorder):(WorkOrders)" with command "DONE" for record "MENGEZEIT_001"
    And I set fields
      | sofort | ja |
      | gut    | ja |
    And I save the current editor

# Rückmeldung zu abgelegtem Fertigungsvorschlag
    # Fehler: In einer Rückmeldung sind nur positive Mengen zulässig.
    And I switch the current editor to editor "Rückmeldung1" with command "COPY"
    And I set field "gutmge" to "2" in row 1
    Then setting field "mge" to "-2" in row 2 throws the exception "11120"
    And I close the current editor


  Scenario: 03 Fehler, wenn negative Gutmenge oder Arbeitszeit in Rückmeldebeleg eingegeben wird

    Given I set the fake date to "04.01.1995"
    Given I open an editor "RM" from table "(Workorder):(CompletionConfirmations)" with command "NEW" for record ""
    And I set field "mgr" to "101"
    Then setting field "bzeit" to "-1" throws the exception "11034"
    Then setting field "bzeit2" to "-1" throws the exception "11034"
    Then setting field "bzeit3" to "-1" throws the exception "11034"
    Then setting field "bzeit4" to "-1" throws the exception "11034"
    Then setting field "bzeit5" to "-1" throws the exception "11034"
    Then setting field "mzeit" to "-1" throws the exception "11034"
    Then setting field "mzeit2" to "-1" throws the exception "11034"
    Then setting field "mzeit3" to "-1" throws the exception "11034"
    Then setting field "mzeit4" to "-1" throws the exception "11034"
    Then setting field "mzeit5" to "-1" throws the exception "11034"
    And I create a new row at the end of the table
    And I set field "artikel" to "BG1" in row 1
    Then setting field "gutmge" to "-1" in row 1 throws the exception "11134"
    Then setting field "mge" to "-1" in row 1 throws the exception "11134"
    Then setting field "bumge" to "-1" in row 1 throws the exception "11134"
    Then setting field "verlustmge" to "-1" in row 1 throws the exception "11134"
    And I close the current editor


  Scenario: 04 Eine Rückmeldung kann durch ändern und löschen der Zeilen nicht mehr gelöscht werden

    Given I set the fake date to "05.01.1995"
# FV anlegen und freigeben
    Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
    And I append rows
      | artikel     | netmge | mfreig | bisuch       |
      | B_BAUGRUPPE | 10     | ja     | RUECKLOESCH_ |
    And I press button "freig" to open a subeditor for "BA_freigeben"
    And I close the current editor
    And I switch the current editor to editor "fvor"
    And I save the current editor

# Rückmeldung ohne buchen speichern
    Given I open an editor "Rückmeldung1" from table "(Workorder):(WorkOrders)" with command "DONE" for record "RUECKLOESCH_001"
    And I set field "gutmge" to "5" in row 1
    And I save the current editor

    Given I switch the current editor to editor "Rückmeldung1" with command "UPDATE"
    And I delete all rows
    Then saving the current editor throws the exception "3001"
    And I close the current editor

# Rückmeldung und BA löschen
    Given I switch the current editor to editor "Rückmeldung1" with command "DELETE"
    And I respond with answer "ja" to the dialog with id "826"
    And I save the current editor

    Given I open an editor "Betriebsauftrag" from table "(Workorder):(WorkOrders)" with command "UPDATE" for record "RUECKLOESCH_000"
    And I respond with answer "ja" to the dialog with id "345"
    And I set field "status" to "s"
    And I save the current editor


######## Retrogrades Material wird abgebucht bei letzter RM falls offene Mengen vorhanden sind ######

  Scenario: 05 Retrograd gebuchtes Material kann zurückgelegt werden, wenn im BA der Löschschutz gesetzt und der Status gefüllt ist

    Given I set the fake date to "06.01.1995"
# Auftrag anlegen
    Given I create a SalesOrder "auftrag3" for Customer "RADSHOP" with Product "BAUGRUPPE" and quantity "50"

# Material einkaufen
    Given I open an editor "Lieferung" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
    And I set fields
      | lief   | KETTLER  |
      | fakt   | ja       |
      | vom    | .        |
      | ebeleg | Rechnung |
      | ueb    | ja       |
      | budat  | .        |
    And I append rows
      | artikel   | mge |
      | EINKAUF-1 | 100 |
      | EINKAUF-2 | 50  |
    And I set field "verw" in row 1 to "verw" from editor "auftrag3" in row 1
    And I respond with answer "ja" to the dialog with id "4841"
    And I save the current editor

# Fertigungsvorschlag anlegen
    Given I open an editor "FV3" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
    And I append rows
      | artikel   | netmge | bisuch | binoloe | mfreig |
      | BAUGRUPPE | 50     | FV3_   | ja      | ja     |
    And I set field "verw" in row !lastRow to "verw" from editor "auftrag3" in row 1
    And I press button "freig" to open a subeditor for "BA_freigeben"
    And I close the current subeditor to switch back to the parent editor
    And I close the current editor

# Rückmeldung auf ersten Arbeitsschein
    Given I open an editor "Rückmeldung1" from table "(Workorder):(WorkOrders)" with command "DONE" for search criteria "$,,such=FV3_001;@richtung=rückwärts;@maxordtreffer=1"
    And I set field "sofort" to "1"
    And I set field "gutmge" to "20" in row 1
    And I save the current editor

# Materialrückgabe buchen
    Given I open an editor "MatEnt" for tip command "Fbuchung" and arguments ""
    And I set field "auftrag" to "!Rückmeldung1^barmex"
    And I set field "gmgevorschl" to "-10"
    And I set field "autorment" to "ja"
    And I press button "stlvblad"
    And I delete row at position 2
    And I save the current editor

# Rückmeldung auf ersten Arbeitsschein, reduzierte Gutmenge durch Setzen Statuskennzeichen
    Given I open an editor "Rückmeldung2" from table "(Workorder):(WorkOrders)" with command "DONE" for search criteria "$,,such=FV3_001;@richtung=rückwärts;@maxordtreffer=1"
    And I set field "sofort" to "1"
    And I set field "gutmge" to "25" in row 1
    And I set field "status" to "S" in row 1
    And I save the current editor

# prüfen Löschschutz ist gesetzt und Status ist gefüllt (offene Menge ist größer 0)
    Given I open an editor "BA" from table "(Workorder):(WorkOrders)" with command "VIEW" for search criteria "$,,such=FV3_000;@richtung=rückwärts;@maxordtreffer=1"
    Then field "noloesch" has value "ja"
    Then field "status" is not empty
    And I close the current editor

# prüfen retrogrades Material kann nicht zurückgelegt werden, bumge ist 0 und schreibgeschützt
    Given I open an editor "MatEnt" for tip command "Fbuchung" and arguments ""
    And I set field "auftrag" to "!Rückmeldung1^barmex"
    And I set field "autorment" to "ja"
    And I press button "stlvblad"
    Then field "elex" has value "EINKAUF-1" in row 1
    Then field "bumge" has value "0" in row 1
    Then field "bumge" is not modifiable in row 1
    And I close the current editor

# prüfen retrogrades Material kann nicht zurückgelegt werden, Mengenvorschlag, bumge ist 0 und schreibgeschützt
    Given I open an editor "MatEnt" for tip command "Fbuchung" and arguments ""
    And I set field "auftrag" to "!Rückmeldung1^barmex"
    And I set field "gmgevorschl" to "-10"
    And I set field "autorment" to "ja"
    And I press button "stlvblad"
    Then field "elex" has value "EINKAUF-1" in row 1
    Then field "bumge" has value "-20" in row 1
    Then field "bumge" is not modifiable in row 1
    And I close the current editor

# BA abschließen - Löschschutz entfernen
    Given I open an editor "BA" from table "(Workorder):(WorkOrders)" with command "UPDATE" for search criteria "$,,such=FV3_000;@richtung=rückwärts;@maxordtreffer=1"
    And I set field "noloesch" to "nein"
    And I save the current editor

# Auftragsmenge reduzieren (um Auftrag abzuschließen)
    Given I switch the current editor to editor "auftrag3" with command "UPDATE"
    And I set field "mge" to "45" in row 1
    And I save the current editor

# Auftrag liefern
    Given I switch the current editor to editor "auftrag3" with command "DELIVERY"
    And I set fields
      | vom | .  |
      | ueb | ja |
    And I set field "mge" to "50" in row 1
    And I save the current editor


  Scenario: 06 Hinweis in RM, wenn manuell entnommenes Material bei letzter RM noch offen ist und Schreibschutz, falls es noch ungebuchte RM gibt, BA mit Löschschutz

    Given I set the fake date to "07.01.1995"
# Bestandskorrektur
    Given I set StorageQuantity to zero for Product "EINKAUF-1" on StorageLocation "F1"

# Auftrag anlegen
    Given I create a SalesOrder "auftrag4" for Customer "RADSHOP" with Product "BAUGRUPPE" and quantity "50"

# Material einkaufen
    Given I open an editor "Lieferung" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
    And I set fields
      | lief   | KETTLER  |
      | fakt   | ja       |
      | vom    | .        |
      | ebeleg | Rechnung |
      | ueb    | ja       |
      | budat  | .        |
    And I append rows
      | artikel   | mge |
      | EINKAUF-1 | 100 |
      | EINKAUF-2 | 50  |
    And I set field "verw" in row 1 to "verw" from editor "auftrag4" in row 1
    And I respond with answer "ja" to the dialog with id "4841"
    And I save the current editor

# Fertigungsvorschlag anlegen
    Given I open an editor "FV1" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
    And I append rows
      | artikel   | netmge | bisuch | binoloe | mfreig |
      | BAUGRUPPE | 50     | FV4_   | ja      | ja     |
    And I set field "verw" in row !lastRow to "verw" from editor "auftrag4" in row 1
    And I press button "freig" to open a subeditor for "BA_freigeben"
    And I close the current subeditor to switch back to the parent editor
    And I close the current editor

# Rückmeldung auf ersten Arbeitsschein, nicht buchen
    Given I open an editor "Rückmeldung1" from table "(Workorder):(WorkOrders)" with command "DONE" for search criteria "$,,such=FV4_001;@richtung=rückwärts;@maxordtreffer=1"
    And I set field "gutmge" to "20" in row 1
    And I save the current editor

# Löschschutz im BA prüfen
    Given I open an editor "BA" from table "(Workorder):(WorkOrders)" with command "UPDATE" for search criteria "$,,such=FV4_000;@richtung=rückwärts;@maxordtreffer=1"
    Then field "noloesch" is not modifiable
    And I close the current editor

# Rückmeldung auf ersten Arbeitsschein buchen
    Given I open an editor "Rückmeldung1" from table "(Workorder):(WorkOrders)" with command "TRANSFER" for search criteria "$,,such=FV4_001;@richtung=rückwärts;@maxordtreffer=1"
    And I save the current editor

# Materialrückgabe buchen
    Given I open an editor "MatEnt" for tip command "Fbuchung" and arguments ""
    And I set field "auftrag" to "!Rückmeldung1^barmex"
    And I set field "autorment" to "ja"
    And I press button "stlvblad"
    And I delete row at position 2
    And I set field "manbu" to "ja" in row 1
    And I set field "bumge" to "-10" in row 1
    And I save the current editor

# Löschschutz im BA entfernen
    Given I open an editor "BA" from table "(Workorder):(WorkOrders)" with command "UPDATE" for search criteria "$,,such=FV4_000;@richtung=rückwärts;@maxordtreffer=1"
    And I set field "noloesch" to "nein"
    And I save the current editor

# Rückmeldung auf ersten Arbeitsschein
    Given I open an editor "Rückmeldung2" from table "(Workorder):(WorkOrders)" with command "DONE" for search criteria "$,,such=FV4_001;@richtung=rückwärts;@maxordtreffer=1"
    And I set field "sofort" to "1"
    And I set field "gutmge" to "30" in row 1
# Fehlermeldung Wählen Sie ein Buchungsverfahren für die Restmenge
    Then saving the current editor throws the exception "1006"
    And I set field "manrest" to "ja"
    And I save the current editor

# LJ prüfen von EINKAUF-1
    Given I open the infosystem "LJ"
    And I set field "beleg" to "!Rückmeldung2^barmex"
    And I set field "artikel" to "EINKAUF-1"
    And I press button "bstart"
    Then table has values
      | art       | amge | detursache            | !row     |
      | EINKAUF-1 | 70   | Rückmeldung Fertigung | !lastRow |
    And I close the current editor

# Bestand von EINKAUF-1 prüfen
    Given I open the infosystem "BESTAND"
    And I set fields
      | artikel | EINKAUF-1 |
      | klplatz | F1        |
      | nullmge | nein      |
    And I press button "bstart"
    Then the table has 0 rows
    And I close the current editor

# Auftrag liefern
    Given I switch the current editor to editor "auftrag4" with command "DELIVERY"
    And I set fields
      | vom | .  |
      | ueb | ja |
    And I set field "mge" to "50" in row 1
    And I save the current editor


  Scenario: 07 Hinweis beim Entfernen des Löschschutzes, wenn manuell entnommenes Material bei letzter Rückmeldung noch offen ist

    Given I set the fake date to "08.01.1995"
# Auftrag anlegen
    Given I create a SalesOrder "auftrag5" for Customer "RADSHOP" with Product "BAUGRUPPE" and quantity "50"

# Material einkaufen
    Given I open an editor "Lieferung" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
    And I set fields
      | lief   | KETTLER  |
      | fakt   | ja       |
      | vom    | .        |
      | ebeleg | Rechnung |
      | ueb    | ja       |
      | budat  | .        |
    And I append rows
      | artikel   | mge |
      | EINKAUF-1 | 100 |
      | EINKAUF-2 | 50  |
    And I set field "verw" in row 1 to "verw" from editor "auftrag5" in row 1
    And I respond with answer "ja" to the dialog with id "4841"
    And I save the current editor

# Fertigungsvorschlag anlegen
    Given I open an editor "FV5" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
    And I append rows
      | artikel   | netmge | bisuch | binoloe | mfreig |
      | BAUGRUPPE | 50     | FV5_   | ja      | ja     |
    And I set field "verw" in row !lastRow to "verw" from editor "auftrag5" in row 1
    And I press button "freig" to open a subeditor for "BA_freigeben"
    And I close the current subeditor to switch back to the parent editor
    And I close the current editor

# Rückmeldung auf ersten Arbeitsschein
    Given I open an editor "Rückmeldung1" from table "(Workorder):(WorkOrders)" with command "DONE" for search criteria "$,,such=FV5_001;@richtung=rückwärts;@maxordtreffer=1"
    And I set field "sofort" to "1"
    And I set field "gutmge" to "20" in row 1
    And I save the current editor

# Materialrückgabe buchen
    Given I open an editor "MatEnt" for tip command "Fbuchung" and arguments ""
    And I set field "auftrag" to "!Rückmeldung1^barmex"
#And I set field "gmgevorschl" to "-10"
    And I set field "autorment" to "ja"
    And I press button "stlvblad"
    And I delete row at position 2
    And I set field "manbu" to "ja" in row 1
    And I set field "bumge" to "-10" in row 1
    And I save the current editor

# Rückmeldung auf ersten Arbeitsschein
    Given I open an editor "Rückmeldung2" from table "(Workorder):(WorkOrders)" with command "DONE" for search criteria "$,,such=FV5_001;@richtung=rückwärts;@maxordtreffer=1"
    And I set field "sofort" to "1"
    And I set field "gutmge" to "30" in row 1
    And I save the current editor

# Löschschutz im BA entfernen
    Given I open an editor "BA" from table "(Workorder):(WorkOrders)" with command "UPDATE" for search criteria "$,,such=FV5_000;@richtung=rückwärts;@maxordtreffer=1"
# Fehlermeldung Löschschutz kann nicht entfernt werden, da noch Restmengen vorhanden
    Then setting field "noloesch" to "nein" throws the exception "1697"
    And I close the current editor

# BA abschließen - Rückmeldung auf ersten Arbeitsschein mit Gutmenge 0
    Given I open an editor "Rückmeldung2" from table "(Workorder):(WorkOrders)" with command "DONE" for search criteria "$,,such=FV5_001;@richtung=rückwärts;@maxordtreffer=1"
    And I set field "sofort" to "1"
    And I set field "manrest" to "1"
#And I set field "gutmge" to "0" in row 1
    And I save the current editor

# Löschschutz entfernen im BA nun möglich
    Given I open an editor "BA" from table "(Workorder):(WorkOrders)" with command "UPDATE" for search criteria "$,,such=FV5_000;@richtung=rückwärts;@maxordtreffer=1"
    And I set field "noloesch" to "nein"
    And I save the current editor

# Auftrag liefern
    Given I switch the current editor to editor "auftrag5" with command "DELIVERY"
    And I set fields
      | vom | .  |
      | ueb | ja |
    And I set field "mge" to "50" in row 1
    And I save the current editor


  Scenario: 08 Zeitbuchung auf eine RM ohne Betriebsauftrag / Kopieren einer RM ohne Betriebsauftrag

    Given I set the fake date to "09.01.1995"
# FDA-2608
    Given I open an editor "RM_ohne_BA" from table "(Workorder):(CompletionConfirmations)" with command "NEW" for record ""
    And I set fields
      | barmex  | 38001 |
      | artikel | V1    |
      | mgr     | 112   |
      | kstelle | 101   |
    And I append rows
      | artikel | mge |
      | V1      | 10  |
    And I save the current editor

# Fehler:  3004 TX=de   |Zeitbuchungen/Zeitkorrekturen nicht möglich zu Fertigungen ohne Fertigungsvorschlag.
    Given I open an editor "Zeitbuchung" for tip command "Zeitbuchung" and arguments ""
    Then setting field "barmex" to "+38001" throws the exception "3004"
    And I close the current editor

# Kein Fehler: Kopieren ist erlaubt
    Given I open an editor "Copy_RM_Neu" from table "(Workorder):(CompletionConfirmations)" with command "NEW" for record "+38001"
    Then field "typa279" has value "Rückmeldung ohne Fertigungsvorschlag"
    And I save the current editor


  Scenario: 09 Verhalten offene Menge bei Fertigungsvorschlag freigeben

    Given I set the fake date to "10.01.1995"
# FDA-3423
    Given I open an editor "FV09" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
    And I append rows
      | artikel | netmge | verw   | mfreig |
      | BAUT    | 50     | SCEN09 | ja     |
    And I save the current editor

    Given I open an editor "FV09frei" from table "(Purchasing):(WorkOrderSuggestion)" with command "RELEASE" for search criteria "$,,artikel==BAUT;verw==SCEN09;@richtung=rückwärts;@maxordtreffer=1"
    Then field "mfreig" has value "ja"
    Then field "netmge" has value "50"
    Then field "netlimge" has value "0"
    Then field "netfrgmge" has value "50"
    And I set field "mfreig" to "nein"
    Then field "netlimge" in row 0 has value equal to field "netmge" in row 0
    Then field "netfrgmge" has value "0"
    And I set field "netfrgmge" to "50"
    Then field "netlimge" has value "0"
    And I close the current editor

    Given I open an editor "FV09frei" from table "(Purchasing):(WorkOrderSuggestion)" with command "RELEASE" for search criteria "$,,artikel==BAUT;verw==SCEN09;@richtung=rückwärts;@maxordtreffer=1"
    Then field "mfreig" has value "ja"
    Then field "netmge" has value "50"
    Then field "netlimge" has value "0"
    Then field "netfrgmge" has value "50"
    And I set field "mfreig" to "nein"
    Then field "netfrgmge" has value "0"
    And I set field "mfreig" to "ja"
    Then field "netfrgmge" has value "50"
    And I set field "netfrgmge" to "20"
    Then field "netlimge" has value "30"
    And I close the current editor


  Scenario: 10 Bruttomenge darf nicht kleiner als Anfahrmenge sein beim Anlegen und Freigeben eines Fertigungsvorschlags

    Given I set the fake date to "11.01.1995"
    Given I open an editor "ANFAHR" from table "(Part):(Product)" with command "COPY" for record "BAUT"
    And I set field "such" to "ANFAHR"
    And I modify table
      | !row | amge |
      | 2    | 3    |
      | 3    | 2    |
    And I save the current editor

    Given I open an editor "FV10" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
    And I append rows
      | artikel | verw   |
      | ANFAHR  | SCEN10 |
# 3009 TX=de |Die angegebene Bruttomenge ist kleiner als der errechnete Verlust.
    Then setting field "mge" to "4" in row 1 throws the exception "3009"
    Then I set field "mge" to "20" in row 1
    Then I set field "mfreig" to "ja" in row 1
    Then field "netmge" has value "15" in row 1
    And I save the current editor

    Given I open an editor "FV10frei" from table "(Purchasing):(WorkOrderSuggestion)" with command "RELEASE" for search criteria "$,,artikel==ANFAHR;verw==SCEN10;@richtung=rückwärts;@maxordtreffer=1"
    Then field "mfreig" has value "ja"
    Then field "netmge" has value "15"
    Then field "netlimge" has value "0"
    Then field "netfrgmge" has value "15"
    Then field "mge" has value "20"
# 3009 TX=de |Die angegebene Bruttomenge ist kleiner als der errechnete Verlust.
    Then setting field "frgmge" to "5" throws the exception "3009"
    And I set field "frgmge" to "10"
    Then field "netfrgmge" has value "5"
    And I set field "bisuch" to "FV10_"
    And I save the current editor

    Given I open an editor "BA" from table "(Workorder):(WorkOrders)" with command "UPDATE" for search criteria "$,,such=FV10_000;@richtung=rückwärts;@maxordtreffer=1"
    And I press button "absteig" to open a subeditor for "AFL"
    Then fields have values
      | netbgmge   | 5 |
      | netblimge  | 5 |
      | netbfrgmge | 5 |
    Then table has values
      | !row | limge | frgmge |
      | 1    | 20    | 20     |
      | 2    | 10    | 10     |
      | 3    | 7     | 7      |
    And I save the current editor


  Scenario: 11 Rundungsfaktor muss beachtet werden beim Anlegen und Freigeben eines Fertigungsvorschlags

    Given I set the fake date to "12.01.1995"
    Given I open an editor "RUNDUNG" from table "(Part):(Product)" with command "COPY" for record "BAUT"
    And I set field "such" to "RUNDUNG"
    And I set field "rundung" to "0,5"
    And I save the current editor

    Given I open an editor "FV11" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
    And I append rows
      | artikel | verw   |
      | RUNDUNG | SCEN11 |
# 3013 TX=de |Der angegebene Wert korrespondiert nicht mit dem hinterlegten Rundungsfaktor des Artikels.
    Then setting field "mge" to "5,25" in row 1 throws the exception "3013"
    Then I set field "mge" to "5,5" in row 1
    Then I set field "mfreig" to "ja" in row 1
    Then field "netmge" has value "5.5" in row 1
    And I save the current editor

    Given I open an editor "FV11frei" from table "(Purchasing):(WorkOrderSuggestion)" with command "RELEASE" for search criteria "$,,artikel==RUNDUNG;verw==SCEN11;@richtung=rückwärts;@maxordtreffer=1"
    Then field "mfreig" has value "ja"
    Then field "netmge" has value "5.5"
    Then field "netlimge" has value "0"
    Then field "netfrgmge" has value "5.5"
# 3013 TX=de |Der angegebene Wert korrespondiert nicht mit dem hinterlegten Rundungsfaktor des Artikels.
    Then setting field "netfrgmge" to "2,25" throws the exception "3013"
    And I set field "netfrgmge" to "2,5"
    Then field "frgmge" has value "2.5"
    Then field "netlimge" has value "3"
    Then field "limge" has value "3"
# 3013 TX=de |Der angegebene Wert korrespondiert nicht mit dem hinterlegten Rundungsfaktor des Artikels.
    Then setting field "frgmge" to "3,25" throws the exception "3013"
    And I set field "frgmge" to "3,5"
    Then field "netfrgmge" has value "3.5"
    Then field "netlimge" has value "2"
    Then field "limge" has value "2"
    And I save the current editor


  Scenario: 12 Ruestzeit und Einzelzeit von Arbeitsgaengen mit Menge 0 und Anfahrmenge 0 werden nicht berücksichtigt
#FDA-3644

    Given I set the fake date to "13.01.1995"
    Given I open an editor "KOMMENTAR_AG" from table "(Part):(Product)" with command "COPY" for record "BAUGRUPPE2"
    And I set field "such" to "KOMMENTAR_AG"
    And I set field "namebspr" to "BG mit Kommentararbeitsgang"
    And I modify table
      | !row | elex  | tr | te | anzahl |
      | +4   | A AG1 | 30 | 20 | 0      |
    And I save the current editor

    Given I open an editor "FV12" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
    And I append rows
      | artikel      | netmge | verw   |
      | KOMMENTAR_AG | 10     | SCEN12 |
    And I save the current editor

    Given I switch the current editor to editor "FV12" with command "VIEW"
    Then field "tr" has value "0.33"
    Then field "te" has value "0.27"
    And I close the current editor


  Scenario: 13 Ruestzeit und Einzelzeit von Arbeitsgaengen mit Menge 0 und Anfahrmenge groesser 0 werden berücksichtigt
#FDA-3644

    Given I set the fake date to "14.01.1995"
    Given I open an editor "KOMMENTAR_AG" from table "(Part):(Product)" with command "UPDATE" for record "KOMMENTAR_AG"
    And I set field "amge" to "1" in row 4
    And I save the current editor

    Given I open an editor "FV13" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
    And I append rows
      | artikel      | netmge | verw   |
      | KOMMENTAR_AG | 10     | SCEN13 |
    And I save the current editor

    Given I open an editor "FV13" from table "(Purchasing):(WorkOrderSuggestion)" with command "VIEW" for search criteria "$,,artikel==KOMMENTAR_AG;verw==SCEN13;@richtung=rückwärts;@maxordtreffer=1"
    Then field "tr" has value "0.83"
    Then field "te" has value "0.6"
    And I close the current editor

# bei Filter NIE wird der Arbeitsgang nicht mehr beruecksichtigt
    Given I switch the current editor to editor "FV13" with command "UPDATE"
    And I press button "absteig" to open a subeditor for "AFL"
    And I set field "filter" to "NIE" in row 4
    And I save the current editor

    Given I switch the current editor to editor "FV13" with command "VIEW"
    Then field "tr" has value "0.33"
    Then field "te" has value "0.27"
    And I close the current editor


  Scenario: 14 Offene Menge passt sich entsprechend der Ueberbuchung des BAs an, Buchung ueber BA
# FDA-3896

    Given I set the fake date to "15.01.1995"
    Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
    And I append rows
      | artikel    | netmge | binoloe | mfreig | bisuch  |
      | BAUGRUPPE2 | 5      | ja      | ja     | UEBERBA |
    And I press button "freig" to open a subeditor for "fvor_freigeben"
    And I close the current subeditor to switch back to the parent editor
    And I close the current editor
    
# Rueckmledung auf BA ueber 8 Stueck, BA wird ueberbucht
    Given I open an editor "Rueckmeldung_BA1" from table "(Workorder):(WorkOrders)" with command "DONE" for record "UEBERBA000"
    And I set field "mgr" to "101"
    And I set field "sofort" to "ja"
    And I set field "gutmge" to "8" in row 1
    And I save the current editor

    Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "UPDATE" for record ""
    And I set field "artikel" to "BAUGRUPPE2"
    And I press button "ladetab"
    And I press button "absteig" to open a subeditor for "FV" in row 1
    Then field "netblimge" has value "-3"

    And I set field "netblimge" to "0"
    Then field "netbgmge" has value "8"
    And I set field "netblimge" to "12"
    Then field "netbgmge" has value "20"
# Fehlermeldung bei negativen Werten
# 1719 de      |Reduktionsgrenze unterschritten.
    Then setting field "netblimge" to "-10" throws the exception "1719"

    And I close the current subeditor to switch back to the parent editor

# Erst Gesamtmenge und dann Offene Menge aendern, Menge erhoehen
    And I press button "absteig" to open a subeditor for "FV" in row 1
    And I set field "netbgmge" to "10"
    Then field "netblimge" has value "2"

    And I set field "netblimge" to "3"
    Then field "netbgmge" has value "11"
    And I save the current subeditor to switch back to the parent editor

# Erst Gesamtmenge und dann Offene Menge aendern, Menge reduzieren
    And I press button "absteig" to open a subeditor for "FV" in row 1
    And I set field "netbgmge" to "15"
    Then field "netblimge" has value "7"

    And I set field "netblimge" to "5"
    Then field "netbgmge" has value "13"
    And I set field "netbfrgmge" to "5"
    And I save the current subeditor to switch back to the parent editor
    And I close the current editor

# Rueckmeldung auf BA und Loeschchutz aus BA entfernen
    Given I open an editor "Rueckmeldung_BA2" from table "(Workorder):(WorkOrders)" with command "DONE" for record "UEBERBA000"
    And I set fields
      | mgr    | 101 |
      | gut    | ja  |
      | sofort | ja  |
    And I save the current editor

    Given I open an editor "BA_UEBERBA" from table "(Workorder):(WorkOrders)" with command "UPDATE" for record "UEBERBA000"
    And I set field "noloesch" to "nein"
    And I save the current editor


  Scenario: 15 Offene Menge passt sich entsprechend der Ueberbuchung des BAs an, Buchung ueber AS
# FDA-3896

    Given I set the fake date to "16.01.1995"
    Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
    And I append rows
      | artikel    | netmge | binoloe | mfreig | bisuch  |
      | BAUGRUPPE2 | 5      | ja      | ja     | UEBERAS |
    And I press button "freig" to open a subeditor for "fvor_freigeben"
    And I close the current subeditor to switch back to the parent editor
    And I close the current editor

# Rueckmledung auf AS ueber 8 Stueck, BA wird ueberbucht
    Given I open an editor "Rueckmeldung1_AS2" from table "(Workorder):(WorkOrders)" with command "DONE" for record "UEBERAS002"
    And I set field "mgr" to "101"
    And I set field "sofort" to "ja"
    And I set field "gutmge" to "8" in row 1
    And I save the current editor

    Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "UPDATE" for record ""
    And I set field "artikel" to "BAUGRUPPE2"
    And I press button "ladetab"
    And I press button "absteig" to open a subeditor for "FV" in row 1
    Then field "netblimge" has value "-3"

    And I set field "netblimge" to "0"
    Then field "netbgmge" has value "8"
    And I set field "netblimge" to "12"
    Then field "netbgmge" has value "20"
# Fehlermeldung bei negativen Werten
# 1719 de      |Reduktionsgrenze unterschritten.
    Then setting field "netblimge" to "-10" throws the exception "1719"

    And I close the current subeditor to switch back to the parent editor

# Erst Gesamtmenge und dann Offene Menge aendern, Menge erhoehen
    And I press button "absteig" to open a subeditor for "FV" in row 1
    And I set field "netbgmge" to "10"
    Then field "netblimge" has value "2"

    And I set field "netblimge" to "3"
    Then field "netbgmge" has value "11"
    And I save the current subeditor to switch back to the parent editor

# Erst Gesamtmenge und dann Offene Menge aendern, Menge reduzieren
    And I press button "absteig" to open a subeditor for "FV" in row 1
    And I set field "netbgmge" to "15"
    Then field "netblimge" has value "7"

    And I set field "netblimge" to "5"
    Then field "netbgmge" has value "13"
    And I set field "netbfrgmge" to "5"
    And I save the current subeditor to switch back to the parent editor
    And I close the current editor

# Rueckmeldung auf AS und Loeschchutz aus BA entfernen
    Given I open an editor "Rueckmeldung2_AS2" from table "(Workorder):(WorkOrders)" with command "DONE" for record "UEBERAS002"
    And I set fields
      | mgr    | 101 |
      | gut    | ja  |
      | sofort | ja  |
    And I save the current editor

    Given I open an editor "BA_UEBERAS" from table "(Workorder):(WorkOrders)" with command "UPDATE" for record "UEBERAS000"
    And I set field "noloesch" to "nein"
    And I save the current editor


  Scenario: 16 Materialzuordnung Fertigartikel und Entnahmeartikel fuer Dienstleistungen nicht aufrufbar
# FDA-2705

    Given I set the fake date to "17.01.1995"
    Given I open an editor "DIENSTLEISTUNG" from table "(Part):(Service)" with command "STORE" for record "DIENSTLEISTUNG"
    And I set fields
      | such     | DIENSTLEISTUNG |
      | namebspr | Analyse        |
      | vpr      | 50             |
    And I delete all rows
    And I append rows
      | elex  |
      | A AG1 |
    And I save the current editor

    Given I open an editor "Repauftrag" from table "(Sales):(RepairOrder)" with command "NEW" for record ""
    And I set fields
      | kunde | 1 |
    And I append rows
      | artikel         | mge |
      | !DIENSTLEISTUNG | 1   |
    And I save the current editor

    And I run Scheduling
    
# Fehlermeldungen beim Aufruf der MZ aus FV-Maske und BA
    Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "UPDATE" for record ""
    And I set field "artikel" to "DIENSTLEISTUNG"
    And I press button "ladetab"
# 1272 de      |Funktion nicht ausführbar
    Then field "mzsubm" is not modifiable in row 1
    Then pressing button "mzsubm" in row 1 throws the exception "1272"
# Für Entnahmeteile darf man das bei Dienstleistungen
    Then field "mzabsm" is modifiable in row 1
    And I modify table
      | !row | mfreig | bisuch |
      | 1    | ja     | DL     |
    And I press button "freig" to open a subeditor for "freigeben"
    And I close the current subeditor to switch back to the parent editor
    And I close the current editor

    Given I open an editor "BA_Repauftrag" from table "(Workorder):(WorkOrders)" with command "UPDATE" for record "DL000"
# 1272 de      |Funktion nicht ausführbar
    Then pressing button "mzsubm" throws the exception "1272"
    And I respond with answer "ja" to the dialog with id "345"
    And I set field "status" to "s"
    And I save the current editor

    And I switch the current editor to editor "Repauftrag" with command "UPDATE"
    And I respond with answer "ja" to the dialog with id "191"
    And I set field "mge" to "0" in row 1
    And I save the current editor


  Scenario: 16a Offene Menge in den Reservierungen werden falsch berechnet nach Aenderung des Feldes (ev)nutzen
# FDA-4106

    Given I set the fake date to "16.01.1995"
    Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
    And I append rows
      | artikel    | netmge | binoloe | mfreig | bisuch |
      | BAUGRUPPE2 | 100    | ja      | ja     | BGMGE_ |
    And I press button "freig" to open a subeditor for "fvor_freigeben"
    And I close the current subeditor to switch back to the parent editor
    And I close the current editor

# pverlust in AG1 und AG2 setzen
    Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "UPDATE" for record ""
    And I set field "artikel" to "BAUGRUPPE2"
    And I press button "ladetab"
    And I press button "absteig" to open a subeditor for "FV" in row 1
    And I set field "pverlust" to "10" in row 2
    And I set field "pverlust" to "10" in row 4
    And I save the current editor
    And I close the current editor
    And I switch the current editor to editor "fvor"
    And I save the current editor
    And I close the current editor

# Rueckmledung auf letzten AS ueber 3 Verlust
    Given I open an editor "RM_BA1" from table "(Workorder):(WorkOrders)" with command "DONE" for record "BGMGE_002"
    And I set field "mgr" to "101"
    And I set field "sofort" to "ja"
    And I set field "verlust" to "3" in row 1
    And I save the current editor

# Mengen im FV ueberpruefen
    Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "VIEW" for record ""
    And I set field "artikel" to "BAUGRUPPE2"
    And I press button "ladetab"
    Then table has values
      | mge     | netmge | limge   | netlimge | frgmge  | netfrgmge | geamge | pverlust | !row |
      | 123.457 | 100    | 120.457 | 100      | 120.457 | 100       | 0      | 19       | 1    |
    And I press button "absteig" to open a subeditor for "FV" in row 1
    Then field "netbgmge" has value "100"
    Then field "netblimge" has value "100"
    Then field "netbfrgmge" has value "100"
    Then field "bgmge" has value "123.457"
    Then field "blimge" has value "120.457"
    Then field "bfrgmge" has value "120.457"
    And I close the current subeditor to switch back to the parent editor
    And I close the current editor

# Rueckmledung auf BA ueber 8 Gut
    Given I open an editor "RM_BA2" from table "(Workorder):(WorkOrders)" with command "DONE" for record "BGMGE_000"
    And I set field "mgr" to "101"
    And I set field "sofort" to "ja"
    And I set field "gutmge" to "8" in row 1
    And I save the current editor

# Mengen im FV ueberpruefen, aendern und wieder pruefen
    Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "UPDATE" for record ""
    And I set field "artikel" to "BAUGRUPPE2"
    And I press button "ladetab"
    And I press button "absteig" to open a subeditor for "FV" in row 1
    Then field "netbgmge" has value "100"
    Then field "netblimge" has value "92"
    Then field "netbfrgmge" has value "92"
    Then field "bgmge" has value "123.457"
    Then field "blimge" has value "112.457"
    Then field "bfrgmge" has value "112.457"
# Nutzen auf 1 setzen => Mengen ändern sich dadurch nicht
    And I set field "nutzen" to "1" in row 2
    Then field "netbgmge" has value "100"
    Then field "netblimge" has value "92"
    Then field "netbfrgmge" has value "92"
    Then field "bgmge" has value "123.457"
    Then field "blimge" has value "112.457"
    Then field "bfrgmge" has value "112.457"
# Verluste auf 0 setzen => Brutto = Netto
    And I set field "pverlust" to "0" in row 2
    And I set field "pverlust" to "0" in row 4
    Then field "netbgmge" has value "100"
    Then field "netblimge" has value "92"
    Then field "netbfrgmge" has value "92"
    Then field "bgmge" has value "100"
    Then field "blimge" has value "92"
    Then field "bfrgmge" has value "92"
# Verluste wieder auf 10 setzen
    And I set field "pverlust" to "10" in row 2
    And I set field "pverlust" to "10" in row 4
    Then field "netbgmge" has value "100"
    Then field "netblimge" has value "92"
    Then field "netbfrgmge" has value "92"
    Then field "bgmge" has value "123.457"
    Then field "blimge" has value "112.457"
    Then field "bfrgmge" has value "112.457"
# limge erhöhen, sadass gesplittet wird
    And I set field "netblimge" to "102"
    Then field "splitfv" has value "ja"
    Then field "netbgmge" has value "110"
    Then field "netblimge" has value "102"
    Then field "netbfrgmge" has value "92"
    Then field "bgmge" has value "135.802"
    Then field "blimge" has value "124.802"
    Then field "bfrgmge" has value "112.457"
# nutzen setzen, Mengen prüfen
    And I set field "nutzen" to "1" in row 2
    Then field "splitfv" has value "ja"
    Then field "netbgmge" has value "110"
    Then field "netblimge" has value "102"
    Then field "netbfrgmge" has value "92"
    Then field "bgmge" has value "135.802"
    Then field "blimge" has value "124.802"
    Then field "bfrgmge" has value "112.457"
# gmge erhöhen
    And I set field "netbgmge" to "112"
    Then field "splitfv" has value "ja"
    Then field "netbgmge" has value "112"
    Then field "netblimge" has value "104"
    Then field "netbfrgmge" has value "92"
    Then field "bgmge" has value "138.272"
    Then field "blimge" has value "127.272"
    Then field "bfrgmge" has value "112.457"
# frgmge auf die limge erhöhen
    And I set field "netbfrgmge" to "104"
    Then field "splitfv" has value "nein"
    Then field "netbgmge" has value "112"
    Then field "netblimge" has value "104"
    Then field "netbfrgmge" has value "104"
    Then field "bgmge" has value "138.272"
    Then field "blimge" has value "127.272"
    Then field "bfrgmge" has value "127.272"
    And I close the current subeditor to switch back to the parent editor
    And I close the current editor

# Rueckmeldung auf letzten AS und Loeschchutz aus BA entfernen
    Given I open an editor "Rueckmeldung2_AS2" from table "(Workorder):(WorkOrders)" with command "DONE" for record "BGMGE_002"
    And I set fields
      | mgr    | 101 |
      | gut    | ja  |
      | sofort | ja  |
    And I save the current editor

    Given I open an editor "BGMGE" from table "(Workorder):(WorkOrders)" with command "UPDATE" for record "BGMGE_000"
    And I set field "noloesch" to "nein"
    And I save the current editor


  Scenario: 17 Materialentnahme ueber Feld select, ID der Reservierung passt nicht zum angegebenen Arbeitsschein

# Fertigungsvorschlag anlegen
    Given I open an editor "FV5" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
    And I append rows
      | artikel      | netmge | bisuch | mfreig |
      | M_BAUGRUPPE2 | 50     | FV14_  | ja     |
    And I press button "freig" to open a subeditor for "BA_freigeben"
    And I close the current subeditor to switch back to the parent editor
    And I close the current editor

# ID aus der Zeile der AFL holen
    Given I open an editor "BA" from table "(Workorder):(WorkOrders)" with command "VIEW" for record "FV14_000"
    And I press button "absteig" to open a subeditor for "AFL"
    And I save value from field "id" in row 1
    And I close the current subeditor to switch back to the parent editor
    And I close the current editor

    Given I open an editor "Arbeitsschein2" from table "(Workorder):(WorkOrders)" with command "VIEW" for record "FV14_002"
    And I close the current editor
# Materialentnahme ueber select, kein Selektionsergebnis, wenn ID der Reservierung nicht zum Arbeitsschein passt
    Given I open an editor "MatEnt" for tip command "Fbuchung" and arguments ""
    And I set field "auftrag" to "!Arbeitsschein2^nummer"
# neuer individueller Step -> set field "select" to "id==saved value"
    And I select material reservation by "id" and "saved value"
    And I press button "selekt"
    Then the table has 0 rows
    And I close the current editor

# wenn die ID der Reservierung zum Arbeitsschein passt, wird die Selektion korrekt ausgefuehrt
    Given I open an editor "Arbeitsschein1" from table "(Workorder):(WorkOrders)" with command "VIEW" for record "FV14_001"
    And I close the current editor
# Materialentnahme ueber select, mit ID der Reservierung
    Given I open an editor "MatEnt" for tip command "Fbuchung" and arguments ""
    And I set field "auftrag" to "!Arbeitsschein1^nummer"
# neuer individueller Step -> set field "select" to "id==saved value"
    And I select material reservation by "id" and "saved value"
    And I press button "selekt"
    Then the table has 1 rows
    Then table has values
      | elex      | bumge |
      | EINKAUF-1 | 100   |
    And I close the current editor


  Scenario: 18 Einkaufsbestellung mit Beistellteilen, AFL anzahl 0, Konto pruefen

    Given I open an editor "KT-BEISTELL" from table "(Part):(Product)" with command "STORE" for record "KT-BEISTELL"
    And I set fields
      | such     | KT-BEISTELL              |
      | namebspr | Kaufteil mit Beistellung |
      | bsart    | Fremdbeschaffung         |
    And I delete all rows
    And I append rows
      | elex | elanzahl | bua                    |
      | EINK | 0        | Lieferantenbeistellung |
    And I save the current editor

    Given I open an editor "Warengruppe" from table "(Company):(MaterialGroup)" with command "VIEW" for record "WG-RHB"
    And I close the current editor

    Given I open an editor "BE-18" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
    And I set fields
      | lief   | KETTLER |
      | such   | BE-18   |
      | ebeleg | BE-18   |
      | tterm  | .       |
      | budat  | .       |
    And I append rows
      | artikel     | mge |
      | KT-BEISTELL | 1   |
    And I press button "absteig" to open a subeditor for "AFL" in row 1
    Then the table has 1 rows
    And I close the current subeditor to switch back to the parent editor
#Then table has values
#    | lbeist        | konto                     |
#    | nein          | !Warengruppe^bestausekso  |
    Then field "lbeist" has value "nein" in row 1
    Then field "konto" in row 1 has value equal to field "bestausekso" from editor "Warengruppe" in row 0
    And I save the current editor


  Scenario: 18a Einkaufsbestellung mit Beistellteilen, AFL anzahl 0, nachtraeglich Menge eintragen, Konto pruefen

    Given I open an editor "Warengruppe" from table "(Company):(MaterialGroup)" with command "VIEW" for record "WG-RHB"
    And I close the current editor

    Given I open an editor "BE-18" from table "(Purchasing):(PurchaseOrder)" with command "UPDATE" for record "BE-18"
    And I press button "absteig" to open a subeditor for "AFL" in row 1
    And I set field "anzahl" to "1" in row 1
    And I save the current subeditor to switch back to the parent editor
#Then table has values
#    | lbeist        | konto                     |
#    | ja            | !Warengruppe^bvaussozug   |
    Then field "lbeist" has value "ja" in row 1
    Then field "konto" in row 1 has value equal to field "bvaussozug" from editor "Warengruppe" in row 0
    And I save the current editor


  Scenario: 18b Einkaufsbestellung mit Beistellteilen, AFL anzahl 0, nachtraeglich amge eintragen, Konto pruefen

    Given I open an editor "Warengruppe" from table "(Company):(MaterialGroup)" with command "VIEW" for record "WG-RHB"
    And I close the current editor

    Given I open an editor "BE-18B" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
    And I set fields
      | lief   | KETTLER |
      | such   | BE-18B  |
      | ebeleg | BE-18B  |
      | tterm  | .       |
      | budat  | .       |
    And I append rows
      | artikel     | mge |
      | KT-BEISTELL | 1   |
    And I press button "absteig" to open a subeditor for "AFL" in row 1
    Then the table has 1 rows
    Then field "anzahl" has value "0" in row 1
    And I close the current subeditor to switch back to the parent editor
#Then table has values
#    | lbeist        | konto                     |
#    | nein          | !Warengruppe^bestausekso  |
    Then field "lbeist" has value "nein" in row 1
    Then field "konto" in row 1 has value equal to field "bestausekso" from editor "Warengruppe" in row 0
    And I save the current editor

    Given I open an editor "BE-18B" from table "(Purchasing):(PurchaseOrder)" with command "UPDATE" for record "BE-18B"
    And I press button "absteig" to open a subeditor for "AFL" in row 1
    And I set field "amge" to "1" in row 1
    And I save the current subeditor to switch back to the parent editor
#Then table has values
#    | lbeist        | konto                     |
#    | ja            | !Warengruppe^bvaussozug   |
    Then field "lbeist" has value "ja" in row 1
    Then field "konto" in row 1 has value equal to field "bvaussozug" from editor "Warengruppe" in row 0
    And I save the current editor


  Scenario: 19 Einkaufsbestellung mit Beistellteilen, AFL anzahl 1 und Filter NIE, Konto pruefen

    Given I open an editor "KT-BEISTELL_NIE" from table "(Part):(Product)" with command "STORE" for record "KT-BEISTELL_NIE"
    And I set fields
      | such     | KT-BEISTELL_NIE          |
      | namebspr | Kaufteil mit Beistellung |
      | bsart    | Fremdbeschaffung         |
    And I delete all rows
    And I append rows
      | elex | elanzahl | bua                    | filter |
      | EINK | 1        | Lieferantenbeistellung | NIE    |
    And I save the current editor

    Given I open an editor "Warengruppe" from table "(Company):(MaterialGroup)" with command "VIEW" for record "WG-RHB"
    And I close the current editor

    Given I open an editor "BE-19" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
    And I set fields
      | lief   | KETTLER |
      | such   | BE-19   |
      | ebeleg | BE-19   |
      | tterm  | .       |
      | budat  | .       |
    And I append rows
      | artikel         | mge |
      | KT-BEISTELL_NIE | 1   |
    And I press button "absteig" to open a subeditor for "AFL" in row 1
    Then the table has 1 rows
    And I close the current subeditor to switch back to the parent editor
#Then table has values
#    | lbeist        | konto                     |
#    | nein          | !Warengruppe^bestausekso  |
    Then field "lbeist" has value "nein" in row 1
    Then field "konto" in row 1 has value equal to field "bestausekso" from editor "Warengruppe" in row 0
    And I save the current editor


  Scenario: 19a Einkaufsbestellung mit Beistellteilen, AFL anzahl 1 und Filter NIE, nachtraeglich relevant auf ja, Konto pruefen

    Given I open an editor "Warengruppe" from table "(Company):(MaterialGroup)" with command "VIEW" for record "WG-RHB"
    And I close the current editor

    Given I open an editor "BE-19" from table "(Purchasing):(PurchaseOrder)" with command "UPDATE" for record "BE-19"
    And I press button "absteig" to open a subeditor for "AFL" in row 1
    And I set field "relevant" to "ja" in row 1
    And I save the current subeditor to switch back to the parent editor
#Then table has values
#    | lbeist        | konto                     |
#    | ja            | !Warengruppe^bvaussozug   |
    Then field "lbeist" has value "ja" in row 1
    Then field "konto" in row 1 has value equal to field "bvaussozug" from editor "Warengruppe" in row 0
    And I save the current editor


  Scenario: 20 Einkaufsbestellung mit Beistellteilen, AFL anzahl 1, nachtraeglich auf 0 Konto pruefen

    Given I open an editor "KT-BEISTELL_A1" from table "(Part):(Product)" with command "STORE" for record "KT-BEISTELL_A1"
    And I set fields
      | such     | KT-BEISTELL_A1           |
      | namebspr | Kaufteil mit Beistellung |
      | bsart    | Fremdbeschaffung         |
    And I delete all rows
    And I append rows
      | elex | elanzahl | bua                    |
      | EINK | 1        | Lieferantenbeistellung |
    And I save the current editor

    Given I open an editor "Warengruppe" from table "(Company):(MaterialGroup)" with command "VIEW" for record "WG-RHB"
    And I close the current editor

    Given I open an editor "BE-20" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
    And I set fields
      | lief   | KETTLER |
      | such   | BE-20   |
      | ebeleg | BE-20   |
      | tterm  | .       |
      | budat  | .       |
    And I append rows
      | artikel        | mge |
      | KT-BEISTELL_A1 | 1   |
#Then table has values
#    | lbeist        | konto                     |
#    | ja            | !Warengruppe^bvaussozug   |
    Then field "lbeist" has value "ja" in row 1
    Then field "konto" in row 1 has value equal to field "bvaussozug" from editor "Warengruppe" in row 0
    And I save the current editor

    Given I open an editor "BE-20" from table "(Purchasing):(PurchaseOrder)" with command "UPDATE" for record "BE-20"
    And I press button "absteig" to open a subeditor for "AFL" in row 1
    And I set field "anzahl" to "0" in row 1
    And I save the current subeditor to switch back to the parent editor
#Then table has values
#    | lbeist        | konto                     |
#    | nein          | !Warengruppe^bestausekso  |
    Then field "lbeist" has value "nein" in row 1
    Then field "konto" in row 1 has value equal to field "bestausekso" from editor "Warengruppe" in row 0
    And I save the current editor


  Scenario: 21 Einkaufsbestellung mit Beistellteilen, AFL mehrere Beistellungen, Konto pruefen

    Given I open an editor "KT-BEISTELL_3" from table "(Part):(Product)" with command "STORE" for record "KT-BEISTELL_3"
    And I set fields
      | such     | KT-BEISTELL_3                |
      | namebspr | Kaufteil mit 3 Beistellungen |
      | bsart    | Fremdbeschaffung             |
    And I delete all rows
    And I append rows
      | elex | elanzahl | bua                    | filter |
      | EINK | 1        | Lieferantenbeistellung | NIE    |
      | BAUT | 0        | Lieferantenbeistellung |        |
      | E3   | 1        | Lieferantenbeistellung |        |
    And I save the current editor

    Given I open an editor "Warengruppe" from table "(Company):(MaterialGroup)" with command "VIEW" for record "WG-RHB"
    And I close the current editor

    Given I open an editor "BE-21" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
    And I set fields
      | lief   | KETTLER |
      | such   | BE-21   |
      | ebeleg | BE-21   |
      | tterm  | .       |
      | budat  | .       |
    And I append rows
      | artikel       | mge |
      | KT-BEISTELL_3 | 1   |
    And I press button "absteig" to open a subeditor for "AFL" in row 1
    Then the table has 3 rows
    And I close the current subeditor to switch back to the parent editor
#Then table has values
#    | lbeist        | konto                     |
#    | ja            | !Warengruppe^bvaussozug  |
    Then field "lbeist" has value "ja" in row 1
    Then field "konto" in row 1 has value equal to field "bvaussozug" from editor "Warengruppe" in row 0
    And I save the current editor

    Given I open an editor "BE-21" from table "(Purchasing):(PurchaseOrder)" with command "UPDATE" for record "BE-21"
    And I press button "absteig" to open a subeditor for "AFL" in row 1
    Then field "elex" has value "E3" in row 3
    And I set field "anzahl" to "0" in row 3
    And I save the current subeditor to switch back to the parent editor
#Then table has values
#    | lbeist        | konto                     |
#    | nein          | !Warengruppe^bestausekso  |
    Then field "lbeist" has value "nein" in row 1
    Then field "konto" in row 1 has value equal to field "bestausekso" from editor "Warengruppe" in row 0
    And I save the current editor


  Scenario: 22 Eine Rückmeldung auf den letzten AS kann nicht erfasst werden, wenn auf den BA eine ungebuchte RM hängt und vv. ZBUCH geht.

    Given I set the fake date to "17.01.1995"
# FV anlegen und freigeben
    Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
    And I append rows
      | artikel     | netmge | mfreig | bisuch  |
      | B_BAUGRUPPE | 10     | ja     | OPENRM_ |
    And I press button "freig" to open a subeditor for "BA_freigeben"
    And I close the current editor
    And I switch the current editor to editor "fvor"
    And I save the current editor

# Rückmeldung auf letzten AS ohne buchen speichern
    Given I open an editor "RM_AS_SAVE" from table "(Workorder):(WorkOrders)" with command "DONE" for record "OPENRM_001"
    And I set field "gutmge" to "1" in row 1
    And I save the current editor

# Rückmeldung auf BA erfassen
    Then opening an editor from table "(Workorder):(WorkOrders)" with command "DONE" for record "OPENRM_000" throws the exception "253"

# Zeitbuchung auf BA ist möglich
    Given I open an editor "Zeitbuchung_BA" for tip command "Zeitbuchung" and arguments ""
    And I set field "barmex" to "OPENRM_000"
    And I set field "mgr" to "101"
    And I set field "lgr" to "1"
    And I set field "bzeit" to "1"
    And I set field "mzeit" to "2"
    And I save the current editor

# Rückmeldung auf letzten AS buchen
    Given I open an editor "RM_AS_TRANS" from table "(Workorder):(WorkOrders)" with command "TRANSFER" for record "OPENRM_001"
    And I save the current editor

# Rückmeldung auf Betriebsauftrag ohne buchen speichern
    Given I open an editor "RM_BA_SAVE" from table "(Workorder):(WorkOrders)" with command "DONE" for record "OPENRM_000"
    And I set field "mgr" to "101"
    And I set field "gutmge" to "1" in row 1
    And I save the current editor

# Rückmeldung auf letzten AS erfassen
    Then opening an editor from table "(Workorder):(WorkOrders)" with command "DONE" for record "OPENRM_001" throws the exception "253"

# Zeitbuchung auf BA ist möglich
    Given I open an editor "Zeitbuchung_AS" for tip command "Zeitbuchung" and arguments ""
    And I set field "barmex" to "OPENRM_001"
    And I set field "lgr" to "1"
    And I set field "bzeit" to "2"
    And I set field "mzeit" to "1"
    And I save the current editor

# Rückmeldung auf BA buchen
    Given I open an editor "RM_BA_TRANS" from table "(Workorder):(WorkOrders)" with command "TRANSFER" for record "OPENRM_000"
    And I save the current editor

# BA abschliessen
    Given I open an editor "RM_BA" from table "(Workorder):(WorkOrders)" with command "DONE" for record "OPENRM_000"
    And I set field "mgr" to "101"
    And I set field "gut" to "ja"
    And I set field "sofort" to "ja"
    And I save the current editor

  Scenario: 23 In der AFL einer Lohnfertigung sind nur Teile und Fertigungsmittel erlaubt
# UA-2500: Diag, wenn man in einer AFL in eine Lohnfertigung einen AG eintragen will

    Given I set the fake date to "18.01.1995"
    Given I open an editor "fvor_new" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
    And I append rows
      | artikel    | netmge | verw       |
      | BAUGRUPPE2 | 100    | Lohnf_test |
    And I press button "absteig" to open a subeditor for "afl" in row 1
    And I create a new row at the end of the table
    And I set field "elex" to "LOHN" in row !lastRow
    And I set field "elanzahl" to "1" in row !lastRow
    And I save the current editor
    And I switch the current editor to editor "fvor_new"
    And I save the current editor

# Disposition starten
    And I run Scheduling

# AG in AFL der Lohnfertigung eintragen => Fehlermeldung. Material und Fertigungsmittel sind erlaubt.
    Given I open an editor "fvor_upd" from table "(Purchasing):(WorkOrderSuggestion)" with command "UPDATE" for search criteria "$,,artikel==BAUGRUPPE2;verw==Lohnf_test;@richtung=rückwärts;@maxordtreffer=1"
    And I press button "absteig" to open a subeditor for "fvor_ab"
    And I descend to a lower level of the BOM in row !lastRow
    And I create a new row at position 1
    Then setting field "elex" to "A AG1" in row 1 throws the exception "1331"
    And I append rows
      | elex  |
      | E3    |
      | TESTF |
    And I save the current editor
    And I switch the current editor to editor "fvor_upd"
    And I save the current editor

# prüfen, ob Fertigungsmittel und Material eingetragen wurden.
    Given I open an editor "fvor_upd" from table "(Purchasing):(WorkOrderSuggestion)" with command "VIEW" for search criteria "$,,artikel==BAUGRUPPE2;verw==Lohnf_test;@richtung=rückwärts;@maxordtreffer=1"
    And I press button "absteig" to open a subeditor for "fvor_ab"
    And I descend to a lower level of the BOM in row !lastRow
    Then table has values
      | elex  |
      | E3    |
      | TESTF |
    And I close the current editor
    And I switch the current editor to editor "fvor_upd"
    And I close the current editor

# FV stornieren.
    Given I open an editor "fvor_upd" from table "(Purchasing):(WorkOrderSuggestion)" with command "UPDATE" for search criteria "$,,artikel==BAUGRUPPE2;verw==Lohnf_test;@richtung=rückwärts;@maxordtreffer=1"
    And I set field "mge" to "0"
    And I save the current editor


  Scenario: 24 Kein Hinweis "Keine zu buchende Materialentnahme bzw. Mengenänderung angegeben", wenn alle zu buchenden Mengen auf 0 gesetzt wurden und "Restmenge stornieren" gedrückt wurde
#  ABS-12789: Setzen neuer Rest auf 0 mit Restmenge stornieren in FBU

# Fertigungsvorschlag anlegen
    Given I open an editor "FV24" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
    And I append rows
      | artikel      | netmge | bisuch | binoloe | mfreig |
      | M_BAUGRUPPE2 | 1      | FV24_  | nein    | ja     |
    And I press button "freig" to open a subeditor for "BA_freigeben"
    And I close the current subeditor to switch back to the parent editor
    And I close the current editor

# Materialrückgabe auf AS1 buchen
    Given I open an editor "MatEnt1" for tip command "Fbuchung" and arguments ""
    And I set field "auftrag" to "FV24_001"
    And I press button "stlvblad"
    And I save the current editor

# Keine Materialrückgabe auf AS2 buchen, Neuer Rest per Button "stornorest" auf 0 setzen -> Kein Hinweis beim Speichern
    Given I open an editor "MatEnt2" for tip command "Fbuchung" and arguments ""
    And I set field "auftrag" to "FV24_002"
    And I press button "stlvblad"
    And I set field "bumge" to "0" in row 1
    And I press button "stornorest"
    And I save the current editor

# Rückmeldung auf letzten Arbeitsschein buchen, FV wird abgeschlossen
    Given I open an editor "Rückmeldung1" from table "(Workorder):(WorkOrders)" with command "DONE" for search criteria "$,,such=FV24_002;@richtung=rückwärts;@maxordtreffer=1"
    And I set field "gut" to "ja"
    And I set field "sofort" to "ja"
    And I save the current editor

