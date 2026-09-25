@persistent
Feature: storno_zeitbuchung.feature

  Background:
    And I set the fake date to "10.02.1995"

# *****************************************************************************
#  Name             : storno_zeitbuchung
#  Autor            : lschneider
#  Verantwortlich   : drpf
#  Kontrolle        : amk
#  Funktion         : Tested den Storno von Zeitbuchung und Zeitkorrektur
# *****************************************************************************


  Scenario: P01 Bis auf Bemerkung sind im Storno-Beleg einer Zeitbuchung alle Felder schreibgeschützt
# Fertigungsvorschlag anlegen, freigeben und eine Rückmeldung buchen
    Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
    And I append rows
      | artikel   | mge | mfreig | bisuch     |
      | BAUGRUPPE | 10  | ja     | SCHREIBSZ_ |
    And I press button "freig" to open a subeditor for "BA_freigeben"
    And I close the current editor
    And I switch the current editor to editor "fvor"
    And I save the current editor

    Given I open an editor "Arbeitsschein" from table "(Workorder):(WorkOrders)" with command "VIEW" for record "SCHREIBSZ_001"
    And I close the current editor

# Zeitbuchung erstellen und stornieren, Schriebschutz prüfen
    Given I open an editor "Zeitbuchung" for tip command "Zeitbuchung" and arguments ""
    And I set field "barmex" to "nummer" from editor "Arbeitsschein"
    And I set fields
      | sofort | 1 |
      | mzeit  | 3 |
      | bzeit  | 3 |
    And I save the current editor

    Given I open an editor "Zeitbuchung_Storno" from table "(Workorder):(CompletionConfirmations)" with command "REVERSAL" for search criteria "$,,such=SCHREIBSZ_001;@richtung=rückwärts;@ablageart=abgelegt;@maxtreffer=1"
    Then fields have values
      | sofort | ja |
      | mzeit  | -3 |
      | bzeit  | -3 |
    Then field "mzeit" is not modifiable
    Then field "bzeit" is not modifiable
    Then field "mgr" is not modifiable
    Then field "verw" is not modifiable
    Then field "kstelle" is not modifiable
    Then field "bem" is modifiable
    And I close the current editor

# Betriebsauftrag löschen
    Given I open an editor "Betriebsuaftrag" from table "(Workorder):(WorkOrders)" with command "UPDATE" for record "SCHREIBSZ_000"
    And I respond with answer "ja" to the dialog with id "345"
    And I set field "status" to "s"
    And I save the current editor


  Scenario: P02 Der Storno einer Zeitbuchung auf den Arbeitsschein erzeugt eine Rückmeldung mit typ=Storno-Zeitbuchung
# Fertigungsvorschlag anlegen, freigeben und eine Rückmeldung buchen
    Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
    And I append rows
      | artikel   | mge | mfreig | bisuch |
      | BAUGRUPPE | 10  | ja     | TYPZ_  |
    And I press button "freig" to open a subeditor for "BA_freigeben"
    And I close the current editor
    And I switch the current editor to editor "fvor"
    And I save the current editor

    Given I open an editor "Arbeitsschein" from table "(Workorder):(WorkOrders)" with command "VIEW" for record "TYPZ_001"
    And I close the current editor

# Zeitbuchung erstellen und stornieren
    Given I open an editor "Zeitbuchung" for tip command "Zeitbuchung" and arguments ""
    And I set field "barmex" to "nummer" from editor "Arbeitsschein"
    And I set fields
      | sofort | 1           |
      | mzeit  | 3           |
      | bzeit  | 3           |
      | bem    | Zeitbuchung |
    And I save the current editor

# Typ in Original- und Stornobeleg prüfen
    Given I open an editor "Zeitbuchung_Storno" from table "(Workorder):(CompletionConfirmations)" with command "REVERSAL" for search criteria "$,,such=TYPZ_001;@richtung=rückwärts;@ablageart=abgelegt;@maxtreffer=1"
    Then field "typa279" has value "Storno-Zeitbuchung"
    And I set field "bem" to "Zeitbuch_Storno"
    And I save the current editor

    Given I open an editor "Zeitbuchung" from table "(Workorder):(CompletionConfirmations)" with command "VIEW" for search criteria "$,,such=TYPZ_001;bem=Zeitbuchung;@richtung=rückwärts;@ablageart=abgelegt;@maxtreffer=1"
    Then field "typa279" has value "Stornierte Zeitbuchung"
    And I close the current editor

# Betriebsauftrag löschen
    Given I open an editor "Betriebsuaftrag" from table "(Workorder):(WorkOrders)" with command "UPDATE" for record "TYPZ_000"
    And I respond with answer "ja" to the dialog with id "345"
    And I set field "status" to "s"
    And I save the current editor


  Scenario: P03 Das Feld Bemerkung wird in den Storno-Belegen der Zeitbuchung vererbt
# Fertigungsvorschlag anlegen, freigeben und eine Rückmeldung buchen
    Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
    And I append rows
      | artikel   | mge | mfreig | bisuch |
      | BAUGRUPPE | 10  | ja     | BEMZ_  |
    And I press button "freig" to open a subeditor for "BA_freigeben"
    And I close the current editor
    And I switch the current editor to editor "fvor"
    And I save the current editor

    Given I open an editor "Arbeitsschein" from table "(Workorder):(WorkOrders)" with command "VIEW" for record "BEMZ_001"
    And I close the current editor

# Zeitbuchung erstellen und stornieren
    Given I open an editor "Zeitbuchung" for tip command "Zeitbuchung" and arguments ""
    And I set field "barmex" to "nummer" from editor "Arbeitsschein"
    And I set fields
      | sofort | 1           |
      | mzeit  | 3           |
      | bzeit  | 3           |
      | bem    | Zeitbuchung |
    And I save the current editor

    Given I open an editor "Zeitbuchung_Storno" from table "(Workorder):(CompletionConfirmations)" with command "REVERSAL" for search criteria "$,,such=BEMZ_001;@richtung=rückwärts;@ablageart=abgelegt;@maxtreffer=1"
    And I set field "bem" to "Zeitstorno"
    And I save the current editor

# Feld Bemerkung in Original- und Stornobeleg prüfen
    Given I open an editor "Zeitbuchung" from table "(Workorder):(CompletionConfirmations)" with command "VIEW" for search criteria "$,,such=BEMZ_001;typa279=Stornierte Zeitbuchung;@richtung=rückwärts;@ablageart=abgelegt;@maxtreffer=1"
    Then field "bem" has value "Zeitbuchung"
    And I close the current editor

    Given I open an editor "Zeitbuchung" from table "(Workorder):(CompletionConfirmations)" with command "VIEW" for search criteria "$,,such=BEMZ_001;typa279=Storno-Zeitbuchung;@richtung=rückwärts;@ablageart=abgelegt;@maxtreffer=1"
    Then field "bem" has value "Zeitstorno"
    And I close the current editor

# Betriebsauftrag löschen
    Given I open an editor "Betriebsuaftrag" from table "(Workorder):(WorkOrders)" with command "UPDATE" for record "BEMZ_000"
    And I respond with answer "ja" to the dialog with id "345"
    And I set field "status" to "s"
    And I save the current editor


  Scenario: P04 Durch den Storno einer Zeitbuchung werden die Zeiten im Arbeitsgang entsprechend korrigiert
# Fertigungsvorschlag anlegen, freigeben und eine Rückmeldung buchen
    Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
    And I append rows
      | artikel   | mge | mfreig | bisuch   |
      | BAUGRUPPE | 10  | ja     | ZEITENZ_ |
    And I press button "freig" to open a subeditor for "BA_freigeben"
    And I close the current editor
    And I switch the current editor to editor "fvor"
    And I save the current editor

    Given I open an editor "Arbeitsschein" from table "(Workorder):(WorkOrders)" with command "VIEW" for record "ZEITENZ_001"
    And I close the current editor

# Zeitbuchung erstellen und stornieren
    Given I open an editor "Zeitbuchung" for tip command "Zeitbuchung" and arguments ""
    And I set field "barmex" to "nummer" from editor "Arbeitsschein"
    And I set fields
      | sofort | 1           |
      | mzeit  | 3           |
      | bzeit  | 3           |
      | bem    | Zeitbuchung |
    And I save the current editor

    Given I open an editor "Zeitbuchung_Storno" from table "(Workorder):(CompletionConfirmations)" with command "REVERSAL" for search criteria "$,,such=ZEITENZ_001;@richtung=rückwärts;@ablageart=abgelegt;@maxtreffer=1"
    And I set field "bem" to "Zeitkorrektur"
    And I save the current editor

# Zeiten im Arbeitsschein sind reduziert
    Given I open the infosystem "PRODLIST"
    And I set field "kba" to "nummer" from editor "Arbeitsschein"
    And I set field "detail" to "ja"
    And I press start
    Then table has values
      | !row | bzeit | mzeit | vzeit |
      | 4    | 0     | 0     | 1.25  |
    And I close the current editor

# Betriebsauftrag löschen
    Given I open an editor "Betriebsuaftrag" from table "(Workorder):(WorkOrders)" with command "UPDATE" for record "ZEITENZ_000"
    And I respond with answer "ja" to the dialog with id "345"
    And I set field "status" to "s"
    And I save the current editor


# Scenario: P05 Zeitbuchung auf einen abgelegeten FV kann nicht storniert werden 
# kann mit Cucumber nicht getestet werden, manuell getestet: funktioniert


  Scenario: P06 Storno einer Zeitbuchung, die durch einen Kurzläufer entstand
# Mitarbeiter und Schichtplan anlegen
    Given I open an editor "mitarbeiter" from table "(Employee):(Employee)" with command "STORE" for record "BDE_MA"
    And I set fields
      | such  | BDE_MA |
      | splan | 303    |
      | lohn  | 1      |
    And I save the current editor

# Fertigungsvorschlag anlegen, freigeben
    Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
    And I append rows
      | artikel   | mge | mfreig | bisuch  |
      | BAUGRUPPE | 10  | ja     | KURZLZ_ |
    And I press button "freig" to open a subeditor for "BA_freigeben"
    And I close the current editor
    And I switch the current editor to editor "fvor"
    And I save the current editor

    Given I open an editor "Arbeitsschein" from table "(Workorder):(WorkOrders)" with command "VIEW" for record "KURZLZ_001"
    And I close the current editor

# Kurzläufer für ersten Arbeitsschein erstellen und stornieren
    Given I open an editor "Kurzläufer1" from table "(PDC):(ShortProductionOrder)" with command "NEW" for record ""
    And I set field "ma" to id from editor "mitarbeiter"
    And I set field "asma" to "nummer" from editor "Arbeitsschein"
    And I set fields
      | mgr     | 112 |
      | anfdat  | .   |
      | anfzeit | .   |
      | istzeit | 2   |
      | mzeit   | 1   |
      | sofort  | ja  |
    And I save the current editor

# Rückmeldung aus Kurzläufer stornieren
    Given I open an editor "Zeitbuchung_Storno" from table "(PDC):(ShortProductionOrder)" with command "REVERSAL" for record from editor "Kurzläufer1"
    And I set field "bem" to "Storno-Zeitbuchung"
    Then fields have values
      | mzeit   | -1                  |
      | istzeit | -2                  |
      | typa332 | Storno-Auftragszeit |
    And I save the current editor

    Given I open an editor "Kurzläufer_pruef1" from table "(Workorder):(CompletionConfirmations)" with command "VIEW" for search criteria "$,,such=KURZLZ_001;mzeit=1;@richtung=rückwärts;@ablageart=abgelegt;@maxtreffer=1"
    Then field "typa279" has value "Stornierte Zeitbuchung" in row 0
    And I close the current editor

# Betriebsauftrag löschen
    Given I open an editor "Betriebsuaftrag" from table "(Workorder):(WorkOrders)" with command "UPDATE" for record "KURZLZ_000"
    And I respond with answer "ja" to the dialog with id "345"
    And I set field "status" to "s"
    And I save the current editor


  Scenario: P07 Storno einer Zeitbuchung, die über eine BDE Auftragszeit entstand
# Mitarbeiter und Schichtplan anlegen
    Given I open an editor "mitarbeiter" from table "(Employee):(Employee)" with command "STORE" for record "BDE_MA"
    And I set fields
      | such  | BDE_MA |
      | splan | 303    |
      | lohn  | 1      |
    And I save the current editor

# Fertigungsvorschlag anlegen, freigeben
    Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
    And I append rows
      | artikel   | mge | mfreig | bisuch    |
      | BAUGRUPPE | 10  | ja     | AUFTRAGZ_ |
    And I press button "freig" to open a subeditor for "BA_freigeben"
    And I close the current editor
    And I switch the current editor to editor "fvor"
    And I save the current editor

    Given I open an editor "Arbeitsschein" from table "(Workorder):(WorkOrders)" with command "VIEW" for record "AUFTRAGZ_001"
    And I close the current editor

# Personal- und Auftragszeit erstellen und übertragen sowie buchen
    Given I open an editor "Personalzeit" from table "(PDC):(TimeAndLaborData)" with command "STORE" for search criteria "$,,ma=BDE_MA;uebertr=ja;@richtung=rückwärts;@maxtreffer=1"
    And I set field "ma" to id from editor "mitarbeiter"
    And I set fields
      | anfdat  | .     |
      | anfzeit | 8:00  |
      | enddat  | .     |
      | endzeit | 16:00 |
    And I save the current editor

    Given I open an editor "Auftragszeit" from table "(PDC):(OrderTime)" with command "NEW" for record ""
    And I set field "ma" to id from editor "mitarbeiter"
    And I set field "asma" to "nummer" from editor "Arbeitsschein"
    And I set fields
      | anfdat  | .     |
      | anfzeit | 9:00  |
      | enddat  | .     |
      | endzeit | 10:00 |
      | mzeit   | 2     |
      | sofort  | ja    |
    And I save the current editor

# Rückmeldung aus Auftragszeit stornieren
    Given I open an editor "Auftargszeit_Storno" from table "(PDC):(OrderTime)" with command "REVERSAL" for record from editor "Auftragszeit"
    And I set field "bem" to "Storno-Zeitbuchung"
    Then fields have values
      | istzeit | -1                  |
      | mzeit   | -2                  |
      | typa332 | Storno-Auftragszeit |
    And I save the current editor

    Given I open an editor "Auftargszeit_pruef" from table "(Workorder):(CompletionConfirmations)" with command "VIEW" for search criteria "$,,such=AUFTRAGZ_001;bzeit=1;@richtung=rückwärts;@ablageart=abgelegt;@maxtreffer=1"
    Then fields have values
      | bzeit   | 1                      |
      | mzeit   | 2                      |
      | typa279 | Stornierte Zeitbuchung |
    And I close the current editor

# Betriebsauftrag löschen
    Given I open an editor "Betriebsauftrag" from table "(Workorder):(WorkOrders)" with command "UPDATE" for record "AUFTRAGZ_000"
    And I respond with answer "ja" to the dialog with id "345"
    And I set field "status" to "s"
    And I save the current editor

  Scenario: P08 Beim Storno einer Zeitbuchung werden die Mengen in den Reservierungen nicht geändert.
# Fertigungsvorschlag anlegen, freigeben und eine Zeitrückmeldung buchen
    Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
    And I append rows
      | artikel   | mge | mfreig | bisuch   |
      | BAUGRUPPE | 10  | ja     | ZEITMGE_ |
    And I press button "freig" to open a subeditor for "BA_freigeben"
    And I close the current editor
    And I switch the current editor to editor "fvor"
    And I save the current editor

    Given I open an editor "Arbeitsschein" from table "(Workorder):(WorkOrders)" with command "VIEW" for record "ZEITMGE_001"
    And I close the current editor

# Zeitbuchung erstellen und stornieren
    Given I open an editor "Zeitbuchung" for tip command "Zeitbuchung" and arguments ""
    And I set field "barmex" to "nummer" from editor "Arbeitsschein"
    And I set fields
      | sofort | 1                   |
      | mgr    | 101                 |
      | mzeit  | 1                   |
      | bzeit  | 1                   |
      | bem    | Zeitbuchung MgeTest |
    And I save the current editor

    Given I open an editor "Zeitbuchung_Storno" from table "(Workorder):(CompletionConfirmations)" with command "REVERSAL" for search criteria "$,,such=ZEITMGE_001;@richtung=rückwärts;@ablageart=abgelegt;@maxtreffer=1"
    And I set field "bem" to "Zeitkorrektur MgeTest"
    And I save the current editor

# Mengen im FV und den Reservierungen sind unverändert (limge=mge)
# Zeiten im Arbeitsschein sind reduziert
    Given I open the infosystem "PRODLIST"
    And I set field "kba" to "nummer" from editor "Arbeitsschein"
    And I set field "detail" to "ja"
    And I press start
    Then table has values
      | !row | netmge | frgmge |
      | 1    | 10     | 10     |
      | 2    | 20     | 20     |
      | 3    | 10     | 10     |
      | 4    | 10     | 10     |
    And I close the current editor

# Betriebsauftrag löschen
    Given I open an editor "Betriebsuaftrag" from table "(Workorder):(WorkOrders)" with command "UPDATE" for record "ZEITMGE_000"
    And I respond with answer "ja" to the dialog with id "345"
    And I set field "status" to "s"
    And I save the current editor


  Scenario: N01 Bis auf Bemerkung sind im Storno-Beleg einer Zeitkorrektur alle Felder schreibgeschützt
# Fertigungsvorschlag anlegen, freigeben und eine Rückmeldung buchen
    Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
    And I append rows
      | artikel   | mge | mfreig | bisuch     |
      | BAUGRUPPE | 10  | ja     | SCHREIBSK_ |
    And I press button "freig" to open a subeditor for "BA_freigeben"
    And I close the current editor
    And I switch the current editor to editor "fvor"
    And I save the current editor

    Given I open an editor "Arbeitsschein" from table "(Workorder):(WorkOrders)" with command "VIEW" for record "SCHREIBSK_001"
    And I close the current editor

# Zeitbuchung und Zeitkorrektur erstellen und stornieren
    Given I open an editor "Zeitbuchung" for tip command "Zeitbuchung" and arguments ""
    And I set field "barmex" to "nummer" from editor "Arbeitsschein"
    And I set fields
      | sofort | 1 |
      | mzeit  | 3 |
      | bzeit  | 3 |
    And I save the current editor

    Given I open an editor "Zeitkorrektur" for tip command "Zeitbuchung" and arguments ""
    And I set field "barmex" to "nummer" from editor "Arbeitsschein"
    And I set fields
      | sofort | 1  |
      | mzeit  | -1 |
      | bzeit  | -1 |
    And I save the current editor

    Given I open an editor "Zeitkorrektur_Storno" from table "(Workorder):(CompletionConfirmations)" with command "REVERSAL" for search criteria "$,,such=SCHREIBSK_001;@richtung=rückwärts;typa279=Zeitkorrektur;@ablageart=abgelegt;@maxtreffer=1"
    Then fields have values
      | mzeit | 1 |
      | bzeit | 1 |
    Then field "mzeit" is not modifiable
    Then field "bzeit" is not modifiable
    Then field "mgr" is not modifiable
    Then field "verw" is not modifiable
    Then field "kstelle" is not modifiable
    Then field "bem" is modifiable
    And I close the current editor

# Betriebsauftrag löschen
    Given I open an editor "Betriebsauftrag" from table "(Workorder):(WorkOrders)" with command "UPDATE" for record "SCHREIBSK_000"
    And I respond with answer "ja" to the dialog with id "345"
    And I set field "status" to "s"
    And I save the current editor


  Scenario: N02 Der Storno einer Zeitkorrektur auf den Arbeitsschein erzeugt eine Rückmeldung mit typ=Storno-Zeitkorrektur
# Fertigungsvorschlag anlegen, freigeben und eine Rückmeldung buchen
    Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
    And I append rows
      | artikel   | mge | mfreig | bisuch    |
      | BAUGRUPPE | 10  | ja     | ZEITKORR_ |
    And I press button "freig" to open a subeditor for "BA_freigeben"
    And I close the current editor
    And I switch the current editor to editor "fvor"
    And I save the current editor

    Given I open an editor "Arbeitsschein" from table "(Workorder):(WorkOrders)" with command "VIEW" for record "ZEITKORR_001"
    And I close the current editor

# Zeitbuchung und Zeitkorrektur erstellen und stornieren
    Given I open an editor "Zeitbuchung" for tip command "Zeitbuchung" and arguments ""
    And I set field "barmex" to "nummer" from editor "Arbeitsschein"
    And I set fields
      | sofort | 1 |
      | mzeit  | 3 |
      | bzeit  | 3 |
    And I save the current editor

    Given I open an editor "Zeitkorrektur" for tip command "Zeitbuchung" and arguments ""
    And I set field "barmex" to "nummer" from editor "Arbeitsschein"
    And I set fields
      | sofort | 1  |
      | mzeit  | -1 |
      | bzeit  | -1 |
    And I save the current editor

    Given I open an editor "Zeitkorrektur_Storno" from table "(Workorder):(CompletionConfirmations)" with command "REVERSAL" for search criteria "$,,such=ZEITKORR_001;@richtung=rückwärts;typa279=Zeitkorrektur;@ablageart=abgelegt;@maxtreffer=1"
    Then fields have values
      | mzeit | 1 |
      | bzeit | 1 |
    Then field "typa279" has value "Storno-Zeitkorrektur"
    And I save the current editor

    Given I open an editor "Zeitkorrektur_Orig" from table "(Workorder):(CompletionConfirmations)" with command "VIEW" for search criteria "$,,such=ZEITKORR_001;@richtung=rückwärts;bzeit=-1;@ablageart=abgelegt;@maxtreffer=1"
    Then fields have values
      | mzeit | -1 |
      | bzeit | -1 |
    Then field "typa279" has value "Stornierte Zeitkorrektur"
    And I close the current editor

# Betriebsauftrag löschen
    Given I open an editor "Betriebsuaftrag" from table "(Workorder):(WorkOrders)" with command "UPDATE" for record "ZEITKORR_000"
    And I respond with answer "ja" to the dialog with id "345"
    And I set field "status" to "s"
    And I save the current editor


  Scenario: N03 Das Feld Bemerkung wird in den Storno-Belegen der Zeitkorrektur vererbt
# Fertigungsvorschlag anlegen, freigeben und eine Rückmeldung buchen
    Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
    And I append rows
      | artikel   | mge | mfreig | bisuch |
      | BAUGRUPPE | 10  | ja     | BEMK_  |
    And I press button "freig" to open a subeditor for "BA_freigeben"
    And I close the current editor
    And I switch the current editor to editor "fvor"
    And I save the current editor

    Given I open an editor "Arbeitsschein" from table "(Workorder):(WorkOrders)" with command "VIEW" for record "BEMK_001"
    And I close the current editor

# Zeitbuchung und Zeitkorrektur erstellen
    Given I open an editor "Zeitbuchung" for tip command "Zeitbuchung" and arguments ""
    And I set field "barmex" to "nummer" from editor "Arbeitsschein"
    And I set fields
      | sofort | 1           |
      | mzeit  | 3           |
      | bzeit  | 3           |
      | bem    | Zeitbuchung |
    And I save the current editor

    Given I open an editor "Zeitkorrektur" for tip command "Zeitbuchung" and arguments ""
    And I set field "barmex" to "nummer" from editor "Arbeitsschein"
    And I set fields
      | sofort | 1             |
      | mzeit  | -1            |
      | bzeit  | -1            |
      | bem    | Zeitkorrektur |
    And I save the current editor

# Zeitkorrektur stornieren
    Given I open an editor "Zeitkorrektur_Storno" from table "(Workorder):(CompletionConfirmations)" with command "REVERSAL" for search criteria "$,,such=BEMK_001;@richtung=rückwärts;@ablageart=abgelegt;@maxtreffer=1"
    And I set field "bem" to "Zeitstorno"
    And I save the current editor

# Feld Bemerkung in Original- und Stornobeleg prüfen
    Given I open an editor "Zeitkorrektur" from table "(Workorder):(CompletionConfirmations)" with command "VIEW" for search criteria "$,,such=BEMK_001;typa279=Stornierte Zeitkorrektur;@richtung=rückwärts;@ablageart=abgelegt;@maxtreffer=1"
    Then field "bem" has value "Zeitkorrektur"
    And I close the current editor

    Given I open an editor "Zeitkorrektur" from table "(Workorder):(CompletionConfirmations)" with command "VIEW" for search criteria "$,,such=BEMK_001;typa279=Storno-Zeitkorrektur;@richtung=rückwärts;@ablageart=abgelegt;@maxtreffer=1"
    Then field "bem" has value "Zeitstorno"
    And I close the current editor

# Betriebsauftrag löschen
    Given I open an editor "Betriebsuaftrag" from table "(Workorder):(WorkOrders)" with command "UPDATE" for record "BEMK_000"
    And I respond with answer "ja" to the dialog with id "345"
    And I set field "status" to "s"
    And I save the current editor


  Scenario: N04 Durch den Storno einer Zeitkorrektur werden die Zeiten im Abreitsgang erhöht
# Fertigungsvorschlag anlegen, freigeben und eine Rückmeldung buchen
    Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
    And I append rows
      | artikel   | mge | mfreig | bisuch    |
      | BAUGRUPPE | 10  | ja     | ZEITKORR_ |
    And I press button "freig" to open a subeditor for "BA_freigeben"
    And I close the current editor
    And I switch the current editor to editor "fvor"
    And I save the current editor

    Given I open an editor "Arbeitsschein" from table "(Workorder):(WorkOrders)" with command "VIEW" for record "ZEITKORR_001"
    And I close the current editor

# Zeitbuchung und Zeitkorrektur erstellen und stornieren
    Given I open an editor "Zeitbuchung" for tip command "Zeitbuchung" and arguments ""
    And I set field "barmex" to "nummer" from editor "Arbeitsschein"
    And I set fields
      | sofort | 1 |
      | mzeit  | 3 |
      | bzeit  | 3 |
    And I save the current editor

    Given I open an editor "Zeitkorrektur" for tip command "Zeitbuchung" and arguments ""
    And I set field "barmex" to "nummer" from editor "Arbeitsschein"
    And I set fields
      | sofort | 1  |
      | mzeit  | -1 |
      | bzeit  | -1 |
    And I save the current editor

    Given I open an editor "Zeitkorrektur_Storno" from table "(Workorder):(CompletionConfirmations)" with command "REVERSAL" for search criteria "$,,such=ZEITKORR_001;@richtung=rückwärts;typa279=Zeitkorrektur;@ablageart=abgelegt;@maxtreffer=1"
    Then fields have values
      | mzeit | 1 |
      | bzeit | 1 |
    Then field "typa279" has value "Storno-Zeitkorrektur"
    And I save the current editor

    Given I open an editor "Zeitkorrektur_Orig" from table "(Workorder):(CompletionConfirmations)" with command "VIEW" for search criteria "$,,such=ZEITKORR_001;@richtung=rückwärts;bzeit=-1;@ablageart=abgelegt;@maxtreffer=1"
    Then fields have values
      | mzeit | -1 |
      | bzeit | -1 |
    Then field "typa279" has value "Stornierte Zeitkorrektur"
    And I close the current editor

# Zeiten im Arbeitsschein sind wieder erhöht
    Given I open the infosystem "PRODLIST"
    And I set field "kba" to "nummer" from editor "Arbeitsschein"
    And I set field "detail" to "ja"
    And I press start
    Then table has values
      | !row | bzeit | mzeit | vzeit |
      | 4    | 3     | 3     | 1.25  |
    And I close the current editor

# Betriebsauftrag löschen
    Given I open an editor "Betriebsauftrag" from table "(Workorder):(WorkOrders)" with command "UPDATE" for record "ZEITKORR_000"
    And I respond with answer "ja" to the dialog with id "345"
    And I set field "status" to "s"
    And I save the current editor


# Scenario: P05 Zeitkorrektur auf einen abgelegeten FV kann nicht storniert werden 
# kann mit Cucumber nicht getestet werden, manuell getestet: funktioniert


  Scenario: N06 Storno einer negativen Zeitmeldung in einem Kurzläufer, Typ Storno-Zeitkorrektur
# Mitarbeiter und Schichtplan anlegen
    Given I open an editor "mitarbeiter" from table "(Employee):(Employee)" with command "STORE" for record "BDE_MA"
    And I set fields
      | such  | BDE_MA |
      | splan | 303    |
      | lohn  | 1      |
    And I save the current editor

# Fertigungsvorschlag anlegen, freigeben und eine Rückmeldung buchen
    Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
    And I append rows
      | artikel   | mge | mfreig | bisuch     |
      | BAUGRUPPE | 10  | ja     | KURZLAUFN_ |
    And I press button "freig" to open a subeditor for "BA_freigeben"
    And I close the current editor
    And I switch the current editor to editor "fvor"
    And I save the current editor

    Given I open an editor "Rückmeldung1" from table "(Workorder):(WorkOrders)" with command "DONE" for record "KURZLAUFN_001"
    And I set fields
      | sofort | ja |
      | mzeit  | 1  |
      | bzeit  | 1  |
    And I save the current editor

# Kurzläufer auf Arbeitsschein 1
    Given I open an editor "Kurzläufer1" from table "(PDC):(ShortProductionOrder)" with command "NEW" for record ""
    And I set field "ma" to id from editor "mitarbeiter"
    And I set field "asma" to "barmex" from editor "Rückmeldung1"
    And I set fields
      | anfdat  | .    |
      | anfzeit | .    |
      | istzeit | -0.5 |
      | mzeit   | -0.5 |
      | sofort  | ja   |
    And I save the current editor

# Kurzläufer prüfen
    Given I open an editor "Kurzläufer_pruef1" from table "(Workorder):(CompletionConfirmations)" with command "VIEW" for search criteria "$,,such=KURZLAUFN_001;@richtung=rückwärts;@ablageart=abgelegt;@maxtreffer=1"
    Then field "typa279" has value "Zeitkorrektur"
    And I close the current editor

# Kurzläufer stornieren
    Given I open an editor "Kurzläufer_Storno" from table "(PDC):(ShortProductionOrder)" with command "REVERSAL" for record from editor "Kurzläufer1"
    Then fields have values
      | istzeit | 0.5                 |
      | mzeit   | 0.5                 |
      | sofort  | ja                  |
      | typa332 | Storno-Auftragszeit |
    And I save the current editor

# Betriebsauftrag abschließen
    Given I open an editor "Betriebsauftrag" from table "(Workorder):(WorkOrders)" with command "UPDATE" for record "KURZLAUFN_000"
    And I respond with answer "ja" to the dialog with id "345"
    And I set field "status" to "s"
    And I save the current editor


  Scenario: N07 Storno einer Rückmeldung, zu der es eine Zeitkorrektur gibt, nicht möglich
# Fertigungsvorschlag anlegen, freigeben und eine Rückmeldung buchen
    Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
    And I append rows
      | artikel   | mge | mfreig | bisuch   |
      | BAUGRUPPE | 10  | ja     | RUECKMR_ |
    And I press button "freig" to open a subeditor for "BA_freigeben"
    And I close the current editor
    And I switch the current editor to editor "fvor"
    And I save the current editor

    Given I open an editor "Arbeitsschein" from table "(Workorder):(WorkOrders)" with command "VIEW" for record "RUECKMR_001"
    And I close the current editor

# Rückmeldung und Zeitkorrektur erstellen
    Given I open an editor "Rückmeldung1" from table "(Workorder):(WorkOrders)" with command "DONE" for record "RUECKMR_001"
    And I set field "sofort" to "ja"
    And I set fields
      | mzeit | 3 |
      | bzeit | 3 |
    And I set field "gutmge" to "5" in row 1
    And I save the current editor

    Given I open an editor "Zeitkorrektur" for tip command "Zeitbuchung" and arguments ""
    And I set field "barmex" to "nummer" from editor "Rückmeldung1"
    And I set fields
      | sofort | 1  |
      | mzeit  | -1 |
      | bzeit  | -1 |
    And I save the current editor

# Rückmekdung1 stornieren
    Given I switch the current editor to editor "Rückmeldung1" with command "REVERSAL"
#  11126 de   |Die zurückzubuchende Maschinenzeit kann nicht größer als die bereits mit der Maschinengruppe gebuchte Maschinenzeit sein.
    Then saving the current editor throws the exception "11126"
    And I close the current editor

# Betriebsauftrag löschen
    Given I open an editor "Betriebsuaftrag" from table "(Workorder):(WorkOrders)" with command "UPDATE" for record "RUECKMR_000"
    And I respond with answer "ja" to the dialog with id "345"
    And I set field "status" to "s"
    And I save the current editor


######################################################################
# Bugfixes                                                           #
######################################################################

  Scenario: B01 Rundungsfehler bei der Arbeitszeit verhindert den Storno (Test 1)
# Fertigungsvorschlag anlegen, freigeben und eine Zeitbuchung buchen
    Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
    And I append rows
      | artikel   | mge | mfreig | bisuch |
      | BAUGRUPPE | 10  | ja     | BF01_  |
    And I press button "freig" to open a subeditor for "BA_freigeben"
    And I close the current editor
    And I switch the current editor to editor "fvor"
    And I save the current editor

# Zeitbuchung erstellen und stornieren
    Given I open an editor "Zeitbuchung" for tip command "Zeitbuchung" and arguments ""
    And I set field "barmex" to "BF01_001"
    And I set fields
      | sofort   | ja          |
      | flgksatz | 50          |
      | bzeit    | 0.07        |
      | bsatz    | 25.81       |
      | bem      | Zeitbuchung |
    And I save the current editor

# Typ in Original- und Stornobeleg prüfen
    Given I open an editor "Zeitbuchung_Storno" from table "(Workorder):(CompletionConfirmations)" with command "REVERSAL" for search criteria "$,,such=BF01_001;@richtung=rückwärts;@ablageart=abgelegt;@maxtreffer=1"
    Then field "typa279" has value "Storno-Zeitbuchung"
    And I set field "bem" to "Zeitbuch_Storno"
    And I save the current editor

    Given I open an editor "Zeitbuchung" from table "(Workorder):(CompletionConfirmations)" with command "VIEW" for search criteria "$,,such=BF01_001;bem=Zeitbuchung;@richtung=rückwärts;@ablageart=abgelegt;@maxtreffer=1"
    Then field "typa279" has value "Stornierte Zeitbuchung"
    And I close the current editor

# Betriebsauftrag löschen
    Given I open an editor "Betriebsuaftrag" from table "(Workorder):(WorkOrders)" with command "UPDATE" for record "BF01_000"
    And I respond with answer "ja" to the dialog with id "345"
    And I set field "status" to "s"
    And I save the current editor


  Scenario: B02 Rundungsfehler bei der Arbeitszeit verhindert den Storno (Test 2)
# Fertigungsvorschlag anlegen, freigeben und mehrere Zeitbuchungen buchen
    Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
    And I append rows
      | artikel   | mge | mfreig | bisuch |
      | BAUGRUPPE | 10  | ja     | BF02_  |
    And I press button "freig" to open a subeditor for "BA_freigeben"
    And I close the current editor
    And I switch the current editor to editor "fvor"
    And I save the current editor

# Zeitbuchung 1 erstellen
    Given I open an editor "Zeitbuchung" for tip command "Zeitbuchung" and arguments ""
    And I set field "barmex" to "BF02_001"
    And I set fields
      | sofort   | ja           |
      | flgksatz | 65           |
      | bzeit    | 0.15         |
      | bsatz    | 34.5         |
      | bem      | Zbuchung1    |
    And I save the current editor

# Zeitbuchung 2 erstellen und stornieren
    Given I open an editor "Zeitbuchung" for tip command "Zeitbuchung" and arguments ""
    And I set field "barmex" to "BF02_001"
    And I set fields
      | sofort   | ja           |
      | flgksatz | 65           |
      | bzeit    | -0.14        |
      | bsatz    | 34.5         |
      | bem      | Zbuchung2    |
    And I save the current editor

    Given I open an editor "Zeitbuchung_Storno" from table "(Workorder):(CompletionConfirmations)" with command "REVERSAL" for search criteria "$,,such=BF02_001;bem=Zbuchung2;@richtung=rückwärts;@ablageart=abgelegt;@maxtreffer=1"
    Then field "typa279" has value "Storno-Zeitkorrektur"
    And I set field "bem" to "Storno_Zbuchung2"
    And I save the current editor

# Zeitbuchung 3 erstellen und stornieren
    Given I open an editor "Zeitbuchung" for tip command "Zeitbuchung" and arguments ""
    And I set field "barmex" to "BF02_001"
    And I set fields
      | sofort   | ja           |
      | flgksatz | 65           |
      | bzeit    | -0.14        |
      | bsatz    | 34.5         |
      | bem      | Zbuchung3    |
    And I save the current editor

    Given I open an editor "Zeitbuchung_Storno" from table "(Workorder):(CompletionConfirmations)" with command "REVERSAL" for search criteria "$,,such=BF02_001;bem=Zbuchung3;@richtung=rückwärts;@ablageart=abgelegt;@maxtreffer=1"
    Then field "typa279" has value "Storno-Zeitkorrektur"
    And I set field "bem" to "Storno_Zbuchung3"
    And I save the current editor

# Zeitbuchung 4 erstellen und stornieren
    Given I open an editor "Zeitbuchung" for tip command "Zeitbuchung" and arguments ""
    And I set field "barmex" to "BF02_001"
    And I set fields
      | sofort   | ja           |
      | flgksatz | 65           |
      | bzeit    | 0.15         |
      | bsatz    | 34.5         |
      | bem      | Zbuchung4    |
    And I save the current editor

    Given I open an editor "Zeitbuchung_Storno" from table "(Workorder):(CompletionConfirmations)" with command "REVERSAL" for search criteria "$,,such=BF02_001;bem=Zbuchung4;@richtung=rückwärts;@ablageart=abgelegt;@maxtreffer=1"
    Then field "typa279" has value "Storno-Zeitbuchung"
    And I set field "bem" to "Storno_Zbuchung4"
    And I save the current editor

# Zeitbuchung 1 stornieren
    Given I open an editor "Zeitbuchung_Storno" from table "(Workorder):(CompletionConfirmations)" with command "REVERSAL" for search criteria "$,,such=BF02_001;bem=Zbuchung1;@richtung=rückwärts;@ablageart=abgelegt;@maxtreffer=1"
    Then field "typa279" has value "Storno-Zeitbuchung"
    And I set field "bem" to "Storno_Zbuchung1"
    And I save the current editor

# Betriebsauftrag löschen
    Given I open an editor "Betriebsuaftrag" from table "(Workorder):(WorkOrders)" with command "UPDATE" for record "BF02_000"
    And I respond with answer "ja" to the dialog with id "345"
    And I set field "status" to "s"
    And I save the current editor


  Scenario: B03 Rundungsfehler bei der Arbeitszeit verhindert den Storno (Test 3)
# Fertigungsvorschlag anlegen, freigeben und Zeitbuchung buchen
    Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
    And I append rows
      | artikel   | mge | mfreig | bisuch |
      | BAUGRUPPE | 10  | ja     | BF03_  |
    And I press button "freig" to open a subeditor for "BA_freigeben"
    And I close the current editor
    And I switch the current editor to editor "fvor"
    And I save the current editor

# Zeitbuchung erstellen
    Given I open an editor "Zeitbuchung" for tip command "Zeitbuchung" and arguments ""
    And I set field "barmex" to "BF03_001"
    And I set fields
      | ma       | 7801         |
      | lgr      | 1            |
      | bzeit    | 0.28         |
      | bsatz    | 26.08        |
      | ma2      | 7802         |
      | lgr2     | 1            |
      | bzeit2   | 0.28         |
      | bsatz2   | 26.08        |
      | ma3      | 1            |
      | lgr3     | 1            |
      | bzeit3   | 0.28         |
      | bsatz3   | 26.08        |
      | flgksatz | 140          |
      | bem      | Zbuchung1    |
      | sofort   | ja           |
    And I save the current editor

# Zeitbuchung stornieren
    Given I open an editor "Zeitbuchung_Storno" from table "(Workorder):(CompletionConfirmations)" with command "REVERSAL" for search criteria "$,,such=BF03_001;bem=Zbuchung1;@richtung=rückwärts;@ablageart=abgelegt;@maxtreffer=1"
    Then field "typa279" has value "Storno-Zeitbuchung"
    And I set field "bem" to "Storno_Zbuchung1"
    And I save the current editor

# Betriebsauftrag löschen
    Given I open an editor "Betriebsuaftrag" from table "(Workorder):(WorkOrders)" with command "UPDATE" for record "BF03_000"
    And I respond with answer "ja" to the dialog with id "345"
    And I set field "status" to "s"
    And I save the current editor

