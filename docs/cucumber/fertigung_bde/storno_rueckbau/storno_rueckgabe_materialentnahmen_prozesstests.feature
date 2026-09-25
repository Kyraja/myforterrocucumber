@persistent
Feature: storno_rueckgabe_materialentnahmen_prozesstests.feature

  Background:
    Given I set the fake date to "02.01.95"


# *****************************************************************************
#  Name             : storno_rueckgabe_materialentnahmen_prozesstests
#  Autor            : uo + lschneider
#  Verantwortlich   : drpf
#  Kontrolle        : amk
#  Funktion         : Testet den Storno von Rückgaben, die über die Materialent-
#                     entnahme entstanden sind
#  ref				: ref_fe_storno_rueck_fbuch_prozess_cu
#  Jira-Issue       : FDA-1030
# *****************************************************************************

  Scenario: 01 Storno einer Material-Teilrückgabe, manbu=nein, keine Gutmenge auf BA
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
      | artikel   | netmge | bisuch     | mfreig |
      | BAUGRUPPE | 10     | MATENTNSR_ | ja     |
    And I set field "verw" in row !lastRow to "verw" from editor "auftrag" in row 1
    And I press button "freig" to open a subeditor for "BA_freigeben"
    And I close the current editor
    And I switch the current editor to editor "fvor"
    And I save the current editor

# Materialentnahme über gesamte Gutmenge
    Given I open an editor "Fbuchung1" for tip command "Fbuchung" and arguments ""
    And I set field "auftrag" to "$,,such=MATENTNSR_001;@richtung=rückwärts;@maxtreffer=1"
    And I set field "bem" to "Entnahme"
    And I set field "autorment" to "ja"
    And I press button "stllad"
    And I save the current editor

    Given I open an editor "Materialentnahme1" from table "(Workorder):(CompletionConfirmations)" with command "VIEW" for search criteria "$,,such=MATENTNSR_001;manrm=ja;@richtung=rückwärts;@maxtreffer=1;@ablageart=abgelegt"
    And I close the current editor

# Materialentnahme über Mengenvorschlag einen Teil des entnommenen Materials zurückbuchen
    Given I open an editor "Fbuchung2" for tip command "Fbuchung" and arguments ""
    And I set field "auftrag" to "$,,such=MATENTNSR_001;@richtung=rückwärts;@maxtreffer=1"
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

    Given I open an editor "Rückgabe1" from table "(Workorder):(CompletionConfirmations)" with command "VIEW" for search criteria "$,,such=MATENTNSR_001;manrm=ja;@richtung=rückwärts;@maxtreffer=1;@ablageart=abgelegt"
    And I close the current editor

# Rückgabe stornieren
    Given I open an editor "Storno1_Rückgabe" via ID from editor "Rückgabe1" from field "id" in row 0 for table "(Workorder):(CompletionConfirmations)" with command "REVERSAL"
    And I save the current editor

# Belege zu Storno, Materialentnahmme und -rückgabe prüfen
    Given I switch the current editor to editor "Storno1_Rückgabe" with command "VIEW"
    Then the table has 3 rows
    Then table has values
      | mge | artikel   | rueckmge | restmge | limgev | limgen |
      | 10  | BAUGRUPPE | 0        | 0       | 0      | 0      |
      | 5   | EINKAUF-2 | 0        | 5       | 5      | 0      |
      | 10  | EINKAUF-1 | 0        | 10      | 10     | 0      |
    And I close the current editor

    Given I switch the current editor to editor "Rückgabe1" with command "VIEW"
    Then the table has 3 rows
    Then table has values
      | mge | artikel   | rueckmge | restmge | limgev | limgen |
      | 10  | BAUGRUPPE | 0        | 0       | 0      | 0      |
      | -5  | EINKAUF-2 | -5       | 0       | 0      | 5      |
      | -10 | EINKAUF-1 | -10      | 0       | 0      | 10     |
    And I close the current editor

    Given I switch the current editor to editor "Materialentnahme1" with command "VIEW"
    Then the table has 3 rows
    Then table has values
      | mge | artikel   | rueckmge | restmge | limgev | limgen |
      | 10  | BAUGRUPPE | 0        | 0       | 0      | 0      |
      | 10  | EINKAUF-2 | 0        | 10      | 10     | 0      |
      | 20  | EINKAUF-1 | 0        | 20      | 20     | 0      |
    And I close the current editor

# Lagerjournaleintrag prüfen
    Given I open the infosystem "LJ"
    And I set field "beleg" to "barmex" from editor "Materialentnahme1"
    And I set field "richtung" to "rückwärts"
    And I press start
    Then table has values
      | art       | amge | rueckmge | restmge | detursache                        | !row |
      | EINKAUF-1 | 10   | 10       | 0       | Storno-Materialrückgabe Fertigung | 1    |
      | EINKAUF-2 | 5    | 5        | 0       | Storno-Materialrückgabe Fertigung | 2    |
      | EINKAUF-1 | -10  | -10      | 0       | Materialrückgabe Fertigung        | 3    |
      | EINKAUF-2 | -5   | -5       | 0       | Materialrückgabe Fertigung        | 4    |
    Then field "stornolj^id" in row 1 has value equal to field "verweis^id" from editor "LJ" in row 3
    Then field "stornolj^id" in row 2 has value equal to field "verweis^id" from editor "LJ" in row 4
    And I close the current editor

# offene Mengen im Arbeitsschein prüfen und Betriebsauftrag abschließen
    Given I open an editor "Betriebsauftrag" from table "(Workorder):(WorkOrders)" with command "VIEW" for record "MATENTNSR_000"
    Then field "mge" has value "10"
    And I press button "absteig" to open a subeditor for "AFL"
    Then field "limge" has value "0" in row 1
    Then field "limge" has value "0" in row 2
    And I close the current editor
    And I switch the current editor to editor "Betriebsauftrag"
    And I close the current editor

    Given I open an editor "Rückmeldung1" from table "(Workorder):(WorkOrders)" with command "DONE" for record "MATENTNSR_001"
    And I set fields
      | sofort | ja |
      | gut    | ja |
    And I save the current editor
    And I deliver the SalesOrder "auftrag" with PackingSlip "LS-MAN01"


  Scenario: 02 Storno einer Materialrückgabe über die Gesamtmenge, manbu=nein, keine Gutmenge auf BA
    Given I set the fake date to "03.01.95"
# Auftrag anlegen und BEdarf einkaufen
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
      | artikel   | netmge | bisuch    | mfreig |
      | BAUGRUPPE | 10     | MAXENTSR_ | ja     |
    And I set field "verw" in row !lastRow to "verw" from editor "auftrag" in row 1
    And I press button "freig" to open a subeditor for "BA_freigeben"
    And I close the current editor
    And I switch the current editor to editor "fvor"
    And I save the current editor

# Materialentnahme und -rückgabe über gesamte Gutmenge
    Given I open an editor "Fbuchung" for tip command "Fbuchung" and arguments ""
    And I set field "auftrag" to "$,,such=MAXENTSR_001;@richtung=rückwärts;@maxtreffer=1"
    And I set field "autorment" to "ja"
    And I press button "stllad"
    And I set field "bem" to "Entnahme"
    And I save the current editor

    Given I open an editor "Materialentnahme1" from table "(Workorder):(CompletionConfirmations)" with command "VIEW" for search criteria "$,,such=MAXENTSR_001;@richtung=rückwärts;@ablageart=abgelegt;@maxtreffer=1"
    And I close the current editor

    Given I open an editor "Fbuchung2" for tip command "Fbuchung" and arguments ""
    And I set field "auftrag" to "$,,such=MAXENTSR_001;@richtung=rückwärts;@maxtreffer=1"
    And I set field "gmgevorschl" to "-15"
    And I set field "autorment" to "ja"
    And I set field "bem" to "Rückgabe"
    And I press button "stllad"
    Then table has values
      | bumge | elex      | nlimge | chentmge | entmge |
      | -20   | EINKAUF-1 | 20     | 20       | 20     |
      | -10   | EINKAUF-2 | 10     | 10       | 10     |
    And I save the current editor

    Given I open an editor "Rückgabe1" from table "(Workorder):(CompletionConfirmations)" with command "VIEW" for search criteria "$,,such=MAXENTSR_001;@richtung=rückwärts;@ablageart=abgelegt;@maxtreffer=1"
    And I close the current editor

# Storno der Materialrückgabe
    Given I open an editor "Storno1_Rückgabe" via ID from editor "Rückgabe1" from field "id" in row 0 for table "(Workorder):(CompletionConfirmations)" with command "REVERSAL"
    And I save the current editor

# Belege zu Stonro, Materialentnahmme und -rückgabe prüfen
    Given I switch the current editor to editor "Storno1_Rückgabe" with command "VIEW"
    Then the table has 3 rows
    Then table has values
      | mge | artikel   | rueckmge | restmge | limgev | limgen |
      | 10  | BAUGRUPPE | 0        | 0       | 0      | 0      |
      | 10  | EINKAUF-2 | 0        | 10      | 10     | 0      |
      | 20  | EINKAUF-1 | 0        | 20      | 20     | 0      |
    And I close the current editor

    Given I switch the current editor to editor "Rückgabe1" with command "VIEW"
    Then the table has 3 rows
    Then table has values
      | mge | artikel   | rueckmge | restmge | limgev | limgen |
      | 10  | BAUGRUPPE | 0        | 0       | 0      | 0      |
      | -10 | EINKAUF-2 | -10      | 0       | 0      | 10     |
      | -20 | EINKAUF-1 | -20      | 0       | 0      | 20     |
    And I close the current editor

    Given I switch the current editor to editor "Materialentnahme1" with command "VIEW"
    Then the table has 3 rows
    Then table has values
      | mge | artikel   | rueckmge | restmge | limgev | limgen |
      | 10  | BAUGRUPPE | 0        | 0       | 0      | 0      |
      | 10  | EINKAUF-2 | 0        | 10      | 10     | 0      |
      | 20  | EINKAUF-1 | 0        | 20      | 20     | 0      |
    And I close the current editor

# LJ prüfen
    Given I open the infosystem "LJ"
    And I set fields
      | beleg    | !Materialentnahme1^barmex |
      | richtung | rückwärts                 |
    And I press start
    Then table has values
      | art       | amge | rueckmge | restmge | detursache                        | !row |
      | EINKAUF-1 | 20   | 20       | 0       | Storno-Materialrückgabe Fertigung | 1    |
      | EINKAUF-2 | 10   | 10       | 0       | Storno-Materialrückgabe Fertigung | 2    |
      | EINKAUF-1 | -20  | -20      | 0       | Materialrückgabe Fertigung        | 3    |
      | EINKAUF-2 | -10  | -10      | 0       | Materialrückgabe Fertigung        | 4    |
    Then field "stornolj^id" in row 1 has value equal to field "verweis^id" from editor "LJ" in row 3
    Then field "stornolj^id" in row 2 has value equal to field "verweis^id" from editor "LJ" in row 4
    And I close the current editor

# offene Mengen im Arbeitsschein prüfen und Betriebsauftrag abschließen
    Given I open an editor "Betriebsauftrag" from table "(Workorder):(WorkOrders)" with command "UPDATE" for record "MAXENTSR_000"
    Then field "mge" has value "10"
    And I press button "absteig" to open a subeditor for "AFL"
    Then field "limge" has value "0" in row 1
    Then field "limge" has value "0" in row 2
    And I close the current editor
    And I switch the current editor to editor "Betriebsauftrag"
    And I close the current editor

    Given I open an editor "Rückmeldung1" from table "(Workorder):(WorkOrders)" with command "DONE" for record "MAXENTSR_001"
    And I set fields
      | sofort | ja |
      | gut    | ja |
    And I save the current editor
    And I deliver the SalesOrder "auftrag" with PackingSlip "LS-MAN02"


  Scenario: 03 Storno einer Material-Teilrückgabe, manbu=ja, keine Gutmenge auf BA
    Given I set the fake date to "04.01.95"
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

# Materialentnahme über gesamte Gutmenge und einen Teil des entnommenen Materials zurückbuchen
    Given I open an editor "Fbuchung1" for tip command "Fbuchung" and arguments ""
    And I set field "auftrag" to "$,,such=MANBU_001;@richtung=rückwärts;@maxtreffer=1"
    And I set field "bem" to "Entnahme"
    And I press button "stllad"
    And I save the current editor

    Given I open an editor "Materialentnahme1" from table "(Workorder):(CompletionConfirmations)" with command "VIEW" for search criteria "$,,such=MANBU_001;manrm=ja;@richtung=rückwärts;@maxtreffer=1;@ablageart=abgelegt"
    And I close the current editor

    Given I open an editor "Fbuchung2" for tip command "Fbuchung" and arguments ""
    And I set field "auftrag" to "$,,such=MANBU_001;@richtung=rückwärts;@maxtreffer=1"
    And I set fields
      | gmgevorschl | -5       |
      | bem         | Rückgabe |
    And I press button "stllad"
    And I save the current editor

    Given I open an editor "Rückgabe1" from table "(Workorder):(CompletionConfirmations)" with command "VIEW" for search criteria "$,,such=MANBU_001;manrm=ja;@richtung=rückwärts;@maxtreffer=1;@ablageart=abgelegt"
    And I close the current editor

# Rückgabe stornieren
    Given I open an editor "Storno1_Rückgabe" via ID from editor "Rückgabe1" from field "id" in row 0 for table "(Workorder):(CompletionConfirmations)" with command "REVERSAL"
    And I save the current editor

# Belege zu Storno, Materialentnahmme und -rückgabe prüfen
    Given I switch the current editor to editor "Storno1_Rückgabe" with command "VIEW"
    Then the table has 3 rows
    Then table has values
      | mge | artikel     | rueckmge | restmge | limgev | limgen |
      | 10  | M_BAUGRUPPE | 0        | 0       | 0      | 0      |
      | 5   | EINKAUF-2   | 0        | 5       | 5      | 0      |
      | 10  | EINKAUF-1   | 0        | 10      | 10     | 0      |
    And I close the current editor

    Given I switch the current editor to editor "Rückgabe1" with command "VIEW"
    Then the table has 3 rows
    Then table has values
      | mge | artikel     | rueckmge | restmge | limgev | limgen |
      | 10  | M_BAUGRUPPE | 0        | 0       | 0      | 0      |
      | -5  | EINKAUF-2   | -5       | 0       | 0      | 5      |
      | -10 | EINKAUF-1   | -10      | 0       | 0      | 10     |
    And I close the current editor

    Given I switch the current editor to editor "Materialentnahme1" with command "VIEW"
    Then the table has 3 rows
    Then table has values
      | mge | artikel     | rueckmge | restmge | limgev | limgen |
      | 10  | M_BAUGRUPPE | 0        | 0       | 0      | 0      |
      | 10  | EINKAUF-2   | 0        | 10      | 10     | 0      |
      | 20  | EINKAUF-1   | 0        | 20      | 20     | 0      |
    And I close the current editor

# Lagerjournaleintrag prüfen
    Given I open the infosystem "LJ"
    And I set field "beleg" to "!Materialentnahme1^barmex"
    And I set field "richtung" to "rückwärts"
    And I press start
    Then table has values
      | art       | amge | rueckmge | restmge | detursache                        | !row |
      | EINKAUF-1 | 10   | 10       | 0       | Storno-Materialrückgabe Fertigung | 1    |
      | EINKAUF-2 | 5    | 5        | 0       | Storno-Materialrückgabe Fertigung | 2    |
      | EINKAUF-1 | -10  | -10      | 0       | Materialrückgabe Fertigung        | 3    |
      | EINKAUF-2 | -5   | -5       | 0       | Materialrückgabe Fertigung        | 4    |
      | EINKAUF-1 | 20   | 0        | 20      | Materialentnahme Fertigung        | 5    |
      | EINKAUF-2 | 10   | 0        | 10      | Materialentnahme Fertigung        | 6    |
    Then field "stornolj^id" in row 1 has value equal to field "verweis^id" from editor "LJ" in row 3
    Then field "stornolj^id" in row 2 has value equal to field "verweis^id" from editor "LJ" in row 4
    And I close the current editor

# offene Mengen im Arbeitsschein prüfen und Betriebsauftrag abschließen
    Given I open an editor "Betriebsauftrag" from table "(Workorder):(WorkOrders)" with command "VIEW" for record "MANBU_000"
    Then field "mge" has value "10"
    And I press button "absteig" to open a subeditor for "AFL"
    Then field "limge" has value "0" in row 1
    Then field "limge" has value "0" in row 2
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


  Scenario: 04 Storno einer Material-Teilrückgabe, manbu=nein, Gutmenge auf BA
    Given I set the fake date to "05.01.95"
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

# Teil-Rückmeldung und Materialrückgabe auf ersten Arbeitsgang
    Given I open an editor "Rückmeldung1" from table "(Workorder):(WorkOrders)" with command "DONE" for record "RETROMAN_001"
    And I set fields
      | sofort | ja |
    And I set field "gutmge" to "7" in row 1
    And I save the current editor

# Materialentnahme über Mengenvorschlag einen Teil des entnommenen Materials zurückbuchen
    Given I open an editor "Fbuchung" for tip command "Fbuchung" and arguments ""
    And I set field "auftrag" to "$,,such=RETROMAN_001;@richtung=rückwärts;@maxtreffer=1"
    And I set fields
      | gmgevorschl | -2       |
      | autorment   | ja       |
      | bem         | Rückgabe |
    Then field "maxofmge" has value "ja"
    Then field "maxofmge" is not modifiable
    And I press button "stllad"
    And I save the current editor

    Given I open an editor "Rückgabe1" from table "(Workorder):(CompletionConfirmations)" with command "VIEW" for search criteria "$,,such=RETROMAN_001;manrm=ja;@richtung=rückwärts;@ablageart=abgelegt;@maxtreffer=1"
    And I close the current editor

# Materialrückgabe stornieren
    Given I open an editor "Storno1_Rückgabe" via ID from editor "Rückgabe1" from field "id" in row 0 for table "(Workorder):(CompletionConfirmations)" with command "REVERSAL"
    And I save the current editor

# Belege zu Storno, Materialentnahmme und -rückgabe prüfen
    Given I switch the current editor to editor "Storno1_Rückgabe" with command "VIEW"
    Then the table has 3 rows
    Then table has values
      | mge | artikel   | rueckmge | restmge | limgev | limgen |
      | 3   | BAUGRUPPE | 0        | 0       | 0      | 0      |
      | 2   | EINKAUF-2 | 0        | 2       | 5      | 3      |
      | 4   | EINKAUF-1 | 0        | 4       | 10     | 6      |
    And I close the current editor

    Given I switch the current editor to editor "Rückgabe1" with command "VIEW"
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
      | 7   | EINKAUF-2 | 0        | 7       | 10     | 3      |
      | 14  | EINKAUF-1 | 0        | 14      | 20     | 6      |
    And I close the current editor

# Lagerjournaleintrag prüfen
    Given I open the infosystem "LJ"
    And I set field "beleg" to "barmex" from editor "Rückmeldung1"
    And I set field "richtung" to "rückwärts"
    And I press start
    Then table has values
      | art       | amge | zmge | rueckmge | restmge | detursache                        | !row |
      | EINKAUF-1 | 4    |      | 4        | 0       | Storno-Materialrückgabe Fertigung | 1    |
      | EINKAUF-2 | 2    |      | 2        | 0       | Storno-Materialrückgabe Fertigung | 2    |
      | EINKAUF-1 | -4   |      | -4       | 0       | Materialrückgabe Fertigung        | 3    |
      | EINKAUF-2 | -2   |      | -2       | 0       | Materialrückgabe Fertigung        | 4    |
      | BAUGRUPPE |      | 7    | 0        | 7       | Rückmeldung Fertigung             | 5    |
      | EINKAUF-1 | 14   |      | 0        | 14      | Rückmeldung Fertigung             | 6    |
      | EINKAUF-2 | 7    |      | 0        | 7       | Rückmeldung Fertigung             | 7    |
    Then field "stornolj^id" in row 1 has value equal to field "verweis^id" from editor "LJ" in row 3
    Then field "stornolj^id" in row 2 has value equal to field "verweis^id" from editor "LJ" in row 4
    And I close the current editor

# Betriebsauftrag abschließen und Auftrag liefern
    Given I open an editor "Rückmeldung2" from table "(Workorder):(WorkOrders)" with command "DONE" for record "RETROMAN_001"
    And I set fields
      | sofort  | ja |
      | gut     | ja |
      | manrest | ja |
    And I save the current editor
    And I deliver the SalesOrder "auftrag" with PackingSlip "LS-MAN04"


# FDA-1007: Diag beim Storno des Rückbaus, Verweis auf zwei LJ-Einträge
  Scenario: 05 Storno eines Rückbaus von Material mit Chargen, manbu=nein, Gutmenge auf BA
    Given I set the fake date to "06.01.95"
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

# Rückmeldung auf ersten Arbeitsgang und Teilrückgabe mit Chargen
    Given I open an editor "Rückmeldung1" from table "(Workorder):(WorkOrders)" with command "DONE" for record "CHARGERED_001"
    And I set fields
      | sofort | ja |
    And I set field "gutmge" to "8" in row 1
    And I save the current editor

    Given I open an editor "Fbuchung1" for tip command "Fbuchung" and arguments ""
    And I set field "auftrag" to "!Rückmeldung1^barmex"
    And I set fields
      | gmgevorschl | -5        |
      | autorment   | ja        |
      | bem         | RückgabeX |
    And I press button "stllad"
    And I modify table
      | !row | manbu | rescharge    |
      | 1    | ja    | !MAT01-01^id |
      | 2    | ja    | !MAT02-01^id |
    And I save the current editor

    Given I open an editor "Rückgabe1" from table "(Workorder):(CompletionConfirmations)" with command "VIEW" for search criteria "$,,such=CHARGERED_001;bem=RückgabeX;@ablageart=abgelegt;@richtung=rückwärts;@maxtreffer=1"
    And I close the current editor

# Rückgabe stornieren
    Given I open an editor "Storno1_Rückgabe" via ID from editor "Rückgabe1" from field "id" in row 0 for table "(Workorder):(CompletionConfirmations)" with command "REVERSAL"
    And I save the current editor

# Belege zu Storno, Materialentnahmme und -rückgabe prüfen
    Given I switch the current editor to editor "Storno1_Rückgabe" with command "VIEW"
    Then the table has 3 rows
    Then table has values
      | mge | artikel   | rueckmge | restmge | limgev | limgen | chentmge |
      | 2   | BAUGRUPPE | 0        | 0       | 0      | 0      | 0        |
      | 5   | EINKAUF-2 | 0        | 5       | 7      | 2      | 0        |
      | 10  | EINKAUF-1 | 0        | 10      | 14     | 4      | 0        |
    And I close the current editor

    Given I switch the current editor to editor "Rückgabe1" with command "VIEW"
    Then the table has 3 rows
    Then table has values
      | mge | artikel   | rueckmge | restmge | limgev | limgen | chentmge |
      | 2   | BAUGRUPPE | 0        | 0       | 8      | 8      | 0        |
      | -5  | EINKAUF-2 | -5       | 0       | 2      | 7      | 0        |
      | -10 | EINKAUF-1 | -10      | 0       | 4      | 14     | 0        |
    And I close the current editor

    Given I switch the current editor to editor "Rückmeldung1" with command "VIEW"
    Then the table has 3 rows
    Then table has values
      | mge | artikel   | rueckmge | restmge | limgev | limgen | chentmge |
      | 10  | BAUGRUPPE | 0        | 8       | 0      | 8      | 0        |
      | 8   | EINKAUF-2 | 0        | 8       | 10     | 2      | 0        |
      | 16  | EINKAUF-1 | 0        | 16      | 20     | 4      | 0        |
    And I close the current editor

# Lagerjournaleintrag prüfen
    Given I open the infosystem "LJ"
    And I set field "beleg" to "barmex" from editor "Rückmeldung1"
    And I set field "richtung" to "rückwärts"
    And I press start
    Then table has values
      | art       | amge | zmge | rueckmge | restmge | vcharge^such | !row |
      | EINKAUF-1 | 10   |      | 10       | 0       | MAT01-01     | 1    |
      | EINKAUF-2 | 5    |      | 5        | 0       | MAT02-01     | 2    |
      | EINKAUF-1 | -10  |      | -10      | 0       | MAT01-01     | 3    |
      | EINKAUF-2 | -5   |      | -5       | 0       | MAT02-01     | 4    |
      | BAUGRUPPE |      | 8    | 0        | 8       |              | 5    |
      | EINKAUF-1 | 6    |      | 0        | 6       | MAT01-02     | 6    |
      | EINKAUF-1 | 10   |      | 0        | 10      | MAT01-01     | 7    |
      | EINKAUF-2 | 3    |      | 0        | 3       | MAT02-02     | 8    |
      | EINKAUF-2 | 5    |      | 0        | 5       | MAT02-01     | 9    |
    Then field "stornolj^id" in row 1 has value equal to field "verweis^id" from editor "LJ" in row 3
    Then field "stornolj^id" in row 2 has value equal to field "verweis^id" from editor "LJ" in row 4
    And I close the current editor

# Betriebsauftrag abschließen und Auftrag liefern
    Given I open an editor "Rückmeldung1" from table "(Workorder):(WorkOrders)" with command "DONE" for record "CHARGERED_001"
    And I set fields
      | sofort  | ja |
      | gut     | ja |
      | manrest | ja |
    And I save the current editor
    And I deliver the SalesOrder "auftrag" with PackingSlip "LS-RED05"


  Scenario: 06 Storno eines Rückbaus von Material mit Chargen, manbu=ja, keine Gutmenge auf BA
    Given I set the fake date to "07.01.95"
# Bestand auf 0 korrigieren
    Given I set StorageQuantity to zero for Product "EINKAUF-1" on StorageLocation "F1" with document "SCEN-06"

    # Chargen anlegen
    Given I create a Lot "MAT01-03" for Product "EINKAUF-1"
    Given I create a Lot "MAT01-04" for Product "EINKAUF-1"
    Given I create a Lot "MAT02-03" for Product "EINKAUF-2"
    Given I create a Lot "MAT02-04" for Product "EINKAUF-2"

# Auftrag anlegen und Bedarfe einkaufen
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
    And I press button "abv" to open a subeditor for "NächsterArtikel"
    And I close the current editor
    And I switch the current editor to editor "EntnahmeMZ"
    And I modify table
      | !row | zuomge | charge       |
      | +1   | 5      | !MAT02-03^id |
      | +2   | 5      | !MAT02-04^id |
    And I save the current editor
    And I switch the current editor to editor "fvor"
    And I set field "bisuch" to "CHARGEMANSR_" in row !lastRow
    And I press button "freig" to open a subeditor for "BA_freigeben"
    And I close the current editor
    And I switch the current editor to editor "fvor"
    And I save the current editor

# Materialentnahme über gesamte Menge und Rückgabe Teilmenge
    Given I open an editor "Fbuchung1" for tip command "Fbuchung" and arguments ""
    And I set field "auftrag" to "$,,such=CHARGEMANSR_001;@richtung=rückwärts;@maxtreffer=1"
    And I set field "bem" to "Entnahme"
    And I press button "stllad"
    And I save the current editor

    Given I open an editor "Materialentnahme1" from table "(Workorder):(CompletionConfirmations)" with command "VIEW" for search criteria "$,,such=CHARGEMANSR_001;bem=Entnahme;@ablageart=abgelegt;@richtung=rückwärts;@maxtreffer=1"
    And I close the current editor

    Given I open an editor "Fbuchung2" for tip command "Fbuchung" and arguments ""
    And I set field "auftrag" to "$,,such=CHARGEMANSR_001;@richtung=rückwärts;@maxtreffer=1"
    And I set fields
      | gmgevorschl | -5       |
      | bem         | Rückgabe |
    And I press button "stllad"
    And I modify table
      | !row | rescharge    |
      | 1    | !MAT01-04^id |
      | 2    | !MAT02-03^id |
    And I save the current editor

    Given I open an editor "Rückgabe1" from table "(Workorder):(CompletionConfirmations)" with command "VIEW" for search criteria "$,,such=CHARGEMANSR_001;bem=Rückgabe;@ablageart=abgelegt;@richtung=rückwärts;@maxtreffer=1"
    And I close the current editor

# Storno Materialrückgabe
    Given I open an editor "Storno1_Rückgabe" via ID from editor "Rückgabe1" from field "id" in row 0 for table "(Workorder):(CompletionConfirmations)" with command "REVERSAL"
    And I save the current editor

# Bestand prüfen
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

# Belege zu Storno, Materialentnahmme und -rückgabe prüfen
    Given I switch the current editor to editor "Storno1_Rückgabe" with command "VIEW"
    Then the table has 3 rows
    Then table has values
      | mge | artikel     | rueckmge | restmge | limgev | limgen |
      | 10  | M_BAUGRUPPE | 0        | 0       | 0      | 0      |
      | 5   | EINKAUF-2   | 0        | 5       | 5      | 0      |
      | 10  | EINKAUF-1   | 0        | 10      | 10     | 0      |
    And I close the current editor

    Given I switch the current editor to editor "Rückgabe1" with command "VIEW"
    Then the table has 3 rows
    Then table has values
      | mge | artikel     | rueckmge | restmge | limgev | limgen |
      | 10  | M_BAUGRUPPE | 0        | 0       | 0      | 0      |
      | -5  | EINKAUF-2   | -5       | 0       | 0      | 5      |
      | -10 | EINKAUF-1   | -10      | 0       | 0      | 10     |
    And I close the current editor

    Given I switch the current editor to editor "Materialentnahme1" with command "VIEW"
    Then the table has 3 rows
    Then table has values
      | mge | artikel     | rueckmge | restmge | limgev | limgen |
      | 10  | M_BAUGRUPPE | 0        | 0       | 0      | 0      |
      | 10  | EINKAUF-2   | 0        | 10      | 10     | 0      |
      | 20  | EINKAUF-1   | 0        | 20      | 20     | 0      |
    And I close the current editor

# Lagerjournaleintrag prüfen
    Given I open the infosystem "LJ"
    And I set field "beleg" to "barmex" from editor "Materialentnahme1"
    And I set field "richtung" to "rückwärts"
    And I press start
    Then table has values
      | art       | amge | rueckmge | restmge | vcharge^such | !row | detursache                        |
      | EINKAUF-1 | 10   | 10       | 0       | MAT01-04     | 1    | Storno-Materialrückgabe Fertigung |
      | EINKAUF-2 | 5    | 5        | 0       | MAT02-03     | 2    | Storno-Materialrückgabe Fertigung |
      | EINKAUF-1 | -10  | -10      | 0       | MAT01-04     | 3    | Materialrückgabe Fertigung        |
      | EINKAUF-2 | -5   | -5       | 0       | MAT02-03     | 4    | Materialrückgabe Fertigung        |
      | EINKAUF-1 | 10   | 0        | 10      | MAT01-04     | 5    | Materialentnahme Fertigung        |
      | EINKAUF-1 | 10   | 0        | 10      | MAT01-03     | 6    | Materialentnahme Fertigung        |
      | EINKAUF-2 | 5    | 0        | 5       | MAT02-04     | 7    | Materialentnahme Fertigung        |
      | EINKAUF-2 | 5    | 0        | 5       | MAT02-03     | 8    | Materialentnahme Fertigung        |
    Then field "stornolj^id" in row 1 has value equal to field "verweis^id" from editor "LJ" in row 3
    Then field "stornolj^id" in row 2 has value equal to field "verweis^id" from editor "LJ" in row 4
    And I close the current editor

# Betriebsauftrag abschließen
    Given I open an editor "Rückmeldung1" from table "(Workorder):(WorkOrders)" with command "DONE" for record "CHARGEMANSR_001"
    And I set fields
      | sofort  | ja |
      | gut     | ja |
      | manrest | ja |
    And I save the current editor

# Bestand prüfen und Auftrag liefern
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

    And I deliver the SalesOrder "auftrag" with PackingSlip "LS-MAN06"


  Scenario: 07 Storno eines Rückbaus, nachdem eine erneute Entnahme gebucht wurde, manbu=ja, kein Gutmenge auf BA
    Given I set the fake date to "08.01.95"
# Bestand auf 0 korrigieren
    Given I set StorageQuantity to zero for Product "EINKAUF-1" on StorageLocation "F1" with document "SCEN-07"

# Chargen anlegen
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
      | EINKAUF-1 | 20  | !GOOD_CH^id |
      | EINKAUF-1 | 20  | !BAD_CH^id  |
      | EINKAUF-2 | 10  |             |
    And I set field "verw" in row 1 to "verw" from editor "auftrag" in row 1
    And I set field "verw" in row 3 to "verw" from editor "auftrag" in row 1
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

# Materialentnahme über gesamte Gutmenge und Rückgabe der gesamten Menge
    Given I open an editor "Fbuchung1" for tip command "Fbuchung" and arguments ""
    And I set field "auftrag" to "$,,such=AUSTAUSCH_001;@richtung=rückwärts;@maxtreffer=1"
    And I set field "bem" to "Entnahme1"
    And I press button "stllad"
    And I save the current editor

    Given I open an editor "Materialentnahme1" from table "(Workorder):(CompletionConfirmations)" with command "VIEW" for search criteria "$,,such=AUSTAUSCH_001;bem=Entnahme1;@ablageart=abgelegt;@richtung=rückwärts;@maxtreffer=1"
    And I close the current editor

    Given I open an editor "Fbuchung2" for tip command "Fbuchung" and arguments ""
    And I set field "auftrag" to "$,,such=AUSTAUSCH_001;@richtung=rückwärts;@maxtreffer=1"
    And I press button "stllad"
    And I set field "bem" to "Rückgabe"
    And I modify table
      | !row | bumge | rescharge  |
      | 1    | -20   | !BAD_CH^id |
    And I save the current editor

    Given I open an editor "Materialrückgabe1" from table "(Workorder):(CompletionConfirmations)" with command "VIEW" for search criteria "$,,such=AUSTAUSCH_001;bem=Rückgabe;@ablageart=abgelegt;@richtung=rückwärts;@maxtreffer=1"
    And I close the current editor

# Zweite Charge entnehmen
    Given I open an editor "Fbuchung3" for tip command "Fbuchung" and arguments ""
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
	And I switch the current editor to editor "Fbuchung3"
    And I save the current editor

    Given I open an editor "Materialentnahme2" from table "(Workorder):(CompletionConfirmations)" with command "VIEW" for search criteria "$,,such=AUSTAUSCH_001;bem=Entnahme2;@ablageart=abgelegt;@richtung=rückwärts;@maxtreffer=1"
    And I close the current editor

      # Storno des Rückbaus
    Given I open an editor "Storno1_Rückgabe" via ID from editor "Materialrückgabe1" from field "id" in row 0 for table "(Workorder):(CompletionConfirmations)" with command "REVERSAL"
    And I save the current editor

# Belege zu Storno und Materialrückgabe prüfen
    Given I switch the current editor to editor "Storno1_Rückgabe" with command "VIEW"
    Then the table has 2 rows
    Then table has values
      | mge | artikel     | rueckmge | restmge | limgev | limgen |
      | 10  | M_BAUGRUPPE | 0        | 0       | 0      | 0      |
      | 20  | EINKAUF-1   | 0        | 20      | 10     | -10    |
    And I close the current editor

    Given I switch the current editor to editor "Materialrückgabe1" with command "VIEW"
    Then the table has 2 rows
    Then table has values
      | mge | artikel     | rueckmge | restmge | limgev | limgen |
      | 10  | M_BAUGRUPPE | 0        | 0       | 0      | 0      |
      | -20 | EINKAUF-1   | -20      | 0       | 0      | 20     |
    And I close the current editor

    Given I switch the current editor to editor "Materialentnahme1" with command "VIEW"
    Then the table has 3 rows
    Then table has values
      | mge | artikel     | rueckmge | restmge | limgev | limgen |
      | 10  | M_BAUGRUPPE | 0        | 0       | 0      | 0      |
      | 10  | EINKAUF-2   | 0        | 10      | 10     | 0      |
      | 20  | EINKAUF-1   | 0        | 20      | 20     | 0      |
    And I close the current editor

    Given I switch the current editor to editor "Materialentnahme2" with command "VIEW"
    Then the table has 2 rows
    Then table has values
      | mge | artikel     | rueckmge | restmge | limgev | limgen |
      | 10  | M_BAUGRUPPE | 0        | 0       | 0      | 0      |
      | 10  | EINKAUF-1   | 0        | 10      | 20     | 10     |
    And I close the current editor

# Lagerjournaleintrag prüfen
    Given I open the infosystem "LJ"
    And I set field "beleg" to "barmex" from editor "Materialentnahme1"
    And I set field "richtung" to "rückwärts"
    And I press start
    Then table has values
      | art       | amge | rueckmge | restmge | vcharge^such | !row |
      | EINKAUF-1 | 20   | 20       | 0       | BAD_CH       | 1    |
      | EINKAUF-1 | 10   | 0        | 10      | GOOD_CH      | 2    |
      | EINKAUF-1 | -20  | -20      | 0       | BAD_CH       | 3    |
      | EINKAUF-1 | 20   | 0        | 20      | BAD_CH       | 4    |
      | EINKAUF-2 | 10   | 0        | 10      |              | 5    |
    Then field "stornolj^id" in row 1 has value equal to field "verweis^id" from editor "LJ" in row 3
    And I close the current editor

# Bestand pürfen
    Given I open the infosystem "BESTAND"
    And I set fields
      | artikel    | EINKAUF-1 |
      | klplatz    | F1        |
      | verdichten | nein      |
      | details    | nein      |
    And I press start
    And I press button "taufzu" in row 1
    Then the table has 2 rows
    Then table has values
      | lemge | gebmge | charge^such |
      | 10    |        |             |
      |       | 10     | GOOD_CH     |
    And I close the current editor

# Betriebsauftrag abschließen und Auftrag liefern
    Given I open an editor "Rückmeldung1" from table "(Workorder):(WorkOrders)" with command "DONE" for record "AUSTAUSCH_001"
    And I set fields
      | sofort  | ja |
      | gut     | ja |
      | manrest | ja |
    And I save the current editor
    And I deliver the SalesOrder "auftrag" with PackingSlip "LS-MAN07"


  Scenario: 08 Storno einer Teil-Rückgabe von entnommenen Material, das über mehrere Materialentnahmen und manrest=ja gebucht wurde, manbu=ja, Gutmenge auf dem AS
    Given I set the fake date to "09.01.95"
# Auftrag anlegen und Bedarfe einkaufen
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

# Materialentnahmen über Teilmengen und Rückmeldung, Teil-Rückgabe des entnommenen Maetrials
    Given I open an editor "Fbuchung1" for tip command "Fbuchung" and arguments ""
    And I set fields
      | auftrag     | !Arbeitsschein1^nummer |
      | bem         | Entnahme1              |
      | gmgevorschl | 10                     |
    And I press button "stllad"
    And I save the current editor

    And I wait 1 time units to move the time forward

    Given I open an editor "Materialentnahme1" from table "(Workorder):(CompletionConfirmations)" with command "VIEW" for search criteria "$,,such=MANREST_001;bem=Entnahme1;@ablageart=abgelegt;@richtung=rückwärts;@maxtreffer=1"
    And I close the current editor

    Given I open an editor "Fbuchung2" for tip command "Fbuchung" and arguments ""
    And I set fields
      | auftrag     | !Arbeitsschein1^nummer |
      | bem         | Entnahme2              |
      | gmgevorschl | 20                     |
    And I press button "stllad"
    And I save the current editor

    And I wait 1 time units to move the time forward

    Given I open an editor "Materialentnahme2" from table "(Workorder):(CompletionConfirmations)" with command "VIEW" for search criteria "$,,such=MANREST_001;bem=Entnahme2;@ablageart=abgelegt;@richtung=rückwärts;@maxtreffer=1"
    And I close the current editor

    Given I open an editor "Rückmeldung1" from table "(Workorder):(WorkOrders)" with command "DONE" for record "MANREST_001"
    And I set fields
      | sofort  | ja |
      | manrest | ja |
    And I set field "gutmge" to "35" in row 1
    And I save the current editor

    Given I open an editor "Fbuchung3" for tip command "Fbuchung" and arguments ""
    And I set field "auftrag" to "!Arbeitsschein1^nummer"
    And I set field "gmgevorschl" to "-33"
    And I press button "stllad"
    And I set field "bem" to "M-Rückgabe"
    And I modify table
      | !row              | bumge |
      | elex=='EINKAUF-1' | -50   |
      | elex=='EINKAUF-2' | -33   |
    And I save the current editor

    Given I open an editor "Materialrückgabe1" from table "(Workorder):(CompletionConfirmations)" with command "VIEW" for search criteria "$,,such=MANREST_001;bem=M-Rückgabe;@ablageart=abgelegt;@richtung=rückwärts;@maxtreffer=1"
    And I close the current editor

# Materialrückgabe stornieren
    Given I open an editor "Storno1_Rückgabe" via ID from editor "Materialrückgabe1" from field "id" in row 0 for table "(Workorder):(CompletionConfirmations)" with command "REVERSAL"
    And I save the current editor

# Belege zu Storno, Materialentnahmme und -rückgabe prüfen
    Given I switch the current editor to editor "Storno1_Rückgabe" with command "VIEW"
    Then table has values
      | mge | artikel     | rueckmge | restmge | limgev | limgen |
      | 15  | M_BAUGRUPPE | 0        | 0       | 0      | 0      |
      | 33  | EINKAUF-2   | 0        | 33      | 33     | 0      |
      | 50  | EINKAUF-1   | 0        | 50      | 50     | 0      |
    And I close the current editor

    Given I switch the current editor to editor "Materialrückgabe1" with command "VIEW"
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
      | 20  | 0      | EINKAUF-2   | 0        | 20      | 20     | 0      |
      | 40  | 0      | EINKAUF-1   | 0        | 40      | 40     | 0      |
    And I close the current editor

    Given I switch the current editor to editor "Materialentnahme2" with command "VIEW"
    Then the table has 3 rows
    Then table has values
      | mge | artikel     | rueckmge | restmge | limgev | limgen |
      | 50  | M_BAUGRUPPE | 0        | 0       | 0      | 0      |
      | 20  | EINKAUF-2   | 0        | 20      | 40     | 20     |
      | 40  | EINKAUF-1   | 0        | 40      | 80     | 40     |
    And I close the current editor

    Given I switch the current editor to editor "Materialentnahme1" with command "VIEW"
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
      | art         | amge | zmge | rueckmge | restmge | !row | detursache                        |
      | EINKAUF-1   | 40   |      | 40       | 0       | 1    | Storno-Materialrückgabe Fertigung |
      | EINKAUF-1   | 10   |      | 10       | 0       | 2    | Storno-Materialrückgabe Fertigung |
      | EINKAUF-2   | 20   |      | 20       | 0       | 3    | Storno-Materialrückgabe Fertigung |
      | EINKAUF-2   | 13   |      | 13       | 0       | 4    | Storno-Materialrückgabe Fertigung |
      | EINKAUF-1   | -10  |      | -10      | 0       | 5    | Materialrückgabe Fertigung        |
      | EINKAUF-1   | -40  |      | -40      | 0       | 6    | Materialrückgabe Fertigung        |
      | EINKAUF-2   | -13  |      | -13      | 0       | 7    | Materialrückgabe Fertigung        |
      | EINKAUF-2   | -20  |      | -20      | 0       | 8    | Materialrückgabe Fertigung        |
      | M_BAUGRUPPE |      | 35   | 0        | 35      | 9    | Rückmeldung Fertigung             |
      | EINKAUF-1   | 40   |      | 0        | 40      | 10   | Rückmeldung Fertigung             |
      | EINKAUF-2   | 20   |      | 0        | 20      | 11   | Rückmeldung Fertigung             |
      | EINKAUF-1   | 40   |      | 0        | 40      | 12   | Materialentnahme Fertigung        |
      | EINKAUF-2   | 20   |      | 0        | 20      | 13   | Materialentnahme Fertigung        |
      | EINKAUF-1   | 20   |      | 0        | 20      | 14   | Materialentnahme Fertigung        |
      | EINKAUF-2   | 10   |      | 0        | 10      | 15   | Materialentnahme Fertigung        |
    Then field "stornolj^id" in row 1 has value equal to field "verweis^id" from editor "LJ" in row 6
    Then field "stornolj^id" in row 2 has value equal to field "verweis^id" from editor "LJ" in row 5
    Then field "stornolj^id" in row 3 has value equal to field "verweis^id" from editor "LJ" in row 8
    Then field "stornolj^id" in row 4 has value equal to field "verweis^id" from editor "LJ" in row 7
    And I close the current editor

# Betriebsauftrag abschließen und Auftrag liefern
    Given I open an editor "Rückmeldung2" from table "(Workorder):(WorkOrders)" with command "DONE" for record "MANREST_001"
    And I set fields
      | sofort  | ja |
      | gut     | ja |
      | manrest | ja |
    And I save the current editor
    And I deliver the SalesOrder "auftrag" with PackingSlip "LS-MAN08"


  Scenario: 09 Storno von Rückgaben von entnommenen Material mit Handelseinheiten, manbu=ja, keine Gutmenge auf AS^, EntnahmeMZ für Komponente mit Gebindepflicht
    Given I set the fake date to "10.01.95"
# Bestände korrigieren
    Given I set StorageQuantity to zero for Product "GEBINDE" on StorageLocation "F1" with document "SCEN-09"
    Given I set StorageQuantity to zero for Product "GEBINDEPFL" on StorageLocation "F1" with document "SCEN-09"
    Given I set StorageQuantity to zero for Product "BG-GEBINDE" on StorageLocation "F1" with document "SCEN-09"

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
    And I press button "mzabsm" to open a subeditor for "EntnahmeMZ" in row 1
    And I press button "abv" to open a subeditor for "NächsterArtikel"
    And I close the current editor
    And I switch the current editor to editor "EntnahmeMZ"
    And I modify table
      | !row | zuomge | einh |
      | +1   | 5      | Paar |
    And I save the current editor
    And I switch the current editor to editor "fvor"
    And I set field "bisuch" to "GEBINDE_" in row 1
    And I press button "freig" to open a subeditor for "BA_freigeben"
    And I close the current editor
    And I switch the current editor to editor "fvor"
    And I save the current editor

# Materialentnahme über gesamte Gutmenge und Teil-Rückgabe in verschiedenen Einheiten
    Given I open an editor "Materialentnahme1" for tip command "Fbuchung" and arguments ""
    And I set field "auftrag" to "$,,such=GEBINDE_001;@richtung=rückwärts;@maxtreffer=1"
    And I set field "bem" to "Entnahme"
    And I press button "stllad"
    And I modify table
      | !row | bumge | bueinh |
      | 1    | 10    | Stück  |
      | 2    | 5     | Paar   |
    And I save the current editor

    Given I open an editor "Materialentnahme1" from table "(Workorder):(CompletionConfirmations)" with command "VIEW" for search criteria "$,,such=GEBINDE_001;bem=Entnahme;@ablageart=abgelegt;@richtung=rückwärts;@maxtreffer=1"
    And I close the current editor

  # in Lagerheinheit, 1 Stück GEBINDE, 1 Stück GEBINDEPFL

    And I wait 1 time units to move the time forward
    Given I open an editor "Materialrückgabe1" for tip command "Fbuchung" and arguments ""
    And I set fields
      | auftrag     | $,,such=GEBINDE_001;@richtung=rückwärts;@maxtreffer=1 |
      | gmgevorschl | -1                                                    |
      | bem         | Rückgabe2                                             |
    And I press button "stllad"
    And I save the current editor

    Given I open an editor "Materialrückgabe1" from table "(Workorder):(CompletionConfirmations)" with command "VIEW" for search criteria "$,,such=GEBINDE_001;bem=Rückgabe2;@ablageart=abgelegt;@richtung=rückwärts;@maxtreffer=1"
    And I close the current editor

  # in Handelseinheit, 1 kg (0,2 Stück), 1 Paar (2 Stück)

    And I wait 1 time units to move the time forward
    Given I open an editor "Materialrückgabe2" for tip command "Fbuchung" and arguments ""
    And I set fields
      | auftrag     | $,,such=GEBINDE_001;@richtung=rückwärts;@maxtreffer=1 |
      | gmgevorschl | -1                                                    |
      | bem         | Rückgabe3                                             |
    And I press button "stllad"
    And I modify table
      | !row | bueinh |
      | 1    | kg     |
      | 2    | Paar   |
    And I save the current editor

    Given I open the infosystem "BESTAND"
    And I set fields
      | artikel    | GEBINDE |
      | verdichten | ja      |
      | details    | nein    |
    And I press start
    And I press button "taufzu" in row 1
    Then the table has 2 rows
    Then table has values
      | lemge | leinheit | gebmge | geinheit |
      | 1.2   | Stück    |        |          |
      |       |          | 1.2    | Stück    |
    And I set fields
      | artikel    | GEBINDEPFL |
      | verdichten | nein       |
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

    Given I open an editor "Materialrückgabe2" from table "(Workorder):(CompletionConfirmations)" with command "VIEW" for search criteria "$,,such=GEBINDE_001;bem=Rückgabe3;@ablageart=abgelegt;@richtung=rückwärts;@maxtreffer=1"
    And I close the current editor

# Storno der Materialrückgaben und Bestände prüfen
  # in Lagereinheit
    Given I open an editor "Storno1_Rückgabe" via ID from editor "Materialrückgabe1" from field "id" in row 0 for table "(Workorder):(CompletionConfirmations)" with command "REVERSAL"
    And I save the current editor

    Given I open the infosystem "BESTAND"
    And I set fields
      | artikel    | GEBINDE |
      | verdichten | nein    |
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
      | details    | nein       |
    And I press start
    And I press button "taufzu" in row 1
    Then the table has 2 rows
    Then table has values
      | lemge | leinheit | gebmge | geinheit |
      | 2     | Stück    |        |          |
      |       |          | 1      | Paar     |
    And I close the current editor

  # in Handelseinheit
    Given I open an editor "Storno2_Rückgabe" via ID from editor "Materialrückgabe2" from field "id" in row 0 for table "(Workorder):(CompletionConfirmations)" with command "REVERSAL"
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

# Belege zu Storno, Materialentnahmme und -rückgabe prüfen
    Given I switch the current editor to editor "Materialentnahme1" with command "VIEW"
    Then the table has 3 rows
    Then table has values
      | mge | artikel    | rueckmge | restmge | limgev | limgen |
      | 10  | BG-GEBINDE | 0        | 0       | 0      | 0      |
      | 10  | GEBINDEPFL | 0        | 10      | 10     | 0      |
      | 10  | GEBINDE    | 0        | 10      | 10     | 0      |
    And I close the current editor

    Given I switch the current editor to editor "Materialrückgabe1" with command "VIEW"
    Then the table has 3 rows
    Then table has values
      | mge | artikel    | rueckmge | restmge | limgev | limgen |
      | 10  | BG-GEBINDE | 0        | 0       | 0      | 0      |
      | -1  | GEBINDEPFL | -1       | 0       | 0      | 1      |
      | -1  | GEBINDE    | -1       | 0       | 0      | 1      |
    And I close the current editor

    Given I switch the current editor to editor "Storno1_Rückgabe" with command "VIEW"
    Then the table has 3 rows
    Then table has values
      | mge | artikel    | rueckmge | restmge | limgev | limgen |
      | 10  | BG-GEBINDE | 0        | 0       | 0      | 0      |
      | 1   | GEBINDEPFL | 0        | 1       | 3      | 2      |
      | 1   | GEBINDE    | 0        | 1       | 1.2    | 0.2    |
    And I close the current editor

    Given I switch the current editor to editor "Materialrückgabe2" with command "VIEW"
    Then the table has 3 rows
    Then table has values
      | mge  | artikel    | rueckmge | restmge | limgev | limgen |
      | 10   | BG-GEBINDE | 0        | 0       | 0      | 0      |
      | -2   | GEBINDEPFL | -2       | 0       | 1      | 3      |
      | -0.2 | GEBINDE    | -0.2     | 0       | 1      | 1.2    |
    And I close the current editor

    Given I switch the current editor to editor "Storno2_Rückgabe" with command "VIEW"
    Then the table has 3 rows
    Then table has values
      | mge | artikel    | rueckmge | restmge | limgev | limgen |
      | 10  | BG-GEBINDE | 0        | 0       | 0      | 0      |
      | 2   | GEBINDEPFL | 0        | 2       | 2      | 0      |
      | 0.2 | GEBINDE    | 0        | 0.2     | 0.2    | 0      |
    And I close the current editor

# Betriebsauftrag abschließen und Auftrag liefern
    Given I open an editor "Rückmeldung1" from table "(Workorder):(WorkOrders)" with command "DONE" for record "GEBINDE_001"
    And I set fields
      | sofort | ja |
      | gut    | ja |
    And I save the current editor
    And I deliver the SalesOrder "auftrag" with PackingSlip "LS-MAN09"

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


  Scenario: 10 Storno eines Rückbaus, der das Material in gefüllte oder leere Behälter gebucht hat, manbu=ja, keine Gutmenge auf AS
    Given I set the fake date to "11.01.95"
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
      | !row | zuomge | behaelter       |
      | +1   | 10     | !B_MATERIAL1^id |
      | +2   | 10     | !B_MATERIAL2^id |
    And I press button "abv" to open a subeditor for "NächsterArtikel"
    And I close the current editor
    And I switch the current editor to editor "EntnahmeMZ"
    And I modify table
      | !row | zuomge | behaelter       |
      | +1   | 5      | !B_MATERIAL3^id |
      | +2   | 5      |                 |
    And I save the current editor
    And I switch the current editor to editor "fvor"
    And I set field "bisuch" to "BEHAELTER_" in row !lastRow
    And I press button "freig" to open a subeditor for "BA_freigeben"
    And I close the current editor
    And I switch the current editor to editor "fvor"
    And I save the current editor

    Given I open an editor "Arbeitsschein1" from table "(Workorder):(WorkOrders)" with command "VIEW" for record "BEHAELTER_001"
    And I close the current editor

# Materialentnahme Teilmenge und Teil-Rückgabe in gefüllten und leeren Behälter
    Given I open an editor "Materialentnahme1" for tip command "Fbuchung" and arguments ""
    And I set fields
      | auftrag     | !Arbeitsschein1^nummer |
      | gmgevorschl | 5                      |
      | bem         | Entnahme1              |
    And I press button "stllad"
    And I save the current editor

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
    And I save the current editor

    Given I open an editor "Rückgabe1" from table "(Workorder):(CompletionConfirmations)" with command "VIEW" for search criteria "$,,such=BEHAELTER_001;bem=Rückgabe;@richtung=rückwärts;@ablageart=abgelegt;@maxtreffer=1"
    And I close the current editor

# Storno Materialrückgabe
    Given I open an editor "Storno1_Rückgabe" via ID from editor "Rückgabe1" from field "id" in row 0 for table "(Workorder):(CompletionConfirmations)" with command "REVERSAL"
    And I save the current editor

# Behälter prüfen
    Then Container from editor "B_MATERIAL1" is empty
    Then Container from editor "B_MATERIAL3" is empty
    Then Container from editor "B_LEER" is empty

    And I switch the current editor to editor "B_MATERIAL2" with command "VIEW"
    Then the table has 1 rows
    Then table has values
      | artikel   | mge |
      | EINKAUF-1 | 10  |
    And I close the current editor

# LJ prüfen
    Given I open the infosystem "LJ"
    And I set field "beleg" to "nummer" from editor "Arbeitsschein1"
    And I set field "richtung" to "rückwärts"
    And I press start
    Then table has values
      | art       | amge | zmge | rueckmge | restmge | !row | behaelter^id    |
      | EINKAUF-1 | 4    |      | 4        | 0       | 1    | !B_MATERIAL2^id |
      | EINKAUF-2 | 2    |      | 2        | 0       | 2    | !B_LEER^id      |
      | EINKAUF-1 | -4   |      | -4       | 0       | 3    | !B_MATERIAL2^id |
      | EINKAUF-2 | -2   |      | -2       | 0       | 4    | !B_LEER^id      |
      | EINKAUF-1 | 10   |      | 0        | 10      | 5    | !B_MATERIAL1^id |
      | EINKAUF-2 | 5    |      | 0        | 5       | 6    | !B_MATERIAL3^id |
    And I close the current editor

# Materialentnahme und Rückmeldung auf ersten AG
    Given I open an editor "Materialentnahme2" for tip command "Fbuchung" and arguments ""
    And I set fields
      | auftrag | !Arbeitsschein1^nummer |
      | bem     | Entnahme2              |
    And I press button "stllad"
    And I modify table
      | !row | behaelter       |
      | 1    | !B_MATERIAL2^id |
      | 2    |                 |
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


  Scenario: 11 Storno einer Materialrückgabe mit Einheiten, Chargen und Behältern, manbu=ja, Gutmenge auf AS
    Given I set the fake date to "12.01.95"
# Bestand auf 0 korrigieren
    Given I set StorageQuantity to zero for Product "GEBINDE" on StorageLocation "F1" with document "SCEN-11"
    Given I set StorageQuantity to zero for Product "GEBINDEPFL" on StorageLocation "F1" with document "SCEN-11"

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
      | ebeleg | R-11    |
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

# Materialentnahme Teilmenge und Rückgabe in gefüllten Behälter
    Given I open an editor "Materialentnahme1" for tip command "Fbuchung" and arguments ""
    And I set fields
      | auftrag     | !Arbeitsschein1^nummer |
      | gmgevorschl | 8                      |
      | bem         | Entnahme1              |
    And I press button "stllad"
    And I save the current editor

    Given I open an editor "Rückgabe1" for tip command "Fbuchung" and arguments ""
    And I set fields
      | auftrag     | !Arbeitsschein1^nummer |
      | gmgevorschl | -2                     |
      | bem         | Rückgabe               |
    And I press button "stllad"
    And I modify table
      | !row | rescharge   | behaelter       | bumge       | bueinh      |
      | 1    | !CH_9876^id | !B_MATERIAL1^id | !dontChange | !dontChange |
      | 2    | !CH_5555^id | !B_MATERIAL1^id | -1          | Paar        |
    And I save the current editor

    Given I open an editor "Rückgabe1" from table "(Workorder):(CompletionConfirmations)" with command "VIEW" for search criteria "$,,such=GEBBEH_001;bem=Rückgabe;@richtung=rückwärts;@ablageart=abgelegt;@maxtreffer=1"
    And I close the current editor

    # Storno der Rückgabe und Behälter prüfen
    Given I open an editor "Storno1_Rückgabe" via ID from editor "Rückgabe1" from field "id" in row 0 for table "(Workorder):(CompletionConfirmations)" with command "REVERSAL"
    And I save the current editor

    And I switch the current editor to editor "B_MATERIAL1" with command "VIEW"
    Then the table has 2 rows
    Then table has values
      | artikel    | mge | charge^such | gebeinh |
      | GEBINDE    | 2   | CH_9876     | Stück   |
      | GEBINDEPFL | 1   | CH_5555     | Paar    |
    And I close the current editor

# LJ prüfen
    Given I open the infosystem "LJ"
    And I set field "beleg" to "nummer" from editor "Arbeitsschein1"
    And I set field "richtung" to "rückwärts"
    And I press start
    Then table has values
      | art        | amge | zmge | rueckmge | restmge | lei   | mei   | vcharge^such | behaelter^id    | !row |
      | GEBINDE    | 2    |      | 2        | 0       | Stück | Stück | CH_9876      | !B_MATERIAL1^id | 1    |
      | GEBINDEPFL | 1    |      | 2        | 0       | Stück | Paar  | CH_5555      | !B_MATERIAL1^id | 2    |
      | GEBINDE    | -2   |      | -2       | 0       | Stück | Stück | CH_9876      | !B_MATERIAL1^id | 3    |
      | GEBINDEPFL | -1   |      | -2       | 0       | Stück | Paar  | CH_5555      | !B_MATERIAL1^id | 4    |
      | GEBINDE    | 40   |      | 0        | 8       | Stück | kg    | CH_9876      | !B_MATERIAL1^id | 5    |
      | GEBINDEPFL | 4    |      | 0        | 8       | Stück | Paar  | CH_5555      | !B_MATERIAL1^id | 6    |
    And I close the current editor

# Materialentnahme und Rückmeldung auf ersten AG
    Given I open an editor "Materialentnahme2" for tip command "Fbuchung" and arguments ""
    And I set fields
      | auftrag | !Arbeitsschein1^nummer |
      | bem     | Entnahme2              |
    And I press button "stllad"
    And I modify table
      | bumge       | bueinh      | rescharge   | behaelter       | !row                  |
      | !dontChange | !dontChange | !CH_9876^id | !B_MATERIAL1^id | artikel=='GEBINDE'    |
      | 1           | Paar        | !CH_5555^id | !B_MATERIAL1^id | artikel=='GEBINDEPFL' |
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


  Scenario: 13 Storno einer Materialrückgabe über Rückmeldung und Fbuchung von zusätzlich entnommenem Material
    Given I set the fake date to "14.01.95"
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
      | EINKAUF-3 | 6   |
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
      | EINKAUF-3   | 6           | !dontChange | +2                   |
    And I save the current editor

# Materialrückgabe über Rückmeldung und Fbuchung
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

    Given I open an editor "Rückgabe2" for tip command "Fbuchung" and arguments ""
    And I set fields
      | auftrag | $,,such=RÜCKM_001;@richtung=rückwärts;@maxtreffer=1 |
      | bem     | Rückgabe-2                                          |
    And I press button "stllad"
    And I modify table
      | !row                 | bumge |
      | artikel=='EINKAUF-3' | -3    |
    And I save the current editor

    Given I open an editor "Rückgabe2" from table "(Workorder):(CompletionConfirmations)" with command "VIEW" for search criteria "$,,such=RÜCKM_001;bem=Rückgabe-2;@richtung=rückwärts;@ablageart=abgelegt;@maxtreffer=1"
    And I close the current editor

# Storno der Rückgaben
    Given I open an editor "Storno2_Rückbau" via ID from editor "Rückgabe2" from field "id" in row 0 for table "(Workorder):(CompletionConfirmations)" with command "REVERSAL"
    And I save the current editor

    Given I open an editor "Storno1_Rückbau" via ID from editor "Rückgabe1" from field "id" in row 0 for table "(Workorder):(CompletionConfirmations)" with command "REVERSAL"
    And I save the current editor

# LJ prüfen
    Given I open the infosystem "LJ"
    And I set field "beleg" to "nummer" from editor "Rückmeldung1"
    And I set field "richtung" to "rückwärts"
    And I press start
    Then table has values
      | art       | amge | zmge | rueckmge | restmge | !row |
      | BAUGRUPPE |      | 1    | 1        | 0       | 1    |
      | EINKAUF-1 | 2    |      | 2        | 0       | 2    |
      | EINKAUF-2 | 1    |      | 1        | 0       | 3    |
      | EINKAUF-3 | 3    |      | 3        | 0       | 4    |
      | EINKAUF-3 | 3    |      | 3        | 0       | 5    |
      | EINKAUF-3 | -3   |      | -3       | 0       | 6    |
      | BAUGRUPPE |      | -1   | -1       | 0       | 7    |
      | EINKAUF-1 | -2   |      | -2       | 0       | 8    |
      | EINKAUF-2 | -1   |      | -1       | 0       | 9    |
      | EINKAUF-3 | -3   |      | -3       | 0       | 10   |
      | BAUGRUPPE |      | 5    | 0        | 5       | 11   |
      | EINKAUF-1 | 10   |      | 0        | 10      | 12   |
      | EINKAUF-2 | 5    |      | 0        | 5       | 13   |
      | EINKAUF-3 | 6    |      | 0        | 6       | 14   |
    And I close the current editor

# Betriebsauftrag abschließen
    Given I open an editor "Rückmeldung2" from table "(Workorder):(WorkOrders)" with command "DONE" for record "RÜCKM_001"
    And I set fields
      | sofort | ja           |
      | gut    | ja           |
      | bem    | Rückmeldung2 |
    And I modify table
      | artikel   | mge | gutmge      | !row |
      | EINKAUF-3 | 6   | !dontChange | +2   |
    And I save the current editor
    And I deliver the SalesOrder "auftrag" with PackingSlip "LS-R13"


  Scenario: 14 Storno von Materialrückgabe über Rückmeldung und Fbuchung von zusätzlich entnommenem Material mit Einheiten über Rückmeldung
    Given I set the fake date to "15.01.95"
# Bestand auf 0 korrigieren
    Given I set StorageQuantity to zero for Product "GEBINDE" on StorageLocation "F1" with document "KORR-14"
    Given I set StorageQuantity to zero for Product "GEBINDEPFL" on StorageLocation "F1" with document "KORR-14"

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
      | GEBINDEPFL | 6   |
    And I set field "verw" in row 1 to "verw" from editor "auftrag" in row 1
    And I set field "verw" in row 2 to "verw" from editor "auftrag" in row 1
    And I respond with answer "ja" to the dialog with id "4841"
    And I save the current editor

# Fertigungsvorschlag anlagen und freigeben
    Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
    And I append rows
      | artikel   | netmge | bisuch     | mfreig |
      | BAUGRUPPE | 10     | RUECKG_SR_ | ja     |
    And I set field "verw" in row !lastRow to "verw" from editor "auftrag" in row !lastRow
    And I press button "freig" to open a subeditor for "BA_freigeben"
    And I close the current editor
    And I switch the current editor to editor "fvor"
    And I save the current editor

# Buchen von zusätzlichem Material über Rückmeldung und Teil der Gutmenge
    Given I open an editor "Rückmeldung1" from table "(Workorder):(WorkOrders)" with command "DONE" for record "RUECKG_SR_001"
    And I set fields
      | sofort | ja           |
      | bem    | Rückmeldung1 |
    And I modify table
      | artikel     | bueinh      | bumge       | gutmge      | !row |
      | !dontChange | !dontChange | !dontChange | 5           | 1    |
      | GEBINDEPFL  | Paar        | 6           | !dontChange | +2   |
      | GEBINDE     | kg          | 10          | !dontChange | +3   |
    And I save the current editor

# Materialrückgabe über Rückmeldung und Fbuchung
    Given I open an editor "Rückgabe1" from table "(Workorder):(WorkOrders)" with command "RETURN" for record "RUECKG_SR_001"
    And I set fields
      | sofort | ja        |
      | bem    | Rückgabe1 |
    Then the table has 3 rows
    And I modify table
      | artikel     | bueinh      | bumge       | gutmge      | !row |
      | !dontChange | !dontChange | !dontChange | -1          | 1    |
      | GEBINDEPFL  | Stück       | -6          | !dontChange | 2    |
      | GEBINDE     | Stück       | -1          | !dontChange | 3    |
    And I save the current editor

    Given I open the infosystem "BESTAND"
    And I set fields
      | artikel    | GEBINDE |
      | klplatz    | F1      |
      | verdichten | nein    |
      | details    | nein    |
    And I press start
    And I press button "taufzu" in row 1
    Then the table has 2 rows
    Then table has values
      | lemge | leinheit | gebmge | geinheit |
      | 1     | Stück    |        |          |
      |       |          | 1      | Stück    |
    And I set fields
      | artikel | GEBINDEPFL |
      | details | nein       |
    And I press start
    And I press button "taufzu" in row 1
    Then the table has 2 rows
    Then table has values
      | lemge | leinheit | gebmge | geinheit |
      | 6     | Stück    |        |          |
      |       |          | 6      | Stück    |
    And I close the current editor

    And I wait 1 time units to move the time forward
    Given I open an editor "Rückgabe2" for tip command "Fbuchung" and arguments ""
    And I set fields
      | auftrag | $,,such=RUECKG_SR_001;@richtung=rückwärts;@maxtreffer=1 |
      | bem     | Rückgabe2                                               |
    And I press button "stllad"
    And I modify table
      | !row                  | bumge | bueinh |
      | artikel=='GEBINDE'    | -5    | kg     |
      | artikel=='GEBINDEPFL' | -3    | Paar   |
    And I save the current editor

    Given I open an editor "Rückgabe2" from table "(Workorder):(CompletionConfirmations)" with command "VIEW" for search criteria "$,,such=RUECKG_SR_001;bem=Rückgabe2;@richtung=rückwärts;@ablageart=abgelegt;@maxtreffer=1"
    And I close the current editor

    Given I open the infosystem "BESTAND"
    And I set fields
      | artikel    | GEBINDE |
      | klplatz    | F1      |
      | verdichten | ja      |
      | details    | nein    |
    And I press start
    And I press button "taufzu" in row 1
    Then the table has 2 rows
    Then table has values
      | lemge | leinheit | gebmge | geinheit |
      | 2     | Stück    |        |          |
      |       |          | 2      | Stück    |
    And I set fields
      | artikel | GEBINDEPFL |
      | details | nein       |
    And I press start
    And I press button "taufzu" in row 1
    Then the table has 3 rows
    Then table has values
      | lemge | leinheit | gebmge | geinheit |
      | 12    | Stück    |        |          |
      |       |          | 6      | Stück    |
      |       |          | 3      | Paar     |
    And I close the current editor

    # Storno der Rückgaben
    Given I open an editor "Storno1_Rückgabe2" via ID from editor "Rückgabe2" from field "id" in row 0 for table "(Workorder):(CompletionConfirmations)" with command "REVERSAL"
    And I save the current editor

    Given I open the infosystem "BESTAND"
    And I set fields
      | artikel    | GEBINDE |
      | klplatz    | F1      |
      | verdichten | nein    |
      | details    | nein    |
    And I press start
    And I press button "taufzu" in row 1
    Then the table has 2 rows
    Then table has values
      | lemge | leinheit | gebmge | geinheit |
      | 1     | Stück    |        |          |
      |       |          | 1      | Stück    |
    And I set fields
      | artikel | GEBINDEPFL |
      | details | nein       |
    And I press start
    And I press button "taufzu" in row 1
    Then the table has 2 rows
    Then table has values
      | lemge | leinheit | gebmge | geinheit |
      | 6     | Stück    |        |          |
      |       |          | 6      | Stück    |
    And I close the current editor

    Given I open an editor "Storno1_Rückgabe" via ID from editor "Rückgabe1" from field "id" in row 0 for table "(Workorder):(CompletionConfirmations)" with command "REVERSAL"
    And I save the current editor

# LJ und Bestand prüfen
    Given I open the infosystem "LJ"
    And I set field "beleg" to "nummer" from editor "Rückmeldung1"
    And I set field "richtung" to "rückwärts"
    And I press start
    Then table has values
      | art        | amge | zmge | mei   | rueckmge | restmge | !row |
      | BAUGRUPPE  |      | 1    | Stück | 1        | 0       | 1    |
      | EINKAUF-1  | 2    |      | Stück | 2        | 0       | 2    |
      | EINKAUF-2  | 1    |      | Stück | 1        | 0       | 3    |
      | GEBINDEPFL | 6    |      | Stück | 6        | 0       | 4    |
      | GEBINDE    | 1    |      | Stück | 1        | 0       | 5    |
      | GEBINDEPFL | 3    |      | Paar  | 6        | 0       | 6    |
      | GEBINDE    | 1    |      | Stück | 1        | 0       | 7    |
      | GEBINDE    | -1   |      | Stück | -1       | 0       | 8    |
      | GEBINDEPFL | -3   |      | Paar  | -6       | 0       | 9    |
      | BAUGRUPPE  |      | -1   | Stück | -1       | 0       | 10   |
      | EINKAUF-1  | -2   |      | Stück | -2       | 0       | 11   |
      | EINKAUF-2  | -1   |      | Stück | -1       | 0       | 12   |
      | GEBINDEPFL | -6   |      | Stück | -6       | 0       | 13   |
      | GEBINDE    | -1   |      | Stück | -1       | 0       | 14   |
      | BAUGRUPPE  |      | 5    | Stück | 0        | 5       | 15   |
      | EINKAUF-1  | 10   |      | Stück | 0        | 10      | 16   |
      | EINKAUF-2  | 5    |      | Stück | 0        | 5       | 17   |
      | GEBINDEPFL | 6    |      | Paar  | 0        | 12      | 18   |
      | GEBINDE    | 10   |      | kg    | 0        | 2       | 19   |
    Then field "stornolj^id" in row 1 has value equal to field "verweis^id" from editor "LJ" in row 10
    Then field "stornolj^id" in row 4 has value equal to field "verweis^id" from editor "LJ" in row 13
    Then field "stornolj^id" in row 6 has value equal to field "verweis^id" from editor "LJ" in row 9
    And I close the current editor

  # Bestand ist auf 0
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
      | artikel | GEBINDEPFL |
      | details | nein       |
    And I press start
    Then the table has 0 rows
    And I close the current editor

# Betriebsauftrag abschließen
    Given I open an editor "Rückmeldung2" from table "(Workorder):(WorkOrders)" with command "DONE" for record "RUECKG_SR_001"
    And I set fields
      | sofort | ja |
      | gut    | ja |
    And I save the current editor
    And I deliver the SalesOrder "auftrag" with PackingSlip "LS-R14"


  Scenario: 15 Rückgabe und Storno Rückgabe auf verschiedene Plätze über BA mit Bestandsumbuchung aufgrund negativer Zeilen, bisher Entnahmen auf letzten AS gebucht
    Given I set the fake date to "16.01.95"
# Bestand EINKAUF-1 auf 0 korrigieren
    Given I set StorageQuantity to zero for Product "EINKAUF-1" on StorageLocation "F1" with document "XX15"
    Given I set StorageQuantity to zero for Product "EINKAUF-1" on StorageLocation "F2" with document "XX15"

# Auftrag anlegen und Bedarfe einkaufen
    Given I create a SalesOrder "auftrag15" for Customer "RADSHOP" with Product "M_BAUGRUPPE" and quantity "10"

    Given I open an editor "Rechnung15" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
    And I set fields
      | lief   | KETTLER    |
      | vom    | .          |
      | ueb    | ja         |
      | fakt   | ja         |
      | ebeleg | Rechnung15 |
    And I append rows
      | artikel   | mge |
      | EINKAUF-1 | 20  |
      | EINKAUF-2 | 10  |
    And I set field "verw" in row 1 to "verw" from editor "auftrag15" in row 1
    And I set field "verw" in row 2 to "verw" from editor "auftrag15" in row 1
    And I respond with answer "ja" to the dialog with id "4841"
    And I save the current editor

# Fertigungsvorschlag anlegen und freigeben
    Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
    And I append rows
      | artikel     | mge | mfreig | bisuch   |
      | M_BAUGRUPPE | 10  | ja     | RUECKBA_ |
    And I set field "verw" in row 1 to "verw" from editor "auftrag15" in row 1
    And I press button "freig" to open a subeditor for "BA_freigeben"
    And I close the current editor
    And I switch the current editor to editor "fvor"
    And I save the current editor

    Given I open an editor "Arbeitsschein1" from table "(Workorder):(WorkOrders)" with command "VIEW" for record "RUECKBA_001"
    And I close the current editor

# Materialentnahme auf Arbeitsschein
    Given I open an editor "Materialentnahme1" for tip command "Fbuchung" and arguments ""
    And I set fields
      | auftrag     | !Arbeitsschein1^nummer |
      | bem         | Entnahme1              |
      | gmgevorschl | 5                      |
    And I press button "stlvblad"
    Then the table has 2 rows
    And I save the current editor

    Given I open an editor "Materialentnahme1" from table "(Workorder):(CompletionConfirmations)" with command "VIEW" for search criteria "$,,such=RUECKBA_001;bem=Entnahme1;@richtung=rückwärts;@ablageart=abgelegt;@maxtreffer=1"
    And I close the current editor

# Materialrückgabe auf Betriebsauftrag
    Given I open an editor "Materialrückgabe1" for tip command "Fbuchung" and arguments ""
    And I set fields
      | auftrag     | !Arbeitsschein1^nummer |
      | bem         | Rückgabe1              |
      | gmgevorschl | -2                     |
      | mgr         | 112                    |
    And I press button "stllad"
    Then the table has 2 rows
    Then table has values
      | bumge | entmge | limge | nlimge | !row |
      | -4    | 10     | 10    | 14     | 1    |
      | -2    | 5      | 5     | 7      | 2    |
    And I press button "mzsubm" to open a subeditor for "Materialzuordnung_Rückgabe" in row 1
    And I modify table
      | !row | zuomge | platz |
      | 1    | -2     | F2    |
      | +2   | -2     | F1    |
    And I save the current editor
    And I switch the current editor to editor "Materialrückgabe1"
    And I save the current editor

    Given I open an editor "Materialrückgabe1" from table "(Workorder):(CompletionConfirmations)" with command "VIEW" for search criteria "$,,such=RUECKBA_001;bem=Rückgabe1;@richtung=rückwärts;@ablageart=abgelegt;@maxtreffer=1"
    And I close the current editor

# LJ und Bestand prüfen
    Given I open the infosystem "LJ"
    And I set fields
      | artikel  | EINKAUF-1 |
      | richtung | rückwärts |
    And I press start
    Then table has values
      | art       | vplatz | amge | rueckmge | restmge | !row |
      | EINKAUF-1 | F1     | -2   | -2       | 0       | 1    |
      | EINKAUF-1 | F2     | -2   | -2       | 0       | 2    |
      | EINKAUF-1 | F1     | 10   | 4        | 6       | 3    |
    Then field "rueckorig^id" in row 1 has value equal to field "verweis^id" from editor "LJ" in row 3
    Then field "rueckorig^id" in row 2 has value equal to field "verweis^id" from editor "LJ" in row 3
    And I set fields
      | artikel  | EINKAUF-2 |
      | richtung | rückwärts |
    And I press start
    Then table has values
      | art       | vplatz | amge | rueckmge | restmge | !row |
      | EINKAUF-2 | F1     | -2   | -2       | 0       | 1    |
      | EINKAUF-2 | F1     | 5    | 2        | 3       | 2    |
    Then field "rueckorig^id" in row 1 has value equal to field "verweis^id" from editor "LJ" in row 2
    And I close the current editor

    Given I open the infosystem "BESTAND"
    And I set fields
      | artikel    | EINKAUF-1 |
      | verdichten | nein      |
      | details    | nein      |
    And I press start
    And I press button "taufzu" in row 1
    And I press button "taufzu" in row 4
    Then the table has 5 rows
    Then table has values
      | lplatz | lemge | gebmge | kopfzugvorg^id |
      | F1     | 12    |        | (0,0,0)        |
      | F1     |       | 10     | !Rechnung15^id |
      | F1     |       | 2      | !Rechnung15^id |
      | F2     | 2     |        | (0,0,0)        |
      | F2     |       | 2      | !Rechnung15^id |
    And I close the current editor

# Materialentnahme auf Betriebsauftrag
    Given I open an editor "Materialentnahme2" for tip command "Fbuchung" and arguments ""
    And I set fields
      | auftrag     | !Arbeitsschein1^nummer |
      | bem         | Entnahme2              |
      | gmgevorschl | 4                      |
      | mgr         | 112                    |
    And I press button "stllad"
    Then the table has 2 rows
    Then table has values
      | bumge | entmge | limge | !row |
      | 8     | 6      | 14    | 1    |
      | 4     | 3      | 7     | 2    |
    And I press button "mzsubm" to open a subeditor for "Materialzuordnung_Entnahme" in row 1
    And I modify table
      | !row | zuomge | platz |
      | 1    | 4      | F2    |
      | +2   | 4      | F1    |
    And I save the current editor
    And I switch the current editor to editor "Materialentnahme2"
    And I save the current editor

    Given I open an editor "Materialentnahme2" from table "(Workorder):(CompletionConfirmations)" with command "VIEW" for search criteria "$,,such=RUECKBA_001;bem=Entnahme2;@richtung=rückwärts;@ablageart=abgelegt;@maxtreffer=1"
    And I close the current editor

# Materialrückgabe auf Arbeitsschein
    Given I open an editor "Materialrückgabe2" for tip command "Fbuchung" and arguments ""
    And I set fields
      | auftrag     | !Arbeitsschein1^nummer |
      | bem         | Rückgabe2              |
      | gmgevorschl | -3                     |
    And I press button "stlvblad"
    Then the table has 2 rows
    Then table has values
      | bumge | entmge | limge | nlimge | !row |
      | -6    | 14     | 6     | 12     | 1    |
      | -3    | 7      | 3     | 6      | 2    |
    And I press button "mzsubm" to open a subeditor for "Materialzuordnung_Rückgabe" in row 1
    And I modify table
      | !row | zuomge | platz |
      | 1    | -3     | F3    |
      | +2   | -3     | F2    |
    And I save the current editor
    And I switch the current editor to editor "Materialrückgabe2"
    And I save the current editor

    Given I open an editor "Materialrückgabe2" from table "(Workorder):(CompletionConfirmations)" with command "VIEW" for search criteria "$,,such=RUECKBA_001;bem=Rückgabe2;@richtung=rückwärts;@ablageart=abgelegt;@maxtreffer=1"
    And I close the current editor

# LJ und Bestand prüfen für Materialrückgabe2
    Given I open the infosystem "LJ"
    And I set fields
      | artikel  | EINKAUF-1 |
      | richtung | rückwärts |
    And I press start
    Then table has values
      | art       | vplatz | amge | rueckmge | restmge | !row |
      | EINKAUF-1 | F2     | -2   | -2       | 0       | 1    |
      | EINKAUF-1 | F2     | -1   | -1       | 0       | 2    |
      | EINKAUF-1 | F3     | -3   | -3       | 0       | 3    |
      | EINKAUF-1 | F1     | 4    | 4        | 0       | 4    |
      | EINKAUF-1 | F2     | 4    | 2        | 2       | 5    |
      | EINKAUF-1 | F1     | -2   | -2       | 0       | 6    |
      | EINKAUF-1 | F2     | -2   | -2       | 0       | 7    |
      | EINKAUF-1 | F1     | 10   | 4        | 6       | 8    |
    And I close the current editor

    Given I open the infosystem "BESTAND"
    And I set fields
      | artikel    | EINKAUF-1 |
      | verdichten | nein      |
      | details    | nein      |
    And I press start
    And I press button "taufzu" in row 1
    And I press button "taufzu" in row 4
    And I press button "taufzu" in row 6
    Then the table has 7 rows
    Then table has values
      | lplatz | lemge | gebmge | kopfzugvorg^id |
      | F1     | 8     |        | (0,0,0)        |
      | F1     |       | 6      | !Rechnung15^id |
      | F1     |       | 2      | !Rechnung15^id |
      | F2     | 1     |        | (0,0,0)        |
      | F2     |       | 1      | !Rechnung15^id |
      | F3     | 3     |        | (0,0,0)        |
      | F3     |       | 3      | !Rechnung15^id |
    And I close the current editor

# Rückgaben stornieren, zuletzt geuchter Rückbau wird zuerst storniert
    Given I open an editor "Materialrückgabe2_Storno" via ID from editor "Materialrückgabe2" from field "id" in row 0 for table "(Workorder):(CompletionConfirmations)" with command "REVERSAL"
    And I save the current editor

    Given I open the infosystem "BESTAND"
    And I set fields
      | artikel    | EINKAUF-1 |
      | verdichten | nein      |
      | nullmge    | nein      |
      | details    | nein      |
    And I press start
    And I press button "taufzu" in row 1
    And I press button "taufzu" in row 4
    Then the table has 6 rows
    Then table has values
      | lplatz | lemge | gebmge | kopfzugvorg^id        |
      | F1     | 8     |        | (0,0,0)               |
      | F1     |       | 6      | !Rechnung15^id        |
      | F1     |       | 2      | !Rechnung15^id        |
      | F2     | -2    |        | (0,0,0)               |
      | F2     |       | -1     | !Materialentnahme2^id |
      | F2     |       | -1     | !Materialentnahme2^id |
    And I close the current editor

    Given I open an editor "Materialrückgabe1_Storno" via ID from editor "Materialrückgabe1" from field "id" in row 0 for table "(Workorder):(CompletionConfirmations)" with command "REVERSAL"
    And I save the current editor

    Given I open the infosystem "BESTAND"
    And I set fields
      | artikel    | EINKAUF-1 |
      | verdichten | nein      |
      | nullmge    | nein      |
      | details    | nein      |
    And I press start
    And I press button "taufzu" in row 1
    And I press button "taufzu" in row 4
    Then the table has 7 rows
    Then table has values
      | lplatz | lemge | gebmge | kopfzugvorg^id        |
      | F1     | 6     |        | (0,0,0)               |
      | F1     |       | 4      | !Rechnung15^id        |
      | F1     |       | 2      | !Rechnung15^id        |
      | F2     | -4    |        | (0,0,0)               |
      | F2     |       | -1     | !Materialentnahme2^id |
      | F2     |       | -1     | !Materialentnahme2^id |
      | F2     |       | -2     | !Materialentnahme1^id |
    And I close the current editor

    Given I open an editor "Lagerbuchung" for tip command "LBuchung" and arguments ""
    And I set fields
      | artikel | EINKAUF-1 |
      | beleg   | UMBUCH15  |
      | beldat  | .         |
      | buart   | Umbuchung |
    And I modify table
      | !row | mge | platz2 | platz | verw                 | verw2                |
      | +1   | 6   | F2     | F1    | !Arbeitsschein1^verw | !Arbeitsschein1^verw |
    And I save the current editor

# FV abschließen, Auftrag liefern
    Given I open an editor "Materialentnahme3" for tip command "Fbuchung" and arguments ""
    And I set fields
      | auftrag | !Arbeitsschein1^nummer |
    And I press button "stlvblad"
    And I set field "buplatz" to "F2" in row 1
    And I save the current editor

    Given I open an editor "Rückmeldung1" from table "(Workorder):(WorkOrders)" with command "DONE" for record "RUECKBA_001"
    And I set fields
      | gut    | ja |
      | sofort | ja |
    And I save the current editor

    Given I open the infosystem "BESTAND"
    And I set fields
      | artikel    | EINKAUF-1 |
      | verdichten | nein      |
      | nullmge    | nein      |
      | details    | nein      |
    And I press start
    Then the table has 0 rows
    And I close the current editor

    And I deliver the SalesOrder "auftrag15" with PackingSlip "LS-15"

  Scenario: 17 Rückbau einer zusätzlichen manuellen Entnahme eines Lohnfertigteils
# Fertigungsvorschlag anlegen und freigeben
    Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
    And I append rows
      | artikel     | mge | mfreig | bisuch      |
      | M_BAUGRUPPE | 10  | ja     | RUECKLFERT_ |
    And I press button "freig" to open a subeditor for "BA_freigeben"
    And I close the current editor
    And I switch the current editor to editor "fvor"
    And I save the current editor

# Materialentnahme auf Arbeitsschein
    Given I open an editor "Materialentnahme1" for tip command "Fbuchung" and arguments ""
    And I set fields
      | auftrag | RUECKLFERT_000 |
      | bem     | Entnahme1      |
      | mgr     | 101            |
    And I append rows
      | elex  | bumge |
      | LOHNF | 10    |
    And I save the current editor

# Materialrückgabe auf Arbeitsschein
    Given I open an editor "Materialrückgabe2" for tip command "Fbuchung" and arguments ""
    And I set fields
      | auftrag | RUECKLFERT_000 |
      | bem     | Rückgabe1      |
      | mgr     | 101            |
    And I append rows
      | elex  | bumge |
      | LOHNF | -5    |
    And I save the current editor

  Scenario: A01 Storno eines Rückbaus auf abgelegten FV, manbu=nein
    Given I set the fake date to "17.01.95"
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
    And I set field "bem" to "MatEntnahme1"
    And I press button "stlvblad"
    And I save the current editor

    Given I open an editor "Materialentnahme1" from table "(Workorder):(CompletionConfirmations)" with command "VIEW" for search criteria "$,,such=RETROBU_001;manrm=ja;bem=MatEntnahme1;@richtung=rückwärts;@maxtreffer=1;@ablageart=abgelegt"
    And I close the current editor

    Given I open an editor "Rückmeldung1" from table "(Workorder):(WorkOrders)" with command "DONE" for record "RETROBU_001"
    And I set fields
      | sofort | ja |
      | gut    | ja |
      | bzeit  | 2  |
      | mzeit  | 2  |
    And I save the current editor

# Rückbau auf abgelegten FV und Bewertung prüfen
    Given I open an editor "Rückgabe1" via ID from editor "Rückmeldung1" from field "id" in row 0 for table "(Workorder):(CompletionConfirmations)" with command "COPY"
    And I modify table
      | !row                 | mge |
      | artikel=="EINKAUF-1" | -4  |
      | artikel=="EINKAUF-2" | -2  |
    And I save the current editor

    Given I open an editor "Bewertung1" from table "(Valuation):(Valuation)" with command "VIEW" for search criteria "$,,artikel=EINKAUF-1;detursache=Rückbau Fertigung;@richtung=rückwärts;@maxtreffer=1"
    Then field "bewvorgang^vorgang^id" has value equal to field "id" from editor "Materialentnahme1"
    And I close the current editor

  # Storno des Rückbaus und Bewertung erhält Nachfolger
    Given I open an editor "Storno1_Rückgabe" via ID from editor "Rückgabe1" from field "id" in row 0 for table "(Workorder):(CompletionConfirmations)" with command "REVERSAL"
    And I save the current editor

    And I switch the current editor to editor "Bewertung1" with command "VIEW"
    Then field "nachfolger" is not empty
    And I close the current editor

    Given I open an editor "Bewertung_nachf" via ID from editor "Bewertung1" from field "nachfolger" in row 0 for table "(Valuation):(Valuation)" with command "VIEW"
    Then field "bewvorgang^vorgang^id" has value equal to field "id" from editor "Materialentnahme1"
    Then field "detursache" has value "Storno-Rückbau Fertigung"
    And I close the current editor

# Storno, Rückmeldungen und Rückbau prüfen
    Given I switch the current editor to editor "Materialentnahme1" with command "VIEW"
    Then table has values
      | artikel   | restmge | rueckmge | limgev | limgen |
      | BAUGRUPPE | 0       | 0        | 0      | 0      |
      | EINKAUF-2 | 10      | 0        | 10     | 0      |
      | EINKAUF-1 | 20      | 0        | 20     | 0      |
    And I close the current editor

    And I switch the current editor to editor "Rückgabe1" with command "VIEW"
    Then table has values
      | artikel   | restmge | rueckmge | limgev | limgen |
      | BAUGRUPPE | 0       | 0        | 10     | 10     |
      | EINKAUF-1 | 0       | -4       | 20     | 16     |
      | EINKAUF-2 | 0       | -2       | 10     | 8      |
    And I close the current editor

    And I switch the current editor to editor "Storno1_Rückgabe" with command "VIEW"
    Then table has values
      | artikel   | restmge | rueckmge | limgev | limgen |
      | BAUGRUPPE | 0       | 0        | 0      | 0      |
      | EINKAUF-1 | 4       | 0        | 16     | 20     |
      | EINKAUF-2 | 2       | 0        | 8      | 10     |
    And I close the current editor

# Lagerjournal prüfen
    Given I open the infosystem "LJ"
    And I set field "beleg" to "barmex" from editor "Rückmeldung1"
    And I set field "richtung" to "rückwärts"
    And I press start
    Then table has values
      | art       | zmge | amge | rueckmge | restmge | detursache                 | !row |
      | EINKAUF-1 |      | 4    | 4        | 0       | Storno-Rückbau Fertigung   | 1    |
      | EINKAUF-2 |      | 2    | 2        | 0       | Storno-Rückbau Fertigung   | 2    |
      | EINKAUF-1 |      | -4   | -4       | 0       | Rückbau Fertigung          | 3    |
      | EINKAUF-2 |      | -2   | -2       | 0       | Rückbau Fertigung          | 4    |
      | BAUGRUPPE | 10   |      | 0        | 10      | Rückmeldung Fertigung      | 5    |
      | EINKAUF-1 |      | 20   | 0        | 20      | Materialentnahme Fertigung | 6    |
      | EINKAUF-2 |      | 10   | 0        | 10      | Materialentnahme Fertigung | 7    |
    Then field "stornolj^id" in row 1 has value equal to field "verweis^id" from editor "LJ" in row 3
    Then field "stornolj^id" in row 2 has value equal to field "verweis^id" from editor "LJ" in row 4
    And I close the current editor

# Auftrag abschließen
    And I deliver the SalesOrder "auftrag" with PackingSlip "LS-A01"


  Scenario: A02 Storno eines Rückbaus über die gesmte Menge, manbu=nein
    Given I set the fake date to "18.01.95"
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

    Given I open an editor "Materialentnahme1" from table "(Workorder):(CompletionConfirmations)" with command "VIEW" for search criteria "$,,such=ALLESBA_001;manrm=ja;@richtung=rückwärts;@maxtreffer=1;@ablageart=abgelegt"
    And I close the current editor

    Given I open an editor "Rückmeldung1" from table "(Workorder):(WorkOrders)" with command "DONE" for record "ALLESBA_001"
    And I set fields
      | sofort | ja |
      | gut    | ja |
      | bzeit  | 2  |
      | mzeit  | 2  |
    And I save the current editor

# Rückbau auf abgelegten FV
    Given I open an editor "Rückgabe1" via ID from editor "Rückmeldung1" from field "id" in row 0 for table "(Workorder):(CompletionConfirmations)" with command "COPY"
    And I modify table
      | !row                 | mge |
      | artikel=="EINKAUF-1" | -20 |
      | artikel=="EINKAUF-2" | -10 |
    And I save the current editor

# Storno des Rückbaus
    Given I open an editor "Storno1_Rückgabe" via ID from editor "Rückgabe1" from field "id" in row 0 for table "(Workorder):(CompletionConfirmations)" with command "REVERSAL"
    And I save the current editor

# Rückmeldungen und Rückbau prüfen, Bewertung erhält Nachfolger
    Given I switch the current editor to editor "Materialentnahme1" with command "VIEW"
    Then table has values
      | artikel     | restmge | rueckmge | limgev | limgen | !row |
      | M_BAUGRUPPE | 0       | 0        | 0      | 0      | 1    |
      | EINKAUF-2   | 10      | 0        | 10     | 0      | 2    |
      | EINKAUF-1   | 20      | 0        | 20     | 0      | 3    |
    And I close the current editor

    And I switch the current editor to editor "Rückgabe1" with command "VIEW"
    Then table has values
      | artikel     | restmge | rueckmge | limgev | limgen |
      | M_BAUGRUPPE | 0       | 0        | 10     | 10     |
      | EINKAUF-1   | 0       | -20      | 20     | 0      |
      | EINKAUF-2   | 0       | -10      | 10     | 0      |
    And I close the current editor

    And I switch the current editor to editor "Storno1_Rückgabe" with command "VIEW"
    Then table has values
      | artikel     | restmge | rueckmge | limgev | limgen |
      | M_BAUGRUPPE | 0       | 0        | 0      | 0      |
      | EINKAUF-1   | 20      | 0        | 0      | 20     |
      | EINKAUF-2   | 10      | 0        | 0      | 10     |
    And I close the current editor

# Lagerjournal prüfen
    Given I open the infosystem "LJ"
    And I set field "beleg" to "barmex" from editor "Rückmeldung1"
    And I set field "richtung" to "rückwärts"
    And I press start
    Then table has values
      | art         | zmge | amge | rueckmge | restmge |
      | EINKAUF-1   |      | 20   | 20       | 0       |
      | EINKAUF-2   |      | 10   | 10       | 0       |
      | EINKAUF-1   |      | -20  | -20      | 0       |
      | EINKAUF-2   |      | -10  | -10      | 0       |
      | M_BAUGRUPPE | 10   |      | 0        | 10      |
      | EINKAUF-1   |      | 20   | 0        | 20      |
      | EINKAUF-2   |      | 10   | 0        | 10      |
    Then field "stornolj^id" in row 1 has value equal to field "verweis^id" from editor "LJ" in row 3
    Then field "stornolj^id" in row 2 has value equal to field "verweis^id" from editor "LJ" in row 4
    And I close the current editor

# Auftrag liefern
    And I deliver the SalesOrder "auftrag" with PackingSlip "LS-A02"


  Scenario: A03 Storno eines Teil-Rückbaus auf abgelegten FV, manbu=ja
    Given I set the fake date to "19.01.95"
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

    Given I open an editor "Materialentnahme1" from table "(Workorder):(CompletionConfirmations)" with command "VIEW" for search criteria "$,,such=MANUELLE_001;manrm=ja;@richtung=rückwärts;@maxtreffer=1;@ablageart=abgelegt"
    And I close the current editor

    Given I open an editor "Rückmeldung1" from table "(Workorder):(WorkOrders)" with command "DONE" for record "MANUELLE_001"
    And I set fields
      | sofort | ja |
      | gut    | ja |
      | bzeit  | 2  |
      | mzeit  | 2  |
    And I save the current editor

# Rückbau auf abgelegten FV und Bewertung prüfen
    Given I open an editor "Rückgabe1" via ID from editor "Rückmeldung1" from field "id" in row 0 for table "(Workorder):(CompletionConfirmations)" with command "COPY"
    And I modify table
      | !row                 | mge |
      | artikel=="EINKAUF-1" | -4  |
      | artikel=="EINKAUF-2" | -2  |
    And I save the current editor

    Given I open an editor "Bewertung1" from table "(Valuation):(Valuation)" with command "VIEW" for search criteria "$,,artikel=EINKAUF-1;detursache=Rückbau Fertigung;@richtung=rückwärts;@maxtreffer=1"
    Then field "bewvorgang^vorgang^id" has value equal to field "id" from editor "Materialentnahme1"
    And I close the current editor

# Storno des Rückbaus und Bewertung erhält Nachfolger
    Given I open an editor "Storno1_Rückgabe" via ID from editor "Rückgabe1" from field "id" in row 0 for table "(Workorder):(CompletionConfirmations)" with command "REVERSAL"
    And I save the current editor

    And I switch the current editor to editor "Bewertung1" with command "VIEW"
    Then field "nachfolger" is not empty
    And I close the current editor

    Given I open an editor "Bewertung_nachf" via ID from editor "Bewertung1" from field "nachfolger" in row 0 for table "(Valuation):(Valuation)" with command "VIEW"
    Then field "bewvorgang^vorgang^id" has value equal to field "id" from editor "Materialentnahme1"
    And I close the current editor

# Storno, Rückmeldungen und Rückbau prüfen
    Given I switch the current editor to editor "Materialentnahme1" with command "VIEW"
    Then table has values
      | artikel     | restmge | rueckmge | limgev | limgen |
      | M_BAUGRUPPE | 0       | 0        | 0      | 0      |
      | EINKAUF-2   | 10      | 0        | 10     | 0      |
      | EINKAUF-1   | 20      | 0        | 20     | 0      |
    And I close the current editor

    And I switch the current editor to editor "Rückgabe1" with command "VIEW"
    Then table has values
      | artikel     | restmge | rueckmge | limgev | limgen |
      | M_BAUGRUPPE | 0       | 0        | 10     | 10     |
      | EINKAUF-1   | 0       | -4       | 20     | 16     |
      | EINKAUF-2   | 0       | -2       | 10     | 8      |
    And I close the current editor

    And I switch the current editor to editor "Storno1_Rückgabe" with command "VIEW"
    Then table has values
      | artikel     | restmge | rueckmge | limgev | limgen |
      | M_BAUGRUPPE | 0       | 0        | 0      | 0      |
      | EINKAUF-1   | 4       | 0        | 16     | 20     |
      | EINKAUF-2   | 2       | 0        | 8      | 10     |
    And I close the current editor

# Lagerjournal prüfen
    Given I open the infosystem "LJ"
    And I set field "beleg" to "barmex" from editor "Rückmeldung1"
    And I set field "richtung" to "rückwärts"
    And I press start
    Then table has values
      | art         | zmge | amge | rueckmge | restmge |
      | EINKAUF-1   |      | 4    | 4        | 0       |
      | EINKAUF-2   |      | 2    | 2        | 0       |
      | EINKAUF-1   |      | -4   | -4       | 0       |
      | EINKAUF-2   |      | -2   | -2       | 0       |
      | M_BAUGRUPPE | 10   |      | 0        | 10      |
      | EINKAUF-1   |      | 20   | 0        | 20      |
      | EINKAUF-2   |      | 10   | 0        | 10      |
    Then field "stornolj^id" in row 1 has value equal to field "verweis^id" from editor "LJ" in row 3
    Then field "stornolj^id" in row 2 has value equal to field "verweis^id" from editor "LJ" in row 4
    And I close the current editor

# Auftrag abschließen
    And I deliver the SalesOrder "auftrag" with PackingSlip "LS-A03"


  Scenario: A04 Auf abgelegten FV einen Teil des entnommenen Materials mit Chargen zurückbuchen, manbu=ja
    Given I set the fake date to "20.01.95"
# Bestand auf 0 korrigieren
    Given I set StorageQuantity to zero for Product "EINKAUF-1" on StorageLocation "F1" with document "SCEN_A04"
    Given I set StorageQuantity to zero for Product "EINKAUF-2" on StorageLocation "F1" with document "SCEN_A04"

# Charge anlegen
    Given I create a Lot "CH_1234" for Product "EINKAUF-1"
    Given I create a Lot "CH_4567" for Product "EINKAUF-1"

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

    And I wait 1 time units to move the time forward
    Given I open an editor "Rückmeldung1" from table "(Workorder):(WorkOrders)" with command "DONE" for record "ACHARGE_001"
    And I set fields
      | sofort | ja |
      | gut    | ja |
      | bzeit  | 2  |
      | mzeit  | 2  |
    And I save the current editor

# Rückbau auf abgelegten FV
    Given I open an editor "Rückgabe1" via ID from editor "Materialentnahme1" from field "id" in row 0 for table "(Workorder):(CompletionConfirmations)" with command "COPY"
    And I modify table
      | !row                 | charge      | mge |
      | artikel=="EINKAUF-1" | !CH_1234^id | -2  |
    And I save the current editor

    Given I open an editor "Rückgabe2" via ID from editor "Materialentnahme1" from field "id" in row 0 for table "(Workorder):(CompletionConfirmations)" with command "COPY"
    And I modify table
      | !row                 | charge      | mge |
      | artikel=="EINKAUF-1" | !CH_4567^id | -10 |
    And I save the current editor

# Storno des Rückbaus und Bestand prüfen
    Given I open an editor "Storno1_Rückgabe" via ID from editor "Rückgabe1" from field "id" in row 0 for table "(Workorder):(CompletionConfirmations)" with command "REVERSAL"
    And I save the current editor

    Given I open the infosystem "BESTAND"
    And I set fields
      | artikel    | EINKAUF-1   |
      | klplatz    | F1          |
      | verdichten | nein        |
      | kcharge    | !CH_1234^id |
    And I press start
    Then the table has 0 rows
    And I close the current editor

    Given I open the infosystem "BESTAND"
    And I set fields
      | artikel    | EINKAUF-1   |
      | klplatz    | F1          |
      | verdichten | nein        |
      | kcharge    | !CH_4567^id |
    And I press start
    Then the table has 1 rows
    And I close the current editor

# Rückmeldungen und Rückbau prüfen, Bestand prüfen
    And I switch the current editor to editor "Materialentnahme1" with command "VIEW"
    Then table has values
      | artikel     | restmge | rueckmge | limgev | limgen |
      | M_BAUGRUPPE | 0       | 0        | 0      | 0      |
      | EINKAUF-2   | 10      | 0        | 10     | 0      |
      | EINKAUF-1   | 10      | 10       | 20     | 0      |
    And I close the current editor

    And I switch the current editor to editor "Rückgabe1" with command "VIEW"
    Then table has values
      | artikel     | restmge | rueckmge | limgev | limgen |
      | M_BAUGRUPPE | 0       | 0        | 10     | 10     |
      | EINKAUF-1   | 0       | -2       | 20     | 18     |
      | EINKAUF-2   | 0       | 0        | 10     | 10     |
    And I close the current editor

    And I switch the current editor to editor "Rückgabe2" with command "VIEW"
    Then table has values
      | artikel     | restmge | rueckmge | limgev | limgen |
      | M_BAUGRUPPE | 0       | 0        | 10     | 10     |
      | EINKAUF-1   | 0       | -10      | 18     | 8      |
      | EINKAUF-2   | 0       | 0        | 10     | 10     |
    And I close the current editor

    And I switch the current editor to editor "Storno1_Rückgabe" with command "VIEW"
    Then table has values
      | artikel     | restmge | rueckmge | limgev | limgen |
      | M_BAUGRUPPE | 0       | 0        | 0      | 0      |
      | EINKAUF-1   | 2       | 0        | 8      | 10     |
      | EINKAUF-2   | 0       | 0        | 10     | 10     |
    And I close the current editor

# Lagerjournal prüfen
    Given I open the infosystem "LJ"
    And I set field "beleg" to "barmex" from editor "Rückmeldung1"
    And I set field "richtung" to "rückwärts"
    And I press start
    Then table has values
      | art         | zmge | amge | rueckmge | restmge | vcharge^such | !row |
      | EINKAUF-1   |      | 2    | 2        | 0       | CH_1234      | 1    |
      | EINKAUF-1   |      | -10  | -10      | 0       | CH_4567      | 2    |
      | EINKAUF-1   |      | -2   | -2       | 0       | CH_1234      | 3    |
      | M_BAUGRUPPE | 10   |      | 0        | 10      |              | 4    |
      | EINKAUF-1   |      | 10   | 10       | 0       | CH_4567      | 5    |
      | EINKAUF-1   |      | 10   | 0        | 10      | CH_1234      | 6    |
      | EINKAUF-2   |      | 10   | 0        | 10      |              | 7    |
    Then field "stornolj^id" in row 1 has value equal to field "verweis^id" from editor "LJ" in row 3
    And I close the current editor

# Auftrag abschließen
    And I deliver the SalesOrder "auftrag" with PackingSlip "LS-A04"


  Scenario: A05 Storno eines Rückbaus auf abgelegten FV mit Chargen zurückbuchen, manbu=nein
    Given I set the fake date to "21.01.95"
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

# Rückmeldung auf AS und Rückbau auf abgelegten FV
    Given I open an editor "Rückmeldung1" from table "(Workorder):(WorkOrders)" with command "DONE" for record "ACHRETRO_001"
    And I set fields
      | sofort | ja |
      | gut    | ja |
      | bzeit  | 2  |
      | mzeit  | 2  |
    And I save the current editor

    Given I open an editor "Rückgabe1" via ID from editor "Rückmeldung1" from field "id" in row 0 for table "(Workorder):(CompletionConfirmations)" with command "COPY"
    And I modify table
      | !row                 | charge      | mge |
      | artikel=="EINKAUF-1" | !CH_1234^id | -2  |
    And I save the current editor

    Given I open an editor "Rückgabe2" via ID from editor "Rückmeldung1" from field "id" in row 0 for table "(Workorder):(CompletionConfirmations)" with command "COPY"
    And I modify table
      | !row                 | charge      | mge |
      | artikel=="EINKAUF-1" | !CH_4567^id | -10 |
    And I save the current editor

# Rückbau stornieren
    Given I open an editor "Storno1_Rückgabe" via ID from editor "Rückgabe1" from field "id" in row 0 for table "(Workorder):(CompletionConfirmations)" with command "REVERSAL"
    And I save the current editor

    Given I open the infosystem "BESTAND"
    And I set fields
      | artikel    | EINKAUF-1 |
      | klplatz    | F1        |
      | verdichten | nein      |
      | details    | nein      |
    And I press start
    Then the table has 1 rows
    And I close the current editor

# Rückmeldungen und Rückbau prüfen, Bewertung hat Nachfolger
    And I switch the current editor to editor "Rückmeldung1" with command "VIEW"
    Then table has values
      | artikel   | restmge | rueckmge | limgev | limgen |
      | BAUGRUPPE | 10      | 0        | 0      | 10     |
      | EINKAUF-2 | 10      | 0        | 10     | 0      |
      | EINKAUF-1 | 10      | 10       | 20     | 0      |
    And I close the current editor

    And I switch the current editor to editor "Rückgabe1" with command "VIEW"
    Then table has values
      | artikel   | restmge | rueckmge | limgev | limgen |
      | BAUGRUPPE | 0       | 0        | 10     | 10     |
      | EINKAUF-1 | 0       | -2       | 20     | 18     |
      | EINKAUF-2 | 0       | 0        | 10     | 10     |
    And I close the current editor

    And I switch the current editor to editor "Storno1_Rückgabe" with command "VIEW"
    Then table has values
      | artikel   | restmge | rueckmge | limgev | limgen |
      | BAUGRUPPE | 0       | 0        | 0      | 0      |
      | EINKAUF-1 | 2       | 0        | 8      | 10     |
      | EINKAUF-2 | 0       | 0        | 10     | 10     |
    And I close the current editor

# Lagerjournal prüfen
    Given I open the infosystem "LJ"
    And I set field "beleg" to "barmex" from editor "Rückmeldung1"
    And I set field "richtung" to "rückwärts"
    And I press start
    Then table has values
      | art       | zmge | amge | rueckmge | restmge | vcharge^such | !row |
      | EINKAUF-1 |      | 2    | 2        | 0       | CH_1234      | 1    |
      | EINKAUF-1 |      | -10  | -10      | 0       | CH_4567      | 2    |
      | EINKAUF-1 |      | -2   | -2       | 0       | CH_1234      | 3    |
      | BAUGRUPPE | 10   |      | 0        | 10      |              | 4    |
      | EINKAUF-1 |      | 10   | 10       | 0       | CH_4567      | 5    |
      | EINKAUF-1 |      | 10   | 0        | 10      | CH_1234      | 6    |
      | EINKAUF-2 |      | 10   | 0        | 10      |              | 7    |
    Then field "stornolj^id" in row 1 has value equal to field "verweis^id" from editor "LJ" in row 3
    And I close the current editor

# Auftrag abschließen
    And I deliver the SalesOrder "auftrag" with PackingSlip "LS-A05"


  Scenario: A06 Storno eines Rückbaus auf abgelegten FV von entmommenem Material mit und ohne Chargen, das über mehrere Materialentnahmen gebucht wurde, manbu=ja
    Given I set the fake date to "22.01.95"
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

    And I wait 1 time units to move the time forward

    Given I open an editor "Materialentnahme1" from table "(Workorder):(CompletionConfirmations)" with command "VIEW" for search criteria "$,,such=SCENARIOA07_001;@richtung=rückwärts;@ablageart=abgelegt;@maxtreffer=1"
    And I close the current editor

    Given I open an editor "Materialentnahme2" for tip command "Fbuchung" and arguments ""
    And I set fields
      | auftrag     | !Arbeitsschein1^nummer |
      | gmgevorschl | 5                      |
      | autorment   | ja                     |
      | bem         | Materialentnahme2      |
    And I press button "stlvblad"
    And I save the current editor

    And I wait 1 time units to move the time forward

    Given I open an editor "Materialentnahme2" from table "(Workorder):(CompletionConfirmations)" with command "VIEW" for search criteria "$,,such=SCENARIOA07_001;@richtung=rückwärts;@ablageart=abgelegt;@maxtreffer=1"
    And I close the current editor

    Given I open an editor "Rückmeldung1" from table "(Workorder):(WorkOrders)" with command "DONE" for record "SCENARIOA07_001"
    And I set fields
      | sofort  | ja |
      | gut     | ja |
      | manrest | ja |
      | bzeit   | 2  |
      | mzeit   | 2  |
    And I save the current editor

# Rückbau auf abgelegten FV
    Given I open an editor "Rückgabe1" via ID from editor "Materialentnahme1" from field "id" in row 0 for table "(Workorder):(CompletionConfirmations)" with command "COPY"
    And I modify table
      | !row                 | charge      | mge |
      | artikel=="EINKAUF-1" | !CH_1234^id | -10 |
    And I save the current editor

    Given I open an editor "Rückgabe2" via ID from editor "Materialentnahme1" from field "id" in row 0 for table "(Workorder):(CompletionConfirmations)" with command "COPY"
    And I modify table
      | !row                 | charge      | mge |
      | artikel=="EINKAUF-1" | !CH_4567^id | -10 |
    And I save the current editor

    Given I open an editor "Rückgabe3" via ID from editor "Materialentnahme1" from field "id" in row 0 for table "(Workorder):(CompletionConfirmations)" with command "COPY"
    And I modify table
      | !row                 | charge | mge |
      | artikel=="EINKAUF-1" |        | -7  |
    And I save the current editor

# Storno des Rückbaus und Bestand prüfen
    Given I open an editor "Storno1_Rückgabe" via ID from editor "Rückgabe1" from field "id" in row 0 for table "(Workorder):(CompletionConfirmations)" with command "REVERSAL"
    And I save the current editor

    Given I open the infosystem "BESTAND"
    And I set fields
      | artikel    | EINKAUF-1 |
      | klplatz    | F1        |
      | verdichten | ja        |
      | details    | nein      |
    And I press start
    And I press button "taufzu" in row 1
    Then the table has 3 rows
    And I close the current editor

# Storno, Rückmeldungen und Rückbau prüfen
    And I switch the current editor to editor "Materialentnahme1" with command "VIEW"
    Then table has values
      | artikel     | restmge | rueckmge | limgev | limgen |
      | M_BAUGRUPPE | 0       | 0        | 0      | 0      |
      | EINKAUF-2   | 7       | 0        | 15     | 8      |
      | EINKAUF-1   | 10      | 4        | 30     | 16     |
    And I close the current editor

    And I switch the current editor to editor "Materialentnahme2" with command "VIEW"
    Then table has values
      | artikel     | restmge | rueckmge | limgev | limgen |
      | M_BAUGRUPPE | 0       | 0        | 0      | 0      |
      | EINKAUF-2   | 5       | 0        | 8      | 3      |
      | EINKAUF-1   | 3       | 7        | 16     | 6      |
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

    And I switch the current editor to editor "Storno1_Rückgabe" with command "VIEW"
    Then table has values
      | artikel     | restmge | rueckmge | limgev | limgen |
      | M_BAUGRUPPE | 0       | 0        | 0      | 0      |
      | EINKAUF-1   | 10      | 0        | 3      | 13     |
      | EINKAUF-2   | 0       | 0        | 15     | 15     |
    And I close the current editor

# Lagerjournal prüfen
    Given I open the infosystem "LJ"
    And I set field "beleg" to "barmex" from editor "Rückmeldung1"
    And I set field "richtung" to "rückwärts"
    And I press start
    Then table has values
      | art         | zmge | amge | rueckmge | restmge | vcharge^such | !row |
      | EINKAUF-1   |      | 10   | 10       | 0       | CH_1234      | 1    |
      | EINKAUF-1   |      | -1   | -1       | 0       |              | 2    |
      | EINKAUF-1   |      | -6   | -6       | 0       |              | 3    |
      | EINKAUF-1   |      | -4   | -4       | 0       | CH_4567      | 4    |
      | EINKAUF-1   |      | -6   | -6       | 0       | CH_4567      | 5    |
      | EINKAUF-1   |      | -10  | -10      | 0       | CH_1234      | 6    |
      | M_BAUGRUPPE | 15   |      | 0        | 15      |              | 7    |
      | EINKAUF-1   |      | 6    | 6        | 0       |              | 8    |
      | EINKAUF-2   |      | 3    | 0        | 3       |              | 9    |
      | EINKAUF-1   |      | 4    | 1        | 3       |              | 10   |
      | EINKAUF-1   |      | 6    | 6        | 0       | CH_4567      | 11   |
      | EINKAUF-2   |      | 5    | 0        | 5       |              | 12   |
      | EINKAUF-1   |      | 4    | 4        | 0       | CH_4567      | 13   |
      | EINKAUF-1   |      | 10   | 0        | 10      | CH_1234      | 14   |
      | EINKAUF-2   |      | 7    | 0        | 7       |              | 15   |
    Then field "stornolj^id" in row 1 has value equal to field "verweis^id" from editor "LJ" in row 6
    And I close the current editor

# Auftrag abschließen
    And I deliver the SalesOrder "auftrag" with PackingSlip "LS-A06"


  Scenario: A07 Storno eines Rückbaus auf abgelegten FV mit Einheiten zurueckbuchen, manbu=ja
    Given I set the fake date to "23.01.95"
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
    And I set field "bem" to "Entnahme"
    And I press button "stllad"
    And I modify table
      | !row | bumge | bueinh |
      | 1    | 10    | Stück  |
      | 2    | 5     | Paar   |
    And I save the current editor

    Given I open an editor "Materialentnahme1" from table "(Workorder):(CompletionConfirmations)" with command "VIEW" for search criteria "$,,such=AGEBINDE_001;manrm=ja;@richtung=rückwärts;@maxtreffer=1;@ablageart=abgelegt"
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

# Storno der Rückgabe und BEstand prüfen
    Given I open an editor "Storno1_Rueckgabe" via ID from editor "Rueckgabe1" from field "id" in row 0 for table "(Workorder):(CompletionConfirmations)" with command "REVERSAL"
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

# Belege zu Storno, Materialentnahmme und -rueckgabe pruefen
    And I switch the current editor to editor "Materialentnahme1" with command "VIEW"
    Then the table has 3 rows
    Then table has values
      | mge | artikel    | rueckmge | restmge | limgev | limgen |
      | 10  | BG-GEBINDE | 0        | 0       | 0      | 0      |
      | 10  | GEBINDEPFL | 0        | 10      | 10     | 0      |
      | 10  | GEBINDE    | 0        | 10      | 10     | 0      |
    And I close the current editor

    And I switch the current editor to editor "Rueckgabe1" with command "VIEW"
    Then table has values
      | mge  | artikel    | rueckmge | restmge | limgev | limgen |
      | 0    | BG-GEBINDE | 0        | 0       | 10     | 10     |
      | -0.2 | GEBINDE    | -0.2     | 0       | 10     | 9.8    |
      | -2   | GEBINDEPFL | -2       | 0       | 10     | 8      |
    And I close the current editor

    And I switch the current editor to editor "Storno1_Rueckgabe" with command "VIEW"
    Then table has values
      | mge | artikel    | rueckmge | restmge | limgev | limgen |
      | 0   | BG-GEBINDE | 0        | 0       | 0      | 0      |
      | 0.2 | GEBINDE    | 0        | 0.2     | 9.8    | 10     |
      | 2   | GEBINDEPFL | 0        | 2       | 8      | 10     |
    And I close the current editor

# LJ pruefen
    Given I open the infosystem "LJ"
    And I set fields
      | beleg    | !Rueckgabe1^barmex |
      | richtung | rückwärts          |
    And I press start
    Then table has values
      | art        | amge | mei   | rueckmge | restmge | lei   |
      | GEBINDE    | 0.2  | Stück | 0.2      | 0       | Stück |
      | GEBINDEPFL | 1    | Paar  | 2        | 0       | Stück |
      | GEBINDE    | -0.2 | Stück | -0.2     | 0       | Stück |
      | GEBINDEPFL | -1   | Paar  | -2       | 0       | Stück |
      | BG-GEBINDE |      | Stück | 0        | 10      | Stück |
      | GEBINDE    | 10   | Stück | 0        | 10      | Stück |
      | GEBINDEPFL | 5    | Paar  | 0        | 10      | Stück |
    And I close the current editor

# Auftrag liefern
    And I deliver the SalesOrder "auftrag" with PackingSlip "LS-MAN07"


  Scenario: A08 Storno eines Rückbaus auf abgelegten FV, der Material aus gefüllten oder leeren Behälter bucht, Nachbuchen mit zusätzlichem Material im Behälter, manbu=ja
    Given I set the fake date to "24.01.95"
    Given I set StorageQuantity to zero for Product "EINKAUF-1" on StorageLocation "F1" with document "SCEN-A08"
    Given I set StorageQuantity to zero for Product "EINKAUF-2" on StorageLocation "F1" with document "SCEN-A08"
    Given I set StorageQuantity to zero for Product "EINKAUF-3" on StorageLocation "F1" with document "SCEN-A08"

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

    Given I open an editor "Rückmeldung1" from table "(Workorder):(WorkOrders)" with command "DONE" for record "ABEHAELTER_001"
    And I set fields
      | sofort  | ja |
      | gut     | ja |
      | manrest | ja |
      | bzeit   | 2  |
      | mzeit   | 2  |
    And I save the current editor

# Teil-Rückgabe in gefüllten und leeren Behälter (über Zeile)
    Given I open an editor "Rückgabe1" via ID from editor "Rückmeldung1" from field "id" in row 0 for table "(Workorder):(CompletionConfirmations)" with command "COPY"
    And I modify table
      | !row                 | artikel     | mge | tbehaelter      |
      | artikel=="EINKAUF-1" | !dontChange | -14 | !B_MATERIAL2^id |
      | artikel=="EINKAUF-2" | !dontChange | -7  | !B_GEFUELLT^id  |
    And I save the current editor

# Storno Rückgabe und Bestand und Behälter prüfen
    Given I open an editor "Storno1_Rückgabe" via ID from editor "Rückgabe1" from field "id" in row 0 for table "(Workorder):(CompletionConfirmations)" with command "REVERSAL"
    And I save the current editor

    Then Container from editor "B_MATERIAL1" is empty
    Then Container from editor "B_MATERIAL2" is empty
    Then Container from editor "B_MATERIAL3" is empty

    Given I open the infosystem "BESTAND"
    And I set fields
      | artikel   | EINKAUF-1 |
      | klplatz   | F1        |
      | behaelter | ja        |
      | nullmge   | nein      |
      | details   | nein      |
    And I press start
    Then the table has 0 rows
    And I set fields
      | artikel   | EINKAUF-3 |
      | klplatz   | F1        |
      | behaelter | ja        |
      | details   | nein      |
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
      | EINKAUF-1      |      | 10   | 10       | 0       | !B_MATERIAL2^id | 1    |
      | EINKAUF-1      |      | 4    | 4        | 0       | !B_MATERIAL2^id | 2    |
      | EINKAUF-2      |      | 5    | 5        | 0       | !B_GEFUELLT^id  | 3    |
      | EINKAUF-2      |      | 2    | 2        | 0       | !B_GEFUELLT^id  | 4    |
      | EINKAUF-1      |      | -4   | -4       | 0       | !B_MATERIAL2^id | 5    |
      | EINKAUF-1      |      | -10  | -10      | 0       | !B_MATERIAL2^id | 6    |
      | EINKAUF-2      |      | -2   | -2       | 0       | !B_GEFUELLT^id  | 7    |
      | EINKAUF-2      |      | -5   | -5       | 0       | !B_GEFUELLT^id  | 8    |
      | M_BG-BEHAELTER | 10   |      | 0        | 10      | (0,0,0)         | 9    |
      | EINKAUF-1      |      | 10   | 0        | 10      | !B_MATERIAL2^id | 10   |
      | EINKAUF-1      |      | 10   | 0        | 10      | !B_MATERIAL1^id | 11   |
      | EINKAUF-2      |      | 5    | 0        | 5       | (0,0,0)         | 12   |
      | EINKAUF-2      |      | 5    | 0        | 5       | !B_MATERIAL3^id | 13   |
    And I close the current editor

# Lieferschein zu Auftrag
    And I deliver the SalesOrder "auftrag" with PackingSlip "LS-08"


  Scenario: A09 Storno Materialrückgabe auf abgelegten FV mit Gebinde und Behälter, manbu=ja
    Given I set the fake date to "25.01.95"
# Bestände auf 0 korrigieren
    Given I set StorageQuantity to zero for Product "GEBINDE" on StorageLocation "F1" with document "SCN-A09"
    Given I set StorageQuantity to zero for Product "GEBINDEPFL" on StorageLocation "F1" with document "SCN-A09"

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

    Given I open an editor "Rückmeldung1" from table "(Workorder):(WorkOrders)" with command "DONE" for record "GEBINDEBEH1_001"
    And I set fields
      | sofort | ja |
      | gut    | ja |
      | bzeit  | 2  |
      | mzeit  | 2  |
    And I save the current editor

# Über Kopie der Rückmeldung einen Teil des entnommenen Materials zurückbuchen
  # in Stück
    Given I open an editor "Rückgabe1" via ID from editor "Rückmeldung1" from field "id" in row 0 for table "(Workorder):(CompletionConfirmations)" with command "COPY"
    And I set field "bem" to "Rückgabe1"
    And I modify table
      | !row | mge | tbehaelter    |
      | 2    | -1  | !MATERIAL1^id |
      | 3    | -1  | !MATERIAL1^id |
    And I save the current editor

  # in Lagerheinheit
    Given I open an editor "Rückgabe2" via ID from editor "Rückmeldung1" from field "id" in row 0 for table "(Workorder):(CompletionConfirmations)" with command "COPY"
    And I set field "bem" to "Rückgabe2"
    And I modify table
      | !row | mge | bueinh | tbehaelter    |
      | 2    | -1  | Stück  | !MATERIAL1^id |
      | 3    | -1  | Paar   | !MATERIAL2^id |
    And I save the current editor

  # in Handelseinheit
    Given I open an editor "Rückgabe3" via ID from editor "Rückmeldung1" from field "id" in row 0 for table "(Workorder):(CompletionConfirmations)" with command "COPY"
    And I set field "bem" to "Rückgabe3"
    And I modify table
      | !row | mge | bueinh |
      | 2    | -1  | kg     |
      | 3    | -1  | Paar   |
    And I save the current editor

# Storno der Rückgaben und Bestand und Behälter prüfen
  # in Stück
    Given I open an editor "Storno1_Rückgabe" via ID from editor "Rückgabe1" from field "id" in row 0 for table "(Workorder):(CompletionConfirmations)" with command "REVERSAL"
    And I save the current editor

    Given I open the infosystem "BESTAND"
    And I set fields
      | artikel   | GEBINDE |
      | behaelter | ja      |
      | details   | nein    |
    And I press start
    Then the table has 2 rows
    Then table has values
      | gebmge | geinheit | tbehaelter^id |
      | 0.2    | Stück    | (0,0,0)       |
      | 1      | Stück    | !MATERIAL1^id |
    And I set fields
      | artikel   | GEBINDEPFL |
      | behaelter | ja         |
      | details   | nein       |
    And I press start
    Then the table has 2 rows
    Then table has values
      | gebmge | geinheit | tbehaelter^id |
      | 1      | Paar     | (0,0,0)       |
      | 1      | Paar     | !MATERIAL2^id |
    And I close the current editor

  # in Lagereinheit
    Given I open an editor "Storno2_Rückgabe" via ID from editor "Rückgabe2" from field "id" in row 0 for table "(Workorder):(CompletionConfirmations)" with command "REVERSAL"
    And I save the current editor

    Given I open the infosystem "BESTAND"
    And I set fields
      | artikel   | GEBINDE |
      | behaelter | ja      |
      | details   | nein    |
    And I press start
    Then the table has 1 rows
    Then table has values
      | gebmge | geinheit | tbehaelter^id |
      | 0.2    | Stück    | (0,0,0)       |
    And I set fields
      | artikel   | GEBINDEPFL |
      | behaelter | ja         |
      | details   | nein       |
    And I press start
    Then the table has 1 rows
    Then table has values
      | gebmge | geinheit | tbehaelter^id |
      | 1      | Paar     | (0,0,0)       |
    And I close the current editor

  # in Handelseinheit
    Given I open an editor "Storno3_Rückgabe" via ID from editor "Rückgabe3" from field "id" in row 0 for table "(Workorder):(CompletionConfirmations)" with command "REVERSAL"
    And I save the current editor

    Given I open the infosystem "BESTAND"
    And I set fields
      | artikel   | GEBINDE |
      | behaelter | ja      |
      | nullmge   | nein    |
      | details   | nein    |
    And I press start
    Then the table has 0 rows
    And I set fields
      | artikel   | GEBINDEPFL |
      | behaelter | ja         |
      | nullmge   | nein       |
      | details   | nein       |
    And I press start
    Then the table has 0 rows
    And I close the current editor

    Then Container from editor "MATERIAL1" is empty
    Then Container from editor "MATERIAL2" is empty

# Auftrag liefern
    And I deliver the SalesOrder "auftrag" with PackingSlip "LS-MAN09"


  Scenario: A10 Storno einer Rückgabe auf abgelegten FV mit zusätzlichem Material über Materialentnahme
    Given I set the fake date to "26.01.95"
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

# Rückbau auf abgelegten FV
    Given I open an editor "Rückgabe1" via ID from editor "Rückmeldung1" from field "id" in row 0 for table "(Workorder):(CompletionConfirmations)" with command "COPY"
    And I modify table
      | !row                 | artikel     | mge |
      | artikel=="EINKAUF-1" | !dontChange | -4  |
      | artikel=="EINKAUF-2" | !dontChange | -2  |
      | +4                   | EINKAUF-3   | -2  |
    And I save the current editor

# Storno der Rückgabe
    Given I open an editor "Storno1_Rückgabe" via ID from editor "Rückgabe1" from field "id" in row 0 for table "(Workorder):(CompletionConfirmations)" with command "REVERSAL"
    And I save the current editor

# Storno und Rückbau prüfen
    And I switch the current editor to editor "Rückgabe1" with command "VIEW"
    Then table has values
      | artikel   | restmge | rueckmge | limgev | limgen |
      | BAUGRUPPE | 0       | 0        | 10     | 10     |
      | EINKAUF-1 | 0       | -4       | 20     | 16     |
      | EINKAUF-2 | 0       | -2       | 10     | 8      |
      | EINKAUF-3 | 0       | -2       | 10     | 8      |
    And I close the current editor

    And I switch the current editor to editor "Storno1_Rückgabe" with command "VIEW"
    Then table has values
      | artikel   | restmge | rueckmge | limgev | limgen |
      | BAUGRUPPE | 0       | 0        | 0      | 0      |
      | EINKAUF-1 | 4       | 0        | 16     | 20     |
      | EINKAUF-2 | 2       | 0        | 8      | 10     |
      | EINKAUF-3 | 2       | 0        | 8      | 10     |
    And I close the current editor

# Lagerjournal prüfen
    Given I open the infosystem "LJ"
    And I set field "beleg" to "barmex" from editor "Rückmeldung1"
    And I set field "richtung" to "rückwärts"
    And I press start
    Then table has values
      | art       | zmge | amge | rueckmge | restmge | !row |
      | EINKAUF-1 |      | 4    | 4        | 0       | 1    |
      | EINKAUF-2 |      | 2    | 2        | 0       | 2    |
      | EINKAUF-3 |      | 2    | 2        | 0       | 3    |
      | EINKAUF-1 |      | -4   | -4       | 0       | 4    |
      | EINKAUF-2 |      | -2   | -2       | 0       | 5    |
      | EINKAUF-3 |      | -2   | -2       | 0       | 6    |
      | BAUGRUPPE | 10   |      | 0        | 10      | 7    |
      | EINKAUF-1 |      | 20   | 0        | 20      | 8    |
      | EINKAUF-2 |      | 10   | 0        | 10      | 9    |
      | EINKAUF-3 |      | 10   | 0        | 10      | 10   |
    And I close the current editor

# Auftrag abschließen
    And I deliver the SalesOrder "auftrag" with PackingSlip "LS-A10"


