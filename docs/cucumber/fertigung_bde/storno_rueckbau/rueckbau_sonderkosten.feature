@persistent
Feature: rueckbau_sonderkosten.feature

  Background:
    Given I set the fake date to "03.02.1995"

# *****************************************************************************
#  Name             : rueckbau_sonderkosten
#  Autor            : dglintz
#  Verantwortlich   : amk
#  Kontrolle        : drpf
#  Funktion         : Prüft, dass die Mengen- und Kostenprüfung richtig funktioniert
#                     (Mengen und Kosten geraten nicht ins negative nach
#                     einer Zeitbuchung oder einem Rückbau) 
#  Jira-Issue       : FDA-1496
# *****************************************************************************

  Scenario: 01 Prüfung der Kosten und Mengen bei Rückbau oder Zeitkorrektur, Sonderkosten storniert
# Fertigungsvorschlag anlegen und freigeben
    Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
    And I append rows
      | artikel    | netmge | mfreig | kstelle | bisuch      |
      | BAUGRUPPE2 | 50     | ja     | 100000  | SKGEBUCHT1_ |
    And I press button "freig" to open a subeditor for "BA_freigeben"
    And I close the current editor
    And I switch the current editor to editor "fvor"
    And I save the current editor
    And I close the current editor

# Bedarfe einkaufen
    Given I open an editor "RechnungLager" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
    And I set fields
      | lief   | KETTLER   |
      | vom    | .         |
      | ebeleg | Rueckbau1 |
      | ueb    | ja        |
      | fakt   | ja        |
    And I append rows
      | artikel     | mge |
      | B_EINKAUF-1 | 100 |
      | B_EINKAUF-2 | 50  |
    And I respond with answer "ja" to the dialog with id "4841"
    And I save the current editor
    And I close the current editor

# Dispolauf
    And I run Scheduling

# Rückmeldung1 auf ersten Arbeitsgang (die die Sonderkosten bebucht)
    Given I open an editor "Rückmeldung1" from table "(Workorder):(WorkOrders)" with command "DONE" for record "SKGEBUCHT1_001"
    And I set fields
      | sofort   | ja  |
      | mgr      | 101 |
      | lgr      | 3   |
      | bzeit    | 3   |
      | mzeit    | 3   |
      | bsatz    | 20  |
      | fixkost  | 10  |
      | varkost  | 5   |
      | skostfix | 11  |
    And I set field "gutmge" to "8" in row 1
    And I set field "erbtext1" to "Rückmeldung1" in row 1
    And I save the current editor

# Rückmeldung2 auf ersten Arbeitsgang
    Given I open an editor "Rückmeldung2" from table "(Workorder):(WorkOrders)" with command "DONE" for record "SKGEBUCHT1_001"
    And I set fields
      | sofort   | ja  |
      | mgr      | 101 |
      | lgr      | 2   |
      | bzeit    | 2   |
      | mzeit    | 2   |
      | bsatz    | 20  |
      | fixkost  | 10  |
      | varkost  | 5   |
      | skostfix | 11  |
    And I set field "gutmge" to "5" in row 1
    And I set field "erbtext1" to "Rückmeldung2" in row 1
    And I save the current editor
    And I close the current editor

# skgebucht im Arbeitsschein prüfen
    Given I open an editor "Arbeitsschein" from table "(Workorder):(WorkOrders)" with command "VIEW" for record "SKGEBUCHT1_001"
    Then field "skgebucht^id" has value equal to field "id" from editor "Rückmeldung1" in row 0
    And I close the current editor

# Zweite Rückmeldung stornieren (um zu prüfen ob skgebucht noch richtig gesetzt ist)
    Given I open an editor "StornoRM2" via ID from editor "Rückmeldung2" from field "id" in row 0 for table "(Workorder):(CompletionConfirmations)" with command "REVERSAL"
    And I set field "erbtext1" to "StornoRM2" in row 1
    And I save the current editor
    And I close the current editor

# skgebucht im Arbeitsschein prüfen
    Given I open an editor "Arbeitsschein1" from table "(Workorder):(WorkOrders)" with command "VIEW" for record "SKGEBUCHT1_001"
    Then field "skgebucht^id" has value equal to field "id" from editor "Rückmeldung1" in row 0
    And I close the current editor

# Rückmeldung1 auf ersten Arbeitsgang (Mengen alle zurückbuchen)
    Given I open an editor "Rückbau1" from table "(Workorder):(WorkOrders)" with command "RETURN" for record "SKGEBUCHT1_001"
    And I set fields
      | sofort   | ja  |
      | mgr      | 101 |
      | lgr      | 0   |
      | bzeit    | 0   |
      | mzeit    | 0   |
      | bsatz    | 20  |
      | fixkost  | 10  |
      | varkost  | 5   |
      | skostfix | 11  |
    And I set field "erbtext1" to "Rückbau1" in row 1
    And setting field "gutmge" to "-9" in row 1 throws the exception "1361"
    And I set field "gutmge" to "-8" in row 1
    And I save the current editor
    And I close the current editor

# skgebucht im Arbeitsschein prüfen
    Given I open an editor "Arbeitsschein1" from table "(Workorder):(WorkOrders)" with command "VIEW" for record "SKGEBUCHT1_001"
    Then field "skgebucht^id" has value equal to field "id" from editor "Rückmeldung1" in row 0
    And I close the current editor

# Test der Fehlermeldungen, wenn zu viel zeit oder kosten zurückgebucht werden
    Given I open an editor "Zeitkorrektur" for tip command "Zeitbuchung" and arguments ""
    And I set field "barmex" to "barmex" from editor "Rückmeldung2"
    And I set fields
      | sofort   | 1   |
      | mgr      | 101 |
      | lgr      | 3   |
      | bzeit    | -3  |
      | mzeit    | -3  |
      | bsatz    | 20  |
      | fixkost  | 10  |
      | varkost  | 5   |
      | skostfix | 11  |
    And I set field "bzeit" to "-4"
    Then saving the current editor throws the exception "11127"
    And I set field "bzeit" to "-3"
    And I set field "mzeit" to "-4"
    Then saving the current editor throws the exception "11126"
    And I set field "mzeit" to "-3"
    And I set field "bsatz" to "21"
    Then saving the current editor throws the exception "997"
    And I set field "bsatz" to "20"
    And I set field "fixkost" to "11"
    Then saving the current editor throws the exception "997"
    And I set field "fixkost" to "10"
    And I set field "varkost" to "6"
    Then saving the current editor throws the exception "997"
# Hier wird die Zeitkorrektur nicht gebucht
    And I close the current editor

# Erster Rückbau stornieren
    Given I open an editor "StornoRB1" via ID from editor "Rückbau1" from field "id" in row 0 for table "(Workorder):(CompletionConfirmations)" with command "REVERSAL"
    And I set field "erbtext1" to "StornoRB1" in row 1
    And I save the current editor
    And I close the current editor

# skgebucht im Arbeitsschein prüfen
    Given I open an editor "Arbeitsschein1" from table "(Workorder):(WorkOrders)" with command "VIEW" for record "SKGEBUCHT1_001"
    Then field "skgebucht^id" has value equal to field "id" from editor "Rückmeldung1" in row 0
    And I close the current editor

# Erste Rückmeldung stornieren (Und Sonderkosten dabei auch)
    Given I open an editor "StornoRM1" via ID from editor "Rückmeldung1" from field "id" in row 0 for table "(Workorder):(CompletionConfirmations)" with command "REVERSAL"
    And I set field "erbtext1" to "StornoRM1" in row 1
    And I save the current editor
    And I close the current editor

# skgebucht im Arbeitsschein prüfen (wurde geleert)
    Given I open an editor "Arbeitsschein1" from table "(Workorder):(WorkOrders)" with command "VIEW" for record "SKGEBUCHT1_001"
    Then field "skgebucht" is empty
    And I close the current editor

# Betriebsauftrag abschließen
    Given I open an editor "Betriebsauftrag1" from table "(Workorder):(WorkOrders)" with command "UPDATE" for record "SKGEBUCHT1_000"
    And I respond with answer "ja" to the dialog with id "345"
    And I set field "status" to "s"
    And I save the current editor
    And I close the current editor

  Scenario: 02 Prüfung Kosten und Mengen bei Rückbau oder Zeitkorrektur, Sonderkosten noch gebucht
# Fertigungsvorschlag anlegen und freigeben
    Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
    And I append rows
      | artikel    | netmge | mfreig | kstelle | bisuch      |
      | BAUGRUPPE2 | 50     | ja     | 100000  | SKGEBUCHT2_ |
    And I press button "freig" to open a subeditor for "BA_freigeben"
    And I close the current editor
    And I switch the current editor to editor "fvor"
    And I save the current editor
    And I close the current editor

# Bedarfe einkaufen
    Given I open an editor "RechnungLager" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
    And I set fields
      | lief   | KETTLER  |
      | vom    | .        |
      | ebeleg | Rückbau1 |
      | ueb    | ja       |
      | fakt   | ja       |
    And I append rows
      | artikel     | mge |
      | B_EINKAUF-1 | 100 |
      | B_EINKAUF-2 | 50  |
    And I respond with answer "ja" to the dialog with id "4841"
    And I save the current editor
    And I close the current editor

# Dispolauf
    And I run Scheduling
# Rückmeldung1 auf ersten Arbeitsgang
    Given I open an editor "Rückmeldung1" from table "(Workorder):(WorkOrders)" with command "DONE" for record "SKGEBUCHT2_001"
    And I set fields
      | sofort   | ja  |
      | mgr      | 101 |
      | lgr      | 2   |
      | bzeit    | 2   |
      | mzeit    | 2   |
      | bsatz    | 20  |
      | fixkost  | 10  |
      | varkost  | 5   |
      | skostfix | 11  |
    And I set field "gutmge" to "5" in row 1
    And I set field "erbtext1" to "Rückmeldung1" in row 1
    And I save the current editor

# skgebucht im Arbeitsschein prüfen
    Given I open an editor "Arbeitsschein" from table "(Workorder):(WorkOrders)" with command "VIEW" for record "SKGEBUCHT2_001"
    Then field "skgebucht^id" has value equal to field "id" from editor "Rückmeldung1" in row 0
    And I close the current editor

# Betriebsauftrag abschließen
    Given I open an editor "Betriebsauftrag" from table "(Workorder):(WorkOrders)" with command "UPDATE" for record "SKGEBUCHT2_000"
    And I respond with answer "ja" to the dialog with id "1483"
    And I set field "status" to "s"
    And I close the current editor

# Rückmeldung1 auf ersten Arbeitsgang
    Given I open an editor "Rückbau1" from table "(Workorder):(WorkOrders)" with command "RETURN" for record "SKGEBUCHT2_001"
    And I set fields
      | sofort   | ja  |
      | mgr      | 101 |
      | lgr      | 0   |
      | bzeit    | 0   |
      | mzeit    | 0   |
      | bsatz    | 20  |
      | fixkost  | 10  |
      | varkost  | 5   |
      | skostfix | 11  |
    And I set field "erbtext1" to "Rückbau1" in row 1
    And setting field "gutmge" to "-6" in row 1 throws the exception "1361"
    And I set field "gutmge" to "-5" in row 1
    And I save the current editor
    And I close the current editor

# bucht alle Zeiten weg
    Given I open an editor "Zeitkorrektur" for tip command "Zeitbuchung" and arguments ""
    And I set field "barmex" to "barmex" from editor "Rückmeldung1"
    And I set fields
      | sofort   | 1   |
      | mgr      | 101 |
      | lgr      | 2   |
      | bzeit    | -2  |
      | mzeit    | -2  |
      | bsatz    | 20  |
      | fixkost  | 10  |
      | varkost  | 5   |
      | skostfix | 11  |
    And I set field "bzeit" to "-3"
    Then saving the current editor throws the exception "11127"
    And I set field "bzeit" to "-2"
    And I set field "mzeit" to "-3"
    Then saving the current editor throws the exception "11126"
    And I set field "mzeit" to "-2"
    And I set field "bsatz" to "21"
    Then saving the current editor throws the exception "997"
    And I set field "bsatz" to "20"
    And I set field "fixkost" to "11"
    Then saving the current editor throws the exception "997"
    And I set field "fixkost" to "10"
    And I set field "varkost" to "6"
    Then saving the current editor throws the exception "997"
    And I set field "varkost" to "5"
    And I set field "skostfix" to "12"
    Then saving the current editor throws the exception "997"
    And I set field "skostfix" to "11"
    And I save the current editor

# skgebucht im Arbeitsschein prüfen
    Given I open an editor "Arbeitsschein1" from table "(Workorder):(WorkOrders)" with command "VIEW" for record "SKGEBUCHT2_001"
# Sonderkosten sind noch gebucht da die Rückmeldung die sie bebucht noch lebendig ist.
    Then field "skgebucht^id" has value equal to field "id" from editor "Rückmeldung1" in row 0
    And I close the current editor

# Betriebsauftrag mit Status setzen abschließen
    Given I open an editor "Betriebsauftrag1" from table "(Workorder):(WorkOrders)" with command "UPDATE" for record "SKGEBUCHT2_000"
    And I respond with answer "ja" to the dialog with id "345"
    And I set field "status" to "s"
    And I save the current editor
    And I close the current editor

  Scenario: 03 Prüfung der Kosten und Mengen bei Rückbau oder Zeitkorrektur, Sonderkosten storniert -> mit Gutmenge
# Fertigungsvorschlag anlegen und freigeben
    Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
    And I append rows
      | artikel   | netmge | mfreig | kstelle | bisuch      |
      | BAUGRUPPE | 50     | ja     | 100000  | SKGEBUCHT3_ |
    And I press button "freig" to open a subeditor for "BA_freigeben"
    And I close the current editor
    And I switch the current editor to editor "fvor"
    And I save the current editor
    And I close the current editor

# Bedarfe einkaufen
    Given I open an editor "RechnungLager" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
    And I set fields
      | lief   | KETTLER   |
      | vom    | .         |
      | ebeleg | Rueckbau1 |
      | ueb    | ja        |
      | fakt   | ja        |
    And I append rows
      | artikel     | mge |
      | B_EINKAUF-1 | 100 |
      | B_EINKAUF-2 | 50  |
    And I respond with answer "ja" to the dialog with id "4841"
    And I save the current editor
    And I close the current editor

# Dispolauf
    And I run Scheduling

# Rückmeldung1 auf ersten Arbeitsgang (die die Sonderkosten bebucht)
    Given I open an editor "Rückmeldung1" from table "(Workorder):(WorkOrders)" with command "DONE" for record "SKGEBUCHT3_001"
    And I set fields
      | sofort   | ja  |
      | mgr      | 101 |
      | lgr      | 3   |
      | bzeit    | 3   |
      | mzeit    | 3   |
      | bsatz    | 20  |
      | fixkost  | 10  |
      | varkost  | 5   |
      | skostfix | 11  |
    And I set field "gutmge" to "8" in row 1
    And I set field "erbtext1" to "Rückmeldung1" in row 1
    And I save the current editor

# Rückmeldung2 auf ersten Arbeitsgang
    Given I open an editor "Rückmeldung2" from table "(Workorder):(WorkOrders)" with command "DONE" for record "SKGEBUCHT3_001"
    And I set fields
      | sofort   | ja  |
      | mgr      | 101 |
      | lgr      | 2   |
      | bzeit    | 2   |
      | mzeit    | 2   |
      | bsatz    | 20  |
      | fixkost  | 10  |
      | varkost  | 5   |
      | skostfix | 11  |
    And I set field "gutmge" to "5" in row 1
    And I set field "erbtext1" to "Rückmeldung2" in row 1
    And I save the current editor
    And I close the current editor

# skgebucht im Arbeitsschein prüfen
    Given I open an editor "Arbeitsschein" from table "(Workorder):(WorkOrders)" with command "VIEW" for record "SKGEBUCHT3_001"
    Then field "skgebucht^id" has value equal to field "id" from editor "Rückmeldung1" in row 0
    And I close the current editor

# Betriebsauftrag abschließen (möglich)
    Given I open an editor "Betriebsauftrag" from table "(Workorder):(WorkOrders)" with command "UPDATE" for record "SKGEBUCHT3_000"
    And I respond with answer "yes" to the dialog with id "345"
    And I set field "status" to "s"
    And I save the current editor
    And I close the current editor

  Scenario: 04 Prüfung Kosten und Mengen bei Rückbau oder Zeitkorrektur, Sonderkosten noch gebucht
# Fertigungsvorschlag anlegen und freigeben
    Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
    And I append rows
      | artikel   | netmge | mfreig | kstelle | bisuch      |
      | BAUGRUPPE | 50     | ja     | 100000  | SKGEBUCHT4_ |
    And I press button "freig" to open a subeditor for "BA_freigeben"
    And I close the current editor
    And I switch the current editor to editor "fvor"
    And I save the current editor
    And I close the current editor

# Bedarfe einkaufen
    Given I open an editor "RechnungLager" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
    And I set fields
      | lief   | KETTLER  |
      | vom    | .        |
      | ebeleg | Rückbau1 |
      | ueb    | ja       |
      | fakt   | ja       |
    And I append rows
      | artikel     | mge |
      | B_EINKAUF-1 | 100 |
      | B_EINKAUF-2 | 50  |
    And I respond with answer "ja" to the dialog with id "4841"
    And I save the current editor
    And I close the current editor

# Dispolauf
    And I run Scheduling

# Rückmeldung1 auf ersten Arbeitsgang
    Given I open an editor "Rückmeldung1" from table "(Workorder):(WorkOrders)" with command "DONE" for record "SKGEBUCHT4_001"
    And I set fields
      | sofort   | ja  |
      | mgr      | 101 |
      | lgr      | 2   |
      | bzeit    | 2   |
      | mzeit    | 2   |
      | bsatz    | 20  |
      | fixkost  | 10  |
      | varkost  | 5   |
      | skostfix | 11  |
    And I set field "gutmge" to "5" in row 1
    And I set field "erbtext1" to "Rückmeldung1" in row 1
    And I save the current editor

# skgebucht im Arbeitsschein prüfen
    Given I open an editor "Arbeitsschein" from table "(Workorder):(WorkOrders)" with command "VIEW" for record "SKGEBUCHT4_001"
    Then field "skgebucht^id" has value equal to field "id" from editor "Rückmeldung1" in row 0
    And I close the current editor

# Betriebsauftrag abschließen
    Given I open an editor "Betriebsauftrag" from table "(Workorder):(WorkOrders)" with command "UPDATE" for record "SKGEBUCHT4_000"
    And I respond with answer "yes" to the dialog with id "345"
    And I set field "status" to "s"
    And I save the current editor
    And I close the current editor


  Scenario Outline: Maschinengruppe anlegen
    Given I open an editor "<such>" from table "(Capacity):(WorkCenter)" with command "STORE" for record "<such>"
    And I set fields
      | such     | <such>     |
      | namebspr | <namebspr> |
      | abtlg    | 1          |
      | kstelle  | 101        |
      | fixkost  | <fixkost>  |
      | varkost  | <varkost>  |
      | fmgk     | <fmgk>     |
      | manz     | <manz>     |
      | auslast  | <auslast>  |
    And I save the current editor

    Examples:
      | such  | namebspr  | fixkost | varkost | fmgk | manz | auslast |
      | CAST1 | Giesserei | 37.05   | 102.15  | 136  | 1    | 100     |
      | CAST2 | Giesserei | 69.71   | 45.11   | 0    | 2    | 80      |


  Scenario Outline: Arbeitsgang anlegen
    Given I open an editor "<such>" from table "(Operation):(Operation)" with command "STORE" for record "<such>"
    And I set fields
      | such     | <such>     |
      | namebspr | <namebspr> |
      | mgr      | <mgr>      |
      | lgr      | <lgr>      |
      | te       | <te>       |
    And I save the current editor

    Examples:
      | such     | namebspr   | mgr   | lgr | te |
      | CASTING1 | Spritzguss | CAST1 | 2   | 1  |
      | CASTING2 | Spritzguss | CAST2 | 2   | 1  |

  Scenario Outline: Baugruppe anlegen
    Given I open an editor "<such>" from table "(Part):(Product)" with command "STORE" for record "<such>"
    And I set fields
      | such      | <such>         |
      | namebspr  | <namebspr>     |
      | bsart     | Eigenfertigung |
      | chverfolgung |             |
      | mindest   | 4              |
    And I delete all rows
    And I append rows
      | elex    | anzahl | breite | manbu |
      | <elex1> | 1      |        | nein  |
      | <ag1>   | 1      | 1      | nein  |
      | <ag2>   | 1      | 1      | nein  |
    And I save the current editor
    Examples:
      | such     | namebspr            | elex1       | ag1        | ag2    |
      | CASING-R | Gehaeuse Pumpe Rot  | B_EINKAUF-1 | a casting1 | a bohr |
      | CASING-B | Gehaeuse Pumpe Blau | B_EINKAUF-1 | a casting2 | a bohr |


  Scenario: 05 # Test Fehlermeldungen 997 darf bei Storno nicht sein (Rundungdifferenzen)
# Dispolauf
    And I run Scheduling

# Fertigungsvorschlag freigeben
    Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
    And I append rows
      | artikel  | mge | mfreig |
      | CASING-R | 4   | ja     |
    And I set field "mfreig" to "ja" in row !lastRow
    And I set field "bisuch" to "ON111001_" in row !lastRow
    And I press button "freig" to open a subeditor for "BA_freigeben"
    And I close the current editor
    And I switch the current editor to editor "fvor"
    And I save the current editor

# Rückmeldung auf ersten Arbeitsgang
    Given I open an editor "Rückmeldung1" from table "(Workorder):(WorkOrders)" with command "DONE" for record "ON111001_001"
    And I set fields
      | sofort | 1   |
      | gut    | ja  |
      | mzeit  | 0.1 |
    And I set field "gutmge" to "4" in row 1
    And I save the current editor

# Rückmeldung stornieren
    Given I open an editor "Storno1" from table "(Workorder):(CompletionConfirmations)" with command "REVERSAL" for search criteria "$,,such=ON111001_001;@richtung=rückwärts;@ablageart=abgelegt;@maxtreffer=1"
    And I save the current editor


# Fertigungsvorschlag freigeben
    Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
    And I append rows
      | artikel  | mge | mfreig |
      | CASING-B | 100 | ja     |
    And I set field "mfreig" to "ja" in row !lastRow
    And I set field "bisuch" to "ON111002_" in row !lastRow
    And I press button "freig" to open a subeditor for "BA_freigeben"
    And I close the current editor
    And I switch the current editor to editor "fvor"
    And I save the current editor

# Rückmeldung auf ersten Arbeitsgang
    Given I open an editor "Rückmeldung1" from table "(Workorder):(WorkOrders)" with command "DONE" for record "ON111002_001"
    And I set fields
      | sofort   | 1     |
      | gut      | nein  |
      | mzeit    | 292.3 |
      | skostfix | 100   |
    And I save the current editor

# Rückmeldung stornieren
    Given I open an editor "Storno1" from table "(Workorder):(CompletionConfirmations)" with command "REVERSAL" for search criteria "$,,such=ON111002_001;@richtung=rückwärts;@ablageart=abgelegt;@maxtreffer=1"
    And I save the current editor

# Dispolauf
    And I run Scheduling

# Fertigungsvorschlag freigeben
    Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
    And I append rows
      | artikel  | mge | mfreig |
      | CASING-R | 10  | ja     |
    And I set field "mfreig" to "ja" in row !lastRow
    And I set field "bisuch" to "ON112001_" in row !lastRow
    And I press button "freig" to open a subeditor for "BA_freigeben"
    And I close the current editor
    And I switch the current editor to editor "fvor"
    And I save the current editor

# Rückmeldung auf ersten Arbeitsgang
    Given I open an editor "Rückmeldung1" from table "(Workorder):(WorkOrders)" with command "DONE" for record "ON112001_001"
    And I set fields
      | sofort  | 1     |
      | mzeit   | 7.05  |
      | fixkost | 0.0   |
      | varkost | 19.42 |
      | vmgk    | 175   |
      | fmgk    | 0.0   |
    And I save the current editor

# Rückmeldung stornieren
    Given I open an editor "Storno1" from table "(Workorder):(CompletionConfirmations)" with command "REVERSAL" for search criteria "$,,such=ON112001_001;@richtung=rückwärts;@ablageart=abgelegt;@maxtreffer=1"
    And I save the current editor
