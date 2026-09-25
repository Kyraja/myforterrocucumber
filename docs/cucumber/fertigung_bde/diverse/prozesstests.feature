@persistent
Feature: prozesstests.feature

  Background:
    And I set the fake date to "03.02.1995"

# *****************************************************************************
#  Name             : prozesstests
#  Autor            : lschneider
#  Verantwortlich   : drpf
#  Kontrolle        : amk
#  Funktion         : Testet Prozesse in der Fertigung
#  Jira-Issue       : FDA-669
# *****************************************************************************



# Artikel anlegen für Scenario 15ff

  Scenario Outline: Einkaufsartikel (Auslauf und Nachfolger)
    Given I open an editor "<such>" from table "(Part):(Product)" with command "STORE" for record "<such>"
    And I set fields
      | such             | <such>             |
      | namebspr         | <namebspr>         |
      | dispoa           | <dispoa>           |
      | lief             | KETTLER            |
      | efrist           | 2                  |
      | epr              | <epr>              |
      | zuplatz          | <zuplatz>          |
      | wgruppe          | 55                 |
      | erlgrp           | 66                 |
      | nachfolgeartikel | <nachfolgeartikel> |
      | lbsdatum         | <lbsdatum>         |
      | lverwdatum       | <lverwdatum>       |
      | vgltermin        | <vgltermin>        |
    And I save the current editor
    Examples:
      | such            | namebspr                        | dispoa         | epr  | zuplatz     | nachfolgeartikel | lbsdatum    | lverwdatum  | vgltermin     |
      | EK-1-NACHFOLGER | Einkaufsteil 1 Nachfolgeartikel | bedarfsbezogen | 5    | !dontChange | !dontChange      | !dontChange | !dontChange | !dontChange   |
      | EK-1-AUSLAUF    | Einkaufsteil 1 Auslaufartikel   | bedarfsbezogen | 4,50 | !dontChange | EK-1-NACHFOLGER  | -100        | +100        | Anfangstermin |
      | EK_NACH_1       | EK-Teil Nachfolgeartikel 1      | bedarfsbezogen | 5    | !dontChange | !dontChange      | !dontChange | !dontChange | !dontChange   |
      | EK_AUSLAUF_1    | EK-Teil Auslaufartikel 1        | bedarfsbezogen | 4,50 | !dontChange | EK_NACH_1        | -100        | +100        | Anfangstermin |
      | EK_NACH_2       | EK-Teil Nachfolgeartikel 2      | bedarfsbezogen | 5    | !dontChange | !dontChange      | !dontChange | !dontChange | !dontChange   |
      | EK_AUSLAUF_2    | EK-Teil Auslaufartikel 2        | bedarfsbezogen | 4,50 | !dontChange | EK_NACH_2        | -100        | +100        | Anfangstermin |


  Scenario: 01 Rückmeldung auf abgelegten FV mit zusätzlicher Gutmenge
# Bestand korrigieren, Auftrag anlegen, Bedarfe einkaufen
    Given I set StorageQuantity to zero for Product "BAUGRUPPE" on StorageLocation "F1"
    Given I create a SalesOrder "auftrag" for Customer "RADSHOP" with Product "BAUGRUPPE" and quantity "10"

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
      | EINKAUF-1 | 20  |
      | EINKAUF-2 | 10  |
    And I set field "verw" in row 1 to "verw" from editor "auftrag" in row 1
    And I set field "verw" in row 2 to "verw" from editor "auftrag" in row 1
    And I respond with answer "ja" to the dialog with id "4841"
    And I save the current editor

# Fertigungsvorschlag anlegen und freigeben
    Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
    And I append rows
      | artikel   | netmge | bisuch  | mfreig |
      | BAUGRUPPE | 10     | ZUSATZ_ | ja     |
    And I set field "verw" in row !lastRow to "verw" from editor "auftrag" in row 1
    And I press button "freig" to open a subeditor for "BA_freigeben"
    And I close the current editor
    And I switch the current editor to editor "fvor"
    And I save the current editor

# Komplettrückmeldung auf ersten Arbeitsgang
    Given I open an editor "Rückmeldung1" from table "(Workorder):(WorkOrders)" with command "DONE" for record "ZUSATZ_001"
    And I set fields
      | sofort | 1 |
      | gut    | 1 |
    And I save the current editor

# Zusätzliche Gutmnege melden
    Given I open an editor "Rückmeldung2" via ID from editor "Rückmeldung1" from field "id" in row 0 for table "(Workorder):(CompletionConfirmations)" with command "COPY"
    And I set field "gutmge" to "5" in row 1
    And I save the current editor

# LJ und Bestand prüfen
    Given I open the infosystem "LJ"
    And I set field "beleg" to "nummer" from editor "Rückmeldung1"
    And I set field "richtung" to "rückwärts"
    And I press start
    Then table has values
      | art       | zmge | amge |
      | BAUGRUPPE | 5    |      |
      | BAUGRUPPE | 10   |      |
      | EINKAUF-1 |      | 20   |
      | EINKAUF-2 |      | 10   |
    And I close the current editor

    Given I open the infosystem "BESTAND"
    And I set fields
      | artikel    | BAUGRUPPE |
      | verdichten | nein      |
      | details    | nein      |
    And I press start
    Then field "lemge" has value "15" in row 1
    And I press button "taufzu" in row 1
    Then table has values
      | gebmge | kopfzugvorg^id   |
      |        | (0,0,0)          |
      | 10     | !Rückmeldung1^id |
      | 5      | !Rückmeldung2^id |
    And I close the current editor

# Auftrag liefern
    Given I switch the current editor to editor "auftrag" with command "DELIVERY"
    And I set fields
      | vom | .  |
      | ueb | ja |
    And I set field "mge" to "15" in row 1
    And I save the current editor


  Scenario: 02 Rückmelung auf letzten AS eines abgelegten FV mit zusätzlicher Gutmenge
# Bestand korrigieren, Auftrag anlegen, Bedarfe einkaufen
    Given I set StorageQuantity to zero for Product "BAUGRUPPE2" on StorageLocation "F1"
    Given I create a SalesOrder "auftrag" for Customer "RADSHOP" with Product "BAUGRUPPE2" and quantity "10"

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
      | EINKAUF-1 | 20  |
      | EINKAUF-2 | 10  |
    And I set field "verw" in row 1 to "verw" from editor "auftrag" in row 1
    And I set field "verw" in row 2 to "verw" from editor "auftrag" in row 1
    And I respond with answer "ja" to the dialog with id "4841"
    And I save the current editor

# Fertigungsvorschlag anlegen und freigeben
    Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
    And I append rows
      | artikel    | netmge | bisuch  | mfreig |
      | BAUGRUPPE2 | 10     | LETZTE_ | ja     |
    And I set field "verw" in row !lastRow to "verw" from editor "auftrag" in row 1
    And I press button "freig" to open a subeditor for "BA_freigeben"
    And I close the current editor
    And I switch the current editor to editor "fvor"
    And I save the current editor

# Komplettrückmeldung auf Arbeitsgänge
    Given I open an editor "Rückmeldung1" from table "(Workorder):(WorkOrders)" with command "DONE" for record "LETZTE_001"
    And I set fields
      | sofort | 1 |
      | gut    | 1 |
    And I save the current editor

    Given I open an editor "Rückmeldung2" from table "(Workorder):(WorkOrders)" with command "DONE" for record "LETZTE_002"
    And I set fields
      | sofort | 1 |
      | gut    | 1 |
    And I save the current editor

# Zusätzliche Gutmnege melden
    Given I open an editor "Rückmeldung3" via ID from editor "Rückmeldung2" from field "id" in row 0 for table "(Workorder):(CompletionConfirmations)" with command "COPY"
    And I set field "gutmge" to "5" in row 1
    And I save the current editor

# LJ und Bestand prüfen
    Given I open the infosystem "LJ"
    And I set field "beleg" to "nummer" from editor "Rückmeldung2"
    And I set field "richtung" to "rückwärts"
    And I press start
    Then table has values
      | art        | zmge | amge |
      | BAUGRUPPE2 | 5    |      |
      | BAUGRUPPE2 | 10   |      |
      | EINKAUF-2  |      | 10   |
    And I close the current editor

    Given I open the infosystem "BESTAND"
    And I set fields
      | artikel    | BAUGRUPPE2 |
      | verdichten | nein       |
      | details    | nein       |
    And I press start
    Then field "lemge" has value "15" in row 1
    And I press button "taufzu" in row 1
    Then table has values
      | gebmge | kopfzugvorg^id   |
      |        | (0,0,0)          |
      | 10     | !Rückmeldung2^id |
      | 5      | !Rückmeldung3^id |
    And I close the current editor

# Auftrag liefern
    Given I switch the current editor to editor "auftrag" with command "DELIVERY"
    And I set fields
      | vom | .  |
      | ueb | ja |
    And I set field "mge" to "15" in row 1
    And I save the current editor


  Scenario: 03 Rückmeldung auf abgelegten FV mit zusätzlicher Gutmenge in Behälter
# Bestand korrigieren, Auftrag anlegen, Bedarfe einkaufen, Behälter anlegen
    Given I set StorageQuantity to zero for Product "BG-BEHAELTER" on StorageLocation "F1"
    Given I create a SalesOrder "auftrag" for Customer "RADSHOP" with Product "BG-BEHAELTER" and quantity "20"

    Given I open an editor "Lieferung" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
    And I set fields
      | lief   | KETTLER  |
      | fakt   | ja       |
      | vom    | .        |
      | ebeleg | Rechnung |
      | ueb    | ja       |
      | budat  | .        |
    And I append rows
      | artikel    | mge |
      | EINKAUF-1  | 40  |
      | EINKAUF-2  | 20  |
      | BEHAELTER  | 4   |
      | EU-PALETTE | 1   |
    And I set field "verw" in row 1 to "verw" from editor "auftrag" in row 1
    And I set field "verw" in row 2 to "verw" from editor "auftrag" in row 1
    And I respond with answer "ja" to the dialog with id "4841"
    And I save the current editor

    Given I create a Container "BEHAELTER1" for packaging material "BEHAELTER"
    Given I create a Container "BEHAELTER2" for packaging material "BEHAELTER"

# Fertigungsvorschlag anlegen und freigeben
    Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
    And I append rows
      | artikel      | netmge | bisuch     | mfreig |
      | BG-BEHAELTER | 10     | BEHAELTER_ | ja     |
    And I set field "verw" in row !lastRow to "verw" from editor "auftrag" in row 1
    And I press button "freig" to open a subeditor for "BA_freigeben"
    And I close the current editor
    And I switch the current editor to editor "fvor"
    And I save the current editor

# Komplettrückmeldung auf ersten Arbeitsgang
    Given I open an editor "Rückmeldung1" from table "(Workorder):(WorkOrders)" with command "DONE" for record "BEHAELTER_001"
    And I set fields
      | sofort    | 1           |
      | gut       | 1           |
      | manrest   | ja          |
      | behaelter | !BEHAELTER1 |
    And I save the current editor

# Zusätzliche Gutmnege in gefüllten Behälter melden, Behälter prüfen
    Given I open an editor "Rückmeldung2" via ID from editor "Rückmeldung1" from field "id" in row 0 for table "(Workorder):(CompletionConfirmations)" with command "COPY"
    And I set field "behaelter" to id from editor "BEHAELTER1"
    And I set field "gutmge" to "5" in row 1
    And I save the current editor
    Then field "mge" from editor "BEHAELTER1" in row 1 has value "15"

# Zusätzliche Gutmnege in leeren Behälter melden, Behälter prüfen
    Given I open an editor "Rückmeldung3" via ID from editor "Rückmeldung1" from field "id" in row 0 for table "(Workorder):(CompletionConfirmations)" with command "COPY"
    And I set field "behaelter" to id from editor "BEHAELTER2"
    And I set field "gutmge" to "5" in row 1
    And I save the current editor
    Then field "mge" from editor "BEHAELTER2" in row 1 has value "5"

# LJ und Bestand prüfen
    Given I open the infosystem "LJ"
    And I set field "beleg" to "nummer" from editor "Rückmeldung1"
    And I set field "richtung" to "rückwärts"
    And I press start
    Then table has values
      | art          | zmge | amge | behaelter^id   |
      | BG-BEHAELTER | 5    |      | !BEHAELTER2^id |
      | BG-BEHAELTER | 5    |      | !BEHAELTER1^id |
      | BG-BEHAELTER | 10   |      | !BEHAELTER1^id |
      | EINKAUF-1    |      | 20   | (0,0,0)        |
      | EINKAUF-2    |      | 10   | (0,0,0)        |
    And I close the current editor

    Given I open the infosystem "BESTAND"
    And I set fields
      | artikel    | BG-BEHAELTER |
      | verdichten | nein         |
      | details    | nein         |
    And I press start
    Then field "lemge" has value "20" in row 1
    And I press button "taufzu" in row 1
    Then table has values
      | gebmge | kopfzugvorg^id   |
      |        | (0,0,0)          |
      | 10     | !Rückmeldung1^id |
      | 5      | !Rückmeldung2^id |
      | 5      | !Rückmeldung3^id |
    And I close the current editor

# Auftrag liefern
    And I run Scheduling
    Given I switch the current editor to editor "auftrag" with command "DELIVERY"
    And I set fields
      | vom | .  |
      | ueb | ja |
    And I set field "mge" to "20" in row 1
    And I press button "mzsubm" to open a subeditor for "MZ" in row 1
    And I modify table
      | !row | zuomge | behaelter   |
      | 1    | 15     | !BEHAELTER1 |
      | +2   | 5      | !BEHAELTER2 |
    And I save the current editor
    And I switch the current editor to editor "auftrag"
    And I save the current editor


  Scenario: 04 Rückmeldung von Gutmenge auf abgelegten FV mit Charge
# Chargen anlegen
    Given I create a Lot "CH_BG1" for Product "BAUGRUPPE"
    Given I create a Lot "CH_BG2" for Product "BAUGRUPPE"
    Given I create a Lot "CH_BG3" for Product "BAUGRUPPE"

# Bestand korrigieren, Auftrag anlegen, Bedarfe einkaufen, Behälter anlegen
    Given I set StorageQuantity to zero for Product "BAUGRUPPE" on StorageLocation "F1"
    Given I create a SalesOrder "auftrag" for Customer "RADSHOP" with Product "BAUGRUPPE" and quantity "10"

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
      | EINKAUF-1 | 20  |
      | EINKAUF-2 | 10  |
    And I set field "verw" in row 1 to "verw" from editor "auftrag" in row 1
    And I set field "verw" in row 2 to "verw" from editor "auftrag" in row 1
    And I respond with answer "ja" to the dialog with id "4841"
    And I save the current editor

# Fertigungsvorschlag anlegen und freigeben
    Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
    And I append rows
      | artikel   | netmge | mfreig |
      | BAUGRUPPE | 10     | ja     |
    And I set field "verw" in row !lastRow to "verw" from editor "auftrag" in row 1
    And I press button "mzsubm" to open a subeditor for "MZ" in row !lastRow
    And I modify table
      | !row | zuomge | charge     |
      | +1   | 5      | !CH_BG1^id |
      | +2   | 5      | !CH_BG2^id |
    And I save the current editor
    And I switch the current editor to editor "fvor"
    And I set field "bisuch" to "CHARGE_" in row !lastRow
    And I press button "freig" to open a subeditor for "BA_freigeben"
    And I close the current editor
    And I switch the current editor to editor "fvor"
    And I save the current editor

# Komplettrückmeldung auf ersten Arbeitsgang
    Given I open an editor "Rückmeldung1" from table "(Workorder):(WorkOrders)" with command "DONE" for record "CHARGE_001"
    And I set fields
      | sofort | 1 |
      | gut    | 1 |
    And I save the current editor

# Zusätzliche Gutmnege in gefüllten Behälter melden, gebuchte Charge
    Given I open an editor "Rückmeldung2" via ID from editor "Rückmeldung1" from field "id" in row 0 for table "(Workorder):(CompletionConfirmations)" with command "COPY"
    And I set field "kcharge" to "!CH_BG1^id"
    And I set field "gutmge" to "5" in row 1
    And I save the current editor

# Zusätzliche Gutmnege in leeren Behälter melden, neue Charge
    Given I open an editor "Rückmeldung3" via ID from editor "Rückmeldung1" from field "id" in row 0 for table "(Workorder):(CompletionConfirmations)" with command "COPY"
    And I set field "kcharge" to "!CH_BG3^id"
    And I set field "gutmge" to "5" in row 1
    And I save the current editor

# LJ und Bestand prüfen
    Given I open the infosystem "LJ"
    And I set field "beleg" to "nummer" from editor "Rückmeldung1"
    And I set field "richtung" to "rückwärts"
    And I press start
    Then table has values
      | art       | zmge | amge | ncharge^such |
      | BAUGRUPPE | 5    |      | CH_BG3       |
      | BAUGRUPPE | 5    |      | CH_BG1       |
      | BAUGRUPPE | 5    |      | CH_BG2       |
      | BAUGRUPPE | 5    |      | CH_BG1       |
      | EINKAUF-1 |      | 10   | CH_BG2       |
      | EINKAUF-1 |      | 10   | CH_BG1       |
      | EINKAUF-2 |      | 5    | CH_BG2       |
      | EINKAUF-2 |      | 5    | CH_BG1       |
    And I close the current editor

    Given I open the infosystem "BESTAND"
    And I set fields
      | artikel    | BAUGRUPPE |
      | verdichten | nein      |
      | details    | nein      |
    And I press start
    Then field "lemge" has value "20" in row 1
    And I press button "taufzu" in row 1
    Then table has values
      | gebmge | charge^such | kopfzugvorg^id   |
      |        |             | (0,0,0)          |
      | 5      | CH_BG1      | !Rückmeldung1^id |
      | 5      | CH_BG2      | !Rückmeldung1^id |
      | 5      | CH_BG1      | !Rückmeldung2^id |
      | 5      | CH_BG3      | !Rückmeldung3^id |
    And I close the current editor

# Auftrag liefern
    Given I switch the current editor to editor "auftrag" with command "DELIVERY"
    And I set fields
      | vom | .  |
      | ueb | ja |
    And I set field "mge" to "20" in row 1
    And I press button "mzsubm" to open a subeditor for "MZ" in row 1
    And I modify table
      | !row | zuomge | charge     |
      | 1    | 10     | !CH_BG1^id |
      | +2   | 5      | !CH_BG2^id |
      | +3   | 5      | !CH_BG3^id |
    And I save the current editor
    And I switch the current editor to editor "auftrag"
    And I save the current editor


  Scenario: 05 Rückmeldung von Gutmenge auf abgelegten FV mit Projekt
# Projekt erstellen
    Given I open an editor "PROJEKT_A05" from table "(Transaction):(Project)" with command "STORE" for record "PROJEKT_A05"
    And I set fields
      | such | PROJEKT_A05 |
    And I save the current editor

# Bestand korrigieren, Auftrag anlegen, Bedarfe einkaufen
    Given I set StorageQuantity to zero for Product "BAUGRUPPE" on StorageLocation "F1"
    Given I open an editor "auftrag" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
    And I set fields
      | kunde | RADSHOP |
    And I append rows
      | artikel   | mge | projekt     |
      | BAUGRUPPE | 10  | PROJEKT_A05 |
    And I save the current editor

    Given I open an editor "Lieferung" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
    And I set fields
      | lief   | KETTLER  |
      | fakt   | ja       |
      | vom    | .        |
      | ebeleg | Rechnung |
      | ueb    | ja       |
      | budat  | .        |
    And I append rows
      | artikel   | mge | projekt     |
      | EINKAUF-1 | 20  | PROJEKT_A05 |
      | EINKAUF-2 | 10  | PROJEKT_A05 |
    And I set field "verw" in row 1 to "verw" from editor "auftrag" in row 1
    And I set field "verw" in row 2 to "verw" from editor "auftrag" in row 1
    And I respond with answer "ja" to the dialog with id "4841"
    And I save the current editor

# Fertigungsvorschlag anlegen und freigeben
    Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
    And I append rows
      | artikel   | netmge | bisuch   | projekt     | mfreig |
      | BAUGRUPPE | 10     | PROJEKT_ | PROJEKT_A05 | ja     |
    And I set field "verw" in row !lastRow to "verw" from editor "auftrag" in row 1
    And I press button "freig" to open a subeditor for "BA_freigeben"
    And I close the current editor
    And I switch the current editor to editor "fvor"
    And I save the current editor

# Komplettrückmeldung auf ersten Arbeitsgang
    Given I open an editor "Rückmeldung1" from table "(Workorder):(WorkOrders)" with command "DONE" for record "PROJEKT_001"
    And I set fields
      | sofort | 1 |
      | gut    | 1 |
    And I save the current editor

# Zusätzliche Gutmnege melden
    Given I open an editor "Rückmeldung2" via ID from editor "Rückmeldung1" from field "id" in row 0 for table "(Workorder):(CompletionConfirmations)" with command "COPY"
    And I set field "gutmge" to "5" in row 1
    And I save the current editor

# LJ und Bestand prüfen
    Given I open the infosystem "LJ"
    And I set field "beleg" to "nummer" from editor "Rückmeldung1"
    And I set field "richtung" to "rückwärts"
    And I press start
    Then table has values
      | art       | zmge | amge | projekt     | projektla |
      | BAUGRUPPE | 5    |      | PROJEKT_A05 | ja        |
      | BAUGRUPPE | 10   |      | PROJEKT_A05 | ja        |
      | EINKAUF-1 |      | 20   | PROJEKT_A05 | ja        |
      | EINKAUF-2 |      | 10   | PROJEKT_A05 | ja        |
    And I close the current editor

    Given I open the infosystem "BESTAND"
    And I set fields
      | artikel    | BAUGRUPPE |
      | verdichten | nein      |
      | details    | nein      |
    And I press start
    Then field "lemge" has value "15" in row 1
    And I press button "taufzu" in row 1
    Then table has values
      | gebmge | projekt     | kopfzugvorg^id   |
      |        |             | (0,0,0)          |
      | 10     | PROJEKT_A05 | !Rückmeldung1^id |
      | 5      | PROJEKT_A05 | !Rückmeldung2^id |
    And I close the current editor

# Auftrag liefern
    Given I switch the current editor to editor "auftrag" with command "DELIVERY"
    And I set fields
      | vom | .  |
      | ueb | ja |
    And I set field "mge" to "15" in row 1
    And I save the current editor


  Scenario: 06 Rückmeldung von Gutmenge auf abgelegten FV mit zusätzlichem Material
# Bestand korrigieren, Auftrag anlegen, Bedarfe einkaufen
    Given I set StorageQuantity to zero for Product "BAUGRUPPE" on StorageLocation "F1"
    Given I create a SalesOrder "auftrag" for Customer "RADSHOP" with Product "BAUGRUPPE" and quantity "10"

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
      | EINKAUF-1 | 25  |
      | EINKAUF-2 | 10  |
      | EINKAUF-3 | 7   |
    And I set field "verw" in row 1 to "verw" from editor "auftrag" in row 1
    And I set field "verw" in row 2 to "verw" from editor "auftrag" in row 1
    And I set field "verw" in row 3 to "verw" from editor "auftrag" in row 1
    And I respond with answer "ja" to the dialog with id "4841"
    And I save the current editor

# Fertigungsvorschlag anlegen und freigeben
    Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
    And I append rows
      | artikel   | netmge | bisuch    | mfreig |
      | BAUGRUPPE | 10     | MATERIAL_ | ja     |
    And I set field "verw" in row !lastRow to "verw" from editor "auftrag" in row 1
    And I press button "freig" to open a subeditor for "BA_freigeben"
    And I close the current editor
    And I switch the current editor to editor "fvor"
    And I save the current editor

# Komplettrückmeldung auf ersten Arbeitsgang
    Given I open an editor "Rückmeldung1" from table "(Workorder):(WorkOrders)" with command "DONE" for record "MATERIAL_001"
    And I set fields
      | sofort | 1 |
      | gut    | 1 |
    And I save the current editor

# Zusätzliche Gutmnege melden
    Given I open an editor "Rückmeldung2" via ID from editor "Rückmeldung1" from field "id" in row 0 for table "(Workorder):(CompletionConfirmations)" with command "COPY"
    And I set field "gutmge" to "5" in row 1
    And I append rows
      | artikel   | mge |
      | EINKAUF-1 | 5   |
      | EINKAUF-3 | 7   |
    And I save the current editor

# LJ prüfen
    Given I open the infosystem "LJ"
    And I set field "beleg" to "nummer" from editor "Rückmeldung1"
    And I set field "richtung" to "rückwärts"
    And I press start
    Then table has values
      | art       | zmge | amge |
      | BAUGRUPPE | 5    |      |
      | EINKAUF-1 |      | 5    |
      | EINKAUF-3 |      | 7    |
      | BAUGRUPPE | 10   |      |
      | EINKAUF-1 |      | 20   |
      | EINKAUF-2 |      | 10   |
    And I close the current editor

# Auftrag liefern
    Given I switch the current editor to editor "auftrag" with command "DELIVERY"
    And I set fields
      | vom | .  |
      | ueb | ja |
    And I set field "mge" to "15" in row 1
    And I save the current editor


  Scenario: 07 Rückmeldung von Ausschuss auf abgelegten FV bucht automatisch kein Material
# Bestand korrigieren, Auftrag anlegen, Bedarfe einkaufen
    Given I set StorageQuantity to zero for Product "BAUGRUPPE" on StorageLocation "F1"
    Given I create a SalesOrder "auftrag" for Customer "RADSHOP" with Product "BAUGRUPPE" and quantity "10"

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
      | EINKAUF-1 | 20  |
      | EINKAUF-2 | 10  |
    And I set field "verw" in row 1 to "verw" from editor "auftrag" in row 1
    And I set field "verw" in row 2 to "verw" from editor "auftrag" in row 1
    And I respond with answer "ja" to the dialog with id "4841"
    And I save the current editor

# Fertigungsvorschlag anlegen und freigeben
    Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
    And I append rows
      | artikel   | netmge | bisuch     | mfreig |
      | BAUGRUPPE | 10     | AUSSCHUSS_ | ja     |
    And I set field "verw" in row !lastRow to "verw" from editor "auftrag" in row 1
    And I press button "freig" to open a subeditor for "BA_freigeben"
    And I close the current editor
    And I switch the current editor to editor "fvor"
    And I save the current editor

# Komplettrückmeldung auf ersten Arbeitsgang
    Given I open an editor "Rückmeldung1" from table "(Workorder):(WorkOrders)" with command "DONE" for record "AUSSCHUSS_001"
    And I set fields
      | sofort | 1 |
      | gut    | 1 |
    And I save the current editor

# Zusätzliche Gutmnege und Ausschuss melden
    Given I open an editor "Rückmeldung2" via ID from editor "Rückmeldung1" from field "id" in row 0 for table "(Workorder):(CompletionConfirmations)" with command "COPY"
    And I set field "gutmge" to "5" in row 1
    And I set field "verlustmge" to "2" in row 1
    And I save the current editor

# LJ und Bestand prüfen
    Given I open the infosystem "LJ"
    And I set field "beleg" to "nummer" from editor "Rückmeldung1"
    And I set field "richtung" to "rückwärts"
    And I press start
    Then table has values
      | art       | zmge | amge |
      | BAUGRUPPE | 5    |      |
      | BAUGRUPPE | 10   |      |
      | EINKAUF-1 |      | 20   |
      | EINKAUF-2 |      | 10   |
    And I close the current editor

    Given I open the infosystem "BESTAND"
    And I set fields
      | artikel    | BAUGRUPPE |
      | verdichten | nein      |
      | details    | nein      |
    And I press start
    Then field "lemge" has value "15" in row 1
    And I press button "taufzu" in row 1
    Then table has values
      | gebmge | kopfzugvorg^id   |
      |        | (0,0,0)          |
      | 10     | !Rückmeldung1^id |
      | 5      | !Rückmeldung2^id |
    And I close the current editor

# Auftrag liefern
    Given I switch the current editor to editor "auftrag" with command "DELIVERY"
    And I set fields
      | vom | .  |
      | ueb | ja |
    And I set field "mge" to "15" in row 1
    And I save the current editor


  Scenario: 08 Feld bem wird beim Nachbuchen auf abgelegten FV geleert
# Bedarfe einkaufen und FV anlegen
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
      | EINKAUF-1 | 20  |
      | EINKAUF-2 | 10  |
    And I respond with answer "ja" to the dialog with id "4841"
    And I save the current editor

# Fertigungsvorschlag anlegen und freigeben
    Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
    And I append rows
      | artikel   | netmge | bisuch     | mfreig |
      | BAUGRUPPE | 10     | BEMERKUNG_ | ja     |
    And I press button "freig" to open a subeditor for "BA_freigeben"
    And I close the current editor
    And I switch the current editor to editor "fvor"
    And I save the current editor

# Komplettrückmeldung auf ersten Arbeitsgang
    Given I open an editor "Rückmeldung1" from table "(Workorder):(WorkOrders)" with command "DONE" for record "BEMERKUNG_001"
    And I set fields
      | sofort | 1               |
      | gut    | 1               |
      | bem    | Bemerkung zu FV |
    And I save the current editor

# Rückmeldung kopieren, Feld bem ist leer
    Given I switch the current editor to editor "Rückmeldung1" with command "COPY"
    Then field "bem" is empty
    And I close the current editor

# Lieferschein
    Given I open an editor "Lieferschein" from table "(Sales):(PackingSlip)" with command "NEW" for record ""
    And I set fields
      | kunde | RADSHOP |
      | vom   | .       |
      | ueb   | ja      |
    And I append rows
      | artikel   | mge |
      | BAUGRUPPE | 10  |
    And I save the current editor


  Scenario: 09 In Kommando Rückmeldung neu sind keine negativen Werte erlaubt

    Given I open an editor "RückmeldungNeu" from table "(Workorder):(CompletionConfirmations)" with command "NEW" for record ""
    And I set field "barmex" to "9999"
    Then setting field "bzeit" to "-1" throws the exception "11034"
    Then setting field "mzeit" to "-1" throws the exception "11034"
    And I create a new row at the end of the table
    And I set field "artikel" to "EINKAUF-1" in row 1
    Then setting field "mge" to "-1" in row 1 throws the exception "11134"
    Then setting field "gutmge" to "-1" in row 1 throws the exception "11134"
    And I close the current editor


  Scenario: 10 Storno einer Rückmeldung, die über Rückmeldung neu entstand, kann storniert werden

# RM Neu nur Zeiten
    Given I open an editor "RückmeldungNeu1" from table "(Workorder):(CompletionConfirmations)" with command "NEW" for record ""
    And I set fields
      | barmex  | 9998      |
      | mgr     | 112       |
      | kstelle | 101       |
      | artikel | BAUGRUPPE |
      | ma      | Karl      |
      | lgr     | 1         |
      | lart    | 1         |
      | bzeit   | 2         |
      | mzeit   | 3         |
    And I save the current editor

    Given I open an editor "RückmeldungNeuStorno1" from table "(Workorder):(CompletionConfirmations)" with command "REVERSAL" for record from editor "RückmeldungNeu1"
    And I close the current editor
# RM Neu nur Mengen
    Given I open an editor "RückmeldungNeu2" from table "(Workorder):(CompletionConfirmations)" with command "NEW" for record ""
    And I set fields
      | barmex  | 9999      |
      | mgr     | 112       |
      | kstelle | 101       |
      | artikel | BAUGRUPPE |
    And I append rows
      | artikel   | mge |
      | EINKAUF-1 | 10  |
    And I save the current editor

    Given I open an editor "RückmeldungNeuStorno2" from table "(Workorder):(CompletionConfirmations)" with command "REVERSAL" for record from editor "RückmeldungNeu2"
    And I close the current editor


  Scenario: 11 In Rückmeldung neu werden Angaben zu Behälter und Chargen berücksichtigt
# Bestand auf 0 korrigieren
    Given I set StorageQuantity to zero for Product "EINKAUF-1" on StorageLocation "F1"

# Behälter und Charge erstellen
    Given I create a Container "BEHAELTER1" for packaging material "BEHAELTER"
    Given I create a Lot "CH_E1" for Product "EINKAUF-1"

# Material auf Lager buchen
    Given I open an editor "Lagerbuchung" for tip command "Lbuchung" and arguments ""
    And I set fields
      | artikel | EINKAUF-1 |
      | beleg   | LBuchung1 |
      | beldat  | .         |
      | buart   | Zugang    |
      | wert    | 4,50      |
    And I append rows
      | mge | platz2 | behaelter      | charge2   |
      | 1   | F1     | !BEHAELTER1^id |           |
      | 1   | F1     |                |           |
      | 1   | F1     |                | !CH_E1^id |
      | 1   | F1     | !BEHAELTER1^id | !CH_E1^id |
    And I save the current editor

    And I switch the current editor to editor "BEHAELTER1" with command "VIEW"
    Then the table has 2 rows
    Then table has values
      | artikel   | mge | charge^id |
      | EINKAUF-1 | 1   | (0,0,0)   |
      | EINKAUF-1 | 1   | !CH_E1^id |
    And I close the current editor

# Rückmeldung neu mit Projekt, Verwendung, Behälter und Charge
    Given I open an editor "RückmeldungNeu" from table "(Workorder):(CompletionConfirmations)" with command "NEW" for record ""
    And I set fields
      | barmex  | 1111          |
      | mgr     | 112           |
      | kstelle | 101           |
      | artikel | BAUGRUPPE     |
    And I append rows
      | artikel   | mge | tbehaelter     | charge    |
      | EINKAUF-1 | 1   | !BEHAELTER1^id |           |
      | EINKAUF-1 | 1   |                | !CH_E1^id |
      | EINKAUF-1 | 1   |                |           |
      | EINKAUF-1 | 1   | !BEHAELTER1^id | !CH_E1^id |
    And I save the current editor

# LJ, Bestand und Behälter prüfen
    Then Container from editor "BEHAELTER1" is empty

    Given I open the infosystem "LJ"
    And I set fields
      | beleg    | 1111      |
      | richtung | rückwärts |
    And I press start
    Then table has values
      | art       | detursache                         | amge | behaelter^id   | vcharge^id |
      | EINKAUF-1 | Fertigung ohne Fertigungsvorschlag | 1    | !BEHAELTER1^id | (0,0,0)    |
      | EINKAUF-1 | Fertigung ohne Fertigungsvorschlag | 1    | (0,0,0)        | !CH_E1^id  |
      | EINKAUF-1 | Fertigung ohne Fertigungsvorschlag | 1    | (0,0,0)        | (0,0,0)    |
      | EINKAUF-1 | Fertigung ohne Fertigungsvorschlag | 1    | !BEHAELTER1^id | !CH_E1^id  |

    Given I open the infosystem "BESTAND"
    And I set fields
      | artikel   | EINKAUF-1 |
      | klplatz   | F1        |
      | behaelter | ja        |
      | details   | nein      |
    And I press start
    Then the table has 0 rows
    And I close the current editor


  Scenario: 12 In Rückmeldung neu können keine Behälter mit Status Gesperrt, Geliefert und Rückgeliefert eingetragen werden
# Behälter Status Gesperrt, Geliefert unf Rückgeliefert erzeugen
    Given I open an editor "B_GESPERRT" from table "(Container):(ContainerShell)" with command "NEW" for record ""
    And I set fields
      | such        | B_GESPERRT |
      | packm       | BEHAELTER  |
      | behstatusaz | Gesperrt   |
    And I save the current editor

    Given I create a Container "B_GELIEFERT" for packaging material "BEHAELTER"
    Given I open an editor "Lbuchung" for tip command "Lbuchung" and arguments ""
    And I set fields
      | artikel | BAUGRUPPE |
      | beleg   | Buchung1  |
      | beldat  | .         |
      | buart   | Zugang    |
    And I append rows
      | mge | platz2 | behaelter    |
      | 10  | F1     | !B_GELIEFERT |
    And I save the current editor

    Given I open an editor "VK-Lieferschein" from table "(Sales):(PackingSlip)" with command "NEW" for record ""
    And I set fields
      | kunde | RADSHOP |
      | vom   | .       |
      | ueb   | ja      |
    And I append rows
      | artikel   | mge | behaelter       |
      | BAUGRUPPE | 10  | !B_GELIEFERT^id |
    And I save the current editor
    Then field "behstatusaz" from editor "B_GELIEFERT" in row 0 has value "Geliefert"

    Given I create a Container "B_RUECKLIEFERUNG" for packaging material "BEHAELTER"
    Given I open an editor "EK-Lieferschein" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
    And I set fields
      | lief   | KETTLER       |
      | vom    | .             |
      | ueb    | ja            |
      | ebeleg | Lieferschein1 |
    And I append rows
      | artikel   | mge |
      | EINKAUF-1 | 10  |
    And I respond with answer "nein" to the dialog with id "Externe Behälternummer ist bereits vergeben."
    And I set field "exbehnum" to "nummer" from editor "B_RUECKLIEFERUNG" in row 1
    And I save the current editor

    Given I switch the current editor to editor "EK-Lieferschein" with command "RETURN"
    And I set fields
      | ueb    | ja             |
      | vom    | .              |
      | ebeleg | Rücklieferung1 |
    And I modify table
      | !row | mge | behaelter            |
      | 1    | -10 | !B_RUECKLIEFERUNG^id |
    And I save the current editor
    Then field "behstatusaz" from editor "B_RUECKLIEFERUNG" in row 0 has value "Rücklieferung"

# Rückmeldung neu gibt Fehlermeldung
    Given I open an editor "RückmeldungNeu" from table "(Workorder):(CompletionConfirmations)" with command "NEW" for record ""
    And I set fields
      | barmex  | 9999      |
      | mgr     | 112       |
      | kstelle | 101       |
      | artikel | BAUGRUPPE |
    And I append rows
      | artikel   | mge |
      | EINKAUF-1 | 10  |
  	# Fehler, der Behälter ist gesperrt
    Then setting field "tbehaelter" to "!B_GESPERRT^id" in row 1 throws the exception "11072"
  	# Fehler, Behälter ist außer Haus
    Then setting field "tbehaelter" to "!B_GELIEFERT^id" in row 1 throws the exception "8413"
    Then setting field "tbehaelter" to "!B_RUECKLIEFERUNG^id" in row 1 throws the exception "8413"
    And I close the current editor


  Scenario: 13 Nachbuchen von Gutmenge und Material mit Einheiten und Gebindefplicht auf abgelegten FV
# Bestände auf 0 korrigieren
    Given I set StorageQuantity to zero for Product "GEBINDE" on StorageLocation "F1" with document "SCEN-13_1"
    Given I set StorageQuantity to zero for Product "GEBINDEPFL" on StorageLocation "F1" with document "SCEN-13_2"
    Given I set StorageQuantity to zero for Product "BG-EINHEITENPFL" on StorageLocation "F1" with document "SCEN-13_3"

# Bedarfe einkaufen
    Given I create a SalesOrder "auftrag" for Customer "RADSHOP" with Product "BG-EINHEITENPFL" and quantity "5"
    Given I open an editor "Rechnung" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
    And I set fields
      | lief   | KETTLER |
      | vom    | .       |
      | ueb    | ja      |
      | fakt   | ja      |
      | ebeleg | R-13    |
      | budat  | .       |
    And I append rows
      | artikel    | mge | he    |
      | GEBINDEPFL | 5,5 | Paar  |
      | GEBINDEPFL | 1   | Stück |
      | GEBINDE    | 60  | kg    |
      | EINKAUF-1  | 10  | Stück |
    And I respond with answer "ja" to the dialog with id "4841"
    And I save the current editor

# Fertigungsvorschlag anlegen und freigeben
    Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
    And I append rows
      | artikel         | netmge | mfreig |
      | BG-EINHEITENPFL | 10     | ja     |
    And I press button "absteig" to open a subeditor for "AFL" in row !lastRow
    And I press button "setmanbu"
    And I save the current editor
    And I switch the current editor to editor "fvor"
    And I set field "bisuch" to "GEBPFLICHT_" in row 1
    And I press button "freig" to open a subeditor for "BA_freigeben"
    And I close the current editor
    And I switch the current editor to editor "fvor"
    And I save the current editor

# Arbeitsschein1 öffnen
    Given I open an editor "Arbeitsschein1" from table "(Workorder):(WorkOrders)" with command "VIEW" for record "GEBPFLICHT_001"
    And I close the current editor

# Materialentnahme und Rueckmeldung ueber gesamte Gutmenge, Buchungseinheiten anpassen
    Given I open an editor "Materialentnahme1" for tip command "Fbuchung" and arguments ""
    And I set field "auftrag" to "!Arbeitsschein1"
    And I set field "bem" to "Entnahme"
    And I press button "stllad"
    And I modify table
      | !row | bumge | bueinh |
      | 1    | 10    | Stück  |
      | 2    | 5     | Paar   |
    And I save the current editor

    Given I open an editor "Materialentnahme1" from table "(Workorder):(CompletionConfirmations)" with command "VIEW" for search criteria "$,,such=GEBPFLICHT_001;manrm=ja;@richtung=rückwärts;@maxtreffer=1;@ablageart=abgelegt"
    And I close the current editor

    Given I open an editor "Rückmeldung1" from table "(Workorder):(WorkOrders)" with command "DONE" for record "GEBPFLICHT_001"
    And I set fields
      | sofort | ja |
      | gut    | ja |
    And I save the current editor

	# Nachbuchen in Lagereinheit
    Given I open an editor "Rückmeldung2" via ID from editor "Rückmeldung1" from field "id" in row 0 for table "(Workorder):(CompletionConfirmations)" with command "COPY"
    And I modify table
      | !row | gutmge      | mge         | bueinh |
      | 1    | 1           | !dontChange | Stück  |
      | 2    | !dontChange | 1           | Stück  |
      | 3    | !dontChange | 1           | Stück  |
    And I save the current editor

	# Nachbuchen in Handelseinheit
    Given I open an editor "Rückmeldung3" via ID from editor "Rückmeldung1" from field "id" in row 0 for table "(Workorder):(CompletionConfirmations)" with command "COPY"
    And I modify table
      | !row | gutmge      | mge         | bueinh |
      | 1    | 1           | !dontChange | Paar   |
      | 2    | !dontChange | 5           | kg     |
      | 3    | !dontChange | 0.5         | Paar   |
    And I save the current editor

    Given I open the infosystem "BESTAND"
    And I set fields
      | artikel    | BG-EINHEITENPFL |
      | verdichten | nein            |
      | details    | nein            |
    And I press start
    Then field "lemge" has value "13" in row 1
    Then field "leinheit" has value "Stück" in row 1
    And I press button "taufzu" in row 1
    Then the table has 4 rows
    Then table has values
      | gebmge | geinheit | kopfzugvorg^id   |
      |        |          | (0,0,0)          |
      | 10     | Stück    | !Rückmeldung1^id |
      | 1      | Stück    | !Rückmeldung2^id |
      | 1      | Paar     | !Rückmeldung3^id |
    And I set fields
      | artikel    | GEBINDE |
      | verdichten | nein    |
      | nullmge    | nein    |
    And I press start
    Then the table has 0 rows
    And I set fields
      | artikel    | GEBINDEPFL |
      | verdichten | nein       |
    And I press start
    Then the table has 0 rows
    And I close the current editor

    And I switch the current editor to editor "auftrag" with command "DELIVERY"
    And I set fields
      | ueb | ja |
    And I modify table
      | artikel         | mge | he    | !row |
      | !dontChange     | 11  | Stück | 1    |
      | BG-EINHEITENPFL | 1   | Paar  | +2   |
    And I save the current editor

    Given I open the infosystem "BESTAND"
    And I set fields
      | artikel    | BG-EINHEITENPFL |
      | verdichten | nein            |
      | nullmge    | nein            |
      | details    | nein            |
    And I press start
    Then the table has 0 rows
    And I save the current editor


  Scenario: 14a Beschaffung über Gesamtmenge wird generiert, wenn ein Artikel nachträglich in eine AFL eingefügt wird
# Bestand auf 0 korrigieren
    Given I set StorageQuantity to zero for Product "EINKAUF-3" on StorageLocation "F1" with document "KORR-14a"

# Fertigungsvorschlag anlegen und freigeben
    Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
    And I append rows
      | artikel    | netmge | bisuch    | verw  | mfreig |
      | BAUGRUPPE2 | 10     | BESTELL1_ | verw1 | ja     |
    And I press button "freig" to open a subeditor for "BA_freigeben"
    And I close the current editor
    And I switch the current editor to editor "fvor"
    And I save the current editor
    And I close the current editor

# Rückmeldung auf ersten Arbeitsschein
    Given I open an editor "Rückmeldung1" from table "(Workorder):(WorkOrders)" with command "DONE" for record "BESTELL1_001"
    And I set field "gut" to "1"
    And I set field "sofort" to "1"
    And I save the current editor
    And I close the current editor

# Artikel im Rückgemeldeten bereich der AFL einfügen
    Given I open an editor "Betriebsauftrag" from table "(Workorder):(WorkOrders)" with command "UPDATE" for record "BESTELL1_000"
    And I press button "absteig" to open a subeditor for "AFL"
    And I create a new row at position 1
    And I set field "elex" to "Einkauf-3" in row 1
    And I set field "elanzahl" to "1" in row 1
    And I save the current editor
    And I switch the current editor to editor "Betriebsauftrag"
    And I close the current editor

# Dispo starten
    And I run Scheduling

# Bestellvorschlag über 10 vorhanden, freigeben
    Given I open an editor "Bestellvorschläge" from table "(Purchasing):(PurchaseOrderSuggestions)" with command "UPDATE" for record ""
    And I set field "artikel" to "Einkauf-3"
    And I press button "ladetab"
    Then field "mge" has value "10" in row !lastRow
    Then field "verw" has value "verw1" in row !lastRow
    And I set field "mfreig" to "ja" in row !lastRow
    And I press button "freig" to open a subeditor for "Bestellung"
    And I save the current editor
    And I switch the current editor to editor "Bestellvorschläge"
    And I close the current editor


  Scenario: 14b Beschaffung über Gesamtmenge wird generiert, wenn ein Artikel nachträglich in eine AFL eingefügt wird ohne dass die Gesamtmenge zuvor gebucht wird
# Fertigungsvorschlag anlegen und freigeben
    Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
    And I append rows
      | artikel    | netmge | bisuch    | verw  | mfreig |
      | BAUGRUPPE2 | 10     | BESTELL2_ | verw2 | ja     |
    And I press button "freig" to open a subeditor for "BA_freigeben"
    And I close the current editor
    And I switch the current editor to editor "fvor"
    And I save the current editor
    And I close the current editor

# Rückmeldung auf ersten Arbeitsschein
    Given I open an editor "Rückmeldung1" from table "(Workorder):(WorkOrders)" with command "DONE" for record "BESTELL2_001"
    And I set field "sofort" to "1"
    And I set field "gutmge" to "3" in row 1
    And I save the current editor
    And I close the current editor

# Artikel im Rückgemeldeten bereich der AFL einfügen
    Given I open an editor "Betriebsauftrag" from table "(Workorder):(WorkOrders)" with command "UPDATE" for record "BESTELL2_000"
    And I press button "absteig" to open a subeditor for "AFL"
    And I create a new row at position 1
    And I set field "elex" to "Einkauf-3" in row 1
    And I set field "elanzahl" to "1" in row 1
    And I save the current editor
    And I switch the current editor to editor "Betriebsauftrag"
    And I close the current editor

# Dispo starten
    And I run Scheduling

# Bestellvorschlag über 10 vorhanden
    Given I open an editor "Bestellvorschläge" from table "(Purchasing):(PurchaseOrderSuggestions)" with command "UPDATE" for record ""
    And I set field "artikel" to "Einkauf-3"
    And I press button "ladetab"
    And field "mge" has value "10" in row !lastRow
    Then field "verw" has value "verw2" in row !lastRow
    And I set field "mfreig" to "ja" in row !lastRow
    And I press button "freig" to open a subeditor for "Bestellung"
    And I save the current editor
    And I switch the current editor to editor "Bestellvorschläge"
    And I close the current editor


  Scenario: 15 Retrogrades Material wird bei Fertigungsmenge reduzieren mit der letzten Rückmeldung entsprechend abgebucht, Auslaufartikel wird zuerst verbraucht

# Betriebsdatensatz umstellen wegen Auslaufsteuerung
    Given I open an editor "KonfigurationDisposition" from table "(SchedulingConfiguration):(CompanySchedConfig)" with command "UPDATE" for record "SCHEDCONF"
    And I set field "auslaufarteinplan" to "Gemischt einplanen"
    And I save the current editor

    Given I open an editor "BG01_SCEN15" from table "(Part):(Product)" with command "STORE" for record "BG01_SCEN15"
    And I set fields
      | dispoa   | bedarfsbezogen            |
      | bsart    | Eigenfertigung            |
      | such     | BG01_SCEN15               |
      | namebspr | Baugruppe mit Auslaufteil |
      | vpr      | 10                        |
    And I modify table
      | !row | elex         | elanzahl |
      | +1   | B_EINKAUF-1  | 1        |
      | +2   | EK-1-AUSLAUF | 1        |
      | +3   | A MONTAGE1   | 1        |
    And I save the current editor

# Bestandskorrekturen
    Given I set StorageQuantity to zero for Product "EK-1-AUSLAUF" on StorageLocation "F1"
    Given I set StorageQuantity to zero for Product "EK-1-NACHFOLGER" on StorageLocation "F1"
    Given I set StorageQuantity to zero for Product "BG01_SCEN15" on StorageLocation "F1"

# Bestandszugang Auslaufartikel
    Given I post a receipt via ManualStockAdjustment for Product "EK-1-AUSLAUF" and quantity "40" on StorageLocation "F1" with document "LBU_scen15"

# Auftrag anlegen
    Given I create a SalesOrder "auftrag7" for Customer "RADSHOP" with Product "BG01_SCEN15" and quantity "50"

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
      | artikel         | mge |
      | B_EINKAUF-1     | 50  |
      | EK-1-NACHFOLGER | 10  |
    And I respond with answer "ja" to the dialog with id "4841"
    And I save the current editor

# Fertigungsvorschlag anlegen
    Given I open an editor "FV7" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
    And I append rows
      | artikel     | netmge | bisuch | mfreig |
      | BG01_SCEN15 | 50     | FV7_   | ja     |
    And I set field "verw" in row !lastRow to "verw" from editor "auftrag7" in row 1
    And I press button "freig" to open a subeditor for "BA_freigeben"
    And I close the current subeditor to switch back to the parent editor
    And I close the current editor

# Dispo laufen lassen, um Mengen für Auslaufartikel und Nachfolger einzuplanen
    And I run Scheduling

# Rückmeldung auf ersten Arbeitsschein
    Given I open an editor "Rückmeldung1" from table "(Workorder):(WorkOrders)" with command "DONE" for search criteria "$,,such=FV7_001;@richtung=rückwärts;@maxordtreffer=1"
    And I set field "sofort" to "ja"
    And I set field "gutmge" to "20" in row 1
    And I save the current editor

# Offene Menge prüfen des Auslaufartikels (20, da 40 an Lager und 20 verbraucht, Rest Nachfolger)
    Given I open an editor "BA" from table "(Workorder):(WorkOrders)" with command "VIEW" for search criteria "$,,such=FV7_000;@richtung=rückwärts;@maxordtreffer=1"
    And I press button "absteig" to open a subeditor for "AFL7"
    Then field "limge" has value "20" in row 2
    And I close the current subeditor to switch back to the parent editor
    And I close the current editor

# Materialrückgabe buchen
    Given I open an editor "MatEnt" for tip command "Fbuchung" and arguments ""
    And I set field "auftrag" to "!Rückmeldung1^barmex"
    And I set field "gmgevorschl" to "-10"
    And I set field "autorment" to "ja"
    And I press button "stlvblad"
    And I delete row at position 1
    And I save the current editor

# Offene Menge prüfen
    Given I open an editor "BA" from table "(Workorder):(WorkOrders)" with command "VIEW" for search criteria "$,,such=FV7_000;@richtung=rückwärts;@maxordtreffer=1"
    And I save value from field "nummer" in row 0
    And I press button "absteig" to open a subeditor for "AFL7"
    Then field "limge" has value "30" in row 2
    And I close the current subeditor to switch back to the parent editor
    And I close the current editor

# Rückmeldung auf ersten Arbeitsschein
    Given I open an editor "Rückmeldung2" from table "(Workorder):(WorkOrders)" with command "DONE" for search criteria "$,,such=FV7_001;@richtung=rückwärts;@maxordtreffer=1"
    And I set field "sofort" to "ja"
    And I set field "mgereduzieren" to "ja"
    And I set field "gutmge" to "25" in row 1
    And I save the current editor

# Prüfen ob FeVo in der Ablage
    Given I open an editor "FV" from table "(Purchasing):(WorkOrderSuggestions)" with command "VIEW" for record ""
    And I set field "artikel" to "BG01_SCEN15"
    And I set field "banummer" in row 0 to saved value
    And I set field "nurablage" to "ja"
    And I press button "ladetab"
    Then the table has 1 rows
    And I close the current editor

## LJ prüfen von EK-1-AUSLAUF (35 benötigt, Rest von 30 verbraucht)
    Given I open the infosystem "LJ"
    And I set field "beleg" to "!Rückmeldung2^barmex"
    And I set field "artikel" to "EK-1-AUSLAUF"
    And I press button "bstart"
    Then table has values
      | art          | amge | detursache            | !row     |
      | EK-1-AUSLAUF | 30   | Rückmeldung Fertigung | !lastRow |
    And I close the current editor

# LJ prüfen von EK-1-NACHFOLGER (fehlende 5 Stk entnommen)
    Given I open the infosystem "LJ"
    And I set field "beleg" to "!Rückmeldung2^barmex"
    And I set field "artikel" to "EK-1-NACHFOLGER"
    And I press button "bstart"
    Then table has values
      | art             | amge | detursache            | !row     |
      | EK-1-NACHFOLGER | 5    | Rückmeldung Fertigung | !lastRow |
    And I close the current editor

# Bestand von EK-1-AUSLAUF prüfen
    Given I open the infosystem "BESTAND"
    And I set field "artikel" to "EK-1-AUSLAUF"
    And I set field "klplatz" to "F1"
    And I set field "details" to "nein"
    And I press button "bstart"
    Then field "lemge" has value "" in row 1
    And I close the current editor

# Bestand von EK-1-NACHFOLGER prüfen
    Given I open the infosystem "BESTAND"
    And I set field "artikel" to "EK-1-NACHFOLGER"
    And I set field "klplatz" to "F1"
    And I set field "details" to "nein"
    And I press button "bstart"
    Then field "lemge" has value "5" in row 1
    And I close the current editor

# Auftragsmenge reduzieren (um Auftrag abzuschließen)
    Given I switch the current editor to editor "auftrag7" with command "UPDATE"
    And I set field "mge" to "45" in row 1
    And I save the current editor

# Auftrag liefern
    Given I switch the current editor to editor "auftrag7" with command "DELIVERY"
    And I set fields
      | vom | .  |
      | ueb | ja |
    And I set field "mge" to "45" in row 1
    And I save the current editor


# Betriebsdatensatz wieder zurück umstellen (Auslaufsteuerung)
    Given I open an editor "KonfigurationDisposition" from table "(SchedulingConfiguration):(CompanySchedConfig)" with command "UPDATE" for record "SCHEDCONF"
    And I set field "auslaufarteinplan" to "Nicht gemischt einplanen"
    And I save the current editor

  Scenario: 16 Retrogrades Material wird bei Fertigungsmenge reduzieren mit der letzten Rückmeldung entsprechend abgebucht

# Bestandskorrektur
    Given I set StorageQuantity to zero for Product "EINKAUF-1" on StorageLocation "F1"

# Auftrag anlegen
    Given I create a SalesOrder "auftrag6" for Customer "RADSHOP" with Product "BAUGRUPPE" and quantity "50"

# Material einkaufen
    Given I open an editor "Lieferung" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
    And I set fields
      | lief   | KETTLER  |
      | fakt   | ja       |
      | vom    | .        |
      | ebeleg | Rechnung |
      | ueb    | ja       |
    And I append rows
      | artikel   | mge |
      | EINKAUF-1 | 100 |
      | EINKAUF-2 | 50  |
    And I set field "verw" in row 1 to "verw" from editor "auftrag6" in row 1
    And I respond with answer "ja" to the dialog with id "4841"
    And I save the current editor

# Fertigungsvorschlag anlegen
    Given I open an editor "FV6" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
    And I append rows
      | artikel   | netmge | bisuch | mfreig |
      | BAUGRUPPE | 50     | FV6_   | ja     |
    And I set field "verw" in row !lastRow to "verw" from editor "auftrag6" in row 1
    And I press button "freig" to open a subeditor for "BA_freigeben"
    And I close the current subeditor to switch back to the parent editor
    And I close the current editor

# Rückmeldung auf ersten Arbeitsschein
    Given I open an editor "Rückmeldung1" from table "(Workorder):(WorkOrders)" with command "DONE" for search criteria "$,,such=FV6_001;@richtung=rückwärts;@maxordtreffer=1"
    And I set field "sofort" to "ja"
    And I set field "gutmge" to "20" in row 1
    And I save the current editor

# Offene Menge prüfen
    Given I open an editor "BA" from table "(Workorder):(WorkOrders)" with command "VIEW" for search criteria "$,,such=FV6_000;@richtung=rückwärts;@maxordtreffer=1"
    And I press button "absteig" to open a subeditor for "AFL6"
    Then field "limge" has value "60" in row 1
    And I close the current subeditor to switch back to the parent editor
    And I close the current editor

# Materialrückgabe buchen
    Given I open an editor "MatEnt" for tip command "Fbuchung" and arguments ""
    And I set field "auftrag" to "!Rückmeldung1^barmex"
    And I set field "gmgevorschl" to "-10"
    And I set field "autorment" to "ja"
    And I press button "stlvblad"
    And I delete row at position 2
    And I save the current editor

# Offene Menge prüfen
    Given I open an editor "BA" from table "(Workorder):(WorkOrders)" with command "VIEW" for search criteria "$,,such=FV6_000;@richtung=rückwärts;@maxordtreffer=1"
    And I save value from field "nummer" in row 0
    And I press button "absteig" to open a subeditor for "AFL6"
    Then field "limge" has value "80" in row 1
    And I close the current subeditor to switch back to the parent editor
    And I close the current editor

# Rückmeldung auf ersten Arbeitsschein
    Given I open an editor "Rückmeldung2" from table "(Workorder):(WorkOrders)" with command "DONE" for search criteria "$,,such=FV6_001;@richtung=rückwärts;@maxordtreffer=1"
    And I set field "sofort" to "ja"
    And I set field "mgereduzieren" to "ja"
    And I set field "gutmge" to "25" in row 1
    And I save the current editor

# Prüfen ob FeVo in der Ablage
    Given I open an editor "FV" from table "(Purchasing):(WorkOrderSuggestions)" with command "VIEW" for record ""
    And I set field "artikel" to "BAUGRUPPE"
    And I set field "banummer" in row 0 to saved value
    And I set field "nurablage" to "ja"
    And I press button "ladetab"
    Then the table has 1 rows
    And I close the current editor

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
    And I set field "artikel" to "EINKAUF-1"
    And I set field "klplatz" to "F1"
    And I set field "details" to "nein"
    And I press button "bstart"
    Then field "lemge" has value "10" in row 1
    And I close the current editor

# Auftragsmenge reduzieren
    Given I switch the current editor to editor "auftrag6" with command "UPDATE"
    And I set field "mge" to "45" in row 1
    And I save the current editor

# Auftrag liefern
    Given I switch the current editor to editor "auftrag6" with command "DELIVERY"
    And I set fields
      | vom | .  |
      | ueb | ja |
    And I set field "mge" to "45" in row 1
    And I save the current editor


  Scenario: 17a Noch offenes retrogrades Material wird über letzte Rückmeldung abgebucht

# Bestandskorrektur
    Given I set StorageQuantity to zero for Product "EINKAUF-1" on StorageLocation "F1"

# Auftrag anlegen
    Given I create a SalesOrder "auftrag" for Customer "RADSHOP" with Product "BAUGRUPPE" and quantity "50"

# Material einkaufen
    Given I open an editor "Lieferung" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
    And I set fields
      | lief   | KETTLER  |
      | fakt   | ja       |
      | vom    | .        |
      | ebeleg | Rechnung |
      | ueb    | ja       |
    And I append rows
      | artikel   | mge |
      | EINKAUF-1 | 100 |
      | EINKAUF-2 | 50  |
    And I set field "verw" in row 1 to "verw" from editor "auftrag" in row 1
    And I respond with answer "ja" to the dialog with id "4841"
    And I save the current editor

# Fertigungsvorschlag anlegen
    Given I open an editor "FV1" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
    And I append rows
      | artikel   | netmge | bisuch | mfreig |
      | BAUGRUPPE | 50     | FV1_   | ja     |
    And I set field "verw" in row !lastRow to "verw" from editor "auftrag" in row 1
    And I press button "freig" to open a subeditor for "BA_freigeben"
    And I close the current subeditor to switch back to the parent editor
    And I close the current editor

# Rückmeldung auf ersten Arbeitsschein
    Given I open an editor "Rückmeldung1" from table "(Workorder):(WorkOrders)" with command "DONE" for search criteria "$,,such=FV1_001;@richtung=rückwärts;@maxordtreffer=1"
    And I set field "sofort" to "1"
    And I set field "gutmge" to "20" in row 1
    And I save the current editor

# Offene Menge prüfen
    Given I open an editor "BA" from table "(Workorder):(WorkOrders)" with command "VIEW" for search criteria "$,,such=FV1_000;@richtung=rückwärts;@maxordtreffer=1"
    And I save value from field "nummer" in row 0
    And I press button "absteig" to open a subeditor for "AFL1"
    Then field "limge" has value "60" in row 1
    And I close the current subeditor to switch back to the parent editor
    And I close the current editor

# Materialrückgabe buchen
    Given I open an editor "MatEnt" for tip command "Fbuchung" and arguments ""
    And I set field "auftrag" to "!Rückmeldung1^barmex"
    And I set field "gmgevorschl" to "-10"
    And I set field "autorment" to "ja"
    And I press button "stlvblad"
    And I delete row at position 2
    And I save the current editor

# Offene Menge prüfen
    Given I open an editor "BA" from table "(Workorder):(WorkOrders)" with command "VIEW" for search criteria "$,,such=FV1_000;@richtung=rückwärts;@maxordtreffer=1"
    And I press button "absteig" to open a subeditor for "AFL1"
    Then field "limge" has value "80" in row 1
    And I close the current subeditor to switch back to the parent editor
    And I close the current editor

# Rückmeldung auf ersten Arbeitsschein
    Given I open an editor "Rückmeldung2" from table "(Workorder):(WorkOrders)" with command "DONE" for search criteria "$,,such=FV1_001;@richtung=rückwärts;@maxordtreffer=1"
    And I set field "sofort" to "1"
    And I set field "gutmge" to "30" in row 1
    And I save the current editor

# Prüfen ob FeVo in der Ablage
    Given I open an editor "FV" from table "(Purchasing):(WorkOrderSuggestions)" with command "VIEW" for record ""
    And I set field "artikel" to "BAUGRUPPE"
    And I set field "banummer" in row 0 to saved value
    And I set field "nurablage" to "ja"
    And I press button "ladetab"
    Then the table has 1 rows
    And I close the current editor

# LJ prüfen von EINKAUF-1
    Given I open the infosystem "LJ"
    And I set field "beleg" to "!Rückmeldung2^barmex"
    And I set field "artikel" to "EINKAUF-1"
    And I press button "bstart"
    Then table has values
      | art       | amge | detursache            | !row     |
      | EINKAUF-1 | 80   | Rückmeldung Fertigung | !lastRow |
    And I close the current editor

# Bestand von EINKAUF-1 prüfen
    Given I open the infosystem "BESTAND"
    And I set fields
      | artikel | EINKAUF-1 |
      | klplatz | F1        |
      | nullmge | nein      |
      | details | nein      |
    And I press button "bstart"
    Then the table has 0 rows
    And I close the current editor

# Auftrag liefern
    Given I switch the current editor to editor "auftrag" with command "DELIVERY"
    And I set fields
      | vom | .  |
      | ueb | ja |
    And I set field "mge" to "50" in row 1
    And I save the current editor


  Scenario: 17b Noch offenes retrogrades Material wird über letzte Rückmeldung abgebucht - ungerade Mengen, autorm=nein

# Konfiguration autorm=nein
    Given I open an editor "Konfiguration" from table "(Company):(Configuration)" with command "UPDATE" for record "0k"
    And I set fields
      | autorm | nein |
    And I save the current editor

# Baugruppe mit ungerader Menge anlegen
    Given I open an editor "Artikel" from table "(Part):(Product)" with command "NEW" for record ""
    And I create a new row at the end of the table
    And I set field "such" to "EK17B-1"
    And I set field "namebspr" to "Einkaufsteil 17B-1"
    And I set field "bsart" to "Fremdbeschaffung"
    And I set field "rundung" to "1"
    And I save the current editor

    Given I open an editor "Artikel" from table "(Part):(Product)" with command "NEW" for record ""
    And I create a new row at the end of the table
    And I set field "such" to "EK17B-2"
    And I set field "namebspr" to "Einkaufsteil 17B-2"
    And I set field "bsart" to "Fremdbeschaffung"
    And I set field "rundung" to "1"
    And I save the current editor

    Given I open an editor "Artikel" from table "(Part):(Product)" with command "NEW" for record ""
    And I create a new row at the end of the table
    And I set field "such" to "EK17B-3"
    And I set field "namebspr" to "Einkaufsteil 17B-3"
    And I set field "bsart" to "Fremdbeschaffung"
    And I set field "rundung" to "1"
    And I save the current editor

    Given I open an editor "Artikel" from table "(Part):(Product)" with command "NEW" for record ""
    And I create a new row at the end of the table
    And I set field "such" to "EK17B-4"
    And I set field "namebspr" to "Einkaufsteil 17B-4"
    And I set field "bsart" to "Fremdbeschaffung"
    And I set field "rundung" to "0.33"
    And I save the current editor

    Given I open an editor "CPTEIL" from table "(Part):(Product)" with command "COPY" for record "BAUGRUPPE3"
    And I set field "such" to "BG17B"
    And I set field "name" to "Baugruppe Scenario 17b"
    And I modify table
      | !row | elem        | elanzahl | amge        | pverlust    | nutzen      |
      | 3    | !dontChange | 128      | 1           | !dontChange | 1,017       |
      | 5    | !dontChange | 2        | !dontChange | !dontChange | !dontChange |
    And I append rows
      | elem    | elanzahl    | amge        | pverlust    | nutzen      |
      | EK17B-1 | 127         | 2           | !dontChange | 1,567       |
      | EK17B-2 | 2           | 3           | !dontChange | !dontChange |
      | EK17B-3 | 2           | !dontChange | 5           | !dontChange |
      | EK17B-4 | 1           | !dontChange | !dontChange | 0.1725      |
      | A AG3   | !dontChange | !dontChange | !dontChange | !dontChange |
      | EINK    | 1           | !dontChange | !dontChange | !dontChange |
    And I save the current editor

# Fertigungsvorschlag anlegen
    Given I open an editor "FV17B" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
    And I append rows
      | artikel | netmge | bisuch | binoloe | mfreig |
      | BG17B   | 1      | FV17B_ | ja      | ja     |
    And I press button "freig" to open a subeditor for "BA_freigeben"
    And I close the current subeditor to switch back to the parent editor
    And I close the current editor

# Rückmeldung auf den Betriebsauftrag
    Given I open an editor "Rückmeldung1" from table "(Workorder):(WorkOrders)" with command "DONE" for search criteria "$,,such=FV17B_000;@richtung=rückwärts;@maxordtreffer=1"
    And I set field "mgr" to "101"
    And I set field "gut" to "ja"
    And I set field "sofort" to "ja"
    And I save the current editor

# Offene Menge über die FBU prüfen
    Given I open an editor "MatEnt" for tip command "Fbuchung" and arguments ""
    And I set field "auftrag" to "!Rückmeldung1^barmex"
    And I set field "autorment" to "ja"
    And I press button "stllad"
    Then table has values
      | elex      | bumge  | limge  | nlimge |
      | EINKAUF-1 | 1      | 1      | 0      |
      | EINKAUF-2 | 125.86 | 125.86 | 0      |
      | EINKAUF-3 | 2      | 2      | 0      |
      | EK17B-1   | 82     | 82     | 0      |
      | EK17B-2   | 2      | 2      | 0      |
      | EK17B-3   | 3      | 3      | 0      |
      | EK17B-4   | 5.94   | 5.94   | 0      |
      | EINK      | 0      | 0      | 0      |
    And I close the current editor

# BA abschließen - Löschschutz entfernen
    Given I open an editor "BA17B" from table "(Workorder):(WorkOrders)" with command "UPDATE" for search criteria "$,,such=FV17B_000;@richtung=rückwärts;@maxordtreffer=1"
    And I set field "noloesch" to "nein"
    And I save the current editor

# Abschluss-Rückmeldung prüfen
    Given I open an editor "AbschlussRückmeldung" from table "(Workorder):(CompletionConfirmations)" with command "VIEW" for search criteria "$,,such=FV17B_000;@ablage=abgelegt;@richtung=rückwärts;@maxordtreffer=1"
    Then table has values
      | artikel   | mge    | limgev | limgen |
      | BG17B     | 0      | 1      | 1      |
      | EK17B-4   | 5.94   | 5.94   | 0      |
      | EK17B-3   | 3      | 3      | 0      |
      | EINKAUF-3 | 2      | 2      | 0      |
      | EINKAUF-2 | 124.853| 125.86 | 0      |
      | EINKAUF-1 | 1      | 1      | 0      |
    And I close the current editor

# LJ prüfen von FV17B
    Given I open the infosystem "LJ"
    And I set field "beleg" to "!AbschlussRückmeldung^barmex"
    And I press button "bstart"
    Then table has values
      | art       | amge   | zmge | detursache            |
      | EINK      | 1      |      | Rückmeldung Fertigung |
      | EK17B-2   | 5      |      | Rückmeldung Fertigung |
      | EK17B-1   | 84     |      | Rückmeldung Fertigung |
      | EINKAUF-2 | 2.007  |      | Rückmeldung Fertigung |
      | BG17B     |        | 1    | Rückmeldung Fertigung |
      | EK17B-4   | 5.94   |      | Rückmeldung Fertigung |
      | EK17B-3   | 3      |      | Rückmeldung Fertigung |
      | EINKAUF-3 | 2      |      | Rückmeldung Fertigung |
      | EINKAUF-2 | 124.853|      | Rückmeldung Fertigung |
      | EINKAUF-1 | 1      |      | Rückmeldung Fertigung |
    And I close the current editor

# autorm hier nicht zurücksetzen!

  Scenario: 17c Noch offenes retrogrades Material wird über letzte Rückmeldung abgebucht - auf letzten AS wurde weniger entnommen, als auf den Rest, autorm=nein

    Given I open an editor "CPTEIL" from table "(Part):(Product)" with command "COPY" for record "BAUGRUPPE3"
    And I set field "such" to "BG17C"
    And I set field "name" to "Baugruppe Scenario 17c"
    And I delete all rows
    And I append rows
      | elem    | elanzahl |
      | EK17B-1 | 1        |
      | A AG1   | 1        |
      | EK17B-2 | 2        |
      | A AG2   | 1        |
      | EK17B-3 | 3        |
      | A AG3   | 1        |
      | EK17B-4 | 4        |
      | A AG4   | 1        |
    And I save the current editor

# Fertigungsvorschlag anlegen
    Given I open an editor "FV17C" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
    And I append rows
      | artikel | netmge | bisuch | binoloe | mfreig |
      | BG17C   | 55     | FV17C_ | ja      | ja     |
    And I press button "freig" to open a subeditor for "BA_freigeben"
    And I close the current subeditor to switch back to the parent editor
    And I close the current editor

# Rückmeldung auf den 1. Arbeitsschein
    Given I open an editor "Rückmeldung1" from table "(Workorder):(WorkOrders)" with command "DONE" for search criteria "$,,such=FV17C_001;@richtung=rückwärts;@maxordtreffer=1"
    And I set field "sofort" to "ja"
    And I set field "gutmge" to "30" in row 1
    And I set field "verlust" to "3" in row 1
    And I save the current editor

# Rückmeldung auf den 2. Arbeitsschein
    Given I open an editor "Rückmeldung2" from table "(Workorder):(WorkOrders)" with command "DONE" for search criteria "$,,such=FV17C_002;@richtung=rückwärts;@maxordtreffer=1"
    And I set field "sofort" to "ja"
    And I set field "gutmge" to "40" in row 1
    And I set field "verlust" to "4" in row 1
    And I save the current editor

# Rückmeldung auf den 3. Arbeitsschein
    Given I open an editor "Rückmeldung3" from table "(Workorder):(WorkOrders)" with command "DONE" for search criteria "$,,such=FV17C_003;@richtung=rückwärts;@maxordtreffer=1"
    And I set field "sofort" to "ja"
    And I set field "gutmge" to "50" in row 1
    And I set field "verlust" to "5" in row 1
    And I save the current editor

# Rückmeldung auf den 4. Arbeitsschein
    Given I open an editor "Rückmeldung4" from table "(Workorder):(WorkOrders)" with command "DONE" for search criteria "$,,such=FV17C_004;@richtung=rückwärts;@maxordtreffer=1"
    And I set field "sofort" to "ja"
    And I set field "gutmge" to "20" in row 1
    And I set field "verlust" to "2" in row 1
    And I set field "status" to "S" in row 1
    And I respond with answer "ja" to the dialog with id "1483"
    And I save the current editor

# BA abschließen - Löschschutz entfernen
    Given I open an editor "BA17B" from table "(Workorder):(WorkOrders)" with command "UPDATE" for search criteria "$,,such=FV17C_000;@richtung=rückwärts;@maxordtreffer=1"
    And I set field "noloesch" to "nein"
    And I save the current editor

# Abschluss-Rückmeldung prüfen
    Given I open an editor "AbschlussRückmeldung" from table "(Workorder):(CompletionConfirmations)" with command "VIEW" for search criteria "$,,such=FV17C_000;@ablage=abgelegt;@richtung=rückwärts;@maxordtreffer=1"
    Then table has values
      | artikel | mge | limgev | limgen |
      | BG17C   | 0   | 20     | 20     |
      | EK17B-2 | 30  | 30     | 0      |
      | EK17B-1 | 29  | 25     | 0      |
    And I close the current editor

# LJ prüfen von FV17C
    Given I open the infosystem "LJ"
    And I set field "beleg" to "!AbschlussRückmeldung^barmex"
    And I press button "bstart"
    Then table has values
      | art     | amge | zmge | detursache            |
      | EK17B-2 | 30   |      | Rückmeldung Fertigung |
      | EK17B-1 | 29   |      | Rückmeldung Fertigung |
    And I close the current editor

# Konfiguration autorm=ja restaurieren
    Given I open an editor "Konfiguration" from table "(Company):(Configuration)" with command "UPDATE" for record "0k"
    And I set fields
      | autorm | ja |
    And I save the current editor


  Scenario: 18 Noch offenes retrogrades Material wird über letzte Rückmeldung abgebucht, BA mit Löschschutz

# Bestandskorrektur
    Given I set StorageQuantity to zero for Product "EINKAUF-1" on StorageLocation "F1"

# Auftrag anlegen
    Given I create a SalesOrder "auftrag2" for Customer "RADSHOP" with Product "BAUGRUPPE" and quantity "50"

# Material einkaufen
    Given I open an editor "Lieferung" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
    And I set fields
      | lief   | KETTLER  |
      | fakt   | ja       |
      | vom    | .        |
      | ebeleg | Rechnung |
      | ueb    | ja       |
    And I append rows
      | artikel   | mge |
      | EINKAUF-1 | 100 |
      | EINKAUF-2 | 50  |
    And I set field "verw" in row 1 to "verw" from editor "auftrag2" in row 1
    And I respond with answer "ja" to the dialog with id "4841"
    And I save the current editor

# Fertigungsvorschlag anlegen
    Given I open an editor "FV2" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
    And I append rows
      | artikel   | netmge | bisuch | binoloe | mfreig |
      | BAUGRUPPE | 50     | FV2_   | ja      | ja     |
    And I set field "verw" in row !lastRow to "verw" from editor "auftrag2" in row 1
    And I press button "freig" to open a subeditor for "BA_freigeben"
    And I close the current subeditor to switch back to the parent editor
    And I close the current editor

# Rückmeldung auf ersten Arbeitsschein
    Given I open an editor "Rückmeldung1" from table "(Workorder):(WorkOrders)" with command "DONE" for search criteria "$,,such=FV2_001;@richtung=rückwärts;@maxordtreffer=1"
    And I set field "sofort" to "1"
    And I set field "gutmge" to "20" in row 1
    And I save the current editor

# Offene Menge prüfen
    Given I open an editor "BA" from table "(Workorder):(WorkOrders)" with command "VIEW" for search criteria "$,,such=FV2_000;@richtung=rückwärts;@maxordtreffer=1"
    And I press button "absteig" to open a subeditor for "AFL2"
    Then field "limge" has value "60" in row 1
    And I close the current subeditor to switch back to the parent editor
    And I close the current editor

# Materialrückgabe buchen
    Given I open an editor "MatEnt" for tip command "Fbuchung" and arguments ""
    And I set field "auftrag" to "!Rückmeldung1^barmex"
    And I set field "gmgevorschl" to "-10"
    And I set field "autorment" to "ja"
    And I press button "stlvblad"
    And I delete row at position 2
    And I save the current editor

# Offene Menge prüfen
    Given I open an editor "BA" from table "(Workorder):(WorkOrders)" with command "VIEW" for search criteria "$,,such=FV2_000;@richtung=rückwärts;@maxordtreffer=1"
    And I press button "absteig" to open a subeditor for "AFL2"
    Then field "limge" has value "80" in row 1
    And I close the current subeditor to switch back to the parent editor
    And I close the current editor

# Rückmeldung auf ersten Arbeitsschein
    Given I open an editor "Rückmeldung2" from table "(Workorder):(WorkOrders)" with command "DONE" for search criteria "$,,such=FV2_001;@richtung=rückwärts;@maxordtreffer=1"
    And I set field "sofort" to "1"
    And I set field "gutmge" to "30" in row 1
    And I save the current editor

# LJ prüfen von EINKAUF-1
    Given I open the infosystem "LJ"
    And I set field "beleg" to "!Rückmeldung2^barmex"
    And I set field "artikel" to "EINKAUF-1"
    And I press button "bstart"
    Then table has values
      | art       | amge | detursache            | !row     |
      | EINKAUF-1 | 80   | Rückmeldung Fertigung | !lastRow |
    And I close the current editor

# Bestand von EINKAUF-1 prüfen
    Given I open the infosystem "BESTAND"
    And I set fields
      | artikel | EINKAUF-1 |
      | klplatz | F1        |
      | nullmge | nein      |
      | details | nein      |
    And I press button "bstart"
    Then the table has 0 rows
    And I close the current editor

# BA abschließen - Löschschutz entfernen
    Given I open an editor "BA" from table "(Workorder):(WorkOrders)" with command "UPDATE" for search criteria "$,,such=FV2_000;@richtung=rückwärts;@maxordtreffer=1"
    And I set field "noloesch" to "nein"
    And I save the current editor

# Auftrag liefern
    Given I switch the current editor to editor "auftrag2" with command "DELIVERY"
    And I set fields
      | vom | .  |
      | ueb | ja |
    And I set field "mge" to "50" in row 1
    And I save the current editor


  Scenario: 19 Retrogrades Material wird bei Fertigungsmenge reduzieren mit der letzten Rückmeldung entsprechend abgebucht, unterschiedliche Einheiten

# Bestandskorrektur
    Given I set StorageQuantity to zero for Product "GEBINDE" on StorageLocation "F1"
    Given I set StorageQuantity to zero for Product "GEBINDE" on StorageLocation "F2"
    Given I set StorageQuantity to zero for Product "GEBINDEPFL" on StorageLocation "F1"
    Given I set StorageQuantity to zero for Product "GEBINDEPFL" on StorageLocation "F2"

# Auftrag anlegen
    Given I create a SalesOrder "auftrag10" for Customer "RADSHOP" with Product "BG-GEBINDE" and quantity "50"

# Material einkaufen
    Given I open an editor "Lieferung" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
    And I set fields
      | lief   | KETTLER  |
      | fakt   | ja       |
      | vom    | .        |
      | ebeleg | Rechnung |
      | ueb    | ja       |
    And I append rows
      | artikel    | mge |
      | GEBINDE    | 50  |
      | GEBINDEPFL | 50  |
    And I press button "mzsubm" to open a subeditor for "MZ" in row 1
    And I modify table
      | !row | lpsuch | zuomge | einh  |
      | 1    | F1     | 10     | Stück |
      | +2   | F2     | 200    | kg    |
    And I save the current subeditor to switch back to the parent editor
    And I press button "mzsubm" to open a subeditor for "MZ" in row 2
    And I modify table
      | !row | lpsuch | zuomge | einh  |
      | 1    | F1     | 10     | Stück |
      | +2   | F2     | 20     | Paar  |
    And I save the current subeditor to switch back to the parent editor
    And I respond with answer "ja" to the dialog with id "4841"
    And I save the current editor

# Fertigungsvorschlag anlegen
    Given I open an editor "FV10" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
    And I append rows
      | artikel    | netmge | mfreig |
      | BG-GEBINDE | 50     | ja     |
    And I press button "mzabsm" to open a subeditor for "MZ1" in row 1
    And I modify table
      | !row | lpsuch | zuomge | einh  |
      | +1   | F1     | 10     | Stück |
      | +2   | F2     | 200    | kg    |
    And I press button "abv" to open a subeditor for "MZ2"
    And I close the current editor
    And I switch the current editor to editor "MZ1"
    And I modify table
      | !row | lpsuch | zuomge | einh  |
      | +1   | F1     | 10     | Stück |
      | +2   | F2     | 20     | Paar  |
    And I save the current editor
    And I switch the current editor to editor "FV10"
    And I set field "bisuch" to "FV10_" in row 1
    And I press button "freig" to open a subeditor for "BA_freigeben"
    And I close the current subeditor to switch back to the parent editor
    And I close the current editor

# Rückmeldung auf ersten Arbeitsschein
    Given I open an editor "Rückmeldung1" from table "(Workorder):(WorkOrders)" with command "DONE" for search criteria "$,,such=FV10_001;@richtung=rückwärts;@maxordtreffer=1"
    And I set field "sofort" to "ja"
    And I set field "gutmge" to "20" in row 1
    And I save the current editor

# Offene Menge prüfen
    Given I open an editor "BA" from table "(Workorder):(WorkOrders)" with command "VIEW" for search criteria "$,,such=FV10_000;@richtung=rückwärts;@maxordtreffer=1"
    And I press button "absteig" to open a subeditor for "AFL10"
    Then field "limge" has value "30" in row 1
    Then field "limge" has value "30" in row 2
    And I close the current subeditor to switch back to the parent editor
    And I close the current editor

# Materialrückgabe buchen
    Given I open an editor "MatEnt" for tip command "Fbuchung" and arguments ""
    And I set field "auftrag" to "!Rückmeldung1^barmex"
    And I set field "gmgevorschl" to "-15"
    And I set field "autorment" to "ja"
    And I press button "stlvblad"
    And I save the current editor

# Offene Menge prüfen
    Given I open an editor "BA" from table "(Workorder):(WorkOrders)" with command "VIEW" for search criteria "$,,such=FV10_000;@richtung=rückwärts;@maxordtreffer=1"
    And I save value from field "nummer" in row 0
    And I press button "absteig" to open a subeditor for "AFL10"
    Then field "limge" has value "45" in row 1
    Then field "limge" has value "45" in row 2
    And I close the current subeditor to switch back to the parent editor
    And I close the current editor

# Rückmeldung auf ersten Arbeitsschein
    Given I open an editor "Rückmeldung2" from table "(Workorder):(WorkOrders)" with command "DONE" for search criteria "$,,such=FV10_001;@richtung=rückwärts;@maxordtreffer=1"
    And I set field "sofort" to "ja"
    And I set field "mgereduzieren" to "ja"
    And I set field "gutmge" to "25" in row 1
    And I save the current editor

# Prüfen ob FeVo in der Ablage
    Given I open an editor "FV" from table "(Purchasing):(WorkOrderSuggestions)" with command "VIEW" for record ""
    And I set field "artikel" to "BG-GEBINDE"
    And I set field "banummer" in row 0 to saved value
    And I set field "nurablage" to "ja"
    And I press button "ladetab"
    Then the table has 1 rows
    And I close the current editor

# LJ prüfen von GEBINDE
    Given I open the infosystem "LJ"
    And I set field "beleg" to "!Rückmeldung2^barmex"
    And I set field "artikel" to "GEBINDE"
    And I set field "lplatz" to "F1"
    And I press button "bstart"
    Then table has values
      | art     | amge | detursache                 | mei   | !row |
      | GEBINDE | 10   | Rückmeldung Fertigung      | Stück | 1    |
      | GEBINDE | -5   | Materialrückgabe Fertigung | Stück | 2    |
      | GEBINDE | 10   | Rückmeldung Fertigung      | Stück | 3    |
    And I set field "lplatz" to "F2"
    And I press button "bstart"
    Then table has values
      | art     | amge | detursache                 | mei   | !row |
      | GEBINDE | 50   | Rückmeldung Fertigung      | kg    | 1    |
      | GEBINDE | -10  | Materialrückgabe Fertigung | Stück | 2    |
      | GEBINDE | 150  | Rückmeldung Fertigung      | kg    | 3    |
# LJ prüfen von GEBINDEPFL
    And I set field "artikel" to "GEBINDEPFL"
    And I press button "bstart"
    Then table has values
      | art        | amge | detursache                 | mei   | !row |
      | GEBINDEPFL | 5    | Rückmeldung Fertigung      | Paar  | 1    |
      | GEBINDEPFL | -10  | Materialrückgabe Fertigung | Stück | 2    |
      | GEBINDEPFL | 15   | Rückmeldung Fertigung      | Paar  | 3    |
    And I set field "lplatz" to "F1"
    And I press button "bstart"
    Then table has values
      | art        | amge | detursache                 | mei   | !row |
      | GEBINDEPFL | 10   | Rückmeldung Fertigung      | Stück | 1    |
      | GEBINDEPFL | -5   | Materialrückgabe Fertigung | Stück | 2    |
      | GEBINDEPFL | 10   | Rückmeldung Fertigung      | Stück | 3    |
    And I close the current editor

# Bestand von GEBINDE prüfen auf F1
    Given I open the infosystem "BESTAND"
    And I set field "artikel" to "GEBINDE"
    And I set field "klplatz" to "F1"
    And I set field "details" to "nein"
    And I press button "bstart"
    And I press button "taufzu" in row 1
    Then field "gebmge" has value "-5" in row 2
    Then field "geinheit" has value "Stück" in row 2
    Then field "gebf" has value "1" in row 2
# Bestand von GEBINDE prüfen auf F2
    And I set field "klplatz" to "F2"
    And I set field "details" to "nein"
    And I press button "bstart"
    And I press button "taufzu" in row 1
    Then field "gebmge" has value "10" in row 2
    Then field "geinheit" has value "Stück" in row 2
    Then field "gebf" has value "1" in row 2
# Bestand von GEBINDEPFL prüfen auf F2
    And I set field "artikel" to "GEBINDEPFL"
    And I set field "details" to "nein"
    And I press button "bstart"
    And I press button "taufzu" in row 1
    Then field "gebmge" has value "10" in row 2
    Then field "geinheit" has value "Stück" in row 2
    Then field "gebf" has value "1" in row 2
# Bestand von GEBINDEPFL prüfen auf F1
    And I set field "klplatz" to "F1"
    And I set field "details" to "nein"
    And I press button "bstart"
    And I press button "taufzu" in row 1
    Then field "gebmge" has value "-5" in row 2
    Then field "geinheit" has value "Stück" in row 2
    Then field "gebf" has value "1" in row 2
    And I close the current editor

# Auftragsmenge reduzieren
    Given I switch the current editor to editor "auftrag10" with command "UPDATE"
    And I set field "mge" to "45" in row 1
    And I save the current editor

# Auftrag liefern
    Given I switch the current editor to editor "auftrag10" with command "DELIVERY"
    And I set fields
      | vom | .  |
      | ueb | ja |
    And I set field "mge" to "45" in row 1
    And I save the current editor


  Scenario: 20 Noch offenes retrogrades Material wird über letzte Rückmeldung abgebucht, unterschiedliche Einheiten, neue EntnahmeMZ

# Bestandskorrektur
    Given I set StorageQuantity to zero for Product "GEBINDE" on StorageLocation "F1"
    Given I set StorageQuantity to zero for Product "GEBINDE" on StorageLocation "F2"
    Given I set StorageQuantity to zero for Product "GEBINDEPFL" on StorageLocation "F1"
    Given I set StorageQuantity to zero for Product "GEBINDEPFL" on StorageLocation "F2"

# Auftrag anlegen
    Given I create a SalesOrder "auftrag11" for Customer "RADSHOP" with Product "BG-GEBINDE" and quantity "50"

# Material einkaufen
    Given I open an editor "Lieferung" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
    And I set fields
      | lief   | KETTLER  |
      | fakt   | ja       |
      | vom    | .        |
      | ebeleg | Rechnung |
      | ueb    | ja       |
    And I append rows
      | artikel    | mge |
      | GEBINDE    | 50  |
      | GEBINDEPFL | 50  |
    And I press button "mzsubm" to open a subeditor for "MZ" in row 1
    And I modify table
      | !row | lpsuch | zuomge | einh  |
      | 1    | F1     | 10     | Stück |
      | +2   | F2     | 200    | kg    |
    And I save the current subeditor to switch back to the parent editor
    And I press button "mzsubm" to open a subeditor for "MZ" in row 2
    And I modify table
      | !row | lpsuch | zuomge | einh  |
      | 1    | F1     | 10     | Stück |
      | +2   | F2     | 20     | Paar  |
    And I save the current subeditor to switch back to the parent editor
    And I respond with answer "ja" to the dialog with id "4841"
    And I save the current editor

# Fertigungsvorschlag anlegen
    Given I open an editor "FV11" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
    And I append rows
      | artikel    | netmge | mfreig |
      | BG-GEBINDE | 50     | ja     |
    And I press button "mzabsm" to open a subeditor for "MZ1" in row 1
    And I modify table
      | !row | lpsuch | zuomge | einh  |
      | +1   | F1     | 10     | Stück |
      | +2   | F2     | 200    | kg    |
    And I press button "abv" to open a subeditor for "MZ2"
    And I close the current editor
    And I switch the current editor to editor "MZ1"
    And I modify table
      | !row | lpsuch | zuomge | einh  |
      | +1   | F1     | 10     | Stück |
      | +2   | F2     | 20     | Paar  |
    And I save the current editor
    And I switch the current editor to editor "FV11"
    And I set field "bisuch" to "FV11_" in row 1
    And I press button "freig" to open a subeditor for "BA_freigeben"
    And I close the current subeditor to switch back to the parent editor
    And I close the current editor

# Rückmeldung auf ersten Arbeitsschein
    Given I open an editor "Rückmeldung1" from table "(Workorder):(WorkOrders)" with command "DONE" for search criteria "$,,such=FV11_001;@richtung=rückwärts;@maxordtreffer=1"
    And I set field "sofort" to "ja"
    And I set field "gutmge" to "20" in row 1
    And I save the current editor

# Offene Menge prüfen
    Given I open an editor "BA" from table "(Workorder):(WorkOrders)" with command "VIEW" for search criteria "$,,such=FV11_000;@richtung=rückwärts;@maxordtreffer=1"
    And I press button "absteig" to open a subeditor for "AFL11"
    Then field "limge" has value "30" in row 1
    Then field "limge" has value "30" in row 2
    And I close the current subeditor to switch back to the parent editor
    And I close the current editor

# Materialrückgabe buchen
    Given I open an editor "MatEnt" for tip command "Fbuchung" and arguments ""
    And I set field "auftrag" to "!Rückmeldung1^barmex"
    And I set field "gmgevorschl" to "-15"
    And I set field "autorment" to "ja"
    And I press button "stlvblad"
    And I save the current editor

# Offene Menge prüfen
    Given I open an editor "BA" from table "(Workorder):(WorkOrders)" with command "VIEW" for search criteria "$,,such=FV11_000;@richtung=rückwärts;@maxordtreffer=1"
    And I save value from field "nummer" in row 0
    And I press button "absteig" to open a subeditor for "AFL11"
    Then field "limge" has value "45" in row 1
    Then field "limge" has value "45" in row 2
    And I close the current subeditor to switch back to the parent editor
    And I close the current editor

# EntnahmeMZ anpassen
    Given I open an editor "FV" from table "(Purchasing):(WorkOrderSuggestions)" with command "UPDATE" for record ""
    And I set field "artikel" to "BG-GEBINDE"
    And I set field "banummer" in row 0 to saved value
    And I press button "ladetab"
    And I press button "mzabsm" to open a subeditor for "MZ1" in row 1
    And I modify table
      | !row | lpsuch      | zuomge      | einh        |
      | +1   | F1          | 5           | Stück       |
      | 2    | !dontChange | !dontChange | !dontChange |
      | +3   | F2          | 10          | Stück       |
    And I press button "abv" to open a subeditor for "MZ2"
    And I close the current editor
    And I switch the current editor to editor "MZ1"
    And I modify table
      | !row | lpsuch      | zuomge      | einh        |
      | +1   | F1          | 5           | Stück       |
      | 2    | !dontChange | !dontChange | !dontChange |
      | +3   | F2          | 10          | Stück       |
    And I save the current editor
    And I switch the current editor to editor "FV"
    And I save the current editor


# Rückmeldung auf ersten Arbeitsschein
    Given I open an editor "Rückmeldung2" from table "(Workorder):(WorkOrders)" with command "DONE" for search criteria "$,,such=FV11_001;@richtung=rückwärts;@maxordtreffer=1"
    And I set field "sofort" to "ja"
    And I set field "gutmge" to "30" in row 1
    And I save the current editor

# Prüfen ob FeVo in der Ablage
    Given I open an editor "FV" from table "(Purchasing):(WorkOrderSuggestions)" with command "VIEW" for record ""
    And I set field "artikel" to "BG-GEBINDE"
    And I set field "banummer" in row 0 to saved value
    And I set field "nurablage" to "ja"
    And I press button "ladetab"
    Then the table has 1 rows
    And I close the current editor

# LJ prüfen von GEBINDE
    Given I open the infosystem "LJ"
    And I set field "beleg" to "!Rückmeldung2^barmex"
    And I set field "artikel" to "GEBINDE"
    And I set field "lplatz" to "F1"
    And I press button "bstart"
    Then table has values
      | art     | amge | detursache                 | mei   | !row |
      | GEBINDE | 10   | Rückmeldung Fertigung      | Stück | 1    |
      | GEBINDE | -5   | Materialrückgabe Fertigung | Stück | 2    |
      | GEBINDE | 5    | Rückmeldung Fertigung      | Stück | 3    |
    And I set field "lplatz" to "F2"
    And I press button "bstart"
    Then table has values
      | art     | amge | detursache                 | mei   | !row |
      | GEBINDE | 50   | Rückmeldung Fertigung      | kg    | 1    |
      | GEBINDE | -10  | Materialrückgabe Fertigung | Stück | 2    |
      | GEBINDE | 150  | Rückmeldung Fertigung      | kg    | 3    |
      | GEBINDE | 10   | Rückmeldung Fertigung      | Stück | 4    |
# LJ prüfen von GEBINDEPFL
    And I set field "artikel" to "GEBINDEPFL"
    And I press button "bstart"
    Then table has values
      | art        | amge | detursache                 | mei   | !row |
      | GEBINDEPFL | 5    | Rückmeldung Fertigung      | Paar  | 1    |
      | GEBINDEPFL | -10  | Materialrückgabe Fertigung | Stück | 2    |
      | GEBINDEPFL | 15   | Rückmeldung Fertigung      | Paar  | 3    |
      | GEBINDEPFL | 10   | Rückmeldung Fertigung      | Stück | 4    |
    And I set field "lplatz" to "F1"
    And I press button "bstart"
    Then table has values
      | art        | amge | detursache                 | mei   | !row |
      | GEBINDEPFL | 10   | Rückmeldung Fertigung      | Stück | 1    |
      | GEBINDEPFL | -5   | Materialrückgabe Fertigung | Stück | 2    |
      | GEBINDEPFL | 5    | Rückmeldung Fertigung      | Stück | 3    |
    And I close the current editor

# Bestand von GEBINDE prüfen
    Given I open the infosystem "BESTAND"
    And I set field "artikel" to "GEBINDE"
    And I set field "nullmge" to "nein"
    And I set field "details" to "nein"
    And I press button "bstart"
    Then the table has 0 rows
# Bestand von GEBINDEPFL prüfen
    And I set field "artikel" to "GEBINDEPFL"
    And I press button "bstart"
    Then the table has 0 rows
    And I close the current editor

# Auftrag liefern
    Given I switch the current editor to editor "auftrag11" with command "DELIVERY"
    And I set fields
      | vom | .  |
      | ueb | ja |
    And I set field "mge" to "50" in row 1
    And I save the current editor


  Scenario: 21 Noch offenes retrogrades Material wird über letzte Rückmeldung abgebucht, BA mit Löschschutz, unterschiedliche Einheiten

# Bestandskorrektur
    Given I set StorageQuantity to zero for Product "GEBINDE" on StorageLocation "F1"
    Given I set StorageQuantity to zero for Product "GEBINDE" on StorageLocation "F2"
    Given I set StorageQuantity to zero for Product "GEBINDEPFL" on StorageLocation "F1"
    Given I set StorageQuantity to zero for Product "GEBINDEPFL" on StorageLocation "F2"

# Auftrag anlegen
    Given I create a SalesOrder "auftrag12" for Customer "RADSHOP" with Product "BG-GEBINDE" and quantity "50"

# Material einkaufen
    Given I open an editor "Lieferung" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
    And I set fields
      | lief   | KETTLER  |
      | fakt   | ja       |
      | vom    | .        |
      | ebeleg | Rechnung |
      | ueb    | ja       |
    And I append rows
      | artikel    | mge |
      | GEBINDE    | 50  |
      | GEBINDEPFL | 50  |
    And I press button "mzsubm" to open a subeditor for "MZ" in row 1
    And I modify table
      | !row | lpsuch | zuomge | einh  |
      | 1    | F1     | 10     | Stück |
      | +2   | F2     | 200    | kg    |
    And I save the current subeditor to switch back to the parent editor
    And I press button "mzsubm" to open a subeditor for "MZ" in row 2
    And I modify table
      | !row | lpsuch | zuomge | einh  |
      | 1    | F1     | 10     | Stück |
      | +2   | F2     | 20     | Paar  |
    And I save the current subeditor to switch back to the parent editor
    And I respond with answer "ja" to the dialog with id "4841"
    And I save the current editor

# Fertigungsvorschlag anlegen
    Given I open an editor "FV12" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
    And I append rows
      | artikel    | netmge | mfreig |
      | BG-GEBINDE | 50     | ja     |
    And I press button "mzabsm" to open a subeditor for "MZ1" in row 1
    And I modify table
      | !row | lpsuch | zuomge | einh  |
      | +1   | F1     | 10     | Stück |
      | +2   | F2     | 200    | kg    |
    And I press button "abv" to open a subeditor for "MZ2"
    And I close the current editor
    And I switch the current editor to editor "MZ1"
    And I modify table
      | !row | lpsuch | zuomge | einh  |
      | +1   | F1     | 10     | Stück |
      | +2   | F2     | 20     | Paar  |
    And I save the current editor
    And I switch the current editor to editor "FV12"
    And I set field "bisuch" to "FV12_" in row 1
    And I set field "binoloe" to "ja" in row 1
    And I press button "freig" to open a subeditor for "BA_freigeben"
    And I close the current subeditor to switch back to the parent editor
    And I close the current editor

# Rückmeldung auf ersten Arbeitsschein
    Given I open an editor "Rückmeldung1" from table "(Workorder):(WorkOrders)" with command "DONE" for search criteria "$,,such=FV12_001;@richtung=rückwärts;@maxordtreffer=1"
    And I set field "sofort" to "ja"
    And I set field "gutmge" to "20" in row 1
    And I save the current editor

# Offene Menge prüfen
    Given I open an editor "BA" from table "(Workorder):(WorkOrders)" with command "VIEW" for search criteria "$,,such=FV12_000;@richtung=rückwärts;@maxordtreffer=1"
    And I press button "absteig" to open a subeditor for "AFL12"
    Then field "limge" has value "30" in row 1
    Then field "limge" has value "30" in row 2
    And I close the current subeditor to switch back to the parent editor
    And I close the current editor

# Materialrückgabe buchen
    Given I open an editor "MatEnt" for tip command "Fbuchung" and arguments ""
    And I set field "auftrag" to "!Rückmeldung1^barmex"
    And I set field "gmgevorschl" to "-15"
    And I set field "autorment" to "ja"
    And I press button "stlvblad"
    And I save the current editor

# Offene Menge prüfen
    Given I open an editor "BA" from table "(Workorder):(WorkOrders)" with command "VIEW" for search criteria "$,,such=FV12_000;@richtung=rückwärts;@maxordtreffer=1"
    And I save value from field "nummer" in row 0
    And I press button "absteig" to open a subeditor for "AFL12"
    Then field "limge" has value "45" in row 1
    Then field "limge" has value "45" in row 2
    And I close the current subeditor to switch back to the parent editor
    And I close the current editor

# Rückmeldung auf ersten Arbeitsschein
    Given I open an editor "Rückmeldung2" from table "(Workorder):(WorkOrders)" with command "DONE" for search criteria "$,,such=FV12_001;@richtung=rückwärts;@maxordtreffer=1"
    And I set field "sofort" to "ja"
    And I set field "gutmge" to "30" in row 1
    And I save the current editor

# LJ prüfen von GEBINDE
    Given I open the infosystem "LJ"
    And I set field "beleg" to "!Rückmeldung2^barmex"
    And I set field "artikel" to "GEBINDE"
    And I set field "lplatz" to "F1"
    And I press button "bstart"
    Then table has values
      | art     | amge | detursache                 | mei   | !row |
      | GEBINDE | 10   | Rückmeldung Fertigung      | Stück | 1    |
      | GEBINDE | -5   | Materialrückgabe Fertigung | Stück | 2    |
      | GEBINDE | 15   | Rückmeldung Fertigung      | Stück | 3    |
    And I set field "lplatz" to "F2"
    And I press button "bstart"
    Then table has values
      | art     | amge | detursache                 | mei   | !row |
      | GEBINDE | 50   | Rückmeldung Fertigung      | kg    | 1    |
      | GEBINDE | -10  | Materialrückgabe Fertigung | Stück | 2    |
      | GEBINDE | 150  | Rückmeldung Fertigung      | kg    | 3    |
# LJ prüfen von GEBINDEPFL
    And I set field "artikel" to "GEBINDEPFL"
    And I press button "bstart"
    Then table has values
      | art        | amge | detursache                 | mei   | !row |
      | GEBINDEPFL | 5    | Rückmeldung Fertigung      | Paar  | 1    |
      | GEBINDEPFL | -10  | Materialrückgabe Fertigung | Stück | 2    |
      | GEBINDEPFL | 15   | Rückmeldung Fertigung      | Paar  | 3    |
    And I set field "lplatz" to "F1"
    And I press button "bstart"
    Then table has values
      | art        | amge | detursache                 | mei   | !row |
      | GEBINDEPFL | 10   | Rückmeldung Fertigung      | Stück | 1    |
      | GEBINDEPFL | -5   | Materialrückgabe Fertigung | Stück | 2    |
      | GEBINDEPFL | 15   | Rückmeldung Fertigung      | Stück | 3    |
    And I close the current editor

# Bestand von GEBINDE prüfen auf F1
    Given I open the infosystem "BESTAND"
    And I set field "artikel" to "GEBINDE"
    And I set field "klplatz" to "F1"
    And I set field "details" to "nein"
    And I press button "bstart"
    And I press button "taufzu" in row 1
    Then field "gebmge" has value "-10" in row 2
    Then field "geinheit" has value "Stück" in row 2
    Then field "gebf" has value "1" in row 2
# Bestand von GEBINDE prüfen auf F2
    And I set field "klplatz" to "F2"
    And I set field "details" to "nein"
    And I press button "bstart"
    And I press button "taufzu" in row 1
    Then field "gebmge" has value "10" in row 2
    Then field "geinheit" has value "Stück" in row 2
    Then field "gebf" has value "1" in row 2
# Bestand von GEBINDEPFL prüfen auf F2
    And I set field "artikel" to "GEBINDEPFL"
    And I set field "details" to "nein"
    And I press button "bstart"
    And I press button "taufzu" in row 1
    Then field "gebmge" has value "10" in row 2
    Then field "geinheit" has value "Stück" in row 2
    Then field "gebf" has value "1" in row 2
# Bestand von GEBINDEPFL prüfen auf F1
    And I set field "klplatz" to "F1"
    And I set field "details" to "nein"
    And I press button "bstart"
    And I press button "taufzu" in row 1
    Then field "gebmge" has value "-10" in row 2
    Then field "geinheit" has value "Stück" in row 2
    Then field "gebf" has value "1" in row 2
    And I close the current editor


# BA abschließen - Löschschutz entfernen
    Given I open an editor "BA" from table "(Workorder):(WorkOrders)" with command "UPDATE" for search criteria "$,,such=FV12_000;@richtung=rückwärts;@maxordtreffer=1"
    And I set field "noloesch" to "nein"
    And I save the current editor

# Auftrag liefern
    Given I switch the current editor to editor "auftrag12" with command "DELIVERY"
    And I set fields
      | vom | .  |
      | ueb | ja |
    And I set field "mge" to "50" in row 1
    And I save the current editor


  Scenario: 22 Noch offenes retrogrades Material wird über letzte Rückmeldung abgebucht, mit Behälter für gesamtes Material

# Bestandskorrektur
#Given I set StorageQuantity to zero for Product "EINKAUF-1" on StorageLocation "F1"
#Given I set StorageQuantity to zero for Product "EINKAUF-2" on StorageLocation "F1"

# Behälter anlegen
    Given I create a Container "B_MATERIAL_G1" for packaging material "BEHAELTER"

# Auftrag anlegen
    Given I create a SalesOrder "auftrag22" for Customer "RADSHOP" with Product "BAUGRUPPE" and quantity "50"

# Material einkaufen und in den selben Behälter legen
    Given I open an editor "Lieferung" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
    And I set fields
      | lief   | KETTLER  |
      | fakt   | ja       |
      | vom    | .        |
      | ebeleg | Rechnung |
      | ueb    | ja       |
    And I append rows
      | artikel   | mge |
      | EINKAUF-1 | 100 |
      | EINKAUF-2 | 50  |
    And I set field "verw" in row 1 to "verw" from editor "auftrag22" in row 1
    And I set field "verw" in row 2 to "verw" from editor "auftrag22" in row 1
    And I respond with answer "nein" to the dialog with id "Externe Behälternummer ist bereits vergeben."
    And I set field "exbehnum" to "nummer" from editor "B_MATERIAL_G1" in row 1
    And I respond with answer "nein" to the dialog with id "Externe Behälternummer ist bereits vergeben."
    And I set field "exbehnum" to "nummer" from editor "B_MATERIAL_G1" in row 2
    And I respond with answer "ja" to the dialog with id "4841"
    And I save the current editor

# Fertigungsvorschlag anlegen
    Given I open an editor "FV22" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
    And I append rows
      | artikel   | netmge | mfreig |
      | BAUGRUPPE | 50     | ja     |
    And I set field "verw" in row !lastRow to "verw" from editor "auftrag22" in row 1
    And I press button "mzabsm" to open a subeditor for "MZ1" in row 1
    And I modify table
      | !row | zuomge | behaelter                                               |
      | +1   | 100    | $,,such=B_MATERIAL_G1;@richtung=rückwärts;@maxtreffer=1 |
    And I press button "abv" to open a subeditor for "MZ2"
    And I close the current editor
    And I switch the current editor to editor "MZ1"
    And I modify table
      | !row | zuomge | behaelter                                               |
      | +1   | 50     | $,,such=B_MATERIAL_G1;@richtung=rückwärts;@maxtreffer=1 |
    And I save the current editor
    And I switch the current editor to editor "FV22"
    And I set field "bisuch" to "FV22_" in row 1
#And I set field "binoloe" to "ja" in row 1
    And I press button "freig" to open a subeditor for "BA_freigeben"
    And I close the current subeditor to switch back to the parent editor
    And I close the current editor

# Rückmeldung auf ersten Arbeitsschein
    Given I open an editor "Rückmeldung1" from table "(Workorder):(WorkOrders)" with command "DONE" for search criteria "$,,such=FV22_001;@richtung=rückwärts;@maxordtreffer=1"
    And I set field "sofort" to "1"
    And I set field "gutmge" to "20" in row 1
    And I save the current editor

# Inhalt des Behälters prüfen
    And I switch the current editor to editor "B_MATERIAL_G1" with command "VIEW"
    Then the table has 2 rows
    Then table has values
      | artikel   | mge |
      | EINKAUF-1 | 60  |
      | EINKAUF-2 | 30  |
    And I close the current editor

# Materialrückgabe buchen (nicht in den Behälter legen, da retrograd)
    Given I open an editor "MatEnt" for tip command "Fbuchung" and arguments ""
    And I set field "auftrag" to "!Rückmeldung1^barmex"
    And I set field "gmgevorschl" to "-10"
    And I set field "autorment" to "ja"
    And I press button "stlvblad"
    And I delete row at position 2
    And I save the current editor

# BA-Nummer zwischenspeichern
    Given I open an editor "BA" from table "(Workorder):(WorkOrders)" with command "VIEW" for search criteria "$,,such=FV22_000;@richtung=rückwärts;@maxordtreffer=1"
    And I save value from field "nummer" in row 0
    And I close the current editor

# Rückmeldung auf ersten Arbeitsschein
    Given I open an editor "Rückmeldung2" from table "(Workorder):(WorkOrders)" with command "DONE" for search criteria "$,,such=FV22_001;@richtung=rückwärts;@maxordtreffer=1"
    And I set field "sofort" to "1"
    And I set field "gutmge" to "30" in row 1
    And I save the current editor

# Prüfen ob FeVo in der Ablage
    Given I open an editor "FV" from table "(Purchasing):(WorkOrderSuggestions)" with command "VIEW" for record ""
    And I set field "artikel" to "BAUGRUPPE"
    And I set field "banummer" in row 0 to saved value
    And I set field "nurablage" to "ja"
    And I press button "ladetab"
    Then the table has 1 rows
    And I close the current editor

# Prüfen, dass Behälters leer ist
    Then Container from editor "B_MATERIAL_G1" is empty

# LJ prüfen von EINKAUF-1
    Given I open the infosystem "LJ"
    And I set field "beleg" to "!Rückmeldung2^barmex"
    And I set field "artikel" to "EINKAUF-1"
    And I set field "richtung" to "rückwärts"
    And I press button "bstart"
    Then table has values
      | art       | amge | detursache            | !row |
      | EINKAUF-1 | 20   | Rückmeldung Fertigung | 1    |
      | EINKAUF-1 | 60   | Rückmeldung Fertigung | 2    |
    Then field "behaelter^id" in row 2 has value equal to field "id" from editor "B_MATERIAL_G1" in row 0
    And I close the current editor

# LJ prüfen von EINKAUF-2 (es gab keine Materialrückgabe)
    Given I open the infosystem "LJ"
    And I set field "beleg" to "!Rückmeldung2^barmex"
    And I set field "artikel" to "EINKAUF-2"
    And I press button "bstart"
    Then table has values
      | art       | amge | detursache            | !row     |
      | EINKAUF-2 | 30   | Rückmeldung Fertigung | !lastRow |
    Then field "behaelter^id" in row !lastRow has value equal to field "id" from editor "B_MATERIAL_G1" in row 0
    And I close the current editor

# Auftrag liefern
    Given I switch the current editor to editor "auftrag22" with command "DELIVERY"
    And I set fields
      | vom | .  |
      | ueb | ja |
    And I set field "mge" to "50" in row 1
    And I save the current editor


#### Restmengen mitbuchen (manbu Material) und reduzierte Menge (FM reduzieren oder Status setzen) ####

  Scenario: 23 Keine Materialentnahme, Rückmeldung mit Fertigungsmenge reduzieren entnimmt die benötigte Menge des manbu Materials

# Bestandskorrektur
    Given I set StorageQuantity to zero for Product "B_EINKAUF-1" on StorageLocation "F1"
    Given I set StorageQuantity to zero for Product "B_EINKAUF-2" on StorageLocation "F1"

# Auftrag anlegen
    Given I create a SalesOrder "auftrag23" for Customer "RADSHOP" with Product "BM_BAUGRUPPE" and quantity "50"

# Material einkaufen
    Given I open an editor "Lieferung" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
    And I set fields
      | lief   | KETTLER  |
      | fakt   | ja       |
      | vom    | .        |
      | ebeleg | Rechnung |
      | ueb    | ja       |
    And I append rows
      | artikel     | mge |
      | B_EINKAUF-1 | 100 |
      | B_EINKAUF-2 | 50  |
    And I respond with answer "ja" to the dialog with id "4841"
    And I save the current editor

# Fertigungsvorschlag anlegen
    Given I open an editor "FV23" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
    And I append rows
      | artikel      | netmge | mfreig | bisuch |
      | BM_BAUGRUPPE | 50     | ja     | FV23_  |
    And I press button "freig" to open a subeditor for "BA_freigeben"
    And I close the current subeditor to switch back to the parent editor
    And I close the current editor

# Rückmeldung auf ersten Arbeitsschein
    Given I open an editor "Rückmeldung1" from table "(Workorder):(WorkOrders)" with command "DONE" for search criteria "$,,such=FV23_001;@richtung=rückwärts;@maxordtreffer=1"
    And I set field "sofort" to "ja"
    And I set field "gutmge" to "20" in row 1
    And I save the current editor

# Offene Menge prüfen und BA-Nummer zwischenspeichern
    Given I open an editor "BA" from table "(Workorder):(WorkOrders)" with command "VIEW" for search criteria "$,,such=FV23_000;@richtung=rückwärts;@maxordtreffer=1"
    And I save value from field "nummer" in row 0
    And I press button "absteig" to open a subeditor for "AFL23"
    Then field "limge" has value "100" in row 1
    Then field "limge" has value "50" in row 2
    And I close the current subeditor to switch back to the parent editor
    And I close the current editor

# Rückmeldung auf ersten Arbeitsschein, FM reduzieren
    Given I open an editor "Rückmeldung2" from table "(Workorder):(WorkOrders)" with command "DONE" for search criteria "$,,such=FV23_001;@richtung=rückwärts;@maxordtreffer=1"
    And I set field "sofort" to "ja"
    And I set field "mgereduzieren" to "ja"
    And I set field "manrest" to "ja"
    And I set field "gutmge" to "25" in row 1
    And I save the current editor

# Prüfen ob FeVo in der Ablage
    Given I open an editor "FV" from table "(Purchasing):(WorkOrderSuggestions)" with command "VIEW" for record ""
    And I set field "artikel" to "BM_BAUGRUPPE"
    And I set field "banummer" in row 0 to saved value
    And I set field "nurablage" to "ja"
    And I press button "ladetab"
    Then the table has 1 rows
    And I close the current editor

# LJ prüfen von B_EINKAUF-1
    Given I open the infosystem "LJ"
    And I set field "beleg" to "!Rückmeldung2^barmex"
    And I set field "artikel" to "B_EINKAUF-1"
    And I press button "bstart"
    Then table has values
      | art         | amge | detursache            | mei   | !row     |
      | B_EINKAUF-1 | 90   | Rückmeldung Fertigung | Stück | !lastRow |
# LJ prüfen von B_EINKAUF-2
    And I set field "artikel" to "B_EINKAUF-2"
    And I press button "bstart"
    Then table has values
      | art         | amge | detursache            | mei   | !row     |
      | B_EINKAUF-2 | 45   | Rückmeldung Fertigung | Stück | !lastRow |
    And I close the current editor

# Bestand von B_EINKAUF-1 prüfen auf F1
    Given I open the infosystem "BESTAND"
    And I set field "artikel" to "B_EINKAUF-1"
    And I set field "klplatz" to "F1"
    And I set field "details" to "nein"
    And I press button "bstart"
    Then field "lemge" has value "10" in row 1
    And I close the current editor

# Bestand von B_EINKAUF-2 prüfen auf F1
    Given I open the infosystem "BESTAND"
    And I set field "artikel" to "B_EINKAUF-2"
    And I set field "klplatz" to "F1"
    And I set field "details" to "nein"
    And I press button "bstart"
    Then field "lemge" has value "5" in row 1
    And I close the current editor

# Auftragsmenge reduzieren
    Given I switch the current editor to editor "auftrag23" with command "UPDATE"
    And I set field "mge" to "45" in row 1
    And I save the current editor

# Auftrag liefern
    Given I switch the current editor to editor "auftrag23" with command "DELIVERY"
    And I set fields
      | vom | .  |
      | ueb | ja |
    And I set field "mge" to "45" in row 1
    And I save the current editor


  Scenario: 24 Materialentnahme Teilmenge, Rückmeldung mit Fertigungsmenge reduzieren entnimmt die benötigte Menge des manbu Materials

# Bestandskorrektur
    Given I set StorageQuantity to zero for Product "B_EINKAUF-1" on StorageLocation "F1"
    Given I set StorageQuantity to zero for Product "B_EINKAUF-2" on StorageLocation "F1"

# Auftrag anlegen
    Given I create a SalesOrder "auftrag24" for Customer "RADSHOP" with Product "BM_BAUGRUPPE" and quantity "50"

# Material einkaufen
    Given I open an editor "Lieferung" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
    And I set fields
      | lief   | KETTLER  |
      | fakt   | ja       |
      | vom    | .        |
      | ebeleg | Rechnung |
      | ueb    | ja       |
    And I append rows
      | artikel     | mge |
      | B_EINKAUF-1 | 100 |
      | B_EINKAUF-2 | 50  |
    And I respond with answer "ja" to the dialog with id "4841"
    And I save the current editor

# Fertigungsvorschlag anlegen
    Given I open an editor "FV24" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
    And I append rows
      | artikel      | netmge | mfreig | bisuch |
      | BM_BAUGRUPPE | 50     | ja     | FV24_  |
    And I press button "freig" to open a subeditor for "BA_freigeben"
    And I close the current subeditor to switch back to the parent editor
    And I close the current editor

# Materialentnahme buchen
    Given I open an editor "Arbeitsschein1" from table "(Workorder):(WorkOrders)" with command "VIEW" for search criteria "$,,such=FV24_001;@richtung=rückwärts;@maxordtreffer=1"
    And I close the current editor
    Given I open an editor "MatEnt" for tip command "Fbuchung" and arguments ""
    And I set field "auftrag" to "!Arbeitsschein1^nummer"
    And I press button "stlvblad"
    And I set field "bumge" to "40" in row 1
    And I set field "bumge" to "20" in row 2
    And I save the current editor

# Rückmeldung auf ersten Arbeitsschein
    Given I open an editor "Rückmeldung1" from table "(Workorder):(WorkOrders)" with command "DONE" for search criteria "$,,such=FV24_001;@richtung=rückwärts;@maxordtreffer=1"
    And I set field "sofort" to "ja"
    And I set field "gutmge" to "20" in row 1
    And I save the current editor

# Offene Menge prüfen und BA-Nummer zwischenspeichern
    Given I open an editor "BA" from table "(Workorder):(WorkOrders)" with command "VIEW" for search criteria "$,,such=FV24_000;@richtung=rückwärts;@maxordtreffer=1"
    And I save value from field "nummer" in row 0
    And I press button "absteig" to open a subeditor for "AFL24"
    Then field "limge" has value "60" in row 1
    Then field "limge" has value "30" in row 2
    And I close the current subeditor to switch back to the parent editor
    And I close the current editor

# Rückmeldung auf ersten Arbeitsschein, FM reduzieren
    Given I open an editor "Rückmeldung2" from table "(Workorder):(WorkOrders)" with command "DONE" for search criteria "$,,such=FV24_001;@richtung=rückwärts;@maxordtreffer=1"
    And I set field "sofort" to "ja"
    And I set field "mgereduzieren" to "ja"
    And I set field "manrest" to "ja"
    And I set field "gutmge" to "25" in row 1
    And I save the current editor

# Prüfen ob FeVo in der Ablage
    Given I open an editor "FV" from table "(Purchasing):(WorkOrderSuggestions)" with command "VIEW" for record ""
    And I set field "artikel" to "BM_BAUGRUPPE"
    And I set field "banummer" in row 0 to saved value
    And I set field "nurablage" to "ja"
    And I press button "ladetab"
    Then the table has 1 rows
    And I close the current editor

# LJ prüfen von B_EINKAUF-1
    Given I open the infosystem "LJ"
    And I set field "beleg" to "!Rückmeldung2^barmex"
    And I set field "artikel" to "B_EINKAUF-1"
    And I press button "bstart"
    Then table has values
      | art         | amge | detursache            | mei   | !row     |
      | B_EINKAUF-1 | 50   | Rückmeldung Fertigung | Stück | !lastRow |
# LJ prüfen von B_EINKAUF-2
    And I set field "artikel" to "B_EINKAUF-2"
    And I press button "bstart"
    Then table has values
      | art         | amge | detursache            | mei   | !row     |
      | B_EINKAUF-2 | 25   | Rückmeldung Fertigung | Stück | !lastRow |
    And I close the current editor

# Bestand von B_EINKAUF-1 prüfen auf F1
    Given I open the infosystem "BESTAND"
    And I set field "artikel" to "B_EINKAUF-1"
    And I set field "klplatz" to "F1"
    And I set field "details" to "nein"
    And I press button "bstart"
    Then field "lemge" has value "10" in row 1
    And I close the current editor

# Bestand von B_EINKAUF-2 prüfen auf F1
    Given I open the infosystem "BESTAND"
    And I set field "artikel" to "B_EINKAUF-2"
    And I set field "klplatz" to "F1"
    And I set field "details" to "nein"
    And I press button "bstart"
    Then field "lemge" has value "5" in row 1
    And I close the current editor

# Auftragsmenge reduzieren
    Given I switch the current editor to editor "auftrag24" with command "UPDATE"
    And I set field "mge" to "45" in row 1
    And I save the current editor

# Auftrag liefern
    Given I switch the current editor to editor "auftrag24" with command "DELIVERY"
    And I set fields
      | vom | .  |
      | ueb | ja |
    And I set field "mge" to "45" in row 1
    And I save the current editor


  Scenario: 25 Materialentnahme geringere Teilmenge, Rückmeldung mit Fertigungsmenge reduzieren entnimmt die benötigte Menge des manbu Materials

# Bestandskorrektur
    Given I set StorageQuantity to zero for Product "B_EINKAUF-1" on StorageLocation "F1"
    Given I set StorageQuantity to zero for Product "B_EINKAUF-2" on StorageLocation "F1"

# Auftrag anlegen
    Given I create a SalesOrder "auftrag25" for Customer "RADSHOP" with Product "BM_BAUGRUPPE" and quantity "50"

# Material einkaufen
    Given I open an editor "Lieferung" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
    And I set fields
      | lief   | KETTLER  |
      | fakt   | ja       |
      | vom    | .        |
      | ebeleg | Rechnung |
      | ueb    | ja       |
    And I append rows
      | artikel     | mge |
      | B_EINKAUF-1 | 100 |
      | B_EINKAUF-2 | 50  |
    And I respond with answer "ja" to the dialog with id "4841"
    And I save the current editor

# Fertigungsvorschlag anlegen
    Given I open an editor "FV25" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
    And I append rows
      | artikel      | netmge | mfreig | bisuch |
      | BM_BAUGRUPPE | 50     | ja     | FV25_  |
    And I press button "freig" to open a subeditor for "BA_freigeben"
    And I close the current subeditor to switch back to the parent editor
    And I close the current editor

# Materialentnahme buchen
    Given I open an editor "Arbeitsschein1" from table "(Workorder):(WorkOrders)" with command "VIEW" for search criteria "$,,such=FV25_001;@richtung=rückwärts;@maxordtreffer=1"
    And I close the current editor
    Given I open an editor "MatEnt" for tip command "Fbuchung" and arguments ""
    And I set field "auftrag" to "!Arbeitsschein1^nummer"
    And I press button "stlvblad"
    And I set field "bumge" to "30" in row 1
    And I set field "bumge" to "10" in row 2
    And I save the current editor

# Rückmeldung auf ersten Arbeitsschein
    Given I open an editor "Rückmeldung1" from table "(Workorder):(WorkOrders)" with command "DONE" for search criteria "$,,such=FV25_001;@richtung=rückwärts;@maxordtreffer=1"
    And I set field "sofort" to "ja"
    And I set field "gutmge" to "20" in row 1
    And I save the current editor

# Offene Menge prüfen und BA-Nummer zwischenspeichern
    Given I open an editor "BA" from table "(Workorder):(WorkOrders)" with command "VIEW" for search criteria "$,,such=FV25_000;@richtung=rückwärts;@maxordtreffer=1"
    And I save value from field "nummer" in row 0
    And I press button "absteig" to open a subeditor for "AFL25"
    Then field "limge" has value "70" in row 1
    Then field "limge" has value "40" in row 2
    And I close the current subeditor to switch back to the parent editor
    And I close the current editor

# Rückmeldung auf ersten Arbeitsschein, FM reduzieren
    Given I open an editor "Rückmeldung2" from table "(Workorder):(WorkOrders)" with command "DONE" for search criteria "$,,such=FV25_001;@richtung=rückwärts;@maxordtreffer=1"
    And I set field "sofort" to "ja"
    And I set field "mgereduzieren" to "ja"
    And I set field "manrest" to "ja"
    And I set field "gutmge" to "25" in row 1
    And I save the current editor

# Prüfen ob FeVo in der Ablage
    Given I open an editor "FV" from table "(Purchasing):(WorkOrderSuggestions)" with command "VIEW" for record ""
    And I set field "artikel" to "BM_BAUGRUPPE"
    And I set field "banummer" in row 0 to saved value
    And I set field "nurablage" to "ja"
    And I press button "ladetab"
    Then the table has 1 rows
    And I close the current editor

# LJ prüfen von B_EINKAUF-1
    Given I open the infosystem "LJ"
    And I set field "beleg" to "!Rückmeldung2^barmex"
    And I set field "artikel" to "B_EINKAUF-1"
    And I press button "bstart"
    Then table has values
      | art         | amge | detursache            | mei   | !row     |
      | B_EINKAUF-1 | 60   | Rückmeldung Fertigung | Stück | !lastRow |
# LJ prüfen von B_EINKAUF-2
    And I set field "artikel" to "B_EINKAUF-2"
    And I press button "bstart"
    Then table has values
      | art         | amge | detursache            | mei   | !row     |
      | B_EINKAUF-2 | 35   | Rückmeldung Fertigung | Stück | !lastRow |
    And I close the current editor

# Bestand von B_EINKAUF-1 prüfen auf F1
    Given I open the infosystem "BESTAND"
    And I set field "artikel" to "B_EINKAUF-1"
    And I set field "klplatz" to "F1"
    And I set field "details" to "nein"
    And I press button "bstart"
    Then field "lemge" has value "10" in row 1
    And I close the current editor

# Bestand von B_EINKAUF-2 prüfen auf F1
    Given I open the infosystem "BESTAND"
    And I set field "artikel" to "B_EINKAUF-2"
    And I set field "klplatz" to "F1"
    And I set field "details" to "nein"
    And I press button "bstart"
    Then field "lemge" has value "5" in row 1
    And I close the current editor

# Auftragsmenge reduzieren
    Given I switch the current editor to editor "auftrag25" with command "UPDATE"
    And I set field "mge" to "45" in row 1
    And I save the current editor

# Auftrag liefern
    Given I switch the current editor to editor "auftrag25" with command "DELIVERY"
    And I set fields
      | vom | .  |
      | ueb | ja |
    And I set field "mge" to "45" in row 1
    And I save the current editor


  Scenario: 26 Materialentnahme größere Teilmenge, Rückmeldung mit Fertigungsmenge reduzieren entnimmt die benötigte Menge des manbu Materials

# Bestandskorrektur
    Given I set StorageQuantity to zero for Product "B_EINKAUF-1" on StorageLocation "F1"
    Given I set StorageQuantity to zero for Product "B_EINKAUF-2" on StorageLocation "F1"

# Auftrag anlegen
    Given I create a SalesOrder "auftrag26" for Customer "RADSHOP" with Product "BM_BAUGRUPPE" and quantity "50"

# Material einkaufen
    Given I open an editor "Lieferung" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
    And I set fields
      | lief   | KETTLER  |
      | fakt   | ja       |
      | vom    | .        |
      | ebeleg | Rechnung |
      | ueb    | ja       |
    And I append rows
      | artikel     | mge |
      | B_EINKAUF-1 | 100 |
      | B_EINKAUF-2 | 50  |
    And I respond with answer "ja" to the dialog with id "4841"
    And I save the current editor

# Fertigungsvorschlag anlegen
    Given I open an editor "FV26" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
    And I append rows
      | artikel      | netmge | mfreig | bisuch |
      | BM_BAUGRUPPE | 50     | ja     | FV26_  |
    And I press button "freig" to open a subeditor for "BA_freigeben"
    And I close the current subeditor to switch back to the parent editor
    And I close the current editor

# Materialentnahme buchen
    Given I open an editor "Arbeitsschein1" from table "(Workorder):(WorkOrders)" with command "VIEW" for search criteria "$,,such=FV26_001;@richtung=rückwärts;@maxordtreffer=1"
    And I close the current editor
    Given I open an editor "MatEnt" for tip command "Fbuchung" and arguments ""
    And I set field "auftrag" to "!Arbeitsschein1^nummer"
    And I press button "stlvblad"
    And I set field "bumge" to "50" in row 1
    And I set field "bumge" to "25" in row 2
    And I save the current editor

# Rückmeldung auf ersten Arbeitsschein
    Given I open an editor "Rückmeldung1" from table "(Workorder):(WorkOrders)" with command "DONE" for search criteria "$,,such=FV26_001;@richtung=rückwärts;@maxordtreffer=1"
    And I set field "sofort" to "ja"
    And I set field "gutmge" to "20" in row 1
    And I save the current editor

# Offene Menge prüfen und BA-Nummer zwischenspeichern
    Given I open an editor "BA" from table "(Workorder):(WorkOrders)" with command "VIEW" for search criteria "$,,such=FV26_000;@richtung=rückwärts;@maxordtreffer=1"
    And I save value from field "nummer" in row 0
    And I press button "absteig" to open a subeditor for "AFL26"
    Then field "limge" has value "50" in row 1
    Then field "limge" has value "25" in row 2
    And I close the current subeditor to switch back to the parent editor
    And I close the current editor

# Rückmeldung auf ersten Arbeitsschein, FM reduzieren
    Given I open an editor "Rückmeldung2" from table "(Workorder):(WorkOrders)" with command "DONE" for search criteria "$,,such=FV26_001;@richtung=rückwärts;@maxordtreffer=1"
    And I set field "sofort" to "ja"
    And I set field "mgereduzieren" to "ja"
    And I set field "manrest" to "ja"
    And I set field "gutmge" to "25" in row 1
    And I save the current editor

# Prüfen ob FeVo in der Ablage
    Given I open an editor "FV" from table "(Purchasing):(WorkOrderSuggestions)" with command "VIEW" for record ""
    And I set field "artikel" to "BM_BAUGRUPPE"
    And I set field "banummer" in row 0 to saved value
    And I set field "nurablage" to "ja"
    And I press button "ladetab"
    Then the table has 1 rows
    And I close the current editor

# LJ prüfen von B_EINKAUF-1
    Given I open the infosystem "LJ"
    And I set field "beleg" to "!Rückmeldung2^barmex"
    And I set field "artikel" to "B_EINKAUF-1"
    And I press button "bstart"
    Then table has values
      | art         | amge | detursache            | mei   | !row     |
      | B_EINKAUF-1 | 40   | Rückmeldung Fertigung | Stück | !lastRow |
# LJ prüfen von B_EINKAUF-2
    And I set field "artikel" to "B_EINKAUF-2"
    And I press button "bstart"
    Then table has values
      | art         | amge | detursache            | mei   | !row     |
      | B_EINKAUF-2 | 20   | Rückmeldung Fertigung | Stück | !lastRow |
    And I close the current editor

# Bestand von B_EINKAUF-1 prüfen auf F1
    Given I open the infosystem "BESTAND"
    And I set field "artikel" to "B_EINKAUF-1"
    And I set field "klplatz" to "F1"
    And I set field "details" to "nein"
    And I press button "bstart"
    Then field "lemge" has value "10" in row 1
    And I close the current editor

# Bestand von B_EINKAUF-2 prüfen auf F1
    Given I open the infosystem "BESTAND"
    And I set field "artikel" to "B_EINKAUF-2"
    And I set field "klplatz" to "F1"
    And I set field "details" to "nein"
    And I press button "bstart"
    Then field "lemge" has value "5" in row 1
    And I close the current editor

# Auftragsmenge reduzieren
    Given I switch the current editor to editor "auftrag26" with command "UPDATE"
    And I set field "mge" to "45" in row 1
    And I save the current editor

# Auftrag liefern
    Given I switch the current editor to editor "auftrag26" with command "DELIVERY"
    And I set fields
      | vom | .  |
      | ueb | ja |
    And I set field "mge" to "45" in row 1
    And I save the current editor


  Scenario: 27 Materialentnahme Teilmenge, Rückmeldung mit Statuskennzeichen entnimmt die benötigte Menge des manbu Materials

# Bestandskorrektur
    Given I set StorageQuantity to zero for Product "B_EINKAUF-1" on StorageLocation "F1"
    Given I set StorageQuantity to zero for Product "B_EINKAUF-2" on StorageLocation "F1"

# Auftrag anlegen
    Given I create a SalesOrder "auftrag27" for Customer "RADSHOP" with Product "BM_BAUGRUPPE" and quantity "50"

# Material einkaufen
    Given I open an editor "Lieferung" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
    And I set fields
      | lief   | KETTLER  |
      | fakt   | ja       |
      | vom    | .        |
      | ebeleg | Rechnung |
      | ueb    | ja       |
    And I append rows
      | artikel     | mge |
      | B_EINKAUF-1 | 100 |
      | B_EINKAUF-2 | 50  |
    And I respond with answer "ja" to the dialog with id "4841"
    And I save the current editor

# Fertigungsvorschlag anlegen
    Given I open an editor "FV27" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
    And I append rows
      | artikel      | netmge | mfreig | bisuch |
      | BM_BAUGRUPPE | 50     | ja     | FV27_  |
    And I press button "freig" to open a subeditor for "BA_freigeben"
    And I close the current subeditor to switch back to the parent editor
    And I close the current editor

# Materialentnahme buchen
    Given I open an editor "Arbeitsschein1" from table "(Workorder):(WorkOrders)" with command "VIEW" for search criteria "$,,such=FV27_001;@richtung=rückwärts;@maxordtreffer=1"
    And I close the current editor
    Given I open an editor "MatEnt" for tip command "Fbuchung" and arguments ""
    And I set field "auftrag" to "!Arbeitsschein1^nummer"
    And I press button "stlvblad"
    And I set field "bumge" to "40" in row 1
    And I set field "bumge" to "20" in row 2
    And I save the current editor

# Rückmeldung auf ersten Arbeitsschein
    Given I open an editor "Rückmeldung1" from table "(Workorder):(WorkOrders)" with command "DONE" for search criteria "$,,such=FV27_001;@richtung=rückwärts;@maxordtreffer=1"
    And I set field "sofort" to "ja"
    And I set field "gutmge" to "20" in row 1
    And I save the current editor

# Offene Menge prüfen und BA-Nummer zwischenspeichern
    Given I open an editor "BA" from table "(Workorder):(WorkOrders)" with command "VIEW" for search criteria "$,,such=FV27_000;@richtung=rückwärts;@maxordtreffer=1"
    And I save value from field "nummer" in row 0
    And I press button "absteig" to open a subeditor for "AFL27"
    Then field "limge" has value "60" in row 1
    Then field "limge" has value "30" in row 2
    And I close the current subeditor to switch back to the parent editor
    And I close the current editor

# Rückmeldung auf ersten Arbeitsschein, Statuskennzeichen setzen
    Given I open an editor "Rückmeldung2" from table "(Workorder):(WorkOrders)" with command "DONE" for search criteria "$,,such=FV27_001;@richtung=rückwärts;@maxordtreffer=1"
    And I set field "sofort" to "ja"
    And I set field "manrest" to "ja"
    And I set field "gutmge" to "25" in row 1
    And I set field "status" to "S" in row 1
    And I save the current editor

# Prüfen ob FeVo in der Ablage
    Given I open an editor "FV" from table "(Purchasing):(WorkOrderSuggestions)" with command "VIEW" for record ""
    And I set field "artikel" to "BM_BAUGRUPPE"
    And I set field "banummer" in row 0 to saved value
    And I set field "nurablage" to "ja"
    And I press button "ladetab"
    Then the table has 1 rows
    And I close the current editor

# LJ prüfen von B_EINKAUF-1
    Given I open the infosystem "LJ"
    And I set field "beleg" to "!Rückmeldung2^barmex"
    And I set field "artikel" to "B_EINKAUF-1"
    And I press button "bstart"
    Then table has values
      | art         | amge | detursache            | mei   | !row     |
      | B_EINKAUF-1 | 50   | Rückmeldung Fertigung | Stück | !lastRow |
# LJ prüfen von B_EINKAUF-2
    And I set field "artikel" to "B_EINKAUF-2"
    And I press button "bstart"
    Then table has values
      | art         | amge | detursache            | mei   | !row     |
      | B_EINKAUF-2 | 25   | Rückmeldung Fertigung | Stück | !lastRow |
    And I close the current editor

# Bestand von B_EINKAUF-1 prüfen auf F1
    Given I open the infosystem "BESTAND"
    And I set field "artikel" to "B_EINKAUF-1"
    And I set field "klplatz" to "F1"
    And I set field "details" to "nein"
    And I press button "bstart"
    Then field "lemge" has value "10" in row 1
    And I close the current editor

# Bestand von B_EINKAUF-2 prüfen auf F1
    Given I open the infosystem "BESTAND"
    And I set field "artikel" to "B_EINKAUF-2"
    And I set field "klplatz" to "F1"
    And I set field "details" to "nein"
    And I press button "bstart"
    Then field "lemge" has value "5" in row 1
    And I close the current editor

# Auftragsmenge reduzieren
    Given I switch the current editor to editor "auftrag27" with command "UPDATE"
    And I set field "mge" to "45" in row 1
    And I save the current editor

# Auftrag liefern
    Given I switch the current editor to editor "auftrag27" with command "DELIVERY"
    And I set fields
      | vom | .  |
      | ueb | ja |
    And I set field "mge" to "45" in row 1
    And I save the current editor


  Scenario: 28 manbu Material wird bei Fertigungsmenge reduzieren mit der letzten Rückmeldung entsprechend abgebucht, Auslaufartikel wird zuerst verbraucht
# ################################################## #
# Betriebsdatensatz umstellen wegen Auslaufsteuerung #
# ################################################## #
    Given I open an editor "KonfigurationDisposition" from table "(SchedulingConfiguration):(CompanySchedConfig)" with command "UPDATE" for record "SCHEDCONF"
    And I set field "auslaufarteinplan" to "Gemischt einplanen"
    And I save the current editor

##Auslaufartikel und Nachfolgeartikel werden im Scenario Outline vor Scenario 15 bereits angelegt##
## Baugruppe mit Auslaufartikel anlegen, manbu
    Given I open an editor "BG01_SCEN29" from table "(Part):(Product)" with command "STORE" for record "BG01_SCEN29"
    And I set fields
      | dispoa   | bedarfsbezogen                  |
      | bsart    | Eigenfertigung                  |
      | such     | BG01_SCEN29                     |
      | namebspr | Baugruppe mit Auslaufteil manbu |
      | vpr      | 10                              |
    And I modify table
      | !row | elex         | elanzahl | manbu |
      | +1   | B_EINKAUF-1  | 1        | 1     |
      | +2   | EK-1-AUSLAUF | 1        | 1     |
      | +3   | A MONTAGE1   | 1        |       |
    And I save the current editor

# Bestandskorrekturen
    Given I set StorageQuantity to zero for Product "EK-1-AUSLAUF" on StorageLocation "F1"
    Given I set StorageQuantity to zero for Product "EK-1-NACHFOLGER" on StorageLocation "F1"
    Given I set StorageQuantity to zero for Product "BG01_SCEN29" on StorageLocation "F1"

# Bestandszugang Auslaufartikel
    Given I post a receipt via ManualStockAdjustment for Product "EK-1-AUSLAUF" and quantity "40" on StorageLocation "F1" with document "LBU_SCEN29"

# Auftrag anlegen
    Given I create a SalesOrder "auftrag28" for Customer "RADSHOP" with Product "BG01_SCEN29" and quantity "50"

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
      | artikel         | mge |
      | B_EINKAUF-1     | 50  |
      | EK-1-NACHFOLGER | 10  |
    And I respond with answer "ja" to the dialog with id "4841"
    And I save the current editor

# Fertigungsvorschlag anlegen
    Given I open an editor "FV28" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
    And I append rows
      | artikel     | netmge | bisuch | mfreig |
      | BG01_SCEN29 | 50     | FV28_  | ja     |
    And I set field "verw" in row !lastRow to "verw" from editor "auftrag28" in row 1
    And I press button "freig" to open a subeditor for "BA_freigeben"
    And I close the current subeditor to switch back to the parent editor
    And I close the current editor

# Dispo laufen lassen, um Mengen für Auslaufartikel und Nachfolger einzuplanen
    And I run Scheduling

# Materialentnahme buchen
    Given I open an editor "Arbeitsschein1" from table "(Workorder):(WorkOrders)" with command "VIEW" for search criteria "$,,such=FV28_001;@richtung=rückwärts;@maxordtreffer=1"
    And I close the current editor
    Given I open an editor "MatEnt" for tip command "Fbuchung" and arguments ""
    And I set field "auftrag" to "!Arbeitsschein1^nummer"
    And I press button "stlvblad"
    And I set field "bumge" to "20" in row 1
    And I set field "bumge" to "20" in row 2
    And I delete row at position 3
    And I save the current editor

# Rückmeldung auf ersten Arbeitsschein
    Given I open an editor "Rückmeldung1" from table "(Workorder):(WorkOrders)" with command "DONE" for search criteria "$,,such=FV28_001;@richtung=rückwärts;@maxordtreffer=1"
    And I set field "sofort" to "ja"
    And I set field "gutmge" to "20" in row 1
    And I save the current editor

# Offene Menge prüfen des Auslaufartikels (20, da 40 an Lager und 20 verbraucht, Rest Nachfolger)
    Given I open an editor "BA" from table "(Workorder):(WorkOrders)" with command "VIEW" for search criteria "$,,such=FV28_000;@richtung=rückwärts;@maxordtreffer=1"
    And I save value from field "nummer" in row 0
    And I press button "absteig" to open a subeditor for "AFL28"
    Then field "limge" has value "20" in row 2
    And I close the current subeditor to switch back to the parent editor
    And I close the current editor

# Rückmeldung auf ersten Arbeitsschein
    Given I open an editor "Rückmeldung2" from table "(Workorder):(WorkOrders)" with command "DONE" for search criteria "$,,such=FV28_001;@richtung=rückwärts;@maxordtreffer=1"
    And I set field "sofort" to "ja"
    And I set field "mgereduzieren" to "ja"
    And I set field "manrest" to "ja"
    And I set field "gutmge" to "25" in row 1
    And I save the current editor

# Prüfen ob FeVo in der Ablage
    Given I open an editor "FV" from table "(Purchasing):(WorkOrderSuggestions)" with command "VIEW" for record ""
    And I set field "artikel" to "BG01_SCEN29"
    And I set field "banummer" in row 0 to saved value
    And I set field "nurablage" to "ja"
    And I press button "ladetab"
    Then the table has 1 rows
    And I close the current editor

## LJ prüfen von EK-1-AUSLAUF (25 benötigt, restliche werden 20 verbraucht)
    Given I open the infosystem "LJ"
    And I set field "beleg" to "!Rückmeldung2^barmex"
    And I set field "artikel" to "EK-1-AUSLAUF"
    And I press button "bstart"
    Then table has values
      | art          | amge | detursache            | !row     |
      | EK-1-AUSLAUF | 20   | Rückmeldung Fertigung | !lastRow |
# LJ prüfen von EK-1-NACHFOLGER (fehlende 5 Stk entnommen)
    And I set field "artikel" to "EK-1-NACHFOLGER"
    And I press button "bstart"
    Then table has values
      | art             | amge | detursache            | !row     |
      | EK-1-NACHFOLGER | 5    | Rückmeldung Fertigung | !lastRow |
    And I close the current editor

# Bestand von EK-1-AUSLAUF prüfen
    Given I open the infosystem "BESTAND"
    And I set field "artikel" to "EK-1-AUSLAUF"
    And I set field "klplatz" to "F1"
    And I set field "details" to "nein"
    And I press button "bstart"
    Then field "lemge" has value "" in row 1
    And I close the current editor

# Bestand von EK-1-NACHFOLGER prüfen
    Given I open the infosystem "BESTAND"
    And I set field "artikel" to "EK-1-NACHFOLGER"
    And I set field "klplatz" to "F1"
    And I set field "details" to "nein"
    And I press button "bstart"
    Then field "lemge" has value "5" in row 1
    And I close the current editor

# Auftragsmenge reduzieren (um Auftrag abzuschließen)
    Given I switch the current editor to editor "auftrag28" with command "UPDATE"
    And I set field "mge" to "45" in row 1
    And I save the current editor

# Auftrag liefern
    Given I switch the current editor to editor "auftrag28" with command "DELIVERY"
    And I set fields
      | vom | .  |
      | ueb | ja |
    And I set field "mge" to "45" in row 1
    And I save the current editor


  Scenario: 29 manbu Material wird bei Fertigungsmenge reduzieren mit der letzten Rückmeldung entsprechend abgebucht, Auslaufartikel reicht aus
# Betriebsdatensatz wurde bereits in Scenario 28 auf "auslaufarteinplan" = "Gemischt einplanen" umgestellt!

    Given I open an editor "BG01_SCEN29" from table "(Part):(Product)" with command "STORE" for record "BG01_SCEN29"
    And I set fields
      | dispoa   | bedarfsbezogen                  |
      | bsart    | Eigenfertigung                  |
      | such     | BG01_SCEN29                     |
      | namebspr | Baugruppe mit Auslaufteil manbu |
      | vpr      | 10                              |
    And I modify table
      | !row | elex         | elanzahl | manbu |
      | +1   | B_EINKAUF-1  | 1        | 1     |
      | +2   | EK-1-AUSLAUF | 1        | 1     |
      | +3   | A MONTAGE1   | 1        |       |
    And I save the current editor

# Bestandskorrekturen
    Given I set StorageQuantity to zero for Product "EK-1-AUSLAUF" on StorageLocation "F1"
    Given I set StorageQuantity to zero for Product "EK-1-NACHFOLGER" on StorageLocation "F1"
    Given I set StorageQuantity to zero for Product "BG01_SCEN29" on StorageLocation "F1"

# Bestandszugang Auslaufartikel
    Given I post a receipt via ManualStockAdjustment for Product "EK-1-AUSLAUF" and quantity "40" on StorageLocation "F1" with document "LBU_scen29"

# Auftrag anlegen
    Given I create a SalesOrder "auftrag29" for Customer "RADSHOP" with Product "BG01_SCEN29" and quantity "50"

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
      | artikel         | mge |
      | B_EINKAUF-1     | 50  |
      | EK-1-NACHFOLGER | 10  |
    And I respond with answer "ja" to the dialog with id "4841"
    And I save the current editor

# Fertigungsvorschlag anlegen
    Given I open an editor "FV29" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
    And I append rows
      | artikel     | netmge | bisuch | mfreig |
      | BG01_SCEN29 | 50     | FV29_  | ja     |
    And I set field "verw" in row !lastRow to "verw" from editor "auftrag28" in row 1
    And I press button "freig" to open a subeditor for "BA_freigeben"
    And I close the current subeditor to switch back to the parent editor
    And I close the current editor

# Dispo laufen lassen, um Mengen für Auslaufartikel und Nachfolger einzuplanen
    And I run Scheduling

# Materialentnahme buchen
    Given I open an editor "Arbeitsschein1" from table "(Workorder):(WorkOrders)" with command "VIEW" for search criteria "$,,such=FV29_001;@richtung=rückwärts;@maxordtreffer=1"
    And I close the current editor
    Given I open an editor "MatEnt" for tip command "Fbuchung" and arguments ""
    And I set field "auftrag" to "!Arbeitsschein1^nummer"
    And I press button "stlvblad"
    And I set field "bumge" to "20" in row 1
    And I set field "bumge" to "20" in row 2
    And I delete row at position 3
    And I save the current editor

# Rückmeldung auf ersten Arbeitsschein
    Given I open an editor "Rückmeldung1" from table "(Workorder):(WorkOrders)" with command "DONE" for search criteria "$,,such=FV29_001;@richtung=rückwärts;@maxordtreffer=1"
    And I set field "sofort" to "ja"
    And I set field "gutmge" to "20" in row 1
    And I save the current editor

# Offene Menge prüfen des Auslaufartikels (20, da 40 an Lager und 20 verbraucht, Rest Nachfolger)
    Given I open an editor "BA" from table "(Workorder):(WorkOrders)" with command "VIEW" for search criteria "$,,such=FV29_000;@richtung=rückwärts;@maxordtreffer=1"
    And I save value from field "nummer" in row 0
    And I press button "absteig" to open a subeditor for "AFL29"
    Then field "limge" has value "20" in row 2
    And I close the current subeditor to switch back to the parent editor
    And I close the current editor

# Rückmeldung auf ersten Arbeitsschein
    Given I open an editor "Rückmeldung2" from table "(Workorder):(WorkOrders)" with command "DONE" for search criteria "$,,such=FV29_001;@richtung=rückwärts;@maxordtreffer=1"
    And I set field "sofort" to "ja"
    And I set field "mgereduzieren" to "ja"
    And I set field "manrest" to "ja"
    And I set field "gutmge" to "10" in row 1
    And I save the current editor

# Prüfen ob FeVo in der Ablage
    Given I open an editor "FV" from table "(Purchasing):(WorkOrderSuggestions)" with command "VIEW" for record ""
    And I set field "artikel" to "BG01_SCEN29"
    And I set field "banummer" in row 0 to saved value
    And I set field "nurablage" to "ja"
    And I press button "ladetab"
    Then the table has 1 rows
    And I close the current editor

# LJ prüfen von EK-1-AUSLAUF (10 benötigt, Bestand reicht)
    Given I open the infosystem "LJ"
    And I set field "beleg" to "!Rückmeldung2^barmex"
    And I set field "artikel" to "EK-1-AUSLAUF"
    And I press button "bstart"
    Then table has values
      | art          | amge | detursache            | !row     |
      | EK-1-AUSLAUF | 10   | Rückmeldung Fertigung | !lastRow |
# LJ prüfen von EK-1-NACHFOLGER (keine Entnahme)
    And I set field "artikel" to "EK-1-NACHFOLGER"
    And I press button "bstart"
    Then the table has 0 rows
    And I close the current editor

# Bestand von EK-1-AUSLAUF prüfen
    Given I open the infosystem "BESTAND"
    And I set field "artikel" to "EK-1-AUSLAUF"
    And I set field "klplatz" to "F1"
    And I set field "details" to "nein"
    And I press button "bstart"
    Then field "lemge" has value "10" in row 1
    And I close the current editor

# Bestand von EK-1-NACHFOLGER prüfen
    Given I open the infosystem "BESTAND"
    And I set field "artikel" to "EK-1-NACHFOLGER"
    And I set field "klplatz" to "F1"
    And I set field "details" to "nein"
    And I press button "bstart"
    Then field "lemge" has value "10" in row 1
    And I close the current editor

# Auftragsmenge reduzieren (um Auftrag abzuschließen)
    Given I switch the current editor to editor "auftrag29" with command "UPDATE"
    And I set field "mge" to "30" in row 1
    And I save the current editor

# Auftrag liefern
    Given I switch the current editor to editor "auftrag29" with command "DELIVERY"
    And I set fields
      | vom | .  |
      | ueb | ja |
    And I set field "mge" to "30" in row 1
    And I save the current editor


  Scenario: 30 manbu Material wird bei reduzierter Menge und Status setzen mit der letzten Rückmeldung entsprechend abgebucht, Auslaufartikel reicht aus
# Betriebsdatensatz wurde bereits in Scenario 28 auf "auslaufarteinplan" = "Gemischt einplanen" umgestellt!

    Given I open an editor "BG01_SCEN30" from table "(Part):(Product)" with command "STORE" for record "BG01_SCEN30"
    And I set fields
      | dispoa   | bedarfsbezogen                  |
      | bsart    | Eigenfertigung                  |
      | such     | BG01_SCEN30                     |
      | namebspr | Baugruppe mit Auslaufteil manbu |
      | vpr      | 10                              |
    And I modify table
      | !row | elex         | elanzahl | manbu |
      | +1   | B_EINKAUF-1  | 1        | 1     |
      | +2   | EK-1-AUSLAUF | 1        | 1     |
      | +3   | A MONTAGE1   | 1        |       |
    And I save the current editor

# Bestandskorrekturen
    Given I set StorageQuantity to zero for Product "EK-1-AUSLAUF" on StorageLocation "F1"
    Given I set StorageQuantity to zero for Product "EK-1-NACHFOLGER" on StorageLocation "F1"
    Given I set StorageQuantity to zero for Product "BG01_SCEN30" on StorageLocation "F1"

# Bestandszugang Auslaufartikel
    Given I post a receipt via ManualStockAdjustment for Product "EK-1-AUSLAUF" and quantity "40" on StorageLocation "F1" with document "LBU_scen30"

# Auftrag anlegen
    Given I create a SalesOrder "auftrag30" for Customer "RADSHOP" with Product "BG01_SCEN30" and quantity "50"

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
      | artikel         | mge |
      | B_EINKAUF-1     | 50  |
      | EK-1-NACHFOLGER | 10  |
    And I respond with answer "ja" to the dialog with id "4841"
    And I save the current editor

# Fertigungsvorschlag anlegen
    Given I open an editor "FV30" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
    And I append rows
      | artikel     | netmge | bisuch | mfreig |
      | BG01_SCEN30 | 50     | FV30_  | ja     |
    And I set field "verw" in row !lastRow to "verw" from editor "auftrag30" in row 1
    And I press button "freig" to open a subeditor for "BA_freigeben"
    And I close the current subeditor to switch back to the parent editor
    And I close the current editor

# Dispo laufen lassen, um Mengen für Auslaufartikel und Nachfolger einzuplanen
    And I run Scheduling

# Materialentnahme buchen
    Given I open an editor "Arbeitsschein1" from table "(Workorder):(WorkOrders)" with command "VIEW" for search criteria "$,,such=FV30_001;@richtung=rückwärts;@maxordtreffer=1"
    And I close the current editor
    Given I open an editor "MatEnt" for tip command "Fbuchung" and arguments ""
    And I set field "auftrag" to "!Arbeitsschein1^nummer"
    And I press button "stlvblad"
    And I set field "bumge" to "20" in row 1
    And I set field "bumge" to "20" in row 2
    And I delete row at position 3
    And I save the current editor

# Rückmeldung auf ersten Arbeitsschein
    Given I open an editor "Rückmeldung1" from table "(Workorder):(WorkOrders)" with command "DONE" for search criteria "$,,such=FV30_001;@richtung=rückwärts;@maxordtreffer=1"
    And I set field "sofort" to "ja"
    And I set field "gutmge" to "20" in row 1
    And I save the current editor

# Offene Menge prüfen des Auslaufartikels (20, da 40 an Lager und 20 verbraucht, Rest Nachfolger)
    Given I open an editor "BA" from table "(Workorder):(WorkOrders)" with command "VIEW" for search criteria "$,,such=FV30_000;@richtung=rückwärts;@maxordtreffer=1"
    And I save value from field "nummer" in row 0
    And I press button "absteig" to open a subeditor for "AFL30"
    Then field "limge" has value "20" in row 2
    And I close the current subeditor to switch back to the parent editor
    And I close the current editor

# Rückmeldung auf ersten Arbeitsschein
    Given I open an editor "Rückmeldung2" from table "(Workorder):(WorkOrders)" with command "DONE" for search criteria "$,,such=FV30_001;@richtung=rückwärts;@maxordtreffer=1"
    And I set field "sofort" to "ja"
    And I set field "manrest" to "ja"
    And I set field "gutmge" to "10" in row 1
    And I set field "status" to "S" in row 1
    And I save the current editor

# Prüfen ob FeVo in der Ablage
    Given I open an editor "FV" from table "(Purchasing):(WorkOrderSuggestions)" with command "VIEW" for record ""
    And I set field "artikel" to "BG01_SCEN30"
    And I set field "banummer" in row 0 to saved value
    And I set field "nurablage" to "ja"
    And I press button "ladetab"
    Then the table has 1 rows
    And I close the current editor

# LJ prüfen von EK-1-AUSLAUF (10 benötigt, Bestand reicht)
    Given I open the infosystem "LJ"
    And I set field "beleg" to "!Rückmeldung2^barmex"
    And I set field "artikel" to "EK-1-AUSLAUF"
    And I press button "bstart"
    Then table has values
      | art          | amge | detursache            | !row     |
      | EK-1-AUSLAUF | 10   | Rückmeldung Fertigung | !lastRow |
# LJ prüfen von EK-1-NACHFOLGER (keine Entnahme)
    And I set field "artikel" to "EK-1-NACHFOLGER"
    And I press button "bstart"
    Then the table has 0 rows
    And I close the current editor

# Bestand von EK-1-AUSLAUF prüfen
    Given I open the infosystem "BESTAND"
    And I set field "artikel" to "EK-1-AUSLAUF"
    And I set field "klplatz" to "F1"
    And I set field "details" to "nein"
    And I press button "bstart"
    Then field "lemge" has value "10" in row 1
    And I close the current editor

# Bestand von EK-1-NACHFOLGER prüfen
    Given I open the infosystem "BESTAND"
    And I set field "artikel" to "EK-1-NACHFOLGER"
    And I set field "klplatz" to "F1"
    And I set field "details" to "nein"
    And I press button "bstart"
    Then field "lemge" has value "10" in row 1
    And I close the current editor

# Auftragsmenge reduzieren (um Auftrag abzuschließen)
    Given I switch the current editor to editor "auftrag30" with command "UPDATE"
    And I set field "mge" to "30" in row 1
    And I save the current editor

# Auftrag liefern
    Given I switch the current editor to editor "auftrag30" with command "DELIVERY"
    And I set fields
      | vom | .  |
      | ueb | ja |
    And I set field "mge" to "30" in row 1
    And I save the current editor

  Scenario: 30a manbu Material wird bei Rückmeldung mit manrest entsprechend abgebucht, Auslaufartikel reicht aus
# Betriebsdatensatz wurde bereits in Scenario 28 auf "auslaufarteinplan" = "Gemischt einplanen" umgestellt!

    Given I open an editor "BG01_SCEN30A" from table "(Part):(Product)" with command "STORE" for record "BG01_SCEN30A"
    And I set fields
      | dispoa   | bedarfsbezogen                  |
      | bsart    | Eigenfertigung                  |
      | such     | BG01_SCEN30A                    |
      | namebspr | Baugruppe mit Auslaufteil manbu |
      | vpr      | 10                              |
    And I modify table
      | !row | elex         | elanzahl | manbu |
      | +1   | B_EINKAUF-1  | 1        | 1     |
      | +2   | EK-1-AUSLAUF | 1        | 1     |
      | +3   | A MONTAGE1   | 1        |       |
    And I save the current editor

# Bestandskorrekturen
    Given I set StorageQuantity to zero for Product "EK-1-AUSLAUF" on StorageLocation "F1"
    Given I set StorageQuantity to zero for Product "EK-1-NACHFOLGER" on StorageLocation "F1"
    Given I set StorageQuantity to zero for Product "BG01_SCEN30A" on StorageLocation "F1"

# Bestandszugang Auslaufartikel
    Given I post a receipt via ManualStockAdjustment for Product "EK-1-AUSLAUF" and quantity "50" on StorageLocation "F1" with document "LBU_scen30a"

# Auftrag anlegen
    Given I create a SalesOrder "auftr30a" for Customer "RADSHOP" with Product "BG01_SCEN30A" and quantity "20"

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
      | artikel         | mge |
      | B_EINKAUF-1     | 100 |
      | EK-1-NACHFOLGER | 50  |
    And I respond with answer "ja" to the dialog with id "4841"
    And I save the current editor

# Fertigungsvorschlag anlegen
    Given I open an editor "FV30a" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
    And I append rows
      | artikel      | netmge | bisuch | mfreig |
      | BG01_SCEN30A | 20     | FV30a_ | ja     |
    And I set field "verw" in row !lastRow to "verw" from editor "auftr30a" in row 1
    And I press button "absteig" to open a subeditor for "AFL" in row !lastRow
    And I modify table
      | !row | elanzahl |
      | 1    | 5        |
      | 2    | 5        |
    And I save the current editor
    And I switch the current editor to editor "FV30a"
    And I set field "bisuch" to "FV30a_" in row 1
    And I set field "binoloe" to "ja" in row 1
    And I press button "freig" to open a subeditor for "BA_freigeben"
    And I close the current subeditor to switch back to the parent editor
    And I close the current editor

# Dispo laufen lassen, um Mengen für Auslaufartikel und Nachfolger einzuplanen
    And I run Scheduling

# Materialentnahme buchen fuer 6 Stueck Gutmenge
    Given I open an editor "Arbeitsschein1" from table "(Workorder):(WorkOrders)" with command "VIEW" for search criteria "$,,such=FV30a_001;@richtung=rückwärts;@maxordtreffer=1"
    And I close the current editor
    Given I open an editor "MatEnt" for tip command "(WOIssue)" and arguments ""
    And I set fields
      | auftrag | !Arbeitsschein1^nummer |
    And I press button "stlvblad"
    And I modify table
      | !row | elex        | bumge |
      | 1    | !dontChange | 30    |
      | 2    | !dontChange | 10    |
      | 3    | !dontChange | 20    |
    And I save the current editor

# Rückmeldung auf ersten Arbeitsschein, Teilmenge und Restmenge mitbuchen, Material fuer 1 weiteres Stueck wird entnommen
    Given I open an editor "Rückmeldung1" from table "(Workorder):(WorkOrders)" with command "DONE" for search criteria "$,,such=FV30a_001;@richtung=rückwärts;@maxordtreffer=1"
    And I set fields
      | mzeit         | 1  |
      | bzeit         | 1  |
      | sofort        | ja |
      | mgereduzieren | ja |
      | manrest       | ja |
    And I set field "gutmge" to "7" in row 1
    And I save the current editor

# Offene Menge prüfen des Auslaufartikels
    Given I open an editor "BA" from table "(Workorder):(WorkOrders)" with command "VIEW" for search criteria "$,,such=FV30a_000;@richtung=rückwärts;@maxordtreffer=1"
    And I press button "absteig" to open a subeditor for "AFL30a"
    Then field "limge" has value "0" in row 2
    And I close the current subeditor to switch back to the parent editor
    And I close the current editor


# LJ prüfen von EK-1-AUSLAUF (10 benötigt, Bestand reicht)
    Given I open the infosystem "LJ"
    And I set fields
      | beleg    | !Rückmeldung1^barmex |
      | artikel  | EK-1-AUSLAUF         |
      | richtung | rückwärts            |
    And I press button "bstart"
    Then table has values
      | art          | amge | detursache                 |
      | EK-1-AUSLAUF | 5    | Rückmeldung Fertigung      |
      | EK-1-AUSLAUF | 10   | Materialentnahme Fertigung |
# LJ prüfen von EK-1-NACHFOLGER (keine Entnahme)
    And I set field "artikel" to "EK-1-NACHFOLGER"
    And I press button "bstart"
    Then table has values
      | art             | amge | detursache                 |
      | EK-1-NACHFOLGER | 20   | Materialentnahme Fertigung |
    And I close the current editor

# Bestand von EK-1-AUSLAUF prüfen
    Given I open the infosystem "BESTAND"
    And I set field "artikel" to "EK-1-AUSLAUF"
    And I set field "klplatz" to "F1"
    And I set field "details" to "nein"
    And I press button "bstart"
    Then field "lemge" has value "35" in row 1
    And I close the current editor

# Bestand von EK-1-NACHFOLGER prüfen
    Given I open the infosystem "BESTAND"
    And I set field "artikel" to "EK-1-NACHFOLGER"
    And I set field "klplatz" to "F1"
    And I set field "details" to "nein"
    And I press button "bstart"
    Then field "lemge" has value "30" in row 1
    And I close the current editor

## BA abschließen
    Given I open an editor "Rückmeldung1" from table "(Workorder):(WorkOrders)" with command "DONE" for search criteria "$,,such=FV30a_001;@richtung=rückwärts;@maxordtreffer=1"
    And I set fields
      | mzeit   | 1  |
      | bzeit   | 1  |
      | sofort  | ja |
      | gut     | ja |
      | manrest | ja |
    And I save the current editor

# Auftragsmenge auf die gefertigte Menge reduzieren (sonst legt die dispo einen neuen FV an!)
    Given I open an editor "auftr30aUpd" from table "(Sales):(SalesOrder)" with command "UPDATE" for record "auftr30a"
    And I set field "mge" to "7" in row 1
    And I save the current editor

# Auftrag liefern
    And I deliver the SalesOrder "auftr30a" with PackingSlip "liefer30a"


  Scenario: 30b Fertigungsliste mit 2 Arbeitsgängen und 2 Auslaufteilen, manbu, Fertigungsmenge reduzieren
# Betriebsdatensatz wurde bereits in Scenario 28 auf "auslaufarteinplan" = "Gemischt einplanen" umgestellt!

    Given I open an editor "BG_AUSLAUF" from table "(Part):(Product)" with command "STORE" for record "BG_AUSLAUF"
    And I set fields
      | dispoa   | bedarfsbezogen             |
      | bsart    | Eigenfertigung             |
      | such     | BG_AUSLAUF                 |
      | namebspr | BG zwei Auslaufteile manbu |
      | vpr      | 10                         |
    And I modify table
      | !row | elex         | elanzahl | manbu |
      | +1   | EK_AUSLAUF_1 | 1        | 1     |
      | +2   | A MONTAGE1   | 1        |       |
      | +3   | EK_AUSLAUF_2 | 1        | 1     |
      | +4   | A SCHRAUBEN  | 1        |       |

    And I save the current editor

# Bestandskorrekturen
    Given I set StorageQuantity to zero for Product "EK_AUSLAUF_1" on StorageLocation "F1"
    Given I set StorageQuantity to zero for Product "EK_NACH_1" on StorageLocation "F1"
    Given I set StorageQuantity to zero for Product "EK_AUSLAUF_2" on StorageLocation "F1"
    Given I set StorageQuantity to zero for Product "EK_NACH_2" on StorageLocation "F1"
    Given I set StorageQuantity to zero for Product "BG_AUSLAUF" on StorageLocation "F1"

# Bestandszugang Auslaufartikel
    Given I post a receipt via ManualStockAdjustment for Product "EK_AUSLAUF_1" and quantity "5" on StorageLocation "F1" with document "LBU_30b"
    Given I post a receipt via ManualStockAdjustment for Product "EK_AUSLAUF_2" and quantity "7" on StorageLocation "F1" with document "LBU_30b"

# Auftrag anlegen
    Given I create a SalesOrder "auftr30b" for Customer "RADSHOP" with Product "BG_AUSLAUF" and quantity "10"

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
      | EK_NACH_1 | 10  |
      | EK_NACH_2 | 10  |
    And I respond with answer "ja" to the dialog with id "4841"
    And I save the current editor

# Fertigungsvorschlag anlegen
    Given I open an editor "FV30b" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
    And I append rows
      | artikel    | netmge | bisuch | mfreig |
      | BG_AUSLAUF | 10     | FV30b_ | ja     |
    And I set field "verw" in row !lastRow to "verw" from editor "auftr30b" in row 1
    And I press button "freig" to open a subeditor for "BA_freigeben"
    And I close the current subeditor to switch back to the parent editor
    And I close the current editor

# Dispo laufen lassen, um Mengen für Auslaufartikel und Nachfolger einzuplanen
    And I run Scheduling

# AS1 Materialentnahme buchen fuer 3 Stk Gutmenge, Auslaufteil und Nachfolger entnehmen
    Given I open an editor "Arbeitsschein1" from table "(Workorder):(WorkOrders)" with command "VIEW" for search criteria "$,,such=FV30b_001;@richtung=rückwärts;@maxordtreffer=1"
    And I close the current editor
    Given I open an editor "MatEnt" for tip command "(WOIssue)" and arguments ""
    And I set fields
      | auftrag | !Arbeitsschein1^nummer |
    And I press button "stlvblad"
    And I modify table
      | !row | elex        | bumge |
      | 1    | !dontChange | 2     |
      | 2    | !dontChange | 1     |
# Auslaufteil 2 und Nachfolger 1 entnehmen
    And I save the current editor

# AS2 Materialentnahme buchen fuer 4 Stk Gutmenge, Auslaufteil und Nachfolger entnehmen
    Given I open an editor "Arbeitsschein2" from table "(Workorder):(WorkOrders)" with command "VIEW" for search criteria "$,,such=FV30b_002;@richtung=rückwärts;@maxordtreffer=1"
    And I close the current editor
    Given I open an editor "MatEnt" for tip command "(WOIssue)" and arguments ""
    And I set fields
      | auftrag | !Arbeitsschein2^nummer |
    And I press button "stlvblad"
    And I modify table
      | !row | elex        | bumge |
      | 1    | !dontChange | 3     |
      | 2    | !dontChange | 1     |
# Auslaufteil 3 und Nachfolger 1 entnehmen
    And I save the current editor

# Rückmeldung auf ersten Arbeitsschein, Fertigungsmenge reduzieren und Restmenge mitbuchen
    Given I open an editor "Rückmeldung1" from table "(Workorder):(WorkOrders)" with command "DONE" for search criteria "$,,such=FV30b_001;@richtung=rückwärts;@maxordtreffer=1"
    And I set fields
      | sofort        | ja |
      | mgereduzieren | ja |
      | manrest       | ja |
    And I set field "gutmge" to "7" in row 1
    And I save the current editor

# Rückmeldung auf zweiten Arbeitsschein, Fertigungsmenge reduzieren und Restmenge mitbuchen
    Given I open an editor "Rückmeldung2" from table "(Workorder):(WorkOrders)" with command "DONE" for search criteria "$,,such=FV30b_002;@richtung=rückwärts;@maxordtreffer=1"
    And I set fields
      | sofort        | ja |
      | mgereduzieren | ja |
      | manrest       | ja |
    And I set field "gutmge" to "7" in row 1
    And I save the current editor

## LJ prüfen von Auslaufteilen und Nachfolgern
    Given I open the infosystem "LJ"
    And I set field "beleg" to "!Rückmeldung1^barmex"
    And I set field "artikel" to "EK_AUSLAUF_1"
    And I set field "richtung" to "rückwärts"
    And I press button "bstart"
    Then table has values
      | art          | amge | detursache                 |
      | EK_AUSLAUF_1 | 3    | Rückmeldung Fertigung      |
      | EK_AUSLAUF_1 | 2    | Materialentnahme Fertigung |
# LJ prüfen von EK_NACH_1
    And I set field "artikel" to "EK_NACH_1"
    And I press button "bstart"
    Then table has values
      | art       | amge | detursache                 |
      | EK_NACH_1 | 1    | Rückmeldung Fertigung      |
      | EK_NACH_1 | 1    | Materialentnahme Fertigung |
    And I set field "beleg" to "!Rückmeldung2^barmex"
    And I set field "artikel" to "EK_AUSLAUF_2"
    And I press button "bstart"
    Then table has values
      | art          | amge | detursache                 |
      | EK_AUSLAUF_2 | 3    | Rückmeldung Fertigung      |
      | EK_AUSLAUF_2 | 3    | Materialentnahme Fertigung |
# LJ prüfen von EK_NACH_2, nur Materialentnahme, keine Restmenge mitgebucht
    And I set field "artikel" to "EK_NACH_2"
    And I press button "bstart"
    Then table has values
      | art       | amge | detursache                 |
      | EK_NACH_2 | 1    | Materialentnahme Fertigung |
    And I close the current editor

# Bestand von EK_AUSLAUF_1 prüfen, komplett verbraucht
    Given I open the infosystem "BESTAND"
    And I set field "artikel" to "EK_AUSLAUF_1"
    And I set field "klplatz" to "F1"
    And I set field "details" to "nein"
    And I press button "bstart"
    Then field "lemge" has value "" in row 1
    And I close the current editor

# Bestand von EK_AUSLAUF_2 prüfen, 1 Stk. übrig
    Given I open the infosystem "BESTAND"
    And I set field "artikel" to "EK_AUSLAUF_2"
    And I set field "klplatz" to "F1"
    And I set field "details" to "nein"
    And I press button "bstart"
    Then field "lemge" has value "1" in row 1
    And I close the current editor

# Auftragsmenge reduzieren (um Auftrag abzuschließen)
    Given I switch the current editor to editor "auftr30b" with command "UPDATE"
    And I set field "mge" to "7" in row 1
    And I save the current editor

# Auftrag liefern
    And I deliver the SalesOrder "auftr30b" with PackingSlip "liefer30b"


# ############################################################## #
# Betriebsdatensatz wieder zurück umstellen (Auslaufsteuerung)   #
# ############################################################## #
    Given I open an editor "KonfigurationDisposition" from table "(SchedulingConfiguration):(CompanySchedConfig)" with command "UPDATE" for record "SCHEDCONF"
    And I set field "auslaufarteinplan" to "Nicht gemischt einplanen"
    And I save the current editor


  Scenario: 31 Zwei Rückmeldungen auf ersten Arbeitsschein buchen, limgev und limgen bleiben 0
# Auftrag anlegen und Bedarfe einkaufen
    Given I create a SalesOrder "auftrag13" for Customer "RADSHOP" with Product "BAUGRUPPE2" and quantity "50"
    Given I open an editor "Rechnung13" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
    And I set fields
      | lief   | KETTLER |
      | vom    | .       |
      | ueb    | ja      |
      | ebeleg | RR-01   |
    And I modify table
      | !row | artikel   | mge |
      | +1   | EINKAUF-1 | 100 |
      | +2   | EINKAUF-2 | 50  |
    And I respond with answer "ja" to the dialog with id "4841"
    And I save the current editor

# Fertigungsvorschlag anlegen und freigeben
    Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
    And I append rows
      | artikel    | mge | mfreig | bisuch |
      | BAUGRUPPE2 | 50  | ja     | RFV01_ |
    And I press button "freig" to open a subeditor for "fvor_freigeben"
    And I close the current subeditor to switch back to the parent editor
    And I close the current editor

# Teil-Rückmeldungen auf ersten Arbeitsschein buchen
    Given I open an editor "Rückmeldung1_AS1" from table "(Workorder):(WorkOrders)" with command "DONE" for record "RFV01_001"
    And I set fields
      | mzeit  | 5  |
      | bzeit  | 5  |
      | sofort | ja |
    And I set field "gutmge" to "30" in row 1
    And I save the current editor

# Teil-Rückmeldung auf ersten und zweiten Arbeitsschein buchen und prüfen
    Given I open an editor "Rückmeldung2_AS1" from table "(Workorder):(WorkOrders)" with command "DONE" for record "RFV01_001"
    And I set fields
      | mzeit  | 3  |
      | bzeit  | 3  |
      | sofort | ja |
    And I set field "gutmge" to "20" in row 1
    And I save the current editor

    And I switch the current editor to editor "Rückmeldung2_AS1" with command "VIEW"
    Then table has values
      | artikel    | mge | gutmge | bumge | rueckmge | restmge | limgev | limgen | !row |
      | BAUGRUPPE2 | 20  | 20     | 20    | 0        | 20      | 0      | 0      | 1    |
      | EINKAUF-1  | 40  | 0      | 40    | 0        | 40      | 40     | 0      | 2    |
    And I close the current editor

# BA abschließen und liefern
    Given I open an editor "Rückmeldung2_AS2" from table "(Workorder):(WorkOrders)" with command "DONE" for record "RFV01_002"
    And I set fields
      | mzeit  | 6  |
      | bzeit  | 6  |
      | sofort | ja |
      | gut    | ja |
    And I save the current editor

    And I deliver the SalesOrder "auftrag13" with PackingSlip "liefer13"


  Scenario: 32 BA mit noch offenen BDE Vorgängen kann nicht abgeschlossen werden - Löschschutz wird gesetzt

# Mitarbeiter anlegen
    Given I open an editor "mitarbeiter" from table "(Employee):(Employee)" with command "STORE" for record "BDE_MA1"
    And I set fields
      | such  | BDE_MA1 |
      | splan | 303     |
      | lohn  | 1       |
    And I save the current editor

# Fertigungsvorschlag anlegen
    Given I open an editor "LSS_01" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
    And I create a new row at the end of the table
    And I set field "artikel" to "BAUGRUPPE" in row 1
    And I set field "netmge" to "19" in row 1
    And I set field "bisuch" to "LSS01_" in row 1
    And I set field "mfreig" to "ja" in row 1
    And I press button "freig" to open a subeditor for "fv_freigeben"
    And I close the current editor
    And I switch the current editor to editor "LSS_01"
    And I save the current editor

## Loeschschutz im BA pruefen
    Given I open an editor "BA_LSS01" from table "(Workorder):(WorkOrders)" with command "VIEW" for search criteria "$,,such=LSS01_000;@richtung=rückwärts;@maxordtreffer=1"
    Then field "noloesch" has value "nein"
    And I close the current editor

## letzten AS teilweise bebuchen
    Given I open an editor "RM_LSS01" from table "(Workorder):(WorkOrders)" with command "DONE" for record "LSS01_001"
    And I set field "sofort" to "ja"
    And I set field "gutmge" to "9" in row 1
    And I set field "erbtext1" to "RM_LSS01" in row 1
    And I save the current editor

## Kurzläufer erfassen, aber nicht buchen
    Given I open an editor "Kurz1" from table "(PDC):(ShortProductionOrder)" with command "NEW" for record ""
    And I set field "ma" to "BDE_MA1"
    And I set field "asma" to "nummer" from editor "RM_LSS01"
    And I set fields
      | anfdat  | .    |
      | anfzeit | 9:00 |
      | istmge  | 1    |
    And I save the current editor

## letzten AS mit Rest bebuchen - Hinweis erwartet
    Given I open an editor "RM_LSS02" from table "(Workorder):(WorkOrders)" with command "DONE" for record "LSS01_001"
    And I set field "sofort" to "ja"
    And I set field "gut" to "ja"
    And I set field "erbtext1" to "RM_LSS02" in row 1
    And I save the current editor

## Loeschschutz im BA pruefen
    Given I open an editor "BA_LSS02" from table "(Workorder):(WorkOrders)" with command "VIEW" for search criteria "$,,such=LSS01_000;@richtung=rückwärts;@maxordtreffer=1"
    Then field "noloesch" has value "ja"
    And I close the current editor

## Loeschschutz im BA mit offenen BDE Vorgängen entfernen - Fehlermeldung erwartet
    Given I open an editor "BA_LSS03" from table "(Workorder):(WorkOrders)" with command "UPDATE" for search criteria "$,,such=LSS01_000;@richtung=rückwärts;@maxordtreffer=1"
    Then setting field "noloesch" to "nein" throws the exception "10931"
    And I close the current editor

## BDE Vorgang buchen
    Given I switch the current editor to editor "Kurz1" with command "TRANSFER"
    And I save the current editor

# Rückmeldung auf ersten Arbeitsschein buchen
    Given I open an editor "RM_LSS04" from table "(Workorder):(WorkOrders)" with command "TRANSFER" for search criteria "$,,such=LSS01_001;@richtung=rückwärts;@maxordtreffer=1"
    And I save the current editor

## Loeschschutz im BA OHNE offenen BDE Vorgängen entfernen
    Given I open an editor "BA_LSS03" from table "(Workorder):(WorkOrders)" with command "UPDATE" for search criteria "$,,such=LSS01_000;@richtung=rückwärts;@maxordtreffer=1"
    And I set field "noloesch" to "nein"
    And I save the current editor


  Scenario: 33 BA mit noch offenen BDE Vorgängen kann nicht storniert werden

# Fertigungsvorschlag anlegen
    Given I open an editor "BAS_01" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
    And I create a new row at the end of the table
    And I set field "artikel" to "BAUGRUPPE" in row 1
    And I set field "netmge" to "11" in row 1
    And I set field "bisuch" to "BAS01_" in row 1
    And I set field "mfreig" to "ja" in row 1
    And I press button "freig" to open a subeditor for "fv_freigeben"
    And I close the current editor
    And I switch the current editor to editor "BAS_01"
    And I save the current editor

## Loeschschutz im BA pruefen
    Given I open an editor "BA_BAS01" from table "(Workorder):(WorkOrders)" with command "VIEW" for search criteria "$,,such=BAS01_000;@richtung=rückwärts;@maxordtreffer=1"
    Then field "noloesch" has value "nein"
    And I close the current editor

## Kurzläufer erfassen, aber nicht buchen
    Given I open an editor "Kurz1" from table "(PDC):(ShortProductionOrder)" with command "NEW" for record ""
    And I set field "ma" to "BDE_MA1"
    And I set field "asma" to "BAS01_000"
    And I set fields
      | mgr     | 101  |
      | anfdat  | .    |
      | anfzeit | 9:00 |
      | istmge  | 1    |
    And I save the current editor

## Statusfeld im BA setzen (BA stornieren)
    Given I open an editor "BA_BAS03" from table "(Workorder):(WorkOrders)" with command "UPDATE" for search criteria "$,,such=BAS01_000;@richtung=rückwärts;@maxordtreffer=1"
    Then setting field "status" to "S" throws the exception "10931"
    And I close the current editor


# ##################################### #
# Setzen des Flags mgereduzieren testen #
# ##################################### #
  Scenario: 34 Letzter AS bebucht den BA wenn nur nicht relevante Reservierungen am Ende stehen

# Fertigungsvorschlag anlegen
# Nicht relevamten Arbeitsgang und Artikel einfügen
    Given I open an editor "FV34" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
    And I create a new row at the end of the table
    And I set field "artikel" to "BAUGRUPPE" in row 1
    And I set field "netmge" to "38" in row 1
    And I press button "absteig" to open a subeditor for "AFL" in row 1
    Then table has values
      | elex       | manbu       | relevant |
      | EINKAUF-1  | nein        | ja       |
      | EINKAUF-2  | nein        | ja       |
      | A MONTAGE1 | !dontChange | ja       |
    And I create a new row at the end of the table
    And I set field "elex" to "A SCHRAUBEN" in row !lastRow
    And I set field "relevant" to "nein" in row !lastRow
    And I create a new row at the end of the table
    And I set field "elex" to "EINKAUF-3" in row !lastRow
    And I set field "elanzahl" to "1" in row !lastRow
    And I set field "relevant" to "nein" in row !lastRow
    And I save the current subeditor to switch back to the parent editor
    And I set field "bisuch" to "FV34_" in row 1
    And I set field "mfreig" to "ja" in row 1
    And I press button "freig" to open a subeditor for "fv_freigeben"
    And I close the current editor
    And I switch the current editor to editor "FV34"
    And I save the current editor

# Rückmeldung auf ersten Arbeitsschein
    Given I open an editor "Rückmeldung1" from table "(Workorder):(WorkOrders)" with command "DONE" for search criteria "$,,such=FV34_001;@richtung=rückwärts;@maxordtreffer=1"
    And I set field "sofort" to "ja"
    And I set field "gutmge" to "20" in row 1
    And I save the current editor

# Offene Menge prüfen
    Given I open an editor "BA" from table "(Workorder):(WorkOrders)" with command "VIEW" for search criteria "$,,such=FV34_000;@richtung=rückwärts;@maxordtreffer=1"
    Then field "gutmgeauto" has value "20"
    And I close the current editor


# Artikel anlegen für Scenario 36


  Scenario Outline: Baugruppe BG-FERTIGMITTEL mit Fertigungsmittel, zwei Komponenten und zwei Arbeitsgängen
    Given I open an editor "<such>" from table "(Part):(Product)" with command "STORE" for record "<such>"
    And I set fields
      | such     | <such>         |
      | namebspr | <namebspr>     |
      | dispoa   | <dispoa>       |
      | bsart    | Eigenfertigung |
    And I delete all rows
    And I append rows
      | elex    | anzahl    |
      | <elex1> | <anzahl1> |
      | <elex2> | <anzahl2> |
      | <elex3> | <anzahl3> |
      | <elex4> | <anzahl4> |
      | <elex5> | <anzahl5> |
    And I save the current editor
    Examples:
      | such            | namebspr                       | dispoa         | elex1 | anzahl1 | elex2     | anzahl2 | elex3  | anzahl3 | elex4     | anzahl4 | elex5  | anzahl5 |
      | BG-FERTIGMITTEL | Baugruppe mit Fertigungsmittel | bedarfsbezogen | TESTF | 1       | EINKAUF-1 | 1       | A BOHR | 1       | EINKAUF-2 | 1       | A DREH | 1       |

  Scenario: 36 Rückmeldung auf abgelegten FV wenn STL an 1. Pos ein Fertigungsmittel und an letzter Pos einen AG hat (Diag)
# Bestand korrigieren, Auftrag anlegen, Bedarfe einkaufen
    Given I set StorageQuantity to zero for Product "BAUGRUPPE" on StorageLocation "F1"
    Given I create a SalesOrder "auftrag" for Customer "RADSHOP" with Product "BAUGRUPPE" and quantity "10"

# Fertigungsvorschlag anlegen und freigeben
    Given I open an editor "fvor36" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
    And I append rows
      | artikel         | netmge | bisuch | mfreig |
      | BG-FERTIGMITTEL | 10     | FMAG_  | ja     |
    And I press button "freig" to open a subeditor for "BA_freigeben"
    And I close the current editor
    And I switch the current editor to editor "fvor36"
    And I save the current editor

# Materialentnahme und Rueckmeldung ueber gesamte Gutmenge, Buchungseinheiten anpassen
    Given I open an editor "Fbuchung1" for tip command "Fbuchung" and arguments ""
    And I set field "auftrag" to "FMAG_000"
    And I set field "gmgevorschl" to "1"
    And I set field "mgr" to "101"
    And I set field "bem" to "FBU-FMAG"
    And I set field "autorment" to "ja"
    And I press button "stllad"
    And I save the current editor

# Komplettrückmeldung auf ersten Arbeitsgang
    Given I open an editor "Rückmeldung1" from table "(Workorder):(WorkOrders)" with command "DONE" for record "FMAG_000"
    And I set fields
      | mgr    | 101     |
      | sofort | ja      |
      | gut    | ja      |
      | bem    | RM-FMAG |
    And I save the current editor

# Verweise aus RM-Zeilen auf die RES loeschen
    Given I'm logged in with password "annette"
    And I enable the flag 71
    And I execute FOP "RMDELRES.DESTROY"
    And I disable the flag 71
    Given I'm logged in with password "sy"

# Kaputte FBU Rueckmeldung pruefen
    Given I open an editor "FBUPruef1" from table "(Workorder):(CompletionConfirmations)" with command "VIEW" for search criteria "$,,such=FMAG_000;manrm=ja;bem=FBU-FMAG;@ablage=abgelegt;@richtung=rückwärts;@maxordtreffer=1"
    Then the table has 3 rows
    Then table has values
      | artikel         | res^id  |
      | BG-FERTIGMITTEL | (0,0,0) |
      | EINKAUF-2       | (0,0,0) |
      | EINKAUF-1       | (0,0,0) |
    And I close the current editor

# Kaputte Rueckmeldung pruefen
    Given I open an editor "RMPruef1" from table "(Workorder):(CompletionConfirmations)" with command "VIEW" for search criteria "$,,such=FMAG_000;manrm=nein;bem=RM-FMAG;@ablage=abgelegt;@richtung=rückwärts;@maxordtreffer=1"
    Then the table has 3 rows
    Then table has values
      | artikel         | res^id  |
      | BG-FERTIGMITTEL | (0,0,0) |
      | EINKAUF-2       | (0,0,0) |
      | EINKAUF-1       | (0,0,0) |
    And I close the current editor

# Zusaetzliche Gutmenge ueber FBU-RM melden
    Given I open an editor "Fbuchung2" from table "(Workorder):(CompletionConfirmations)" with command "COPY" for search criteria "$,,such=FMAG_000;manrm=ja;bem=FBU-FMAG;@ablage=abgelegt;@richtung=rückwärts;@maxordtreffer=1"
    And I set field "bem" to "FBU-RM auf abgelegten FV"
    And I set field "gutmge" to "3" in row 1
    And I save the current editor

# Zusaetzliche Gutmenge ueber RM melden
##Given I open an editor "Rückmeldung2" via ID from editor "Rückmeldung1" from field "id" in row 0 for table "(Workorder):(CompletionConfirmations)" with command "COPY"
    Given I open an editor "Rückmeldung2" from table "(Workorder):(CompletionConfirmations)" with command "COPY" for search criteria "$,,such=FMAG_000;manrm=nein;bem=RM-FMAG;@ablage=abgelegt;@richtung=rückwärts;@maxordtreffer=1"
    And I set field "bem" to "RM auf abgelegten FV"
    And I set field "gutmge" to "1" in row 1
    And I save the current editor

# Rueckmeldungen pruefen
    Given I open an editor "RMPruef2" via ID from editor "Rückmeldung2" from field "id" in row 0 for table "(Workorder):(CompletionConfirmations)" with command "VIEW"
    Then the table has 3 rows
    Then table has values
      | artikel         | res^elem^such |
      | BG-FERTIGMITTEL |               |
      | EINKAUF-1       | EINKAUF-1     |
      | EINKAUF-2       | EINKAUF-2     |
    And I close the current editor

    Given I open an editor "FBUPruef2" via ID from editor "Fbuchung2" from field "id" in row 0 for table "(Workorder):(CompletionConfirmations)" with command "VIEW"
    Then the table has 3 rows
    Then table has values
      | artikel         | res^elem^such |
      | BG-FERTIGMITTEL |               |
      | EINKAUF-1       | EINKAUF-1     |
      | EINKAUF-2       | EINKAUF-2     |
    And I close the current editor

#################################################################################################
######### FDA-2103 Status des Anwenders erhalten bei weiteren Rückmeldungen #####################

  Scenario: 40 Rückmeldung mit manuell gesetztem Status, danach weitere Buchungen nur Zeit, RM und Zeitbuchung

# Auftrag anlegen
    Given I create a SalesOrder "auftrag40" for Customer "RADSHOP" with Product "BAUGRUPPE2" and quantity "50"

# Material einkaufen
    Given I open an editor "Lieferung" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
    And I set fields
      | lief   | KETTLER  |
      | fakt   | ja       |
      | vom    | .        |
      | ebeleg | Rechnung |
      | ueb    | ja       |
    And I append rows
      | artikel   | mge |
      | EINKAUF-1 | 100 |
      | EINKAUF-2 | 50  |
    And I respond with answer "ja" to the dialog with id "4841"
    And I save the current editor

# Fertigungsvorschlag anlegen
    Given I open an editor "FV40" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
    And I append rows
      | artikel    | netmge | mfreig | bisuch |
      | BAUGRUPPE2 | 50     | ja     | FV40_  |
    And I press button "freig" to open a subeditor for "BA_freigeben"
    And I close the current subeditor to switch back to the parent editor
    And I close the current editor

# Rueckmeldung auf ersten Arbeitsschein, Statuskennzeichen setzen
    Given I open an editor "Rueckmeldung1" from table "(Workorder):(WorkOrders)" with command "DONE" for search criteria "$,,such=FV40_001;@richtung=rückwärts;@maxordtreffer=1"
    And I set fields
      | mzeit  | 2  |
      | bzeit  | 2  |
      | sofort | ja |
    And I modify table
      | !row | gutmge | status |
      | 1    | 40     | M      |
    And I save the current editor

# Offene Menge prüfen, Zeile 1 Material zu AS1 und Zeile 2 AG1
    Given I open an editor "BA" from table "(Workorder):(WorkOrders)" with command "VIEW" for search criteria "$,,such=FV40_000;@richtung=rückwärts;@maxordtreffer=1"
    And I press button "absteig" to open a subeditor for "AFL36"
    Then field "limge" has value "20" in row 1
    Then field "frgmge" has value "0" in row 1
    Then field "limge" has value "10" in row 2
    Then field "frgmge" has value "0" in row 2
    And I close the current subeditor to switch back to the parent editor
    And I close the current editor

# Rueckmeldung auf zweiten Arbeitsschein
    Given I open an editor "Rueckmeldung2" from table "(Workorder):(WorkOrders)" with command "DONE" for search criteria "$,,such=FV40_002;@richtung=rückwärts;@maxordtreffer=1"
    And I set fields
      | mzeit  | 2  |
      | bzeit  | 2  |
      | sofort | ja |
    And I set field "gutmge" to "40" in row 1
    And I save the current editor

# Rueckmeldung auf ersten Arbeitsschein, nur Zeit, Statuskennzeichen pruefen
    Given I open an editor "Rueckmeldung1" from table "(Workorder):(WorkOrders)" with command "DONE" for search criteria "$,,such=FV40_001;@richtung=rückwärts;@maxordtreffer=1"
    And I set fields
      | mzeit  | 1  |
      | bzeit  | 1  |
      | sofort | ja |
    Then field "status" has value "M" in row 1
    And I save the current editor

# Status im Arbeitsschein pruefen
    Given I open an editor "AS" from table "(Workorder):(WorkOrders)" with command "VIEW" for search criteria "$,,such=FV40_001;@richtung=rückwärts;@maxordtreffer=1"
    Then field "status" has value "M"
    And I close the current editor

## Auftragszeit buchen fuer ersten Arbeitsschein
# Mitarbeiter anlegen
    Given I open an editor "mitarbeiter" from table "(Employee):(Employee)" with command "STORE" for record "MA1_BDE"
    And I set fields
      | such  | MA1_BDE |
      | splan | 303     |
      | lohn  | 1       |
    And I save the current editor

# Personalzeit anlegen
    Given I open an editor "Personalzeit1" from table "(PDC):(TimeAndLaborData)" with command "STORE" for search criteria "$,,ma=MA1_BDE;@richtung=rückwärts;@maxtreffer=1"
    And I set field "ma" to "MA1_BDE"
    And I set fields
      | anfdat  | .     |
      | anfzeit | 8:00  |
      | enddat  | .     |
      | endzeit | 16:00 |
    And I save the current editor

# Auftragszeit buchen
    Given I open an editor "Auftragszeit" from table "(PDC):(OrderTime)" with command "NEW" for record ""
    And I set field "ma" to "MA1_BDE"
    And I set field "asma" to "barmex" from editor "Rueckmeldung1"
    And I set fields
      | anfdat  | .     |
      | anfzeit | 10:00 |
      | enddat  | .     |
      | endzeit | 10:45 |
    And I save the current editor

# Status im Arbeitsschein pruefen
    Given I open an editor "AS" from table "(Workorder):(WorkOrders)" with command "VIEW" for search criteria "$,,such=FV40_001;@richtung=rückwärts;@maxordtreffer=1"
    Then field "status" has value "M"
    And I close the current editor

# BA abschließen durch Rueckmeldung auf Arbeitsschein 2
    Given I open an editor "Rueckmeldung2" from table "(Workorder):(WorkOrders)" with command "DONE" for search criteria "$,,such=FV40_002;@richtung=rückwärts;@maxordtreffer=1"
    And I set fields
      | mzeit  | 1  |
      | bzeit  | 1  |
      | sofort | ja |
      | gut    | ja |
    And I save the current editor

# Auftrag liefern
    And I deliver the SalesOrder "auftrag40" with PackingSlip "LS-S36"

#############################################################################################################

  Scenario: 41 Rückmeldung mit manuell gesetztem Status, dann RM mit negativer Gutmenge, Status bleibt erhalten

# Auftrag anlegen
    Given I create a SalesOrder "auftrag41" for Customer "RADSHOP" with Product "BAUGRUPPE2" and quantity "50"

# Material einkaufen
    Given I open an editor "Lieferung" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
    And I set fields
      | lief   | KETTLER  |
      | fakt   | ja       |
      | vom    | .        |
      | ebeleg | Rechnung |
      | ueb    | ja       |
    And I append rows
      | artikel   | mge |
      | EINKAUF-1 | 100 |
      | EINKAUF-2 | 50  |
    And I respond with answer "ja" to the dialog with id "4841"
    And I save the current editor

# Fertigungsvorschlag anlegen
    Given I open an editor "FV41" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
    And I append rows
      | artikel    | netmge | mfreig | bisuch |
      | BAUGRUPPE2 | 50     | ja     | FV41_  |
    And I press button "freig" to open a subeditor for "BA_freigeben"
    And I close the current subeditor to switch back to the parent editor
    And I close the current editor

# Rueckmeldung auf ersten Arbeitsschein, Statuskennzeichen setzen
    Given I open an editor "Rueckmeldung1" from table "(Workorder):(WorkOrders)" with command "DONE" for search criteria "$,,such=FV41_001;@richtung=rückwärts;@maxordtreffer=1"
    And I set fields
      | mzeit  | 2  |
      | bzeit  | 2  |
      | sofort | ja |
    And I modify table
      | !row | gutmge | status |
      | 1    | 40     | M      |
    And I save the current editor

# Rueckmeldung auf zweiten Arbeitsschein
    Given I open an editor "Rueckmeldung2" from table "(Workorder):(WorkOrders)" with command "DONE" for search criteria "$,,such=FV41_002;@richtung=rückwärts;@maxordtreffer=1"
    And I set fields
      | mzeit  | 2  |
      | bzeit  | 2  |
      | sofort | ja |
    And I set field "gutmge" to "40" in row 1
    And I save the current editor

# Rueckbau auf ersten Arbeitsschein, Statuskennzeichen pruefen
    Given I open an editor "Rueckbau_AS1" from table "(Workorder):(WorkOrders)" with command "RETURN" for search criteria "$,,such=FV41_001;@richtung=rückwärts;@maxordtreffer=1"
    And I set fields
      | mzeit  | 1  |
      | bzeit  | 1  |
      | sofort | ja |
    And I set field "gutmge" to "-10" in row 1
    Then field "status" has value "M" in row 1
    And I save the current editor

# Status im Arbeitsschein pruefen
    Given I open an editor "AS" from table "(Workorder):(WorkOrders)" with command "VIEW" for search criteria "$,,such=FV41_001;@richtung=rückwärts;@maxordtreffer=1"
    Then field "status" has value "M"
    And I close the current editor

# Rueckmeldung auf ersten Arbeitsschein, Statuskennzeichen entfernen
    Given I open an editor "Rueckmeldung1" from table "(Workorder):(WorkOrders)" with command "DONE" for search criteria "$,,such=FV41_001;@richtung=rückwärts;@maxordtreffer=1"
    And I set fields
      | mzeit  | 2  |
      | bzeit  | 2  |
      | sofort | ja |
    And I modify table
      | !row | gutmge | status |
      | 1    | 15     |        |
    And I save the current editor

# Status ist geleert, im Arbeitsschein pruefen
    Given I open an editor "AS" from table "(Workorder):(WorkOrders)" with command "VIEW" for search criteria "$,,such=FV41_001;@richtung=rückwärts;@maxordtreffer=1"
    Then field "status" is empty
    And I close the current editor

# BA abschließen durch Rueckmeldung auf Arbeitsschein 1 und 2
    Given I open an editor "Rueckmeldung1" from table "(Workorder):(WorkOrders)" with command "DONE" for search criteria "$,,such=FV41_001;@richtung=rückwärts;@maxordtreffer=1"
    And I set fields
      | mzeit  | 1  |
      | bzeit  | 1  |
      | sofort | ja |
      | gut    | ja |
    And I save the current editor

    Given I open an editor "Rueckmeldung2" from table "(Workorder):(WorkOrders)" with command "DONE" for search criteria "$,,such=FV41_002;@richtung=rückwärts;@maxordtreffer=1"
    And I set fields
      | mzeit  | 1  |
      | bzeit  | 1  |
      | sofort | ja |
      | gut    | ja |
    And I save the current editor

# Auftrag liefern
    And I deliver the SalesOrder "auftrag41" with PackingSlip "LS-S37"

#######################################################################################################

  Scenario: 42 Rückmeldung auf BA mit Löschschutz, Status setzen, weitere Gutmenge buchen, Status bleibt

# Auftrag anlegen
    Given I create a SalesOrder "auftrag42" for Customer "RADSHOP" with Product "BAUGRUPPE2" and quantity "50"

# Material einkaufen
    Given I open an editor "Lieferung" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
    And I set fields
      | lief   | KETTLER  |
      | fakt   | ja       |
      | vom    | .        |
      | ebeleg | Rechnung |
      | ueb    | ja       |
    And I append rows
      | artikel   | mge |
      | EINKAUF-1 | 100 |
      | EINKAUF-2 | 50  |
    And I respond with answer "ja" to the dialog with id "4841"
    And I save the current editor

# Fertigungsvorschlag anlegen
    Given I open an editor "FV42" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
    And I append rows
      | artikel    | netmge | mfreig | bisuch | binoloe |
      | BAUGRUPPE2 | 50     | ja     | FV42_  | ja      |
    And I press button "freig" to open a subeditor for "BA_freigeben"
    And I close the current subeditor to switch back to the parent editor
    And I close the current editor

# Rueckmeldung auf BA, Statuskennzeichen setzen
    Given I open an editor "Rueckmeldung1" from table "(Workorder):(WorkOrders)" with command "DONE" for search criteria "$,,such=FV42_000;@richtung=rückwärts;@maxordtreffer=1"
    And I set fields
      | mzeit  | 2      |
      | bzeit  | 2      |
      | lgr    | 1      |
      | mgr    | 112    |
      | sofort | ja     |
      | bem    | RM1_BA |
    And I modify table
      | !row | gutmge | status |
      | 1    | 40     | M      |
    And I save the current editor

# weitere Rueckmeldung auf BA mit gesetztem Status
    Given I open an editor "Rueckmeldung2" from table "(Workorder):(WorkOrders)" with command "DONE" for search criteria "$,,such=FV42_000;@richtung=rückwärts;@maxordtreffer=1"
    And I set fields
      | mzeit  | 2      |
      | bzeit  | 2      |
      | lgr    | 1      |
      | mgr    | 112    |
      | sofort | ja     |
      | bem    | RM2_BA |
    And I set field "gutmge" to "5" in row 1
    Then field "status" has value "M" in row 1
    And I save the current editor

# Status im BA pruefen, M bleibt erhalten, Löschschutz entfernen, um BA abzuschließen
    Given I open an editor "BA" from table "(Workorder):(WorkOrders)" with command "UPDATE" for search criteria "$,,such=FV42_000;@richtung=rückwärts;@maxordtreffer=1"
    Then field "status" has value "M"
    And I set field "noloesch" to "nein"
    And I save the current editor

# Auftrag liefern
    Given I switch the current editor to editor "auftrag42" with command "DELIVERY"
    And I set fields
      | vom | .  |
      | ueb | ja |
    And I set field "mge" to "45" in row 1
    And I save the current editor


#######################################################################################################

  Scenario: 43 Rückmeldung auf BA mit gesetztem Status und Nachbuchen auf abgelegten Fertigungsvorschlag

# Auftrag anlegen
    Given I create a SalesOrder "auftrag43" for Customer "RADSHOP" with Product "BAUGRUPPE2" and quantity "50"

# Material einkaufen
    Given I open an editor "Lieferung" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
    And I set fields
      | lief   | KETTLER  |
      | fakt   | ja       |
      | vom    | .        |
      | ebeleg | Rechnung |
      | ueb    | ja       |
    And I append rows
      | artikel   | mge |
      | EINKAUF-1 | 100 |
      | EINKAUF-2 | 50  |
    And I respond with answer "ja" to the dialog with id "4841"
    And I save the current editor

# Fertigungsvorschlag anlegen
    Given I open an editor "FV43" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
    And I append rows
      | artikel    | netmge | mfreig | bisuch |
      | BAUGRUPPE2 | 50     | ja     | FV43_  |
    And I press button "freig" to open a subeditor for "BA_freigeben"
    And I close the current subeditor to switch back to the parent editor
    And I close the current editor

# BA-Nummer zwischenspeichern
    Given I open an editor "BA" from table "(Workorder):(WorkOrders)" with command "VIEW" for search criteria "$,,such=FV43_000;@richtung=rückwärts;@maxordtreffer=1"
    And I save value from field "nummer" in row 0
    And I close the current editor

# Rueckmeldung auf BA, Statuskennzeichen setzen
    Given I open an editor "Rueckmeldung1" from table "(Workorder):(WorkOrders)" with command "DONE" for search criteria "$,,such=FV43_000;@richtung=rückwärts;@maxordtreffer=1"
    And I set fields
      | mzeit  | 2      |
      | bzeit  | 2      |
      | lgr    | 1      |
      | mgr    | 112    |
      | sofort | ja     |
      | bem    | RM1_BA |
    And I modify table
      | !row | gutmge | status |
      | 1    | 40     | M      |
    And I save the current editor

# Prüfen ob FeVo in der Ablage
    Given I open an editor "FV" from table "(Purchasing):(WorkOrderSuggestions)" with command "VIEW" for record ""
    And I set field "artikel" to "BAUGRUPPE2"
    And I set field "banummer" in row 0 to saved value
    And I set field "nurablage" to "ja"
    And I press button "ladetab"
    Then the table has 1 rows
    And I close the current editor

# Nachbuchen auf abgelegten Fertigungsvorschlag, Status M bleibt erhalten
    Given I open an editor "Rueckmeldung2" via ID from editor "Rueckmeldung1" from field "id" in row 0 for table "(Workorder):(CompletionConfirmations)" with command "COPY"
    And I set field "gutmge" to "5" in row 1
    Then field "status" has value "M" in row 1
    And I save the current editor

# Auftrag liefern
    Given I switch the current editor to editor "auftrag43" with command "DELIVERY"
    And I set fields
      | vom | .  |
      | ueb | ja |
    And I set field "mge" to "45" in row 1
    And I save the current editor

  Scenario: 44 Rückmeldung auf abgelegten FV mit Material von neuem Platz
# Bestand korrigieren, Auftrag anlegen, Bedarfe einkaufen
    Given I set StorageQuantity to zero for Product "BAUGRUPPE" on StorageLocation "F1"
    Given I create a SalesOrder "auftrag" for Customer "RADSHOP" with Product "BAUGRUPPE" and quantity "10"

    Given I open an editor "Lieferung" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
    And I set fields
      | lief   | KETTLER  |
      | fakt   | ja       |
      | vom    | .        |
      | ebeleg | Rechnung |
      | ueb    | ja       |
      | budat  | .        |
    And I append rows
      | artikel   | mge | platz |
      | EINKAUF-1 | 20  | F1    |
      | EINKAUF-2 | 10  | F1    |
      | EINKAUF-2 | 5   | F2    |
      | EINKAUF-3 | 5   | F2    |
    And I set field "verw" in row 1 to "verw" from editor "auftrag" in row 1
    And I set field "verw" in row 2 to "verw" from editor "auftrag" in row 1
    And I set field "verw" in row 2 to "verw" from editor "auftrag" in row 1
    And I respond with answer "ja" to the dialog with id "4841"
    And I save the current editor

# Fertigungsvorschlag anlegen und freigeben
    Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
    And I append rows
      | artikel   | netmge | bisuch   | mfreig |
      | BAUGRUPPE | 10     | NBPLATZ_ | ja     |
    And I set field "verw" in row !lastRow to "verw" from editor "auftrag" in row 1
    And I press button "freig" to open a subeditor for "BA_freigeben"
    And I close the current editor
    And I switch the current editor to editor "fvor"
    And I save the current editor

# Komplettrückmeldung auf ersten Arbeitsgang
    Given I open an editor "Rückmeldung1" from table "(Workorder):(WorkOrders)" with command "DONE" for record "NBPLATZ_001"
    And I set fields
      | sofort | 1 |
      | gut    | 1 |
    And I save the current editor

# Zusätzliche Entnahme melden, anderer Platz
    Given I open an editor "Rückmeldung2" via ID from editor "Rückmeldung1" from field "id" in row 0 for table "(Workorder):(CompletionConfirmations)" with command "COPY"
    And I set field "bumge" to "5" in row 2
    And I set field "buplatz" to "F2" in row 2
    And I append rows
      | artikel   | mge | buplatz |
      | EINKAUF-3 | 5   | F2      |
    And I save the current editor

# Einen Teil wieder zurücklegen, aber auf einen anderen Platz
    Given I open an editor "Rückmeldung3" via ID from editor "Rückmeldung1" from field "id" in row 0 for table "(Workorder):(CompletionConfirmations)" with command "COPY"
    And I set field "bumge" to "-3" in row 2
    And I set field "buplatz" to "F3" in row 2
    And I append rows
      | artikel   | mge | buplatz |
      | EINKAUF-3 | -3  | F3      |
    And I save the current editor

# LJ prüfen, Entnahmeteile habe unterschiedliche Plätze
    Given I open the infosystem "LJ"
    And I set field "beleg" to "nummer" from editor "Rückmeldung1"
    And I set field "richtung" to "rückwärts"
    And I press start
    Then table has values
      | art       | zmge | amge | vplatz |
      | EINKAUF-1 |      | -3   | F3     |
      | EINKAUF-3 |      | -3   | F3     |
      | EINKAUF-1 |      | 5    | F2     |
      | EINKAUF-3 |      | 5    | F2     |
      | BAUGRUPPE | 10   |      |        |
      | EINKAUF-1 |      | 20   | F1     |
      | EINKAUF-2 |      | 10   | F1     |
    And I close the current editor

# Auftrag liefern
    Given I switch the current editor to editor "auftrag" with command "DELIVERY"
    And I set fields
      | vom | .  |
      | ueb | ja |
    And I set field "mge" to "10" in row 1
    And I save the current editor

  Scenario: Baugruppe BAUNOAS, 1 AG kein AS für 45
    Given I open an editor "BAUNOAS" from table "(Part):(Product)" with command "STORE" for record "BAUNOAS"
    And I set fields
      | such     | BAUNOAS                    |
      | namebspr | Einfache Baugruppe ohne AS |
      | dispoa   | bedarfsbezogen             |
      | bsart    | Eigenfertigung             |
      | wgruppe  | 55                         |
      | erlgrp   | 66                         |
    And I delete all rows
    And I append rows
      | elex         | anzahl | manbu |
      | EINKAUF-1    | 1      | ja    |
      | EINKAUF-1    | 1      | ja    |
      | A AG_ohne_AS | 1      |       |
    And I save the current editor


  Scenario: 45 Rückgabe auf FV ohne AS mit doppelten Artikel
# Bestand korrigieren, Auftrag anlegen, Bedarfe einkaufen
    Given I set StorageQuantity to zero for Product "BAUNOAS" on StorageLocation "F1"
    Given I create a SalesOrder "auftrag" for Customer "RADSHOP" with Product "BAUNOAS" and quantity "100"

    Given I open an editor "Lieferung" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
    And I set fields
      | lief   | KETTLER  |
      | fakt   | ja       |
      | vom    | .        |
      | ebeleg | Rechnung |
      | ueb    | ja       |
      | budat  | .        |
    And I append rows
      | artikel   | mge | platz |
      | EINKAUF-1 | 200 | F1    |
    And I respond with answer "ja" to the dialog with id "4841"
    And I save the current editor

# Fertigungsvorschlag anlegen und freigeben
    Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
    And I append rows
      | artikel | netmge | bisuch | mfreig |
      | BAUNOAS | 100    | NOAS_  | ja     |
    And I press button "freig" to open a subeditor for "BA_freigeben"
    And I close the current editor
    And I switch the current editor to editor "fvor"
    And I save the current editor

# Materialentnahme auf BA
    Given I open an editor "Materialentnahme1" for tip command "Fbuchung" and arguments ""
    And I set field "auftrag" to "NOAS_000"
    And I set field "mgr" to "101"
    And I press button "stllad"
    And I set field "bumge" to "30" in row 1
    And I set field "bumge" to "50" in row 2
    And I append rows
      | elex      | bumge |
      | EINKAUF-2 | 10    |
      | EINKAUF-2 | 12    |
    And I save the current editor

# Materialentnahme auf BA
    Given I open an editor "Materialentnahme2" for tip command "Fbuchung" and arguments ""
    And I set field "auftrag" to "NOAS_000"
    And I set field "mgr" to "101"
    And I press button "stllad"
    And I set field "bumge" to "20" in row 1
    And I set field "bumge" to "30" in row 2
    And I set field "bumge" to "10" in row 3
    And I append rows
      | elex      | bumge |
      | EINKAUF-2 | 12    |
    And I save the current editor

# Materialrückgabe auf BA
    Given I open an editor "Materialentnahme2" for tip command "Fbuchung" and arguments ""
    And I set field "auftrag" to "NOAS_000"
    And I set field "mgr" to "101"
    And I press button "stllad"
    And I set field "bumge" to "0" in row 2
    And I set field "bumge" to "-30" in row 1
    And I set field "bumge" to "-50" in row 2
    And I set field "bumge" to "-25" in row 3
    And I save the current editor

# Materialentnahme auf BA
    Given I open an editor "Materialentnahme3" for tip command "Fbuchung" and arguments ""
    And I set field "auftrag" to "NOAS_000"
    And I set field "mgr" to "101"
    And I press button "stllad"
    And I save the current editor

# Komplettrückmeldung auf ersten Arbeitsgang
    Given I open an editor "Rückmeldung1" from table "(Workorder):(WorkOrders)" with command "DONE" for record "NOAS_000"
    And I set fields
      | sofort | 1   |
      | gut    | 1   |
      | mgr    | 101 |
    And I save the current editor

# LJ prüfen, Entnahmeteile habe unterschiedliche Plätze
    Given I open the infosystem "LJ"
    And I set field "beleg" to "nummer" from editor "Rückmeldung1"
    And I set field "richtung" to "rückwärts"
    And I press start
    Then table has values
      | art       | amge | vplatz |
      | BAUNOAS   |      |        |
      | EINKAUF-1 | 80   | F1     |
      | EINKAUF-1 | 70   | F1     |
      | EINKAUF-1 | -10  | F1     |
      | EINKAUF-1 | -20  | F1     |
      | EINKAUF-1 | -20  | F1     |
      | EINKAUF-1 | -30  | F1     |
      | EINKAUF-2 | -3   | F1     |
      | EINKAUF-2 | -12  | F1     |
      | EINKAUF-2 | -10  | F1     |
      | EINKAUF-1 | 20   | F1     |
      | EINKAUF-1 | 30   | F1     |
      | EINKAUF-2 | 10   | F1     |
      | EINKAUF-2 | 12   | F1     |
      | EINKAUF-1 | 30   | F1     |
      | EINKAUF-1 | 50   | F1     |
      | EINKAUF-2 | 10   | F1     |
      | EINKAUF-2 | 12   | F1     |
    And I close the current editor

# Auftrag liefern
    Given I switch the current editor to editor "auftrag" with command "DELIVERY"
    And I set fields
      | vom | .  |
      | ueb | ja |
    And I set field "mge" to "10" in row 1
    And I save the current editor

  Scenario: Baugruppe BAUNOAS_AS, 2 AG ersterAG kein AS für 46
    Given I open an editor "BAUNOAS_AS" from table "(Part):(Product)" with command "STORE" for record "BAUNOAS_AS"
    And I set fields
      | such     | BAUNOAS_AS                |
      | namebspr | Baugruppe mit und ohne AS |
      | dispoa   | bedarfsbezogen            |
      | bsart    | Eigenfertigung            |
      | wgruppe  | 55                        |
      | erlgrp   | 66                        |
    And I delete all rows
    And I append rows
      | elex         | anzahl | manbu |
      | B_EINKAUF-1  | 1      | nein  |
      | B_EINKAUF-2  | 1      | ja    |
      | A AG_ohne_AS | 1      |       |
      | A MONTAGE1   | 1      |       |
    And I save the current editor

  Scenario: 46 Rückgabe auf abgelegten FV, bei dem zwischen Material und AS mit ASchein ein AS ohne ASchein liegt
# Bestand korrigieren, Auftrag anlegen, Bedarfe einkaufen
    Given I set StorageQuantity to zero for Product "BAUNOAS_AS" on StorageLocation "F1"
    Given I create a SalesOrder "auftrag" for Customer "RADSHOP" with Product "BAUNOAS_AS" and quantity "3"

    Given I open an editor "Lieferung" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
    And I set fields
      | lief   | KETTLER  |
      | fakt   | ja       |
      | vom    | .        |
      | ebeleg | Rechnung |
      | ueb    | ja       |
      | budat  | .        |
    And I append rows
      | artikel     | mge | platz |
      | B_EINKAUF-1 | 3   | F1    |
      | B_EINKAUF-2 | 3   | F1    |
    And I respond with answer "ja" to the dialog with id "4841"
    And I save the current editor

# Fertigungsvorschlag anlegen und freigeben
    Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
    And I append rows
      | artikel    | netmge | bisuch  | mfreig |
      | BAUNOAS_AS | 3      | NOASAS_ | ja     |
    And I press button "freig" to open a subeditor for "BA_freigeben"
    And I close the current editor
    And I switch the current editor to editor "fvor"
    And I save the current editor

# Materialentnahme auf BA
    Given I open an editor "Materialentnahme1" for tip command "Fbuchung" and arguments ""
    And I set field "auftrag" to "NOASAS_001"
    And I press button "stllad"
    And I set field "bumge" to "3" in row 1
    And I save the current editor

    Given I open an editor "Rückmeldung1" from table "(Workorder):(WorkOrders)" with command "DONE" for record "NOASAS_001"
    And I set fields
      | sofort | 1 |
      | gut    | 1 |
    And I save the current editor

# Zusätzliche Gutmnege melden
    Given I open an editor "Rückmeldung2" via ID from editor "Rückmeldung1" from field "id" in row 0 for table "(Workorder):(CompletionConfirmations)" with command "COPY"
    Then field "ag" has value "MONTAGE1" in row 2
    And I set field "bumge" to "-1" in row 2
    Then field "ag" has value "MONTAGE1" in row 3
    And I set field "bumge" to "-1" in row 3
    And I save the current editor


  Scenario: 47 BA auf externer Lagergruppe, Entnahme zusätzliches Material auf BA, Rückmeldung auf BA, Nachbuchen auf abgelegten Fertigungsvorschlag
# FDA-2516
# Auftrag anlegen
    Given I create a SalesOrder "AUF003" for Customer "RADSHOP" with Product "BAUGRUPPE2" and quantity "50"
# Lagerplatz aus externer Lagergruppe eintragen
    Given I open an editor "AUF003" from table "(Sales):(SalesOrder)" with command "UPDATE" for record "AUF003"
    And I set field "platz" to "L3F1" in row 1
    And I save the current editor

# Material einkaufen
    Given I open an editor "Lieferung" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
    And I set fields
      | lief   | KETTLER |
      | fakt   | ja      |
      | vom    | .       |
      | ebeleg | RE_003  |
      | ueb    | ja      |
      | budat  | .       |
    And I append rows
      | artikel   | mge |
      | EINKAUF-1 | 20  |
      | EINKAUF-2 | 10  |
    And I respond with answer "ja" to the dialog with id "4841"
    And I save the current editor

# Fertigungsvorschlag anlegen
    Given I open an editor "FVOR03" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
    And I append rows
      | artikel    | netmge | platz | mfreig | bisuch  |
      | BAUGRUPPE2 | 10     | L3F1  | ja     | FVOR03_ |
    And I press button "freig" to open a subeditor for "BA_freigeben"
    And I close the current subeditor to switch back to the parent editor
    And I close the current editor

# BA-Nummer zwischenspeichern
    Given I open an editor "BA" from table "(Workorder):(WorkOrders)" with command "VIEW" for search criteria "$,,such=FVOR03_000;@richtung=rückwärts;@maxordtreffer=1"
    And I save value from field "nummer" in row 0
    And I close the current editor

# Materialentnahme auf BA, zusätzliches Material
    Given I open an editor "Fbuchung1" for tip command "Fbuchung" and arguments ""
    And I set field "auftrag" to "FVOR03_000"
    And I set field "bem" to "ZUSATZMAT"
    And I set field "manent" to "ja"
    And I set field "mgr" to "112"
    And I append rows
      | elex | bumge |
      | E3   | 5     |
      | EINK | 2     |
    And I save the current editor

# Rueckmeldung auf BA
    Given I open an editor "Rueckmeldung1" from table "(Workorder):(WorkOrders)" with command "DONE" for search criteria "$,,such=FVOR03_000;@richtung=rückwärts;@maxordtreffer=1"
    And I set fields
      | mzeit  | 2      |
      | bzeit  | 2      |
      | lgr    | 1      |
      | mgr    | 112    |
      | gut    | ja     |
      | sofort | ja     |
      | bem    | RM1_BA |
    And I save the current editor

# Prüfen ob FeVo in der Ablage
    Given I open an editor "FV" from table "(Purchasing):(WorkOrderSuggestions)" with command "VIEW" for record ""
    And I set field "artikel" to "BAUGRUPPE2"
    And I set field "banummer" in row 0 to saved value
    And I set field "nurablage" to "ja"
    And I set field "lgruppe" to "BERLIN"
    And I press button "ladetab"
    Then the table has 1 rows
    And I close the current editor

# Nachbuchen auf abgelegten Fertigungsvorschlag, zusätzliches Material wird auch geladen
    Given I open an editor "Rueckmeldung2" from table "(Workorder):(CompletionConfirmations)" with command "COPY" for search criteria "$,,such=FVOR03_000;bem=ZUSATZMAT;@richtung=rückwärts;@maxordtreffer=1;@ablageart=abgelegt"
    Then table has values
      | artikel    |
      | BAUGRUPPE2 |
      | EINKAUF-1  |
      | EINKAUF-2  |
      | E3         |
      | EINK       |
    And I set field "bem" to "NACHBUCH"
    And I set field "gutmge" to "1" in row 1
    And I set field "mge" to "2" in row 2
    And I set field "mge" to "1" in row 3
    And I set field "mge" to "1" in row 4
    And I set field "mge" to "1" in row 5
    And I save the current editor

# LJ prüfen, auch Plätze
    Given I open the infosystem "LJ"
    And I set field "beleg" to "nummer" from editor "Rueckmeldung1"
    And I set field "richtung" to "rückwärts"
    And I press start
    Then table has values
      | art        | zmge | amge | nplatz | vplatz |
      | BAUGRUPPE2 | 1    |      | L3F1   |        |
      | EINKAUF-1  |      | 2    |        | L3F1   |
      | EINKAUF-2  |      | 1    |        | L3F1   |
      | E3         |      | 1    |        | L3F1   |
      | EINK       |      | 1    |        | L3F1   |
      | BAUGRUPPE2 | 10   |      | L3F1   |        |
      | EINKAUF-1  |      | 20   |        | L3F1   |
      | EINKAUF-2  |      | 10   |        | L3F1   |
      | E3         |      | 5    |        | L3F1   |
      | EINK       |      | 2    |        | L3F1   |
    And I close the current editor

# Auftrag liefern
    And I deliver the SalesOrder "AUF003" with PackingSlip "LS-003"


  Scenario: 48 BA auf externer Lagergruppe, Entnahme zusätzliches Material auf AS, Rückmeldung auf AS, Nachbuchen auf abgelegten Fertigungsvorschlag
# FDA-2516
# Auftrag anlegen
    Given I create a SalesOrder "AUF031" for Customer "RADSHOP" with Product "BAUGRUPPE2" and quantity "50"
# Lagerplatz aus externer Lagergruppe eintragen
    Given I open an editor "AUF031" from table "(Sales):(SalesOrder)" with command "UPDATE" for record "AUF031"
    And I set field "platz" to "L3F1" in row 1
    And I save the current editor

# Material einkaufen
    Given I open an editor "Lieferung" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
    And I set fields
      | lief   | KETTLER |
      | fakt   | ja      |
      | vom    | .       |
      | ebeleg | RE_031  |
      | ueb    | ja      |
      | budat  | .       |
    And I append rows
      | artikel   | mge |
      | EINKAUF-1 | 20  |
      | EINKAUF-2 | 10  |
    And I respond with answer "ja" to the dialog with id "4841"
    And I save the current editor

# Fertigungsvorschlag anlegen
    Given I open an editor "FVOR31" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
    And I append rows
      | artikel    | netmge | platz | mfreig | bisuch  |
      | BAUGRUPPE2 | 10     | L3F1  | ja     | FVOR31_ |
    And I press button "freig" to open a subeditor for "BA_freigeben"
    And I close the current subeditor to switch back to the parent editor
    And I close the current editor

# BA-Nummer zwischenspeichern
    Given I open an editor "BA" from table "(Workorder):(WorkOrders)" with command "VIEW" for search criteria "$,,such=FVOR31_000;@richtung=rückwärts;@maxordtreffer=1"
    And I save value from field "nummer" in row 0
    And I close the current editor

# Materialentnahme auf AS, zusätzliches Material
    Given I open an editor "Fbuchung1" for tip command "Fbuchung" and arguments ""
    And I set field "auftrag" to "FVOR31_001"
    And I set field "bem" to "ZUSATZMAT"
    And I set field "manent" to "ja"
    And I set field "mgr" to "112"
    And I delete all rows
    And I append rows
      | elex | bumge |
      | E3   | 5     |
      | EINK | 2     |
    And I save the current editor

# Rueckmeldung auf Arbeitsschein 1
    Given I open an editor "Rueckmeldung1" from table "(Workorder):(WorkOrders)" with command "DONE" for search criteria "$,,such=FVOR31_001;@richtung=rückwärts;@maxordtreffer=1"
    And I set fields
      | mzeit  | 2      |
      | bzeit  | 2      |
      | lgr    | 1      |
      | mgr    | 112    |
      | gut    | ja     |
      | sofort | ja     |
      | bem    | RM_AS1 |
    And I save the current editor

# Rueckmeldung auf Arbeitsschein 2
    Given I open an editor "Rueckmeldung2" from table "(Workorder):(WorkOrders)" with command "DONE" for search criteria "$,,such=FVOR31_002;@richtung=rückwärts;@maxordtreffer=1"
    And I set fields
      | mzeit  | 2      |
      | bzeit  | 2      |
      | lgr    | 1      |
      | mgr    | 112    |
      | gut    | ja     |
      | sofort | ja     |
      | bem    | RM_AS2 |
    And I save the current editor

# Prüfen ob FeVo in der Ablage
    Given I open an editor "FV" from table "(Purchasing):(WorkOrderSuggestions)" with command "VIEW" for record ""
    And I set field "artikel" to "BAUGRUPPE2"
    And I set field "banummer" in row 0 to saved value
    And I set field "nurablage" to "ja"
    And I set field "lgruppe" to "BERLIN"
    And I press button "ladetab"
    Then the table has 1 rows
    And I close the current editor


# Nachbuchen auf abgelegten Fertigungsvorschlag, zusätzliches Material wird auch geladen
    Given I switch the current editor to editor "Rueckmeldung1" with command "COPY"
    Then table has values
      | artikel    |
      | BAUGRUPPE2 |
      | EINKAUF-1  |
      | E3         |
      | EINK       |
    And I set field "bem" to "NACHBUCH"
    And I set field "mge" to "2" in row 2
    And I set field "mge" to "1" in row 3
    And I set field "mge" to "1" in row 4
    And I save the current editor

# LJ prüfen, auch Plätze
    Given I open the infosystem "LJ"
    And I set field "beleg" to "nummer" from editor "Rueckmeldung1"
    And I set field "richtung" to "rückwärts"
    And I press start
    Then table has values
      | art       | zmge | amge | nplatz | vplatz |
      | EINKAUF-1 |      | 2    |        | L3F1   |
      | E3        |      | 1    |        | L3F1   |
      | EINK      |      | 1    |        | L3F1   |
      | EINKAUF-1 |      | 20   |        | L3F1   |
      | E3        |      | 5    |        | L3F1   |
      | EINK      |      | 2    |        | L3F1   |
    And I close the current editor

# Auftrag liefern
    And I deliver the SalesOrder "AUF031" with PackingSlip "LS-031"


  Scenario: 49 Rückmeldung auf BA mit Löschschutz, Status setzen, weitere Gutmenge buchen, keine Abbuchung von manbu-Material

# Auftrag anlegen
    Given I create a SalesOrder "auftrag49" for Customer "RADSHOP" with Product "M_BAUGRUPPE2" and quantity "20"

# Material einkaufen
    Given I open an editor "Lieferung" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
    And I set fields
      | lief   | KETTLER  |
      | fakt   | ja       |
      | vom    | .        |
      | ebeleg | Rechnung |
      | ueb    | ja       |
    And I append rows
      | artikel   | mge |
      | EINKAUF-1 | 40  |
      | EINKAUF-2 | 20  |
    And I respond with answer "ja" to the dialog with id "4841"
    And I save the current editor

# Fertigungsvorschlag anlegen
    Given I open an editor "FV42" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
    And I append rows
      | artikel      | netmge | mfreig | bisuch | binoloe |
      | M_BAUGRUPPE2 | 20     | ja     | FV49_  | ja      |
    And I press button "freig" to open a subeditor for "BA_freigeben"
    And I close the current subeditor to switch back to the parent editor
    And I close the current editor

# Rueckmeldung auf BA, Statuskennzeichen setzen
    Given I open an editor "Rueckmeldung1" from table "(Workorder):(WorkOrders)" with command "DONE" for search criteria "$,,such=FV49_000;@richtung=rückwärts;@maxordtreffer=1"
    And I set fields
      | mzeit  | 2      |
      | bzeit  | 2      |
      | lgr    | 1      |
      | mgr    | 112    |
      | sofort | ja     |
      | bem    | RM1_BA |
    And I modify table
      | !row | gutmge | status |
      | 1    | 18     | X      |
    And I save the current editor

# weitere Rueckmeldung auf BA, Status leeren
    Given I open an editor "Rueckmeldung2" from table "(Workorder):(WorkOrders)" with command "DONE" for search criteria "$,,such=FV49_000;@richtung=rückwärts;@maxordtreffer=1"
    And I set fields
      | mzeit  | 1      |
      | bzeit  | 1      |
      | lgr    | 1      |
      | mgr    | 112    |
      | sofort | ja     |
      | bem    | RM2_BA |
    And I modify table
      | !row | gutmge | status |
      | 1    | 1      |        |
    And I save the current editor

# RM-Beleg pruefen, nur Fertigteil wurde gebucht, kein Material
    And I switch the current editor to editor "Rueckmeldung2" with command "VIEW"
    Then the table has 1 rows
    Then table has values
      | artikel      | mge | gutmge | status |
      | M_BAUGRUPPE2 | 2   | 1      |        |
    And I close the current editor

# LJ pruefen
    Given I open the infosystem "LJ"
    And I set field "beleg" to "nummer" from editor "Rueckmeldung2"
    And I set field "richtung" to "rückwärts"
    And I press start
    Then the table has 2 rows
    Then table has values
      | art          | zmge | amge |
      | M_BAUGRUPPE2 | 1    |      |
      | M_BAUGRUPPE2 | 18   |      |
    And I close the current editor

# Löschschutz entfernen, um BA abzuschließen
    Given I open an editor "BA" from table "(Workorder):(WorkOrders)" with command "UPDATE" for search criteria "$,,such=FV49_000;@richtung=rückwärts;@maxordtreffer=1"
    And I set field "noloesch" to "nein"
    And I save the current editor

# Auftrag liefern
    Given I switch the current editor to editor "auftrag49" with command "DELIVERY"
    And I set fields
      | vom | .  |
      | ueb | ja |
    And I set field "mge" to "19" in row 1
    And I save the current editor


  Scenario: 50 Nachbuchen auf Arbeitsschein von Gutmenge (ohne Fertigteil Zugang) und Material auf abgelegten FV

# Fertigungsvorschlag anlegen und freigeben
    Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
    And I append rows
      | artikel    | netmge | mfreig | bisuch |
      | BAUGRUPPE2 | 10     | ja     | NBAS_  |
    And I press button "freig" to open a subeditor for "BA_freigeben"
    And I close the current editor
    And I switch the current editor to editor "fvor"
    And I save the current editor

    Given I open an editor "Rückmeldung1" from table "(Workorder):(WorkOrders)" with command "DONE" for record "NBAS_001"
    And I set fields
      | sofort | ja |
      | gut    | ja |
    And I save the current editor

    Given I open an editor "Rückmeldung2" from table "(Workorder):(WorkOrders)" with command "DONE" for record "NBAS_002"
    And I set fields
      | sofort | ja |
      | gut    | ja |
    And I save the current editor

# Nachbuchen in Lagereinheit
    Given I open an editor "Rückmeldung3" via ID from editor "Rückmeldung1" from field "id" in row 0 for table "(Workorder):(CompletionConfirmations)" with command "COPY"
    And I modify table
      | !row | gutmge      | mge         |
      | 1    | 1           | !dontChange |
      | 2    | !dontChange | 1           |
    And I save the current editor

# Lagerjournaleintrag prüfen
    Given I open the infosystem "LJ"
    And I set field "beleg" to "barmex" from editor "Rückmeldung1"
    And I set field "richtung" to "rückwärts"
    And I press start
    Then table has values
      | art       | zmge | amge | detursache            |
      | EINKAUF-1 |      | 1    | Rückmeldung Fertigung |
      | EINKAUF-1 |      | 20   | Rückmeldung Fertigung |
    And I close the current editor

  Scenario: Baugruppe BARUND mit Rundungsfaktor, 1 AG mit Anfahrmenge/PVerlust für Scenario_51
    Given I open an editor "BARUND" from table "(Part):(Product)" with command "STORE" for record "BARUND"
    And I set fields
      | such     | BARUND                  |
      | namebspr | Baugruppe mit Rundung 1 |
      | dispoa   | bedarfsbezogen          |
      | bsart    | Eigenfertigung          |
      | mindest  | 50                      |
      | losgr    | 100                     |
      | rundung  | 1                       |
    And I delete all rows
    And I append rows
      | elex        | anzahl | manbu | amge | pverlust |
      | B_EINKAUF-1 | 1      | nein  |      |          |
      | B_EINKAUF-2 | 1      | ja    |      |          |
      | A MONTAGE1  | 1      |       | 4    | 10       |
    And I save the current editor

  Scenario: 51 FDA-4533 Berücksichtigung des Rundungsfaktors, wenn die Menge beim Erfassen automatisch eingetragen wird
# Bestand korrigieren
    Given I set StorageQuantity to zero for Product "BARUND" on StorageLocation "F1"

# Fertigungsvorschlag anlegen
    Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
    And I append rows
      | artikel | netmge | bisuch |
      | BARUND  | 100    | RUND_  |
    Then field "mge" has value "116" in row 1
    And I save the current editor

  Scenario: Baugruppe CALCMGE mit Rundungsfaktor, 1 AG mit Anfahrmenge/PVerlust für Scenario_52
    Given I open an editor "CALCMGE" from table "(Part):(Product)" with command "STORE" for record "CALCMGE"
    And I set fields
      | such     | CALCMGE                 |
      | namebspr | Baugruppe mit Verlusten |
      | dispoa   | bedarfsbezogen          |
      | bsart    | Eigenfertigung          |
      | mindest  | 5000                    |
      | losgr    | 5000                    |
      | rundung  | 1                       |
    And I delete all rows
    And I append rows
      | elex        | anzahl | manbu | amge | pverlust |
      | B_EINKAUF-1 | 1      | nein  |      |          |
      | A SCHRAUBEN | 1      |       |      | 1,2      |
      | A MONTAGE1  | 1      |       |      | 0,2      |
    And I save the current editor

  Scenario: 52 FDA-4534 Rundungsfehler bei der Berechnung der Nettomenge führt zu interner Diag
# Bestand korrigieren
    Given I set StorageQuantity to zero for Product "CALCMGE" on StorageLocation "F1"

# Fertigungsvorschlag anlegen und freigeben
    Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
    And I append rows
      | artikel | bisuch   | mfreig |
      | CALCMGE | CALCMGE_ | ja     |
    Then field "mge" has value "5071" in row 1
    Then field "limge" has value "5071" in row 1
    Then field "frgmge" has value "0" in row 1
    Then field "netmge" has value "5000" in row 1
    Then field "netlimge" has value "5000" in row 1
    Then field "netfrgmge" has value "0" in row 1
    And I press button "freig" to open a subeditor for "BA_freigeben"
    And I close the current editor
    And I switch the current editor to editor "fvor"
    And I save the current editor

# In die AFL absteigen und speichern. Dabei werden die Mengen im BA/AS und RES neu berechnet. Hier kam es zur Diag.
    Given I open an editor "Betriebsauftrag" from table "(Workorder):(WorkOrders)" with command "UPDATE" for record "CALCMGE_000"
    And I press button "absteig" to open a subeditor for "AFL"
    And I save the current editor
    And I switch the current editor to editor "Betriebsauftrag"
    And I close the current editor


  Scenario: 53 Materialzuordnung fuer Entnahmeartikel aus gebuchter RM anzeigen

    Given I create a Lot "CH1EK1" for Product "EINKAUF-1"
    Given I create a Lot "CH2EK1" for Product "EINKAUF-1"
    Given I create a Lot "CH1EK2" for Product "EINKAUF-2"
    Given I create a Lot "CH2EK2" for Product "EINKAUF-2"
    Given I create a Lot "CH1BG" for Product "BAUGRUPPE"

# Material einkaufen, mit Chargen auf verschiedene Lagerplaetze buchen
    Given I open an editor "Lieferung" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
    And I set fields
        | lief   | KETTLER  |
        | fakt   | ja       |
        | vom    | .        |
        | ebeleg | Rechnung |
        | ueb    | ja       |
    And I append rows
        | artikel   | mge | verw  | charge |
        | EINKAUF-1 | 100 | VERW1 | CH1EK1 |
        | EINKAUF-2 | 50  | VERW1 | CH1EK2 |
    And I press button "mzsubm" to open a subeditor for "MZ" in row 1
    And I delete all rows
    And I append rows
        | lpsuch | zuomge | verw  | charge |
        | F1     | 70     | VERW1 | CH1EK1 |
        | F2     | 30     | VERW1 | CH2EK1 |
    And I press button for next product
    And I delete all rows
    And I append rows
        | lpsuch | zuomge | verw  | charge |
        | F1     | 10     | VERW1 | CH1EK2 |
        | F2     | 40     | VERW1 | CH2EK2 |
    And I save the current editor
    And I switch the current editor to editor "Lieferung"
    And I respond with answer "ja" to the dialog with id "4841"
    And I save the current editor

# Fertigungsvorschlag anlegen und freigeben
    Given I open an editor "FV53" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
    And I append rows
        | artikel   | netmge | mfreig | verw  | charge |
        | BAUGRUPPE | 50     | ja     | VERW1 | CH1BG  |
    And I press button "mzabsm" to open a subeditor for "MZ1" in row 1
    And I delete all rows
    And I append rows
        | lpsuch | zuomge | charge |
        | F1     | 70     | CH1EK1 |
        | F2     | 30     | CH2EK1 |
    And I press button for next product
    And I delete all rows
    And I append rows
        | lpsuch | zuomge | charge |
        | F1     | 10     | CH1EK2 |
        | F2     | 40     | CH2EK2 |
    And I save the current editor
    And I switch the current editor to editor "FV53"
    And I set field "bisuch" to "FV53_" in row 1
    And I press button "freig" to open a subeditor for "BA_freigeben"
    And I close the current subeditor to switch back to the parent editor
    And I close the current editor

# Rueckmeldung 1 auf ersten Arbeitsschein
    Given I open an editor "Rückmeldung1" from table "(Workorder):(WorkOrders)" with command "DONE" for search criteria "$,,such=FV53_001;@richtung=rückwärts;@maxordtreffer=1"
    And I set field "sofort" to "1"
    And I set field "bem" to "RM1"
    And I set field "gutmge" to "20" in row 1
    And I save the current editor

# Rueckmeldung 2 auf ersten Arbeitsschein
    Given I open an editor "Rückmeldung2" from table "(Workorder):(WorkOrders)" with command "DONE" for search criteria "$,,such=FV53_001;@richtung=rückwärts;@maxordtreffer=1"
    And I set field "sofort" to "1"
    And I set field "bem" to "RM2"
    And I set field "gutmge" to "30" in row 1
    And I save the current editor

# MZ fuer Entnahmeartikel in der Rueckmeldung pruefen
    Given I open an editor "RMPruef1" from table "(Workorder):(CompletionConfirmations)" with command "VIEW" for search criteria "$,,such=FV53_001;bem==RM1;@ablage=abgelegt;@richtung=rückwärts;@maxordtreffer=1"
    Then the table has 3 rows
    Then field "verw" has value "VERW1"
    Then table has values
        | artikel   | mge |
        | BAUGRUPPE | 50  |
        | EINKAUF-2 | 20  |
        | EINKAUF-1 | 40  |
# MZ fuer Entnahmeartikel laesst sich nicht oeffnen aus der Zeile des Fertigartikels
# 5705 de      |Kann Submaske nicht öffnen
    Then pressing button "mzabsm" in row 1 to open a subeditor throws the exception "5705"
# MZ fuer Fertigartikel laesst sich nicht oeffnen aus der Zeile des Entnahmeartikels
# 5705 de      |Kann Submaske nicht öffnen
    Then pressing button "mzsubm" in row 2 to open a subeditor throws the exception "5705"
    And I press button "mzabsm" to open a subeditor for "MZ1" in row 2
    Then field "artikel" has value "EINKAUF-2"
    Then table has values
        | lpsuch | zuomge | verw  | charge^such |
        | F1     | 10     | VERW1 | CH1EK2      |
        | F2     | 10     | VERW1 | CH2EK2      |
    And I press button for next product
    Then field "artikel" has value "EINKAUF-1"
    Then table has values
        | lpsuch | zuomge | verw  | charge^such |
        | F1     | 40     | VERW1 | CH1EK1      |
    And I close the current editor
    And I switch the current editor to editor "RMPruef1"
    And I close the current editor

    Given I open an editor "RMPruef2" from table "(Workorder):(CompletionConfirmations)" with command "VIEW" for search criteria "$,,such=FV53_001;bem==RM2;@ablage=abgelegt;@richtung=rückwärts;@maxordtreffer=1"
    Then the table has 3 rows
    Then field "verw" has value "VERW1"
    Then table has values
        | artikel   | mge |
        | BAUGRUPPE | 30  |
        | EINKAUF-2 | 30  |
        | EINKAUF-1 | 60  |
    And I press button "mzabsm" to open a subeditor for "MZ1" in row 2
    Then field "artikel" has value "EINKAUF-2"
    Then table has values
        | lpsuch | zuomge | verw  | charge^such |
        | F2     | 30     | VERW1 | CH2EK2      |
    And I press button for next product
    Then field "artikel" has value "EINKAUF-1"
    Then table has values
        | lpsuch | zuomge | verw  | charge^such |
        | F1     | 30     | VERW1 | CH1EK1      |
        | F2     | 30     | VERW1 | CH2EK1      |
    And I close the current editor
    And I switch the current editor to editor "RMPruef2"
    And I close the current editor


  Scenario: 54 Materialzuordnung fuer Entnahmeartikel und Koppelprodukt aus gebuchter RM anzeigen

    Given I create a Lot "CH3EK1" for Product "EINKAUF-1"
    Given I create a Lot "CH4EK1" for Product "EINKAUF-1"
    Given I create a Lot "CH1KOPRO" for Product "KOPPELPROD"
    Given I create a Lot "CH2KOPRO" for Product "KOPPELPROD"
    Given I create a Lot "CH1BGKO" for Product "BG-KOPPEL"

# Material einkaufen und mit Chargen auf verschiedene Lagerplaetze buchen
    Given I open an editor "Lieferung" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
    And I set fields
        | lief   | KETTLER  |
        | fakt   | ja       |
        | vom    | .        |
        | ebeleg | Rechnung |
        | ueb    | ja       |
    And I append rows
        | artikel   | mge | verw  | charge |
        | EINKAUF-1 | 100 | VERW2 | CH3EK1 |
    And I press button "mzsubm" to open a subeditor for "MZ" in row 1
    And I delete all rows
    And I append rows
        | lpsuch | zuomge | verw  | charge |
        | F1     | 70     | VERW2 | CH3EK1 |
        | F2     | 30     | VERW2 | CH4EK1 |
    And I save the current subeditor to switch back to the parent editor
    And I respond with answer "ja" to the dialog with id "4841"
    And I save the current editor

# Fertigungsvorschlag anlegen und freigeben
    Given I open an editor "FV54" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
    And I append rows
        | artikel   | netmge | mfreig | verw  | charge  |
        | BG-KOPPEL | 50     | ja     | VERW2 | CH1BGKO |
    And I press button "mzabsm" to open a subeditor for "MZ" in row 1
    And I delete all rows
    And I append rows
        | lpsuch | zuomge | charge   |
        | F1     | 30     | CH1KOPRO |
        | F2     | 20     | CH2KOPRO |
    And I press button for next product
    And I delete all rows
    And I append rows
        | lpsuch | zuomge | charge |
        | F1     | 70     | CH3EK1 |
        | F2     | 30     | CH4EK1 |
    And I save the current editor
    And I switch the current editor to editor "FV54"
    And I set field "bisuch" to "FV54_" in row 1
    And I press button "freig" to open a subeditor for "BA_freigeben"
    And I close the current subeditor to switch back to the parent editor
    And I close the current editor

# Rueckmeldung 1 auf ersten Arbeitsschein
    Given I open an editor "Rückmeldung1" from table "(Workorder):(WorkOrders)" with command "DONE" for search criteria "$,,such=FV54_001;@richtung=rückwärts;@maxordtreffer=1"
    And I set field "sofort" to "1"
    And I set field "bem" to "RM1"
    And I set field "gutmge" to "20" in row 1
    And I save the current editor

# Rueckmeldung 2 auf ersten Arbeitsschein
    Given I open an editor "Rückmeldung2" from table "(Workorder):(WorkOrders)" with command "DONE" for search criteria "$,,such=FV54_001;@richtung=rückwärts;@maxordtreffer=1"
    And I set field "sofort" to "1"
    And I set field "bem" to "RM2"
    And I set field "gutmge" to "30" in row 1
    And I save the current editor

# MZ in der Rueckmeldung pruefen, Koppelprodukt ebenfalls in der MZ fuer Entnahmeartikel
    Given I open an editor "RMPruef1" from table "(Workorder):(CompletionConfirmations)" with command "VIEW" for search criteria "$,,such=FV54_001;bem==RM1;@ablage=abgelegt;@richtung=rückwärts;@maxordtreffer=1"
    Then the table has 3 rows
    Then field "verw" has value "VERW2"
    Then table has values
        | artikel    | mge |
        | BG-KOPPEL  | 50  |
        | EINKAUF-1  | 40  |
        | KOPPELPROD | 20  |
    And I press button "mzabsm" to open a subeditor for "MZ1" in row 2
    Then field "artikel" has value "EINKAUF-1"
    Then table has values
        | lpsuch | zuomge | verw  | charge^such |
        | F1     | 40     | VERW2 | CH3EK1      |
    And I press button for next product
    Then field "artikel" has value "KOPPELPROD"
    Then table has values
        | lpsuch | zuomge | verw  | charge^such |
        | F1     | 20     | VERW2 | CH1KOPRO    |
    And I close the current editor
    And I switch the current editor to editor "RMPruef1"
    And I close the current editor

    Given I open an editor "RMPruef2" from table "(Workorder):(CompletionConfirmations)" with command "VIEW" for search criteria "$,,such=FV54_001;bem==RM2;@ablage=abgelegt;@richtung=rückwärts;@maxordtreffer=1"
    Then the table has 3 rows
    Then field "verw" has value "VERW2"
    Then table has values
        | artikel    | mge |
        | BG-KOPPEL  | 30  |
        | EINKAUF-1  | 60  |
        | KOPPELPROD | 30  |
    And I press button "mzabsm" to open a subeditor for "MZ1" in row 2
    Then field "artikel" has value "EINKAUF-1"
    Then table has values
        | lpsuch | zuomge | verw  | charge^such |
        | F1     | 30     | VERW2 | CH3EK1      |
        | F2     | 30     | VERW2 | CH4EK1      |
    And I press button for next product
    Then field "artikel" has value "KOPPELPROD"
    Then table has values
        | lpsuch | zuomge | verw  | charge^such |
        | F1     | 10     | VERW2 | CH1KOPRO    |
        | F2     | 20     | VERW2 | CH2KOPRO    |
    And I close the current editor
    And I switch the current editor to editor "RMPruef2"
    And I close the current editor


#  Scenario: Aufzaehlung ARTIKELSPERRE aendern und Reorganisation sofort

    Given I open an editor "Aufzaehlung" from table "(Enumeration):(Enumeration)" with command "UPDATE" for record "ARTIKELSPERRE"
    And I set field "reosofort" to "ja"
    And I delete all rows
    And I append rows
      | aufzelem     | aebez                                |
      | PRODUCTLOCK  | Standard-Artikelsperre               |
      | PRODUCTNOTE  | Standard-Artikelsperre, nur Hinweise |
    And I save the current editor

    Given I open an editor "Dienstleistung" from table "(Enumeration):(Enumeration)" with command "UPDATE" for record "DIENSTLSTSPERRE"
    And I set field "reosofort" to "ja"
    And I delete all rows
    And I append rows
      | aufzelem       | aebez                                        |
      | SERVICELOCK    | Standard-Dienstleistungssperre               |
      | SERVICENOTE    | Standard-Dienstleistungssperre, nur Hinweise |
    And I save the current editor


  Scenario: 55a Löschschutz im BA wird gesetzt, wenn noch ein gesperrter Artikel mit komplett offener Menge vorhanden ist (retrograde Entnahme)

# Fertigungsvorschlag anlegen
    Given I open an editor "FV1" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
    And I append rows
      | artikel    | netmge | bisuch    | mfreig |
      | BAUGRUPPE2 | 50     | SPERR_A1_ | ja     |
    And I press button "freig" to open a subeditor for "BA_freigeben"
    And I close the current subeditor to switch back to the parent editor
    And I close the current editor

# Prüfen ob Loeschschutz im BA nicht gesetzt ist
    Given I open an editor "BA" from table "(Workorder):(WorkOrders)" with command "VIEW" for record "SPERR_A1_000"
    Then field "noloesch" has value "nein"
    And I close the current editor

# Artikel EINKAUF-1 zu Arbeitsgang 1 sperren
    Given I open an editor "EK-1" from table "(Part):(Product)" with command "UPDATE" for record "EINKAUF-1"
    And I set field "sperrkonfigurationneu" to "Standard-Artikelsperre"
    And I save the current editor

# Rückmeldung auf zweiten (letzten) Arbeitsschein, abschliessen des FV
    Given I open an editor "Rückmeldung2" from table "(Workorder):(WorkOrders)" with command "DONE" for record "SPERR_A1_002"
    And I set field "sofort" to "ja"
    And I set field "gut" to "ja"
    And I save the current editor

# Prüfen ob Loeschschutz im BA gesetzt wurde
    Given I open an editor "BAPRUEF" from table "(Workorder):(WorkOrders)" with command "VIEW" for record "SPERR_A1_000"
    Then field "noloesch" has value "ja"
    And I close the current editor

# Artikel EINKAUF-1 zu Arbeitsgang 1 wieder entsperren
    Given I open an editor "EK-1" from table "(Part):(Product)" with command "UPDATE" for record "EINKAUF-1"
    And I set field "sperrkonfigurationneu" to ""
    And I save the current editor

# BA beenden
    Given I open an editor "BAFERTIG" from table "(Workorder):(WorkOrders)" with command "UPDATE" for record "SPERR_A1_000"
    And I set field "noloesch" to "nein"
    And I save the current editor


  Scenario: 55b Löschschutz im BA wird gesetzt, wenn noch ein gesperrter Artikel mit anteiliger offener Menge vorhanden ist (retrograde Entnahme)

# Fertigungsvorschlag anlegen
    Given I open an editor "FV1" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
    And I append rows
      | artikel    | netmge | bisuch    | mfreig |
      | BAUGRUPPE2 | 50     | SPERR_A2_ | ja     |
    And I press button "freig" to open a subeditor for "BA_freigeben"
    And I close the current subeditor to switch back to the parent editor
    And I close the current editor

# Prüfen ob Loeschschutz im BA nicht gesetzt ist
    Given I open an editor "BA" from table "(Workorder):(WorkOrders)" with command "VIEW" for record "SPERR_A2_000"
    Then field "noloesch" has value "nein"
    And I close the current editor

# Rückmeldung auf ersten Arbeitsschein
    Given I open an editor "Rückmeldung1" from table "(Workorder):(WorkOrders)" with command "DONE" for record "SPERR_A2_001"
    And I set field "sofort" to "ja"
    And I set field "gutmge" to "20" in row 1
    And I save the current editor

# Artikel EINKAUF-1 zu Arbeitsgang 1 sperren
    Given I open an editor "EK-1" from table "(Part):(Product)" with command "UPDATE" for record "EINKAUF-1"
    And I set field "sperrkonfigurationneu" to "Standard-Artikelsperre"
    And I save the current editor

# Rückmeldung auf zweiten (letzten) Arbeitsschein, abschliessen des FV
    Given I open an editor "Rückmeldung2" from table "(Workorder):(WorkOrders)" with command "DONE" for record "SPERR_A2_002"
    And I set field "sofort" to "ja"
    And I set field "gut" to "ja"
    And I save the current editor

# Prüfen ob Loeschschutz im BA gesetzt wurde
    Given I open an editor "BAPRUEF" from table "(Workorder):(WorkOrders)" with command "VIEW" for record "SPERR_A2_000"
    Then field "noloesch" has value "ja"
    And I close the current editor

# Artikel EINKAUF-1 zu Arbeitsgang 1 wieder entsperren
    Given I open an editor "EK-1" from table "(Part):(Product)" with command "UPDATE" for record "EINKAUF-1"
    And I set field "sperrkonfigurationneu" to ""
    And I save the current editor

# BA beenden
    Given I open an editor "BAFERTIG" from table "(Workorder):(WorkOrders)" with command "UPDATE" for record "SPERR_A2_000"
    And I set field "noloesch" to "nein"
    And I save the current editor


  Scenario: 55c Löschschutz im BA wird gesetzt, wenn noch ein gesperrter Artikel mit offener Menge vorhanden ist (manuelle Entnahme)

# Fertigungsvorschlag anlegen
    Given I open an editor "FV1" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
    And I append rows
      | artikel      | netmge | bisuch   | mfreig |
      | M_BAUGRUPPE2 | 50     | SPERR_M_ | ja     |
    And I press button "freig" to open a subeditor for "BA_freigeben"
    And I close the current subeditor to switch back to the parent editor
    And I close the current editor

# Prüfen ob Loeschschutz im BA nicht gesetzt ist
    Given I open an editor "BA" from table "(Workorder):(WorkOrders)" with command "VIEW" for record "SPERR_M_000"
    Then field "noloesch" has value "nein"
    And I close the current editor

# Materialentnahme auf ersten Arbeitsschein
    Given I open an editor "Materialentnahme1" for tip command "Fbuchung" and arguments ""
    And I set field "auftrag" to "SPERR_M_001"
    And I set field "gmgevorschl" to "20"
    And I set field "bem" to "Entnahme"
    And I press button "stllad"
    And I save the current editor

# Rückmeldung auf ersten Arbeitsschein
    Given I open an editor "Rückmeldung1" from table "(Workorder):(WorkOrders)" with command "DONE" for record "SPERR_M_001"
    And I set field "sofort" to "ja"
    And I set field "gutmge" to "20" in row 1
    And I save the current editor

# Artikel zu Arbeitsgang 1 sperren
    Given I open an editor "EK-1" from table "(Part):(Product)" with command "UPDATE" for record "EINKAUF-1"
    And I set field "sperrkonfigurationneu" to "Standard-Artikelsperre"
    And I save the current editor

# Rückmeldung auf zweiten (letzten) Arbeitsschein, abschliessen des FV
    Given I open an editor "Rückmeldung2" from table "(Workorder):(WorkOrders)" with command "DONE" for record "SPERR_M_002"
    And I set field "manrest" to "ja"
    And I set field "sofort" to "ja"
    And I set field "gut" to "ja"
    And I save the current editor

# Prüfen ob Loeschschutz im BA gesetzt wurde
    Given I open an editor "BA" from table "(Workorder):(WorkOrders)" with command "VIEW" for record "SPERR_M_000"
    Then field "noloesch" has value "ja"
    And I close the current editor

# Artikel EINKAUF-1 zu Arbeitsgang 1 wieder entsperren
    Given I open an editor "EK-1" from table "(Part):(Product)" with command "UPDATE" for record "EINKAUF-1"
    And I set field "sperrkonfigurationneu" to ""
    And I save the current editor

# BA beenden
    Given I open an editor "BAFERTIG" from table "(Workorder):(WorkOrders)" with command "UPDATE" for record "SPERR_M_000"
    And I set field "noloesch" to "nein"
    And I save the current editor


  Scenario: 56 Kenner Gutmenge vorbesetzen nach Ausschussbuchung belegt Gutmenge korrekt vor

# FV anlegen und freigeben, Baugruppe mit 3 Arbeitsgaengen
    Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
    And I append rows
      | artikel | netmge | bisuch  | mfreig |
      | V3      | 100    | FVOR02_ | ja     |
    And I press button "freig" to open a subeditor for "BA_freigeben"
    And I close the current editor
    And I switch the current editor to editor "fvor"
    And I save the current editor

# Komplettrueckmeldung auf ersten Arbeitsschein
    Given I open an editor "Rueckmeldung1" from table "(Workorder):(WorkOrders)" with command "DONE" for search criteria "$,,such=FVOR02_001;@richtung=rückwärts;@maxordtreffer=1"
    And I set fields
      | mgr    | 101     |
      | mzeit  | 2       |
      | bzeit  | 2       |
      | sofort | ja      |
      | gut    | ja      |
      | bem    | RM1-AS1 |
    And I save the current editor

# Rueckmeldung mit Ausschuss auf zweiten Arbeitsschein, NICHT Fertigungsmenge reduzieren
    Given I open an editor "Rueckmeldung2" from table "(Workorder):(WorkOrders)" with command "DONE" for search criteria "$,,such=FVOR02_002;@richtung=rückwärts;@maxordtreffer=1"
    And I set fields
      | mgr    | 101     |
      | mzeit  | 2       |
      | bzeit  | 2       |
      | sofort | ja      |
      | bem    | RM1-AS2 |
    And I modify table
      | !row | gutmge | verlustmge |
      | 1    | 80     | 20         |
    And I save the current editor

# Offene Menge pruefen, erster Arbeitsgang hat wieder offene Menge von 20
    Given I open an editor "BA" from table "(Workorder):(WorkOrders)" with command "VIEW" for search criteria "$,,such=FVOR02_000;@richtung=rückwärts;@maxordtreffer=1"
    And I press button "absteig" to open a subeditor for "AFL"
    Then table has values
      | limge | frgmge | elarta      |
      | 20    | 20     | Artikel     |
      | 20    | 20     | Arbeitsgang |
      | 40    | 40     | Artikel     |
      | 20    | 20     | Arbeitsgang |
    And I close the current subeditor to switch back to the parent editor
    And I close the current editor

# weitere Rueckmeldung auf ersten Arbeitsschein und Gutmenge vorbesetzen anhaken, Gutmenge ist dann 20
    Given I open an editor "Rueckmeldung1" from table "(Workorder):(WorkOrders)" with command "DONE" for search criteria "$,,such=FVOR02_001;@richtung=rückwärts;@maxordtreffer=1"
    And I set fields
      | mgr    | 101     |
      | mzeit  | 1       |
      | bzeit  | 1       |
      | sofort | ja      |
      | gut    | ja      |
      | bem    | RM2-AS1 |
    Then field "gutmge" has value "20" in row 1
    And I save the current editor

# Offene Menge pruefen
    Given I open an editor "BA" from table "(Workorder):(WorkOrders)" with command "VIEW" for search criteria "$,,such=FVOR02_000;@richtung=rückwärts;@maxordtreffer=1"
    And I press button "absteig" to open a subeditor for "AFL"
    Then table has values
      | limge | frgmge | elarta      |
      |  0    |  0     | Artikel     |
      |  0    |  0     | Arbeitsgang |
      | 40    | 40     | Artikel     |
      | 20    | 20     | Arbeitsgang |
    And I close the current subeditor to switch back to the parent editor
    And I close the current editor

# BA abschliessen
    Given I open an editor "Rueckmeldung2" from table "(Workorder):(WorkOrders)" with command "DONE" for search criteria "$,,such=FVOR02_002;@richtung=rückwärts;@maxordtreffer=1"
    And I set fields
      | mgr    | 101     |
      | mzeit  | 1       |
      | bzeit  | 1       |
      | sofort | ja      |
      | gut    | ja      |
      | bem    | RM2-AS2 |
    And I save the current editor

    Given I open an editor "Rueckmeldung2" from table "(Workorder):(WorkOrders)" with command "DONE" for search criteria "$,,such=FVOR02_003;@richtung=rückwärts;@maxordtreffer=1"
    And I set fields
      | mgr    | 102     |
      | mzeit  | 3       |
      | bzeit  | 3       |
      | sofort | ja      |
      | gut    | ja      |
      | bem    | RM1-AS3 |
    And I save the current editor


  Scenario: 57 Entnahme MZ für retrogrades Material aus FBU anlegen

    Given I create a Lot "CH571EK1" for Product "EINKAUF-1"
    Given I create a Lot "CH572EK1" for Product "EINKAUF-1"
    Given I create a Lot "CH571EK2" for Product "EINKAUF-2"
    Given I create a Lot "CH572EK2" for Product "EINKAUF-2"
    Given I create a Lot "CH571EK3" for Product "EINKAUF-3"
    Given I create a Lot "CH572EK3" for Product "EINKAUF-3"
    Given I create a Lot "CH571BG3" for Product "BAUGRUPPE3"

    Given I create a Container "BEH571" for packaging material "BEHAELTER"
    Given I create a Container "BEH572" for packaging material "BEHAELTER"
    Given I create a Container "BEH573" for packaging material "BEHAELTER"
    Given I create a Container "BEH571A" for packaging material "BEHAELTER"
    Given I create a Container "BEH572A" for packaging material "BEHAELTER"
    Given I create a Container "BEH573A" for packaging material "BEHAELTER"

# Material einkaufen, mit Chargen und Behaelter auf verschiedene Lagerplaetze buchen
    Given I open an editor "Lieferung" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
    And I set fields
        | lief   | KETTLER  |
        | fakt   | ja       |
        | vom    | .        |
        | ebeleg | Rechnung |
        | ueb    | ja       |
    And I append rows
        | artikel   | mge | charge   | !dialogId                                     | !dialogAnswer | exbehnum   |
        | EINKAUF-1 | 50  | CH571EK1 | Externe Behälternummer ist bereits vergeben. | nein          | BEH571     |
        | EINKAUF-1 | 50  | CH571EK1 | Externe Behälternummer ist bereits vergeben. | nein          | BEH571A    |
        | EINKAUF-2 | 50  | CH571EK2 | Externe Behälternummer ist bereits vergeben. | nein          | BEH572     |
        | EINKAUF-2 | 50  | CH571EK2 | Externe Behälternummer ist bereits vergeben. | nein          | BEH572A    |
        | EINKAUF-3 | 50  | CH571EK3 | Externe Behälternummer ist bereits vergeben. | nein          | BEH573     |
        | EINKAUF-3 | 50  | CH571EK3 | Externe Behälternummer ist bereits vergeben. | nein          | BEH573A    |
    And I respond with answer "ja" to the dialog with id "4841"
    And I save the current editor

# Fertigungsvorschlag anlegen und freigeben
    Given I open an editor "FV57" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
    And I append rows
        | artikel    | netmge | mfreig | charge     |
        | BAUGRUPPE3 | 50     | ja     | CH571BG3   |
    And I press button "absteig" to open a subeditor for "AFL" in row 1
    And I set field "manbu" to "ja" in row 1
    And I save the current subeditor to switch back to the parent editor
    And I set field "bisuch" to "FV57_" in row 1
    And I press button "freig" to open a subeditor for "BA_freigeben"
    And I close the current subeditor to switch back to the parent editor
    And I close the current editor

    Given I open an editor "Materialentnahme1" for tip command "Fbuchung" and arguments ""
    And I set field "auftrag" to "FV57_002"
    And I set field "bem" to "Entnahme"
    And I set field "autorment" to "ja"
    And I press button "stllad"
    Then table has values
        | elex      | bumge | manbu |
        | EINKAUF-1 | 50    | ja    |
        | EINKAUF-2 | 50    | nein  |
    # auf fuer retrogrades Material kann in die EntnahmeMZ abgestiegen werden
    And I press button "mzsubm" to open a subeditor for "EntnahmeMZ" in row 2
    Then field "artikel" has value "EINKAUF-2"
    # durchblaettern ist moeglich und es werden nur die Zeile der Tabelle durchlaufen, der Artikel zu Arbeitsschein 3 wird NICHT aufgerufen
    And I press button for next product
    Then field "artikel" has value "EINKAUF-1"
    And I press button for next product
    Then field "artikel" has value "EINKAUF-2"
    And I delete all rows
    And I append rows
        | lpsuch    | zuomge    | behaelter | charge    |
        | F1        | 20        | BEH572    | CH571EK2  |
        | F1        | 30        | BEH572A   | CH571EK2  |
    And I save the current editor
    And I switch the current editor to editor "Materialentnahme1"
    And I save the current editor

    Given I open an editor "RMPruef" from table "(Workorder):(CompletionConfirmations)" with command "VIEW" for search criteria "$,,such=FV57_002;bem==Entnahme;@ablage=abgelegt;@richtung=rückwärts;@maxordtreffer=1"
    Then the table has 3 rows
    Then table has values
        | artikel    | mge |
        | BAUGRUPPE3 | 50  |
        | EINKAUF-2  | 50  |
        | EINKAUF-1  | 50  |
    And I press button "mzabsm" to open a subeditor for "MZ1" in row 2
    Then field "artikel" has value "EINKAUF-2"
    Then table has values
        | lpsuch    | zuomge    | behaelter^such | charge^such  |
        | F1        | 20        | BEH572         | CH571EK2     |
        | F1        | 30        | BEH572A        | CH571EK2     |
    And I press button for next product
    Then field "artikel" has value "EINKAUF-1"
    Then table has values
        | lpsuch    | zuomge    | behaelter^such | charge^such  |
        | F1        | 50        |                |              |
    And I close the current editor
    And I switch the current editor to editor "RMPruef"
    And I close the current editor

    Given I open the infosystem "LJ"
    And I set fields
      | beleg    | !RMPruef^barmex  |
      | richtung | rückwärts        |
    And I press start
    Then table has values
      | art       | detursache                 | amge | behaelter^such | vcharge^such |
      | EINKAUF-1 | Materialentnahme Fertigung | 50   |                |              |
      | EINKAUF-2 | Materialentnahme Fertigung | 30   | BEH572A        | CH571EK2     |
      | EINKAUF-2 | Materialentnahme Fertigung | 20   | BEH572         | CH571EK2     |


  Scenario: 58 Entnahme MZ für retrogrades Material im Fertigungsvorschlag anlegen und in FBU bearbeiten

# Fertigungsvorschlag anlegen und freigeben
    Given I open an editor "FV58" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
    And I append rows
        | artikel    | netmge | mfreig | charge     |
        | BAUGRUPPE3 | 50     | ja     | CH571BG3   |
    And I press button "absteig" to open a subeditor for "AFL" in row 1
    And I set field "manbu" to "ja" in row 1
    And I save the current subeditor to switch back to the parent editor
    And I press button "mzabsm" to open a subeditor for "EntnahmeMZ" in row 1
    Then field "artikel" has value "EINKAUF-1"
    And I delete all rows
    And I append rows
        | zuomge    | behaelter | charge    | lpsuch    |
        | 30        | BEH571    | CH571EK1  | F1        |
        | 20        | BEH571A   | CH571EK1  | F1        |
    And I press button for next product
    Then field "artikel" has value "EINKAUF-2"
    And I delete all rows
    And I append rows
        | zuomge    | behaelter | charge    | lpsuch    |
        | 30        | BEH571    | CH571EK2  | F1        |
        | 20        | BEH571A   | CH571EK2  | F1        |
    And I press button for next product
    Then field "artikel" has value "EINKAUF-3"
    And I delete all rows
    And I append rows
        | zuomge    | behaelter | charge    | lpsuch    |
        | 30        | BEH571    | CH571EK3  | F1        |
        | 20        | BEH571A   | CH571EK3  | F1        |
    And I save the current editor
    And I switch the current editor to editor "FV58"
    And I set field "bisuch" to "FV58_" in row 1
    And I press button "freig" to open a subeditor for "BA_freigeben"
    And I close the current subeditor to switch back to the parent editor
    And I close the current editor

    Given I open an editor "Materialentnahme1" for tip command "Fbuchung" and arguments ""
    And I set field "auftrag" to "FV58_002"
    And I set field "bem" to "Entnahme"
    And I set field "autorment" to "ja"
    And I press button "stllad"
    Then table has values
        | elex      | bumge | manbu |
        | EINKAUF-1 | 50    | ja    |
        | EINKAUF-2 | 50    | nein  |
    # auf fuer retrogrades Material kann in die EntnahmeMZ abgestiegen werden und eine angelegte MZ kann geaendert werden
    And I press button "mzsubm" to open a subeditor for "EntnahmeMZ" in row 2
    Then field "artikel" has value "EINKAUF-2"
    Then table has values
        | lpsuch    | zuomge    | behaelter^such    | charge^such   |
        | F1        | 30        | BEH571            | CH571EK2      |
        | F1        | 20        | BEH571A           | CH571EK2      |
    And I modify table
        | !row  | lpsuch    | zuomge    | behaelter | charge    |
        | 1     | F1        | 25        |           | CH572EK2  |
        | 2     | F1        | 25        |           | CH572EK2  |
    And I save the current editor
    And I switch the current editor to editor "Materialentnahme1"
    And I save the current editor

    Given I open an editor "RMPruef" from table "(Workorder):(CompletionConfirmations)" with command "VIEW" for search criteria "$,,such=FV58_002;bem==Entnahme;@ablage=abgelegt;@richtung=rückwärts;@maxordtreffer=1"
    Then the table has 3 rows
    Then table has values
        | artikel    | mge |
        | BAUGRUPPE3 | 50  |
        | EINKAUF-2  | 50  |
        | EINKAUF-1  | 50  |
    And I press button "mzabsm" to open a subeditor for "MZ1" in row 2
    Then field "artikel" has value "EINKAUF-2"
    Then table has values
        | lpsuch    | zuomge    | behaelter^such | charge^such  |
        | F1        | 25        |                | CH572EK2     |
        | F1        | 25        |                | CH572EK2     |
    And I press button for next product
    Then field "artikel" has value "EINKAUF-1"
    Then table has values
        | lpsuch    | zuomge    | behaelter^such | charge^such  |
        | F1        | 30        | BEH571         | CH571EK1     |
        | F1        | 20        | BEH571A        | CH571EK1     |
    And I close the current editor
    And I switch the current editor to editor "RMPruef"
    And I close the current editor

    Given I open the infosystem "LJ"
    And I set fields
      | beleg    | !RMPruef^barmex  |
      | richtung | rückwärts        |
    And I press start
    Then table has values
      | art       | detursache                 | amge | behaelter^such | vcharge^such |
      | EINKAUF-1 | Materialentnahme Fertigung | 20   | BEH571A        | CH571EK1     |
      | EINKAUF-1 | Materialentnahme Fertigung | 30   | BEH571         | CH571EK1     |
      | EINKAUF-2 | Materialentnahme Fertigung | 25   |                | CH572EK2     |
      | EINKAUF-2 | Materialentnahme Fertigung | 25   |                | CH572EK2     |

  Scenario: Baugruppe RUNDAS mit Rundungsfaktor, 1 AG und 2 AG mit PVerlust für Scenario_58
    Given I open an editor "RUNDAS" from table "(Part):(Product)" with command "STORE" for record "RUNDAS"
    And I set fields
      | such     | RUNDAS                  |
      | namebspr | Baugruppe mit Verlusten |
      | dispoa   | bedarfsbezogen          |
      | bsart    | Eigenfertigung          |
      | mindest  | 1000                    |
      | losgr    | 1000                    |
      | rundung  | 1                       |
    And I delete all rows
    And I append rows
      | elex        | anzahl | manbu | amge | pverlust |
      | B_EINKAUF-1 | 1      | nein  |      |          |
      | A SCHRAUBEN | 1      |       |      | 10       |
      | A MONTAGE1  | 1      |       |      | 10       |
      | A BOHR      | 1      |       |      |          |
    And I save the current editor


  Scenario: 59 FDA-4897 Rundungsfaktor beeinflusst die offene Menge bei mehreren Arbeitsgängen nicht konsistent
    # Bestand korrigieren
    Given I set StorageQuantity to zero for Product "RUNDAS" on StorageLocation "F1"
    # Fertigungsvorschlag anlegen und freigeben
    Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
    And I append rows
      | artikel | bisuch  | mfreig |
      | RUNDAS  | RUNDAS_ | ja     |
    Then field "mge" has value "1235" in row 1
    Then field "limge" has value "1235" in row 1
    Then field "frgmge" has value "0" in row 1
    Then field "netmge" has value "1000" in row 1
    Then field "netlimge" has value "1000" in row 1
    Then field "netfrgmge" has value "0" in row 1
    And I press button "freig" to open a subeditor for "BA_freigeben"
    And I close the current editor
    And I switch the current editor to editor "fvor"
    And I save the current editor
    # Mengen im BA/AS pruefen.
    Given I open an editor "Betriebsauftrag" from table "(Workorder):(WorkOrders)" with command "VIEW" for record "RUNDAS_000"
    Then field "mge" has value "1235"
    Then field "egutmge" has value "1000"
    Then field "everlustmge" has value "235"
    And I close the current editor
    Given I open an editor "Betriebsauftrag" from table "(Workorder):(WorkOrders)" with command "VIEW" for record "RUNDAS_003"
    Then field "mge" has value "1000"
    Then field "egutmge" has value "1000"
    Then field "everlustmge" has value "0"
    And I close the current editor
    Given I open an editor "Betriebsauftrag" from table "(Workorder):(WorkOrders)" with command "VIEW" for record "RUNDAS_002"
    Then field "mge" has value "1111"
    Then field "egutmge" has value "1000"
    Then field "everlustmge" has value "111"
    And I close the current editor
    Given I open an editor "Betriebsauftrag" from table "(Workorder):(WorkOrders)" with command "VIEW" for record "RUNDAS_001"
    Then field "mge" has value "1235"
    Then field "egutmge" has value "1112"
    Then field "everlustmge" has value "123"
    And I close the current editor

  Scenario: 60 FDA-6360 Fel evapsanfdat setzen beim buchen von Gutmengen

   # Fertigungsvorschlag anlegen und freigeben
    Given I open an editor "FV60" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
    And I append rows
        | artikel    | netmge | bisuch  | mfreig |
        | BAUGRUPPE3 | 60     | APSDAT_ |     ja |
    And I press button "freig" to open a subeditor for "BA_freigeben"
    And I close the current subeditor to switch back to the parent editor
    And I close the current editor

   # RM auf 1. AS mit sofort=j => apsanfdat in der AG-RES1 wird gesetzt
    Given I open an editor "RM1_AS1" from table "(Workorder):(WorkOrders)" with command "DONE" for search criteria "$,,such=APSDAT_001;@richtung=rückwärts;@maxordtreffer=1"
    And I set field "sofort" to "ja"
    And I set field "gutmge" to "20" in row 1
    And I save the current editor

    Given I open an editor "RM1_AS1_PRUEF" from table "(Workorder):(CompletionConfirmations)" with command "VIEW" for search criteria "$,,such=APSDAT_001;@ablage=abgelegt;@richtung=rückwärts;@maxordtreffer=1"
    Then field "lres^apsanfdat" is not empty
    And I close the current editor

   # RM auf 2. AS mit sofort=n, dann mit Kommando ändern sofort=j setzen => apsanfdat in der AG-RES2 wird gesetzt
    Given I open an editor "RM2_AS2a" from table "(Workorder):(WorkOrders)" with command "DONE" for search criteria "$,,such=APSDAT_002;@richtung=rückwärts;@maxordtreffer=1"
    And I set field "sofort" to "nein"
    And I set field "gutmge" to "20" in row 1
    And I save the current editor

    Given I open an editor "RM1_AS2_PRUEF1" from table "(Workorder):(CompletionConfirmations)" with command "VIEW" for search criteria "$,,such=APSDAT_002;@richtung=rückwärts;@maxordtreffer=1"
    Then field "lres^apsanfdat" is empty
    And I close the current editor

    Given I open an editor "RM2_AS2b" from table "(Workorder):(CompletionConfirmations)" with command "UPDATE" for search criteria "$,,such=APSDAT_002;@richtung=rückwärts;@maxordtreffer=1"
    And I set field "sofort" to "ja"
    And I save the current editor

    Given I open an editor "RM1_AS2_PRUEF2" from table "(Workorder):(CompletionConfirmations)" with command "VIEW" for search criteria "$,,such=APSDAT_002;@ablage=abgelegt;@richtung=rückwärts;@maxordtreffer=1"
    Then field "lres^apsanfdat" is not empty
    And I close the current editor

   # RM auf 3. AS mit sofort=n, dann mit Kommando übertragen buchen => apsanfdat in der AG-RES3 wird gesetzt
    Given I open an editor "RM3_AS3a" from table "(Workorder):(WorkOrders)" with command "DONE" for search criteria "$,,such=APSDAT_003;@richtung=rückwärts;@maxordtreffer=1"
    And I set field "sofort" to "nein"
    And I set field "gutmge" to "20" in row 1
    And I save the current editor

    Given I open an editor "RM3_AS3_PRUEF1" from table "(Workorder):(CompletionConfirmations)" with command "VIEW" for search criteria "$,,such=APSDAT_003;@richtung=rückwärts;@maxordtreffer=1"
    Then field "lres^apsanfdat" is empty
    And I close the current editor

    Given I open an editor "RM3_AS3b" from table "(Workorder):(CompletionConfirmations)" with command "TRANSFER" for search criteria "$,,such=APSDAT_003;@richtung=rückwärts;@maxordtreffer=1"
    And I save the current editor

    Given I open an editor "RM3_AS3_PRUEF2" from table "(Workorder):(CompletionConfirmations)" with command "VIEW" for search criteria "$,,such=APSDAT_003;@ablage=abgelegt;@richtung=rückwärts;@maxordtreffer=1"
    Then field "lres^apsanfdat" is not empty
    And I close the current editor
