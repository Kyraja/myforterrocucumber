@persistent
Feature: storno_rueck_basisprozesse_fbuchung_FDM_mit_bew_upg.feature

  Background:
    And I set the fake date to "03.07.2002"

  # Stammdaten werden in der Version 2016r4n16 angelegt und basieren auf basis_stammdaten.feature
  # Bewertungsverfahren: Vorgangspreis (Abgang) und Preis des Zugangs (Zugang)


# **********************************************************************************
#  Name             : storno_rueck_basisprozesse_fbuchung_FDM_mit_bew_upg.feature
#  Autor            : bschiga
#  Verantwortlich   : amk
#  Kontrolle        : drpf
#  Funktion         : Prozesse Teil 2 nach Upgrade auf Version 2019 oder höher
#
# **********************************************************************************
# Jira FDA-1747


  Scenario: 01 NACH Upgrade Materialrückgabe auf Arbeitsschein 1

    Given I'm logged in with password "annette"
    And I enable the flag 71
    And I execute FOP "RMKOP.REP"
    And I disable the flag 71
    Given I'm logged in with password "sy"

# Materialentnahme über gesamte Gutmenge Arbeitsschein 2
    Given I open an editor "Materialentnahme2" for tip command "Fbuchung" and arguments ""
    And I set field "auftrag" to "$,,such=FV01_002;@richtung=rückwärts;@maxtreffer=1"
    And I set field "bem" to "EntnahmeAS2"
    And I press button "stlvblad"
    And I save the current editor

# Materialrückgabe auf Arbeitssschein 1 Teilmenge
    Given I open an editor "Rueckgabe1" for tip command "Fbuchung" and arguments ""
    And I set field "auftrag" to "$,,such=FV01_001;@richtung=rückwärts;@maxtreffer=1"
    And I press button "stlvblad"
    And I set field "bem" to "RueckgabeAS1"
    And I set field "bumge" to "-10" in row 1
    And I save the current editor

# Mengen in AFL prüfen
    Given I open an editor "BA_pruef" from table "(Workorder):(WorkOrders)" with command "VIEW" for search criteria "$,,such=FV01_000;@richtung=rückwärts;@maxtreffer=1"
    And I press button "absteig" to open a subeditor for "AFL01"
    Then field "limge" has value "10" in row 1
    Then field "limge" has value "0" in row 3
    And I close the current subeditor to switch back to the parent editor
    And I close the current editor

# Beleg öffnen
    Given I open an editor "Materialentnahme1_pruef" from table "(Workorder):(CompletionConfirmations)" with command "VIEW" for search criteria "$,,such=FV01_001;bem=EntnahmeAS1;@ablageart=abgelegt;@richtung=rückwärts;@maxtreffer=1"
    And I close the current editor

# BA und FV prüfen
    Given I open an editor "BA_pruef" from table "(Workorder):(WorkOrders)" with command "VIEW" for search criteria "$,,such=FV01_000;@richtung=rückwärts;@maxtreffer=1"
    Then field "mge" has value "50"
    Then field "rgutmge" has value "0"
    And I close the current editor

    Given I open an editor "FV_pruef" from table "(Purchasing):(WorkOrderSuggestions)" with command "VIEW" for record ""
    And I set field "banummer" to "!BA_pruef^num9"
    And I press button "ladetab"
    Then field "mge" has value "50" in row 1
    Then field "netlimge" has value "50" in row 1
    And I close the current editor

# Lagerjournaleintrag prüfen
    Given I open the infosystem "LJ"
    And I set fields
      | beleg    | !Materialentnahme1_pruef^barmex |
      | adatum   | -250                            |
      | edatum   | .                               |
      | richtung | rückwärts                       |
    And I press start
    Then table has values
      | art        | amge | rueckmge | restmge |
      | EK1-BEDARF | -10  | -10      | 0       |
      | EK1-BEDARF | 50   | 10       | 40      |
    And I close the current editor

# BA abschließen
# Rückmeldung auf Arbeitsschein 2 gesamte Gutmenge
    Given I open an editor "Rueckmeldung1" from table "(Workorder):(WorkOrders)" with command "DONE" for search criteria "$,,such=FV01_002;@richtung=rückwärts;@maxtreffer=1"
    And I set field "sofort" to "ja"
    And I set field "gut" to "ja"
    And I set field "manrest" to "ja"
    And I save the current editor


  Scenario: 02 NACH Upgrade Materialrückgabe auf BA, anstatt auf AS

# Materialentnahme über gesamte Gutmenge Arbeitsschein 2
    Given I open an editor "Materialentnahme2" for tip command "Fbuchung" and arguments ""
    And I set field "auftrag" to "$,,such=FV02_002;@richtung=rückwärts;@maxtreffer=1"
    And I set field "bem" to "EntnahmeAS2"
    And I press button "stlvblad"
    And I save the current editor

# Materialrückgabe auf BA Teilmenge
    Given I open an editor "RueckgabeBA" for tip command "Fbuchung" and arguments ""
    And I set field "auftrag" to "$,,such=FV02_000;@richtung=rückwärts;@maxtreffer=1"
    And I set field "mgr" to "103"
    And I press button "stllad"
    And I set field "bem" to "RueckgabeBA"
    And I set field "bumge" to "-10" in row 1
    And I save the current editor

# Mengen in AFL prüfen
    Given I open an editor "BA_pruef" from table "(Workorder):(WorkOrders)" with command "VIEW" for search criteria "$,,such=FV02_000;@richtung=rückwärts;@maxtreffer=1"
    And I press button "absteig" to open a subeditor for "AFL02"
    Then field "limge" has value "10" in row 1
    Then field "limge" has value "0" in row 3
    And I close the current subeditor to switch back to the parent editor
    And I close the current editor

# Belege zu Materialentnahmme und -rückgabe prüfen
    Given I open an editor "RueckgabeBA_pruef" from table "(Workorder):(CompletionConfirmations)" with command "VIEW" for search criteria "$,,such=FV02_000;bem=RueckgabeBA;@ablageart=abgelegt;@richtung=rückwärts;@maxtreffer=1"
    Then the table has 2 rows
    Then table has values
      | mge | artikel       | rueckmge | restmge | limgev | limgen |
      | 50  | UP_MBG-BEDARF | 0        | 0       | 0      | 0      |
      | -10 | EK1-BEDARF    | -10      | 0       | 0      | 10     |
    And I close the current editor

    Given I open an editor "Materialentnahme1_pruef" from table "(Workorder):(CompletionConfirmations)" with command "VIEW" for search criteria "$,,such=FV02_001;bem=EntnahmeAS1;@ablageart=abgelegt;@richtung=rückwärts;@maxtreffer=1"
    Then the table has 2 rows
    Then table has values
      | mge | artikel       | rueckmge | restmge |
      | 50  | UP_MBG-BEDARF | 0        | 0       |
      | 50  | EK1-BEDARF    | 10       | 40      |
    And I close the current editor

# BA und FV prüfen
    Given I open an editor "BA_pruef" from table "(Workorder):(WorkOrders)" with command "VIEW" for search criteria "$,,such=FV02_000;@richtung=rückwärts;@maxtreffer=1"
    Then field "mge" has value "50"
    Then field "rgutmge" has value "0"
    And I close the current editor

    Given I open an editor "FV_pruef" from table "(Purchasing):(WorkOrderSuggestions)" with command "VIEW" for record ""
    And I set field "banummer" to "!BA_pruef^num9"
    And I press button "ladetab"
    Then field "mge" has value "50" in row 1
    Then field "netlimge" has value "50" in row 1
    And I close the current editor

# Lagerjournaleintrag prüfen Buchung auf AS
    Given I open the infosystem "LJ"
    And I set fields
      | beleg    | !Materialentnahme1_pruef^barmex |
      | adatum   | -250                            |
      | edatum   | .                               |
      | richtung | rückwärts                       |
    And I press start
    Then table has values
      | art        | amge | rueckmge | restmge |
      | EK1-BEDARF | 50   | 10       | 40      |
    And I close the current editor

# Lagerjournaleintrag prüfen Buchung auf BA
    Given I open the infosystem "LJ"
    And I set field "beleg" to "!BA_pruef^num9"
    And I set field "richtung" to "rückwärts"
    And I press start
    Then table has values
      | art        | amge | rueckmge | restmge |
      | EK1-BEDARF | -10  | -10      | 0       |
    And I close the current editor

# BA abschließen
# Rückmeldung auf Arbeitsschein 2 gesamte Gutmenge
    Given I open an editor "Rueckmeldung1" from table "(Workorder):(WorkOrders)" with command "DONE" for search criteria "$,,such=FV02_002;@richtung=rückwärts;@maxtreffer=1"
    And I set field "sofort" to "ja"
    And I set field "gut" to "ja"
    And I set field "manrest" to "ja"
    And I save the current editor


  Scenario: 03 NACH Upgrade - Materialentnahme stornieren

# Materialentnahme stornieren
    Given I open an editor "Storno1" from table "(Workorder):(CompletionConfirmations)" with command "REVERSAL" for search criteria "$,,such=FV03_001;bem=EntnahmeAS1;@richtung=rückwärts;@ablageart=abgelegt;@maxtreffer=1"
    Then the table has 2 rows
    Then table has values
      | artikel       | mge | gutmge |
      | UP_MBG-BEDARF | 20  | 0      |
      | EK1-BEDARF    | -30 | 0      |
    And I save the current editor

# Lagerjournaleintrag prüfen
    Given I open the infosystem "LJ"
    And I set field "beleg" to "barmex" from editor "Storno1"
    And I set field "artikel" to "EK1-BEDARF"
    And I set field "richtung" to "rückwärts"
    And I press start
    Then table has values
      | art        | amge | zmge | detursache                        |
      | EK1-BEDARF | -30  |      | Storno-Materialentnahme Fertigung |
    And I close the current editor

# Offene Mengen in Reservierung prüfen
    Given I open an editor "Betriebsauftrag" from table "(Workorder):(WorkOrders)" with command "VIEW" for search criteria "$,,such=FV03_000;@richtung=rückwärts;@maxtreffer=1"
    And I press button "absteig" to open a subeditor for "Auftragsfertigungsliste"
    Then table has values
      | elex       | limge | frgmge | !row |
      | EK1-BEDARF | 50    | 50     | 1    |
      | EK2-BEDARF | 50    | 50     | 3    |
    And I close the current subeditor to switch back to the parent editor
    And I close the current editor

# BA abschließen
# Rückmeldung auf Arbeitsschein 1 Restmenge
    Given I open an editor "Rueckmeldung1" from table "(Workorder):(WorkOrders)" with command "DONE" for search criteria "$,,such=FV03_001;@richtung=rückwärts;@maxtreffer=1"
    And I set field "sofort" to "ja"
    And I set field "gut" to "ja"
    And I set field "manrest" to "ja"
    And I save the current editor

# Rückmeldung auf Arbeitsschein 2 gesamte Gutmenge
    Given I open an editor "Rueckmeldung1" from table "(Workorder):(WorkOrders)" with command "DONE" for search criteria "$,,such=FV03_002;@richtung=rückwärts;@maxtreffer=1"
    And I set field "sofort" to "ja"
    And I set field "gut" to "ja"
    And I set field "manrest" to "ja"
    And I save the current editor


  Scenario: 04 NACH Upgrade Materialentnahme AS 2 stornieren und dann Materialrückgabe auf AS 1 mit zusätzlichem Material

# Materialentnahme Arbeitsschein 2 stornieren
    Given I open an editor "Storno1" from table "(Workorder):(CompletionConfirmations)" with command "REVERSAL" for search criteria "$,,such=FV04_002;bem=EntnahmeAS2;@richtung=rückwärts;@ablageart=abgelegt;@maxtreffer=1"
    Then the table has 3 rows
    Then table has values
      | artikel       | mge | gutmge |
      | UP_MBG-BEDARF | 50  | 0      |
      | EK3-BEDARF    | -10 | 0      |
      | EK2-BEDARF    | -30 | 0      |
    And I save the current editor

# Lagerjournaleintrag prüfen
    Given I open the infosystem "LJ"
    And I set field "beleg" to "barmex" from editor "Storno1"
    And I set field "artikel" to "EK2-BEDARF"
    And I set field "richtung" to "rückwärts"
    And I press start
    Then table has values
      | art        | amge | zmge | detursache                        |
      | EK2-BEDARF | -30  |      | Storno-Materialentnahme Fertigung |
    And I set field "artikel" to "EK3-BEDARF"
    And I press start
    Then table has values
      | art        | amge | zmge | detursache                        |
      | EK3-BEDARF | -10  |      | Storno-Materialentnahme Fertigung |
    And I close the current editor

# Offene Mengen in Reservierung prüfen
    Given I open an editor "Betriebsauftrag" from table "(Workorder):(WorkOrders)" with command "VIEW" for search criteria "$,,such=FV04_000;@richtung=rückwärts;@maxtreffer=1"
    And I press button "absteig" to open a subeditor for "AFL04"
    Then table has values
      | elex       | limge | frgmge | !row |
      | EK1-BEDARF | 20    | 20     | 1    |
      | EK2-BEDARF | 50    | 50     | 3    |
    And I close the current subeditor to switch back to the parent editor
    And I close the current editor

# Materialrückgabe auf Arbeitsschein 1 Teilmenge
    Given I open an editor "Rueckgabe1" for tip command "Fbuchung" and arguments ""
    And I set field "auftrag" to "$,,such=FV04_001;@richtung=rückwärts;@maxtreffer=1"
    And I press button "stlvblad"
    And I set field "bem" to "RückgabeAS1"
    And I modify table
      | !row | elex        | bumge |
      | 1    | !dontChange | -10   |
      | +2   | EK3-BEDARF  | -5    |
    And I save the current editor

# Beleg öffnen
    Given I open an editor "Rueckgabe1_pruef" from table "(Workorder):(WorkOrders)" with command "VIEW" for search criteria "$,,such=FV04_001;@richtung=rückwärts;@maxtreffer=1"
    And I close the current editor

# Lagerjournaleintrag prüfen
    Given I open the infosystem "LJ"
    And I set field "beleg" to "barmex" from editor "Rueckgabe1_pruef"
    And I set field "artikel" to "EK1-BEDARF"
    And I set field "richtung" to "rückwärts"
    And I press start
    Then table has values
      | art        | amge | zmge | detursache                 |
      | EK1-BEDARF | -10  |      | Materialrückgabe Fertigung |
    And I set field "artikel" to "EK3-BEDARF"
    And I press start
    Then table has values
      | art        | amge | zmge | detursache                 |
      | EK3-BEDARF | -5   |      | Materialrückgabe Fertigung |
    And I close the current editor

# BA abschließen
# Rückmeldung auf Arbeitsschein 1 Restmenge
    Given I open an editor "Rückmeldung1" from table "(Workorder):(WorkOrders)" with command "DONE" for search criteria "$,,such=FV04_001;@richtung=rückwärts;@maxtreffer=1"
    And I set field "sofort" to "ja"
    And I set field "gut" to "ja"
    And I set field "manrest" to "ja"
    And I save the current editor

# Rückmeldung auf Arbeitsschein 2 gesamte Gutmenge
    Given I open an editor "Rückmeldung1" from table "(Workorder):(WorkOrders)" with command "DONE" for search criteria "$,,such=FV04_002;@richtung=rückwärts;@maxtreffer=1"
    And I set field "sofort" to "ja"
    And I set field "gut" to "ja"
    And I set field "manrest" to "ja"
    And I save the current editor


  Scenario: 05 NACH Upgrade Stornieren der 2. Materialentnahme AS 1 ist nicht möglich

    Given I open an editor "Materialentnahme_pruef" from table "(Workorder):(CompletionConfirmations)" with command "VIEW" for search criteria "$,,such=FV05_001;bem=Entnahme2AS1;@richtung=rückwärts;@ablageart=abgelegt;@maxtreffer=1"
    Then the table has 3 rows
    Then table has values
      | artikel       | mge | gutmge |
      | UP_MBG-BEDARF | 50  | 0      |
      | EK1-BEDARF    | 2   | 0      |
      | EK3-BEDARF    | -3  | 0      |
    And I close the current editor

# Materialentnahme stornieren nicht möglich
#  2199 de   |Storno dieses Belegs nicht möglich, Material wurde bereits rückgebucht.
    Then opening an editor from table "(Workorder):(CompletionConfirmations)" with command "REVERSAL" for record from editor "Materialentnahme_pruef" throws the exception "2199"

# BA abschließen
# Rückmeldung auf Arbeitsschein 1 gesamte Gutmenge
    Given I open an editor "Rückmeldung1" from table "(Workorder):(WorkOrders)" with command "DONE" for search criteria "$,,such=FV05_001;@richtung=rückwärts;@maxtreffer=1"
    And I set field "sofort" to "ja"
    And I set field "gut" to "ja"
    And I set field "manrest" to "ja"
    And I save the current editor

# Rückmeldung auf Arbeitsschein 2 gesamte Gutmenge
    Given I open an editor "Rückmeldung1" from table "(Workorder):(WorkOrders)" with command "DONE" for search criteria "$,,such=FV05_002;@richtung=rückwärts;@maxtreffer=1"
    And I set field "sofort" to "ja"
    And I set field "gut" to "ja"
    And I set field "manrest" to "ja"
    And I save the current editor


  Scenario: 06 NACH Materialentnahme stornieren nicht möglich, da Material bereits vor Upgrade zurückgelegt wurde

    Given I open an editor "Materialentnahme_pruef" from table "(Workorder):(CompletionConfirmations)" with command "VIEW" for search criteria "$,,such=FV06_002;bem=EntnahmeAS2;@richtung=rückwärts;@ablageart=abgelegt;@maxtreffer=1"
    Then the table has 2 rows
    Then table has values
      | artikel       | mge | gutmge |
      | UP_MBG-BEDARF | 50  | 0      |
      | EK2-BEDARF    | 30  | 0      |
    And I close the current editor

# Materialentnahme stornieren nicht möglich
#  2199 de   |Storno dieses Belegs nicht möglich, Material wurde bereits rückgebucht.
    Then opening an editor from table "(Workorder):(CompletionConfirmations)" with command "REVERSAL" for record from editor "Materialentnahme_pruef" throws the exception "2199"

# BA abschließen
# Rückmeldung auf Arbeitsschein 1 Teilmenge
    Given I open an editor "Rückmeldung1" from table "(Workorder):(WorkOrders)" with command "DONE" for search criteria "$,,such=FV06_001;@richtung=rückwärts;@maxtreffer=1"
    And I set field "sofort" to "ja"
    And I set field "gut" to "ja"
    And I set field "manrest" to "ja"
    And I save the current editor

# Rückmeldung auf Arbeitsschein 2 gesamte Gutmenge
    Given I open an editor "Rückmeldung1" from table "(Workorder):(WorkOrders)" with command "DONE" for search criteria "$,,such=FV06_002;@richtung=rückwärts;@maxtreffer=1"
    And I set field "sofort" to "ja"
    And I set field "gut" to "ja"
    And I set field "manrest" to "ja"
    And I save the current editor


  Scenario: 07 NACH Storno der 1. Materialentnahme ist nicht möglich, da Teilmenge bereits zurückgelegt wurde

# Materialrückgabe auf Arbeitssschein 1 Teilmenge
    Given I open an editor "Rückgabe1" for tip command "Fbuchung" and arguments ""
    And I set field "auftrag" to "$,,such=FV07_001;@richtung=rückwärts;@maxtreffer=1"
    And I press button "stlvblad"
    And I set field "bem" to "RückgabeAS1"
    And I set field "bumge" to "-7" in row 1
    And I save the current editor

    Given I open an editor "Materialentnahme_pruef" from table "(Workorder):(CompletionConfirmations)" with command "VIEW" for search criteria "$,,such=FV07_001;bem=Entnahme2AS1;@richtung=rückwärts;@ablageart=abgelegt;@maxtreffer=1"
    Then the table has 2 rows
    Then table has values
      | artikel       | mge | gutmge |
      | UP_MBG-BEDARF | 50  | 0      |
      | EK1-BEDARF    | 5   | 0      |
    And I close the current editor

# Materialentnahme stornieren nicht möglich
#  2199 de   |Storno dieses Belegs nicht möglich, Material wurde bereits rückgebucht.
    Then opening an editor from table "(Workorder):(CompletionConfirmations)" with command "REVERSAL" for record from editor "Materialentnahme_pruef" throws the exception "2199"

# BA abschließen
# Rückmeldung auf Arbeitsschein 1 gesamte Gutmenge
    Given I open an editor "Rückmeldung1" from table "(Workorder):(WorkOrders)" with command "DONE" for search criteria "$,,such=FV07_001;@richtung=rückwärts;@maxtreffer=1"
    And I set field "sofort" to "ja"
    And I set field "gut" to "ja"
    And I set field "manrest" to "ja"
    And I save the current editor

# Rückmeldung auf Arbeitsschein 2 gesamte Gutmenge
    Given I open an editor "Rückmeldung1" from table "(Workorder):(WorkOrders)" with command "DONE" for search criteria "$,,such=FV07_002;@richtung=rückwärts;@maxtreffer=1"
    And I set field "sofort" to "ja"
    And I set field "gut" to "ja"
    And I set field "manrest" to "ja"
    And I save the current editor


  Scenario: 08 NACH Materialrückgabe stornieren nicht möglich, da mehr Material zurückgelegt wurde, als entnommen wurde

    Given I open an editor "Materialentnahme_pruef" from table "(Workorder):(CompletionConfirmations)" with command "VIEW" for search criteria "$,,such=FV08_002;bem=RückgabeAS2;@richtung=rückwärts;@ablageart=abgelegt;@maxtreffer=1"
    Then the table has 2 rows
    Then table has values
      | artikel       | mge | gutmge |
      | UP_MBG-BEDARF | 50  | 0      |
      | EK2-BEDARF    | -20 | 0      |
    And I close the current editor

# Materialentnahme stornieren nicht möglich
#  2199 de   |Storno dieses Belegs nicht möglich, Material wurde bereits rückgebucht.
    Then opening an editor from table "(Workorder):(CompletionConfirmations)" with command "REVERSAL" for record from editor "Materialentnahme_pruef" throws the exception "2199"

# BA abschließen
# Rückmeldung auf Arbeitsschein 1 Restmenge
    Given I open an editor "Rückmeldung1" from table "(Workorder):(WorkOrders)" with command "DONE" for search criteria "$,,such=FV08_001;@richtung=rückwärts;@maxtreffer=1"
    And I set field "sofort" to "ja"
    And I set field "gut" to "ja"
    And I set field "manrest" to "ja"
    And I save the current editor

# Rückmeldung auf Arbeitsschein 2 gesamte Gutmenge
    Given I open an editor "Rückmeldung1" from table "(Workorder):(WorkOrders)" with command "DONE" for search criteria "$,,such=FV08_002;@richtung=rückwärts;@maxtreffer=1"
    And I set field "sofort" to "ja"
    And I set field "gut" to "ja"
    And I set field "manrest" to "ja"
    And I save the current editor


  Scenario: 09 NACH Materialrückgabe stornieren nicht möglich, da Material gar nicht entnommen wurde

    Given I open an editor "Materialentnahme_pruef" from table "(Workorder):(CompletionConfirmations)" with command "VIEW" for search criteria "$,,such=FV09_002;bem=RückgabeAS2;@richtung=rückwärts;@ablageart=abgelegt;@maxtreffer=1"
    Then the table has 2 rows
    Then table has values
      | artikel       | mge | gutmge |
      | UP_MBG-BEDARF | 50  | 0      |
      | EK2-BEDARF    | -20 | 0      |
    And I close the current editor

    Given I open an editor "Storno" from table "(Workorder):(CompletionConfirmations)" with command "REVERSAL" for record from editor "Materialentnahme_pruef"
    Then table has values
      | artikel       | mge | gutmge |
      | UP_MBG-BEDARF | 50  | 0      |
      | EK2-BEDARF    | 20  | 0      |
# 11121 de |In einem Rueckbau sind nur negative Mengen zulaessig.
    Then saving the current editor throws the exception "11121"
    And I close the current editor

# BA abschließen
# Rückmeldung auf Arbeitsschein 1 Restmenge
    Given I open an editor "Rückmeldung1" from table "(Workorder):(WorkOrders)" with command "DONE" for search criteria "$,,such=FV09_001;@richtung=rückwärts;@maxtreffer=1"
    And I set field "sofort" to "ja"
    And I set field "gut" to "ja"
    And I set field "manrest" to "ja"
    And I save the current editor

# Rückmeldung auf Arbeitsschein 2 gesamte Gutmenge
    Given I open an editor "Rückmeldung1" from table "(Workorder):(WorkOrders)" with command "DONE" for search criteria "$,,such=FV09_002;@richtung=rückwärts;@maxtreffer=1"
    And I set field "sofort" to "ja"
    And I set field "gut" to "ja"
    And I set field "manrest" to "ja"
    And I save the current editor


  Scenario: 10 NACH Materialrückgabe und Storno auf abgelegten FV

# Rückbau auf abgelegten FV, nur Materialrückgabe
    Given I open an editor "Rückgabe1_abgelegt" from table "(Workorder):(CompletionConfirmations)" with command "COPY" for search criteria "$,,such=FV10_001;bem=EntnahmeAS1;@ablageart=abgelegt;@richtung=rückwärts;@maxtreffer=1"
    And I set field "bem" to "RückgabeAS1_abgelegt"
    And I modify table
      | !row                  | mge |
      | artikel=="EK1-BEDARF" | -15 |
    And I save the current editor

# Lagerjournaleintrag prüfen
    Given I open the infosystem "LJ"
    And I set field "beleg" to "barmex" from editor "Rückgabe1_abgelegt"
    And I set field "richtung" to "rückwärts"
    And I press start
    Then table has values
      | art        | amge | rueckmge | restmge | !row |
      | EK1-BEDARF | -15  | -15      | 0       | 1    |
    And I close the current editor

# Beleg zu Materialrückgabe prüfen
    Given I open an editor "Rückgabe1_pruef" from table "(Workorder):(CompletionConfirmations)" with command "VIEW" for search criteria "$,,such=FV10_001;bem=RückgabeAS1_abgelegt;@ablageart=abgelegt;@richtung=rückwärts;@maxtreffer=1"
    Then the table has 2 rows
    Then table has values
      | mge | artikel       | rueckmge | restmge |
      | 0   | UP_MBG-BEDARF | 0        | 0       |
      | -15 | EK1-BEDARF    | -15      | 0       |
    And I close the current editor

# Materialentnahme AS 2 stornieren
    Given I open an editor "Storno1" from table "(Workorder):(CompletionConfirmations)" with command "REVERSAL" for search criteria "$,,such=FV10_002;bem=EntnahmeAS2;@richtung=rückwärts;@ablageart=abgelegt;@maxtreffer=1"
    Then the table has 2 rows
    Then table has values
      | artikel       | mge | gutmge |
      | UP_MBG-BEDARF | 0   | 0      |
      | EK2-BEDARF    | -50 | 0      |
    And I save the current editor

# Lagerjournaleintrag prüfen
    Given I open the infosystem "LJ"
    And I set field "beleg" to "barmex" from editor "Storno1"
    And I set field "richtung" to "rückwärts"
    And I press start
    Then table has values
      | art        | amge | rueckmge | restmge | !row |
      | EK2-BEDARF | -50  | -50      | 0       | 1    |
    And I close the current editor


  Scenario: 11 NACH Materialrückgabe und Storno auf abgelegten FV, BA mit Löschschutz

# Materialrückgabe auf Arbeitssschein 1 Teilmenge
    Given I open an editor "Rückgabe1" for tip command "Fbuchung" and arguments ""
    And I set field "auftrag" to "$,,such=FV11_001;@richtung=rückwärts;@maxtreffer=1"
    And I set field "bem" to "RückgabeAS1"
    And I press button "stlvblad"
    And I set field "bumge" to "-15" in row 1
    And I save the current editor

# Lagerjournaleintrag prüfen
    Given I open the infosystem "LJ"
    And I set field "beleg" to "barmex" from editor "Rückgabe1"
    And I set field "richtung" to "rückwärts"
    And I press start
    Then table has values
      | art        | amge | rueckmge | restmge | !row |
      | EK1-BEDARF | -15  | -15      | 0       | 1    |
    And I close the current editor

# Materialentnahme AS 2 stornieren
    Given I open an editor "Storno1" from table "(Workorder):(CompletionConfirmations)" with command "REVERSAL" for search criteria "$,,such=FV11_002;bem=EntnahmeAS2;@richtung=rückwärts;@ablageart=abgelegt;@maxtreffer=1"
    Then the table has 2 rows
    Then table has values
      | artikel       | mge | gutmge |
      | UP_MBG-BEDARF | 0   | 0      |
      | EK2-BEDARF    | -50 | 0      |
    And I save the current editor


# Lagerjournaleintrag prüfen
    Given I open the infosystem "LJ"
    And I set field "beleg" to "barmex" from editor "Storno1"
    And I set field "richtung" to "rückwärts"
    And I press start
    Then table has values
      | art        | detursache                        | amge | rueckmge | restmge | !row |
      | EK2-BEDARF | Storno-Materialentnahme Fertigung | -50  | -50      | 0       | 1    |
    And I close the current editor

# Mengen in AFL prüfen (15 Rückgabe auf AS 1 und 50 Storno AS 2)
    Given I open an editor "BA_pruef" from table "(Workorder):(WorkOrders)" with command "VIEW" for search criteria "$,,such=FV11_000;@richtung=rückwärts;@maxtreffer=1"
    And I press button "absteig" to open a subeditor for "AFL11"
    Then field "limge" has value "15" in row 1
    Then field "limge" has value "50" in row 3
    And I close the current subeditor to switch back to the parent editor
    And I close the current editor


  Scenario: 12 NACH Materialrückgabe und Storno der Materialentnahme buchen das Koppelprodukt entsprechend ab

# durch Reparatur-FOP bekommen die Mengen des Koppelprodukts umgekehrte Vorzeichen #
# 1. Materialentnahme AS 1, Beleg prüfen
    Given I open an editor "Materialentnahme_pruef" from table "(Workorder):(CompletionConfirmations)" with command "VIEW" for search criteria "$,,such=FV12_001;bem=EntnahmeAS1;@richtung=rückwärts;@ablageart=abgelegt;@maxtreffer=1"
    Then the table has 3 rows
    Then table has values
      | artikel       | mge | gutmge | ikompeig     |
      | UP_MBG-KOPPEL | 50  | 0      |              |
      | EK1-BEDARF    | 5   | 0      |              |
      | KOPPELPROD    | 5   | 0      | icon:combine |
    And I close the current editor

# durch Reparatur-FOP bekommen die Mengen des Koppelprodukts umgekehrte Vorzeichen #
# 2. Materialentnahme AS 1, Beleg prüfen
    Given I open an editor "Materialentnahme2_pruef" from table "(Workorder):(CompletionConfirmations)" with command "VIEW" for search criteria "$,,such=FV12_001;bem=Entnahme2AS1;@richtung=rückwärts;@ablageart=abgelegt;@maxtreffer=1"
    Then the table has 3 rows
    Then table has values
      | artikel       | mge | gutmge | ikompeig     |
      | UP_MBG-KOPPEL | 50  | 0      |              |
      | EK1-BEDARF    | 10  | 0      |              |
      | KOPPELPROD    | 10  | 0      | icon:combine |
    And I close the current editor

# durch Reparatur-FOP ist Storno möglich #
# 1. Materialentnahme auf AS 1 stornieren
    Given I open an editor "STORNO_AS1" from table "(Workorder):(CompletionConfirmations)" with command "REVERSAL" for record from editor "Materialentnahme_pruef"
    Then the table has 3 rows
    Then table has values
      | artikel       | mge | gutmge |
      | UP_MBG-KOPPEL | 50  | 0      |
      | EK1-BEDARF    | -5  | 0      |
      | KOPPELPROD    | -5  | 0      |
    And I save the current editor

# Materialrückgabe auf Arbeitssschein 1 Teilmenge
    Given I open an editor "RUECKGABE_AS1" for tip command "Fbuchung" and arguments ""
    And I set field "auftrag" to "!Materialentnahme_pruef^barmex"
    And I set field "gmgevorschl" to "-7"
    And I set field "bem" to "RückgabeAS1"
    And I press button "stlvblad"
    Then field "bumge" has value "-7" in row 1
    Then field "bumge" has value "-7" in row 2
    And I save the current editor

# LJ-Eintrag prüfen und offene Mengen in Reservierung prüfen

    Given I open an editor "BA_pruef" from table "(Workorder):(WorkOrders)" with command "VIEW" for search criteria "$,,such=FV12_000;@richtung=rückwärts;@maxtreffer=1"
    And I press button "absteig" to open a subeditor for "AFL12"
    Then field "limge" has value "47" in row 1
    Then field "limge" has value "47" in row 2
    Then field "kompeig" has value "Koppelprodukt" in row 2
    And I close the current subeditor to switch back to the parent editor
    And I close the current editor

# Beleg öffnen
    Given I open an editor "RUECKGABE_pruef" from table "(Workorder):(CompletionConfirmations)" with command "VIEW" for search criteria "$,,such=FV12_001;bem=RückgabeAS1;@richtung=rückwärts;@ablageart=abgelegt;@maxtreffer=1"
    And I close the current editor

# Lagerbewegungsjournal prüfen
    Given I open the infosystem "LJ"
    And I set fields
      | beleg  | !Materialentnahme_pruef^barmex |
      | adatum | -250                           |
      | edatum | .                              |
    And I press start
    Then table has values
      | art        | detursache                        | amge | zmge | rueckmge | restmge | vorgang^id                  |
      | EK1-BEDARF |                                   | 5    |      | 5        | 0       | !Materialentnahme_pruef^id  |
      | KOPPELPROD |                                   |      | 5    | 5        | 0       | !Materialentnahme_pruef^id  |
      | EK1-BEDARF |                                   | 10   |      | 7        | 3       | !Materialentnahme2_pruef^id |
      | KOPPELPROD |                                   |      | 10   | 7        | 3       | !Materialentnahme2_pruef^id |
      | KOPPELPROD | Storno-Materialentnahme Fertigung |      | -5   | -5       | 0       | !STORNO_AS1^id              |
      | EK1-BEDARF | Storno-Materialentnahme Fertigung | -5   |      | -5       | 0       | !STORNO_AS1^id              |
      | KOPPELPROD | Materialrückgabe Fertigung        |      | -7   | -7       | 0       | !RUECKGABE_pruef^id         |
      | EK1-BEDARF | Materialrückgabe Fertigung        | -7   |      | -7       | 0       | !RUECKGABE_pruef^id         |
    And I close the current editor

# BA abschließen
# Rückmeldung auf Arbeitsschein 1 gesamte Gutmenge
    Given I open an editor "Rückmeldung1" from table "(Workorder):(WorkOrders)" with command "DONE" for search criteria "$,,such=FV12_001;@richtung=rückwärts;@maxtreffer=1"
    And I set field "sofort" to "ja"
    And I set field "gut" to "ja"
    And I set field "manrest" to "ja"
    And I save the current editor

# Rückmeldung auf Arbeitsschein 2 gesamte Gutmenge
    Given I open an editor "Rückmeldung1" from table "(Workorder):(WorkOrders)" with command "DONE" for search criteria "$,,such=FV12_002;@richtung=rückwärts;@maxtreffer=1"
    And I set field "sofort" to "ja"
    And I set field "gut" to "ja"
    And I set field "manrest" to "ja"
    And I save the current editor


  Scenario: 13 NACH neuer Rest wird bei Storno der Materialentnahme zurückgesetzt und bei Materialrückgabe entsprechend berücksichtigt

# 2. Materialentnahme AS 1 stornieren
    Given I open an editor "Storno1" from table "(Workorder):(CompletionConfirmations)" with command "REVERSAL" for search criteria "$,,such=FV13_001;bem=Entnahme2AS1;@richtung=rückwärts;@ablageart=abgelegt;@maxtreffer=1"
    Then the table has 2 rows
    Then table has values
      | artikel       | mge | gutmge |
      | UP_MBG-BEDARF | 35  | 0      |
      | EK1-BEDARF    | -8  | 0      |
    And I save the current editor

# Materialrückgabe auf Arbeitsschein 2 Teilmenge
    Given I open an editor "Rückgabe1" for tip command "Fbuchung" and arguments ""
    And I set field "auftrag" to "$,,such=FV13_002;@richtung=rückwärts;@maxtreffer=1"
    And I press button "stlvblad"
    And I set field "bem" to "RückgabeAS2"
    And I set field "bumge" to "-1" in row 1
    Then field "nlimge" has value "36" in row 1
    And I save the current editor

# Offene Mengen in Reservierung prüfen, bei EK1-BEDARF ist neuer Rest 40, nicht 43, bei EK2-BEDARF ist neuer Rest 36, nicht 37
    Given I open an editor "Betriebsauftrag" from table "(Workorder):(WorkOrders)" with command "VIEW" for search criteria "$,,such=FV13_000;@richtung=rückwärts;@maxtreffer=1"
    And I press button "absteig" to open a subeditor for "AFL04"
    Then table has values
      | elex       | limge | frgmge | !row |
      | EK1-BEDARF | 43    | 43     | 1    |
      | A AG-LOHN1 | 35    | 35     | 2    |
      | EK2-BEDARF | 36    | 36     | 3    |
      | A AG-LOHN2 | 35    | 35     | 4    |
    And I close the current subeditor to switch back to the parent editor
    And I close the current editor

# BA abschließen
# Rückmeldung auf Arbeitsschein 1 Restmenge
    Given I open an editor "Rückmeldung1" from table "(Workorder):(WorkOrders)" with command "DONE" for search criteria "$,,such=FV13_001;@richtung=rückwärts;@maxtreffer=1"
    And I set field "sofort" to "ja"
    And I set field "gut" to "ja"
    And I set field "manrest" to "ja"
    And I save the current editor

# Rückmeldung auf Arbeitsschein 2 Restmenge
    Given I open an editor "Rückmeldung1" from table "(Workorder):(WorkOrders)" with command "DONE" for search criteria "$,,such=FV13_002;@richtung=rückwärts;@maxtreffer=1"
    And I set field "sofort" to "ja"
    And I set field "gut" to "ja"
    And I set field "manrest" to "ja"
    And I save the current editor


  Scenario: 14 NACH Materialrückgabe auf anderen Lagerplatz ist nicht möglich, da negativer Bestand auf Ursprungsplatz

# Materialentnahme über gesamte Gutmenge Arbeitsschein 2
    Given I open an editor "Materialentnahme2" for tip command "Fbuchung" and arguments ""
    And I set field "auftrag" to "$,,such=FV14_002;@richtung=rückwärts;@maxtreffer=1"
    And I set field "bem" to "EntnahmeAS2"
    And I press button "stlvblad"
    And I save the current editor

# Bestand prüfen
    Given I open the infosystem "BESTAND"
    And I set field "artikel" to "EK4-BEDARF"
    And I set field "klplatz" to "F1"
    And I press start
    Then field "lemge" has value "-50" in row 1
    And I close the current editor

# Materialrückgabe auf Arbeitsschein 1 Teilmenge, auf anderen Platz als bei der Entnahme, nur 2. Komponente
# Erwartetes Ergebnis: nicht möglich, da negativer Bestand auf Ursprungsplatz
    Given I open an editor "Rückgabe1" for tip command "Fbuchung" and arguments ""
    And I set field "auftrag" to "$,,such=FV14_001;@richtung=rückwärts;@maxtreffer=1"
    And I set field "bem" to "RückgabeAS1"
    And I press button "stlvblad"
    And I delete row at position 1
    And I set field "bumge" to "-10" in row 1
    And I set field "buplatz" to "F2" in row 1
#  2037 de   |Aktion wegen eines negativen Bestands auf dem ursprünglichen Abgangsplatz nicht möglich. Bitte Bestände ausgleichen.
    Then saving the current editor throws the exception "2037"
    And I close the current editor

# BA abschließen
# Rückmeldung auf Arbeitsschein 2 gesamte Gutmenge
    Given I open an editor "Rückmeldung1" from table "(Workorder):(WorkOrders)" with command "DONE" for search criteria "$,,such=FV14_002;@richtung=rückwärts;@maxtreffer=1"
    And I set field "sofort" to "ja"
    And I set field "gut" to "ja"
    And I save the current editor


  Scenario: 15 NACH Storno einer Rückmeldung mit gemischten Vorzeichen ist nicht möglich

    Given I open an editor "Rueckmeldung_pruef" from table "(Workorder):(CompletionConfirmations)" with command "VIEW" for search criteria "$,,such=FV15_001;bem=Rückmeldung2AS1;@richtung=rückwärts;@ablageart=abgelegt;@maxtreffer=1"
    Then the table has 2 rows
    Then table has values
      | artikel       | mge | gutmge |
      | UP_MBG-BEDARF | 5   | -5     |
      | EK3-BEDARF    | 20  | 0      |
    And I close the current editor

# Materialentnahme stornieren nicht möglich
#  9453 de |Rückmeldung ist zu alt. Storno nicht möglich, da Daten fehlen. Bitte Kommando Rückbau verwenden.
    Then opening an editor from table "(Workorder):(CompletionConfirmations)" with command "REVERSAL" for record from editor "Rueckmeldung_pruef" throws the exception "9453"

# BA abschließen
# Rückmeldung auf Arbeitsschein 1 Restmenge
    Given I open an editor "Rückmeldung1" from table "(Workorder):(WorkOrders)" with command "DONE" for search criteria "$,,such=FV15_001;@richtung=rückwärts;@maxtreffer=1"
    And I set field "sofort" to "ja"
    And I set field "gut" to "ja"
    And I set field "manrest" to "ja"
    And I save the current editor

# Rückmeldung auf Arbeitsschein 2 Restmenge
    Given I open an editor "Rückmeldung1" from table "(Workorder):(WorkOrders)" with command "DONE" for search criteria "$,,such=FV15_002;@richtung=rückwärts;@maxtreffer=1"
    And I set field "sofort" to "ja"
    And I set field "gut" to "ja"
    And I set field "manrest" to "ja"
    And I save the current editor


  Scenario: 16 NACH Upgrade Materialrückgabe, mehr als entnommen wurde, ist nicht möglich

# Materialrückgabe auf Arbeitssschein 2 größere Menge als entnommen wurde
    Given I open an editor "Rückgabe1" for tip command "Fbuchung" and arguments ""
    And I set field "auftrag" to "$,,such=FV16_002;@richtung=rückwärts;@maxtreffer=1"
    And I press button "stlvblad"
    And I set field "bumge" to "-15" in row 1
#  1395 de   |Die zurückzubuchende Menge ist größer als die ursprünglich zurückgemeldete Menge.
    Then saving the current editor throws the exception "1395"
    And I close the current editor

# BA abschließen
# Rückmeldung auf Arbeitsschein 2 gesamte Gutmenge
    Given I open an editor "Rückmeldung1" from table "(Workorder):(WorkOrders)" with command "DONE" for search criteria "$,,such=FV16_002;@richtung=rückwärts;@maxtreffer=1"
    And I set field "sofort" to "ja"
    And I set field "gut" to "ja"
    And I set field "manrest" to "ja"
    And I save the current editor


  Scenario: 17 NACH Materialrückgabe auf AS 1 der gesamten entnommenen Menge, auf AS und BA

# Materialrückgabe auf Arbeitssschein 1, gesamte entnommene Menge auf AS und BA
    Given I open an editor "Rückgabe1" for tip command "Fbuchung" and arguments ""
    And I set field "auftrag" to "$,,such=FV17_001;@richtung=rückwärts;@maxtreffer=1"
    And I press button "stlvblad"
    And I set field "bem" to "RückgabeAS1"
    And I set field "bumge" to "-25" in row 1
# 1395 Die zurückzubuchende Menge ist größer als die ursprünglich zurückgemeldete Menge.
    Then saving the current editor throws the exception "1395"
# Materialrückgabe auf Arbeitssschein 1, tatsächlich entnommene Menge
    And I set field "bumge" to "-20" in row 1
    And I save the current editor


# BA abschließen
# Rückmeldung auf Arbeitsschein 1 gesamte Gutmenge
    Given I open an editor "Rückmeldung1" from table "(Workorder):(WorkOrders)" with command "DONE" for search criteria "$,,such=FV17_001;@richtung=rückwärts;@maxtreffer=1"
    And I set field "sofort" to "ja"
    And I set field "gut" to "ja"
    And I set field "manrest" to "ja"
    And I save the current editor

# Rückmeldung auf Arbeitsschein 2 gesamte Gutmenge
    Given I open an editor "Rückmeldung1" from table "(Workorder):(WorkOrders)" with command "DONE" for search criteria "$,,such=FV17_002;@richtung=rückwärts;@maxtreffer=1"
    And I set field "sofort" to "ja"
    And I set field "gut" to "ja"
    And I set field "manrest" to "ja"
    And I save the current editor

