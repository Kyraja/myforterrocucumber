@persistent
Feature: rueckgabe_materialentnahme_prozesstests.feature

  Background:
    Given I enable the flag 42
    And I set the fake date to "5.1.95"
# fake dates können mit std/test/fake_date_subst_in_cucumber.pl gepflegt werden. anleitung s. dort

# *****************************************************************************
#  Name             : rueckgabe_materialentnahme_prozesstests
#  Autor            : lschneider
#  Verantwortlich   : drpf
#  Kontrolle        : amk
#  Funktion         : Testet Rückgaben über die Materialentnahme
#  Jira-Issue       : FDA-539
# *****************************************************************************


  Scenario: 01 Teil-Rückgabe auf letzten AS, bisher nur Materialentnahme gebucht, Material in AFL manbu=nein
    Given I set the fake date to "6.1.95"
#Auftrag anlegen und Material einkaufen
    Given I create a SalesOrder "auftrag" for Customer "RADSHOP" with Product "BAUGRUPPE" and quantity "10"
    Given I open an editor "Rechnung" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
    And I set fields
      | lief   | KETTLER |
      | vom    | .       |
      | ueb    | ja      |
      | fakt   | ja      |
      | ebeleg | R-01    |
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
      | artikel   | netmge | bisuch   | mfreig |
      | BAUGRUPPE | 10     | MATENTN_ | ja     |
    And I set field "verw" in row !lastRow to "verw" from editor "auftrag" in row 1
    And I press button "freig" to open a subeditor for "BA_freigeben"
    And I close the current editor
    And I switch the current editor to editor "fvor"
    And I save the current editor

# Materialentnahme über gesamte Gutmenge
    Given I open an editor "Materialentnahme1" for tip command "Fbuchung" and arguments ""
    And I set field "auftrag" to "$,,such=MATENTN_001;@richtung=rückwärts;@maxtreffer=1"
    And I set field "bem" to "Entnahme"
    And I set field "autorment" to "ja"
    And I press button "stllad"
    And I save the current editor

# Bewertung prüfen
    Given I open an editor "Materialentnahme1" from table "(Workorder):(CompletionConfirmations)" with command "VIEW" for search criteria "$,,such=MATENTN_001;manrm=ja;@richtung=rückwärts;@maxtreffer=1;@ablageart=abgelegt"
    And I close the current editor

    Given I open an editor "Bewertung1" from table "(Valuation):(Valuation)" with command "VIEW" for search criteria "$,,artikel=EINKAUF-1;detursache=Materialentnahme Fertigung;@richtung=rückwärts;@maxtreffer=1"
    Then field "bewvorgang^vorgang^id" has value equal to field "id" from editor "Materialentnahme1"
    And I close the current editor

# Materialentnahme über Mengenvorschlag einen Teil des entnommenen Materials zurückbuchen
    Given I open an editor "Rückgabe1" for tip command "Fbuchung" and arguments ""
    And I set field "auftrag" to "$,,such=MATENTN_001;@richtung=rückwärts;@maxtreffer=1"
    And I set fields
      | gmgevorschl | -5 |
      | autorment   | ja |
    Then field "maxofmge" has value "ja"
    Then field "maxofmge" is not modifiable
    And I press button "stllad"
    And I set field "bem" to "Rückgabe"
    Then table has values
      | bumge | elex      | nlimge | chentmge | entmge |
      | -10   | EINKAUF-1 | 10     | 20       | 20     |
      | -5    | EINKAUF-2 | 5      | 10       | 10     |
    And I save the current editor

# Belege zu Materialentnahmme und -rückgabe prüfen, Bwertung hat Nachfolger
    Given I open an editor "Rückgabe1_pruef" from table "(Workorder):(CompletionConfirmations)" with command "VIEW" for search criteria "$,,such=MATENTN_001;bem=Rückgabe;@ablageart=abgelegt;@richtung=rückwärts;@maxtreffer=1"
    Then the table has 3 rows
    Then table has values
      | mge | artikel   | rueckmge | restmge | limgev | limgen |
      | 10  | BAUGRUPPE | 0        | 0       | 0      | 0      |
      | -5  | EINKAUF-2 | -5       | 0       | 0      | 5      |
      | -10 | EINKAUF-1 | -10      | 0       | 0      | 10     |
    And I close the current editor

    Given I open an editor "Materialentnahme1_pruef" from table "(Workorder):(CompletionConfirmations)" with command "VIEW" for search criteria "$,,such=MATENTN_001;bem=Entnahme;@ablageart=abgelegt;@richtung=rückwärts;@maxtreffer=1"
    Then the table has 3 rows
    Then table has values
      | mge | artikel   | rueckmge | restmge | limgev | limgen |
      | 10  | BAUGRUPPE | 0        | 0       | 0      | 0      |
      | 10  | EINKAUF-2 | 5        | 5       | 10     | 0      |
      | 20  | EINKAUF-1 | 10       | 10      | 20     | 0      |
    And I close the current editor

    And I switch the current editor to editor "Bewertung1" with command "VIEW"
    Then field "nachfolger" is not empty
    And I close the current editor

    Given I open an editor "Bewertung_nachf" via ID from editor "Bewertung1" from field "nachfolger" in row 0 for table "(Valuation):(Valuation)" with command "VIEW"
    Then field "bewvorgang^vorgang^id" has value equal to field "id" from editor "Materialentnahme1"
    And I close the current editor

# Lagerjournaleintrag prüfen
    Given I open the infosystem "LJ"
    And I set field "beleg" to "barmex" from editor "Materialentnahme1_pruef"
    And I set field "richtung" to "rückwärts"
    And I press start
    Then table has values
      | art       | amge | rueckmge | restmge |
      | EINKAUF-1 | -10  | -10      | 0       |
      | EINKAUF-2 | -5   | -5       | 0       |
      | EINKAUF-1 | 20   | 10       | 10      |
      | EINKAUF-2 | 10   | 5        | 5       |
    Then field "rueckorig^id" in row 1 has value equal to field "verweis^id" from editor "LJ" in row 3
    Then field "rueckorig^id" in row 2 has value equal to field "verweis^id" from editor "LJ" in row 4
    And I close the current editor

# offene Mengen im Arbeitsschein prüfen und Betriebsauftrag abschließen
    Given I open an editor "Betriebsauftrag" from table "(Workorder):(WorkOrders)" with command "VIEW" for record "MATENTN_000"
    Then field "mge" has value "10"
    And I press button "absteig" to open a subeditor for "AFL"
    Then field "limge" has value "10" in row 1
    Then field "limge" has value "5" in row 2
    And I close the current editor
    And I switch the current editor to editor "Betriebsauftrag"
    And I close the current editor

    Given I open an editor "Rückmeldung1" from table "(Workorder):(WorkOrders)" with command "DONE" for record "MATENTN_001"
    And I set fields
      | sofort | ja |
      | gut    | ja |
    And I save the current editor
    And I deliver the SalesOrder "auftrag" with PackingSlip "LS-MAN01"


  Scenario: 02 Gesamt-Rückgabe auf letzten AS, bisher nur Materialentnahme gebucht, Material in AFL manbu=nein
    Given I set the fake date to "7.1.95"
# Auftrag anlegen und Bedarf einkaufen
    Given I create a SalesOrder "auftrag" for Customer "RADSHOP" with Product "BAUGRUPPE" and quantity "10"
    Given I open an editor "Rechnung" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
    And I set fields
      | lief   | KETTLER |
      | vom    | .       |
      | ueb    | ja      |
      | fakt   | ja      |
      | ebeleg | R-02    |
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
      | BAUGRUPPE | 10     | MAXENT_ | ja     |
    And I set field "verw" in row !lastRow to "verw" from editor "auftrag" in row 1
    And I press button "freig" to open a subeditor for "BA_freigeben"
    And I close the current editor
    And I switch the current editor to editor "fvor"
    And I save the current editor

# Materialentnahme über gesamte Gutmenge
    Given I open an editor "Materialentnahme1" for tip command "Fbuchung" and arguments ""
    And I set field "auftrag" to "$,,such=MAXENT_001;@richtung=rückwärts;@maxtreffer=1"
    And I set field "autorment" to "ja"
    And I press button "stllad"
    And I set field "bem" to "Entnahme"
    And I save the current editor

# Bewertung prüfen
    Given I open an editor "Materialentnahme1" from table "(Workorder):(CompletionConfirmations)" with command "VIEW" for search criteria "$,,such=MAXENT_001;manrm=ja;@richtung=rückwärts;@maxtreffer=1;@ablageart=abgelegt"
    And I close the current editor

    Given I open an editor "Bewertung1" from table "(Valuation):(Valuation)" with command "VIEW" for search criteria "$,,artikel=EINKAUF-1;detursache=Materialentnahme Fertigung;@richtung=rückwärts;@maxtreffer=1"
    Then field "bewvorgang^vorgang^id" has value equal to field "id" from editor "Materialentnahme1"
    And I close the current editor

# Materialentnahme über Mengenvorschlag für mehr als die entnommene Menge
    Given I open an editor "Rückgabe1" for tip command "Fbuchung" and arguments ""
    And I set field "auftrag" to "$,,such=MAXENT_001;@richtung=rückwärts;@maxtreffer=1"
    And I set field "gmgevorschl" to "-15"
    And I set field "autorment" to "ja"
    And I set field "bem" to "Rückgabe"
    And I press button "stllad"
    Then table has values
      | bumge | elex      | nlimge | chentmge | entmge |
      | -20   | EINKAUF-1 | 20     | 20       | 20     |
      | -10   | EINKAUF-2 | 10     | 10       | 10     |
    And I save the current editor

# Belege zu Materialentnahmme und -rückgabe prüfen, Bewertung hat Nachfolger
    Given I open an editor "Rückgabe1_pruef" from table "(Workorder):(CompletionConfirmations)" with command "VIEW" for search criteria "$,,such=MAXENT_001;bem=Rückgabe;@ablageart=abgelegt;@richtung=rückwärts;@maxtreffer=1"
    Then the table has 3 rows
    Then table has values
      | mge | artikel   | rueckmge | restmge | limgev | limgen |
      | 10  | BAUGRUPPE | 0        | 0       | 0      | 0      |
      | -10 | EINKAUF-2 | -10      | 0       | 0      | 10     |
      | -20 | EINKAUF-1 | -20      | 0       | 0      | 20     |
    And I close the current editor

    Given I open an editor "Materialentnahme1_pruef" from table "(Workorder):(CompletionConfirmations)" with command "VIEW" for search criteria "$,,such=MAXENT_001;bem=Entnahme;@ablageart=abgelegt;@richtung=rückwärts;@maxtreffer=1"
    Then the table has 3 rows
    Then table has values
      | mge | artikel   | rueckmge | restmge | limgev | limgen |
      | 10  | BAUGRUPPE | 0        | 0       | 0      | 0      |
      | 10  | EINKAUF-2 | 10       | 0       | 10     | 0      |
      | 20  | EINKAUF-1 | 20       | 0       | 20     | 0      |
    And I close the current editor

    And I switch the current editor to editor "Bewertung1" with command "VIEW"
    Then field "nachfolger" is not empty
    And I close the current editor

    Given I open an editor "Bewertung_nachf" via ID from editor "Bewertung1" from field "nachfolger" in row 0 for table "(Valuation):(Valuation)" with command "VIEW"
    Then field "bewvorgang^vorgang^id" has value equal to field "id" from editor "Materialentnahme1"
    And I close the current editor

# offene Mengen im Arbeitsschein prüfen und Betriebsauftrag abschließen
    Given I open an editor "Betriebsauftrag" from table "(Workorder):(WorkOrders)" with command "UPDATE" for record "MAXENT_000"
    Then field "mge" has value "10"
    And I press button "absteig" to open a subeditor for "AFL"
    Then field "limge" has value "20" in row 1
    Then field "limge" has value "10" in row 2
    And I close the current editor
    And I switch the current editor to editor "Betriebsauftrag"
    And I close the current editor

    Given I open an editor "Rückmeldung1" from table "(Workorder):(WorkOrders)" with command "DONE" for record "MAXENT_001"
    And I set fields
      | sofort | ja |
      | gut    | ja |
    And I save the current editor
    And I deliver the SalesOrder "auftrag" with PackingSlip "LS-MAN02"


  Scenario: 03 Teil-Rückgabe auf letzten AS, bisher nur Materialentnahme gebucht, Material in AFL manbu=ja
    Given I set the fake date to "8.1.95"
#Auftrag anlegen und Bedarfe einkaufen
    Given I create a SalesOrder "auftrag" for Customer "RADSHOP" with Product "M_BAUGRUPPE" and quantity "10"
    Given I open an editor "Rechnung" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
    And I set fields
      | lief   | KETTLER |
      | vom    | .       |
      | ueb    | ja      |
      | fakt   | ja      |
      | ebeleg | R-03    |
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
      | artikel     | netmge | bisuch | mfreig |
      | M_BAUGRUPPE | 10     | MANBU_ | ja     |
    And I set field "verw" in row !lastRow to "verw" from editor "auftrag" in row 1
    And I press button "freig" to open a subeditor for "BA_freigeben"
    And I close the current editor
    And I switch the current editor to editor "fvor"
    And I save the current editor

# Materialentnahme über gesamte Gutmenge
    Given I open an editor "Materialentnahme1" for tip command "Fbuchung" and arguments ""
    And I set field "auftrag" to "$,,such=MANBU_001;@richtung=rückwärts;@maxtreffer=1"
    And I set field "bem" to "Entnahme"
    And I press button "stllad"
    And I save the current editor

# Bewertung prüfen
    Given I open an editor "Materialentnahme1" from table "(Workorder):(CompletionConfirmations)" with command "VIEW" for search criteria "$,,such=MANBU_001;manrm=ja;@richtung=rückwärts;@maxtreffer=1;@ablageart=abgelegt"
    And I close the current editor

    Given I open an editor "Bewertung1" from table "(Valuation):(Valuation)" with command "VIEW" for search criteria "$,,artikel=EINKAUF-1;detursache=Materialentnahme Fertigung;@richtung=rückwärts;@maxtreffer=1"
    Then field "bewvorgang^vorgang^id" has value equal to field "id" from editor "Materialentnahme1"
    And I close the current editor

# Materialentnahme über Mengenvorschlag einen Teil des entnommenen Materials zurückbuchen
    Given I open an editor "Rückgabe1" for tip command "Fbuchung" and arguments ""
    And I set field "auftrag" to "$,,such=MANBU_001;@richtung=rückwärts;@maxtreffer=1"
    And I set fields
      | gmgevorschl | -5 |
      | autorment   | ja |
    Then field "maxofmge" has value "ja"
    Then field "maxofmge" is not modifiable
    And I press button "stllad"
    And I set field "bem" to "Rückgabe"
    Then table has values
      | bumge | elex      | nlimge | chentmge | entmge |
      | -10   | EINKAUF-1 | 10     | 20       | 20     |
      | -5    | EINKAUF-2 | 5      | 10       | 10     |
    And I save the current editor

# Belege zu Materialentnahmme und -rückgabe prüfen, Bwertung hat Nachfolger
    Given I open an editor "Rückgabe1_pruef" from table "(Workorder):(CompletionConfirmations)" with command "VIEW" for search criteria "$,,such=MANBU_001;bem=Rückgabe;@ablageart=abgelegt;@richtung=rückwärts;@maxtreffer=1"
    Then the table has 3 rows
    Then table has values
      | mge | artikel     | rueckmge | restmge | limgev | limgen |
      | 10  | M_BAUGRUPPE | 0        | 0       | 0      | 0      |
      | -5  | EINKAUF-2   | -5       | 0       | 0      | 5      |
      | -10 | EINKAUF-1   | -10      | 0       | 0      | 10     |
    And I close the current editor

    Given I open an editor "Materialentnahme1_pruef" from table "(Workorder):(CompletionConfirmations)" with command "VIEW" for search criteria "$,,such=MANBU_001;bem=Entnahme;@ablageart=abgelegt;@richtung=rückwärts;@maxtreffer=1"
    Then the table has 3 rows
    Then table has values
      | mge | artikel     | rueckmge | restmge | limgev | limgen |
      | 10  | M_BAUGRUPPE | 0        | 0       | 0      | 0      |
      | 10  | EINKAUF-2   | 5        | 5       | 10     | 0      |
      | 20  | EINKAUF-1   | 10       | 10      | 20     | 0      |
    And I close the current editor

    And I switch the current editor to editor "Bewertung1" with command "VIEW"
    Then field "nachfolger" is not empty
    And I close the current editor

    Given I open an editor "Bewertung_nachf" via ID from editor "Bewertung1" from field "nachfolger" in row 0 for table "(Valuation):(Valuation)" with command "VIEW"
    Then field "bewvorgang^vorgang^id" has value equal to field "id" from editor "Materialentnahme1"
    And I close the current editor

# Lagerjournaleintrag prüfen
    Given I open the infosystem "LJ"
    And I set field "beleg" to "barmex" from editor "Materialentnahme1_pruef"
    And I set field "richtung" to "rückwärts"
    And I press start
    Then table has values
      | art       | amge | rueckmge | restmge |
      | EINKAUF-1 | -10  | -10      | 0       |
      | EINKAUF-2 | -5   | -5       | 0       |
      | EINKAUF-1 | 20   | 10       | 10      |
      | EINKAUF-2 | 10   | 5        | 5       |
    Then field "rueckorig^id" in row 1 has value equal to field "verweis^id" from editor "LJ" in row 3
    Then field "rueckorig^id" in row 2 has value equal to field "verweis^id" from editor "LJ" in row 4
    And I close the current editor

# offene Mengen im Arbeitsschein prüfen und Betriebsauftrag abschließen
    Given I open an editor "Betriebsauftrag" from table "(Workorder):(WorkOrders)" with command "VIEW" for record "MANBU_000"
    Then field "mge" has value "10"
    And I press button "absteig" to open a subeditor for "AFL"
    Then field "limge" has value "10" in row 1
    Then field "limge" has value "5" in row 2
    And I close the current editor
    And I switch the current editor to editor "Betriebsauftrag"
    And I close the current editor

    Given I open an editor "Rückmeldung1" from table "(Workorder):(WorkOrders)" with command "DONE" for record "MANBU_001"
    And I set fields
      | sofort  | ja |
      | gut     | ja |
      | manrest | ja |
    And I save the current editor
    And I deliver the SalesOrder "auftrag" with PackingSlip "LS-MAN03"


  Scenario: 04 Teil-Rückgabe auf letzten AS, bisher eine Rückmledung auf letzten AS, Material in AFL manbu=ja
    Given I set the fake date to "9.1.95"
#Auftrag anlegen und Bedarfe einkaufen
    Given I create a SalesOrder "auftrag" for Customer "RADSHOP" with Product "BAUGRUPPE" and quantity "10"
    Given I open an editor "Rechnung" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
    And I set fields
      | lief   | KETTLER |
      | vom    | .       |
      | ueb    | ja      |
      | fakt   | ja      |
      | ebeleg | R-04    |
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
      | artikel   | netmge | bisuch    | mfreig |
      | BAUGRUPPE | 10     | RETROMAN_ | ja     |
    And I set field "verw" in row !lastRow to "verw" from editor "auftrag" in row 1
    And I press button "freig" to open a subeditor for "BA_freigeben"
    And I close the current editor
    And I switch the current editor to editor "fvor"
    And I save the current editor

# Teil-Rückmeldung aus ersten Arbeitsgang
    Given I open an editor "Rückmeldung1" from table "(Workorder):(WorkOrders)" with command "DONE" for record "RETROMAN_001"
    And I set fields
      | sofort | ja |
    And I set field "gutmge" to "7" in row 1
    And I save the current editor

# Bewertung prüfen
    Given I open an editor "Bewertung1" from table "(Valuation):(Valuation)" with command "VIEW" for search criteria "$,,artikel=EINKAUF-1;detursache=Rückmeldung Fertigung;@richtung=rückwärts;@maxtreffer=1"
    Then field "bewvorgang^vorgang^id" has value equal to field "id" from editor "Rückmeldung1"
    And I close the current editor

# Materialentnahme über Mengenvorschlag einen Teil des entnommenen Materials zurückbuchen
    Given I open an editor "Rückgabe1" for tip command "Fbuchung" and arguments ""
    And I set field "auftrag" to "$,,such=RETROMAN_001;@richtung=rückwärts;@maxtreffer=1"
    And I set fields
      | gmgevorschl | -2 |
      | autorment   | ja |
    Then field "maxofmge" has value "ja"
    Then field "maxofmge" is not modifiable
    And I press button "stllad"
    And I set field "bem" to "Rückgabe"
    Then table has values
      | bumge | elex      | nlimge | chentmge | entmge |
      | -4    | EINKAUF-1 | 10     | 14       | 14     |
      | -2    | EINKAUF-2 | 5      | 7        | 7      |
    And I save the current editor

# Belege zu Materialentnahmme und -rückgabe prüfen, Bewertung hat Nachfolger
    Given I open an editor "Rückgabe1_pruef" from table "(Workorder):(CompletionConfirmations)" with command "VIEW" for search criteria "$,,such=RETROMAN_001;bem=Rückgabe;@ablageart=abgelegt;@richtung=rückwärts;@maxtreffer=1"
    Then the table has 3 rows
    Then table has values
      | mge | artikel   | rueckmge | restmge | limgev | limgen |
      | 3   | BAUGRUPPE | 0        | 0       | 7      | 7      |
      | -2  | EINKAUF-2 | -2       | 0       | 3      | 5      |
      | -4  | EINKAUF-1 | -4       | 0       | 6      | 10     |
    And I close the current editor

    And I switch the current editor to editor "Rückmeldung1" with command "VIEW"
    Then the table has 3 rows
    Then table has values
      | mge | artikel   | rueckmge | restmge | limgev | limgen |
      | 10  | BAUGRUPPE | 0        | 7       | 0      | 7      |
      | 7   | EINKAUF-2 | 2        | 5       | 10     | 3      |
      | 14  | EINKAUF-1 | 4        | 10      | 20     | 6      |
    And I close the current editor

    And I switch the current editor to editor "Bewertung1" with command "VIEW"
    Then field "nachfolger" is not empty
    And I close the current editor

    Given I open an editor "Bewertung_nachf" via ID from editor "Bewertung1" from field "nachfolger" in row 0 for table "(Valuation):(Valuation)" with command "VIEW"
    Then field "bewvorgang^vorgang^id" has value equal to field "id" from editor "Rückmeldung1"
    And I close the current editor

    Given I open an editor "Bewertung_Rückmeldung" from table "(Valuation):(Valuation)" with command "VIEW" for search criteria "$,,artikel=BAUGRUPPE;detursache=Rückmeldung Fertigung;@richtung=rückwärts;@maxtreffer=1"
    Then field "nachfolger" is empty
    And I close the current editor

# Lagerjournaleintrag prüfen
    Given I open the infosystem "LJ"
    And I set field "beleg" to "barmex" from editor "Rückmeldung1"
    And I set field "richtung" to "rückwärts"
    And I press start
    Then table has values
      | art       | amge | zmge | rueckmge | restmge |
      | EINKAUF-1 | -4   |      | -4       | 0       |
      | EINKAUF-2 | -2   |      | -2       | 0       |
      | BAUGRUPPE |      | 7    | 0        | 7       |
      | EINKAUF-1 | 14   |      | 4        | 10      |
      | EINKAUF-2 | 7    |      | 2        | 5       |
    Then field "rueckorig^id" in row 1 has value equal to field "verweis^id" from editor "LJ" in row 4
    Then field "rueckorig^id" in row 2 has value equal to field "verweis^id" from editor "LJ" in row 5
    And I close the current editor

# Betriebsauftrag abschließen und Auftrag liefern
    Given I open an editor "Rückmeldung2" from table "(Workorder):(WorkOrders)" with command "DONE" for record "RETROMAN_001"
    And I set fields
      | sofort  | ja |
      | gut     | ja |
      | manrest | ja |
    And I save the current editor
    And I deliver the SalesOrder "auftrag" with PackingSlip "LS-MAN04"


  Scenario: 05 Teil-Rückgabe mit Chargenangabe auf letzten AS, bisher Rückmeldung gebucht, EntnahmeMZ mit Chargen vor Freigabe FV angelegt, Material in AFL manbu=nein
    Given I set the fake date to "10.1.95"
# Chargen anlegen
    Given I create a Lot "MAT01-01" for Product "EINKAUF-1"
    Given I create a Lot "MAT01-02" for Product "EINKAUF-1"
    Given I create a Lot "MAT02-01" for Product "EINKAUF-2"
    Given I create a Lot "MAT02-02" for Product "EINKAUF-2"

#Auftrag anlegen und Bedarfe einkaufen
    Given I create a SalesOrder "auftrag" for Customer "RADSHOP" with Product "BAUGRUPPE" and quantity "10"
    Given I open an editor "Rechnung" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
    And I set fields
      | lief   | KETTLER |
      | vom    | .       |
      | ueb    | ja      |
      | fakt   | ja      |
      | ebeleg | R-05    |
    And I append rows
      | artikel   | mge | charge       |
      | EINKAUF-1 | 10  | !MAT01-01^id |
      | EINKAUF-1 | 10  | !MAT01-02^id |
      | EINKAUF-2 | 5   | !MAT02-01^id |
      | EINKAUF-2 | 5   | !MAT02-02^id |
    And I set field "verw" in row 1 to "verw" from editor "auftrag" in row 1
    And I set field "verw" in row 2 to "verw" from editor "auftrag" in row 1
    And I set field "verw" in row 3 to "verw" from editor "auftrag" in row 1
    And I set field "verw" in row 4 to "verw" from editor "auftrag" in row 1
    And I respond with answer "ja" to the dialog with id "4841"
    And I save the current editor

# Fertigungsvorschlag anlegen und freigeben
    Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
    And I append rows
      | artikel   | netmge | mfreig |
      | BAUGRUPPE | 10     | ja     |
    And I set field "verw" in row !lastRow to "verw" from editor "auftrag" in row !lastRow
    And I press button "mzabsm" to open a subeditor for "EntnahmeMZ" in row !lastRow
    And I modify table
      | !row | zuomge | charge       |
      | +1   | 10     | !MAT01-01^id |
      | +2   | 10     | !MAT01-02^id |
    And I press button "abv" to open a subeditor for "mz2"
    And I close the current editor
    And I switch the current editor to editor "EntnahmeMZ"
    And I modify table
      | !row | zuomge | charge       |
      | +1   | 5      | !MAT02-01^id |
      | +2   | 5      | !MAT02-02^id |
    And I save the current editor
    And I switch the current editor to editor "fvor"
    And I set field "bisuch" to "CHARGERED_" in row !lastRow
    And I press button "freig" to open a subeditor for "BA_freigeben"
    And I close the current editor
    And I switch the current editor to editor "fvor"
    And I save the current editor

# Rückmeldung auf ersten Arbeitsgang
    Given I open an editor "Rückmeldung1" from table "(Workorder):(WorkOrders)" with command "DONE" for record "CHARGERED_001"
    And I set fields
      | sofort | ja |
    And I set field "gutmge" to "8" in row 1
    And I save the current editor

# Materialentnahme über Mengenvorschlag einen Teil des entnommenen Materials zurückbuchen
    Given I open an editor "Rückgabe1" for tip command "Fbuchung" and arguments ""
    And I set field "auftrag" to "!Rückmeldung1^barmex"
    And I set fields
      | gmgevorschl | -5 |
      | autorment   | ja |
    Then field "maxofmge" has value "ja"
    Then field "maxofmge" is not modifiable
    And I press button "stllad"
    And I set field "bem" to "Rückgabe"
    And I modify table
      | !row | manbu | rescharge    |
      | 1    | ja    | !MAT01-01^id |
      | 2    | ja    | !MAT02-01^id |
    Then table has values
      | bumge | elex      | nlimge | limge | chentmge | entmge | rescharge^such |
      | -10   | EINKAUF-1 | 14     | 4     | 10       | 16     | MAT01-01       |
      | -5    | EINKAUF-2 | 7      | 2     | 5        | 8      | MAT02-01       |
    And I save the current editor

# Belege zu Materialentnahmme und -rückgabe prüfen
    Given I open an editor "Rückgabe1_pruef" from table "(Workorder):(CompletionConfirmations)" with command "VIEW" for search criteria "$,,such=CHARGERED_001;bem=Rückgabe;@ablageart=abgelegt;@richtung=rückwärts;@maxtreffer=1"
    Then the table has 3 rows
    Then table has values
      | mge | artikel   | rueckmge | restmge | limgev | limgen |
      | 2   | BAUGRUPPE | 0        | 0       | 8      | 8      |
      | -5  | EINKAUF-2 | -5       | 0       | 2      | 7      |
      | -10 | EINKAUF-1 | -10      | 0       | 4      | 14     |
    And I close the current editor

    Given I switch the current editor to editor "Rückmeldung1" with command "VIEW"
    Then the table has 3 rows
    Then table has values
      | mge | artikel   | rueckmge | restmge | limgev | limgen |
      | 10  | BAUGRUPPE | 0        | 8       | 0      | 8      |
      | 8   | EINKAUF-2 | 5        | 3       | 10     | 2      |
      | 16  | EINKAUF-1 | 10       | 6       | 20     | 4      |
    And I close the current editor

# Lagerjournaleintrag prüfen
    Given I open the infosystem "LJ"
    And I set field "beleg" to "barmex" from editor "Rückmeldung1"
    And I set field "richtung" to "rückwärts"
    And I press start
    Then table has values
      | art       | amge | zmge | rueckmge | restmge | vcharge^such | !row |
      | EINKAUF-1 | -10  |      | -10      | 0       | MAT01-01     | 1    |
      | EINKAUF-2 | -5   |      | -5       | 0       | MAT02-01     | 2    |
      | BAUGRUPPE |      | 8    | 0        | 8       |              | 3    |
      | EINKAUF-1 | 6    |      | 0        | 6       | MAT01-02     | 4    |
      | EINKAUF-1 | 10   |      | 10       | 0       | MAT01-01     | 5    |
      | EINKAUF-2 | 3    |      | 0        | 3       | MAT02-02     | 6    |
      | EINKAUF-2 | 5    |      | 5        | 0       | MAT02-01     | 7    |
    Then field "rueckorig^id" in row 1 has value equal to field "verweis^id" from editor "LJ" in row 5
    Then field "rueckorig^id" in row 2 has value equal to field "verweis^id" from editor "LJ" in row 7
    And I close the current editor

# Betriebsauftrag abschließen und Auftrag liefern
    Given I open an editor "Rückmeldung1" from table "(Workorder):(WorkOrders)" with command "DONE" for record "CHARGERED_001"
    And I set fields
      | sofort  | ja |
      | gut     | ja |
      | manrest | ja |
    And I save the current editor
    And I deliver the SalesOrder "auftrag" with PackingSlip "LS-RED05"


  Scenario: 06 Teil-Rückgabe mit Chargenangabe auf letzten AS, bisher EntnahmeMZ mit Chargen vor Freigabe FV angelegt, Material in AFL manbu=ja
    Given I set the fake date to "11.1.95"
# Chargen anlegen
    Given I create a Lot "MAT01-03" for Product "EINKAUF-1"
    Given I create a Lot "MAT01-04" for Product "EINKAUF-1"
    Given I create a Lot "MAT02-03" for Product "EINKAUF-2"
    Given I create a Lot "MAT02-04" for Product "EINKAUF-2"

#Auftrag anlegen und Bedarfe einkaufen
    Given I create a SalesOrder "auftrag" for Customer "RADSHOP" with Product "M_BAUGRUPPE" and quantity "10"
    Given I open an editor "Rechnung" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
    And I set fields
      | lief   | KETTLER |
      | vom    | .       |
      | ueb    | ja      |
      | fakt   | ja      |
      | ebeleg | R-05    |
    And I append rows
      | artikel   | mge | charge       |
      | EINKAUF-1 | 10  | !MAT01-03^id |
      | EINKAUF-1 | 10  | !MAT01-04^id |
      | EINKAUF-2 | 5   | !MAT02-03^id |
      | EINKAUF-2 | 5   | !MAT02-04^id |
    And I respond with answer "ja" to the dialog with id "4841"
    And I save the current editor

# Fertigungsvorschlag anlegen und freigeben
    Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
    And I append rows
      | artikel     | netmge | mfreig |
      | M_BAUGRUPPE | 10     | ja     |
    And I set field "verw" in row !lastRow to "verw" from editor "auftrag" in row !lastRow
    And I press button "mzabsm" to open a subeditor for "EntnahmeMZ" in row !lastRow
    And I modify table
      | !row | zuomge | charge       |
      | +1   | 10     | !MAT01-03^id |
      | +2   | 10     | !MAT01-04^id |
    And I press button "abv" to open a subeditor for "mz2"
    And I close the current editor
    And I switch the current editor to editor "EntnahmeMZ"
    And I modify table
      | !row | zuomge | charge       |
      | +1   | 5      | !MAT02-03^id |
      | +2   | 5      | !MAT02-04^id |
    And I save the current editor
    And I switch the current editor to editor "fvor"
    And I set field "bisuch" to "CHARGEMAN_" in row !lastRow
    And I press button "freig" to open a subeditor for "BA_freigeben"
    And I close the current editor
    And I switch the current editor to editor "fvor"
    And I save the current editor

# Materialentnahme über gesamte Menge
    Given I open an editor "Materialentnahme1" for tip command "Fbuchung" and arguments ""
    And I set field "auftrag" to "$,,such=CHARGEMAN_001;@richtung=rückwärts;@maxtreffer=1"
    And I set field "bem" to "Entnahme"
    And I press button "stllad"
    And I save the current editor

# Materialentnahme über Mengenvorschlag einen Teil des entnommenen Materials zurückbuchen
    Given I open an editor "Rückgabe1" for tip command "Fbuchung" and arguments ""
    And I set field "auftrag" to "$,,such=CHARGEMAN_001;@richtung=rückwärts;@maxtreffer=1"
    And I set fields
      | gmgevorschl | -5 |
    Then field "maxofmge" has value "ja"
    Then field "maxofmge" is not modifiable
    And I press button "stllad"
    And I set field "bem" to "Rückgabe"
    Then table has values
      | bumge | elex      | nlimge | limge | chentmge | entmge | rescharge^such |
      | -10   | EINKAUF-1 | 10     | 0     | 0        | 20     |                |
      | -5    | EINKAUF-2 | 5      | 0     | 0        | 10     |                |
    And I modify table
      | !row | rescharge    |
      | 1    | !MAT01-04^id |
      | 2    | !MAT02-03^id |
    Then table has values
      | bumge | elex      | nlimge | limge | chentmge | entmge | rescharge^such |
      | -10   | EINKAUF-1 | 10     | 0     | 10       | 20     | MAT01-04       |
      | -5    | EINKAUF-2 | 5      | 0     | 5        | 10     | MAT02-03       |
    And I save the current editor

# Belege zu Materialentnahmme und -rückgabe prüfen
    Given I open an editor "Rückgabe1_pruef" from table "(Workorder):(CompletionConfirmations)" with command "VIEW" for search criteria "$,,such=CHARGEMAN_001;bem=Rückgabe;@ablageart=abgelegt;@richtung=rückwärts;@maxtreffer=1"
    Then the table has 3 rows
    Then table has values
      | mge | artikel     | rueckmge | restmge | limgev | limgen |
      | 10  | M_BAUGRUPPE | 0        | 0       | 0      | 0      |
      | -5  | EINKAUF-2   | -5       | 0       | 0      | 5      |
      | -10 | EINKAUF-1   | -10      | 0       | 0      | 10     |
    And I close the current editor

    Given I open an editor "Materialentnahme1_pruef" from table "(Workorder):(CompletionConfirmations)" with command "VIEW" for search criteria "$,,such=CHARGEMAN_001;bem=Entnahme;@ablageart=abgelegt;@richtung=rückwärts;@maxtreffer=1"
    Then the table has 3 rows
    Then table has values
      | mge | artikel     | rueckmge | restmge | limgev | limgen |
      | 10  | M_BAUGRUPPE | 0        | 0       | 0      | 0      |
      | 10  | EINKAUF-2   | 5        | 5       | 10     | 0      |
      | 20  | EINKAUF-1   | 10       | 10      | 20     | 0      |
    And I close the current editor

# Lagerjournaleintrag prüfen
    Given I open the infosystem "LJ"
    And I set field "beleg" to "barmex" from editor "Materialentnahme1_pruef"
    And I set field "richtung" to "rückwärts"
    And I press start
    Then table has values
      | art       | amge | rueckmge | restmge | vcharge^such | !row | detursache                 |
      | EINKAUF-1 | -10  | -10      | 0       | MAT01-04     | 1    | Materialrückgabe Fertigung |
      | EINKAUF-2 | -5   | -5       | 0       | MAT02-03     | 2    | Materialrückgabe Fertigung |
      | EINKAUF-1 | 10   | 10       | 0       | MAT01-04     | 3    | Materialentnahme Fertigung |
      | EINKAUF-1 | 10   | 0        | 10      | MAT01-03     | 4    | Materialentnahme Fertigung |
      | EINKAUF-2 | 5    | 0        | 5       | MAT02-04     | 5    | Materialentnahme Fertigung |
      | EINKAUF-2 | 5    | 5        | 0       | MAT02-03     | 6    | Materialentnahme Fertigung |
    Then field "rueckorig^id" in row 1 has value equal to field "verweis^id" from editor "LJ" in row 3
    Then field "rueckorig^id" in row 2 has value equal to field "verweis^id" from editor "LJ" in row 6
    And I close the current editor

# Betriebsauftrag abschließen und Auftrag liefern
    Given I open an editor "Rückmeldung1" from table "(Workorder):(WorkOrders)" with command "DONE" for record "CHARGEMAN_001"
    And I set fields
      | sofort  | ja |
      | gut     | ja |
      | manrest | ja |
    And I save the current editor
    And I deliver the SalesOrder "auftrag" with PackingSlip "LS-MAN06"


  Scenario: 07 Gesamt-Rückgabe der Charge auf letzten AS und durch Entnahme anderer Charge ersetzen, bisher Materialentnahme für Charge gebucht, EntnahmeMZ mit einer Chargen vor Freigabe FV angelegt
    Given I set the fake date to "12.1.95"
# Bestand auf 0 korrigieren
    Given I set StorageQuantity to zero for Product "EINKAUF-1" on StorageLocation "F1"
    Given I set StorageQuantity to zero for Product "EINKAUF-2" on StorageLocation "F1"

#Chargen anlegen
    Given I create a Lot "GOOD_CH" for Product "EINKAUF-1"
    Given I create a Lot "BAD_CH" for Product "EINKAUF-1"

#Auftrag anlegen und Bedarfe einkaufen
    Given I create a SalesOrder "auftrag" for Customer "RADSHOP" with Product "M_BAUGRUPPE" and quantity "10"
    Given I open an editor "Rechnung" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
    And I set fields
      | lief   | KETTLER |
      | vom    | .       |
      | ueb    | ja      |
      | fakt   | ja      |
      | ebeleg | R-07    |
    And I append rows
      | artikel   | mge | charge      |
      | EINKAUF-1 | 10  | !GOOD_CH^id |
      | EINKAUF-1 | 20  | !BAD_CH^id  |
      | EINKAUF-1 | 10  |             |
      | EINKAUF-2 | 10  |             |
    And I respond with answer "ja" to the dialog with id "4841"
    And I save the current editor

# Fertigungsvorschlag anlegen und freigeben
    Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
    And I append rows
      | artikel     | netmge | mfreig |
      | M_BAUGRUPPE | 10     | ja     |
    And I set field "verw" in row !lastRow to "verw" from editor "auftrag" in row !lastRow
    And I press button "mzabsm" to open a subeditor for "EntnahmeMZ" in row !lastRow
    And I modify table
      | !row | zuomge | charge     |
      | +1   | 20     | !BAD_CH^id |
    And I save the current editor
    And I switch the current editor to editor "fvor"
    And I set field "bisuch" to "AUSTAUSCH_" in row !lastRow
    And I press button "freig" to open a subeditor for "BA_freigeben"
    And I close the current editor
    And I switch the current editor to editor "fvor"
    And I save the current editor

# Materialentnahme über gesamte Gutmenge
    Given I open an editor "Materialentnahme1" for tip command "Fbuchung" and arguments ""
    And I set field "auftrag" to "$,,such=AUSTAUSCH_001;@richtung=rückwärts;@maxtreffer=1"
    And I set field "bem" to "Entnahme1"
    And I press button "stllad"
    And I save the current editor

# Über Materialentnahme das entnommenen Materials zurückbuchen
    Given I open an editor "Rückgabe1" for tip command "Fbuchung" and arguments ""
    And I set field "auftrag" to "$,,such=AUSTAUSCH_001;@richtung=rückwärts;@maxtreffer=1"
    And I press button "stllad"
    And I set field "bem" to "Rückgabe"
    And I modify table
      | !row | bumge |
      | 1    | -20   |
    Then field "chentmge" has value "0" in row 1
    And I set field "rescharge" to "!BAD_CH^id" in row 1
    Then table has values
      | bumge | elex      | nlimge | limge | chentmge | entmge | rescharge^such |
      | -20   | EINKAUF-1 | 20     | 0     | 20       | 20     | BAD_CH         |
      | 0     | EINKAUF-2 | 0      | 0     | 10       | 10     |                |
    And I save the current editor

# Belege zu Materialentnahmme und -rückgabe prüfen
    Given I open an editor "Rückgabe1_pruef" from table "(Workorder):(CompletionConfirmations)" with command "VIEW" for search criteria "$,,such=AUSTAUSCH_001;bem=Rückgabe;@ablageart=abgelegt;@richtung=rückwärts;@maxtreffer=1"
    Then the table has 2 rows
    Then table has values
      | mge | artikel     | rueckmge | restmge | limgev | limgen |
      | 10  | M_BAUGRUPPE | 0        | 0       | 0      | 0      |
      | -20 | EINKAUF-1   | -20      | 0       | 0      | 20     |
    And I close the current editor

    Given I open an editor "Materialentnahme1_pruef" from table "(Workorder):(CompletionConfirmations)" with command "VIEW" for search criteria "$,,such=AUSTAUSCH_001;bem=Entnahme1;@ablageart=abgelegt;@richtung=rückwärts;@maxtreffer=1"
    Then the table has 3 rows
    Then table has values
      | mge | artikel     | rueckmge | restmge | limgev | limgen |
      | 10  | M_BAUGRUPPE | 0        | 0       | 0      | 0      |
      | 10  | EINKAUF-2   | 0        | 10      | 10     | 0      |
      | 20  | EINKAUF-1   | 20       | 0       | 20     | 0      |
    And I close the current editor

# Zweite Charge entnehmen
    Given I open an editor "Materialentnahme2" for tip command "Fbuchung" and arguments ""
    And I set field "auftrag" to "$,,such=AUSTAUSCH_001;@richtung=rückwärts;@maxtreffer=1"
    And I set field "bem" to "Entnahme2"
    And I press button "stllad"
    And I modify table
      | !row | bumge |
      | 1    | 10    |
	And I press button "mzsubm" to open a subeditor for "MZ" in row 1
	And I set field "zuomge" to "10" in row 1
	And I set field "charge" to "!GOOD_CH^id" in row 1
	And I save the current editor
	And I switch the current editor to editor "Materialentnahme2"
    And I save the current editor

# Belege zu Materialentnahmmen prüfen
    Given I open an editor "Materialentnahme1_pruef" from table "(Workorder):(CompletionConfirmations)" with command "VIEW" for search criteria "$,,such=AUSTAUSCH_001;bem=Entnahme1;@ablageart=abgelegt;@richtung=rückwärts;@maxtreffer=1"
    Then the table has 3 rows
    Then table has values
      | mge | artikel     | rueckmge | restmge | limgev | limgen |
      | 10  | M_BAUGRUPPE | 0        | 0       | 0      | 0      |
      | 10  | EINKAUF-2   | 0        | 10      | 10     | 0      |
      | 20  | EINKAUF-1   | 20       | 0       | 20     | 0      |
    And I close the current editor

    Given I open an editor "Materialentnahme2_pruef" from table "(Workorder):(CompletionConfirmations)" with command "VIEW" for search criteria "$,,such=AUSTAUSCH_001;bem=Entnahme2;@ablageart=abgelegt;@richtung=rückwärts;@maxtreffer=1"
    Then the table has 2 rows
    Then table has values
      | mge | artikel     | rueckmge | restmge | limgev | limgen |
      | 10  | M_BAUGRUPPE | 0        | 0       | 0      | 0      |
      | 10  | EINKAUF-1   | 0        | 10      | 20     | 10     |
    And I close the current editor

# Lagerjournaleintrag prüfen
    Given I open the infosystem "LJ"
    And I set field "beleg" to "barmex" from editor "Materialentnahme1_pruef"
    And I set field "richtung" to "rückwärts"
    And I press start
    Then table has values
      | art       | amge | rueckmge | restmge | vcharge^such | !row |
      | EINKAUF-1 | 10   | 0        | 10      | GOOD_CH      | 1    |
      | EINKAUF-1 | -20  | -20      | 0       | BAD_CH       | 2    |
      | EINKAUF-1 | 20   | 20       | 0       | BAD_CH       | 3    |
      | EINKAUF-2 | 10   | 0        | 10      |              | 4    |
    Then field "rueckorig^id" in row 2 has value equal to field "verweis^id" from editor "LJ" in row 3
    And I close the current editor

# Betriebsauftrag abschließen und Auftrag liefern
    Given I open an editor "Rückmeldung1" from table "(Workorder):(WorkOrders)" with command "DONE" for record "AUSTAUSCH_001"
    And I set fields
      | sofort  | ja |
      | gut     | ja |
      | manrest | ja |
    And I save the current editor
    And I deliver the SalesOrder "auftrag" with PackingSlip "LS-MAN01"


  Scenario: 08 Teil-Rückgabe auf letzten AS mit und ohne Chargen, das mehrere Materialentnahmen und RM betrifft, bisher zwei Materialentnahmen über Teilmenge und Rückmeldung mit manrest=ja gebucht
    Given I set the fake date to "13.1.95"
#Auftrag anlegen und Bedarfe einkaufen
    Given I create a SalesOrder "auftrag" for Customer "RADSHOP" with Product "M_BAUGRUPPE" and quantity "50"
    Given I open an editor "Rechnung" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
    And I set fields
      | lief   | KETTLER |
      | vom    | .       |
      | ueb    | ja      |
      | fakt   | ja      |
      | ebeleg | R-08    |
    And I append rows
      | artikel   | mge |
      | EINKAUF-1 | 30  |
      | EINKAUF-1 | 30  |
      | EINKAUF-1 | 40  |
      | EINKAUF-2 | 50  |
    And I set field "verw" in row 1 to "verw" from editor "auftrag" in row 1
    And I set field "verw" in row 2 to "verw" from editor "auftrag" in row 1
    And I set field "verw" in row 3 to "verw" from editor "auftrag" in row 1
    And I set field "verw" in row 4 to "verw" from editor "auftrag" in row 1
    And I respond with answer "ja" to the dialog with id "4841"
    And I save the current editor

# Fertigungsvorschlag anlegen und freigeben
    Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
    And I append rows
      | artikel     | netmge | mfreig | bisuch   |
      | M_BAUGRUPPE | 50     | ja     | MANREST_ |
    And I set field "verw" in row !lastRow to "verw" from editor "auftrag" in row 1
    And I press button "freig" to open a subeditor for "BA_freigeben"
    And I close the current editor
    And I switch the current editor to editor "fvor"
    And I save the current editor

    Given I open an editor "Arbeitsschein1" from table "(Workorder):(WorkOrders)" with command "VIEW" for record "MANREST_001" and menu choice "<string>"
    And I close the current editor

# Materialentnahmen über Teilmengen und Rückmeldung
    Given I open an editor "Materialentnahme1" for tip command "Fbuchung" and arguments ""
    And I set fields
      | auftrag     | !Arbeitsschein1^nummer |
      | bem         | Entnahme1              |
      | gmgevorschl | 10                     |
    And I press button "stllad"
    And I save the current editor
    And I set the fake date to "14.1.95"
    And I wait 1 time units to move the time forward

    Given I open an editor "Materialentnahme2" for tip command "Fbuchung" and arguments ""
    And I set fields
      | auftrag     | !Arbeitsschein1^nummer |
      | bem         | Entnahme2              |
      | gmgevorschl | 20                     |
    And I press button "stllad"
    And I save the current editor
    And I set the fake date to "15.1.95"
    And I wait 1 time units to move the time forward

    Given I open an editor "Rückmeldung1" from table "(Workorder):(WorkOrders)" with command "DONE" for record "MANREST_001"
    And I set fields
      | sofort  | ja |
      | manrest | ja |
    And I set field "gutmge" to "35" in row 1
    And I save the current editor

# Über Materialentnahme das entnommenen Material teilweise zurückbuchen
    Given I open an editor "Rückgabe1" for tip command "Fbuchung" and arguments ""
    And I set field "auftrag" to "!Arbeitsschein1^nummer"
    And I set field "gmgevorschl" to "-33"
    And I press button "stllad"
    And I set field "bem" to "M-Rückgabe"
    Then table has values
      | bumge | elex      | nlimge | limge | chentmge | entmge | rescharge^such |
      | -66   | EINKAUF-1 | 66     | 0     | 100      | 100    |                |
      | -33   | EINKAUF-2 | 33     | 0     | 50       | 50     |                |
    And I modify table
      | !row              | bumge |
      | elex=='EINKAUF-1' | -50   |
      | elex=='EINKAUF-2' | -33   |
    And I save the current editor

# Belege zu Materialentnahmme und -rückgabe prüfen
    Given I open an editor "Rückgabe1_pruef" from table "(Workorder):(CompletionConfirmations)" with command "VIEW" for search criteria "$,,such=MANREST_001;bem=M-Rückgabe;@ablageart=abgelegt;@richtung=rückwärts;@maxtreffer=1"
    Then table has values
      | mge | artikel     | rueckmge | restmge | limgev | limgen |
      | 15  | M_BAUGRUPPE | 0        | 0       | 35     | 35     |
      | -33 | EINKAUF-2   | -33      | 0       | 0      | 33     |
      | -50 | EINKAUF-1   | -50      | 0       | 0      | 50     |
    And I close the current editor

    Given I switch the current editor to editor "Rückmeldung1" with command "VIEW"
    Then table has values
      | mge | gutmge | artikel     | rueckmge | restmge | limgev | limgen |
      | 50  | 35     | M_BAUGRUPPE | 0        | 35      | 0      | 35     |
      | 20  | 0      | EINKAUF-2   | 20       | 0       | 20     | 0      |
      | 40  | 0      | EINKAUF-1   | 40       | 0       | 40     | 0      |
    And I close the current editor

    Given I open an editor "Materialentnahme2_pruef" from table "(Workorder):(CompletionConfirmations)" with command "VIEW" for search criteria "$,,such=MANREST_001;bem=Entnahme2;@ablageart=abgelegt;@richtung=rückwärts;@maxtreffer=1"
    Then the table has 3 rows
    Then table has values
      | mge | artikel     | rueckmge | restmge | limgev | limgen |
      | 50  | M_BAUGRUPPE | 0        | 0       | 0      | 0      |
      | 20  | EINKAUF-2   | 13       | 7       | 40     | 20     |
      | 40  | EINKAUF-1   | 10       | 30      | 80     | 40     |
    And I close the current editor

    Given I open an editor "Materialentnahme1_pruef" from table "(Workorder):(CompletionConfirmations)" with command "VIEW" for search criteria "$,,such=MANREST_001;bem=Entnahme1;@ablageart=abgelegt;@richtung=rückwärts;@maxtreffer=1"
    Then table has values
      | mge | artikel     | rueckmge | restmge | limgev | limgen |
      | 50  | M_BAUGRUPPE | 0        | 0       | 0      | 0      |
      | 10  | EINKAUF-2   | 0        | 10      | 50     | 40     |
      | 20  | EINKAUF-1   | 0        | 20      | 100    | 80     |
    And I close the current editor

# Lagerjournaleintrag prüfen
    Given I open the infosystem "LJ"
    And I set field "beleg" to "!Arbeitsschein1^nummer"
    And I set field "richtung" to "rückwärts"
    And I press start
    Then table has values
      | art         | amge | zmge | rueckmge | restmge | !row |
      | EINKAUF-1   | -10  |      | -10      | 0       | 1    |
      | EINKAUF-1   | -40  |      | -40      | 0       | 2    |
      | EINKAUF-2   | -13  |      | -13      | 0       | 3    |
      | EINKAUF-2   | -20  |      | -20      | 0       | 4    |
      | M_BAUGRUPPE |      | 35   | 0        | 35      | 5    |
      | EINKAUF-1   | 40   |      | 40       | 0       | 6    |
      | EINKAUF-2   | 20   |      | 20       | 0       | 7    |
      | EINKAUF-1   | 40   |      | 10       | 30      | 8    |
      | EINKAUF-2   | 20   |      | 13       | 7       | 9    |
      | EINKAUF-1   | 20   |      | 0        | 20      | 10   |
      | EINKAUF-2   | 10   |      | 0        | 10      | 11   |
    Then field "rueckorig^id" in row 1 has value equal to field "verweis^id" from editor "LJ" in row 8
    Then field "rueckorig^id" in row 2 has value equal to field "verweis^id" from editor "LJ" in row 6
    Then field "rueckorig^id" in row 3 has value equal to field "verweis^id" from editor "LJ" in row 9
    Then field "rueckorig^id" in row 4 has value equal to field "verweis^id" from editor "LJ" in row 7
    And I close the current editor

# Betriebsauftrag abschließen und Auftrag liefern
    Given I open an editor "Rückmeldung2" from table "(Workorder):(WorkOrders)" with command "DONE" for record "MANREST_001"
    And I set fields
      | sofort  | ja |
      | gut     | ja |
      | manrest | ja |
    And I save the current editor
    And I deliver the SalesOrder "auftrag" with PackingSlip "LS-MAN01"


  Scenario: 09 Rückgabe auf letzten AS mit Einheiten und Gebindepflicht, bisher Materialentnahme gebucht
    Given I set the fake date to "16.1.95"
# Bestände korrigieren
    Given I set StorageQuantity to zero for Product "GEBINDE" on StorageLocation "F1" with document "SCEN-09_1"
    Given I set StorageQuantity to zero for Product "GEBINDEPFL" on StorageLocation "F1" with document "SCEN-09_2"
    Given I set StorageQuantity to zero for Product "BG-GEBINDE" on StorageLocation "F1" with document "SCEN-09_3"

# Auftrag anlegen und Bedarfe einkaufen
    Given I create a SalesOrder "auftrag" for Customer "RADSHOP" with Product "BG-GEBINDE" and quantity "10"
    Given I open an editor "Rechnung" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
    And I set fields
      | lief   | KETTLER |
      | vom    | .       |
      | ueb    | ja      |
      | fakt   | ja      |
      | ebeleg | R-09    |
    And I append rows
      | artikel    | mge | he   |
      | GEBINDEPFL | 5   | Paar |
      | GEBINDE    | 50  | kg   |
    And I set field "verw" in row 1 to "verw" from editor "auftrag" in row 1
    And I set field "verw" in row 2 to "verw" from editor "auftrag" in row 1
    And I respond with answer "ja" to the dialog with id "4841"
    And I save the current editor

# Fertigungsvorschlag anlegen und freigeben
    Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
    And I append rows
      | artikel    | netmge | mfreig |
      | BG-GEBINDE | 10     | ja     |
    And I set field "verw" in row !lastRow to "verw" from editor "auftrag" in row 1
    And I press button "absteig" to open a subeditor for "AFL" in row !lastRow
    And I press button "setmanbu"
    And I save the current editor
    And I switch the current editor to editor "fvor"
    And I set field "bisuch" to "GEBINDE_" in row 1
    And I press button "freig" to open a subeditor for "BA_freigeben"
    And I close the current editor
    And I switch the current editor to editor "fvor"
    And I save the current editor

# Materialentnahme über gesamte Gutmenge
    Given I open an editor "Materialentnahme1" for tip command "Fbuchung" and arguments ""
    And I set field "auftrag" to "$,,such=GEBINDE_001;@richtung=rückwärts;@maxtreffer=1"
    And I set field "bem" to "Entnahme"
    And I press button "stllad"
    And I modify table
      | !row | bumge | bueinh |
      | 1    | 10    | Stück  |
      | 2    | 5     | Paar   |
    And I save the current editor

# Materialentnahme über Mengenvorschlag einen Teil des entnommenen Materials zurückbuchen
# in Stück
    Given I open an editor "Rückgabe1" for tip command "Fbuchung" and arguments ""
    And I set fields
      | auftrag     | $,,such=GEBINDE_001;@richtung=rückwärts;@maxtreffer=1 |
      | gmgevorschl | -1                                                    |
      | bem         | Rückgabe1                                             |
    And I press button "stllad"
    Then table has values
      | bumge | bueinh | elex       | nlimge | chentmge | entmge |
      | -1    | Stück  | GEBINDE    | 1      | 10       | 10     |
      | -1    | Stück  | GEBINDEPFL | 1      | 10       | 10     |
    And I save the current editor

    Given I open the infosystem "BESTAND"
    And I set fields
      | artikel    | GEBINDE |
      | verdichten | nein    |
      | nullmge    | nein    |
      | details    | nein    |
    And I press start
    And I press button "taufzu" in row 1
    Then the table has 2 rows
    Then table has values
      | lemge | gebmge | geinheit |
      | 1     |        |          |
      |       | 1      | Stück    |
    And I set fields
      | artikel    | GEBINDEPFL |
      | verdichten | nein       |
      | nullmge    | nein       |
      | details    | nein       |
    And I press start
    And I press button "taufzu" in row 1
    Then the table has 2 rows
    Then table has values
      | lemge | gebmge | geinheit |
      | 1     |        |          |
      |       | 1      | Stück    |
    And I close the current editor

# in Lagerheinheit
    Given I open an editor "Rückgabe2" for tip command "Fbuchung" and arguments ""
    And I set fields
      | auftrag     | $,,such=GEBINDE_001;@richtung=rückwärts;@maxtreffer=1 |
      | gmgevorschl | -1                                                    |
      | bem         | Rückgabe2                                             |
    And I press button "stllad"
    And I modify table
      | !row | bueinh |
      | 1    | Stück  |
      | 2    | Paar   |
    Then table has values
      | bumge | bueinh | elex       | nlimge | chentmge | entmge |
      | -1    | Stück  | GEBINDE    | 2      | 9        | 9      |
      | -1    | Paar   | GEBINDEPFL | 3      | 9        | 9      |
    And I save the current editor

    Given I open the infosystem "BESTAND"
    And I set fields
      | artikel    | GEBINDE |
      | verdichten | nein    |
      | nullmge    | nein    |
      | details    | nein    |
    And I press start
    And I press button "taufzu" in row 1
    Then the table has 3 rows
    Then table has values
      | lemge | gebmge | geinheit |
      | 2     |        |          |
      |       | 1      | Stück    |
      |       | 1      | Stück    |
    And I set fields
      | artikel    | GEBINDEPFL |
      | verdichten | nein       |
      | nullmge    | nein       |
      | details    | nein       |
    And I press start
    And I press button "taufzu" in row 1
    Then the table has 3 rows
    Then table has values
      | lemge | leinheit | gebmge | geinheit |
      | 3     | Stück    |        |          |
      |       |          | 1      | Stück    |
      |       |          | 1      | Paar     |
    And I close the current editor

# in Handelseinheit
    Given I open an editor "Rückgabe3" for tip command "Fbuchung" and arguments ""
    And I set fields
      | auftrag     | $,,such=GEBINDE_001;@richtung=rückwärts;@maxtreffer=1 |
      | gmgevorschl | -1                                                    |
      | bem         | Rückgabe3                                             |
    And I press button "stllad"
    And I modify table
      | !row | bueinh |
      | 1    | kg     |
      | 2    | Paar   |
    Then table has values
      | bumge | bueinh | elex       | nlimge | chentmge | entmge |
      | -1    | kg     | GEBINDE    | 2.2    | 8        | 8      |
      | -1    | Paar   | GEBINDEPFL | 5      | 7        | 7      |
    And I save the current editor

    Given I open the infosystem "BESTAND"
    And I set fields
      | artikel    | GEBINDE |
      | verdichten | nein    |
      | nullmge    | nein    |
      | details    | nein    |
    And I press start
    And I press button "taufzu" in row 1
    Then the table has 4 rows
    Then table has values
      | lemge | leinheit | gebmge | geinheit |
      | 2.2   | Stück    |        |          |
      |       |          | 1      | Stück    |
      |       |          | 1      | Stück    |
      |       |          | 0.2    | Stück    |
    And I set fields
      | artikel    | GEBINDEPFL |
      | verdichten | nein       |
      | nullmge    | nein       |
      | details    | nein       |
    And I press start
    And I press button "taufzu" in row 1
    Then the table has 4 rows
    Then table has values
      | lemge | leinheit | gebmge | geinheit |
      | 5     | Stück    |        |          |
      |       |          | 1      | Stück    |
      |       |          | 1      | Paar     |
      |       |          | 1      | Paar     |
    And I close the current editor

# entmge und nlimge in fbuch prüfen
    Given I open an editor "RückgabeTest" for tip command "Fbuchung" and arguments ""
    And I set fields
      | auftrag     | $,,such=GEBINDE_001;@richtung=rückwärts;@maxtreffer=1 |
      | gmgevorschl | -1                                                    |
      | bem         | RückgabeTest                                          |
    And I press button "stllad"
    Then table has values
      | bumge | bueinh | elex       | nlimge | chentmge | entmge |
      | -1    | Stück  | GEBINDE    | 3.2    | 7.8      | 7.8    |
      | -1    | Stück  | GEBINDEPFL | 6      | 5        | 5      |
    And I close the current editor

# Belege zu Materialentnahmme und -rückgabe prüfen
    Given I open an editor "Materialentnahme1_pruef" from table "(Workorder):(CompletionConfirmations)" with command "VIEW" for search criteria "$,,such=GEBINDE_001;bem=Entnahme;@ablageart=abgelegt;@richtung=rückwärts;@maxtreffer=1"
    Then the table has 3 rows
    Then table has values
      | mge | artikel    | rueckmge | restmge | limgev | limgen |
      | 10  | BG-GEBINDE | 0        | 0       | 0      | 0      |
      | 10  | GEBINDEPFL | 5        | 5       | 10     | 0      |
      | 10  | GEBINDE    | 2.2      | 7.8     | 10     | 0      |
    And I close the current editor

    Given I open an editor "Rückgabe1_pruef" from table "(Workorder):(CompletionConfirmations)" with command "VIEW" for search criteria "$,,such=GEBINDE_001;bem=Rückgabe1;@ablageart=abgelegt;@richtung=rückwärts;@maxtreffer=1"
    Then the table has 3 rows
    Then table has values
      | mge | artikel    | rueckmge | restmge | limgev | limgen |
      | 10  | BG-GEBINDE | 0        | 0       | 0      | 0      |
      | -1  | GEBINDEPFL | -1       | 0       | 0      | 1      |
      | -1  | GEBINDE    | -1       | 0       | 0      | 1      |
    And I close the current editor

    Given I open an editor "Rückgabe2_pruef" from table "(Workorder):(CompletionConfirmations)" with command "VIEW" for search criteria "$,,such=GEBINDE_001;bem=Rückgabe2;@ablageart=abgelegt;@richtung=rückwärts;@maxtreffer=1"
    Then the table has 3 rows
    Then table has values
      | mge | artikel    | rueckmge | restmge | limgev | limgen |
      | 10  | BG-GEBINDE | 0        | 0       | 0      | 0      |
      | -2  | GEBINDEPFL | -2       | 0       | 1      | 3      |
      | -1  | GEBINDE    | -1       | 0       | 1      | 2      |
    And I close the current editor

    Given I open an editor "Rückgabe3_pruef" from table "(Workorder):(CompletionConfirmations)" with command "VIEW" for search criteria "$,,such=GEBINDE_001;bem=Rückgabe3;@ablageart=abgelegt;@richtung=rückwärts;@maxtreffer=1"
    Then the table has 3 rows
    Then table has values
      | mge  | artikel    | rueckmge | restmge | limgev | limgen |
      | 10   | BG-GEBINDE | 0        | 0       | 0      | 0      |
      | -2   | GEBINDEPFL | -2       | 0       | 3      | 5      |
      | -0.2 | GEBINDE    | -0.2     | 0       | 2      | 2.2    |
    And I close the current editor

# Betriebsauftrag abschließen
    Given I open an editor "Materialentnahme1" for tip command "Fbuchung" and arguments ""
    And I set field "auftrag" to "$,,such=GEBINDE_001;@richtung=rückwärts;@maxtreffer=1"
    And I press button "stllad"
    And I modify table
      | !row | bueinh | bumge |
      | 2    | Paar   | 2     |
    And I save the current editor
    Given I open an editor "Materialentnahme2" for tip command "Fbuchung" and arguments ""
    And I set field "auftrag" to "$,,such=GEBINDE_001;@richtung=rückwärts;@maxtreffer=1"
    And I press button "stllad"
    And I modify table
      | !row | bueinh | bumge |
      | 2    | Stück  | 1     |
    And I save the current editor
    Given I open an editor "Rückmeldung1" from table "(Workorder):(WorkOrders)" with command "DONE" for record "GEBINDE_001"
    And I set fields
      | sofort | ja |
      | gut    | ja |
    And I save the current editor
    And I deliver the SalesOrder "auftrag" with PackingSlip "LS-MAN01"

    Given I open the infosystem "BESTAND"
    And I set fields
      | artikel    | GEBINDE |
      | verdichten | nein    |
      | nullmge    | nein    |
      | details    | nein    |
    And I press start
    Then the table has 0 rows
    And I set fields
      | artikel    | GEBINDEPFL |
      | verdichten | nein       |
      | nullmge    | nein       |
      | details    | nein       |
    And I press start
    Then the table has 0 rows
    And I close the current editor


  Scenario: 10 Rückgabe auf letzten AS in gefüllte und leere Behälter, bisher Materialentnahme ohne Behälterangabe gebucht, EntnahmeMZ mit Behälter vor Freigabe FV angelegt
    Given I set the fake date to "17.1.95"
# Behälter anlegen
    Given I create a Container "B_MATERIAL1" for packaging material "BEHAELTER"
    Given I create a Container "B_MATERIAL2" for packaging material "BEHAELTER"
    Given I create a Container "B_MATERIAL3" for packaging material "BEHAELTER"
    Given I create a Container "B_LEER" for packaging material "BEHAELTER"

# Auftrag anlagen und Bedarfe einkaufen
    Given I create a SalesOrder "auftrag" for Customer "RADSHOP" with Product "M_BAUGRUPPE" and quantity "10"
    Given I open an editor "Rechnung" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
    And I set fields
      | lief   | KETTLER |
      | vom    | .       |
      | ueb    | ja      |
      | fakt   | ja      |
      | ebeleg | R-10    |
    And I append rows
      | artikel    | mge |
      | EINKAUF-1  | 10  |
      | EINKAUF-1  | 10  |
      | EINKAUF-2  | 5   |
      | EINKAUF-2  | 5   |
      | BEHAELTER  | 4   |
      | EU-PALETTE | 1   |
    And I set field "verw" in row 1 to "verw" from editor "auftrag" in row 1
    And I set field "verw" in row 2 to "verw" from editor "auftrag" in row 1
    And I set field "verw" in row 3 to "verw" from editor "auftrag" in row 1
    And I set field "verw" in row 4 to "verw" from editor "auftrag" in row 1
    And I respond with answer "nein" to the dialog with id "Externe Behälternummer ist bereits vergeben."
    And I set field "exbehnum" to "nummer" from editor "B_MATERIAL1" in row 1
    And I respond with answer "nein" to the dialog with id "Externe Behälternummer ist bereits vergeben."
    And I set field "exbehnum" to "nummer" from editor "B_MATERIAL2" in row 2
    And I respond with answer "nein" to the dialog with id "Externe Behälternummer ist bereits vergeben."
    And I set field "exbehnum" to "nummer" from editor "B_MATERIAL3" in row 3
    And I respond with answer "ja" to the dialog with id "4841"
    And I save the current editor

# Fertigungsvorschlag anlegen und freigeben
    Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
    And I append rows
      | artikel     | netmge | mfreig |
      | M_BAUGRUPPE | 10     | ja     |
    And I set field "verw" in row !lastRow to "verw" from editor "auftrag" in row !lastRow
    And I press button "mzabsm" to open a subeditor for "EntnahmeMZ" in row !lastRow
    And I modify table
      | !row | zuomge | behaelter                                             |
      | +1   | 10     | $,,such=B_MATERIAL1;@richtung=rückwärts;@maxtreffer=1 |
      | +2   | 10     | $,,such=B_MATERIAL2;@richtung=rückwärts;@maxtreffer=1 |
    And I press button "abv" to open a subeditor for "mz2"
    And I close the current editor
    And I switch the current editor to editor "EntnahmeMZ"
    And I modify table
      | !row | zuomge | behaelter                                             |
      | +1   | 5      | $,,such=B_MATERIAL3;@richtung=rückwärts;@maxtreffer=1 |
      | +2   | 5      |                                                       |
    And I save the current editor
    And I switch the current editor to editor "fvor"
    And I set field "bisuch" to "BEHAELTER_" in row !lastRow
    And I press button "freig" to open a subeditor for "BA_freigeben"
    And I close the current editor
    And I switch the current editor to editor "fvor"
    And I save the current editor

    Given I open an editor "Arbeitsschein1" from table "(Workorder):(WorkOrders)" with command "VIEW" for record "BEHAELTER_001"
    And I close the current editor

# Materialentnahme Teilmenge
    Given I open an editor "Materialentnahme1" for tip command "Fbuchung" and arguments ""
    And I set fields
      | auftrag     | $,,such=BEHAELTER_001;@richtung=rückwärts;@maxtreffer=1 |
      | gmgevorschl | 5                                                       |
      | bem         | Entnahme1                                               |
    And I press button "stllad"
    And I save the current editor

# Behälter prüfen
    Then Container from editor "B_MATERIAL1" is empty
    Then Container from editor "B_MATERIAL3" is empty

# Teil-Rückgabe in gefüllten und leeren Behälter (über Zeile)
    Given I open an editor "Rückgabe1" for tip command "Fbuchung" and arguments ""
    And I set fields
      | auftrag     | $,,such=BEHAELTER_001;@richtung=rückwärts;@maxtreffer=1 |
      | gmgevorschl | -2                                                      |
      | bem         | Rückgabe                                                |
    And I press button "stllad"
    And I modify table
      | !row | behaelter    |
      | 1    | !B_MATERIAL2 |
      | 2    | !B_LEER      |
    Then table has values
      | bumge | bueinh | elex      | nlimge | chentmge | entmge | behaelter^such |
      | -4    | Stück  | EINKAUF-1 | 14     | 10       | 10     | B_MATERIAL2    |
      | -2    | Stück  | EINKAUF-2 | 7      | 5        | 5      | B_LEER         |
    And I save the current editor

# Behälter prüfen
    Then Container from editor "B_MATERIAL1" is empty

    And I switch the current editor to editor "B_MATERIAL2" with command "VIEW"
    Then the table has 1 rows
    Then table has values
      | artikel   | mge |
      | EINKAUF-1 | 14  |
    And I close the current editor
    And I switch the current editor to editor "B_LEER" with command "VIEW"
    Then the table has 1 rows
    Then table has values
      | artikel   | mge |
      | EINKAUF-2 | 2   |
    And I close the current editor

# LJ prüfen
    Given I open the infosystem "LJ"
    And I set field "beleg" to "nummer" from editor "Arbeitsschein1"
    And I set field "richtung" to "rückwärts"
    And I press start
    Then table has values
      | art       | amge | zmge | rueckmge | restmge | !row |
      | EINKAUF-1 | -4   |      | -4       | 0       | 1    |
      | EINKAUF-2 | -2   |      | -2       | 0       | 2    |
      | EINKAUF-1 | 10   |      | 4        | 6       | 3    |
      | EINKAUF-2 | 5    |      | 2        | 3       | 4    |
    Then field "behaelter^id" in row 1 has value equal to field "id" from editor "B_MATERIAL2" in row 0
    Then field "behaelter^id" in row 2 has value equal to field "id" from editor "B_LEER" in row 0
    Then field "behaelter^id" in row 3 has value equal to field "id" from editor "B_MATERIAL1" in row 0
    Then field "behaelter^id" in row 4 has value equal to field "id" from editor "B_MATERIAL3" in row 0
    And I close the current editor

# Materialentnahme und Rückmeldung auf ersten AG
    Given I open an editor "Materialentnahme2" for tip command "Fbuchung" and arguments ""
    And I set fields
      | auftrag | $,,such=BEHAELTER_001;@richtung=rückwärts;@maxtreffer=1 |
      | bem     | Entnahme2                                               |
    And I press button "stllad"
    And I modify table
      | !row | bumge       | behaelter                                             |
      | 1    | !dontChange | $,,such=B_MATERIAL2;@richtung=rückwärts;@maxtreffer=1 |
      | 2    | 2           | $,,such=B_LEER;@richtung=rückwärts;@maxtreffer=1      |
    And I save the current editor

    Given I open an editor "Rückmeldung1" from table "(Workorder):(WorkOrders)" with command "DONE" for record "BEHAELTER_001"
    And I set fields
      | gut     | ja |
      | sofort  | ja |
      | manrest | ja |
    And I save the current editor

# Behälter prüfen
    Then Container from editor "B_MATERIAL1" is empty
    Then Container from editor "B_MATERIAL2" is empty
    Then Container from editor "B_MATERIAL3" is empty
    Then Container from editor "B_LEER" is empty

# Lieferschein zu Auftrag
    And I deliver the SalesOrder "auftrag" with PackingSlip "LS-10"


  Scenario: 11 Rückgabe auf letzten AS mit Einheiten und Chargen in Behälter, bisher Materialentnahme gebucht, EntnahmeMZ für Chargen und Behälter vor Freigabe FV angelegt
    Given I set the fake date to "18.1.95"
# Bestand auf 0 korrigieren
    Given I set StorageQuantity to zero for Product "GEBINDE" on StorageLocation "F1" with document "SCEN-11_1"
    Given I set StorageQuantity to zero for Product "GEBINDEPFL" on StorageLocation "F1" with document "SCEN-11_2"

# Behälter und Chargen anlegen
    Given I create a Container "B_MATERIAL1" for packaging material "BEHAELTER"
    Given I create a Lot "CH_9876" for Product "GEBINDE"
    Given I create a Lot "CH_5555" for Product "GEBINDEPFL"

# Auftrag anlagen und Bedarfe einkaufen
    Given I create a SalesOrder "auftrag" for Customer "RADSHOP" with Product "BG-GEBINDE" and quantity "10"
    Given I open an editor "Rechnung" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
    And I set fields
      | lief   | KETTLER |
      | vom    | .       |
      | ueb    | ja      |
      | fakt   | ja      |
      | ebeleg | R-10    |
    And I append rows
      | artikel    | mge | charge      |
      | GEBINDE    | 50  | !CH_9876^id |
      | GEBINDEPFL | 5   | !CH_5555^id |
      | BEHAELTER  | 1   |             |
    And I set field "verw" in row 1 to "verw" from editor "auftrag" in row 1
    And I set field "verw" in row 2 to "verw" from editor "auftrag" in row 1
    And I respond with answer "nein" to the dialog with id "Externe Behälternummer ist bereits vergeben."
    And I set field "exbehnum" to "nummer" from editor "B_MATERIAL1" in row 1
    And I respond with answer "nein" to the dialog with id "Externe Behälternummer ist bereits vergeben."
    And I set field "exbehnum" to "nummer" from editor "B_MATERIAL1" in row 2
    And I respond with answer "ja" to the dialog with id "4841"
    And I save the current editor

# Fertigungsvorschlag anlegen und freigeben
    Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
    And I append rows
      | artikel    | netmge | mfreig |
      | BG-GEBINDE | 10     | ja     |
    And I set field "verw" in row !lastRow to "verw" from editor "auftrag" in row !lastRow
    And I press button "mzabsm" to open a subeditor for "EntnahmeMZ" in row !lastRow
    And I modify table
      | !row | zuomge | einh | charge      | behaelter       |
      | +1   | 50     | kg   | !CH_9876^id | !B_MATERIAL1^id |
    And I press button "abv" to open a subeditor for "NächsterArtikel"
    And I close the current editor
    And I switch the current editor to editor "EntnahmeMZ"
    And I modify table
      | !row | zuomge | einh | charge      | behaelter       |
      | +1   | 5      | Paar | !CH_5555^id | !B_MATERIAL1^id |
    And I save the current editor
    And I switch the current editor to editor "fvor"
    And I press button "absteig" to open a subeditor for "AFL" in row 1
    And I press button "setmanbu"
    And I save the current editor
    And I switch the current editor to editor "fvor"
    And I set field "bisuch" to "GEBBEH_" in row !lastRow
    And I press button "freig" to open a subeditor for "BA_freigeben"
    And I close the current editor
    And I switch the current editor to editor "fvor"
    And I save the current editor

    Given I open an editor "Betriebsauftrag" from table "(Workorder):(WorkOrders)" with command "VIEW" for record "GEBBEH_000"
    And I close the current editor

    Given I open an editor "Arbeitsschein1" from table "(Workorder):(WorkOrders)" with command "VIEW" for record "GEBBEH_001"
    And I close the current editor

# Materialentnahme Teilmenge
    Given I open an editor "Materialentnahme1" for tip command "Fbuchung" and arguments ""
    And I set fields
      | auftrag     | !Arbeitsschein1^nummer |
      | gmgevorschl | 8                      |
      | bem         | Entnahme1              |
    And I press button "stllad"
    And I save the current editor

# Behälter prüfen
    And I switch the current editor to editor "B_MATERIAL1" with command "VIEW"
    Then the table has 2 rows
    Then table has values
      | artikel    | mge | charge^such | gebeinh |
      | GEBINDE    | 2   | CH_9876     | Stück   |
      | GEBINDEPFL | 1   | CH_5555     | Paar    |
    And I close the current editor

# Teil-Rückgabe in gefüllten und leeren Behälter (über Zeile)
    Given I open an editor "Rückgabe1" for tip command "Fbuchung" and arguments ""
    And I set fields
      | auftrag     | !Arbeitsschein1^nummer |
      | gmgevorschl | -2                     |
      | bem         | Rückgabe               |
    And I press button "stllad"
    And I modify table
      | !row | bumge       | bueinh      | rescharge   | behaelter       |
      | 1    | !dontChange | !dontChange | !CH_9876^id | !B_MATERIAL1^id |
      | 2    | -1          | Paar        | !CH_5555^id | !B_MATERIAL1^id |
    Then table has values
      | bumge | bueinh | elex       | nlimge | chentmge | entmge |
      | -2    | Stück  | GEBINDE    | 4      | 8        | 8      |
      | -1    | Paar   | GEBINDEPFL | 4      | 8        | 8      |
    And I save the current editor

# Behälter prüfen
    And I switch the current editor to editor "B_MATERIAL1" with command "VIEW"
    Then the table has 2 rows
    Then table has values
      | artikel    | mge | charge^such | gebeinh |
      | GEBINDE    | 4   | CH_9876     | Stück   |
      | GEBINDEPFL | 2   | CH_5555     | Paar    |
    And I close the current editor

# LJ prüfen
    Given I open the infosystem "LJ"
    And I set field "beleg" to "nummer" from editor "Arbeitsschein1"
    And I set field "richtung" to "rückwärts"
    And I press start
    Then table has values
      | art        | amge | zmge | rueckmge | restmge | lei   | mei   | vcharge^such | behaelter^id    | !row |
      | GEBINDE    | -2   |      | -2       | 0       | Stück | Stück | CH_9876      | !B_MATERIAL1^id | 1    |
      | GEBINDEPFL | -1   |      | -2       | 0       | Stück | Paar  | CH_5555      | !B_MATERIAL1^id | 2    |
      | GEBINDE    | 40   |      | 2        | 6       | Stück | kg    | CH_9876      | !B_MATERIAL1^id | 3    |
      | GEBINDEPFL | 4    |      | 2        | 6       | Stück | Paar  | CH_5555      | !B_MATERIAL1^id | 4    |
    And I close the current editor

# MZ wieder anlegen, Materialentnahme und Rückmeldung auf ersten AG
    Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "UPDATE" for record ""
    And I set fields
      | banummer | !Betriebsauftrag^nummer |
    And I press button "ladetab"
    And I press button "mzabsm" to open a subeditor for "EntnahmeMZ" in row 1
    And I press button "abv" to open a subeditor for "NächsterArtikel"
    And I close the current editor
    And I switch the current editor to editor "EntnahmeMZ"
    And I modify table
      | !row | zuomge | einh | charge      | behaelter       |
      | 1    | 2      | Paar | !CH_5555^id | !B_MATERIAL1^id |
    And I save the current editor
    And I switch the current editor to editor "fvor"
    And I save the current editor

    Given I open an editor "Materialentnahme2" for tip command "Fbuchung" and arguments ""
    And I set fields
      | auftrag | !Arbeitsschein1^nummer |
      | bem     | Entnahme2              |
    And I press button "stllad"
    And I modify table
      | bumge       | bueinh      | rescharge   | behaelter       | !row                  |
      | !dontChange | !dontChange | !CH_9876^id | !B_MATERIAL1^id | artikel=='GEBINDE'    |
      | 2           | Paar        | !CH_5555^id | !B_MATERIAL1^id | artikel=='GEBINDEPFL' |
    And I save the current editor

# Behälter und Bestand prüfen
    Then Container from editor "B_MATERIAL1" is empty
    Given I open the infosystem "BESTAND"
    And I set fields
      | artikel    | GEBINDE |
      | klplatz    | F1      |
      | verdichten | nein    |
      | nullmge    | nein    |
      | details    | nein    |
    And I press start
    Then the table has 0 rows
    And I set fields
      | artikel    | GEBINDEPFL |
      | klplatz    | F1         |
      | verdichten | nein       |
      | nullmge    | nein       |
      | details    | nein       |
    And I press start
    Then the table has 0 rows
    And I close the current editor

# Rückmeldung und Lieferschein zu Auftrag
    Given I open an editor "Rückmeldung1" from table "(Workorder):(WorkOrders)" with command "DONE" for record "GEBBEH_001"
    And I set fields
      | gut    | ja |
      | sofort | ja |
    And I save the current editor
    And I deliver the SalesOrder "auftrag" with PackingSlip "LS-11"


# Scenario: 12 Materialrückgabe über MZ in fbuch mit Gebinde, Chargen und Behälter, manbu=ja, Gutmenge auf AS
# zu BC2_RUECKGABE_Fertigung_Materialentnahmen_MZ.feature



  Scenario: 13 Rückgabe von zusätzlich entnommenem Material auf letzten AS, bisher zusätzliches Material über Rückmeldung und Fbuchung auf letzten AS gebucht
    Given I set the fake date to "19.1.95"
# Auftrag anlegen und Bedarfe einkaufen
    Given I create a SalesOrder "auftrag" for Customer "RADSHOP" with Product "BAUGRUPPE" and quantity "10"
    Given I open an editor "Rechnung" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
    And I set fields
      | lief   | KETTLER |
      | vom    | .       |
      | ueb    | ja      |
      | fakt   | ja      |
      | ebeleg | R-13    |
    And I append rows
      | artikel   | mge |
      | EINKAUF-1 | 10  |
      | EINKAUF-2 | 5   |
      | EINKAUF-3 | 5   |
    And I set field "verw" in row 1 to "verw" from editor "auftrag" in row 1
    And I set field "verw" in row 2 to "verw" from editor "auftrag" in row 1
    And I respond with answer "ja" to the dialog with id "4841"
    And I save the current editor

# Fertigungsvorschlag anlagen und freigeben
    Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
    And I append rows
      | artikel   | netmge | bisuch | mfreig |
      | BAUGRUPPE | 10     | RÜCKM_ | ja     |
    And I set field "verw" in row !lastRow to "verw" from editor "auftrag" in row !lastRow
    And I press button "freig" to open a subeditor for "BA_freigeben"
    And I close the current editor
    And I switch the current editor to editor "fvor"
    And I save the current editor

# Materialentnahme Teilmenge
    Given I open an editor "Rückmeldung1" from table "(Workorder):(WorkOrders)" with command "DONE" for record "RÜCKM_001"
    And I set fields
      | sofort | ja           |
      | bem    | Rückmeldung1 |
    And I modify table
      | artikel     | mge         | gutmge      | !row                 |
      | !dontChange | !dontChange | 5           | artikel=='BAUGRUPPE' |
      | EINKAUF-3   | 5           | !dontChange | +2                   |
    And I save the current editor

# Materialrückgabe über Rückmeldung
    Given I open an editor "Rückgabe1" from table "(Workorder):(WorkOrders)" with command "RETURN" for record "RÜCKM_001"
    And I set fields
      | sofort | ja        |
      | bem    | Rückgabe1 |
    Then the table has 2 rows
    And I modify table
      | artikel     | mge         | gutmge      | !row                 |
      | !dontChange | !dontChange | -1          | artikel=='BAUGRUPPE' |
      | EINKAUF-3   | -3          | !dontChange | artikel=='EINKAUF-3' |
    And I save the current editor

# Belege prüfen
    And I switch the current editor to editor "Rückmeldung1" with command "VIEW"
    Then table has values
      | !row | rueckmge | restmge | limgev | limgen |
      | 2    | 3        | 2       | 0      | 5      |
    And I close the current editor

    And I switch the current editor to editor "Rückgabe1" with command "VIEW"
    Then table has values
      | !row | rueckmge | restmge | limgev | limgen |
      | 2    | -3       | 0       | 5      | 2      |
    And I close the current editor

# LJ prüfen
    Given I open the infosystem "LJ"
    And I set field "beleg" to "nummer" from editor "Rückmeldung1"
    And I set field "richtung" to "rückwärts"
    And I press start
    Then table has values
      | art       | amge | zmge | rueckmge | restmge | !row |
      | BAUGRUPPE |      | -1   | -1       | 0       | 1    |
      | EINKAUF-1 | -2   |      | -2       | 0       | 2    |
      | EINKAUF-2 | -1   |      | -1       | 0       | 3    |
      | EINKAUF-3 | -3   |      | -3       | 0       | 4    |
      | BAUGRUPPE |      | 5    | 1        | 4       | 5    |
      | EINKAUF-1 | 10   |      | 2        | 8       | 6    |
      | EINKAUF-2 | 5    |      | 1        | 4       | 7    |
      | EINKAUF-3 | 5    |      | 3        | 2       | 8    |
    And I close the current editor

# Betriebsauftrag abschließen
    Given I open an editor "Rückmeldung2" from table "(Workorder):(WorkOrders)" with command "DONE" for record "RÜCKM_001"
    And I set fields
      | sofort | ja           |
      | gut    | ja           |
      | bem    | Rückmeldung2 |
    And I modify table
      | artikel   | mge | gutmge      | !row |
      | EINKAUF-3 | 3   | !dontChange | +2   |
    And I save the current editor
    And I deliver the SalesOrder "auftrag" with PackingSlip "LS-R13"


  Scenario: 14 Rückgabe von zusätzlich entnommenem Material mit Einheiten und Gebindepflicht auf letzten AS, bisher zusätzliches Material über Rückmeldung und Fbuchung auf letzten AS gebucht
    Given I set the fake date to "20.1.95"
# Auftrag anlegen und Material einkaufen
    Given I create a SalesOrder "auftrag" for Customer "RADSHOP" with Product "BAUGRUPPE" and quantity "10"
    Given I open an editor "Rechnung" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
    And I set fields
      | lief   | KETTLER |
      | vom    | .       |
      | ueb    | ja      |
      | fakt   | ja      |
      | ebeleg | R-13    |
    And I append rows
      | artikel    | mge |
      | EINKAUF-1  | 10  |
      | EINKAUF-2  | 5   |
      | GEBINDE    | 10  |
      | GEBINDEPFL | 5   |
    And I set field "verw" in row 1 to "verw" from editor "auftrag" in row 1
    And I set field "verw" in row 2 to "verw" from editor "auftrag" in row 1
    And I respond with answer "ja" to the dialog with id "4841"
    And I save the current editor

# Fertigungsvorschlag anlagen und freigeben
    Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
    And I append rows
      | artikel   | netmge | bisuch | mfreig |
      | BAUGRUPPE | 10     | RÜCKG_ | ja     |
    And I set field "verw" in row !lastRow to "verw" from editor "auftrag" in row !lastRow
    And I press button "freig" to open a subeditor for "BA_freigeben"
    And I close the current editor
    And I switch the current editor to editor "fvor"
    And I save the current editor

# Materialentnahme Teilmenge
    Given I open an editor "Rückmeldung1" from table "(Workorder):(WorkOrders)" with command "DONE" for record "RÜCKG_001"
    And I set fields
      | sofort | ja           |
      | bem    | Rückmeldung1 |
    And I modify table
      | artikel     | bueinh      | bumge       | gutmge      | !row |
      | !dontChange | !dontChange | !dontChange | 5           | 1    |
      | GEBINDEPFL  | Paar        | 5           | !dontChange | +2   |
      | GEBINDE     | kg          | 10          | !dontChange | +3   |
    And I save the current editor

# Bewertung
    Given I open an editor "Bewertung1" from table "(Valuation):(Valuation)" with command "VIEW" for search criteria "$,,artikel=GEBINDE;detursache=Rückmeldung Fertigung;@richtung=rückwärts;@maxtreffer=1"
    Then field "bewvorgang^vorgang^id" has value equal to field "id" from editor "Rückmeldung1"
    And I close the current editor

# Materialrückgabe über Rückmeldung
    Given I open an editor "Rückgabe1" from table "(Workorder):(WorkOrders)" with command "RETURN" for record "RÜCKG_001"
    And I set fields
      | sofort | ja        |
      | bem    | Rückgabe1 |
    Then the table has 3 rows
    And I modify table
      | artikel     | bueinh      | bumge       | gutmge      | !row |
      | !dontChange | !dontChange | !dontChange | -1          | 1    |
      | GEBINDEPFL  | Stück       | -7          | !dontChange | 2    |
      | GEBINDE     | Stück       | -1          | !dontChange | 3    |
    And I save the current editor

# Belege prüfen, Bewertung hat Nachfolger
    And I switch the current editor to editor "Rückmeldung1" with command "VIEW"
    Then table has values
      | !row | bumge | bueinh | mge | rueckmge | restmge | limgev | limgen |
      | 2    | 5     | Paar   | 10  | 7        | 3       | 0      | 10     |
      | 3    | 10    | kg     | 2   | 1        | 1       | 0      | 2      |
    And I close the current editor

    And I switch the current editor to editor "Rückgabe1" with command "VIEW"
    Then table has values
      | !row | bumge | bueinh | mge | rueckmge | restmge | limgev | limgen |
      | 2    | -7    | Stück  | -7  | -7       | 0       | 10     | 3      |
      | 3    | -1    | Stück  | -1  | -1       | 0       | 2      | 1      |
    And I close the current editor

    And I switch the current editor to editor "Bewertung1" with command "VIEW"
    Then field "nachfolger" is not empty
    And I close the current editor

    Given I open an editor "Bewertung_nachf" via ID from editor "Bewertung1" from field "nachfolger" in row 0 for table "(Valuation):(Valuation)" with command "VIEW"
    Then field "detursache" has value "Rückbau Fertigung"
    Then field "bewvorgang^vorgang^id" has value equal to field "id" from editor "Rückmeldung1"
    And I close the current editor

# LJ prüfen
    Given I open the infosystem "LJ"
    And I set field "beleg" to "nummer" from editor "Rückmeldung1"
    And I set field "richtung" to "rückwärts"
    And I press start
    Then table has values
      | art        | amge | zmge | mei   | rueckmge | restmge | !row |
      | BAUGRUPPE  |      | -1   | Stück | -1       | 0       | 1    |
      | EINKAUF-1  | -2   |      | Stück | -2       | 0       | 2    |
      | EINKAUF-2  | -1   |      | Stück | -1       | 0       | 3    |
      | GEBINDEPFL | -7   |      | Stück | -7       | 0       | 4    |
      | GEBINDE    | -1   |      | Stück | -1       | 0       | 5    |
      | BAUGRUPPE  |      | 5    | Stück | 1        | 4       | 6    |
      | EINKAUF-1  | 10   |      | Stück | 2        | 8       | 7    |
      | EINKAUF-2  | 5    |      | Stück | 1        | 4       | 8    |
      | GEBINDEPFL | 5    |      | Paar  | 7        | 3       | 9    |
      | GEBINDE    | 10   |      | kg    | 1        | 1       | 10   |
    Then field "rueckorig^id" in row 4 has value equal to field "verweis^id" from editor "LJ" in row 9
    Then field "rueckorig^id" in row 5 has value equal to field "verweis^id" from editor "LJ" in row 10
    And I close the current editor

# Betriebsauftrag abschließen
    Given I open an editor "Rückmeldung2" from table "(Workorder):(WorkOrders)" with command "DONE" for record "RÜCKG_001"
    And I set fields
      | sofort | ja           |
      | gut    | ja           |
      | bem    | Rückmeldung2 |
    And I modify table
      | artikel   | mge | gutmge      | !row |
      | EINKAUF-3 | 3   | !dontChange | +2   |
    And I save the current editor
    And I deliver the SalesOrder "auftrag" with PackingSlip "LS-R13"


  Scenario: 15 Teil-Rückgabe auf verschiedene Lagerplätze auf letzten AS, bisher Materialentnahme von verschiedenen Plätzen
    Given I set the fake date to "21.1.95"
# Bestand auf 0 korrigieren
    Given I set StorageQuantity to zero for Product "B_EINKAUF-1" on StorageLocation "F1" with document "KORR-X02"
    Given I set StorageQuantity to zero for Product "B_EINKAUF-1" on StorageLocation "F2" with document "KORR-X02"

# Auftrag anlegen und Material zubuchen
    Given I create a SalesOrder "auftrag" for Customer "RADSHOP" with Product "BM_BAUGRUPPE" and quantity "10"

    Given I post a receipt via ManualStockAdjustment for Product "B_EINKAUF-1" and quantity "10" on StorageLocation "F1" with document "ZUGANG-X02" and price "0"
    Given I post a receipt via ManualStockAdjustment for Product "B_EINKAUF-1" and quantity "10" on StorageLocation "F2" with document "ZUGANG-X02" and price "0"
    Given I post a receipt via ManualStockAdjustment for Product "B_EINKAUF-2" and quantity "10" on StorageLocation "F1" with document "ZUGANG-X02" and price "0"

# Fertigungsvorschlag anlegen und freigeben
    Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
    And I append rows
      | artikel      | netmge | bisuch     | mfreig |
      | BM_BAUGRUPPE | 10     | PLAETZE2X_ | ja     |
    And I press button "freig" to open a subeditor for "BA_freigeben"
    And I close the current editor
    And I switch the current editor to editor "fvor"
    And I save the current editor

# Materialentnahmen über die Mengen von B_EINKAUF-1 auf F1 und F2
    Given I open an editor "Materialentnahme1" for tip command "Fbuchung" and arguments ""
    And I set fields
      | auftrag     | $,,such=PLAETZE2X_001;@richtung=rückwärts;@maxtreffer=1 |
      | gmgevorschl | 5                                                       |
      | bem         | Entnahme1                                               |
    And I press button "stllad"
    And I save the current editor
    And I set the fake date to "22.1.95"
    And I wait 1 time units to move the time forward

    Given I open an editor "Materialentnahme1" from table "(Workorder):(CompletionConfirmations)" with command "VIEW" for search criteria "$,,such=PLAETZE2X_001;manrm=ja;@richtung=rückwärts;@maxtreffer=1;@ablageart=abgelegt"
    And I close the current editor

    Given I open an editor "Materialentnahme2" for tip command "Fbuchung" and arguments ""
    And I set fields
      | auftrag     | $,,such=PLAETZE2X_001;@richtung=rückwärts;@maxtreffer=1 |
      | gmgevorschl | 5                                                       |
      | bem         | Entnahme2                                               |
    And I press button "stllad"
    And I modify table
      | !row                | buplatz |
      | elex=='B_EINKAUF-1' | F2      |
    And I save the current editor

    Given I open an editor "Materialentnahme2" from table "(Workorder):(CompletionConfirmations)" with command "VIEW" for search criteria "$,,such=PLAETZE2X_001;manrm=ja;@richtung=rückwärts;@maxtreffer=1;@ablageart=abgelegt"
    And I close the current editor

# Materialentnahme über Mengenvorschlag einen Teil des entnommenen Materials auf F1 zurückbuchen
    Given I open an editor "Rückgabe1" for tip command "Fbuchung" and arguments ""
    And I set fields
      | auftrag     | $,,such=PLAETZE2X_001;@richtung=rückwärts;@maxtreffer=1 |
      | gmgevorschl | -4                                                      |
      | bem         | Rückgabe1                                               |
    And I press button "stllad"
    Then table has values
      | bumge | elex        | nlimge | chentmge | entmge | buplatz |
      | -8    | B_EINKAUF-1 | 8      | 20       | 20     | F1      |
      | -4    | B_EINKAUF-2 | 4      | 10       | 10     | F1      |
    And I save the current editor

# Belege zu Materialentnahmme und -rückgabe prüfen
    Given I open an editor "Rückgabe1" from table "(Workorder):(CompletionConfirmations)" with command "VIEW" for search criteria "$,,such=PLAETZE2X_001;bem=Rückgabe1;manrm=ja;@ablageart=abgelegt;@richtung=rückwärts;@maxtreffer=1"
    Then table has values
      | mge | artikel      | rueckmge | restmge | limgev | limgen | buplatz |
      | 10  | BM_BAUGRUPPE | 0        | 0       | 0      | 0      | F1      |
      | -4  | B_EINKAUF-2  | -4       | 0       | 0      | 4      | F1      |
      | -8  | B_EINKAUF-1  | -8       | 0       | 0      | 8      | F1      |
    And I close the current editor

    And I switch the current editor to editor "Materialentnahme2" with command "VIEW"
    Then table has values
      | mge | artikel      | rueckmge | restmge | limgev | limgen | buplatz |
      | 10  | BM_BAUGRUPPE | 0        | 0       | 0      | 0      | F1      |
      | 5   | B_EINKAUF-2  | 4        | 1       | 5      | 0      | F1      |
      | 10  | B_EINKAUF-1  | 8        | 2       | 10     | 0      | F2      |
    And I close the current editor

    And I switch the current editor to editor "Materialentnahme1" with command "VIEW"
    Then table has values
      | mge | artikel      | rueckmge | restmge | limgev | limgen | buplatz |
      | 10  | BM_BAUGRUPPE | 0        | 0       | 0      | 0      | F1      |
      | 5   | B_EINKAUF-2  | 0        | 5       | 10     | 5      | F1      |
      | 10  | B_EINKAUF-1  | 0        | 10      | 20     | 10     | F1      |
    And I close the current editor

 # Lagerjournaleintrag und Bestand prüfen
    Given I open the infosystem "LJ"
    And I set field "beleg" to "!Materialentnahme1^barmex"
    And I set field "richtung" to "rückwärts"
    And I press start
    Then table has values
      | art         | amge | vplatz | rueckmge | restmge | !row |
      | B_EINKAUF-1 | -8   | F1     | -8       | 0       | 1    |
      | B_EINKAUF-2 | -4   | F1     | -4       | 0       | 2    |
      | B_EINKAUF-1 | 10   | F2     | 8        | 2       | 3    |
      | B_EINKAUF-2 | 5    | F1     | 4        | 1       | 4    |
      | B_EINKAUF-1 | 10   | F1     | 0        | 10      | 5    |
      | B_EINKAUF-2 | 5    | F1     | 0        | 5       | 6    |
    Then field "rueckorig^id" in row 1 has value equal to field "verweis^id" from editor "LJ" in row 3
    And I close the current editor

    Given I open the infosystem "BESTAND"
    And I set fields
      | artikel    | B_EINKAUF-1 |
      | klplatz    |             |
      | verdichten | nein        |
      | nullmge    | nein        |
      | details    | nein        |
    And I press start
    And I press button "taufzu" in row 1
    Then the table has 2 rows
    Then table has values
      | lemge | lplatz | gebmge |
      | 8     | F1     |        |
      |       | F1     | 8      |
    And I close the current editor

# Betriebsauftrag abschließen und Auftrag liefern
    Given I open an editor "Rückmeldung1" from table "(Workorder):(WorkOrders)" with command "DONE" for record "PLAETZE2X_001"
    And I set fields
      | sofort  | ja |
      | gut     | ja |
      | manrest | ja |
    And I save the current editor
    And I deliver the SalesOrder "auftrag" with PackingSlip "LS-X01"

    Given I open the infosystem "BESTAND"
    And I set fields
      | artikel    | B_EINKAUF-1 |
      | klplatz    |             |
      | verdichten | nein        |
      | nullmge    | nein        |
      | details    | nein        |
    And I press start
    Then the table has 0 rows
    And I close the current editor


  Scenario: 16 Teil-Rückgabe auf verschiedene Lagerplätze auf letzten AS, bisher Materialentnahme von verschiedenen Plätzen, EntnahmeMZ mit Plätzen
    Given I set the fake date to "23.1.95"
  # Bestand auf 0 korrigieren
    Given I set StorageQuantity to zero for Product "B_EINKAUF-1" on StorageLocation "F1" with document "KORR-X03"
    Given I set StorageQuantity to zero for Product "B_EINKAUF-1" on StorageLocation "F2" with document "KORR-X03"
    Given I set StorageQuantity to zero for Product "B_EINKAUF-1" on StorageLocation "F3" with document "KORR-X03"

  # Auftrag anlegen und Material zubuchen
    Given I create a SalesOrder "auftrag" for Customer "RADSHOP" with Product "BM_BAUGRUPPE" and quantity "15"

    Given I post a receipt via ManualStockAdjustment for Product "B_EINKAUF-1" and quantity "10" on StorageLocation "F1" with document "ZUGANG-X03A" and price "0"
    Given I post a receipt via ManualStockAdjustment for Product "B_EINKAUF-1" and quantity "10" on StorageLocation "F2" with document "ZUGANG-X03B" and price "0"
    Given I post a receipt via ManualStockAdjustment for Product "B_EINKAUF-1" and quantity "10" on StorageLocation "F3" with document "ZUGANG-X03C" and price "0"
    Given I post a receipt via ManualStockAdjustment for Product "B_EINKAUF-2" and quantity "10" on StorageLocation "F1" with document "ZUGANG-X03D" and price "0"

# Fertigungsvorschlag anlegen und freigeben
    Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
    And I append rows
      | artikel      | netmge | mfreig |
      | BM_BAUGRUPPE | 15     | ja     |
    And I press button "mzabsm" to open a subeditor for "EntnahmeMZ" in row 1
    And I modify table
      | !row | zuomge | lpsuch |
      | +1   | 10     | F1     |
      | +2   | 10     | F2     |
      | +3   | 10     | F3     |
    And I save the current editor
    And I switch the current editor to editor "fvor"
    And I set field "bisuch" to "PLAETZE3X_" in row 1
    And I press button "freig" to open a subeditor for "BA_freigeben"
    And I close the current editor
    And I switch the current editor to editor "fvor"
    And I save the current editor

# Materialentnahmen über die gesamte Mengen
    Given I open an editor "Materialentnahme1" for tip command "Fbuchung" and arguments ""
    And I set fields
      | auftrag | $,,such=PLAETZE3X_001;@richtung=rückwärts;@maxtreffer=1 |
      | bem     | Entnahme1                                               |
    And I press button "stllad"
    And I save the current editor

    Given I open an editor "Materialentnahme1" from table "(Workorder):(CompletionConfirmations)" with command "VIEW" for search criteria "$,,such=PLAETZE3X_001;manrm=ja;@richtung=rückwärts;@maxtreffer=1;@ablageart=abgelegt"
    And I close the current editor

# Materialrückgabe1 auf F1 zurückbuchen, Materialrückgabe2 auf F3 betrifft mehrere Plätze
    Given I open an editor "Rückgabe1" for tip command "Fbuchung" and arguments ""
    And I set fields
      | auftrag     | $,,such=PLAETZE3X_001;@richtung=rückwärts;@maxtreffer=1 |
      | gmgevorschl | -2                                                      |
      | bem         | Rückgabe1                                               |
    And I press button "stllad"
    Then table has values
      | bumge | elex        | nlimge | chentmge | entmge | buplatz |
      | -4    | B_EINKAUF-1 | 4      | 30       | 30     | F1      |
      | -2    | B_EINKAUF-2 | 2      | 15       | 15     | F1      |
    And I save the current editor

    Given I open an editor "Rückgabe2" for tip command "Fbuchung" and arguments ""
    And I set fields
      | auftrag     | $,,such=PLAETZE3X_001;@richtung=rückwärts;@maxtreffer=1 |
      | gmgevorschl | -7                                                      |
      | bem         | Rückgabe2                                               |
    And I press button "stllad"
    And I set field "buplatz" to "F3" in row 1
    Then table has values
      | bumge | elex        | nlimge | chentmge | entmge | buplatz |
      | -14   | B_EINKAUF-1 | 18     | 26       | 26     | F3      |
      | -7    | B_EINKAUF-2 | 9      | 13       | 13     | F1      |
    And I save the current editor

# Belege zu Materialentnahmme und -rückgabe prüfen
    Given I open an editor "Rückgabe2" from table "(Workorder):(CompletionConfirmations)" with command "VIEW" for search criteria "$,,such=PLAETZE3X_001;bem=Rückgabe2;manrm=ja;@ablageart=abgelegt;@richtung=rückwärts;@maxtreffer=1"
    Then table has values
      | mge | artikel      | rueckmge | restmge | limgev | limgen | buplatz |
      | 15  | BM_BAUGRUPPE | 0        | 0       | 0      | 0      | F1      |
      | -7  | B_EINKAUF-2  | -7       | 0       | 2      | 9      | F1      |
      | -14 | B_EINKAUF-1  | -14      | 0       | 4      | 18     | F3      |
    And I close the current editor

    Given I open an editor "Rückgabe1" from table "(Workorder):(CompletionConfirmations)" with command "VIEW" for search criteria "$,,such=PLAETZE3X_001;bem=Rückgabe1;manrm=ja;@ablageart=abgelegt;@richtung=rückwärts;@maxtreffer=1"
    Then table has values
      | mge | artikel      | rueckmge | restmge | limgev | limgen | buplatz |
      | 15  | BM_BAUGRUPPE | 0        | 0       | 0      | 0      | F1      |
      | -2  | B_EINKAUF-2  | -2       | 0       | 0      | 2      | F1      |
      | -4  | B_EINKAUF-1  | -4       | 0       | 0      | 4      | F1      |
    And I close the current editor

    And I switch the current editor to editor "Materialentnahme1" with command "VIEW"
    Then table has values
      | mge | artikel      | rueckmge | restmge | limgev | limgen | buplatz |
      | 15  | BM_BAUGRUPPE | 0        | 0       | 0      | 0      | F1      |
      | 15  | B_EINKAUF-2  | 9        | 6       | 15     | 0      | F1      |
      | 30  | B_EINKAUF-1  | 18       | 12      | 30     | 0      | F1      |
    And I close the current editor

# Lagerjournaleintrag und Bestand prüfen
    Given I open the infosystem "LJ"
    And I set fields
      | beleg    | !Materialentnahme1^barmex |
      | artikel  | B_EINKAUF-1               |
      | richtung | rückwärts                 |
    And I press start
    Then table has values
      | art         | amge | vplatz | rueckmge | restmge | !row |
      | B_EINKAUF-1 | -8   | F3     | -8       | 0       | 1    |
      | B_EINKAUF-1 | -6   | F3     | -6       | 0       | 2    |
      | B_EINKAUF-1 | -4   | F1     | -4       | 0       | 3    |
      | B_EINKAUF-1 | 10   | F3     | 10       | 0       | 4    |
      | B_EINKAUF-1 | 10   | F2     | 8        | 2       | 5    |
      | B_EINKAUF-1 | 10   | F1     | 0        | 10      | 6    |
    Then field "rueckorig^id" in row 1 has value equal to field "verweis^id" from editor "LJ" in row 5
    Then field "rueckorig^id" in row 2 has value equal to field "verweis^id" from editor "LJ" in row 4
    And I close the current editor

    Given I open the infosystem "BESTAND"
    And I set fields
      | artikel    | B_EINKAUF-1 |
      | klplatz    |             |
      | verdichten | nein        |
      | nullmge    | nein        |
      | details    | nein        |
    And I press start
    And I press button "taufzu" in row 2
    And I press button "taufzu" in row 1
    Then the table has 5 rows
    Then table has values
      | lemge | lplatz | gebmge |
      | 4     | F1     |        |
      |       | F1     | 4      |
      | 14    | F3     |        |
      |       | F3     | 6      |
      |       | F3     | 8      |
    And I close the current editor

# Betriebsauftrag abschließen und Auftrag liefern
    Given I open an editor "Materialentnahme2" for tip command "Fbuchung" and arguments ""
    And I set fields
      | auftrag     | $,,such=PLAETZE3X_001;@richtung=rückwärts;@maxtreffer=1 |
      | gmgevorschl | 7                                                       |
      | bem         | Entnahme2                                               |
    And I press button "stllad"
    And I set field "buplatz" to "F3" in row 1
    And I save the current editor

    Given I open an editor "Rückmeldung1" from table "(Workorder):(WorkOrders)" with command "DONE" for record "PLAETZE3X_001"
    And I set fields
      | sofort  | ja |
      | gut     | ja |
      | manrest | ja |
    And I save the current editor
    And I deliver the SalesOrder "auftrag" with PackingSlip "LS-X01"

    Given I open the infosystem "BESTAND"
    And I set fields
      | artikel    | B_EINKAUF-1 |
      | klplatz    |             |
      | verdichten | nein        |
      | nullmge    | nein        |
      | details    | nein        |
    And I press start
    Then the table has 0 rows
    And I close the current editor


  Scenario: 17 Teil-Rückgabe auf verschiedene Lagerplätze auf letzten AS betreffen mehrere Entnahmen, bisher Materialentnahmen von verschiedenen Plätzen
    Given I set the fake date to "24.1.95"
# Bestand auf 0 korrigieren
    Given I set StorageQuantity to zero for Product "B_EINKAUF-1" on StorageLocation "F1" with document "KORR-X01"
    Given I set StorageQuantity to zero for Product "B_EINKAUF-1" on StorageLocation "F2" with document "KORR-X01"

# Auftrag anlegen und Material zubuchen
    Given I create a SalesOrder "auftrag" for Customer "RADSHOP" with Product "BM_BAUGRUPPE" and quantity "10"

    Given I post a receipt via ManualStockAdjustment for Product "B_EINKAUF-1" and quantity "10" on StorageLocation "F1" with document "ZUGANG-X01" and price "0"
    Given I post a receipt via ManualStockAdjustment for Product "B_EINKAUF-1" and quantity "10" on StorageLocation "F2" with document "ZUGANG-X01" and price "0"
    Given I post a receipt via ManualStockAdjustment for Product "B_EINKAUF-2" and quantity "10" on StorageLocation "F1" with document "ZUGANG-X01" and price "0"

# Fertigungsvorschlag anlegen und freigeben
    Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
    And I append rows
      | artikel      | netmge | bisuch    | mfreig |
      | BM_BAUGRUPPE | 10     | PLAETZEX_ | ja     |
    And I press button "freig" to open a subeditor for "BA_freigeben"
    And I close the current editor
    And I switch the current editor to editor "fvor"
    And I save the current editor

# Materialentnahmen über die Mengen von B_EINKAUF-1 auf F1 und F2
    Given I open an editor "Materialentnahme1" for tip command "Fbuchung" and arguments ""
    And I set fields
      | auftrag     | $,,such=PLAETZEX_001;@richtung=rückwärts;@maxtreffer=1 |
      | gmgevorschl | 5                                                      |
      | bem         | Entnahme1                                              |
    And I press button "stllad"
    And I save the current editor
    And I set the fake date to "25.1.95"
    And I wait 1 time units to move the time forward

    Given I open an editor "Materialentnahme1" from table "(Workorder):(CompletionConfirmations)" with command "VIEW" for search criteria "$,,such=PLAETZEX_001;manrm=ja;@richtung=rückwärts;@maxtreffer=1;@ablageart=abgelegt"
    And I close the current editor

    Given I open an editor "Materialentnahme2" for tip command "Fbuchung" and arguments ""
    And I set fields
      | auftrag     | $,,such=PLAETZEX_001;@richtung=rückwärts;@maxtreffer=1 |
      | gmgevorschl | 5                                                      |
      | bem         | Entnahme2                                              |
    And I press button "stllad"
    And I modify table
      | !row                | buplatz |
      | elex=='B_EINKAUF-1' | F2      |
    And I save the current editor

    Given I open an editor "Materialentnahme2" from table "(Workorder):(CompletionConfirmations)" with command "VIEW" for search criteria "$,,such=PLAETZEX_001;manrm=ja;@richtung=rückwärts;@maxtreffer=1;@ablageart=abgelegt"
    And I close the current editor

# Materialentnahme über Mengenvorschlag einen Teil des entnommenen Materials zurückbuchen
    Given I open an editor "Rückgabe1" for tip command "Fbuchung" and arguments ""
    And I set fields
      | auftrag     | $,,such=PLAETZEX_001;@richtung=rückwärts;@maxtreffer=1 |
      | gmgevorschl | -6                                                     |
      | bem         | Rückgabe1                                              |
    And I press button "stllad"
    Then table has values
      | bumge | elex        | nlimge | chentmge | entmge | buplatz |
      | -12   | B_EINKAUF-1 | 12     | 20       | 20     | F1      |
      | -6    | B_EINKAUF-2 | 6      | 10       | 10     | F1      |
    And I save the current editor

# Belege zu Materialentnahmme und -rückgabe prüfen
    Given I open an editor "Rückgabe1" from table "(Workorder):(CompletionConfirmations)" with command "VIEW" for search criteria "$,,such=PLAETZEX_001;bem=Rückgabe1;manrm=ja;@ablageart=abgelegt;@richtung=rückwärts;@maxtreffer=1"
    Then table has values
      | mge | artikel      | rueckmge | restmge | limgev | limgen | buplatz |
      | 10  | BM_BAUGRUPPE | 0        | 0       | 0      | 0      | F1      |
      | -6  | B_EINKAUF-2  | -6       | 0       | 0      | 6      | F1      |
      | -12 | B_EINKAUF-1  | -12      | 0       | 0      | 12     | F1      |
    And I close the current editor

    And I switch the current editor to editor "Materialentnahme2" with command "VIEW"
    Then table has values
      | mge | artikel      | rueckmge | restmge | limgev | limgen | buplatz |
      | 10  | BM_BAUGRUPPE | 0        | 0       | 0      | 0      | F1      |
      | 5   | B_EINKAUF-2  | 5        | 0       | 5      | 0      | F1      |
      | 10  | B_EINKAUF-1  | 10       | 0       | 10     | 0      | F2      |
    And I close the current editor

    And I switch the current editor to editor "Materialentnahme1" with command "VIEW"
    Then table has values
      | mge | artikel      | rueckmge | restmge | limgev | limgen | buplatz |
      | 10  | BM_BAUGRUPPE | 0        | 0       | 0      | 0      | F1      |
      | 5   | B_EINKAUF-2  | 1        | 4       | 10     | 5      | F1      |
      | 10  | B_EINKAUF-1  | 2        | 8       | 20     | 10     | F1      |
    And I close the current editor

# Lagerjournaleintrag und Bestand prüfen
    Given I open the infosystem "LJ"
    And I set field "beleg" to "!Materialentnahme1^barmex"
    And I set field "richtung" to "rückwärts"
    And I press start
    Then table has values
      | art         | amge | vplatz | rueckmge | restmge | !row |
      | B_EINKAUF-1 | -2   | F1     | -2       | 0       | 1    |
      | B_EINKAUF-1 | -10  | F1     | -10      | 0       | 2    |
      | B_EINKAUF-2 | -1   | F1     | -1       | 0       | 3    |
      | B_EINKAUF-2 | -5   | F1     | -5       | 0       | 4    |
      | B_EINKAUF-1 | 10   | F2     | 10       | 0       | 5    |
      | B_EINKAUF-2 | 5    | F1     | 5        | 0       | 6    |
      | B_EINKAUF-1 | 10   | F1     | 2        | 8       | 7    |
      | B_EINKAUF-2 | 5    | F1     | 1        | 4       | 8    |
    Then field "rueckorig^id" in row 1 has value equal to field "verweis^id" from editor "LJ" in row 7
    Then field "rueckorig^id" in row 2 has value equal to field "verweis^id" from editor "LJ" in row 5
    And I close the current editor

    Given I open the infosystem "BESTAND"
    And I set fields
      | artikel    | B_EINKAUF-1 |
      | klplatz    |             |
      | verdichten | nein        |
      | nullmge    | nein        |
      | details    | nein        |
    And I press start
    And I press button "taufzu" in row 1
    Then the table has 3 rows
    Then table has values
      | lemge | lplatz | gebmge |
      | 12    | F1     |        |
      |       | F1     | 10     |
      |       | F1     | 2      |
    And I close the current editor

# Betriebsauftrag abschließen und Auftrag liefern
    Given I open an editor "Rückmeldung1" from table "(Workorder):(WorkOrders)" with command "DONE" for record "PLAETZEX_001"
    And I set fields
      | sofort  | ja |
      | gut     | ja |
      | manrest | ja |
    And I save the current editor
    And I deliver the SalesOrder "auftrag" with PackingSlip "LS-X01"

    Given I open the infosystem "BESTAND"
    And I set fields
      | artikel    | B_EINKAUF-1 |
      | klplatz    |             |
      | verdichten | nein        |
      | nullmge    | nein        |
      | details    | nein        |
    And I press start
    Then the table has 0 rows
    And I close the current editor


  Scenario: 18 Teil-Rückgabe mit Chargen auf letzten AS, bisher Materialentnahme mit Chargenangabe gebucht
    Given I set the fake date to "26.1.95"
    And I set the fake date to "27.1.95"
# Bestand auf 0 korrigieren
    Given I set StorageQuantity to zero for Product "B_EINKAUF-1" on StorageLocation "F1" with document "KORR-X05"

#Chargen anlegen und Bedarfe zubuchen
    Given I create a Lot "CH1_MATX5" for Product "B_EINKAUF-1"
    Given I create a Lot "CH2_MATX5" for Product "B_EINKAUF-1"

#Auftrag anlegen und Bedarfe einkaufen
    Given I create a SalesOrder "auftrag" for Customer "RADSHOP" with Product "BM_BAUGRUPPE" and quantity "10"

    Given I open an editor "Rechnung" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
    And I set fields
      | lief   | KETTLER |
      | vom    | .       |
      | ueb    | ja      |
      | fakt   | ja      |
      | ebeleg | R-X05   |
    And I append rows
      | artikel     | mge | charge        |
      | B_EINKAUF-1 | 10  | !CH1_MATX5^id |
      | B_EINKAUF-1 | 10  | !CH2_MATX5^id |
      | B_EINKAUF-2 | 10  |               |
    And I respond with answer "ja" to the dialog with id "4841"
    And I save the current editor

# Fertigungsvorschlag anlegen und freigeben
    Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
    And I append rows
      | artikel      | netmge | mfreig | bisuch      |
      | BM_BAUGRUPPE | 10     | ja     | CHMATERIAL_ |
    And I press button "freig" to open a subeditor for "BA_freigeben"
    And I close the current editor
    And I switch the current editor to editor "fvor"
    And I save the current editor

# Zwei Materialentnahmen über mit je einer Chargen für das Material
    Given I open an editor "Materialentnahme1" for tip command "Fbuchung" and arguments ""
    And I set field "auftrag" to "$,,such=CHMATERIAL_001;@richtung=rückwärts;@maxtreffer=1"
    And I set field "bem" to "Entnahme1"
    And I press button "stllad"
    And I modify table
      | bumge       | rescharge     | !row |
      | 10          | !CH1_MATX5^id | 1    |
      | !dontChange |               | 2    |
    And I save the current editor

    Given I open an editor "Materialentnahme1" from table "(Workorder):(CompletionConfirmations)" with command "VIEW" for search criteria "$,,such=CHMATERIAL_001;bem=Entnahme1;@ablageart=abgelegt;@richtung=rückwärts;@maxtreffer=1"
    And I close the current editor

    Given I open an editor "Materialentnahme2" for tip command "Fbuchung" and arguments ""
    And I set field "auftrag" to "$,,such=CHMATERIAL_001;@richtung=rückwärts;@maxtreffer=1"
    And I set field "bem" to "Entnahme2"
    And I press button "stllad"
    And I modify table
      | bumge | !row |
      | 10    | 1    |
	And I press button "mzsubm" to open a subeditor for "MZ" in row 1
	And I set field "charge" to "!CH2_MATX5^id" in row 1
	And I save the current editor
	And I switch the current editor to editor "Materialentnahme2"
    And I save the current editor

    Given I open an editor "Materialentnahme2" from table "(Workorder):(CompletionConfirmations)" with command "VIEW" for search criteria "$,,such=CHMATERIAL_001;bem=Entnahme2;@ablageart=abgelegt;@richtung=rückwärts;@maxtreffer=1"
    And I close the current editor

# Über Fertigcharge einen Teil des entnommenen Materials zurückbuchen
    Given I open an editor "Rückgabe1" for tip command "Fbuchung" and arguments ""
    And I set fields
      | auftrag     | $,,such=CHMATERIAL_001;@richtung=rückwärts;@maxtreffer=1 |
      | gmgevorschl | -2                                                       |
      | bem         | Rückgabe                                                 |
    And I press button "stllad"
    And I set field "rescharge" to "!CH1_MATX5" in row 1
    Then table has values
      | bumge | elex        | nlimge | limge | chentmge | entmge | rescharge^such |
      | -4    | B_EINKAUF-1 | 4      | 0     | 10       | 20     | CH1_MATX5      |
      | -2    | B_EINKAUF-2 | 2      | 0     | 10       | 10     |                |
    And I save the current editor

# Belege zu Materialentnahmme und -rückgabe prüfen
    Given I open an editor "Rückgabe1" from table "(Workorder):(CompletionConfirmations)" with command "VIEW" for search criteria "$,,such=CHMATERIAL_001;@ablageart=abgelegt;@richtung=rückwärts;@maxtreffer=1"
    Then the table has 3 rows
    Then table has values
      | mge | artikel      | rueckmge | restmge | limgev | limgen |
      | 10  | BM_BAUGRUPPE | 0        | 0       | 0      | 0      |
      | -2  | B_EINKAUF-2  | -2       | 0       | 0      | 2      |
      | -4  | B_EINKAUF-1  | -4       | 0       | 0      | 4      |
    And I close the current editor

    And I switch the current editor to editor "Materialentnahme2" with command "VIEW"
    Then the table has 2 rows
    Then table has values
      | mge | artikel      | rueckmge | restmge | limgev | limgen |
      | 10  | BM_BAUGRUPPE | 0        | 0       | 0      | 0      |
      | 10  | B_EINKAUF-1  | 0        | 10      | 10     | 0      |
    And I close the current editor

    And I switch the current editor to editor "Materialentnahme1" with command "VIEW"
    Then the table has 3 rows
    Then table has values
      | mge | artikel      | rueckmge | restmge | limgev | limgen |
      | 10  | BM_BAUGRUPPE | 0        | 0       | 0      | 0      |
      | 10  | B_EINKAUF-2  | 2        | 8       | 10     | 0      |
      | 10  | B_EINKAUF-1  | 4        | 6       | 20     | 10     |
    And I close the current editor

# Lagerjournal und Bestand prüfen
    Given I open the infosystem "LJ"
    And I set field "beleg" to "barmex" from editor "Materialentnahme1"
    And I set field "richtung" to "rückwärts"
    And I press start
    Then table has values
      | art         | zmge | amge | rueckmge | restmge | vcharge^such | !row |
      | B_EINKAUF-1 |      | -4   | -4       | 0       | CH1_MATX5    | 1    |
      | B_EINKAUF-2 |      | -2   | -2       | 0       |              | 2    |
      | B_EINKAUF-1 |      | 10   | 0        | 10      | CH2_MATX5    | 3    |
      | B_EINKAUF-1 |      | 10   | 4        | 6       | CH1_MATX5    | 4    |
      | B_EINKAUF-2 |      | 10   | 2        | 8       |              | 5    |
    Then field "rueckorig^id" in row 1 has value equal to field "verweis^id" from editor "LJ" in row 4
    And I close the current editor

    Given I open the infosystem "BESTAND"
    And I set fields
      | artikel    | B_EINKAUF-1 |
      | klplatz    | F1          |
      | verdichten | nein        |
      | nullmge    | nein        |
      | details    | nein        |
    And I press start
    And I press button "taufzu" in row 1
    Then the table has 2 rows
    Then table has values
      | lemge | lplatz | gebmge | charge^such |
      | 4     | F1     |        |             |
      |       | F1     | 4      | CH1_MATX5   |
    And I close the current editor

# Betriebsauftrag abschließen und Auftrag liefern
    Given I open an editor "Materialentnahme1" for tip command "Fbuchung" and arguments ""
    And I set field "auftrag" to "$,,such=CHMATERIAL_001;@richtung=rückwärts;@maxtreffer=1"
    And I press button "stllad"
    And I save the current editor

    Given I open an editor "Rückmeldung1" from table "(Workorder):(WorkOrders)" with command "DONE" for record "CHMATERIAL_001"
    And I set fields
      | sofort | ja |
      | gut    | ja |
    And I save the current editor

    Given I open the infosystem "BESTAND"
    And I set fields
      | artikel    | B_EINKAUF-1 |
      | klplatz    | F1          |
      | verdichten | nein        |
      | nullmge    | nein        |
      | details    | nein        |
    And I press start
    Then the table has 0 rows
    And I close the current editor

    And I deliver the SalesOrder "auftrag" with PackingSlip "LS-MANX05"


  Scenario: 19 Teil-Rückgabe über Chargenangabe des Fertigteils auf letzten AS, bisher zwei Rückmeldungen mit Chargenangabe Fertigteil gebucht
    Given I set the fake date to "28.1.95"
# Bestand auf 0 korrigieren
    Given I set StorageQuantity to zero for Product "B_EINKAUF-1" on StorageLocation "F1" with document "KORR-X03"

#Chargen anlegen und Bedarfe zubuchen
    Given I create a Lot "CH1_BGX3" for Product "BM_BAUGRUPPE"
    Given I create a Lot "CH2_BGX3" for Product "BM_BAUGRUPPE"

#Auftrag anlegen und Bedarfe zubuchen
    Given I create a SalesOrder "auftrag" for Customer "RADSHOP" with Product "BM_BAUGRUPPE" and quantity "10"

    Given I post a receipt via ManualStockAdjustment for Product "B_EINKAUF-1" and quantity "20" on StorageLocation "F1" with document "ZUGANG-X03E" and price "0"
    Given I post a receipt via ManualStockAdjustment for Product "B_EINKAUF-2" and quantity "10" on StorageLocation "F1" with document "ZUGANG-X03F" and price "0"

# Fertigungsvorschlag anlegen und freigeben
    Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
    And I append rows
      | artikel      | netmge | mfreig | bisuch    |
      | BM_BAUGRUPPE | 10     | ja     | CHGUTMGE_ |
    And I press button "freig" to open a subeditor for "BA_freigeben"
    And I close the current editor
    And I switch the current editor to editor "fvor"
    And I save the current editor

# Materialentnahme über gesamte Gutmenge und zwei Teil-Rückmeldungen mit Chargen für das Fertigteil
    Given I open an editor "Materialentnahme1" for tip command "Fbuchung" and arguments ""
    And I set field "auftrag" to "$,,such=CHGUTMGE_001;@richtung=rückwärts;@maxtreffer=1"
    And I set field "charge" to "!CH1_BGX3"
    And I press button "stllad"
    And I save the current editor

    Given I open an editor "Materialentnahme1" from table "(Workorder):(CompletionConfirmations)" with command "VIEW" for search criteria "$,,such=CHGUTMGE_001;@ablageart=abgelegt;@richtung=rückwärts;@maxtreffer=1"
    And I close the current editor

    Given I open an editor "Rückmeldung1" from table "(Workorder):(WorkOrders)" with command "DONE" for record "CHGUTMGE_001"
    And I set fields
      | sofort  | ja        |
      | kcharge | !CH1_BGX3 |
    And I set field "gutmge" to "4" in row 1
    And I save the current editor

    Given I open an editor "Rückmeldung2" from table "(Workorder):(WorkOrders)" with command "DONE" for record "CHGUTMGE_001"
    And I set fields
      | sofort  | ja        |
      | kcharge | !CH2_BGX3 |
    And I set field "gutmge" to "4" in row 1
    And I save the current editor

# Über Fertigcharge einen Teil des entnommenen Materials zurückbuchen
    Given I open an editor "Rückgabe1" for tip command "Fbuchung" and arguments ""
    And I set fields
      | auftrag     | $,,such=CHGUTMGE_001;@richtung=rückwärts;@maxtreffer=1 |
      | gmgevorschl | -2                                                     |
      | charge      | !CH1_BGX3                                              |
      | bem         | Rückgabe                                               |
    And I press button "stllad"
    Then table has values
      | bumge | elex        | nlimge | limge | chentmge | entmge |
      | -4    | B_EINKAUF-1 | 4      | 0     | 20       | 20     |
      | -2    | B_EINKAUF-2 | 2      | 0     | 10       | 10     |
    And I set field "bumge" to "-5" in row 1
    And I save the current editor

# Belege zu Materialentnahmme und -rückgabe prüfen
    Given I open an editor "Rückgabe1" from table "(Workorder):(CompletionConfirmations)" with command "VIEW" for search criteria "$,,such=CHGUTMGE_001;@ablageart=abgelegt;@richtung=rückwärts;@maxtreffer=1"
    Then the table has 3 rows
    Then table has values
      | mge | artikel      | rueckmge | restmge | limgev | limgen |
      | 2   | BM_BAUGRUPPE | 0        | 0       | 8      | 8      |
      | -2  | B_EINKAUF-2  | -2       | 0       | 0      | 2      |
      | -5  | B_EINKAUF-1  | -5       | 0       | 0      | 5      |
    And I close the current editor

    And I switch the current editor to editor "Materialentnahme1" with command "VIEW"
    Then the table has 3 rows
    Then table has values
      | mge | artikel      | rueckmge | restmge | limgev | limgen |
      | 10  | BM_BAUGRUPPE | 0        | 0       | 0      | 0      |
      | 10  | B_EINKAUF-2  | 2        | 8       | 10     | 0      |
      | 20  | B_EINKAUF-1  | 5        | 15      | 20     | 0      |
    And I close the current editor

# Lagerjournal und Bestand prüfen
    Given I open the infosystem "LJ"
    And I set field "beleg" to "barmex" from editor "Materialentnahme1"
    And I set field "richtung" to "rückwärts"
    And I press start
    Then table has values
      | art          | zmge | amge | rueckmge | restmge | ncharge^such | !row |
      | B_EINKAUF-1  |      | -5   | -5       | 0       | CH1_BGX3     | 1    |
      | B_EINKAUF-2  |      | -2   | -2       | 0       | CH1_BGX3     | 2    |
      | BM_BAUGRUPPE | 4    |      | 0        | 4       | CH2_BGX3     | 3    |
      | BM_BAUGRUPPE | 4    |      | 0        | 4       | CH1_BGX3     | 4    |
      | B_EINKAUF-1  |      | 20   | 5        | 15      | CH1_BGX3     | 5    |
      | B_EINKAUF-2  |      | 10   | 2        | 8       | CH1_BGX3     | 6    |
    Then field "rueckorig^id" in row 1 has value equal to field "verweis^id" from editor "LJ" in row 5
    And I close the current editor

    Given I open the infosystem "BESTAND"
    And I set fields
      | artikel    | B_EINKAUF-1 |
      | klplatz    | F1          |
      | verdichten | nein        |
      | nullmge    | nein        |
      | details    | nein        |
    And I press start
    And I press button "taufzu" in row 1
    Then the table has 2 rows
    Then table has values
      | lemge | lplatz | gebmge |
      | 5     | F1     |        |
      |       | F1     | 5      |
    And I close the current editor

# Betriebsauftrag abschließen und Auftrag liefern
    Given I open an editor "Rückmeldung1" from table "(Workorder):(WorkOrders)" with command "DONE" for record "CHGUTMGE_001"
    And I set fields
      | sofort  | ja |
      | gut     | ja |
      | manrest | ja |
    And I save the current editor

    Given I open the infosystem "BESTAND"
    And I set fields
      | artikel    | B_EINKAUF-1 |
      | klplatz    | F1          |
      | verdichten | nein        |
      | nullmge    | nein        |
      | details    | nein        |
    And I press start
    Then the table has 0 rows
    And I close the current editor

    And I deliver the SalesOrder "auftrag" with PackingSlip "LS-MANX03"


  Scenario: 20 Teil-Rückgabe über Chargenangabe des Fertigteils auf letzten AS, EntnahmeMZ mit Chargen vor Freigabe FV angelegt
    Given I set the fake date to "1.2.95"
    And I set the fake date to "2.2.95"

# Bestand auf 0 korrigieren
    Given I set StorageQuantity to zero for Product "B_EINKAUF-1" on StorageLocation "F1" with document "KORR-X04"

#Chargen anlegen und Bedarfe zubuchen
    Given I create a Lot "CH1_BGX4" for Product "BM_BAUGRUPPE"
    Given I create a Lot "CH2_BGX4" for Product "BM_BAUGRUPPE"
    Given I create a Lot "CH1_MATX4" for Product "B_EINKAUF-1"
    Given I create a Lot "CH2_MATX4" for Product "B_EINKAUF-1"

#Auftrag anlegen und Bedarfe einkaufen
    Given I create a SalesOrder "auftrag" for Customer "RADSHOP" with Product "BM_BAUGRUPPE" and quantity "10"

    Given I open an editor "Rechnung" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
    And I set fields
      | lief   | KETTLER |
      | vom    | .       |
      | ueb    | ja      |
      | fakt   | ja      |
      | ebeleg | R-07    |
    And I append rows
      | artikel     | mge | charge        |
      | B_EINKAUF-1 | 10  | !CH1_MATX4^id |
      | B_EINKAUF-1 | 10  | !CH2_MATX4^id |
      | B_EINKAUF-2 | 10  |               |
    And I respond with answer "ja" to the dialog with id "4841"
    And I save the current editor

# Fertigungsvorschlag anlegen und freigeben
    Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
    And I append rows
      | artikel      | netmge | mfreig |
      | BM_BAUGRUPPE | 10     | ja     |
    And I press button "mzabsm" to open a subeditor for "EntnahmeMZ" in row !lastRow
    And I modify table
      | !row | zuomge | charge        |
      | +1   | 10     | !CH1_MATX4^id |
      | +2   | 10     | !CH2_MATX4^id |
    And I save the current editor
    And I switch the current editor to editor "fvor"
    And I set field "bisuch" to "CHMATGUT_" in row !lastRow
    And I press button "freig" to open a subeditor for "BA_freigeben"
    And I close the current editor
    And I switch the current editor to editor "fvor"
    And I save the current editor

# Materialentnahme über gesamte Gutmenge und zwei Teil-Rückmeldungen mit Chargen für das Fertigteil
    Given I open an editor "Materialentnahme1" for tip command "Fbuchung" and arguments ""
    And I set field "auftrag" to "$,,such=CHMATGUT_001;@richtung=rückwärts;@maxtreffer=1"
    And I set field "charge" to "!CH1_BGX4"
    And I press button "stllad"
    And I save the current editor

    Given I open an editor "Materialentnahme1" from table "(Workorder):(CompletionConfirmations)" with command "VIEW" for search criteria "$,,such=CHMATGUT_001;@ablageart=abgelegt;@richtung=rückwärts;@maxtreffer=1"
    And I close the current editor

    Given I open an editor "Rückmeldung1" from table "(Workorder):(WorkOrders)" with command "DONE" for record "CHMATGUT_001"
    And I set fields
      | sofort  | ja        |
      | kcharge | !CH1_BGX4 |
    And I set field "gutmge" to "4" in row 1
    And I save the current editor

    Given I open an editor "Rückmeldung2" from table "(Workorder):(WorkOrders)" with command "DONE" for record "CHMATGUT_001"
    And I set fields
      | sofort  | ja        |
      | kcharge | !CH2_BGX4 |
    And I set field "gutmge" to "4" in row 1
    And I save the current editor

# Über Fertigcharge einen Teil des entnommenen Materials zurückbuchen
    Given I open an editor "Rückgabe1" for tip command "Fbuchung" and arguments ""
    And I set fields
      | auftrag     | $,,such=CHMATGUT_001;@richtung=rückwärts;@maxtreffer=1 |
      | gmgevorschl | -2                                                     |
      | charge      | !CH1_BGX4                                              |
      | bem         | Rückgabe                                               |
    And I press button "stllad"
    And I set field "rescharge" to "!CH1_MATX4" in row 1
    Then table has values
      | bumge | elex        | nlimge | limge | chentmge | entmge | rescharge^id  |
      | -4    | B_EINKAUF-1 | 4      | 0     | 10       | 20     | !CH1_MATX4^id |
      | -2    | B_EINKAUF-2 | 2      | 0     | 10       | 10     | (0,0,0)       |
    And I save the current editor

# Belege zu Materialentnahmme und -rückgabe prüfen
    Given I open an editor "Rückgabe1" from table "(Workorder):(CompletionConfirmations)" with command "VIEW" for search criteria "$,,such=CHMATGUT_001;@ablageart=abgelegt;@richtung=rückwärts;@maxtreffer=1"
    Then the table has 3 rows
    Then table has values
      | mge | artikel      | rueckmge | restmge | limgev | limgen |
      | 2   | BM_BAUGRUPPE | 0        | 0       | 8      | 8      |
      | -2  | B_EINKAUF-2  | -2       | 0       | 0      | 2      |
      | -4  | B_EINKAUF-1  | -4       | 0       | 0      | 4      |
    And I close the current editor

    And I switch the current editor to editor "Materialentnahme1" with command "VIEW"
    Then the table has 3 rows
    Then table has values
      | mge | artikel      | rueckmge | restmge | limgev | limgen |
      | 10  | BM_BAUGRUPPE | 0        | 0       | 0      | 0      |
      | 10  | B_EINKAUF-2  | 2        | 8       | 10     | 0      |
      | 20  | B_EINKAUF-1  | 4        | 16      | 20     | 0      |
    And I close the current editor

# Lagerjournal und Bestand prüfen
    Given I open the infosystem "LJ"
    And I set field "beleg" to "barmex" from editor "Materialentnahme1"
    And I set field "richtung" to "rückwärts"
    And I press start
    Then table has values
      | art          | zmge | amge | rueckmge | restmge | ncharge^such | vcharge^such | !row |
      | B_EINKAUF-1  |      | -4   | -4       | 0       | CH1_BGX4     | CH1_MATX4    | 1    |
      | B_EINKAUF-2  |      | -2   | -2       | 0       | CH1_BGX4     |              | 2    |
      | BM_BAUGRUPPE | 4    |      | 0        | 4       | CH2_BGX4     |              | 3    |
      | BM_BAUGRUPPE | 4    |      | 0        | 4       | CH1_BGX4     |              | 4    |
      | B_EINKAUF-1  |      | 10   | 0        | 10      | CH1_BGX4     | CH2_MATX4    | 5    |
      | B_EINKAUF-1  |      | 10   | 4        | 6       | CH1_BGX4     | CH1_MATX4    | 6    |
      | B_EINKAUF-2  |      | 10   | 2        | 8       | CH1_BGX4     |              | 7    |
    Then field "rueckorig^id" in row 1 has value equal to field "verweis^id" from editor "LJ" in row 6
    And I close the current editor

    Given I open the infosystem "BESTAND"
    And I set fields
      | artikel    | B_EINKAUF-1 |
      | klplatz    | F1          |
      | verdichten | nein        |
      | nullmge    | nein        |
      | details    | nein        |
    And I press start
    And I press button "taufzu" in row 1
    Then the table has 2 rows
    Then table has values
      | lemge | gebmge | charge^such |
      | 4     |        |             |
      |       | 4      | CH1_MATX4   |
    And I close the current editor

# Betriebsauftrag abschließen und Auftrag liefern
    Given I open an editor "Materialentnahme1" for tip command "Fbuchung" and arguments ""
    And I set field "auftrag" to "$,,such=CHMATGUT_001;@richtung=rückwärts;@maxtreffer=1"
    And I press button "stllad"
	And I press button "mzsubm" to open a subeditor for "MZ" in row 1
	And I set field "charge" to "!CH1_MATX4^id" in row 1
	And I save the current editor
	And I switch the current editor to editor "Materialentnahme1"
    And I save the current editor

    Given I open an editor "Rückmeldung1" from table "(Workorder):(WorkOrders)" with command "DONE" for record "CHMATGUT_001"
    And I set fields
      | sofort | ja |
      | gut    | ja |
    And I save the current editor

    Given I open the infosystem "BESTAND"
    And I set fields
      | artikel    | B_EINKAUF-1 |
      | klplatz    | F1          |
      | verdichten | nein        |
      | nullmge    | nein        |
      | details    | nein        |
    And I press start
    Then the table has 0 rows
    And I close the current editor

    And I deliver the SalesOrder "auftrag" with PackingSlip "LS-MANX04"


  Scenario: 21 Teil-Rückgabe in leere und gefüllte Behälter auf letzten AS, bisher Materialentnahme mit Behälterangabe gebucht
    Given I set the fake date to "3.2.95"

    And I set the fake date to "4.2.95"
# Behälter anlegen
    Given I create a Container "B_MATERIAL1" for packaging material "BEHAELTER"
    Given I create a Container "B_MATERIAL2" for packaging material "BEHAELTER"
    Given I create a Container "B_MATERIAL3" for packaging material "BEHAELTER"
    Given I create a Container "B_LEER" for packaging material "BEHAELTER"

# Auftrag anlagen und Bedarfe einkaufen
    Given I create a SalesOrder "auftrag" for Customer "RADSHOP" with Product "BM_BAUGRUPPE" and quantity "10"
    Given I open an editor "Rechnung" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
    And I set fields
      | lief   | KETTLER |
      | vom    | .       |
      | ueb    | ja      |
      | fakt   | ja      |
      | ebeleg | R-X06   |
    And I append rows
      | artikel     | mge |
      | B_EINKAUF-1 | 10  |
      | B_EINKAUF-1 | 10  |
      | B_EINKAUF-2 | 5   |
      | B_EINKAUF-2 | 5   |
    And I respond with answer "nein" to the dialog with id "Externe Behälternummer ist bereits vergeben."
    And I set field "exbehnum" to "!B_MATERIAL1^nummer" in row 1
    And I respond with answer "nein" to the dialog with id "Externe Behälternummer ist bereits vergeben."
    And I set field "exbehnum" to "!B_MATERIAL2^nummer" in row 2
    And I respond with answer "nein" to the dialog with id "Externe Behälternummer ist bereits vergeben."
    And I set field "exbehnum" to "!B_MATERIAL3^nummer" in row 3
    And I respond with answer "ja" to the dialog with id "4841"
    And I save the current editor

# Fertigungsvorschlag anlegen und freigeben
    Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
    And I append rows
      | artikel      | netmge | mfreig | bisuch      |
      | BM_BAUGRUPPE | 10     | ja     | XBEHAELTER_ |
    And I press button "freig" to open a subeditor for "BA_freigeben"
    And I close the current editor
    And I switch the current editor to editor "fvor"
    And I save the current editor

    Given I open an editor "Arbeitsschein1" from table "(Workorder):(WorkOrders)" with command "VIEW" for record "XBEHAELTER_001"
    And I close the current editor

# Materialentnahme Teilmenge
    Given I open an editor "Materialentnahme1" for tip command "Fbuchung" and arguments ""
    And I set fields
      | auftrag     | !Arbeitsschein1^nummer |
      | gmgevorschl | 5                      |
      | bem         | Entnahme1              |
    And I press button "stllad"
    And I modify table
      | behaelter    | !row |
      | !B_MATERIAL1 | 1    |
      | !B_MATERIAL3 | 2    |
    And I save the current editor

# Behälter prüfen
    Then Container from editor "B_MATERIAL1" is empty
    Then Container from editor "B_MATERIAL3" is empty

# Teil-Rückgabe in gefüllten und leeren Behälter (über Zeile)
    Given I open an editor "Rückgabe1" for tip command "Fbuchung" and arguments ""
    And I set fields
      | auftrag     | !Arbeitsschein1^nummer |
      | gmgevorschl | -2                     |
      | bem         | Rückgabe               |
    And I press button "stllad"
    And I modify table
      | !row | behaelter    |
      | 1    | !B_MATERIAL2 |
      | 2    | !B_LEER      |
    Then table has values
      | bumge | bueinh | elex        | nlimge | chentmge | entmge | behaelter^such |
      | -4    | Stück  | B_EINKAUF-1 | 14     | 10       | 10     | B_MATERIAL2    |
      | -2    | Stück  | B_EINKAUF-2 | 7      | 5        | 5      | B_LEER         |
    And I save the current editor

# Behälter prüfen
    Then Container from editor "B_MATERIAL1" is empty

    And I switch the current editor to editor "B_MATERIAL2" with command "VIEW"
    Then the table has 1 rows
    Then table has values
      | artikel     | mge |
      | B_EINKAUF-1 | 14  |
    And I close the current editor
    And I switch the current editor to editor "B_LEER" with command "VIEW"
    Then the table has 1 rows
    Then table has values
      | artikel     | mge |
      | B_EINKAUF-2 | 2   |
    And I close the current editor

# LJ prüfen
    Given I open the infosystem "LJ"
    And I set field "beleg" to "!Arbeitsschein1^nummer"
    And I set field "richtung" to "rückwärts"
    And I press start
    Then table has values
      | art         | amge | zmge | rueckmge | restmge | !row | behaelter^id    |
      | B_EINKAUF-1 | -4   |      | -4       | 0       | 1    | !B_MATERIAL2^id |
      | B_EINKAUF-2 | -2   |      | -2       | 0       | 2    | !B_LEER^id      |
      | B_EINKAUF-1 | 10   |      | 4        | 6       | 3    | !B_MATERIAL1^id |
      | B_EINKAUF-2 | 5    |      | 2        | 3       | 4    | !B_MATERIAL3^id |
    And I close the current editor

# Materialentnahme und Rückmeldung auf ersten AG
    Given I open an editor "Materialentnahme2" for tip command "Fbuchung" and arguments ""
    And I set fields
      | auftrag | !Arbeitsschein1^nummer |
      | bem     | Entnahme2              |
    And I press button "stllad"
    And I modify table
      | !row | bumge       | behaelter       |
      | 1    | !dontChange | !B_MATERIAL2^id |
      | 2    | 2           | !B_LEER^id      |
    And I save the current editor

    Given I open an editor "Rückmeldung1" from table "(Workorder):(WorkOrders)" with command "DONE" for record "XBEHAELTER_001"
    And I set fields
      | gut     | ja |
      | sofort  | ja |
      | manrest | ja |
    And I save the current editor

# Behälter prüfen
    Then Container from editor "B_MATERIAL1" is empty
    Then Container from editor "B_MATERIAL2" is empty
    Then Container from editor "B_MATERIAL3" is empty
    Then Container from editor "B_LEER" is empty

# Lieferschein zu Auftrag
    And I deliver the SalesOrder "auftrag" with PackingSlip "LS-X06"


  Scenario: 22 Rückgabe eines Koppelprodukts als zusätzliche Entnahme
    Given I set the fake date to "5.2.95"

    And I set the fake date to "6.2.95"

# Bestand auf 0 korrigieren
    Given I set StorageQuantity to zero for Product "B_EINKAUF-1" on StorageLocation "F1" with document "KORR-X22"
    Given I set StorageQuantity to zero for Product "B_EINKAUF-2" on StorageLocation "F1" with document "KORR-X22"
    Given I set StorageQuantity to zero for Product "EINK" on StorageLocation "F1" with document "KORR-X22"
#Auftrag anlegen und Bedarfe zubuchen
    Given I create a SalesOrder "auftrag" for Customer "RADSHOP" with Product "BM_BAUGRUPPE" and quantity "11"

    Given I post a receipt via ManualStockAdjustment for Product "B_EINKAUF-1" and quantity "22" on StorageLocation "F1" with document "ZUGANG-X22" and price "0"
    Given I post a receipt via ManualStockAdjustment for Product "B_EINKAUF-2" and quantity "11" on StorageLocation "F1" with document "ZUGANG-X22" and price "0"

# Fertigungsvorschlag anlegen und freigeben
    Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
    And I append rows
      | artikel      | netmge | mfreig | bisuch        |
      | BM_BAUGRUPPE | 11     | ja     | XKOPPELZUSMAT |
    And I press button "freig" to open a subeditor for "BA_freigeben"
    And I close the current editor
    And I switch the current editor to editor "fvor"
    And I save the current editor

# Materialentnahme Koppelprodukt als zusaetzliches Material
    Given I open an editor "Materialentnahme1" for tip command "Fbuchung" and arguments ""
    And I set fields
      | auftrag     | XKOPPELZUSMAT001           |
      | gmgevorschl | 2                          |
      | bem         | Entnahme Koppel als zusMat |
    And I press button "stllad"
    And I create a new row at the end of the table
    And I set field "elex" to "EINK" in row !lastRow
    And I set field "kompeig" to "Koppelprodukt" in row !lastRow
    And I set field "bumge" to "5" in row !lastRow
    And I save the current editor

    Given I open the infosystem "BESTAND"
    And I set fields
      | artikel    | EINK |
      | klplatz    | F1   |
      | verdichten | nein |
      | nullmge    | nein |
      | details    | nein |
    And I press start
    And I press button "taufzu" in row 1
    Then the table has 2 rows
    Then table has values
      | lemge | gebmge |
      | 5     |        |
      |       | 5      |
    And I close the current editor

    # Rückgabe des zusätzlich entnommenen Koppelprodukts
    Given I open an editor "Rückgabe1" for tip command "Fbuchung" and arguments ""
    And I set fields
      | auftrag     | XKOPPELZUSMAT001           |
      | gmgevorschl | -1                         |
      | bem         | Rückgabe Koppel als zusMat |
    And I press button "stllad"
    And I create a new row at the end of the table
    And I set field "elex" to "EINK" in row !lastRow
    And I set field "kompeig" to "Koppelprodukt" in row !lastRow
    And I set field "bumge" to "-2" in row !lastRow
    And I save the current editor

    Given I open the infosystem "BESTAND"
    And I set fields
      | artikel    | EINK |
      | klplatz    | F1   |
      | verdichten | nein |
      | nullmge    | nein |
      | details    | nein |
    And I press start
    And I press button "taufzu" in row 1
    Then the table has 2 rows
    Then table has values
      | lemge | gebmge |
      | 3     |        |
      |       | 3      |
    And I close the current editor

	# Materialrückgabe über Rückmeldung
    Given I open an editor "Rückgabe2" from table "(Workorder):(WorkOrders)" with command "RETURN" for record "XKOPPELZUSMAT001"
    And I set fields
      | sofort | ja        |
      | bem    | Rückgabe2 |
    Then the table has 2 rows
    And I modify table
      | mge | !row            |
      | -3  | artikel=='EINK' |
    And I save the current editor

    Given I open the infosystem "BESTAND"
    And I set fields
      | artikel    | EINK |
      | klplatz    | F1   |
      | verdichten | nein |
      | nullmge    | nein |
      | details    | nein |
    And I press start
    Then the table has 0 rows
    And I close the current editor

# Betriebsauftrag abschließen und Auftrag liefern
    Given I open an editor "Rückmeldung2" from table "(Workorder):(WorkOrders)" with command "DONE" for record "XKOPPELZUSMAT000"
    And I set fields
      | sofort  | ja  |
      | gut     | ja  |
      | manrest | ja  |
      | mgr     | 112 |
    And I save the current editor

    And I deliver the SalesOrder "auftrag" with PackingSlip "LS-MANX22"


  Scenario: 23 Artikel mit Einheiten und Artikel mit Gebindepflicht
    Given I set the fake date to "7.2.95"
    Given I open an editor "VERSCH-FAKTOR" from table "(Part):(Product)" with command "STORE" for record "VERSCH-FAKTOR"
    And I set fields
      | such     | VERSCH-FAKTOR               |
      | namebspr | Verschiedene Faktoren EK VK |
      | dispoa   | bedarfsbezogen              |
      | lief     | KETTLER                     |
      | efrist   | 2                           |
      | epr      | 10                          |
      | wgruppe  | 55                          |
      | erlgrp   | 66                          |
      | le       | kg                          |
      | gebvhe   | ja                          |
      | fvhe     | 1                           |
      | vhe      | Satz                        |
      | gebvpe   | ja                          |
      | fvpe     | 1                           |
      | vpe      | Satz                        |
      | fvhle    | 100                         |
      | fvple    | 100                         |
      | gebehe   | ja                          |
      | fehe     | 1                           |
      | ehe      | Satz                        |
      | gebepe   | ja                          |
      | fepe     | 1                           |
      | epe      | Satz                        |
      | fehle    | 100                         |
      | feple    | 100                         |
    And I save the current editor

  # Baugruppe mit Artikel VERSCH-FAKTOR
    Given I open an editor "BG-UFAKTOR" from table "(Part):(Product)" with command "STORE" for record "BG-UFAKTOR"
    And I set fields
      | such     | BG-UFAKTOR               |
      | namebspr | Komponente VERSCH-FAKTOR |
      | bsart    | Eigenfertigung           |
      | wgruppe  | 55                       |
      | erlgrp   | 66                       |
    And I delete all rows
    And I append rows
      | elex          | elanzahl | manbu       |
      | VERSCH-FAKTOR | 5        | ja          |
      | A AG1         | 1        | !dontChange |
    And I save the current editor


  Scenario: 24 Materialrückgabe mit geändertem Faktor, bisher Materialentnahme mit Faktor aus Lagerbestand
    Given I set the fake date to "8.2.95"
  # Bestand VERSCH-FAKTOR auf 0 korrigieren
    Given I set StorageQuantity to zero for Product "VERSCH-FAKTOR" on StorageLocation "F1" with document "KORR_FAKTOR"

  # Bedarf zubuchen in Satz (Zugang), mit Preis im Kopf angegeben 10€
    Given I open an editor "rechnungF" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
    And I set fields
      | lief   | KETTLER    |
      | vom    | .          |
      | ebeleg | Rechnung_F |
      | ueb    | ja         |
    And I append rows
      | artikel       | mge |
      | VERSCH-FAKTOR | 5   |
    And I respond with answer "ja" to the dialog with id "4841"
    And I save the current editor

    Given I open the infosystem "BESTAND"
    And I set fields
      | artikel    | VERSCH-FAKTOR |
      | verdichten | nein          |
      | nullmge    | nein          |
      | details    | nein          |
    And I press start
    And I press button "taufzu" in row 1
    Then the table has 2 rows
    Then table has values
      | lemge | leinheit | gebmge | geinheit | gebf | kopfzugvorg^id |
      | 500   | kg       |        |          |      | (0,0,0)        |
      |       |          | 5      | Satz     | 100  | !rechnungF^id  |
    And I close the current editor

  # Auftrag und FV anlegen und freigeben
    Given I create a SalesOrder "auftragF" for Customer "RADSHOP" with Product "BG-UFAKTOR" and quantity "100"

    Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
    And I append rows
      | artikel    | mge | mfreig | bisuch  |
      | BG-UFAKTOR | 100 | ja     | FAKTOR_ |
    And I set field "verw" in row 1 to "verw" from editor "auftragF" in row 1
    And I press button "freig" to open a subeditor for "FVfreigeben"
    And I close the current editor
    And I switch the current editor to editor "fvor"
    And I close the current editor

    Given I open an editor "Arbeitsschein1" from table "(Workorder):(WorkOrders)" with command "VIEW" for record "FAKTOR_001"
    And I close the current editor

  # Manuelle Entnahme 1 Satz und Bestand prüfen
    Given I open an editor "Materialentnahme1" for tip command "Fbuchung" and arguments ""
    And I set fields
      | auftrag | !Arbeitsschein1^nummer |
      | bem     | MatEnt1                |
    And I press button "stllad"
    And I set field "bumge" to "1" in row 1
    And I set field "bueinh" to "Satz" in row 1
    And I save the current editor

    Given I open an editor "Materialentnahme1" from table "(Workorder):(CompletionConfirmations)" with command "VIEW" for search criteria "$,,such=FAKTOR_001;bem=MatEnt1;manrm=ja;@richtung=rückwärts;@ablageart=abgelegt;@maxordtreffer=1"
    And I close the current editor

    Given I open the infosystem "BESTAND"
    And I set fields
      | artikel    | VERSCH-FAKTOR |
      | verdichten | nein          |
      | nullmge    | nein          |
      | details    | nein          |
    And I press start
    And I press button "taufzu" in row 1
    Then the table has 2 rows
    Then table has values
      | lemge | leinheit | gebmge | geinheit |
      | 400   | kg       |        |          |
      |       |          | 4      | Satz     |
    And I close the current editor

  # Rückgabe 1 Satz mit Faktor 50 buchen, LJ und Bestand prüfen
    Given I open an editor "Materialrückgabe1" for tip command "Fbuchung" and arguments ""
    And I set fields
      | auftrag | !Arbeitsschein1^nummer |
      | bem     | MatRück1               |
    And I press button "stllad"
    And I set field "bumge" to "-1" in row 1
    And I set field "bueinh" to "Satz" in row 1
    And I set field "zele" to "50" in row 1
    And I save the current editor

    Given I open the infosystem "BESTAND"
    And I set fields
      | artikel    | VERSCH-FAKTOR |
      | verdichten | nein          |
      | nullmge    | nein          |
      | details    | nein          |
    And I press start
    And I press button "taufzu" in row 1
    Then the table has 3 rows
    Then table has values
      | lemge | leinheit | gebmge | geinheit | gebf | kopfzugvorg^id |
      | 450   | kg       |        |          |      | (0,0,0)        |
      |       |          | 4      | Satz     | 100  | !rechnungF^id  |
      |       |          | 1      | Satz     | 50   | !rechnungF^id  |
    And I close the current editor

    Given I open the infosystem "LJ"
    And I set fields
      | artikel  | VERSCH-FAKTOR             |
      | beleg    | !Materialentnahme1^barmex |
      | richtung | rückwärts                 |
    And I press start
    Then the table has 2 rows
    Then table has values
      | art           | amge | mei  | leimei | rueckmge | restmge | !row |
      | VERSCH-FAKTOR | -1   | Satz | 50     | -50      | 0       | 1    |
      | VERSCH-FAKTOR | 1    | Satz | 100    | 50       | 50      | 2    |
    Then field "rueckorig^id" in row 1 has value equal to field "verweis^id" from editor "LJ" in row 2
    And I close the current editor

  # BA abschließen und Auftrag liefern
    Given I open an editor "Materialentnahme2" for tip command "Fbuchung" and arguments ""
    And I set fields
      | auftrag | !Arbeitsschein1^nummer |
      | bem     | MatEnt2                |
    And I press button "stllad"
    And I press button "mzsubm" to open a subeditor for "MZ" in row 1
    And I modify table
      | !row | zuomge | einh | faktor      |
      | 1    | 4      | Satz | !dontChange |
      | +2   | 1      | Satz | 50          |
    And I save the current editor
    And I switch the current editor to editor "Materialentnahme2"
    And I save the current editor

    Given I open an editor "Rückmeldung1" from table "(Workorder):(WorkOrders)" with command "DONE" for record "FAKTOR_001"
    And I set fields
      | gut    | ja |
      | sofort | ja |
    And I save the current editor

    Given I open the infosystem "BESTAND"
    And I set fields
      | artikel    | VERSCH-FAKTOR |
      | verdichten | nein          |
      | nullmge    | nein          |
      | details    | nein          |
    And I press start
    Then the table has 0 rows
    And I close the current editor

    Given I open the infosystem "LJ"
    And I set fields
      | artikel  | VERSCH-FAKTOR             |
      | beleg    | !Materialentnahme1^barmex |
      | richtung | rückwärts                 |
    And I press start
    Then the table has 4 rows
    Then table has values
      | art           | amge | mei  | leimei | rueckmge | restmge |
      | VERSCH-FAKTOR | 1    | Satz | 50     | 0        | 50      |
      | VERSCH-FAKTOR | 4    | Satz | 100    | 0        | 400     |
      | VERSCH-FAKTOR | -1   | Satz | 50     | -50      | 0       |
      | VERSCH-FAKTOR | 1    | Satz | 100    | 50       | 50      |
    And I close the current editor

    And I deliver the SalesOrder "auftragF" with PackingSlip "LS-FAKTOR"


  Scenario: 25 Materialrückgaben mit geändertem Faktor, bisher zwei Materialentnahmen mit verschiedenen Faktoren aus Lagerbestand
    Given I set the fake date to "9.2.95"
  # Bestand VERSCH-FAKTOR auf 0 korrigieren
    Given I set StorageQuantity to zero for Product "VERSCH-FAKTOR" on StorageLocation "F1" with document "KORR_FAKT2"

  # Bedarf einkaufen in Satz (Zugang), 4 Satz Faktor 100, 1,25 Satz Faktor 80
    Given I open an editor "rechnungF2" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
    And I set fields
      | lief   | KETTLER     |
      | vom    | .           |
      | ebeleg | Rechnung_F2 |
      | ueb    | ja          |
    And I append rows
      | artikel       | mge |
      | VERSCH-FAKTOR | 5   |
    And I press button "mzsubm" to open a subeditor for "MZ" in row 1
    And I modify table
      | !row | zuomge | faktor |
      | 1    | 4      | 100    |
      | +2   | 2      | 80     |
    And I save the current editor
    And I switch the current editor to editor "rechnungF2"
    And I respond with answer "ja" to the dialog with id "4841"
    And I save the current editor

    Given I open the infosystem "BESTAND"
    And I set fields
      | artikel    | VERSCH-FAKTOR |
      | verdichten | nein          |
      | nullmge    | nein          |
      | details    | nein          |
    And I press start
    And I press button "taufzu" in row 1
    Then the table has 3 rows
    Then table has values
      | lemge | leinheit | gebmge | geinheit | gebf | kopfzugvorg^id |
      | 560   | kg       |        |          |      | (0,0,0)        |
      |       |          | 4      | Satz     | 100  | !rechnungF2^id |
      |       |          | 2      | Satz     | 80   | !rechnungF2^id |
    And I close the current editor

  # Auftrag und FV anlegen und freigeben
    Given I create a SalesOrder "auftragF2" for Customer "RADSHOP" with Product "BG-UFAKTOR" and quantity "100"

    Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
    And I append rows
      | artikel    | mge | mfreig | bisuch   |
      | BG-UFAKTOR | 100 | ja     | FAKTOR2_ |
    And I press button "freig" to open a subeditor for "FVfreigeben"
    And I close the current editor
    And I switch the current editor to editor "fvor"
    And I close the current editor

    Given I open an editor "Arbeitsschein1" from table "(Workorder):(WorkOrders)" with command "VIEW" for record "FAKTOR2_001"
    And I close the current editor

  # Manuelle Entnahme1: 1 Satz mit Faktor 80, Entnahme2: 1 Satz mit Faktor 100 und Bestand prüfen
    Given I open an editor "Materialentnahme1" for tip command "Fbuchung" and arguments ""
    And I set fields
      | auftrag | !Arbeitsschein1^nummer |
      | bem     | Mat2Ent1               |
    And I press button "stllad"
    And I modify table
      | bumge | bueinh | zele | !row |
      | 1     | Satz   | 80   | 1    |
    And I save the current editor

    Given I open an editor "Materialentnahme1" from table "(Workorder):(CompletionConfirmations)" with command "VIEW" for search criteria "$,,such=FAKTOR2_001;bem=Mat2Ent1;manrm=ja;@richtung=rückwärts;@ablageart=abgelegt;@maxordtreffer=1"
    And I close the current editor

    Given I open the infosystem "BESTAND"
    And I set fields
      | artikel    | VERSCH-FAKTOR |
      | verdichten | nein          |
      | nullmge    | nein          |
      | details    | nein          |
    And I press start
    And I press button "taufzu" in row 1
    Then the table has 3 rows
    Then table has values
      | lemge | leinheit | gebmge | geinheit | gebf | kopfzugvorg^id |
      | 480   | kg       |        |          |      | (0,0,0)        |
      |       |          | 4      | Satz     | 100  | !rechnungF2^id |
      |       |          | 1      | Satz     | 80   | !rechnungF2^id |
    And I close the current editor

  # Rückgabe1: 1 Satz mit Faktor 30 buchen
    Given I open an editor "Materialrückgabe1" for tip command "Fbuchung" and arguments ""
    And I set fields
      | auftrag | !Arbeitsschein1^nummer |
      | bem     | Mat2Rück1              |
    And I press button "stllad"
    And I modify table
      | bumge | bueinh | zele | !row |
      | -1    | Satz   | 30   | 1    |
    And I save the current editor

    And I set the fake date to "10.2.95"
    And I wait 1 time units to move the time forward
    Given I open an editor "Materialentnahme2" for tip command "Fbuchung" and arguments ""
    And I set fields
      | auftrag | !Arbeitsschein1^nummer |
      | bem     | Mat2Ent2               |
    And I press button "stllad"
    And I modify table
      | bumge | bueinh | zele        | !row |
      | 1     | Satz   | !dontChange | 1    |
    And I save the current editor

    Given I open an editor "Materialentnahme2" from table "(Workorder):(CompletionConfirmations)" with command "VIEW" for search criteria "$,,such=FAKTOR2_001;bem=Mat2Ent2;manrm=ja;@richtung=rückwärts;@ablageart=abgelegt;@maxordtreffer=1"
    And I close the current editor

    Given I open the infosystem "BESTAND"
    And I set fields
      | artikel    | VERSCH-FAKTOR |
      | verdichten | nein          |
      | nullmge    | nein          |
      | details    | nein          |
    And I press start
    And I press button "taufzu" in row 1
    Then the table has 4 rows
    Then table has values
      | lemge | leinheit | gebmge | geinheit | gebf | kopfzugvorg^id |
      | 410   | kg       |        |          |      | (0,0,0)        |
      |       |          | 3      | Satz     | 100  | !rechnungF2^id |
      |       |          | 1      | Satz     | 80   | !rechnungF2^id |
      |       |          | 1      | Satz     | 30   | !rechnungF2^id |
    And I close the current editor

    # Rückgabe2: 1 Satz mit Fakor 90, LJ und Bestand prüfen
    And I set the fake date to "11.2.95"
    And I wait 1 time units to move the time forward
    Given I open an editor "Materialrückgabe2" for tip command "Fbuchung" and arguments ""
    And I set fields
      | auftrag | !Arbeitsschein1^nummer |
      | bem     | Mat2Rück2              |
    And I press button "stllad"
    And I modify table
      | bumge | bueinh | zele | !row |
      | -1    | Satz   | 90   | 1    |
    And I save the current editor

    Given I open the infosystem "BESTAND"
    And I set fields
      | artikel    | VERSCH-FAKTOR |
      | verdichten | nein          |
      | nullmge    | nein          |
      | details    | nein          |
    And I press start
    And I press button "taufzu" in row 1
    Then the table has 5 rows
    Then table has values
      | lemge | leinheit | gebmge | geinheit | gebf | kopfzugvorg^id |
      | 500   | kg       |        |          |      | (0,0,0)        |
      |       |          | 3      | Satz     | 100  | !rechnungF2^id |
      |       |          | 1      | Satz     | 80   | !rechnungF2^id |
      |       |          | 1      | Satz     | 30   | !rechnungF2^id |
      |       |          | 1      | Satz     | 90   | !rechnungF2^id |
    And I close the current editor

    Given I open the infosystem "LJ"
    And I set fields
      | artikel  | VERSCH-FAKTOR             |
      | beleg    | !Materialentnahme1^barmex |
      | richtung | rückwärts                 |
    And I press start
    Then the table has 4 rows
    Then table has values
      | art           | amge | mei  | leimei | rueckmge | restmge | !row |
      | VERSCH-FAKTOR | -1   | Satz | 90     | -90      | 0       | 1    |
      | VERSCH-FAKTOR | 1    | Satz | 100    | 90       | 10      | 2    |
      | VERSCH-FAKTOR | -1   | Satz | 30     | -30      | 0       | 3    |
      | VERSCH-FAKTOR | 1    | Satz | 80     | 30       | 50      | 4    |
    Then field "rueckorig^id" in row 1 has value equal to field "verweis^id" from editor "LJ" in row 2
    Then field "rueckorig^id" in row 3 has value equal to field "verweis^id" from editor "LJ" in row 4
    And I close the current editor

  # BA abschließen und Auftrag liefern
    Given I open an editor "Materialentnahme3" for tip command "Fbuchung" and arguments ""
    And I set fields
      | auftrag | !Arbeitsschein1^nummer |
      | bem     | Mat2Ent3               |
    And I press button "stllad"
    And I press button "mzsubm" to open a subeditor for "MZ" in row 1
    And I modify table
      | !row | zuomge | einh | faktor      |
      | 1    | 3      | Satz | !dontChange |
      | +2   | 0.25   | Satz | 80          |
      | +3   | 1      | Satz | 30          |
      | +4   | 1      | Satz | 90          |
    And I save the current editor
    And I switch the current editor to editor "Materialentnahme3"
    And I save the current editor

    Given I open an editor "Rückmeldung1" from table "(Workorder):(WorkOrders)" with command "DONE" for record "FAKTOR2_001"
    And I set fields
      | gut    | ja |
      | sofort | ja |
    And I save the current editor

    Given I open the infosystem "BESTAND"
    And I set fields
      | artikel    | VERSCH-FAKTOR |
      | verdichten | nein          |
      | nullmge    | nein          |
      | details    | nein          |
    And I press start
    And I press button "taufzu" in row 1
    Then the table has 2 rows
    Then table has values
      | lemge | leinheit | gebmge | geinheit | gebf | kopfzugvorg^id |
      | 60    | kg       |        |          |      | (0,0,0)        |
      |       |          | 0.75   | Satz     | 80   | !rechnungF2^id |
    And I close the current editor

    Given I open the infosystem "LJ"
    And I set fields
      | artikel  | VERSCH-FAKTOR             |
      | beleg    | !Materialentnahme1^barmex |
      | richtung | rückwärts                 |
    And I press start
    Then the table has 8 rows
    Then table has values
      | art           | amge | mei  | leimei | rueckmge | restmge | !row |
      | VERSCH-FAKTOR | 1    | Satz | 90     | 0        | 90      | 1    |
      | VERSCH-FAKTOR | 1    | Satz | 30     | 0        | 30      | 2    |
      | VERSCH-FAKTOR | 0.25 | Satz | 80     | 0        | 20      | 3    |
      | VERSCH-FAKTOR | 3    | Satz | 100    | 0        | 300     | 4    |
    And I close the current editor

    And I deliver the SalesOrder "auftragF2" with PackingSlip "LS-FAKT2"


  Scenario: A01 Teil-Rückgabe auf letzten AS eines abgelegten FV, bisher Materialentnahme gebucht, Materil in AFL manbu=nein
    Given I set the fake date to "12.2.95"
# Auftrag anlegen und Material einkaufen
    Given I create a SalesOrder "auftrag" for Customer "RADSHOP" with Product "BAUGRUPPE" and quantity "10"
    Given I open an editor "Rechnung" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
    And I set fields
      | lief   | KETTLER |
      | vom    | .       |
      | ueb    | ja      |
      | fakt   | ja      |
      | ebeleg | R-A01   |
    And I append rows
      | artikel   | mge |
      | EINKAUF-1 | 20  |
      | EINKAUF-2 | 10  |
    And I set field "verw" in row 1 to "verw" from editor "auftrag" in row 1
    And I set field "verw" in row 2 to "verw" from editor "auftrag" in row 1
    And I respond with answer "ja" to the dialog with id "4841"
    And I save the current editor

# Fertigungsvorschlag anlegen und freigeben
    Given I open an editor "fvor" from table "04:11" with command "NEW" for record ""
    And I append rows
      | artikel   | mge | mfreig | bisuch   |
      | BAUGRUPPE | 10  | ja     | RETROBU_ |
    And I set field "verw" in row !lastRow to "verw" from editor "auftrag" in row 1
    And I press button "freig" to open a subeditor for "BA_freigeben"
    And I close the current editor
    And I switch the current editor to editor "fvor"
    And I save the current editor

# Materialentnahme und Rückmeldung auf AS
    Given I open an editor "Materialentnahme1" for tip command "Fbuchung" and arguments ""
    And I set field "auftrag" to "$,,such=RETROBU_001;@richtung=rückwärts;@maxtreffer=1"
    And I set field "autorment" to "ja"
    And I press button "stlvblad"
    And I save the current editor

    Given I open an editor "Rückmeldung1" from table "(Workorder):(WorkOrders)" with command "DONE" for record "RETROBU_001"
    And I set fields
      | sofort | ja |
      | gut    | ja |
      | bzeit  | 2  |
      | mzeit  | 2  |
    And I save the current editor

# Bewertungen
    Given I open an editor "Materialentnahme1" from table "(Workorder):(CompletionConfirmations)" with command "VIEW" for search criteria "$,,such=RETROBU_001;manrm=ja;@richtung=rückwärts;@maxtreffer=1;@ablageart=abgelegt"
    And I close the current editor

    Given I open an editor "Bewertung1" from table "(Valuation):(Valuation)" with command "VIEW" for search criteria "$,,artikel=EINKAUF-1;detursache=Materialentnahme Fertigung;@richtung=rückwärts;@maxtreffer=1"
    Then field "bewvorgang^vorgang^id" has value equal to field "id" from editor "Materialentnahme1"
    And I close the current editor

# Rückbau auf abgelegten FV
    Given I open an editor "Rückgabe1" via ID from editor "Rückmeldung1" from field "id" in row 0 for table "(Workorder):(CompletionConfirmations)" with command "COPY"
    And I modify table
      | !row                 | mge |
      | artikel=="EINKAUF-1" | -4  |
      | artikel=="EINKAUF-2" | -2  |
    And I save the current editor

# Rückmeldungen und Rückbau prüfen, Bewertung hat Nachfolger
    And I switch the current editor to editor "Rückmeldung1" with command "VIEW"
    Then the table has 1 rows
    Then table has values
      | restmge | rueckmge | limgev | limgen |
      | 10      | 0        | 0      | 10     |
    And I close the current editor

    Given I open an editor "Manbu_pruef" from table "(Workorder):(CompletionConfirmations)" with command "VIEW" for search criteria "$,,such=RETROBU_001;manrm=ja;@richtung=rückwärts;@maxtreffer=1;@ablageart=abgelegt"
    Then table has values
      | artikel   | restmge | rueckmge | limgev | limgen |
      | BAUGRUPPE | 0       | 0        | 0      | 0      |
      | EINKAUF-2 | 8       | 2        | 10     | 0      |
      | EINKAUF-1 | 16      | 4        | 20     | 0      |
    And I close the current editor

    And I switch the current editor to editor "Rückgabe1" with command "VIEW"
    Then table has values
      | artikel   | restmge | rueckmge | limgev | limgen |
      | BAUGRUPPE | 0       | 0        | 10     | 10     |
      | EINKAUF-1 | 0       | -4       | 20     | 16     |
      | EINKAUF-2 | 0       | -2       | 10     | 8      |
    And I close the current editor

    And I switch the current editor to editor "Bewertung1" with command "VIEW"
    Then field "nachfolger" is not empty
    And I close the current editor

    Given I open an editor "Bewertung_nachf" via ID from editor "Bewertung1" from field "nachfolger" in row 0 for table "(Valuation):(Valuation)" with command "VIEW"
    Then field "bewvorgang^vorgang^id" has value equal to field "id" from editor "Materialentnahme1"
    And I close the current editor

# Lagerjournal prüfen
    Given I open the infosystem "LJ"
    And I set field "beleg" to "barmex" from editor "Rückmeldung1"
    And I set field "richtung" to "rückwärts"
    And I press start
    Then table has values
      | art       | zmge | amge | rueckmge | restmge |
      | EINKAUF-1 |      | -4   | -4       | 0       |
      | EINKAUF-2 |      | -2   | -2       | 0       |
      | BAUGRUPPE | 10   |      | 0        | 10      |
      | EINKAUF-1 |      | 20   | 4        | 16      |
      | EINKAUF-2 |      | 10   | 2        | 8       |
    Then field "rueckorig^id" in row 1 has value equal to field "verweis^id" from editor "LJ" in row 4
    Then field "rueckorig^id" in row 2 has value equal to field "verweis^id" from editor "LJ" in row 5
    And I close the current editor

# Auftrag abschließen
    And I deliver the SalesOrder "auftrag" with PackingSlip "LS-A01"


  Scenario: A02 Gesamt-Rückgabe auf letzten AS eines abgelegten FV, bisher Materialentnahme gebucht, Material in AFL manbu=nein
    Given I set the fake date to "13.2.95"
# Auftrag anlegen und Material einkaufen
    Given I create a SalesOrder "auftrag" for Customer "RADSHOP" with Product "M_BAUGRUPPE" and quantity "10"
    Given I open an editor "Rechnung" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
    And I set fields
      | lief   | KETTLER |
      | vom    | .       |
      | ueb    | ja      |
      | fakt   | ja      |
      | ebeleg | R-A01   |
    And I append rows
      | artikel   | mge |
      | EINKAUF-1 | 20  |
      | EINKAUF-2 | 10  |
    And I set field "verw" in row 1 to "verw" from editor "auftrag" in row 1
    And I set field "verw" in row 2 to "verw" from editor "auftrag" in row 1
    And I respond with answer "ja" to the dialog with id "4841"
    And I save the current editor

# Fertigungsvorschlag anlegen, freigeben und Rückmeldung buchen
    Given I open an editor "fvor" from table "04:11" with command "NEW" for record ""
    And I append rows
      | artikel     | mge | mfreig | bisuch   |
      | M_BAUGRUPPE | 10  | ja     | ALLESBA_ |
    And I set field "verw" in row !lastRow to "verw" from editor "auftrag" in row 1
    And I press button "freig" to open a subeditor for "BA_freigeben"
    And I close the current editor
    And I switch the current editor to editor "fvor"
    And I save the current editor

# Materialentnahme und Rückmeldung auf AS
    Given I open an editor "Materialentnahme1" for tip command "Fbuchung" and arguments ""
    And I set field "auftrag" to "$,,such=ALLESBA_001;@richtung=rückwärts;@maxtreffer=1"
    And I press button "stlvblad"
    And I save the current editor

    Given I open an editor "Rückmeldung1" from table "(Workorder):(WorkOrders)" with command "DONE" for record "ALLESBA_001"
    And I set fields
      | sofort | ja |
      | gut    | ja |
      | bzeit  | 2  |
      | mzeit  | 2  |
    And I save the current editor

# Bewertungen
    Given I open an editor "Materialentnahme1" from table "(Workorder):(CompletionConfirmations)" with command "VIEW" for search criteria "$,,such=ALLESBA_001;manrm=ja;@richtung=rückwärts;@maxtreffer=1;@ablageart=abgelegt"
    And I close the current editor

    Given I open an editor "Bewertung1" from table "(Valuation):(Valuation)" with command "VIEW" for search criteria "$,,artikel=EINKAUF-1;detursache=Materialentnahme Fertigung;@richtung=rückwärts;@maxtreffer=1"
    Then field "bewvorgang^vorgang^id" has value equal to field "id" from editor "Materialentnahme1"
    And I close the current editor

# Rückbau auf abgelegten FV
    Given I open an editor "Rückgabe1" via ID from editor "Rückmeldung1" from field "id" in row 0 for table "(Workorder):(CompletionConfirmations)" with command "COPY"
    And setting field "mge" to "-30" in row 2 throws the exception "1395"
    And I modify table
      | !row                 | mge |
      | artikel=="EINKAUF-1" | -20 |
      | artikel=="EINKAUF-2" | -10 |
    And I save the current editor

# Rückmeldungen und Rückbau prüfen, Bewertung erhält Nachfolger
    And I switch the current editor to editor "Rückmeldung1" with command "VIEW"
    Then the table has 1 rows
    Then table has values
      | restmge | rueckmge | limgev | limgen |
      | 10      | 0        | 0      | 10     |
    And I close the current editor

    Given I open an editor "Manbu_pruef" from table "(Workorder):(CompletionConfirmations)" with command "VIEW" for search criteria "$,,such=ALLESBA_001;manrm=ja;@richtung=rückwärts;@maxtreffer=1;@ablageart=abgelegt"
    Then table has values
      | artikel     | restmge | rueckmge | limgev | limgen | !row |
      | M_BAUGRUPPE | 0       | 0        | 0      | 0      | 1    |
      | EINKAUF-2   | 0       | 10       | 10     | 0      | 2    |
      | EINKAUF-1   | 0       | 20       | 20     | 0      | 3    |
    And I close the current editor

    And I switch the current editor to editor "Rückgabe1" with command "VIEW"
    Then table has values
      | artikel     | restmge | rueckmge | limgev | limgen |
      | M_BAUGRUPPE | 0       | 0        | 10     | 10     |
      | EINKAUF-1   | 0       | -20      | 20     | 0      |
      | EINKAUF-2   | 0       | -10      | 10     | 0      |
    And I close the current editor

    And I switch the current editor to editor "Bewertung1" with command "VIEW"
    Then field "nachfolger" is not empty
    And I close the current editor

    Given I open an editor "Bewertung_nachf" via ID from editor "Bewertung1" from field "nachfolger" in row 0 for table "(Valuation):(Valuation)" with command "VIEW"
    Then field "bewvorgang^vorgang^id" has value equal to field "id" from editor "Materialentnahme1"
    And I close the current editor

# Lagerjournal prüfen
    Given I open the infosystem "LJ"
    And I set field "beleg" to "barmex" from editor "Rückmeldung1"
    And I set field "richtung" to "rückwärts"
    And I press start
    Then table has values
      | art         | zmge | amge | rueckmge | restmge |
      | EINKAUF-1   |      | -20  | -20      | 0       |
      | EINKAUF-2   |      | -10  | -10      | 0       |
      | M_BAUGRUPPE | 10   |      | 0        | 10      |
      | EINKAUF-1   |      | 20   | 20       | 0       |
      | EINKAUF-2   |      | 10   | 10       | 0       |
    Then field "rueckorig^id" in row 1 has value equal to field "verweis^id" from editor "LJ" in row 4
    Then field "rueckorig^id" in row 2 has value equal to field "verweis^id" from editor "LJ" in row 5
    And I close the current editor

# Auftrag liefern
    And I deliver the SalesOrder "auftrag" with PackingSlip "LS-A02"


  Scenario: A03 Teil-Rückgabe auf letzten AS eines abgelegten FV, bisher Materialeentnhame gebucht, Material in AFL manbu=ja
    Given I set the fake date to "14.2.95"
# Auftrag anlegen und Bedarfe einkaufen
    Given I create a SalesOrder "auftrag" for Customer "RADSHOP" with Product "M_BAUGRUPPE" and quantity "10"
    Given I open an editor "Rechnung" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
    And I set fields
      | lief   | KETTLER |
      | vom    | .       |
      | ueb    | ja      |
      | fakt   | ja      |
      | ebeleg | R-A03   |
    And I append rows
      | artikel   | mge |
      | EINKAUF-1 | 20  |
      | EINKAUF-2 | 10  |
    And I set field "verw" in row 1 to "verw" from editor "auftrag" in row 1
    And I set field "verw" in row 2 to "verw" from editor "auftrag" in row 1
    And I respond with answer "ja" to the dialog with id "4841"
    And I save the current editor

# Fertigungsvorschlag anlegen, freigeben und Rückmeldung buchen
    Given I open an editor "fvor" from table "04:11" with command "NEW" for record ""
    And I append rows
      | artikel     | mge | mfreig | bisuch    |
      | M_BAUGRUPPE | 10  | ja     | MANUELLE_ |
    And I set field "verw" in row !lastRow to "verw" from editor "auftrag" in row 1
    And I press button "freig" to open a subeditor for "BA_freigeben"
    And I close the current editor
    And I switch the current editor to editor "fvor"
    And I save the current editor

# Materialentnahme und Rückmeldung auf AS
    Given I open an editor "Materialentnahme1" for tip command "Fbuchung" and arguments ""
    And I set field "auftrag" to "$,,such=MANUELLE_001;@richtung=rückwärts;@maxtreffer=1"
    And I press button "stlvblad"
    And I save the current editor

    Given I open an editor "Rückmeldung1" from table "(Workorder):(WorkOrders)" with command "DONE" for record "MANUELLE_001"
    And I set fields
      | sofort | ja |
      | gut    | ja |
      | bzeit  | 2  |
      | mzeit  | 2  |
    And I save the current editor

# Bewertungen
    Given I open an editor "Materialentnahme1" from table "(Workorder):(CompletionConfirmations)" with command "VIEW" for search criteria "$,,such=MANUELLE_001;manrm=ja;@richtung=rückwärts;@maxtreffer=1;@ablageart=abgelegt"
    And I close the current editor

    Given I open an editor "Bewertung1" from table "(Valuation):(Valuation)" with command "VIEW" for search criteria "$,,artikel=EINKAUF-1;detursache=Materialentnahme Fertigung;@richtung=rückwärts;@maxtreffer=1"
    Then field "bewvorgang^vorgang^id" has value equal to field "id" from editor "Materialentnahme1"
    And I close the current editor

# Rückbau auf abgelegten FV
    Given I open an editor "Rückgabe1" via ID from editor "Rückmeldung1" from field "id" in row 0 for table "(Workorder):(CompletionConfirmations)" with command "COPY"
    And I modify table
      | !row                 | mge |
      | artikel=="EINKAUF-1" | -4  |
      | artikel=="EINKAUF-2" | -2  |
    And I save the current editor

# Rückmeldungen und Rückbau prüfen, Bewertung hat Nachfolger
    And I switch the current editor to editor "Rückmeldung1" with command "VIEW"
    Then table has values
      | restmge | rueckmge | limgev | limgen |
      | 10      | 0        | 0      | 10     |
    And I close the current editor

    Given I open an editor "Manbu_pruef" from table "(Workorder):(CompletionConfirmations)" with command "VIEW" for record "$,,such=MANUELLE_001;manrm=ja;@richtung=rückwärts;@ablageart=abgelegt;@maxtreffer=1"
    Then table has values
      | artikel     | restmge | rueckmge | limgev | limgen |
      | M_BAUGRUPPE | 0       | 0        | 0      | 0      |
      | EINKAUF-2   | 8       | 2        | 10     | 0      |
      | EINKAUF-1   | 16      | 4        | 20     | 0      |
    And I close the current editor

    And I switch the current editor to editor "Rückgabe1" with command "VIEW"
    Then table has values
      | artikel     | restmge | rueckmge | limgev | limgen |
      | M_BAUGRUPPE | 0       | 0        | 10     | 10     |
      | EINKAUF-1   | 0       | -4       | 20     | 16     |
      | EINKAUF-2   | 0       | -2       | 10     | 8      |
    And I close the current editor

    And I switch the current editor to editor "Bewertung1" with command "VIEW"
    Then field "nachfolger" is not empty
    And I close the current editor

    Given I open an editor "Bewertung_nachf" via ID from editor "Bewertung1" from field "nachfolger" in row 0 for table "(Valuation):(Valuation)" with command "VIEW"
    Then field "bewvorgang^vorgang^id" has value equal to field "id" from editor "Materialentnahme1"
    And I close the current editor

# Lagerjournal prüfen
    Given I open the infosystem "LJ"
    And I set field "beleg" to "barmex" from editor "Rückmeldung1"
    And I set field "richtung" to "rückwärts"
    And I press start
    Then table has values
      | art         | zmge | amge | rueckmge | restmge |
      | EINKAUF-1   |      | -4   | -4       | 0       |
      | EINKAUF-2   |      | -2   | -2       | 0       |
      | M_BAUGRUPPE | 10   |      | 0        | 10      |
      | EINKAUF-1   |      | 20   | 4        | 16      |
      | EINKAUF-2   |      | 10   | 2        | 8       |
    Then field "rueckorig^id" in row 1 has value equal to field "verweis^id" from editor "LJ" in row 4
    Then field "rueckorig^id" in row 2 has value equal to field "verweis^id" from editor "LJ" in row 5
    And I close the current editor

# Auftrag abschließen
    And I deliver the SalesOrder "auftrag" with PackingSlip "LS-A03"


  Scenario: A04 Teil-Rückgabe mit Chargen auf letzten AS eines abgelegten FV, bisher Materialentnahme gebucht, EntnahmeMZ mit Chargen vor Freigabe FV angelegt
    Given I set the fake date to "15.2.95"
# Bestand auf 0 korrigieren
    Given I set StorageQuantity to zero for Product "EINKAUF-1" on StorageLocation "F1" with document "SCEN_A04"

# Charge anlegen
    Given I create a Lot "CH_1234" for Product "EINKAUF-1"
    Given I create a Lot "CH_4567" for Product "EINKAUF-1"

  # Bestände korrigieren
    Given I set StorageQuantity to zero for Product "EINKAUF-1" on StorageLocation "F1"
    Given I set StorageQuantity to zero for Product "EINKAUF-1" on StorageLocation "F2"
    Given I set StorageQuantity to zero for Product "EINKAUF-2" on StorageLocation "F1"
    Given I set StorageQuantity to zero for Product "EINKAUF-2" on StorageLocation "F2"
# Auftrag anlegen und Material einkaufen
    Given I create a SalesOrder "auftrag" for Customer "RADSHOP" with Product "M_BAUGRUPPE" and quantity "10"

    Given I open an editor "Rechnung" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
    And I set fields
      | lief   | KETTLER |
      | vom    | .       |
      | ueb    | ja      |
      | fakt   | ja      |
      | ebeleg | R-A04   |
    And I append rows
      | artikel   | mge | charge      |
      | EINKAUF-1 | 10  | !CH_1234^id |
      | EINKAUF-1 | 10  | !CH_4567^id |
      | EINKAUF-2 | 10  |             |
    And I set field "verw" in row 1 to "verw" from editor "auftrag" in row 1
    And I set field "verw" in row 2 to "verw" from editor "auftrag" in row 1
    And I set field "verw" in row 3 to "verw" from editor "auftrag" in row 1
    And I respond with answer "ja" to the dialog with id "4841"
    And I save the current editor

# Fertigungsvorschlag anlegen und freigeben
    Given I open an editor "fvor" from table "04:11" with command "NEW" for record ""
    And I append rows
      | artikel     | mge | mfreig |
      | M_BAUGRUPPE | 10  | ja     |
    And I set field "verw" in row !lastRow to "verw" from editor "auftrag" in row 1
    And I press button "mzabsm" to open a subeditor for "EntnahmeMZ" in row !lastRow
    And I modify table
      | !row | zuomge | charge      |
      | +1   | 10     | !CH_1234^id |
      | +2   | 10     | !CH_4567^id |
    And I save the current editor
    And I switch the current editor to editor "fvor"
    And I set field "bisuch" to "ACHARGE_" in row !lastRow
    And I press button "freig" to open a subeditor for "BA_freigeben"
    And I close the current editor
    And I switch the current editor to editor "fvor"
    And I save the current editor

# Materialentnahme und Rückmeldung auf AS
    Given I open an editor "Materialentnahme1" for tip command "Fbuchung" and arguments ""
    And I set field "auftrag" to "$,,such=ACHARGE_001;@richtung=rückwärts;@maxtreffer=1"
    And I press button "stlvblad"
    And I save the current editor

    Given I open an editor "Materialentnahme1" from table "(Workorder):(CompletionConfirmations)" with command "VIEW" for search criteria "$,,such=ACHARGE_001;manrm=ja;@richtung=rückwärts;@maxtreffer=1;@ablageart=abgelegt"
    And I close the current editor

    And I set the fake date to "16.2.95"
    And I wait 1 time units to move the time forward
    Given I open an editor "Rückmeldung1" from table "(Workorder):(WorkOrders)" with command "DONE" for record "ACHARGE_001"
    And I set fields
      | sofort | ja |
      | gut    | ja |
      | bzeit  | 2  |
      | mzeit  | 2  |
    And I save the current editor

# Bewertungen
    Given I open an editor "Bewertung1" from table "(Valuation):(Valuation)" with command "VIEW" for search criteria "$,,artikel=EINKAUF-1;detursache=Materialentnahme Fertigung;@richtung=rückwärts;@maxtreffer=1"
    Then field "bewvorgang^vorgang^id" has value equal to field "id" from editor "Materialentnahme1"
    And I close the current editor

# Rückbau auf abgelegten FV und Bestand prüfen
    Given I open an editor "Rückgabe1" via ID from editor "Materialentnahme1" from field "id" in row 0 for table "(Workorder):(CompletionConfirmations)" with command "COPY"
    And I modify table
      | !row                 | mge | charge      |
      | artikel=="EINKAUF-1" | -10 | !CH_4567^id |
    And I save the current editor

# Rückbau auf abgelegten FV und Bestand prüfen
    Given I open an editor "Rückgabe2" via ID from editor "Materialentnahme1" from field "id" in row 0 for table "(Workorder):(CompletionConfirmations)" with command "COPY"
    And I modify table
      | !row                 | mge | charge      |
      | artikel=="EINKAUF-1" | -2  | !CH_1234^id |
    And I save the current editor

    Given I open the infosystem "BESTAND"
    And I set fields
      | artikel    | EINKAUF-1 |
      | klplatz    | F1        |
      | verdichten | nein      |
      | nullmge    | nein      |
      | details    | nein      |
    And I press start
    And I press button "taufzu" in row 1
    Then the table has 3 rows
    Then table has values
      | lemge | gebmge | charge^such | kopfzugvorg^id |
      | 12    |        |             | (0,0,0)        |
      |       | 10     | CH_4567     | !Rechnung^id   |
      |       | 2      | CH_1234     | !Rechnung^id   |
    And I close the current editor

# Rückmeldungen und Rückbau prüfen, Bestand prüfen
    And I switch the current editor to editor "Rückmeldung1" with command "VIEW"
    Then the table has 1 rows
    Then table has values
      | restmge | rueckmge | limgev | limgen |
      | 10      | 0        | 0      | 10     |
    And I close the current editor

    And I switch the current editor to editor "Materialentnahme1" with command "VIEW"
    Then table has values
      | artikel     | restmge | rueckmge | limgev | limgen |
      | M_BAUGRUPPE | 0       | 0        | 0      | 0      |
      | EINKAUF-2   | 10      | 0        | 10     | 0      |
      | EINKAUF-1   | 8       | 12       | 20     | 0      |
    And I close the current editor

    And I switch the current editor to editor "Rückgabe1" with command "VIEW"
    Then table has values
      | artikel     | restmge | rueckmge | limgev | limgen |
      | M_BAUGRUPPE | 0       | 0        | 10     | 10     |
      | EINKAUF-1   | 0       | -10      | 20     | 10     |
      | EINKAUF-2   | 0       | 0        | 10     | 10     |
    And I close the current editor

    And I switch the current editor to editor "Rückgabe2" with command "VIEW"
    Then table has values
      | artikel     | restmge | rueckmge | limgev | limgen |
      | M_BAUGRUPPE | 0       | 0        | 10     | 10     |
      | EINKAUF-1   | 0       | -2       | 10     | 8      |
      | EINKAUF-2   | 0       | 0        | 10     | 10     |
    And I close the current editor

    Given I open the infosystem "BESTAND"
    And I set fields
      | artikel    | EINKAUF-1 |
      | klplatz    | F1        |
      | verdichten | nein      |
      | nullmge    | nein      |
      | details    | nein      |
    And I press start
    And I press button "taufzu" in row 1
    Then the table has 3 rows
    Then table has values
      | lemge | gebmge | charge^such |
      | 12    |        |             |
      |       | 10     | CH_4567     |
      |       | 2      | CH_1234     |
    And I set fields
      | artikel    | EINKAUF-2 |
      | klplatz    | F1        |
      | verdichten | nein      |
      | nullmge    | nein      |
      | details    | nein      |
    And I press start
    Then the table has 0 rows
    And I close the current editor

# Bewertung hat Nachfolger
    And I switch the current editor to editor "Bewertung1" with command "VIEW"
    Then field "nachfolger" is not empty
    And I close the current editor

    Given I open an editor "Bewertung_nachf" via ID from editor "Bewertung1" from field "nachfolger" in row 0 for table "(Valuation):(Valuation)" with command "VIEW"
    Then field "bewvorgang^vorgang^id" has value equal to field "id" from editor "Materialentnahme1"
    And I close the current editor

# Lagerjournal prüfen
    Given I open the infosystem "LJ"
    And I set field "beleg" to "barmex" from editor "Rückmeldung1"
    And I set field "richtung" to "rückwärts"
    And I press start
    Then table has values
      | art         | zmge | amge | rueckmge | restmge | vcharge^such | !row |
      | EINKAUF-1   |      | -2   | -2       | 0       | CH_1234      | 1    |
      | EINKAUF-1   |      | -10  | -10      | 0       | CH_4567      | 2    |
      | M_BAUGRUPPE | 10   |      | 0        | 10      |              | 3    |
      | EINKAUF-1   |      | 10   | 10       | 0       | CH_4567      | 4    |
      | EINKAUF-1   |      | 10   | 2        | 8       | CH_1234      | 5    |
      | EINKAUF-2   |      | 10   | 0        | 10      |              | 6    |
    Then field "rueckorig^id" in row 1 has value equal to field "verweis^id" from editor "LJ" in row 5
    Then field "rueckorig^id" in row 2 has value equal to field "verweis^id" from editor "LJ" in row 4
    And I close the current editor

# Material nachbuchen und Auftrag abschließen
    Given I open an editor "Materialentnahme2" via ID from editor "Materialentnahme1" from field "id" in row 0 for table "(Workorder):(CompletionConfirmations)" with command "COPY"
    And I modify table
      | !row                 | artikel     | mge | charge      |
      | artikel=="EINKAUF-1" | !dontChange | 10  | !CH_4567^id |
      | +2                   | EINKAUF-1   | 2   | !CH_1234^id |
    And I save the current editor

    Given I open the infosystem "BESTAND"
    And I set fields
      | artikel    | EINKAUF-1 |
      | klplatz    | F1        |
      | verdichten | nein      |
      | nullmge    | nein      |
      | details    | nein      |
    And I press start
    Then the table has 0 rows
    And I close the current editor

    And I deliver the SalesOrder "auftrag" with PackingSlip "LS-A04"


  Scenario: A05 Teil-Rückgabe mit Chargen auf letzten AS eines abgelegten FV, bisher Material über RM gebucht, EntnahmeMZ mit Chargen vor Freigabe FV angelegt, Material in AFL manbu=nein
    Given I set the fake date to "17.2.95"
# Bestand auf 0 korrigieren
    Given I set StorageQuantity to zero for Product "EINKAUF-1" on StorageLocation "F1" with document "SCEN-A05"

# Chargen anlegen
    Given I create a Lot "CH_1234" for Product "EINKAUF-1"
    Given I create a Lot "CH_4567" for Product "EINKAUF-1"

# Auftrag anlegen und Material einkaufen
    Given I create a SalesOrder "auftrag" for Customer "RADSHOP" with Product "BAUGRUPPE" and quantity "10"
    Given I open an editor "Rechnung" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
    And I set fields
      | lief   | KETTLER |
      | vom    | .       |
      | ueb    | ja      |
      | fakt   | ja      |
      | ebeleg | R-A05   |
    And I append rows
      | artikel   | mge | charge      |
      | EINKAUF-1 | 10  | !CH_1234^id |
      | EINKAUF-1 | 10  | !CH_4567^id |
      | EINKAUF-2 | 10  |             |
    And I set field "verw" in row 1 to "verw" from editor "auftrag" in row 1
    And I set field "verw" in row 2 to "verw" from editor "auftrag" in row 1
    And I set field "verw" in row 3 to "verw" from editor "auftrag" in row 1
    And I respond with answer "ja" to the dialog with id "4841"
    And I save the current editor

# Fertigungsvorschlag anlegen und freigeben
    Given I open an editor "fvor" from table "04:11" with command "NEW" for record ""
    And I append rows
      | artikel   | mge | mfreig |
      | BAUGRUPPE | 10  | ja     |
    And I set field "verw" in row !lastRow to "verw" from editor "auftrag" in row 1
    And I press button "mzabsm" to open a subeditor for "EntnahmeMZ" in row !lastRow
    And I modify table
      | !row | zuomge | charge      |
      | +1   | 10     | !CH_1234^id |
      | +2   | 10     | !CH_4567^id |
    And I save the current editor
    And I switch the current editor to editor "fvor"
    And I set field "bisuch" to "ACHRETRO_" in row !lastRow
    And I press button "freig" to open a subeditor for "BA_freigeben"
    And I close the current editor
    And I switch the current editor to editor "fvor"
    And I save the current editor

# Rückmeldung auf AS
    Given I open an editor "Rückmeldung1" from table "(Workorder):(WorkOrders)" with command "DONE" for record "ACHRETRO_001"
    And I set fields
      | sofort | ja |
      | gut    | ja |
      | bzeit  | 2  |
      | mzeit  | 2  |
    And I save the current editor

# Bewertungen
    Given I open an editor "Bewertung1" from table "(Valuation):(Valuation)" with command "VIEW" for search criteria "$,,artikel=EINKAUF-1;detursache=Rückmeldung Fertigung;@richtung=rückwärts;@maxtreffer=1"
    Then field "bewvorgang^vorgang^id" has value equal to field "id" from editor "Rückmeldung1"
    And I close the current editor

# Rückbau auf abgelegten FV und Bestand prüfen
    Given I open an editor "Rückgabe1" via ID from editor "Rückmeldung1" from field "id" in row 0 for table "(Workorder):(CompletionConfirmations)" with command "COPY"
    And I modify table
      | !row                 | mge | charge      |
      | artikel=="EINKAUF-1" | -10 | !CH_4567^id |
    And I save the current editor

    Given I open an editor "Rückgabe2" via ID from editor "Rückmeldung1" from field "id" in row 0 for table "(Workorder):(CompletionConfirmations)" with command "COPY"
    And I modify table
      | !row                 | mge | charge      |
      | artikel=="EINKAUF-1" | -2  | !CH_1234^id |
    And I save the current editor

    Given I open the infosystem "BESTAND"
    And I set fields
      | artikel    | EINKAUF-1 |
      | klplatz    | F1        |
      | verdichten | nein      |
      | nullmge    | nein      |
      | details    | nein      |
    And I press start
    And I press button "taufzu" in row 1
    Then the table has 3 rows
    Then table has values
      | lemge | gebmge | charge^such | kopfzugvorg^id |
      | 12    |        |             | (0,0,0)        |
      |       | 10     | CH_4567     | !Rechnung^id   |
      |       | 2      | CH_1234     | !Rechnung^id   |
    And I close the current editor

# Rückmeldungen und Rückbau prüfen, Bewertung hat Nachfolger
    And I switch the current editor to editor "Rückmeldung1" with command "VIEW"
    Then table has values
      | artikel   | restmge | rueckmge | limgev | limgen |
      | BAUGRUPPE | 10      | 0        | 0      | 10     |
      | EINKAUF-2 | 10      | 0        | 10     | 0      |
      | EINKAUF-1 | 8       | 12       | 20     | 0      |
    And I close the current editor

    And I switch the current editor to editor "Rückgabe1" with command "VIEW"
    Then table has values
      | artikel   | restmge | rueckmge | limgev | limgen |
      | BAUGRUPPE | 0       | 0        | 10     | 10     |
      | EINKAUF-1 | 0       | -10      | 20     | 10     |
      | EINKAUF-2 | 0       | 0        | 10     | 10     |
    And I close the current editor

    And I switch the current editor to editor "Rückgabe2" with command "VIEW"
    Then table has values
      | artikel   | restmge | rueckmge | limgev | limgen |
      | BAUGRUPPE | 0       | 0        | 10     | 10     |
      | EINKAUF-1 | 0       | -2       | 10     | 8      |
      | EINKAUF-2 | 0       | 0        | 10     | 10     |
    And I close the current editor

    And I switch the current editor to editor "Bewertung1" with command "VIEW"
    Then field "nachfolger" is not empty
    And I close the current editor

    Given I open an editor "Bewertung_nachf" via ID from editor "Bewertung1" from field "nachfolger" in row 0 for table "(Valuation):(Valuation)" with command "VIEW"
    Then field "bewvorgang^vorgang^id" has value equal to field "id" from editor "Rückmeldung1"
    And I close the current editor

# Lagerjournal prüfen
    Given I open the infosystem "LJ"
    And I set field "beleg" to "barmex" from editor "Rückmeldung1"
    And I set field "richtung" to "rückwärts"
    And I press start
    Then table has values
      | art       | zmge | amge | rueckmge | restmge | vcharge^such | !row |
      | EINKAUF-1 |      | -2   | -2       | 0       | CH_1234      | 1    |
      | EINKAUF-1 |      | -10  | -10      | 0       | CH_4567      | 2    |
      | BAUGRUPPE | 10   |      | 0        | 10      |              | 3    |
      | EINKAUF-1 |      | 10   | 10       | 0       | CH_4567      | 4    |
      | EINKAUF-1 |      | 10   | 2        | 8       | CH_1234      | 5    |
      | EINKAUF-2 |      | 10   | 0        | 10      |              | 6    |
    Then field "rueckorig^id" in row 1 has value equal to field "verweis^id" from editor "LJ" in row 5
    Then field "rueckorig^id" in row 2 has value equal to field "verweis^id" from editor "LJ" in row 4
    And I close the current editor

# Material nachbuchen und Auftrag abschließen
    Given I open an editor "Materialentnahme2" via ID from editor "Rückmeldung1" from field "id" in row 0 for table "(Workorder):(CompletionConfirmations)" with command "COPY"
    And I modify table
      | !row                 | artikel     | mge | charge      |
      | artikel=="EINKAUF-1" | !dontChange | 10  | !CH_4567^id |
      | +2                   | EINKAUF-1   | 2   | !CH_1234^id |
    And I save the current editor

    Given I open the infosystem "BESTAND"
    And I set fields
      | artikel    | EINKAUF-1 |
      | klplatz    | F1        |
      | verdichten | nein      |
      | nullmge    | nein      |
      | details    | nein      |
    And I press start
    Then the table has 0 rows
    And I close the current editor

    And I deliver the SalesOrder "auftrag" with PackingSlip "LS-A05"


  Scenario: A06 Teil-Rückgabe mit und ohne Chargen auf letzten AS eines abgelegten FV, bisher mehrere Materialentnahmen gebucht, EntnahmeMZ mit Chargen vor Freigabe FV angelegt
    Given I set the fake date to "18.2.95"
# Bestand auf 0 korrigieren
    Given I set StorageQuantity to zero for Product "EINKAUF-1" on StorageLocation "F1" with document "SCEN_A06"

# Chargen anlegen
    Given I create a Lot "CH_1234" for Product "EINKAUF-1"
    Given I create a Lot "CH_4567" for Product "EINKAUF-1"

# Auftrag anlegen und Material einkaufen
    Given I create a SalesOrder "auftrag" for Customer "RADSHOP" with Product "M_BAUGRUPPE" and quantity "15"

    Given I open an editor "Rechnung" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
    And I set fields
      | lief   | KETTLER |
      | vom    | .       |
      | ueb    | ja      |
      | fakt   | ja      |
      | ebeleg | R-A06   |
    And I append rows
      | artikel   | mge | charge      |
      | EINKAUF-1 | 10  | !CH_1234^id |
      | EINKAUF-1 | 10  | !CH_4567^id |
      | EINKAUF-1 | 10  |             |
      | EINKAUF-2 | 15  |             |
    And I set field "verw" in row 1 to "verw" from editor "auftrag" in row 1
    And I set field "verw" in row 2 to "verw" from editor "auftrag" in row 1
    And I set field "verw" in row 3 to "verw" from editor "auftrag" in row 1
    And I set field "verw" in row 4 to "verw" from editor "auftrag" in row 1
    And I respond with answer "ja" to the dialog with id "4841"
    And I save the current editor

# Fertigungsvorschlag anlegen und freigeben
    Given I open an editor "fvor" from table "04:11" with command "NEW" for record ""
    And I append rows
      | artikel     | mge | mfreig |
      | M_BAUGRUPPE | 15  | ja     |
    And I set field "verw" in row !lastRow to "verw" from editor "auftrag" in row 1
    And I press button "mzabsm" to open a subeditor for "EntnahmeMZ" in row !lastRow
    And I modify table
      | !row | zuomge | charge      |
      | +1   | 10     | !CH_1234^id |
      | +2   | 10     | !CH_4567^id |
      | +3   | 10     |             |
    And I save the current editor
    And I switch the current editor to editor "fvor"
    And I set field "bisuch" to "SCENARIOA07_" in row !lastRow
    And I press button "freig" to open a subeditor for "BA_freigeben"
    And I close the current editor
    And I switch the current editor to editor "fvor"
    And I save the current editor

    Given I open an editor "Arbeitsschein1" from table "(Workorder):(WorkOrders)" with command "VIEW" for record "SCENARIOA07_001"
    And I close the current editor

# Materialentnahme und Rückmeldung auf AS, Bewertungen öffnen
    Given I open an editor "Materialentnahme1" for tip command "Fbuchung" and arguments ""
    And I set fields
      | auftrag     | !Arbeitsschein1^nummer |
      | gmgevorschl | 7                      |
      | autorment   | ja                     |
      | bem         | Materialentnahme1      |
    And I press button "stlvblad"
    And I save the current editor
    And I set the fake date to "19.2.95"
    And I wait 1 time units to move the time forward

    Given I open an editor "Materialentnahme1" from table "(Workorder):(CompletionConfirmations)" with command "VIEW" for search criteria "$,,such=SCENARIOA07_001;@richtung=rückwärts;@ablageart=abgelegt;@maxtreffer=1"
    And I close the current editor

    Given I open an editor "Bewertung1" from table "(Valuation):(Valuation)" with command "VIEW" for search criteria "$,,artikel=EINKAUF-1;detursache=Materialentnahme Fertigung;@richtung=rückwärts;@maxtreffer=1"
    Then field "bewvorgang^vorgang^id" has value equal to field "id" from editor "Materialentnahme1"
    And I close the current editor

    Given I open an editor "Materialentnahme2" for tip command "Fbuchung" and arguments ""
    And I set fields
      | auftrag     | !Arbeitsschein1^nummer |
      | gmgevorschl | 5                      |
      | autorment   | ja                     |
      | bem         | Materialentnahme2      |
    And I press button "stlvblad"
    And I save the current editor
    And I set the fake date to "20.2.95"
    And I wait 1 time units to move the time forward

    Given I open an editor "Materialentnahme2" from table "(Workorder):(CompletionConfirmations)" with command "VIEW" for search criteria "$,,such=SCENARIOA07_001;@richtung=rückwärts;@ablageart=abgelegt;@maxtreffer=1"
    And I close the current editor

    Given I open an editor "Bewertung2" from table "(Valuation):(Valuation)" with command "VIEW" for search criteria "$,,artikel=EINKAUF-1;detursache=Materialentnahme Fertigung;@richtung=rückwärts;@maxtreffer=1"
    Then field "bewvorgang^vorgang^id" has value equal to field "id" from editor "Materialentnahme2"
    And I close the current editor

    Given I open an editor "Rückmeldung1" from table "(Workorder):(WorkOrders)" with command "DONE" for record "SCENARIOA07_001"
    And I set fields
      | sofort  | ja |
      | gut     | ja |
      | manrest | ja |
      | bzeit   | 2  |
      | mzeit   | 2  |
    And I save the current editor

    Given I open an editor "Bewertung3" from table "(Valuation):(Valuation)" with command "VIEW" for search criteria "$,,artikel=EINKAUF-1;detursache=Rückmeldung Fertigung;@richtung=rückwärts;@maxtreffer=1"
    Then field "bewvorgang^vorgang^id" has value equal to field "id" from editor "Rückmeldung1"
    And I close the current editor

# Rückbau auf abgelegten FV und Bestand prüfen
    Given I open an editor "Rückgabe1" via ID from editor "Materialentnahme1" from field "id" in row 0 for table "(Workorder):(CompletionConfirmations)" with command "COPY"
    And I modify table
      | !row                 | mge |
      | artikel=="EINKAUF-1" | -10 |
    And I save the current editor

    Given I open an editor "Rückgabe2" via ID from editor "Materialentnahme1" from field "id" in row 0 for table "(Workorder):(CompletionConfirmations)" with command "COPY"
    And I modify table
      | !row                 | mge | charge      |
      | artikel=="EINKAUF-1" | -10 | !CH_4567^id |
    And I save the current editor

    Given I open an editor "Rückgabe3" via ID from editor "Materialentnahme1" from field "id" in row 0 for table "(Workorder):(CompletionConfirmations)" with command "COPY"
    And I modify table
      | !row                 | mge | charge      |
      | artikel=="EINKAUF-1" | -7  | !CH_1234^id |
    And I save the current editor

    Given I open the infosystem "BESTAND"
    And I set fields
      | artikel    | EINKAUF-1 |
      | klplatz    | F1        |
      | verdichten | nein      |
      | nullmge    | nein      |
      | details    | nein      |
    And I press start
    And I press button "taufzu" in row 1
    Then the table has 6 rows
    Then table has values
      | lemge | gebmge | charge^such | kopfzugvorg^id |
      | 27    |        |             | (0,0,0)        |
      |       | 6      |             | !Rechnung^id   |
      |       | 4      |             | !Rechnung^id   |
      |       | 6      | CH_4567     | !Rechnung^id   |
      |       | 4      | CH_4567     | !Rechnung^id   |
      |       | 7      | CH_1234     | !Rechnung^id   |
    And I close the current editor

# Rückmeldungen und Rückbau prüfen, Bewertungen haben Nachfolger erhalten
    And I switch the current editor to editor "Materialentnahme1" with command "VIEW"
    Then table has values
      | artikel     | restmge | rueckmge | limgev | limgen |
      | M_BAUGRUPPE | 0       | 0        | 0      | 0      |
      | EINKAUF-2   | 7       | 0        | 15     | 8      |
      | EINKAUF-1   | 3       | 11       | 30     | 16     |
    And I close the current editor

    And I switch the current editor to editor "Materialentnahme2" with command "VIEW"
    Then table has values
      | artikel     | restmge | rueckmge | limgev | limgen |
      | M_BAUGRUPPE | 0       | 0        | 0      | 0      |
      | EINKAUF-2   | 5       | 0        | 8      | 3      |
      | EINKAUF-1   | 0       | 10       | 16     | 6      |
    And I close the current editor

    And I switch the current editor to editor "Rückmeldung1" with command "VIEW"
    Then table has values
      | artikel     | restmge | rueckmge | limgev | limgen |
      | M_BAUGRUPPE | 15      | 0        | 0      | 15     |
      | EINKAUF-2   | 3       | 0        | 3      | 0      |
      | EINKAUF-1   | 0       | 6        | 6      | 0      |
    And I close the current editor

    And I switch the current editor to editor "Rückgabe1" with command "VIEW"
    Then table has values
      | artikel     | restmge | rueckmge | limgev | limgen |
      | M_BAUGRUPPE | 0       | 0        | 15     | 15     |
      | EINKAUF-1   | 0       | -10      | 30     | 20     |
      | EINKAUF-2   | 0       | 0        | 15     | 15     |
    And I close the current editor

    And I switch the current editor to editor "Rückgabe2" with command "VIEW"
    Then table has values
      | artikel     | restmge | rueckmge | limgev | limgen |
      | M_BAUGRUPPE | 0       | 0        | 15     | 15     |
      | EINKAUF-1   | 0       | -10      | 20     | 10     |
      | EINKAUF-2   | 0       | 0        | 15     | 15     |
    And I close the current editor

    And I switch the current editor to editor "Rückgabe3" with command "VIEW"
    Then table has values
      | artikel     | restmge | rueckmge | limgev | limgen |
      | M_BAUGRUPPE | 0       | 0        | 15     | 15     |
      | EINKAUF-1   | 0       | -7       | 10     | 3      |
      | EINKAUF-2   | 0       | 0        | 15     | 15     |
    And I close the current editor

    And I switch the current editor to editor "Bewertung1" with command "VIEW"
    Then field "nachfolger" is not empty
    And I close the current editor
    Given I open an editor "Bewertung_nachf1" via ID from editor "Bewertung1" from field "nachfolger" in row 0 for table "(Valuation):(Valuation)" with command "VIEW"
    Then field "bewvorgang^vorgang^id" has value equal to field "id" from editor "Materialentnahme1"
    And I close the current editor

    And I switch the current editor to editor "Bewertung2" with command "VIEW"
    Then field "nachfolger" is not empty
    And I close the current editor
    Given I open an editor "Bewertung_nachf2" via ID from editor "Bewertung2" from field "nachfolger" in row 0 for table "(Valuation):(Valuation)" with command "VIEW"
    Then field "bewvorgang^vorgang^id" has value equal to field "id" from editor "Materialentnahme2"
    And I close the current editor

    And I switch the current editor to editor "Bewertung1" with command "VIEW"
    Then field "nachfolger" is not empty
    And I close the current editor
    Given I open an editor "Bewertung_nachf3" via ID from editor "Bewertung3" from field "nachfolger" in row 0 for table "(Valuation):(Valuation)" with command "VIEW"
    Then field "bewvorgang^vorgang^id" has value equal to field "id" from editor "Rückmeldung1"
    And I close the current editor

# Lagerjournal prüfen
    Given I open the infosystem "LJ"
    And I set field "beleg" to "barmex" from editor "Rückmeldung1"
    And I set field "richtung" to "rückwärts"
    And I press start
    Then table has values
      | art         | zmge | amge | rueckmge | restmge | vcharge^such | !row |
      | EINKAUF-1   |      | -7   | -7       | 0       | CH_1234      | 1    |
      | EINKAUF-1   |      | -4   | -4       | 0       | CH_4567      | 2    |
      | EINKAUF-1   |      | -6   | -6       | 0       | CH_4567      | 3    |
      | EINKAUF-1   |      | -4   | -4       | 0       |              | 4    |
      | EINKAUF-1   |      | -6   | -6       | 0       |              | 5    |
      | M_BAUGRUPPE | 15   |      | 0        | 15      |              | 6    |
      | EINKAUF-1   |      | 6    | 6        | 0       |              | 7    |
      | EINKAUF-2   |      | 3    | 0        | 3       |              | 8    |
      | EINKAUF-1   |      | 4    | 4        | 0       |              | 9    |
      | EINKAUF-1   |      | 6    | 6        | 0       | CH_4567      | 10   |
      | EINKAUF-2   |      | 5    | 0        | 5       |              | 11   |
      | EINKAUF-1   |      | 4    | 4        | 0       | CH_4567      | 12   |
      | EINKAUF-1   |      | 10   | 7        | 3       | CH_1234      | 13   |
      | EINKAUF-2   |      | 7    | 0        | 7       |              | 14   |
    Then field "rueckorig^id" in row 1 has value equal to field "verweis^id" from editor "LJ" in row 13
    Then field "rueckorig^id" in row 2 has value equal to field "verweis^id" from editor "LJ" in row 12
    Then field "rueckorig^id" in row 3 has value equal to field "verweis^id" from editor "LJ" in row 10
    Then field "rueckorig^id" in row 4 has value equal to field "verweis^id" from editor "LJ" in row 9
    Then field "rueckorig^id" in row 5 has value equal to field "verweis^id" from editor "LJ" in row 7
    And I close the current editor

# Material nachbuchen und Auftrag abschließen
    Given I open an editor "Rückmeldung2" via ID from editor "Rückmeldung1" from field "id" in row 0 for table "(Workorder):(CompletionConfirmations)" with command "COPY"
    And I modify table
      | !row                 | artikel     | mge | charge      |
      | artikel=="EINKAUF-1" | !dontChange | 10  | !CH_4567^id |
      | +2                   | EINKAUF-1   | 10  |             |
      | +2                   | EINKAUF-1   | 7   | !CH_1234^id |
    And I save the current editor

    Given I open the infosystem "BESTAND"
    And I set fields
      | artikel    | EINKAUF-1 |
      | klplatz    | F1        |
      | verdichten | nein      |
      | nullmge    | nein      |
      | details    | nein      |
    And I press start
    Then the table has 0 rows
    And I close the current editor

    And I deliver the SalesOrder "auftrag" with PackingSlip "LS-A06"


  Scenario: A07 Teil-Rückgabe mit Einheiten und Gebindepflicht auf letzten AS eines abgelegten FV, bisher Materialentnahme gebucht
    Given I set the fake date to "21.2.95"
# Bestände auf 0 korrigieren
    Given I set StorageQuantity to zero for Product "GEBINDE" on StorageLocation "F1" with document "SCEN-A07"
    Given I set StorageQuantity to zero for Product "GEBINDEPFL" on StorageLocation "F1" with document "SCEN-A07"
    Given I set StorageQuantity to zero for Product "BG-GEBINDE" on StorageLocation "F1" with document "SCEN-A07"

# Auftrag anlegen und Bedarfe einkaufen
    Given I create a SalesOrder "auftrag" for Customer "RADSHOP" with Product "BG-GEBINDE" and quantity "10"
    Given I open an editor "Rechnung" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
    And I set fields
      | lief   | KETTLER |
      | vom    | .       |
      | ueb    | ja      |
      | fakt   | ja      |
      | ebeleg | R-A07   |
    And I append rows
      | artikel    | mge | he   |
      | GEBINDEPFL | 5   | Paar |
      | GEBINDE    | 50  | kg   |
    And I respond with answer "ja" to the dialog with id "4841"
    And I save the current editor

# Fertigungsvorschlag anlegen und freigeben
    Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
    And I append rows
      | artikel    | netmge | mfreig |
      | BG-GEBINDE | 10     | ja     |
    And I press button "absteig" to open a subeditor for "AFL" in row !lastRow
    And I press button "setmanbu"
    And I save the current editor
    And I switch the current editor to editor "fvor"
    And I set field "bisuch" to "AGEBINDE_" in row 1
    And I press button "freig" to open a subeditor for "BA_freigeben"
    And I close the current editor
    And I switch the current editor to editor "fvor"
    And I save the current editor

# Arbeitsschein1 öffnen
    Given I open an editor "Arbeitsschein1" from table "(Workorder):(WorkOrders)" with command "VIEW" for record "AGEBINDE_001"
    And I close the current editor

# Materialentnahme und Rueckmeldung ueber gesamte Gutmenge
    Given I open an editor "Materialentnahme1" for tip command "Fbuchung" and arguments ""
    And I set field "auftrag" to "!Arbeitsschein1"
    And I set field "bem" to "EntnahmeT1"
    And I press button "stllad"
    And I modify table
      | !row | bumge | bueinh |
      | 1    | 10    | Stück  |
      | 2    | 5     | Paar   |
    And I save the current editor

    Given I open an editor "Materialentnahme1" from table "(Workorder):(CompletionConfirmations)" with command "VIEW" for search criteria "$,,such=AGEBINDE_001;bem=EntnahmeT1;manrm=ja;@richtung=rückwärts;@maxtreffer=1;@ablageart=abgelegt"
    And I close the current editor

    Given I open an editor "Rueckmeldung1" from table "(Workorder):(WorkOrders)" with command "DONE" for record "AGEBINDE_001"
    And I set fields
      | sofort | ja |
      | gut    | ja |
      | bzeit  | 2  |
      | mzeit  | 2  |
    And I save the current editor

# über Kopie der Materialentnahme einen Teil des entnommenen Materials zurueckbuchen
# in Handelseinheit
    Given I open an editor "Rueckgabe1" via ID from editor "Materialentnahme1" from field "id" in row 0 for table "(Workorder):(CompletionConfirmations)" with command "COPY"
    And I set field "bem" to "Rueckgabe1"
    And I modify table
      | !row | mge | bueinh |
      | 2    | -1  | kg     |
      | 3    | -1  | Paar   |
    Then table has values
      | bumge | bueinh | artikel    | limgen | limgev | restmge | rueckmge | !row |
      | -1    | kg     | GEBINDE    | 9.8    | 10     | -0.2    | 0        | 2    |
      | -1    | Paar   | GEBINDEPFL | 8      | 10     | -2      | 0        | 3    |
    And I save the current editor

    Given I open the infosystem "BESTAND"
    And I set fields
      | artikel    | GEBINDE |
      | verdichten | nein    |
      | nullmge    | nein    |
      | details    | nein    |
    And I press start
    And I press button "taufzu" in row 1
    Then the table has 2 rows
    Then table has values
      | lemge | leinheit | gebmge | geinheit |
      | 0.2   | Stück    |        |          |
      |       |          | 0.2    | Stück    |
    And I set fields
      | artikel    | GEBINDEPFL |
      | verdichten | nein       |
      | nullmge    | nein       |
      | details    | nein       |
    And I press start
    And I press button "taufzu" in row 1
    Then the table has 2 rows
    Then table has values
      | lemge | leinheit | gebmge | geinheit |
      | 2     | Stück    |        |          |
      |       |          | 1      | Paar     |
    And I close the current editor

# Belege zu Materialentnahmme und -rueckgabe pruefen
    And I switch the current editor to editor "Materialentnahme1" with command "VIEW"
    Then the table has 3 rows
    Then table has values
      | mge | artikel    | rueckmge | restmge | limgev | limgen |
      | 10  | BG-GEBINDE | 0        | 0       | 0      | 0      |
      | 10  | GEBINDEPFL | 2        | 8       | 10     | 0      |
      | 10  | GEBINDE    | 0.2      | 9.8     | 10     | 0      |
    And I close the current editor

    And I switch the current editor to editor "Rueckgabe1" with command "VIEW"
    Then table has values
      | mge  | artikel    | rueckmge | restmge | limgev | limgen |
      | 0    | BG-GEBINDE | 0        | 0       | 10     | 10     |
      | -0.2 | GEBINDE    | -0.2     | 0       | 10     | 9.8    |
      | -2   | GEBINDEPFL | -2       | 0       | 10     | 8      |
    And I close the current editor

# LJ pruefen
    Given I open the infosystem "LJ"
    And I set fields
      | beleg    | !Rueckgabe1^barmex |
      | richtung | rückwärts          |
    And I press start
    Then table has values
      | art        | amge | mei   | rueckmge | restmge | lei   |
      | GEBINDE    | -0.2 | Stück | -0.2     | 0       | Stück |
      | GEBINDEPFL | -1   | Paar  | -2       | 0       | Stück |
      | BG-GEBINDE |      | Stück | 0        | 10      | Stück |
      | GEBINDE    | 10   | Stück | 0.2      | 9.8     | Stück |
      | GEBINDEPFL | 5    | Paar  | 2        | 8       | Stück |
    And I close the current editor

# Nachbuchen von rückgegebenen Material, Bestand prüfen und Auftrag liefern
    Given I open an editor "Rückmeldung2" via ID from editor "Materialentnahme1" from field "id" in row 0 for table "(Workorder):(CompletionConfirmations)" with command "COPY"
    And I modify table
      | !row | mge | bueinh |
      | 2    | 0.2 | Stück  |
      | 3    | 1   | Paar   |
    And I save the current editor

    Given I open the infosystem "BESTAND"
    And I set fields
      | artikel    | GEBINDE |
      | verdichten | nein    |
      | nullmge    | nein    |
      | details    | nein    |
    And I press start
    Then the table has 0 rows
    And I set fields
      | artikel    | GEBINDEPFL |
      | verdichten | nein       |
      | nullmge    | nein       |
      | details    | nein       |
    And I press start
    Then the table has 0 rows
    And I close the current editor

    And I deliver the SalesOrder "auftrag" with PackingSlip "LS-MAN07"


  Scenario: A08 Rückgabe in gefüllt und leere Behälter auf letzten AS eines abgelegten FV, bihser Materialentnahme gebucht, EntnahmeMZ mit Behältern vor Freigabe FV angelegt
    Given I set the fake date to "22.2.95"
# Bestand auf 0 korrigieren
    Given I set StorageQuantity to zero for Product "EINKAUF-1" on StorageLocation "F1" with document "SCEN-A08_1"
    Given I set StorageQuantity to zero for Product "EINKAUF-2" on StorageLocation "F1" with document "SCEN-A08_2"
    Given I set StorageQuantity to zero for Product "EINKAUF-3" on StorageLocation "F1" with document "SCEN-A08_3"

# Behälter anlegen
    Given I create a Container "B_MATERIAL1" for packaging material "BEHAELTER"
    Given I create a Container "B_MATERIAL2" for packaging material "BEHAELTER"
    Given I create a Container "B_MATERIAL3" for packaging material "BEHAELTER"
    Given I create a Container "B_GEFUELLT" for packaging material "BEHAELTER"

# Auftrag anlagen und Bedarfe einkaufen
    Given I create a SalesOrder "auftrag" for Customer "RADSHOP" with Product "M_BG-BEHAELTER" and quantity "10"
    Given I open an editor "Rechnung" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
    And I set fields
      | lief   | KETTLER |
      | vom    | .       |
      | ueb    | ja      |
      | fakt   | ja      |
      | ebeleg | R-A08   |
    And I modify table
      | artikel   | mge | !dialogId                                     | !dialogAnswer | exbehnum            | !row |
      | EINKAUF-1 | 10  | Externe Behälternummer ist bereits vergeben. | nein          | !B_MATERIAL1^nummer | +1   |
      | EINKAUF-1 | 10  | Externe Behälternummer ist bereits vergeben. | nein          | !B_MATERIAL2^nummer | +2   |
      | EINKAUF-2 | 5   | Externe Behälternummer ist bereits vergeben. | nein          | !B_MATERIAL3^nummer | +3   |
      | EINKAUF-2 | 5   |                                               |               |                     | +4   |
      | EINKAUF-3 | 1   | Externe Behälternummer ist bereits vergeben. | nein          | !B_GEFUELLT^nummer  | +5   |
      | BEHAELTER | 4   |                                               |               |                     | +6   |
    And I set field "verw" in row 1 to "verw" from editor "auftrag" in row 1
    And I set field "verw" in row 2 to "verw" from editor "auftrag" in row 1
    And I set field "verw" in row 3 to "verw" from editor "auftrag" in row 1
    And I set field "verw" in row 4 to "verw" from editor "auftrag" in row 1
    And I respond with answer "ja" to the dialog with id "4841"
    And I save the current editor

# Fertigungsvorschlag anlegen und freigeben
    Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
    And I append rows
      | artikel        | netmge | mfreig |
      | M_BG-BEHAELTER | 10     | ja     |
    And I set field "verw" in row !lastRow to "verw" from editor "auftrag" in row !lastRow
    And I press button "mzabsm" to open a subeditor for "EntnahmeMZ" in row !lastRow
    And I modify table
      | !row | zuomge | behaelter    |
      | +1   | 10     | !B_MATERIAL1 |
      | +2   | 10     | !B_MATERIAL2 |
    And I press button "abv" to open a subeditor for "mz2"
    And I close the current editor
    And I switch the current editor to editor "EntnahmeMZ"
    And I modify table
      | !row | zuomge | behaelter    |
      | +1   | 5      | !B_MATERIAL3 |
      | +2   | 5      |              |
    And I save the current editor
    And I switch the current editor to editor "fvor"
    And I set field "bisuch" to "ABEHAELTER_" in row !lastRow
    And I press button "freig" to open a subeditor for "BA_freigeben"
    And I close the current editor
    And I switch the current editor to editor "fvor"
    And I save the current editor

    Given I open an editor "Arbeitsschein1" from table "(Workorder):(WorkOrders)" with command "VIEW" for record "ABEHAELTER_001"
    And I close the current editor

# Materialentnahme und Rückmeldung
    Given I open an editor "Materialentnahme1" for tip command "Fbuchung" and arguments ""
    And I set fields
      | auftrag | !Arbeitsschein1^nummer |
      | bem     | Entnahme1              |
    And I press button "stllad"
    And I save the current editor

    Given I open an editor "Materialentnahme1" from table "(Workorder):(CompletionConfirmations)" with command "VIEW" for search criteria "$,,such=ABEHAELTER_001;manrm=ja;@richtung=rückwärts;@maxtreffer=1;@ablageart=abgelegt"
    And I close the current editor

    Given I open an editor "Rückmeldung1" from table "(Workorder):(WorkOrders)" with command "DONE" for record "ABEHAELTER_001"
    And I set fields
      | sofort  | ja |
      | gut     | ja |
      | manrest | ja |
      | bzeit   | 2  |
      | mzeit   | 2  |
    And I save the current editor

# Behälter und Bestand prüfen
    Then Container from editor "B_MATERIAL1" is empty
    Then Container from editor "B_MATERIAL2" is empty
    Then Container from editor "B_MATERIAL3" is empty

    Given I open the infosystem "BESTAND"
    And I set fields
      | artikel    | EINKAUF-1 |
      | klplatz    | F1        |
      | behaelter  | ja        |
      | verdichten | nein      |
      | nullmge    | nein      |
      | details    | nein      |
    And I press start
    Then the table has 0 rows
    And I set fields
      | artikel    | EINKAUF-3 |
      | klplatz    | F1        |
      | behaelter  | ja        |
      | verdichten | nein      |
      | nullmge    | nein      |
      | details    | nein      |
    And I press start
    Then the table has 1 rows
    Then table has values
      | gebmge | lemge | tbehaelter^id  |
      | 1      |       | !B_GEFUELLT^id |
    And I close the current editor

# Teil-Rückgabe in gefüllten und leeren Behälter (über Zeile)
    Given I open an editor "Rückgabe1" via ID from editor "Materialentnahme1" from field "id" in row 0 for table "(Workorder):(CompletionConfirmations)" with command "COPY"
    And I modify table
      | !row                 | artikel     | mge | tbehaelter      |
      | artikel=="EINKAUF-1" | !dontChange | -14 | !B_MATERIAL2^id |
      | artikel=="EINKAUF-2" | !dontChange | -7  | !B_GEFUELLT^id  |
    And I save the current editor

# Behälter und Bestand prüfen
    Then Container from editor "B_MATERIAL3" is empty
    Then Container from editor "B_MATERIAL1" is empty
    And I switch the current editor to editor "B_MATERIAL2" with command "VIEW"
    Then the table has 1 rows
    Then table has values
      | artikel   | mge |
      | EINKAUF-1 | 14  |
    And I close the current editor
    And I switch the current editor to editor "B_GEFUELLT" with command "VIEW"
    Then the table has 2 rows
    Then table has values
      | artikel   | mge |
      | EINKAUF-2 | 7   |
      | EINKAUF-3 | 1   |
    And I close the current editor

    Given I open the infosystem "BESTAND"
    And I set fields
      | artikel    | EINKAUF-1 |
      | klplatz    | F1        |
      | behaelter  | ja        |
      | verdichten | nein      |
      | nullmge    | nein      |
      | details    | nein      |
    And I press start
    Then the table has 1 rows
    Then table has values
      | gebmge | tbehaelter^id   |
      | 14     | !B_MATERIAL2^id |
    And I set fields
      | artikel    | EINKAUF-3 |
      | klplatz    | F1        |
      | behaelter  | ja        |
      | verdichten | nein      |
      | nullmge    | nein      |
      | details    | nein      |
    And I press start
    Then the table has 1 rows
    Then table has values
      | gebmge | tbehaelter^id  |
      | 1      | !B_GEFUELLT^id |
    And I close the current editor

# LJ prüfen
    Given I open the infosystem "LJ"
    And I set field "beleg" to "!Rückmeldung1^barmex"
    And I set field "richtung" to "rückwärts"
    And I press start
    Then table has values
      | art            | zmge | amge | rueckmge | restmge | behaelter^id    | !row |
      | EINKAUF-1      |      | -4   | -4       | 0       | !B_MATERIAL2^id | 1    |
      | EINKAUF-1      |      | -10  | -10      | 0       | !B_MATERIAL2^id | 2    |
      | EINKAUF-2      |      | -2   | -2       | 0       | !B_GEFUELLT^id  | 3    |
      | EINKAUF-2      |      | -5   | -5       | 0       | !B_GEFUELLT^id  | 4    |
      | M_BG-BEHAELTER | 10   |      | 0        | 10      | (0,0,0)         | 5    |
      | EINKAUF-1      |      | 10   | 10       | 0       | !B_MATERIAL2^id | 6    |
      | EINKAUF-1      |      | 10   | 4        | 6       | !B_MATERIAL1^id | 7    |
      | EINKAUF-2      |      | 5    | 5        | 0       | (0,0,0)         | 8    |
      | EINKAUF-2      |      | 5    | 2        | 3       | !B_MATERIAL3^id | 9    |
    And I close the current editor

# Material und zusätzliches Material nachbuchen
    Given I open an editor "Rückmeldung2" via ID from editor "Materialentnahme1" from field "id" in row 0 for table "(Workorder):(CompletionConfirmations)" with command "COPY"
    And I modify table
      | !row                 | artikel     | mge | tbehaelter      |
      | artikel=="EINKAUF-1" | !dontChange | 14  | !B_MATERIAL2^id |
      | artikel=="EINKAUF-2" | !dontChange | 7   | !B_GEFUELLT^id  |
      | +2                   | EINKAUF-3   | 1   | !B_GEFUELLT^id  |
    And I save the current editor

# Behälter und Bestand prüfen
    Then Container from editor "B_MATERIAL1" is empty
    Then Container from editor "B_MATERIAL2" is empty
    Then Container from editor "B_MATERIAL3" is empty
    Then Container from editor "B_GEFUELLT" is empty

    Given I open the infosystem "BESTAND"
    And I set fields
      | artikel    | EINKAUF-1 |
      | klplatz    | F1        |
      | behaelter  | ja        |
      | verdichten | nein      |
      | nullmge    | nein      |
      | details    | nein      |
    And I press start
    Then the table has 0 rows
    And I set fields
      | artikel    | EINKAUF-3 |
      | klplatz    | F1        |
      | behaelter  | ja        |
      | verdichten | nein      |
      | nullmge    | nein      |
      | details    | nein      |
    And I press start
    Then the table has 0 rows
    And I close the current editor

# Lieferschein zu Auftrag
    And I deliver the SalesOrder "auftrag" with PackingSlip "LS-08"


# negative Zeilem Behälter Material2
  Scenario: A09 Rückgabe mit Einheiten und Gebindepflicht in gefüllt und leere Behälter auf letzten AS eines abgelegten FV, bihser Materialentnahme gebucht, EntnahmeMZ mit Behältern vor Freigabe FV angelegt
    Given I set the fake date to "23.2.95"
# Bestände auf 0 korrigieren
    Given I set StorageQuantity to zero for Product "GEBINDE" on StorageLocation "F1" with document "SCN-A09_1"
    Given I set StorageQuantity to zero for Product "GEBINDEPFL" on StorageLocation "F1" with document "SCN-A09_2"

# Behälter erstellen
    Given I create a Container "MATERIAL1" for packaging material "BEHAELTER"
    Given I create a Container "MATERIAL2" for packaging material "BEHAELTER"

# Auftrag anlegen und Bedarfe einkaufen
    Given I create a SalesOrder "auftrag" for Customer "RADSHOP" with Product "BG-GEBINDE" and quantity "10"
    Given I open an editor "Rechnung" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
    And I set fields
      | lief   | KETTLER |
      | vom    | .       |
      | ueb    | ja      |
      | fakt   | ja      |
      | ebeleg | R-A09   |
    And I append rows
      | artikel    | mge | he   |
      | GEBINDE    | 30  | kg   |
      | GEBINDE    | 20  | kg   |
      | GEBINDEPFL | 5   | Paar |
    And I set field "verw" in row 1 to "verw" from editor "auftrag" in row 1
    And I set field "verw" in row 2 to "verw" from editor "auftrag" in row 1
    And I set field "verw" in row 3 to "verw" from editor "auftrag" in row 1
    And I respond with answer "nein" to the dialog with id "Externe Behälternummer ist bereits vergeben."
    And I set field "exbehnum" to "nummer" from editor "MATERIAL1" in row 1
    And I respond with answer "nein" to the dialog with id "Externe Behälternummer ist bereits vergeben."
    And I set field "exbehnum" to "nummer" from editor "MATERIAL2" in row 2
    And I respond with answer "nein" to the dialog with id "Externe Behälternummer ist bereits vergeben."
    And I set field "exbehnum" to "nummer" from editor "MATERIAL2" in row 3
    And I respond with answer "ja" to the dialog with id "4841"
    And I save the current editor

# Fertigungsvorschlag anlegen und freigeben
    Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
    And I append rows
      | artikel    | netmge | mfreig |
      | BG-GEBINDE | 10     | ja     |
    And I set field "verw" in row !lastRow to "verw" from editor "auftrag" in row 1
    And I press button "absteig" to open a subeditor for "AFL" in row !lastRow
    And I press button "setmanbu"
    And I save the current editor
    And I switch the current editor to editor "fvor"
    And I press button "mzabsm" to open a subeditor for "MZ_Entnahme" in row 1
    And I modify table
      | !row | zuomge | einh  | behaelter     |
      | +1   | 6      | Stück | !MATERIAL1^id |
      | +2   | 4      | Stück | !MATERIAL2^id |
    And I press button "abv" to open a subeditor for "MZ_Entnahme2"
    And I close the current editor
    And I switch the current editor to editor "MZ_Entnahme"
    And I modify table
      | !row | zuomge | einh | behaelter     |
      | +1   | 5      | Paar | !MATERIAL2^id |
    And I save the current editor
    And I switch the current editor to editor "fvor"
    And I set field "bisuch" to "GEBINDEBEH1_" in row 1
    And I press button "freig" to open a subeditor for "BA_freigeben"
    And I close the current editor
    And I switch the current editor to editor "fvor"
    And I save the current editor

    And I open an editor "Arbeitsschein1" from table "(Workorder):(WorkOrders)" with command "VIEW" for record "GEBINDEBEH1_001"
    And I close the current editor

# Materialentnahme und Rückmeldung über gesamte Mengen
    Given I open an editor "Materialentnahme1" for tip command "Fbuchung" and arguments ""
    And I set field "auftrag" to "!Arbeitsschein1^nummer"
    And I set field "bem" to "Entnahme"
    And I press button "stllad"
    And I save the current editor

    Given I open an editor "Materialentnahme1" from table "(Workorder):(CompletionConfirmations)" with command "VIEW" for search criteria "$,,such=GEBINDEBEH1_001;manrm=ja;@richtung=rückwärts;@maxtreffer=1;@ablageart=abgelegt"
    And I close the current editor

    Then Container from editor "MATERIAL1" is empty
    Then Container from editor "MATERIAL2" is empty

    Given I open an editor "Rückmeldung1" from table "(Workorder):(WorkOrders)" with command "DONE" for record "GEBINDEBEH1_001"
    And I set fields
      | sofort | ja |
      | gut    | ja |
      | bzeit  | 2  |
      | mzeit  | 2  |
    And I save the current editor

# Über Kopie der Materialentnahme einen Teil des entnommenen Materials zurückbuchen, Bestand und Behälter pürfen
# in Stück
    Given I open an editor "Rückgabe1" via ID from editor "Materialentnahme1" from field "id" in row 0 for table "(Workorder):(CompletionConfirmations)" with command "COPY"
    And I set field "bem" to "Rückgabe1"
    And I modify table
      | !row | mge | tbehaelter    |
      | 2    | -1  | !MATERIAL1^id |
      | 3    | -1  | !MATERIAL1^id |
    Then table has values
      | bumge | bueinh | artikel    | limgen | limgev | restmge | rueckmge | !row |
      | -1    | Stück  | GEBINDE    | 9      | 10     | -1      | 0        | 2    |
      | -1    | Stück  | GEBINDEPFL | 9      | 10     | -1      | 0        | 3    |
    And I save the current editor

    Given I open the infosystem "BESTAND"
    And I set fields
      | artikel    | GEBINDE |
      | verdichten | nein    |
      | nullmge    | nein    |
      | behaelter  | ja      |
      | details    | nein    |
    And I press start
    Then the table has 1 rows
    Then table has values
      | lemge | gebmge | geinheit | tbehaelter^id |
      |       | 1      | Stück    | !MATERIAL1^id |
    And I set fields
      | artikel    | GEBINDEPFL |
      | verdichten | nein       |
      | nullmge    | nein       |
      | behaelter  | ja         |
      | details    | nein       |
    And I press start
    Then the table has 1 rows
    Then table has values
      | gebmge | geinheit | tbehaelter^id |
      | 1      | Stück    | !MATERIAL1^id |
    And I close the current editor

    And I switch the current editor to editor "MATERIAL1" with command "VIEW"
    Then the table has 2 rows
    Then table has values
      | artikel    | mge | gebeinh |
      | GEBINDE    | 1   | Stück   |
      | GEBINDEPFL | 1   | Stück   |
    And I close the current editor
    Then Container from editor "MATERIAL2" is empty

# in Lagerheinheit
    Given I open an editor "Rückgabe2" via ID from editor "Materialentnahme1" from field "id" in row 0 for table "(Workorder):(CompletionConfirmations)" with command "COPY"
    And I set field "bem" to "Rückgabe2"
    And I modify table
      | !row | mge | bueinh | tbehaelter    |
      | 2    | -1  | Stück  | !MATERIAL1^id |
      | 3    | -1  | Paar   | !MATERIAL2^id |
    Then table has values
      | bumge | bueinh | artikel    | limgen | limgev | restmge | rueckmge | !row |
      | -1    | Stück  | GEBINDE    | 8      | 9      | -1      | 0        | 2    |
      | -1    | Paar   | GEBINDEPFL | 7      | 9      | -2      | 0        | 3    |
    And I save the current editor

    Given I open the infosystem "BESTAND"
    And I set fields
      | artikel    | GEBINDE |
      | verdichten | nein    |
      | nullmge    | nein    |
      | behaelter  | ja      |
      | details    | nein    |
    And I press start
    Then the table has 1 rows
    Then table has values
      | gebmge | geinheit | tbehaelter^id |
      | 2      | Stück    | !MATERIAL1^id |
    And I set fields
      | artikel    | GEBINDEPFL |
      | verdichten | nein       |
      | nullmge    | nein       |
      | behaelter  | ja         |
      | details    | nein       |
    And I press start
    Then the table has 2 rows
    Then table has values
      | gebmge | geinheit | tbehaelter^id |
      | 1      | Stück    | !MATERIAL1^id |
      | 1      | Paar     | !MATERIAL2^id |
    And I close the current editor

    And I switch the current editor to editor "MATERIAL1" with command "VIEW"
    Then the table has 2 rows
    Then table has values
      | artikel    | mge | gebeinh |
      | GEBINDE    | 2   | Stück   |
      | GEBINDEPFL | 1   | Stück   |
    And I close the current editor
    And I switch the current editor to editor "MATERIAL2" with command "VIEW"
    Then the table has 1 rows
    Then table has values
      | artikel    | mge | gebeinh |
      | GEBINDEPFL | 1   | Paar    |
    And I close the current editor

# in Handelseinheit
    Given I open an editor "Rückgabe3" via ID from editor "Materialentnahme1" from field "id" in row 0 for table "(Workorder):(CompletionConfirmations)" with command "COPY"
    And I set field "bem" to "Rückgabe3"
    And I modify table
      | !row | mge | bueinh |
      | 2    | -1  | kg     |
      | 3    | -1  | Paar   |
    Then table has values
      | bumge | bueinh | artikel    | limgen | limgev | restmge | rueckmge | !row |
      | -1    | kg     | GEBINDE    | 7.8    | 8      | -0.2    | 0        | 2    |
      | -1    | Paar   | GEBINDEPFL | 5      | 7      | -2      | 0        | 3    |
    And I save the current editor

    Given I open the infosystem "BESTAND"
    And I set fields
      | artikel    | GEBINDE |
      | verdichten | nein    |
      | nullmge    | nein    |
      | behaelter  | ja      |
      | details    | nein    |
    And I press start
    Then the table has 2 rows
    Then table has values
      | gebmge | geinheit | tbehaelter^id |
      | 0.2    | Stück    | (0,0,0)       |
      | 2      | Stück    | !MATERIAL1^id |
    And I set fields
      | artikel    | GEBINDEPFL |
      | verdichten | nein       |
      | nullmge    | nein       |
      | behaelter  | ja         |
      | details    | nein       |
    And I press start
    Then the table has 3 rows
    Then table has values
      | gebmge | geinheit | tbehaelter^id |
      | 1      | Stück    | !MATERIAL1^id |
      | 1      | Paar     | (0,0,0)       |
      | 1      | Paar     | !MATERIAL2^id |
    And I close the current editor

    And I switch the current editor to editor "MATERIAL1" with command "VIEW"
    Then the table has 2 rows
    Then table has values
      | artikel    | mge | gebeinh |
      | GEBINDE    | 2   | Stück   |
      | GEBINDEPFL | 1   | Stück   |
    And I close the current editor
    And I switch the current editor to editor "MATERIAL2" with command "VIEW"
    Then the table has 1 rows
    Then table has values
      | artikel    | mge | gebeinh |
      | GEBINDEPFL | 1   | Paar    |
    And I close the current editor

# Originalbeleg zu Materialentnahmme prüfen
    And I switch the current editor to editor "Materialentnahme1" with command "VIEW"
    Then the table has 3 rows
    Then table has values
      | mge | artikel    | rueckmge | restmge | limgev | limgen |
      | 10  | BG-GEBINDE | 0        | 0       | 0      | 0      |
      | 10  | GEBINDEPFL | 5        | 5       | 10     | 0      |
      | 10  | GEBINDE    | 2.2      | 7.8     | 10     | 0      |
    And I close the current editor

# Nachbuchen von rückgegebenen Material, Bestand und Behälter prüfen und Auftrag liefern
    Given I open an editor "Rückmeldung2" via ID from editor "Materialentnahme1" from field "id" in row 0 for table "(Workorder):(CompletionConfirmations)" with command "COPY"
    And I modify table
      | !row | artikel     | mge | bueinh | tbehaelter    |
      | 2    | !dontChange | 2   | Stück  | !MATERIAL1^id |
      | 3    | !dontChange | 1   | Paar   | !MATERIAL2^id |
      | +4   | GEBINDE     | 0.2 | Stück  |               |
      | +5   | GEBINDEPFL  | 1   | Stück  | !MATERIAL1^id |
      | +6   | GEBINDEPFL  | 1   | Paar   |               |
    And I save the current editor

    Given I open the infosystem "BESTAND"
    And I set fields
      | artikel    | GEBINDE |
      | verdichten | nein    |
      | nullmge    | nein    |
      | behaelter  | ja      |
      | details    | nein    |
    And I press start
    Then the table has 0 rows
    And I set fields
      | artikel    | GEBINDEPFL |
      | verdichten | nein       |
      | nullmge    | nein       |
      | behaelter  | ja         |
      | details    | nein       |
    And I press start
    Then the table has 0 rows
    And I close the current editor

    Then Container from editor "MATERIAL1" is empty
    Then Container from editor "MATERIAL2" is empty

    And I deliver the SalesOrder "auftrag" with PackingSlip "LS-MAN09"


  Scenario: A10 Rückgabe von zusätzlich entnommenem Material auf letzten AS eines abgelegten FV, bisher zusätzliches Material über Fbuchung auf letzten AS entnommen
    Given I set the fake date to "24.2.95"
# Auftrag anlegen und Material einkaufen
    Given I create a SalesOrder "auftrag" for Customer "RADSHOP" with Product "BAUGRUPPE" and quantity "10"
    Given I open an editor "Rechnung" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
    And I set fields
      | lief   | KETTLER |
      | vom    | .       |
      | ueb    | ja      |
      | fakt   | ja      |
      | ebeleg | R-A10   |
    And I append rows
      | artikel   | mge |
      | EINKAUF-1 | 20  |
      | EINKAUF-2 | 10  |
      | EINKAUF-3 | 10  |
    And I set field "verw" in row 1 to "verw" from editor "auftrag" in row 1
    And I set field "verw" in row 2 to "verw" from editor "auftrag" in row 1
    And I set field "verw" in row 3 to "verw" from editor "auftrag" in row 1
    And I respond with answer "ja" to the dialog with id "4841"
    And I save the current editor

# Fertigungsvorschlag anlegen, freigeben und Rückmeldung buchen
    Given I open an editor "fvor" from table "04:11" with command "NEW" for record ""
    And I append rows
      | artikel   | mge | mfreig | bisuch   |
      | BAUGRUPPE | 10  | ja     | ZUSATZM_ |
    And I set field "verw" in row !lastRow to "verw" from editor "auftrag" in row 1
    And I press button "freig" to open a subeditor for "BA_freigeben"
    And I close the current editor
    And I switch the current editor to editor "fvor"
    And I save the current editor

# Materialentnahme und Rückmeldung auf AS
    Given I open an editor "Materialentnahme1" for tip command "Fbuchung" and arguments ""
    And I set field "auftrag" to "$,,such=ZUSATZM_001;@richtung=rückwärts;@maxtreffer=1"
    And I press button "stlvblad"
    And I append rows
      | elex      | bumge |
      | EINKAUF-3 | 10    |
    And I save the current editor

    Given I open an editor "Rückmeldung1" from table "(Workorder):(WorkOrders)" with command "DONE" for record "ZUSATZM_001"
    And I set fields
      | sofort | ja |
      | gut    | ja |
      | bzeit  | 2  |
      | mzeit  | 2  |
    And I save the current editor

# Bewertungen
    Given I open an editor "Materialentnahme1" from table "(Workorder):(CompletionConfirmations)" with command "VIEW" for search criteria "$,,such=ZUSATZM_001;manrm=ja;@richtung=rückwärts;@maxtreffer=1;@ablageart=abgelegt"
    And I close the current editor

    Given I open an editor "Bewertung1" from table "(Valuation):(Valuation)" with command "VIEW" for search criteria "$,,artikel=EINKAUF-3;detursache=Materialentnahme Fertigung;@richtung=rückwärts;@maxtreffer=1"
    Then field "bewvorgang^vorgang^id" has value equal to field "id" from editor "Materialentnahme1"
    And I close the current editor

# Rückbau auf abgelegten FV
    Given I open an editor "Rückgabe1" via ID from editor "Rückmeldung1" from field "id" in row 0 for table "(Workorder):(CompletionConfirmations)" with command "COPY"
    And I modify table
      | !row                 | artikel     | mge |
      | artikel=="EINKAUF-1" | !dontChange | -4  |
      | artikel=="EINKAUF-2" | !dontChange | -2  |
      | +4                   | EINKAUF-3   | -2  |
    And I save the current editor

# Rückmeldungen und Rückbau prüfen, Bewertung erhält Nachfolger
    And I switch the current editor to editor "Materialentnahme1" with command "VIEW"
    Then table has values
      | artikel   | restmge | rueckmge | limgev | limgen |
      | BAUGRUPPE | 0       | 0        | 0      | 0      |
      | EINKAUF-3 | 8       | 2        | 0      | 10     |
    And I close the current editor

    And I switch the current editor to editor "Rückmeldung1" with command "VIEW"
    Then table has values
      | artikel   | restmge | rueckmge | limgev | limgen |
      | BAUGRUPPE | 10      | 0        | 0      | 10     |
      | EINKAUF-2 | 8       | 2        | 10     | 0      |
      | EINKAUF-1 | 16      | 4        | 20     | 0      |
    And I close the current editor

    And I switch the current editor to editor "Rückgabe1" with command "VIEW"
    Then table has values
      | artikel   | restmge | rueckmge | limgev | limgen |
      | BAUGRUPPE | 0       | 0        | 10     | 10     |
      | EINKAUF-1 | 0       | -4       | 20     | 16     |
      | EINKAUF-2 | 0       | -2       | 10     | 8      |
      | EINKAUF-3 | 0       | -2       | 10     | 8      |
    And I close the current editor

    And I switch the current editor to editor "Bewertung1" with command "VIEW"
    Then field "nachfolger" is not empty
    And I close the current editor

    Given I open an editor "Bewertung_nachf" via ID from editor "Bewertung1" from field "nachfolger" in row 0 for table "(Valuation):(Valuation)" with command "VIEW"
    Then field "bewvorgang^vorgang^id" has value equal to field "id" from editor "Materialentnahme1"
    And I close the current editor

# Lagerjournal prüfen
    Given I open the infosystem "LJ"
    And I set field "beleg" to "barmex" from editor "Rückmeldung1"
    And I set field "richtung" to "rückwärts"
    And I press start
    Then table has values
      | art       | zmge | amge | rueckmge | restmge | !row |
      | EINKAUF-1 |      | -4   | -4       | 0       | 1    |
      | EINKAUF-2 |      | -2   | -2       | 0       | 2    |
      | EINKAUF-3 |      | -2   | -2       | 0       | 3    |
      | BAUGRUPPE | 10   |      | 0        | 10      | 4    |
      | EINKAUF-1 |      | 20   | 4        | 16      | 5    |
      | EINKAUF-2 |      | 10   | 2        | 8       | 6    |
      | EINKAUF-3 |      | 10   | 2        | 8       | 7    |
    And I close the current editor

# Auftrag abschließen
    And I deliver the SalesOrder "auftrag" with PackingSlip "LS-A10"

# Materialkostenverbuchung
    Given I create a CostEntriesSuggestion "mkv-24" with type of cost entry "Verbuchung Lagerbestand" for startdate "1.1.95" until enddate "."


  Scenario: A11 Teil-Rückgabe auf verschiedene Lagerplätze auf letzten AS eines abgelegten FV, bisher Materialentnahmen von verschiedenen Plätzen und RM gebucht
    Given I set the fake date to "25.2.95"
# Bestand auf 0 korrigieren
    Given I set StorageQuantity to zero for Product "B_EINKAUF-1" on StorageLocation "F1" with document "KORR-X09"
    Given I set StorageQuantity to zero for Product "B_EINKAUF-1" on StorageLocation "F2" with document "KORR-X09"

# Auftrag anlegen und Material zubuchen
    Given I create a SalesOrder "auftrag" for Customer "RADSHOP" with Product "BM_BAUGRUPPE" and quantity "10"

    Given I post a receipt via ManualStockAdjustment for Product "B_EINKAUF-1" and quantity "10" on StorageLocation "F1" with document "ZUGANG-X09" and price "0"
    Given I post a receipt via ManualStockAdjustment for Product "B_EINKAUF-1" and quantity "10" on StorageLocation "F2" with document "ZUGANG-X09" and price "0"
    Given I post a receipt via ManualStockAdjustment for Product "B_EINKAUF-2" and quantity "10" on StorageLocation "F1" with document "ZUGANG-X09" and price "0"

# Fertigungsvorschlag anlegen und freigeben
    Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
    And I append rows
      | artikel      | netmge | bisuch     | mfreig |
      | BM_BAUGRUPPE | 10     | PLAETZE9X_ | ja     |
    And I press button "freig" to open a subeditor for "BA_freigeben"
    And I close the current editor
    And I switch the current editor to editor "fvor"
    And I save the current editor

# Materialentnahmen über die Mengen von B_EINKAUF-1 auf F1 und F2, Rückmeldung über gesamte Gutmenge
    Given I open an editor "Materialentnahme1" for tip command "Fbuchung" and arguments ""
    And I set fields
      | auftrag     | $,,such=PLAETZE9X_001;@richtung=rückwärts;@maxtreffer=1 |
      | gmgevorschl | 5                                                       |
      | bem         | Entnahme1                                               |
    And I press button "stllad"
    And I modify table
      | !row                | buplatz |
      | elex=='B_EINKAUF-1' | F1      |
      | elex=='B_EINKAUF-2' | F1      |
    And I save the current editor
    And I set the fake date to "26.2.95"
    And I wait 1 time units to move the time forward

    Given I open an editor "Materialentnahme1" from table "(Workorder):(CompletionConfirmations)" with command "VIEW" for search criteria "$,,such=PLAETZE9X_001;manrm=ja;@richtung=rückwärts;@maxtreffer=1;@ablageart=abgelegt"
    And I close the current editor

    And I set the fake date to "27.2.95"
    And I wait 1 time units to move the time forward
    Given I open an editor "Materialentnahme2" for tip command "Fbuchung" and arguments ""
    And I set fields
      | auftrag     | $,,such=PLAETZE9X_001;@richtung=rückwärts;@maxtreffer=1 |
      | gmgevorschl | 5                                                       |
      | bem         | Entnahme2                                               |
    And I press button "stllad"
    And I modify table
      | !row                | buplatz |
      | elex=='B_EINKAUF-1' | F2      |
    And I save the current editor

    Given I open an editor "Materialentnahme2" from table "(Workorder):(CompletionConfirmations)" with command "VIEW" for search criteria "$,,such=PLAETZE9X_001;manrm=ja;@richtung=rückwärts;@maxtreffer=1;@ablageart=abgelegt"
    And I close the current editor

    Given I open an editor "Rückmeldung1" from table "(Workorder):(WorkOrders)" with command "DONE" for record "PLAETZE9X_001"
    And I set fields
      | sofort | ja |
      | gut    | ja |
    And I save the current editor

# Materialentnahme über Mengenvorschlag einen Teil des entnommenen Materials auf F1 zurückbuchen
    Given I open an editor "Rückgabe1" via ID from editor "Materialentnahme1" from field "id" in row 0 for table "(Workorder):(CompletionConfirmations)" with command "COPY"
    And I modify table
      | mge | buplatz | erbtext1   | !row                   |
      | -4  | F1      | Rückgabe1a | artikel=='B_EINKAUF-2' |
      | -8  | F1      | Rückgabe1b | artikel=='B_EINKAUF-1' |
    And I save the current editor

# Belege zu Materialentnahmme und -rückgabe prüfen
    And I switch the current editor to editor "Rückgabe1" with command "VIEW"
    Then table has values
      | mge | artikel      | rueckmge | restmge | limgev | limgen | buplatz |
      | 0   | BM_BAUGRUPPE | 0        | 0       | 10     | 10     | F1      |
      | -8  | B_EINKAUF-1  | -8       | 0       | 20     | 12     | F1      |
      | -4  | B_EINKAUF-2  | -4       | 0       | 10     | 6      | F1      |
    And I close the current editor

    And I switch the current editor to editor "Materialentnahme2" with command "VIEW"
    Then table has values
      | mge | artikel      | rueckmge | restmge | limgev | limgen | buplatz |
      | 10  | BM_BAUGRUPPE | 0        | 0       | 0      | 0      | F1      |
      | 5   | B_EINKAUF-2  | 4        | 1       | 5      | 0      | F1      |
      | 10  | B_EINKAUF-1  | 8        | 2       | 10     | 0      | F2      |
    And I close the current editor

    And I switch the current editor to editor "Materialentnahme1" with command "VIEW"
    Then table has values
      | mge | artikel      | rueckmge | restmge | limgev | limgen | buplatz |
      | 10  | BM_BAUGRUPPE | 0        | 0       | 0      | 0      | F1      |
      | 5   | B_EINKAUF-2  | 0        | 5       | 10     | 5      | F1      |
      | 10  | B_EINKAUF-1  | 0        | 10      | 20     | 10     | F1      |
    And I close the current editor

# Lagerjournaleintrag und Bestand prüfen
    Given I open the infosystem "LJ"
    And I set field "beleg" to "!Materialentnahme1^barmex"
    And I set field "richtung" to "rückwärts"
    And I press start
    Then table has values
      | art          | amge | zmge | vplatz | rueckmge | restmge | !row |
      | B_EINKAUF-1  | -8   |      | F1     | -8       | 0       | 1    |
      | B_EINKAUF-2  | -4   |      | F1     | -4       | 0       | 2    |
      | BM_BAUGRUPPE |      | 10   |        | 0        | 10      | 3    |
      | B_EINKAUF-1  | 10   |      | F2     | 8        | 2       | 4    |
      | B_EINKAUF-2  | 5    |      | F1     | 4        | 1       | 5    |
      | B_EINKAUF-1  | 10   |      | F1     | 0        | 10      | 6    |
      | B_EINKAUF-2  | 5    |      | F1     | 0        | 5       | 7    |
    Then field "rueckorig^id" in row 1 has value equal to field "verweis^id" from editor "LJ" in row 4
    And I close the current editor

    Given I open the infosystem "BESTAND"
    And I set fields
      | artikel    | B_EINKAUF-1 |
      | klplatz    |             |
      | verdichten | nein        |
      | nullmge    | nein        |
      | details    | nein        |
    And I press start
    And I press button "taufzu" in row 1
    Then the table has 2 rows
    Then table has values
      | lemge | lplatz | gebmge |
      | 8     | F1     |        |
      |       | F1     | 8      |
    And I close the current editor

# Material nachbuchen und Auftrag liefern
    Given I open an editor "Rückmeldung2" via ID from editor "Rückmeldung1" from field "id" in row 0 for table "(Workorder):(CompletionConfirmations)" with command "COPY"
    And I modify table
      | mge | buplatz | !row                   |
      | 4   | F1      | artikel=='B_EINKAUF-2' |
      | 8   | F1      | artikel=='B_EINKAUF-1' |
    And I save the current editor

    And I deliver the SalesOrder "auftrag" with PackingSlip "LS-X01"

    Given I open the infosystem "BESTAND"
    And I set fields
      | artikel    | B_EINKAUF-1 |
      | klplatz    |             |
      | verdichten | nein        |
      | nullmge    | nein        |
      | details    | nein        |
    And I press start
    Then the table has 0 rows
    And I close the current editor


  Scenario: A12 Teil-Rückgabe auf verschiedene Lagerplätze auf letzten AS eines abgelegten FV, bisher Materialentnahme von verschiedenen Plätzen und RM, EntnahmeMZ mit Plätzen
    Given I set the fake date to "28.2.95"
 # Bestand auf 0 korrigieren
    Given I set StorageQuantity to zero for Product "B_EINKAUF-1" on StorageLocation "F1" with document "KORR-X08"
    Given I set StorageQuantity to zero for Product "B_EINKAUF-1" on StorageLocation "F2" with document "KORR-X08"

 # Auftrag anlegen und Material zubuchen
    Given I create a SalesOrder "auftrag" for Customer "RADSHOP" with Product "BM_BAUGRUPPE" and quantity "10"

    Given I post a receipt via ManualStockAdjustment for Product "B_EINKAUF-1" and quantity "10" on StorageLocation "F1" with document "ZUGANG-X08" and price "0"
    Given I post a receipt via ManualStockAdjustment for Product "B_EINKAUF-1" and quantity "10" on StorageLocation "F2" with document "ZUGANG-X08" and price "0"
    Given I post a receipt via ManualStockAdjustment for Product "B_EINKAUF-2" and quantity "10" on StorageLocation "F1" with document "ZUGANG-X08" and price "0"

# Fertigungsvorschlag anlegen und freigeben
    Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
    And I append rows
      | artikel      | netmge | mfreig |
      | BM_BAUGRUPPE | 10     | ja     |
    And I press button "mzabsm" to open a subeditor for "EntnahmeMZ" in row 1
    And I modify table
      | !row | zuomge | lpsuch |
      | +1   | 10     | F1     |
      | +2   | 10     | F2     |
    And I save the current editor
    And I switch the current editor to editor "fvor"
    And I set field "bisuch" to "PLAETZE8X_" in row 1
    And I press button "freig" to open a subeditor for "BA_freigeben"
    And I close the current editor
    And I switch the current editor to editor "fvor"
    And I save the current editor

# Materialentnahmen über die gesamte Menge von B_EINKAUF-1 auf F1 und F2, Rückmeldung über gesamte Gutmenge
    Given I open an editor "Materialentnahme1" for tip command "Fbuchung" and arguments ""
    And I set fields
      | auftrag | $,,such=PLAETZE8X_001;@richtung=rückwärts;@maxtreffer=1 |
      | bem     | Entnahme1                                               |
    And I press button "stllad"
    And I save the current editor
    And I set the fake date to "1.3.95"
    And I wait 1 time units to move the time forward

    Given I open an editor "Materialentnahme1" from table "(Workorder):(CompletionConfirmations)" with command "VIEW" for search criteria "$,,such=PLAETZE8X_001;manrm=ja;@richtung=rückwärts;@maxtreffer=1;@ablageart=abgelegt"
    And I close the current editor

    Given I open an editor "Rückmeldung1" from table "(Workorder):(WorkOrders)" with command "DONE" for record "PLAETZE8X_001"
    And I set fields
      | sofort | ja |
      | gut    | ja |
    And I save the current editor

# Materialentnahme über Mengenvorschlag einen Teil des entnommenen Materials auf F1 zurückbuchen
    Given I open an editor "Rückgabe1" via ID from editor "Materialentnahme1" from field "id" in row 0 for table "(Workorder):(CompletionConfirmations)" with command "COPY"
    And I modify table
      | mge | buplatz | erbtext1   | !row                   |
      | -4  | F1      | Rückgabe1a | artikel=='B_EINKAUF-2' |
      | -8  | F1      | Rückgabe1b | artikel=='B_EINKAUF-1' |
    And I save the current editor

# Belege zu Materialentnahmme und -rückgabe prüfen
    And I switch the current editor to editor "Rückgabe1" with command "VIEW"
    Then table has values
      | mge | artikel      | rueckmge | restmge | limgev | limgen | buplatz |
      | 0   | BM_BAUGRUPPE | 0        | 0       | 10     | 10     | F1      |
      | -8  | B_EINKAUF-1  | -8       | 0       | 20     | 12     | F1      |
      | -4  | B_EINKAUF-2  | -4       | 0       | 10     | 6      | F1      |
    And I close the current editor

    And I switch the current editor to editor "Materialentnahme1" with command "VIEW"
    Then table has values
      | mge | artikel      | rueckmge | restmge | limgev | limgen | buplatz |
      | 10  | BM_BAUGRUPPE | 0        | 0       | 0      | 0      | F1      |
      | 10  | B_EINKAUF-2  | 4        | 6       | 10     | 0      | F1      |
      | 20  | B_EINKAUF-1  | 8        | 12      | 20     | 0      | F1      |
    And I close the current editor

# Lagerjournaleintrag und Bestand prüfen
    Given I open the infosystem "LJ"
    And I set field "beleg" to "!Materialentnahme1^barmex"
    And I set field "richtung" to "rückwärts"
    And I press start
    Then table has values
      | art          | amge | zmge | vplatz | rueckmge | restmge | !row |
      | B_EINKAUF-1  | -8   |      | F1     | -8       | 0       | 1    |
      | B_EINKAUF-2  | -4   |      | F1     | -4       | 0       | 2    |
      | BM_BAUGRUPPE |      | 10   |        | 0        | 10      | 3    |
      | B_EINKAUF-1  | 10   |      | F2     | 8        | 2       | 4    |
      | B_EINKAUF-1  | 10   |      | F1     | 0        | 10      | 5    |
      | B_EINKAUF-2  | 10   |      | F1     | 4        | 6       | 6    |
    Then field "rueckorig^id" in row 1 has value equal to field "verweis^id" from editor "LJ" in row 4
    And I close the current editor

    Given I open the infosystem "BESTAND"
    And I set fields
      | artikel    | B_EINKAUF-1 |
      | klplatz    |             |
      | verdichten | nein        |
      | nullmge    | nein        |
      | details    | nein        |
    And I press start
    And I press button "taufzu" in row 1
    Then the table has 2 rows
    Then table has values
      | lemge | lplatz | gebmge |
      | 8     | F1     |        |
      |       | F1     | 8      |
    And I close the current editor

 # Material nachbuchen und Auftrag liefern
    Given I open an editor "Rückmeldung2" via ID from editor "Materialentnahme1" from field "id" in row 0 for table "(Workorder):(CompletionConfirmations)" with command "COPY"
    And I modify table
      | mge | buplatz | !row                   |
      | 4   | F1      | artikel=='B_EINKAUF-2' |
      | 8   | F1      | artikel=='B_EINKAUF-1' |
    And I save the current editor
    And I deliver the SalesOrder "auftrag" with PackingSlip "LS-X01"

    Given I open the infosystem "BESTAND"
    And I set fields
      | artikel    | B_EINKAUF-1 |
      | klplatz    |             |
      | verdichten | nein        |
      | nullmge    | nein        |
      | details    | nein        |
    And I press start
    Then the table has 0 rows
    And I close the current editor


  Scenario:  A13 Teil-Rückgabe auf verschiedene Lagerplätze auf letzten AS eines abgelegten FV betrifft mehrere Entnahmen, bisher Materialentnahmen von verschiedenen Plätzen und RM gebucht
    Given I set the fake date to "2.3.95"
# Bestand auf 0 korrigieren
    Given I set StorageQuantity to zero for Product "B_EINKAUF-1" on StorageLocation "F1" with document "KORR-X07"
    Given I set StorageQuantity to zero for Product "B_EINKAUF-1" on StorageLocation "F2" with document "KORR-X07"

# Auftrag anlegen und Material zubuchen
    Given I create a SalesOrder "auftrag" for Customer "RADSHOP" with Product "BM_BAUGRUPPE" and quantity "10"
    Given I post a receipt via ManualStockAdjustment for Product "B_EINKAUF-1" and quantity "10" on StorageLocation "F1" with document "ZUGANG-X07" and price "0"
    Given I post a receipt via ManualStockAdjustment for Product "B_EINKAUF-1" and quantity "10" on StorageLocation "F2" with document "ZUGANG-X07" and price "0"
    Given I post a receipt via ManualStockAdjustment for Product "B_EINKAUF-2" and quantity "10" on StorageLocation "F1" with document "ZUGANG-X07" and price "0"

# Fertigungsvorschlag anlegen und freigeben
    Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
    And I append rows
      | artikel      | netmge | mfreig | bisuch     |
      | BM_BAUGRUPPE | 10     | ja     | PLAETZE7X_ |
    And I press button "freig" to open a subeditor for "BA_freigeben"
    And I close the current editor
    And I switch the current editor to editor "fvor"
    And I save the current editor

# Materialentnahmen über die gesamte Menge von B_EINKAUF-1 auf F1 und F2, Rückmeldung über gesamte Gutmenge
    Given I open an editor "Materialentnahme1" for tip command "Fbuchung" and arguments ""
    And I set fields
      | auftrag     | $,,such=PLAETZE7X_001;@richtung=rückwärts;@maxtreffer=1 |
      | gmgevorschl | 5                                                       |
      | bem         | Entnahme1                                               |
    And I press button "stllad"
    And I modify table
      | !row                | buplatz |
      | elex=='B_EINKAUF-1' | F1      |
      | elex=='B_EINKAUF-2' | F1      |
    And I save the current editor
    And I set the fake date to "3.3.95"
    And I wait 1 time units to move the time forward

    Given I open an editor "Materialentnahme1" from table "(Workorder):(CompletionConfirmations)" with command "VIEW" for search criteria "$,,such=PLAETZE7X_001;manrm=ja;@richtung=rückwärts;@maxtreffer=1;@ablageart=abgelegt"
    And I close the current editor

    Given I open an editor "Materialentnahme2" for tip command "Fbuchung" and arguments ""
    And I set fields
      | auftrag     | $,,such=PLAETZE7X_001;@richtung=rückwärts;@maxtreffer=1 |
      | gmgevorschl | 5                                                       |
      | bem         | Entnahme2                                               |
    And I press button "stllad"
    And I modify table
      | !row                | buplatz |
      | elex=='B_EINKAUF-1' | F2      |
    And I save the current editor

    Given I open an editor "Materialentnahme2" from table "(Workorder):(CompletionConfirmations)" with command "VIEW" for search criteria "$,,such=PLAETZE7X_001;manrm=ja;@richtung=rückwärts;@maxtreffer=1;@ablageart=abgelegt"
    And I close the current editor

    Given I open an editor "Rückmeldung1" from table "(Workorder):(WorkOrders)" with command "DONE" for record "PLAETZE7X_001"
    And I set fields
      | sofort | ja |
      | gut    | ja |
    And I save the current editor

# Materialentnahme über Mengenvorschlag einen Teil des entnommenen Materials auf F1 zurückbuchen
    Given I open an editor "Rückgabe1" via ID from editor "Materialentnahme1" from field "id" in row 0 for table "(Workorder):(CompletionConfirmations)" with command "COPY"
    And I modify table
      | mge | buplatz | erbtext1   | !row                   |
      | -7  | F1      | Rückgabe1a | artikel=='B_EINKAUF-2' |
      | -14 | F1      | Rückgabe1b | artikel=='B_EINKAUF-1' |
    And I save the current editor

# Belege zu Materialentnahmme und -rückgabe prüfen
    And I switch the current editor to editor "Rückgabe1" with command "VIEW"
    Then table has values
      | mge | artikel      | rueckmge | restmge | limgev | limgen | buplatz |
      | 0   | BM_BAUGRUPPE | 0        | 0       | 10     | 10     | F1      |
      | -14 | B_EINKAUF-1  | -14      | 0       | 20     | 6      | F1      |
      | -7  | B_EINKAUF-2  | -7       | 0       | 10     | 3      | F1      |
    And I close the current editor

    And I switch the current editor to editor "Materialentnahme2" with command "VIEW"
    Then table has values
      | mge | artikel      | rueckmge | restmge | limgev | limgen | buplatz |
      | 10  | BM_BAUGRUPPE | 0        | 0       | 0      | 0      | F1      |
      | 5   | B_EINKAUF-2  | 5        | 0       | 5      | 0      | F1      |
      | 10  | B_EINKAUF-1  | 10       | 0       | 10     | 0      | F2      |
    And I close the current editor

    And I switch the current editor to editor "Materialentnahme1" with command "VIEW"
    Then table has values
      | mge | artikel      | rueckmge | restmge | limgev | limgen | buplatz |
      | 10  | BM_BAUGRUPPE | 0        | 0       | 0      | 0      | F1      |
      | 5   | B_EINKAUF-2  | 2        | 3       | 10     | 5      | F1      |
      | 10  | B_EINKAUF-1  | 4        | 6       | 20     | 10     | F1      |
    And I close the current editor

# Lagerjournaleintrag und Bestand prüfen
    Given I open the infosystem "LJ"
    And I set field "beleg" to "!Materialentnahme1^barmex"
    And I set field "richtung" to "rückwärts"
    And I press start
    Then table has values
      | art          | amge | zmge | vplatz | rueckmge | restmge | !row |
      | B_EINKAUF-1  | -4   |      | F1     | -4       | 0       | 1    |
      | B_EINKAUF-1  | -10  |      | F1     | -10      | 0       | 2    |
      | B_EINKAUF-2  | -2   |      | F1     | -2       | 0       | 3    |
      | B_EINKAUF-2  | -5   |      | F1     | -5       | 0       | 4    |
      | BM_BAUGRUPPE |      | 10   |        | 0        | 10      | 5    |
      | B_EINKAUF-1  | 10   |      | F2     | 10       | 0       | 6    |
      | B_EINKAUF-2  | 5    |      | F1     | 5        | 0       | 7    |
      | B_EINKAUF-1  | 10   |      | F1     | 4        | 6       | 8    |
      | B_EINKAUF-2  | 5    |      | F1     | 2        | 3       | 9    |
    Then field "rueckorig^id" in row 1 has value equal to field "verweis^id" from editor "LJ" in row 8
    Then field "rueckorig^id" in row 2 has value equal to field "verweis^id" from editor "LJ" in row 6
    And I close the current editor

    Given I open the infosystem "BESTAND"
    And I set fields
      | artikel    | B_EINKAUF-1 |
      | klplatz    |             |
      | verdichten | nein        |
      | nullmge    | nein        |
      | details    | nein        |
    And I press start
    And I press button "taufzu" in row 1
    Then the table has 3 rows
    Then table has values
      | lemge | lplatz | gebmge |
      | 14    | F1     |        |
      |       | F1     | 10     |
      |       | F1     | 4      |
    And I close the current editor

# Material nachbuchen und Auftrag liefern
    Given I open an editor "Rückmeldung2" via ID from editor "Materialentnahme1" from field "id" in row 0 for table "(Workorder):(CompletionConfirmations)" with command "COPY"
    And I modify table
      | mge | buplatz | !row                   |
      | 7   | F1      | artikel=='B_EINKAUF-2' |
      | 14  | F1      | artikel=='B_EINKAUF-1' |
    And I save the current editor
    And I deliver the SalesOrder "auftrag" with PackingSlip "LS-X01"

    Given I open the infosystem "BESTAND"
    And I set fields
      | artikel    | B_EINKAUF-1 |
      | klplatz    |             |
      | verdichten | nein        |
      | nullmge    | nein        |
      | details    | nein        |
    And I press start
    Then the table has 0 rows
    And I close the current editor


  Scenario: A14 Teil-Rückgabe mit Chargen auf letzten AS eines abgelegten FV, bisher Materialentnahmen mit Chargenangabe und RM gebucht
    Given I set the fake date to "4.3.95"
# Bestand auf 0 korrigieren
    Given I set StorageQuantity to zero for Product "B_EINKAUF-1" on StorageLocation "F1" with document "KORR-X06"

#Chargen anlegen und Bedarfe zubuchen
    Given I create a Lot "CH1_MATX6" for Product "B_EINKAUF-1"
    Given I create a Lot "CH2_MATX6" for Product "B_EINKAUF-1"

#Auftrag anlegen und Bedarfe einkaufen
    Given I create a SalesOrder "auftrag" for Customer "RADSHOP" with Product "BM_BAUGRUPPE" and quantity "10"

    Given I open an editor "Rechnung" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
    And I set fields
      | lief   | KETTLER |
      | vom    | .       |
      | ueb    | ja      |
      | fakt   | ja      |
      | ebeleg | R-X06   |
    And I append rows
      | artikel     | mge | charge        |
      | B_EINKAUF-1 | 10  | !CH1_MATX6^id |
      | B_EINKAUF-1 | 10  | !CH2_MATX6^id |
      | B_EINKAUF-2 | 10  |               |
    And I respond with answer "ja" to the dialog with id "4841"
    And I save the current editor

# Fertigungsvorschlag anlegen und freigeben
    Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
    And I append rows
      | artikel      | netmge | mfreig | bisuch       |
      | BM_BAUGRUPPE | 10     | ja     | XCHMATERIAL_ |
    And I press button "freig" to open a subeditor for "BA_freigeben"
    And I close the current editor
    And I switch the current editor to editor "fvor"
    And I save the current editor

# Zwei Materialentnahmen über mit je einer Chargen für das Material und Rückmeldung über gesamte Gutmenge
    Given I open an editor "Materialentnahme1" for tip command "Fbuchung" and arguments ""
    And I set field "auftrag" to "$,,such=XCHMATERIAL_001;@richtung=rückwärts;@maxtreffer=1"
    And I set field "bem" to "Entnahme1"
    And I press button "stllad"
    And I modify table
      | bumge       | !row |
      | 10          | 1    |
	And I press button "mzsubm" to open a subeditor for "MZ" in row 1
	And I set field "charge" to "!CH1_MATX6^id" in row 1
	And I save the current editor
	And I switch the current editor to editor "Materialentnahme1"
    And I save the current editor

    Given I open an editor "Materialentnahme1" from table "(Workorder):(CompletionConfirmations)" with command "VIEW" for search criteria "$,,such=XCHMATERIAL_001;bem=Entnahme1;@ablageart=abgelegt;@richtung=rückwärts;@maxtreffer=1"
    And I close the current editor

    Given I open an editor "Materialentnahme2" for tip command "Fbuchung" and arguments ""
    And I set field "auftrag" to "$,,such=XCHMATERIAL_001;@richtung=rückwärts;@maxtreffer=1"
    And I set field "bem" to "Entnahme2"
    And I press button "stllad"
    And I modify table
      | bumge | rescharge     | !row |
      | 10    | !CH2_MATX6^id | 1    |
    And I save the current editor

    Given I open an editor "Materialentnahme2" from table "(Workorder):(CompletionConfirmations)" with command "VIEW" for search criteria "$,,such=XCHMATERIAL_001;bem=Entnahme2;@ablageart=abgelegt;@richtung=rückwärts;@maxtreffer=1"
    And I close the current editor

    Given I open an editor "Rückmeldung1" from table "(Workorder):(WorkOrders)" with command "DONE" for record "XCHMATERIAL_001"
    And I set fields
      | sofort | ja |
      | gut    | ja |
    And I save the current editor

# Über Fertigcharge einen Teil des entnommenen Materials zurückbuchen
    Given I open an editor "Rückgabe1" via ID from editor "Materialentnahme1" from field "id" in row 0 for table "(Workorder):(CompletionConfirmations)" with command "COPY"
    And I modify table
      | !row                   | mge | charge        |
      | artikel=='B_EINKAUF-2' | -2  |               |
      | artikel=='B_EINKAUF-1' | -4  | !CH1_MATX6^id |
    And I save the current editor

# Belege zu Materialentnahmme und -rückgabe prüfen
    And I switch the current editor to editor "Rückgabe1" with command "VIEW"
    Then the table has 3 rows
    Then table has values
      | mge | artikel      | rueckmge | restmge | limgev | limgen | charge^such |
      | 0   | BM_BAUGRUPPE | 0        | 0       | 10     | 10     |             |
      | -4  | B_EINKAUF-1  | -4       | 0       | 20     | 16     | CH1_MATX6   |
      | -2  | B_EINKAUF-2  | -2       | 0       | 10     | 8      |             |
    And I close the current editor

    And I switch the current editor to editor "Materialentnahme2" with command "VIEW"
    Then the table has 2 rows
    Then table has values
      | mge | artikel      | rueckmge | restmge | limgev | limgen |
      | 10  | BM_BAUGRUPPE | 0        | 0       | 0      | 0      |
      | 10  | B_EINKAUF-1  | 0        | 10      | 10     | 0      |
    And I close the current editor

    And I switch the current editor to editor "Materialentnahme1" with command "VIEW"
    Then the table has 3 rows
    Then table has values
      | mge | artikel      | rueckmge | restmge | limgev | limgen |
      | 10  | BM_BAUGRUPPE | 0        | 0       | 0      | 0      |
      | 10  | B_EINKAUF-2  | 2        | 8       | 10     | 0      |
      | 10  | B_EINKAUF-1  | 4        | 6       | 20     | 10     |
    And I close the current editor

# Lagerjournal und Bestand prüfen
    Given I open the infosystem "LJ"
    And I set field "beleg" to "barmex" from editor "Materialentnahme1"
    And I set field "richtung" to "rückwärts"
    And I press start
    Then table has values
      | art          | zmge | amge | rueckmge | restmge | vcharge^such | !row |
      | B_EINKAUF-1  |      | -4   | -4       | 0       | CH1_MATX6    | 1    |
      | B_EINKAUF-2  |      | -2   | -2       | 0       |              | 2    |
      | BM_BAUGRUPPE | 10   |      | 0        | 10      |              | 3    |
      | B_EINKAUF-1  |      | 10   | 0        | 10      | CH2_MATX6    | 4    |
      | B_EINKAUF-1  |      | 10   | 4        | 6       | CH1_MATX6    | 5    |
      | B_EINKAUF-2  |      | 10   | 2        | 8       |              | 6    |
    Then field "rueckorig^id" in row 1 has value equal to field "verweis^id" from editor "LJ" in row 5
    And I close the current editor

    Given I open the infosystem "BESTAND"
    And I set fields
      | artikel    | B_EINKAUF-1 |
      | klplatz    | F1          |
      | verdichten | nein        |
      | nullmge    | nein        |
      | details    | nein        |
    And I press start
    And I press button "taufzu" in row 1
    Then the table has 2 rows
    Then table has values
      | lemge | gebmge | charge^such |
      | 4     |        |             |
      |       | 4      | CH1_MATX6   |
    And I close the current editor

# Betriebsauftrag abschließen und Auftrag liefern
    Given I open an editor "Rückmeldung2" via ID from editor "Materialentnahme1" from field "id" in row 0 for table "(Workorder):(CompletionConfirmations)" with command "COPY"
    And I modify table
      | !row                   | mge | charge        |
      | artikel=='B_EINKAUF-2' | 2   |               |
      | artikel=='B_EINKAUF-1' | 4   | !CH1_MATX6^id |
    And I save the current editor

    Given I open the infosystem "BESTAND"
    And I set fields
      | artikel    | B_EINKAUF-1 |
      | klplatz    | F1          |
      | verdichten | nein        |
      | nullmge    | nein        |
      | details    | nein        |
    And I press start
    Then the table has 0 rows
    And I close the current editor

    And I deliver the SalesOrder "auftrag" with PackingSlip "LS-MANX06"


  Scenario: A15 Teil-Rückgabe in leere und gefüllte Behälter auf letzten AS eines abgelegten FV, bisher Materialentnahme mit Behälterangabe und RM gebucht
    Given I set the fake date to "5.3.95"
    And I set the fake date to "6.3.95"
# Behälter anlegen
    Given I create a Container "B_MATERIAL1" for packaging material "BEHAELTER"
    Given I create a Container "B_MATERIAL2" for packaging material "BEHAELTER"
    Given I create a Container "B_MATERIAL3" for packaging material "BEHAELTER"
    Given I create a Container "B_LEER" for packaging material "BEHAELTER"

# Auftrag anlagen und Bedarfe einkaufen
    Given I create a SalesOrder "auftrag" for Customer "RADSHOP" with Product "BM_BAUGRUPPE" and quantity "10"
    Given I open an editor "Rechnung" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
    And I set fields
      | lief   | KETTLER |
      | vom    | .       |
      | ueb    | ja      |
      | fakt   | ja      |
      | ebeleg | R-XA1   |
    And I append rows
      | artikel     | mge |
      | B_EINKAUF-1 | 10  |
      | B_EINKAUF-1 | 10  |
      | B_EINKAUF-2 | 5   |
      | B_EINKAUF-2 | 5   |
    And I respond with answer "nein" to the dialog with id "Externe Behälternummer ist bereits vergeben."
    And I set field "exbehnum" to "!B_MATERIAL1^nummer" in row 1
    And I respond with answer "nein" to the dialog with id "Externe Behälternummer ist bereits vergeben."
    And I set field "exbehnum" to "!B_MATERIAL2^nummer" in row 2
    And I respond with answer "nein" to the dialog with id "Externe Behälternummer ist bereits vergeben."
    And I set field "exbehnum" to "!B_MATERIAL3^nummer" in row 3
    And I respond with answer "ja" to the dialog with id "4841"
    And I save the current editor

# Fertigungsvorschlag anlegen und freigeben
    Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
    And I append rows
      | artikel      | netmge | mfreig | bisuch      |
      | BM_BAUGRUPPE | 10     | ja     | ABEHAELTER_ |
    And I press button "freig" to open a subeditor for "BA_freigeben"
    And I close the current editor
    And I switch the current editor to editor "fvor"
    And I save the current editor

    Given I open an editor "Arbeitsschein1" from table "(Workorder):(WorkOrders)" with command "VIEW" for record "ABEHAELTER_001"
    And I close the current editor

# Gesamt-Materialentnahme mit Behältern, Rückmeldung über gesamte Gutmenge
    Given I open an editor "Materialentnahme1" for tip command "Fbuchung" and arguments ""
    And I set fields
      | auftrag     | !Arbeitsschein1^nummer |
      | gmgevorschl | 5                      |
      | bem         | Entnahme1              |
    And I press button "stllad"
    And I modify table
      | behaelter    | !row |
      | !B_MATERIAL1 | 1    |
      | !B_MATERIAL3 | 2    |
    And I save the current editor
    And I set the fake date to "7.3.95"
    And I wait 1 time units to move the time forward

    Given I open an editor "Materialentnahme2" for tip command "Fbuchung" and arguments ""
    And I set fields
      | auftrag     | !Arbeitsschein1^nummer |
      | gmgevorschl | 5                      |
      | bem         | Entnahme2              |
    And I press button "stllad"
    And I modify table
      | behaelter    | !row |
      | !B_MATERIAL2 | 1    |
      |              | 2    |
    And I save the current editor

    Given I open an editor "Rückmeldung1" from table "(Workorder):(WorkOrders)" with command "DONE" for record "ABEHAELTER_001"
    And I set fields
      | gut    | ja |
      | sofort | ja |
    And I save the current editor

# Behälter prüfen
    Then Container from editor "B_MATERIAL1" is empty
    Then Container from editor "B_MATERIAL2" is empty
    Then Container from editor "B_MATERIAL3" is empty

# Teil-Rückgabe in gefüllten und leeren Behälter
    Given I open an editor "Rückgabe1" via ID from editor "Rückmeldung1" from field "id" in row 0 for table "(Workorder):(CompletionConfirmations)" with command "COPY"
    And I modify table
      | !row                   | mge | tbehaelter      |
      | artikel=='B_EINKAUF-2' | -2  | !B_LEER^id      |
      | artikel=='B_EINKAUF-1' | -4  | !B_MATERIAL1^id |
    And I save the current editor

# Behälter prüfen
    Then Container from editor "B_MATERIAL2" is empty

    And I switch the current editor to editor "B_MATERIAL1" with command "VIEW"
    Then the table has 1 rows
    Then table has values
      | artikel     | mge |
      | B_EINKAUF-1 | 4   |
    And I close the current editor
    And I switch the current editor to editor "B_LEER" with command "VIEW"
    Then the table has 1 rows
    Then table has values
      | artikel     | mge |
      | B_EINKAUF-2 | 2   |
    And I close the current editor

# LJ prüfen
    Given I open the infosystem "LJ"
    And I set field "beleg" to "!Rückmeldung1^barmex"
    And I set field "richtung" to "rückwärts"
    And I press start
    Then table has values
      | art          | amge | zmge | rueckmge | restmge | !row | behaelter^id    |
      | B_EINKAUF-1  | -4   |      | -4       | 0       | 1    | !B_MATERIAL1^id |
      | B_EINKAUF-2  | -2   |      | -2       | 0       | 2    | !B_LEER^id      |
      | BM_BAUGRUPPE |      | 10   | 0        | 10      | 3    | (0,0,0)         |
      | B_EINKAUF-1  | 10   |      | 4        | 6       | 4    | !B_MATERIAL2^id |
      | B_EINKAUF-2  | 5    |      | 2        | 3       | 5    | (0,0,0)         |
      | B_EINKAUF-1  | 10   |      | 0        | 10      | 6    | !B_MATERIAL1^id |
      | B_EINKAUF-2  | 5    |      | 0        | 5       | 7    | !B_MATERIAL3^id |
    And I close the current editor

# Nachbuchen auf Betriebsauftrag, Behälter prüfen und Auftrag liefern
    Given I open an editor "Rückmeldung2" via ID from editor "Rückmeldung1" from field "id" in row 0 for table "(Workorder):(CompletionConfirmations)" with command "COPY"
    And I modify table
      | !row                   | mge | tbehaelter      |
      | artikel=='B_EINKAUF-2' | 2   | !B_LEER^id      |
      | artikel=='B_EINKAUF-1' | 4   | !B_MATERIAL1^id |
    And I save the current editor

    Then Container from editor "B_MATERIAL1" is empty
    Then Container from editor "B_MATERIAL2" is empty
    Then Container from editor "B_MATERIAL3" is empty
    Then Container from editor "B_LEER" is empty

    And I deliver the SalesOrder "auftrag" with PackingSlip "LS-X06"


  Scenario: A16 Teil-Rückgabe Koppelprodukt mit Chargen auf letzten AS, bisher Materialentnahme mit Chargenangabe gebucht
    Given I set the fake date to "7.3.95"
    And I set the fake date to "8.3.95"
# Bestand auf 0 korrigieren
    Given I set StorageQuantity to zero for Product "EINKAUF-1" on StorageLocation "F1" with document "KORR-A16"
    Given I set StorageQuantity to zero for Product "KOPPELPROD" on StorageLocation "F2" with document "KORR-A16"

    Given I open an editor "KOPPELPROD" from table "(Part):(Product)" with command "UPDATE" for record "KOPPELPROD"
    And I set field "chverfolgung" to "Chargenverfolgung"
    And I save the current editor

#Chargen anlegen und Bedarfe zubuchen
    Given I create a Lot "CH1_MATA16" for Product "EINKAUF-1"
    Given I create a Lot "CH1_KOPPEL" for Product "KOPPELPROD"

#Auftrag anlegen und Bedarfe einkaufen
    Given I create a SalesOrder "auftrag" for Customer "RADSHOP" with Product "BG-KOPPEL" and quantity "10"

    Given I open an editor "Rechnung" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
    And I set fields
      | lief   | KETTLER |
      | vom    | .       |
      | ueb    | ja      |
      | fakt   | ja      |
      | ebeleg | R-X05   |
    And I append rows
      | artikel   | mge | charge         |
      | EINKAUF-1 | 20  | !CH1_MATA16^id |
    And I respond with answer "ja" to the dialog with id "4841"
    And I save the current editor

# Fertigungsvorschlag anlegen und freigeben
    Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
    And I append rows
      | artikel   | netmge | mfreig | bisuch    |
      | BG-KOPPEL | 10     | ja     | CHKOPPEL_ |
    And I press button "absteig" to open a subeditor for "AFL" in row 1
    And I press button "setmanbu"
    And I save the current subeditor to switch back to the parent editor
    And I set field "bisuch" to "CHKOPPEL_" in row 1
    And I press button "freig" to open a subeditor for "BA_freigeben"
    And I close the current editor
    And I switch the current editor to editor "fvor"
    And I save the current editor

# Materialentnahmen über mit je einer Chargen für das Material und das Koppelprodukt
    Given I open an editor "Materialentnahme1" for tip command "Fbuchung" and arguments ""
    And I set field "auftrag" to "$,,such=CHKOPPEL_001;@richtung=rückwärts;@maxtreffer=1"
    And I set field "bem" to "Entnahme1"
    And I press button "stllad"
	And I press button "mzsubm" to open a subeditor for "MZ" in row 1
	And I set field "charge" to "!CH1_KOPPEL^id" in row 1
	And I press button for next product
    And I set field "charge" to "!CH1_MATA16^id" in row 1
	And I save the current editor
	And I switch the current editor to editor "Materialentnahme1"
    And I save the current editor

    Given I open an editor "Materialentnahme1" from table "(Workorder):(CompletionConfirmations)" with command "VIEW" for search criteria "$,,such=CHKOPPEL_001;bem=Entnahme1;@ablageart=abgelegt;@richtung=rückwärts;@maxtreffer=1"
    And I close the current editor

# einen Teil des entnommenen Materials zurückbuchen und Koppelprodukt abbuchen
    Given I open an editor "Rückgabe1" for tip command "Fbuchung" and arguments ""
    And I set fields
      | auftrag     | !Materialentnahme1^barmex |
      | gmgevorschl | -2                        |
      | bem         | Rückgabe                  |
    And I press button "stllad"
    And I set field "rescharge" to "!CH1_KOPPEL^id" in row 1
    And I set field "rescharge" to "!CH1_MATA16^id" in row 2
    Then table has values
      | bumge | elex       | nlimge | limge | chentmge | entmge | rescharge^such |
      | -2    | KOPPELPROD | 2      | 0     | 10       | 10     | CH1_KOPPEL     |
      | -4    | EINKAUF-1  | 4      | 0     | 20       | 20     | CH1_MATA16     |
    And I save the current editor

# Belege zu Materialentnahmme und -rückgabe prüfen
    Given I open an editor "Rückgabe1" from table "(Workorder):(CompletionConfirmations)" with command "VIEW" for search criteria "$,,such=CHKOPPEL_001;@ablageart=abgelegt;@richtung=rückwärts;@maxtreffer=1"
    Then the table has 3 rows
    Then table has values
      | mge | artikel    | rueckmge | restmge | limgev | limgen |
      | 10  | BG-KOPPEL  | 0        | 0       | 0      | 0      |
      | -4  | EINKAUF-1  | -4       | 0       | 0      | 4      |
      | -2  | KOPPELPROD | -2       | 0       | 0      | 2      |
    And I close the current editor


    And I switch the current editor to editor "Materialentnahme1" with command "VIEW"
    Then the table has 3 rows
    Then table has values
      | mge | artikel    | rueckmge | restmge | limgev | limgen |
      | 10  | BG-KOPPEL  | 0        | 0       | 0      | 0      |
      | 20  | EINKAUF-1  | 4        | 16      | 20     | 0      |
      | 10  | KOPPELPROD | 2        | 8       | 10     | 0      |
    And I close the current editor

# Lagerjournal und Bestand prüfen
    Given I open the infosystem "LJ"
    And I set field "beleg" to "barmex" from editor "Materialentnahme1"
    And I set field "richtung" to "rückwärts"
    And I press start
    Then table has values
      | art        | zmge | amge | rueckmge | restmge | vcharge^such | ncharge^such | !row |
      | KOPPELPROD | -2   |      | -2       | 0       |              | CH1_KOPPEL   | 1    |
      | EINKAUF-1  |      | -4   | -4       | 0       | CH1_MATA16   |              | 2    |
      | KOPPELPROD | 10   |      | 2        | 8       |              | CH1_KOPPEL   | 3    |
      | EINKAUF-1  |      | 20   | 4        | 16      | CH1_MATA16   |              | 4    |
    Then field "rueckorig^id" in row 1 has value equal to field "verweis^id" from editor "LJ" in row 3
    Then field "rueckorig^id" in row 2 has value equal to field "verweis^id" from editor "LJ" in row 4
    And I close the current editor

    Given I open the infosystem "BESTAND"
    And I set fields
      | artikel    | KOPPELPROD |
      | klplatz    | F2         |
      | verdichten | nein       |
      | nullmge    | nein       |
      | details    | nein       |
    And I press start
    And I press button "taufzu" in row 1
    Then the table has 2 rows
    Then table has values
      | lemge | lplatz | gebmge | charge^such |
      | 8     | F2     |        |             |
      |       | F2     | 8      | CH1_KOPPEL  |
    And I close the current editor

    Given I open the infosystem "BESTAND"
    And I set fields
      | artikel    | EINKAUF-1 |
      | klplatz    | F1        |
      | verdichten | nein      |
      | nullmge    | nein      |
      | details    | nein      |
    And I press start
    And I press button "taufzu" in row 1
    Then the table has 2 rows
    Then table has values
      | lemge | lplatz | gebmge | charge^such |
      | 4     | F1     |        |             |
      |       | F1     | 4      | CH1_MATA16  |
    And I close the current editor

# Betriebsauftrag abschließen und Auftrag liefern
    Given I open an editor "Materialentnahme1" for tip command "Fbuchung" and arguments ""
    And I set field "auftrag" to "CHKOPPEL_001"
    And I press button "stllad"
    And I save the current editor

    Given I open an editor "Rueckmeldung1" from table "(Workorder):(WorkOrders)" with command "DONE" for record "CHKOPPEL_001"
    And I set fields
      | sofort | ja |
      | gut    | ja |
    And I save the current editor

    Given I open the infosystem "BESTAND"
    And I set fields
      | artikel    | KOPPELPROD |
      | klplatz    | F2         |
      | verdichten | nein       |
      | nullmge    | nein       |
      | details    | nein       |
    And I press start
    And I press button "taufzu" in row 1
    Then the table has 3 rows
    Then table has values
      | lemge | lplatz | gebmge | charge^such |
      | 10    | F2     |        |             |
      |       | F2     | 8      | CH1_KOPPEL  |
      |       | F2     | 2      |             |
    And I close the current editor

    Given I open the infosystem "BESTAND"
    And I set fields
      | artikel    | EINKAUF-1 |
      | klplatz    | F1        |
      | verdichten | nein      |
      | nullmge    | nein      |
      | details    | nein      |
    And I press start
    Then the table has 0 rows
    And I close the current editor

    And I deliver the SalesOrder "auftrag" with PackingSlip "LS-MANA16"

# Nachbuchen auf abgelegten Fertigungsvorschlag, auch Koppelprodukt abbuchen
    Given I open an editor "Nachbuchen1" via ID from editor "Rueckmeldung1" from field "id" in row 0 for table "(Workorder):(CompletionConfirmations)" with command "COPY"
    Then field "typa279" has value "Rückmeldung auf abgelegten Fertigungsvorschlag"
    Then table has values
      | !row | artikel    | mge         | gutmge      | verlustmge  |
      | 1    | BG-KOPPEL  | !dontChange | 0           | 0           |
      | 2    | KOPPELPROD | 0           | !dontChange | !dontChange |
      | 3    | EINKAUF-1  | 0           | !dontChange | !dontChange |
    And I modify table
      | mge         | gutmge      | charge         | !row |
      | !dontChange | 1           |                | 1    |
      | 1           | !dontChange | !CH1_KOPPEL^id | 2    |
      | 2           | !dontChange | !CH1_MATA16^id | 3    |
    And I save the current editor

    Given I open the infosystem "LJ"
    And I set field "beleg" to "barmex" from editor "Nachbuchen1"
    And I set field "richtung" to "rückwärts"
    And I press start
    Then table has values
      | art        | zmge | amge | rueckmge | restmge | vcharge^such | ncharge^such | !row |
      | BG-KOPPEL  | 1    |      | 0        | 1       |              |              | 1    |
      | KOPPELPROD | 1    |      | 0        | 1       |              | CH1_KOPPEL   | 2    |
      | EINKAUF-1  |      | 2    | 0        | 2       | CH1_MATA16   |              | 3    |
      | BG-KOPPEL  | 10   |      | 0        | 10      |              |              | 4    |
      | KOPPELPROD | 2    |      | 0        | 2       |              |              | 5    |
      | EINKAUF-1  |      | 4    | 0        | 4       |              |              | 6    |
      | KOPPELPROD | -2   |      | -2       | 0       |              | CH1_KOPPEL   | 7    |
      | EINKAUF-1  |      | -4   | -4       | 0       | CH1_MATA16   |              | 8    |
      | KOPPELPROD | 10   |      | 2        | 8       |              | CH1_KOPPEL   | 9    |
      | EINKAUF-1  |      | 20   | 4        | 16      | CH1_MATA16   |              | 10   |
    And I close the current editor

    Given I open the infosystem "BESTAND"
    And I set fields
      | artikel    | KOPPELPROD |
      | klplatz    | F2         |
      | verdichten | nein       |
      | nullmge    | nein       |
      | details    | nein       |
    And I press start
    And I press button "taufzu" in row 1
    Then the table has 4 rows
    Then table has values
      | lemge | lplatz | gebmge | charge^such |
      | 11    | F2     |        |             |
      |       | F2     | 8      | CH1_KOPPEL  |
      |       | F2     | 2      |             |
      |       | F2     | 1      | CH1_KOPPEL  |
    And I close the current editor

    Given I open the infosystem "BESTAND"
    And I set fields
      | artikel    | EINKAUF-1 |
      | klplatz    | F1        |
      | verdichten | nein      |
      | nullmge    | nein      |
      | details    | nein      |
    And I press start
    And I press button "taufzu" in row 1
    Then the table has 3 rows
    Then table has values
      | lemge | lplatz | gebmge | charge^such |
      | -2    | F1     |        |             |
      |       | F1     | 2      | CH1_MATA16  |
      |       | F1     | -4     |             |
    And I close the current editor

    Given I open an editor "Nachbuchen2" via ID from editor "Rueckmeldung1" from field "id" in row 0 for table "(Workorder):(CompletionConfirmations)" with command "COPY"
    Then field "typa279" has value "Rückmeldung auf abgelegten Fertigungsvorschlag"
    Then table has values
      | !row | artikel    | mge         | gutmge      | verlustmge  |
      | 1    | BG-KOPPEL  | !dontChange | 0           | 0           |
      | 2    | KOPPELPROD | 0           | !dontChange | !dontChange |
      | 3    | EINKAUF-1  | 0           | !dontChange | !dontChange |
    And I modify table
      | mge         | gutmge      | charge         | !row |
      | !dontChange | -1          |                | 1    |
      | -1          | !dontChange | !CH1_KOPPEL^id | 2    |
      | -2          | !dontChange | !CH1_MATA16^id | 3    |
    And I save the current editor

    Given I open the infosystem "LJ"
    And I set field "beleg" to "barmex" from editor "Nachbuchen1"
    And I set field "richtung" to "rückwärts"
    And I press start
    Then table has values
      | art        | zmge | amge | rueckmge | restmge | vcharge^such | ncharge^such | !row |
      | BG-KOPPEL  | -1   |      | -1       | 0       |              |              | 1    |
      | KOPPELPROD | -1   |      | -1       | 0       |              | CH1_KOPPEL   | 2    |
      | EINKAUF-1  |      | -2   | -2       | 0       | CH1_MATA16   |              | 3    |
      | BG-KOPPEL  | 1    |      | 1        | 0       |              |              | 4    |
      | KOPPELPROD | 1    |      | 1        | 0       |              | CH1_KOPPEL   | 5    |
      | EINKAUF-1  |      | 2    | 2        | 0       | CH1_MATA16   |              | 6    |
      | BG-KOPPEL  | 10   |      | 0        | 10      |              |              | 7    |
      | KOPPELPROD | 2    |      | 0        | 2       |              |              | 8    |
      | EINKAUF-1  |      | 4    | 0        | 4       |              |              | 9    |
      | KOPPELPROD | -2   |      | -2       | 0       |              | CH1_KOPPEL   | 10   |
      | EINKAUF-1  |      | -4   | -4       | 0       | CH1_MATA16   |              | 11   |
      | KOPPELPROD | 10   |      | 2        | 8       |              | CH1_KOPPEL   | 12   |
      | EINKAUF-1  |      | 20   | 4        | 16      | CH1_MATA16   |              | 13   |
    And I close the current editor

    Given I open the infosystem "BESTAND"
    And I set fields
      | artikel    | KOPPELPROD |
      | klplatz    | F2         |
      | verdichten | nein       |
      | nullmge    | nein       |
      | details    | nein       |
    And I press start
    And I press button "taufzu" in row 1
    Then the table has 3 rows
    Then table has values
      | lemge | lplatz | gebmge | charge^such |
      | 10    | F2     |        |             |
      |       | F2     | 8      | CH1_KOPPEL  |
      |       | F2     | 2      |             |
    And I close the current editor

    Given I open the infosystem "BESTAND"
    And I set fields
      | artikel    | EINKAUF-1 |
      | klplatz    | F1        |
      | verdichten | nein      |
      | nullmge    | nein      |
      | details    | nein      |
    And I press start
    Then the table has 0 rows
    And I close the current editor


  Scenario: A17 Rueckgabe von zusaetzlich entnommenem Material in mehreren Zeilen, gesamte entnommene Menge darf nicht ueberschritten werden
# FDA-4001
    Given I set the fake date to "09.03.95"

    Given I create a SalesOrder "auftrag" for Customer "RADSHOP" with Product "BAUGRUPPE" and quantity "10"
    Given I open an editor "Rechnung" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
    And I set fields
      | lief   | KETTLER |
      | vom    | .       |
      | ueb    | ja      |
      | fakt   | ja      |
      | ebeleg | R-17    |
    And I append rows
      | artikel   | mge |
      | EINKAUF-1 | 10  |
      | EINKAUF-2 | 5   |
      | EINKAUF-3 | 10  |
    And I set field "verw" in row 1 to "verw" from editor "auftrag" in row 1
    And I set field "verw" in row 2 to "verw" from editor "auftrag" in row 1
    And I respond with answer "ja" to the dialog with id "4841"
    And I save the current editor

    Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
    And I append rows
      | artikel   | netmge | bisuch  | mfreig |
      | BAUGRUPPE | 10     | ZUSENT_ | ja     |
    And I set field "verw" in row !lastRow to "verw" from editor "auftrag" in row !lastRow
    And I press button "freig" to open a subeditor for "BA_freigeben"
    And I close the current editor
    And I switch the current editor to editor "fvor"
    And I save the current editor

# Materialentnahme zusaetzliches Material
    Given I open an editor "Materialentnahme1" for tip command "Fbuchung" and arguments ""
    And I set fields
      | auftrag | ZUSENT_001 |
      | bem     | Entnahme1  |
    And I append rows
      | elex      | bumge |
      | EINKAUF-3 | 5     |
      | EINKAUF-3 | 3     |
      | EINKAUF-3 | 2     |
    And I save the current editor

# Materialrueckgabe zusaetzliches Material, es darf nicht mehr zurueckgebucht werden, als entnommen wurde
    Given I open an editor "Materialentnahme1" for tip command "Fbuchung" and arguments ""
    And I set fields
      | auftrag | ZUSENT_001 |
      | bem     | Entnahme1  |
    And I append rows
      | elex      | bumge |
      | EINKAUF-3 | -4    |
      | EINKAUF-3 | -5    |
      | EINKAUF-3 | -3    |
# 1395 de      |Die zurückzubuchende Menge ist größer als die ursprünglich zurückgemeldete Menge.
    Then saving the current editor throws the exception "984"
    And I set field "bumge" to "0" in row 3
    And I set field "bumge" to "0" in row 2
    And I set field "bumge" to "-10" in row 1
    And I save the current editor

    Given I open the infosystem "LJ"
    And I set field "richtung" to "rückwärts"
    And I press start
    Then table has values
      | art       | amge | zmge | rueckmge | restmge |
      | EINKAUF-3 | -2   |      | -2       | 0       |
      | EINKAUF-3 | -3   |      | -3       | 0       |
      | EINKAUF-3 | -5   |      | -5       | 0       |
      | EINKAUF-3 | 5    |      | 5        | 0       |
      | EINKAUF-3 | 3    |      | 3        | 0       |
      | EINKAUF-3 | 2    |      | 2        | 0       |
    And I close the current editor

# Betriebsauftrag abschließen
    Given I open an editor "Rückmeldung2" from table "(Workorder):(WorkOrders)" with command "DONE" for record "ZUSENT_000"
    And I set fields
      | sofort | ja          |
      | gut    | ja          |
      | mgr    | 112         |
      | bem    | Rückmeldung |
    And I save the current editor
    And I deliver the SalesOrder "auftrag" with PackingSlip "LS-R17"

  Scenario: A18 Rueckgabe von zusaetzlich entnommenem Material in mehreren Zeilen, gesamte entnommene Menge darf nicht ueberschritten werden
# https://abascloud.atlassian.net/browse/FDA-4001#icft=FDA-4001
    Given I set the fake date to "09.03.95"

    Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
    And I append rows
      | artikel | netmge | bisuch | mfreig |
      | V3      | 10     | MMM_   | ja     |
#And I set field "verw" in row !lastRow to "verw" from editor "auftrag" in row !lastRow
    And I press button "freig" to open a subeditor for "BA_freigeben"
    And I close the current editor
    And I switch the current editor to editor "fvor"
    And I save the current editor

# Materialentnahme zusaetzliches Material
    Given I open an editor "Materialentnahme1" for tip command "Fbuchung" and arguments ""
    And I set fields
      | auftrag | MMM_001   |
      | bem     | Entnahme1 |
    And I append rows
      | elex | bumge |
      | EINK | 3     |
      | EINK | 5     |
      | EINK | 2     |
    And I save the current editor

# Materialrueckgabe zusaetzliches Material, es darf nicht mehr zurueckgebucht werden, als entnommen wurde
    Given I open an editor "Materialentnahme1" for tip command "Fbuchung" and arguments ""
    And I set fields
      | auftrag | MMM_001   |
      | bem     | Entnahme1 |
    And I append rows
      | elex | bumge |
      | EINK | -1    |
      | EINK | -2    |
# 984 de      |Es gibt mehrere zusätzliche Entnahmen mit gleicher Charge, Verwendung und Projekt. Diese müssen zusammengefasst werden.
    Then saving the current editor throws the exception "984"
    And I set field "bumge" to "0" in row 2
    And I save the current editor

