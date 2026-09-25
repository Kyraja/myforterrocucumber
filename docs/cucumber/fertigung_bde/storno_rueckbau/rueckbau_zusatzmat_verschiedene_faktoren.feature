Feature: rueckbau_zusatzmat_verschiedene_faktoren.feature

  Background:
    And I set the fake date to "03.02.1995"

  # *****************************************************************************
  # Name             : rueckbau_zusatzmat_verschiedene_faktoren
  # Autor            : lschneider
  # Verantwortlich   : amk
  # Kontrolle        : drpf
  # Funktion         : Testet Rückgaben von Material mit zusätzlichem chargen-
  # pflichtigem Material sowie die Rückgabe von Material mit
  # verschiedenen Faktoren
  # Jira-Issue       : FDA-1497
  # *****************************************************************************
  Scenario: 01 Storno Entnahme und Storno Rückgabe von zusätzlichem Material mit Charge über Rückmeldung
    # Bestandskorrektur auf 0
    Given I set StorageQuantity to zero for Product "EINKAUF-3" on StorageLocation "F1" with document "KORR_Z"
    # Charge anlegen
    Given I create a Lot "ZUSATZ_CH" for Product "EINKAUF-3"
    # Auftrag anlegen und Bedarfe zubuchen
    Given I create a SalesOrder "auftragZ" for Customer "RADSHOP" with Product "B_BAUGRUPPE" and quantity "10"
    Given I post a receipt via ManualStockAdjustment for Product "EINKAUF-1" and quantity "20" on StorageLocation "F1" with document "ZugangZ" and price "0"
    Given I post a receipt via ManualStockAdjustment for Product "EINKAUF-2" and quantity "10" on StorageLocation "F1" with document "ZugangZ" and price "0"
    Given I open an editor "Lbuchung" for tip command "Lbuchung" and arguments ""
    And I set fields
      | artikel | EINKAUF-3 |
      | beleg   | ZugangZ   |
      | beldat  | .         |
      | buart   | Zugang    |
    And I append rows
      | mge | platz2 | charge2       |
      | 6   | F1     | !ZUSATZ_CH^id |
    And I save the current editor
    # FV anlegen und freigeben
    Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
    And I append rows
      | artikel     | mge | mfreig | bisuch  |
      | B_BAUGRUPPE | 10  | ja     | ZUSMAT_ |
    And I press button "freig" to open a subeditor for "FVfreigeben"
    And I close the current editor
    And I switch the current editor to editor "fvor"
    And I close the current editor
    # Rückmeldungen mit zusätzlichem Material buchen
    Given I open an editor "Rückmeldung1" from table "(Workorder):(WorkOrders)" with command "DONE" for record "ZUSMAT_001"
    And I set field "sofort" to "ja"
    And I modify table
      | !row | artikel     | mge         | gutmge      | charge        |
      | 1    | !dontChange | !dontChange | 1           |               |
      | +2   | EINKAUF-3   | 3           | !dontChange | !ZUSATZ_CH^id |
    And I save the current editor
    And I wait 1 time units to move the time forward
    Given I open an editor "Rückmeldung2" from table "(Workorder):(WorkOrders)" with command "DONE" for record "ZUSMAT_001"
    And I set field "sofort" to "ja"
    And I modify table
      | !row | artikel     | mge         | gutmge      | charge        |
      | 1    | !dontChange | !dontChange | 1           |               |
      | +2   | EINKAUF-3   | 3           | !dontChange | !ZUSATZ_CH^id |
    And I save the current editor
    # Rückmeldung2 stornieren, Rückbau auf Rückmeldung1 und Storno des Rückbaus
    Given I open an editor "Rückmeldung2_Storno1" from table "(Workorder):(CompletionConfirmations)" with command "REVERSAL" for record from editor "Rückmeldung2"
    Then the table has 4 rows
    Then table has values
      | !row | artikel   | mge | charge^such |
      | 2    | EINKAUF-3 | -3  | ZUSATZ_CH   |
    And I save the current editor
    Given I open an editor "Rückbau1" from table "(Workorder):(WorkOrders)" with command "RETURN" for record "ZUSMAT_001"
    And I set field "sofort" to "ja"
    Then the table has 2 rows
    And I set field "charge" to "!ZUSATZ_CH^id" in row 2
    And I set field "mge" to "-2" in row 2
    And I save the current editor
    Given I open an editor "Rückbau1_Storno2" from table "(Workorder):(CompletionConfirmations)" with command "REVERSAL" for record from editor "Rückbau1"
    Then the table has 2 rows
    Then table has values
      | !row | artikel   | mge | charge^such |
      | 2    | EINKAUF-3 | 2   | ZUSATZ_CH   |
    And I save the current editor
    # LJ und Bestand zusätzliches Material prüfen
    Given I open the infosystem "LJ"
    And I set fields
      | artikel  | EINKAUF-3            |
      | beleg    | !Rückmeldung1^barmex |
      | richtung | rückwärts            |
    And I press start
    Then table has values
      | art       | amge | zmge | rueckmge | restmge | vcharge^such | vorgang^id               | storniert |
      | EINKAUF-3 | 2    |      | 2        | 0       | ZUSATZ_CH    | !Rückbau1_Storno2^id     | nein      |
      | EINKAUF-3 | -2   |      | -2       | 0       | ZUSATZ_CH    | !Rückbau1^id             | ja        |
      | EINKAUF-3 | -3   |      | -3       | 0       | ZUSATZ_CH    | !Rückmeldung2_Storno1^id | nein      |
      | EINKAUF-3 | 3    |      | 3        | 0       | ZUSATZ_CH    | !Rückmeldung2^id         | ja        |
      | EINKAUF-3 | 3    |      | 0        | 3       | ZUSATZ_CH    | !Rückmeldung1^id         | nein      |
    And I close the current editor
    Given I open the infosystem "BESTAND"
    And I set fields
      | artikel    | EINKAUF-3 |
      | klplatz    | F1        |
      | verdichten | nein      |
      | details    | nein      |
    And I press start
    And I press button "taufzu" in row 1
    Then the table has 3 rows
    Then table has values
      | lemge | gebmge | charge^such |
      | 3     |        |             |
      |       | 1      | ZUSATZ_CH   |
      |       | 2      | ZUSATZ_CH   |
    And I close the current editor
    # BA abschließen und auftrag liefern
    Given I open an editor "Rückmeldung3" from table "(Workorder):(WorkOrders)" with command "DONE" for record "ZUSMAT_001"
    And I set field "sofort" to "ja"
    And I set field "gut" to "ja"
    And I modify table
      | !row | artikel   | mge | charge        |
      | +2   | EINKAUF-3 | 3   | !ZUSATZ_CH^id |
    And I save the current editor
    Given I open the infosystem "BESTAND"
    And I set fields
      | artikel    | EINKAUF-3 |
      | klplatz    | F1        |
      | verdichten | nein      |
      | nullmge    | nein      |
      | details    | nein      |
    And I press start
    Then the table has 0 rows
    And I close the current editor
    And I deliver the SalesOrder "auftragZ" with PackingSlip "LS-Z01"

  Scenario: 02 Storno Entnahme und Storno Rückgabe von zusätzlichem Material mit Charge über Materialentnahme
    # Bestandskorrektur auf 0
    Given I set StorageQuantity to zero for Product "EINKAUF-3" on StorageLocation "F1" with document "KORR_Z2"
    # Charge anlegen
    Given I create a Lot "ZUSATZ2_CH" for Product "EINKAUF-3"
    # Auftrag anlegen und Bedarfe zubuchen
    Given I create a SalesOrder "auftragZ2" for Customer "RADSHOP" with Product "B_BAUGRUPPE" and quantity "10"
    Given I post a receipt via ManualStockAdjustment for Product "EINKAUF-1" and quantity "20" on StorageLocation "F1" with document "ZugangZ2" and price "0"
    Given I post a receipt via ManualStockAdjustment for Product "EINKAUF-2" and quantity "10" on StorageLocation "F1" with document "ZugangZ2" and price "0"
    Given I open an editor "Lbuchung" for tip command "Lbuchung" and arguments ""
    And I set fields
      | artikel | EINKAUF-3 |
      | beleg   | ZugangZ2  |
      | beldat  | .         |
      | buart   | Zugang    |
    And I append rows
      | mge | platz2 | charge2        |
      | 6   | F1     | !ZUSATZ2_CH^id |
    And I save the current editor
    # FV anlegen und freigeben
    Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
    And I append rows
      | artikel     | mge | mfreig | bisuch   |
      | B_BAUGRUPPE | 10  | ja     | ZUSMAT2_ |
    And I press button "freig" to open a subeditor for "FVfreigeben"
    And I close the current editor
    And I switch the current editor to editor "fvor"
    And I close the current editor
    Given I open an editor "Arbeitsschein1" from table "(Workorder):(WorkOrders)" with command "VIEW" for record "ZUSMAT2_001"
    And I close the current editor
    # Materialentnahme mit zusätzlichem Material buchen
    Given I open an editor "Materialentnahme1" for tip command "Fbuchung" and arguments ""
    And I set fields
      | auftrag | !Arbeitsschein1^nummer |
      | bem     | ZusMat2                |
    And I append rows
      | elex      | bumge | rescharge      |
      | EINKAUF-3 | 3     | !ZUSATZ2_CH^id |
    Then field "entmge" has value "0" in row 1
    Then field "chentmge" has value "0" in row 1
    And I save the current editor
    Given I open an editor "Materialentnahme1" from table "(Workorder):(CompletionConfirmations)" with command "VIEW" for search criteria "$,,such=ZUSMAT2_001;bem=ZusMat2;manrm=ja;@richtung=rückwärts;@ablageart=abgelegt;@maxordtreffer=1"
    And I close the current editor
    And I wait 1 time units to move the time forward
    Given I open an editor "Materialentnahme2" for tip command "Fbuchung" and arguments ""
    And I set fields
      | auftrag | !Arbeitsschein1^nummer |
      | bem     | ZusMat22               |
    And I append rows
      | elex      | bumge | rescharge      |
      | EINKAUF-3 | 3     | !ZUSATZ2_CH^id |
    Then field "entmge" has value "3" in row 1
    Then field "chentmge" has value "3" in row 1
    And I save the current editor
    Given I open an editor "Materialentnahme2" from table "(Workorder):(CompletionConfirmations)" with command "VIEW" for search criteria "$,,such=ZUSMAT2_001;bem=ZusMat22;manrm=ja;@richtung=rückwärts;@ablageart=abgelegt;@maxordtreffer=1"
    And I close the current editor
    # Rückmeldung2 stornieren, Rückbau auf Rückmeldung1 und Storno des Rückbaus
    Given I open an editor "Materialentnahme2_Storno1" from table "(Workorder):(CompletionConfirmations)" with command "REVERSAL" for record from editor "Materialentnahme2"
    Then the table has 2 rows
    Then table has values
      | !row | artikel   | mge | charge^such |
      | 2    | EINKAUF-3 | -3  | ZUSATZ2_CH  |
    And I save the current editor
    Given I open an editor "Materialrückgabe1" for tip command "Fbuchung" and arguments ""
    And I set fields
      | auftrag | !Arbeitsschein1^nummer |
      | bem     | ZusMatR2               |
    And I append rows
      | elex      | bumge | rescharge      |
      | EINKAUF-3 | -2    | !ZUSATZ2_CH^id |
    Then field "entmge" has value "3" in row 1
    Then field "chentmge" has value "3" in row 1
    And I save the current editor
    Given I open an editor "Materialrückgabe1" from table "(Workorder):(CompletionConfirmations)" with command "VIEW" for search criteria "$,,such=ZUSMAT2_001;bem=ZusMatR2;manrm=ja;@richtung=rückwärts;@ablageart=abgelegt;@maxordtreffer=1"
    And I close the current editor
    Given I open an editor "Rückgabe1_Storno2" from table "(Workorder):(CompletionConfirmations)" with command "REVERSAL" for record from editor "Materialrückgabe1"
    Then the table has 2 rows
    Then table has values
      | !row | artikel   | mge | charge^such |
      | 2    | EINKAUF-3 | 2   | ZUSATZ2_CH  |
    And I save the current editor
    # LJ und Bestand zusätzliches Material prüfen
    Given I open the infosystem "LJ"
    And I set fields
      | artikel  | EINKAUF-3              |
      | beleg    | !Arbeitsschein1^nummer |
      | richtung | rückwärts              |
    And I press start
    Then the table has 5 rows
    Then table has values
      | art       | amge | zmge | rueckmge | restmge | vcharge^such | storniert |
      | EINKAUF-3 | 2    |      | 2        | 0       | ZUSATZ2_CH   | nein      |
      | EINKAUF-3 | -2   |      | -2       | 0       | ZUSATZ2_CH   | ja        |
      | EINKAUF-3 | -3   |      | -3       | 0       | ZUSATZ2_CH   | nein      |
      | EINKAUF-3 | 3    |      | 3        | 0       | ZUSATZ2_CH   | ja        |
      | EINKAUF-3 | 3    |      | 0        | 3       | ZUSATZ2_CH   | nein      |
    And I close the current editor
    Given I open the infosystem "BESTAND"
    And I set fields
      | artikel    | EINKAUF-3 |
      | klplatz    | F1        |
      | verdichten | nein      |
      | details    | nein      |
    And I press start
    And I press button "taufzu" in row 1
    Then the table has 3 rows
    Then table has values
      | lemge | gebmge | charge^such |
      | 3     |        |             |
      |       | 1      | ZUSATZ2_CH  |
      |       | 2      | ZUSATZ2_CH  |
    And I close the current editor
    # BA abschließen und auftrag liefern
    Given I open an editor "Rückmeldung1" from table "(Workorder):(WorkOrders)" with command "DONE" for record "ZUSMAT2_001"
    And I set field "sofort" to "ja"
    And I set field "gut" to "ja"
    And I modify table
      | !row | artikel   | mge | charge         |
      | +2   | EINKAUF-3 | 3   | !ZUSATZ2_CH^id |
    And I save the current editor
    Given I open the infosystem "BESTAND"
    And I set fields
      | artikel    | EINKAUF-3 |
      | klplatz    | F1        |
      | verdichten | nein      |
      | nullmge    | nein      |
      | details    | nein      |
    And I press start
    Then the table has 0 rows
    And I close the current editor
    And I deliver the SalesOrder "auftragZ2" with PackingSlip "LS-Z02"

  Scenario: 03 Rückmeldungen und Entnahmen auf alle AS und BA, Rückbau und Materialrückgaben auf alle AS und BA
    # Bestände auf 0 korrigieren
    Given I set StorageQuantity to zero for Product "EINKAUF-1" on StorageLocation "F1" with document "KORR_B"
    Given I set StorageQuantity to zero for Product "EINKAUF-2" on StorageLocation "F1" with document "KORR_B"
    Given I set StorageQuantity to zero for Product "M_BAUGRUPPE2" on StorageLocation "F1" with document "KORR_B"
    # Auftrag anlegen und Bedarfe einkaufen
    Given I create a SalesOrder "auftragB" for Customer "RADSHOP" with Product "M_BAUGRUPPE2" and quantity "100"
    Given I open an editor "rechnungB" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
    And I set fields
      | lief   | KETTLER    |
      | vom    | .          |
      | ebeleg | Rechnung_B |
      | ueb    | ja         |
    And I append rows
      | artikel   | mge |
      | EINKAUF-1 | 200 |
      | EINKAUF-2 | 100 |
    And I set field "verw" in row 1 to "verw" from editor "auftragB" in row 1
    And I set field "verw" in row 2 to "verw" from editor "auftragB" in row 1
    And I respond with answer "ja" to the dialog with id "4841"
    And I save the current editor
    # FV anlegen und freigeben
    Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
    And I append rows
      | artikel      | mge | mfreig | bisuch  |
      | M_BAUGRUPPE2 | 100 | ja     | ZWEIAG_ |
    And I set field "verw" in row 1 to "verw" from editor "auftragB" in row 1
    And I press button "freig" to open a subeditor for "FVfreigeben"
    And I close the current editor
    And I switch the current editor to editor "fvor"
    And I close the current editor
    Given I open an editor "Betriebsauftrag" from table "(Workorder):(WorkOrders)" with command "VIEW" for record "ZWEIAG_000"
    And I close the current editor
    Given I open an editor "Arbeitsschein1" from table "(Workorder):(WorkOrders)" with command "VIEW" for record "ZWEIAG_001"
    And I close the current editor
    Given I open an editor "Arbeitsschein2" from table "(Workorder):(WorkOrders)" with command "VIEW" for record "ZWEIAG_002"
    And I close the current editor
    # Materialentnahme AS1 mit Material zu AS1 und Materialentnahme AS2 mit Material zu beiden AS
    Given I open an editor "Materialentnahme1" for tip command "Fbuchung" and arguments ""
    And I set fields
      | auftrag | !Arbeitsschein1^id |
      | bem     | MatEnt1            |
    And I press button "stlvblad"
    Then the table has 1 rows
    And I set field "bumge" to "20" in row 1
    Then field "entmge" has value "0" in row 1
    Then field "chentmge" has value "0" in row 1
    And I save the current editor
    Given I open an editor "Materialentnahme1" from table "(Workorder):(CompletionConfirmations)" with command "VIEW" for search criteria "$,,such=ZWEIAG_001;bem=MatEnt1;manrm=ja;@richtung=rückwärts;@ablageart=abgelegt;@maxordtreffer=1"
    And I close the current editor
    And I wait 1 time units to move the time forward
    Given I open an editor "Materialentnahme2" for tip command "Fbuchung" and arguments ""
    And I set fields
      | auftrag | !Arbeitsschein2^id |
      | bem     | MatEnt2            |
    And I press button "stllad"
    Then the table has 2 rows
    And I set field "bumge" to "20" in row 1
    And I set field "bumge" to "50" in row 2
    Then field "entmge" has value "20" in row 1
    Then field "chentmge" has value "20" in row 1
    Then field "entmge" has value "0" in row 2
    Then field "chentmge" has value "0" in row 2
    And I save the current editor
    Given I open an editor "Materialentnahme2" from table "(Workorder):(CompletionConfirmations)" with command "VIEW" for search criteria "$,,such=ZWEIAG_002;bem=MatEnt2;manrm=ja;@richtung=rückwärts;@ablageart=abgelegt;@maxordtreffer=1"
    And I close the current editor
    # Rückmeldung AS2, BA und wieder AS2
    Given I open an editor "Rückmeldung1" from table "(Workorder):(WorkOrders)" with command "DONE" for record "ZWEIAG_002"
    And I set field "sofort" to "ja"
    And I set field "gutmge" to "31" in row 1
    And I save the current editor
    And I wait 1 time units to move the time forward
    Given I open an editor "Rückmeldung2" from table "(Workorder):(WorkOrders)" with command "DONE" for record "ZWEIAG_000"
    And I set field "sofort" to "ja"
    And I set field "mgr" to "112"
    And I set field "gutmge" to "60" in row 1
    And I save the current editor
    And I wait 1 time units to move the time forward
    Given I open an editor "Rückmeldung3" from table "(Workorder):(WorkOrders)" with command "DONE" for record "ZWEIAG_002"
    And I set field "sofort" to "ja"
    And I set field "gutmge" to "2" in row 1
    And I save the current editor
    # Materialentnahme auf BA, beide Komponenten entnehmen
    And I wait 1 time units to move the time forward
    Given I open an editor "Materialentnahme3" for tip command "Fbuchung" and arguments ""
    And I set fields
      | auftrag | !Betriebsauftrag^nummer |
      | bem     | MatEnt3                 |
      | mgr     | 112                     |
    And I press button "stllad"
    Then the table has 2 rows
    And I set field "bumge" to "90" in row 1
    And I set field "bumge" to "60" in row 2
    Then field "entmge" has value "40" in row 1
    Then field "chentmge" has value "40" in row 1
    Then field "entmge" has value "50" in row 2
    Then field "chentmge" has value "50" in row 2
    And I save the current editor
    Given I open an editor "Materialentnahme3" from table "(Workorder):(CompletionConfirmations)" with command "VIEW" for search criteria "$,,such=ZWEIAG_000;bem=MatEnt3;manrm=ja;@richtung=rückwärts;@ablageart=abgelegt;@maxordtreffer=1"
    And I close the current editor
    # Rückbau auf BA
    Given I open an editor "Rückbau1" from table "(Workorder):(WorkOrders)" with command "RETURN" for record "ZWEIAG_000"
    And I set fields
      | sofort | ja     |
      | bem    | Rückb1 |
      | mgr    | 112    |
    And I set field "gutmge" to "-30" in row 1
    And I save the current editor
    # Materialrückgabe AS2 für beide Komponenten
    Given I open an editor "Materialrückgabe1" for tip command "Fbuchung" and arguments ""
    And I set fields
      | auftrag     | !Arbeitsschein2^nummer |
      | bem         | Rückg1                 |
      | gmgevorschl | -1                     |
    And I press button "stllad"
    Then the table has 2 rows
    And I set field "bumge" to "-30" in row 1
    And I set field "bumge" to "-30" in row 2
    Then field "entmge" has value "130" in row 1
    Then field "chentmge" has value "130" in row 1
    Then field "entmge" has value "110" in row 2
    Then field "chentmge" has value "110" in row 2
    And I save the current editor
    Given I open an editor "Materialrückgabe1" from table "(Workorder):(CompletionConfirmations)" with command "VIEW" for search criteria "$,,such=ZWEIAG_002;bem=Rückg1;manrm=ja;@richtung=rückwärts;@ablageart=abgelegt;@maxordtreffer=1"
    And I close the current editor
    # Materialrückgabe auf AS1 und AS2, jeweils das Material zum Arbeitsschein
    Given I open an editor "Materialrückgabe2" for tip command "Fbuchung" and arguments ""
    And I set fields
      | auftrag | !Arbeitsschein1^nummer |
      | bem     | Rückg2                 |
    And I press button "stlvblad"
    Then the table has 1 rows
    And I set field "bumge" to "-10" in row 1
    Then field "entmge" has value "100" in row 1
    Then field "chentmge" has value "100" in row 1
    And I save the current editor
    Given I open an editor "Materialrückgabe2" from table "(Workorder):(CompletionConfirmations)" with command "VIEW" for search criteria "$,,such=ZWEIAG_001;bem=Rückg2;manrm=ja;@richtung=rückwärts;@ablageart=abgelegt;@maxordtreffer=1"
    And I close the current editor
    Given I open an editor "Materialrückgabe3" for tip command "Fbuchung" and arguments ""
    And I set fields
      | auftrag | !Arbeitsschein2^nummer |
      | bem     | Rückg3                 |
    And I press button "stlvblad"
    Then the table has 1 rows
    And I set field "bumge" to "-10" in row 1
    Then field "entmge" has value "80" in row 1
    Then field "chentmge" has value "80" in row 1
    And I save the current editor
    Given I open an editor "Materialrückgabe3" from table "(Workorder):(CompletionConfirmations)" with command "VIEW" for search criteria "$,,such=ZWEIAG_002;bem=Rückg3;manrm=ja;@richtung=rückwärts;@ablageart=abgelegt;@maxordtreffer=1"
    And I close the current editor
    # Rückbau auf AS2
    Given I open an editor "Rückbau2" from table "(Workorder):(WorkOrders)" with command "RETURN" for record "ZWEIAG_002"
    And I set fields
      | sofort | ja     |
      | bem    | Rückb1 |
    And I set field "gutmge" to "-4" in row 1
    And I save the current editor
    # LJ Buchungen und Bestand prüfen
    Given I open the infosystem "LJ"
    # Buchungen auf den BA
    And I set fields
      | beleg    | !Betriebsauftrag^nummer |
      | richtung | rückwärts               |
    And I press start
    Then table has values
      | art          | amge | zmge | detursache                 | rueckmge | restmge |
      | M_BAUGRUPPE2 |      | -27  | Rückbau Fertigung          | -27      | 0       |
      | EINKAUF-1    | 90   |      | Materialentnahme Fertigung | 40       | 50      |
      | EINKAUF-2    | 60   |      | Materialentnahme Fertigung | 40       | 20      |
      | M_BAUGRUPPE2 |      | 29   | Rückmeldung Fertigung      | 29       | 0       |
    # Buchungen AS2
    And I set fields
      | beleg    | !Arbeitsschein2^nummer |
      | richtung | rückwärts              |
    And I press start
    Then table has values
      | art          | amge | zmge | detursache                 | rueckmge | restmge |
      | M_BAUGRUPPE2 |      | -2   | Rückbau Fertigung          | -2       | 0       |
      | M_BAUGRUPPE2 |      | -1   | Rückbau Fertigung          | -1       | 0       |
      | EINKAUF-2    | -10  |      | Materialrückgabe Fertigung | -10      | 0       |
      | EINKAUF-1    | -30  |      | Materialrückgabe Fertigung | -30      | 0       |
      | EINKAUF-2    | -30  |      | Materialrückgabe Fertigung | -30      | 0       |
      | M_BAUGRUPPE2 |      | 31   | Rückmeldung Fertigung      | 1        | 30      |
      | EINKAUF-1    | 20   |      | Materialentnahme Fertigung | 0        | 20      |
      | EINKAUF-2    | 50   |      | Materialentnahme Fertigung | 0        | 50      |
    # Buchungen AS1
    And I set fields
      | beleg    | !Arbeitsschein1^nummer |
      | richtung | rückwärts              |
    And I press start
    Then table has values
      | art       | amge | zmge | detursache                 | rueckmge | restmge |
      | EINKAUF-1 | -10  |      | Materialrückgabe Fertigung | -10      | 0       |
      | EINKAUF-1 | 20   |      | Materialentnahme Fertigung | 0        | 20      |
    And I close the current editor
    Given I open the infosystem "BESTAND"
    And I set fields
      | artikel    | EINKAUF-1 |
      | verdichten | nein      |
      | details    | nein      |
    And I press start
    And I press button "taufzu" in row 1
    Then the table has 4 rows
    Then table has values
      | lemge | gebmge | kopfzugvorg^id |
      | 110   |        | (0,0,0)        |
      |       | 70     | !rechnungB^id  |
      |       | 30     | !rechnungB^id  |
      |       | 10     | !rechnungB^id  |
    And I set fields
      | artikel | EINKAUF-2 |
      | details | nein      |
    And I press start
    And I press button "taufzu" in row 1
    Then the table has 3 rows
    Then table has values
      | lemge | gebmge | kopfzugvorg^id |
      | 30    |        | (0,0,0)        |
      |       | 20     | !rechnungB^id  |
      |       | 10     | !rechnungB^id  |
    And I set fields
      | artikel | M_BAUGRUPPE2 |
      | details | nein         |
    And I press start
    And I press button "taufzu" in row 1
    Then the table has 2 rows
    Then table has values
      | lemge | gebmge | kopfzugvorg^id   |
      | 30    |        | (0,0,0)          |
      |       | 30     | !Rückmeldung1^id |
    And I close the current editor

  Scenario: 04 Mehrere Materialrückgaben mit geänderten Faktoren, bisher Materialentnahme aus Lagerbestand
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
    Then field "entmge" has value "0" in row 1
    Then field "chentmge" has value "0" in row 1
    And I save the current editor
    Given I open an editor "Materialentnahme1" from table "(Workorder):(CompletionConfirmations)" with command "VIEW" for search criteria "$,,such=FAKTOR_001;bem=MatEnt1;manrm=ja;@richtung=rückwärts;@ablageart=abgelegt;@maxordtreffer=1"
    And I close the current editor
    Given I open the infosystem "BESTAND"
    And I set fields
      | artikel    | VERSCH-FAKTOR |
      | verdichten | nein          |
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
    Then field "entmge" has value "100" in row 1
    Then field "chentmge" has value "100" in row 1
    And I save the current editor
    Given I open the infosystem "BESTAND"
    And I set fields
      | artikel    | VERSCH-FAKTOR |
      | verdichten | nein          |
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
    Then field "entmge" has value "50" in row 1
    Then field "chentmge" has value "50" in row 1
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

  Scenario: 05 Materialrückgaben mit geänderten Faktoren, bisher zwei Materialentnahmen mit verschiedenen Faktoren aus Lagerbestand
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
    Then field "entmge" has value "0" in row 1
    Then field "chentmge" has value "0" in row 1
    And I save the current editor
    Given I open an editor "Materialentnahme1" from table "(Workorder):(CompletionConfirmations)" with command "VIEW" for search criteria "$,,such=FAKTOR2_001;bem=Mat2Ent1;manrm=ja;@richtung=rückwärts;@ablageart=abgelegt;@maxordtreffer=1"
    And I close the current editor
    And I wait 1 time units to move the time forward
    Given I open an editor "Materialentnahme2" for tip command "Fbuchung" and arguments ""
    And I set fields
      | auftrag | !Arbeitsschein1^nummer |
      | bem     | Mat2Ent2               |
    And I press button "stllad"
    And I modify table
      | bumge | bueinh | zele        | !row |
      | 1     | Satz   | !dontChange | 1    |
    Then field "entmge" has value "80" in row 1
    Then field "chentmge" has value "80" in row 1
    And I save the current editor
    Given I open an editor "Materialentnahme2" from table "(Workorder):(CompletionConfirmations)" with command "VIEW" for search criteria "$,,such=FAKTOR2_001;bem=Mat2Ent2;manrm=ja;@richtung=rückwärts;@ablageart=abgelegt;@maxordtreffer=1"
    And I close the current editor
    Given I open the infosystem "BESTAND"
    And I set fields
      | artikel    | VERSCH-FAKTOR |
      | verdichten | nein          |
      | details    | nein          |
    And I press start
    And I press button "taufzu" in row 1
    Then the table has 3 rows
    Then table has values
      | lemge | leinheit | gebmge | geinheit | gebf | kopfzugvorg^id |
      | 380   | kg       |        |          |      | (0,0,0)        |
      |       |          | 3      | Satz     | 100  | !rechnungF2^id |
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
    Then field "entmge" has value "180" in row 1
    Then field "chentmge" has value "180" in row 1
    And I save the current editor
    # Rückgabe2: 1 Satz mit Fakor 90 kann nicht zurückgelegt werden, daher Rückgabe in Lagereinheit
    And I wait 1 time units to move the time forward
    Given I open an editor "Materialrückgabe2" for tip command "Fbuchung" and arguments ""
    And I set fields
      | auftrag | !Arbeitsschein1^nummer |
      | bem     | Mat2Rück2              |
    And I press button "stllad"
    # Rückgabe in Satz und Faktor 90 nicht möglich
    # Fehler 122: Die letzte Entnahme hatte ein kleineres Gebinde. Bitte in Lagereinheit zurücklegen.
    And I set field "bumge" to "-1" in row 1
    And I set field "bueinh" to "Satz" in row 1
    And I set field "zele" to "90" in row 1
    Then saving the current editor throws the exception "224"
    # daher in Lagereinheit zurücklegen
    And I modify table
      | bumge | bueinh | !row |
      | -90   | kg     | 1    |
    Then field "entmge" has value "150" in row 1
    Then field "chentmge" has value "150" in row 1
    And I save the current editor
    # LJ und Bestand prüfen
    Given I open the infosystem "BESTAND"
    And I set fields
      | artikel    | VERSCH-FAKTOR |
      | verdichten | nein          |
      | details    | nein          |
    And I press start
    And I press button "taufzu" in row 1
    Then the table has 6 rows
    Then table has values
      | lemge | leinheit | gebmge | geinheit | gebf | kopfzugvorg^id |
      | 500   | kg       |        |          |      | (0,0,0)        |
      |       |          | 3      | Satz     | 100  | !rechnungF2^id |
      |       |          | 1      | Satz     | 80   | !rechnungF2^id |
      |       |          | 1      | Satz     | 30   | !rechnungF2^id |
      |       |          | 70     | kg       | 1    | !rechnungF2^id |
      |       |          | 20     | kg       | 1    | !rechnungF2^id |
    And I close the current editor
    Given I open the infosystem "LJ"
    And I set fields
      | artikel  | VERSCH-FAKTOR             |
      | beleg    | !Materialentnahme1^barmex |
      | richtung | rückwärts                 |
    And I press start
    Then the table has 5 rows
    Then table has values
      | art           | amge | mei  | leimei | rueckmge | restmge | !row |
      | VERSCH-FAKTOR | -20  | kg   | 1      | -20      | 0       | 1    |
      | VERSCH-FAKTOR | -70  | kg   | 1      | -70      | 0       | 2    |
      | VERSCH-FAKTOR | -1   | Satz | 30     | -30      | 0       | 3    |
      | VERSCH-FAKTOR | 1    | Satz | 100    | 100      | 0       | 4    |
      | VERSCH-FAKTOR | 1    | Satz | 80     | 20       | 60      | 5    |
    Then field "rueckorig^id" in row 1 has value equal to field "verweis^id" from editor "LJ" in row 5
    Then field "rueckorig^id" in row 2 has value equal to field "verweis^id" from editor "LJ" in row 4
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
      | +4   | 90     | kg   | !dontChange |
    And I save the current editor
    And I switch the current editor to editor "Materialentnahme3"
    Then field "entmge" has value "60" in row 1
    Then field "chentmge" has value "60" in row 1
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
    Then table has values
      | art           | amge | mei  | leimei | rueckmge | restmge | !row |
      | VERSCH-FAKTOR | 90   | kg   | 1      | 0        | 90      | 1    |
      | VERSCH-FAKTOR | 1    | Satz | 30     | 0        | 30      | 2    |
      | VERSCH-FAKTOR | 0.25 | Satz | 80     | 0        | 20      | 3    |
      | VERSCH-FAKTOR | 3    | Satz | 100    | 0        | 300     | 4    |
    And I close the current editor
    And I deliver the SalesOrder "auftragF2" with PackingSlip "LS-FAKT2"


  Scenario: 06 Entnahmen und Rückgaben von zusätzlichem Material mit Charge über Fbuchung
    # Test der Felder entmge und chentmge bei zusätzlichen Entnahmen

    # Charge anlegen
    Given I create a Lot "ZUS_CH_E-1A" for Product "B_EINKAUF-1"
    Given I create a Lot "ZUS_CH_E-2A" for Product "B_EINKAUF-2"
    Given I create a Lot "ZUS_CH_E-1B" for Product "B_EINKAUF-1"
    Given I create a Lot "ZUS_CH_E-2B" for Product "B_EINKAUF-2"
    # FV anlegen und freigeben
    Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
    And I append rows
      | artikel     | mge | mfreig | bisuch  |
      | M_BAUGRUPPE | 10  | ja     | ZUSM_   |
    And I press button "freig" to open a subeditor for "FVfreigeben"
    And I close the current editor
    And I switch the current editor to editor "fvor"
    And I close the current editor

    # Material entnehmen
    Given I open an editor "Materialentnahme1" for tip command "Fbuchung" and arguments ""
    And I set fields
      | auftrag     | ZUSM_001  |
      | gmgevorschl | 1         |
      | bem         | ZusMat-01 |
    And I press button "stllad"
    Then the table has 2 rows
    And I append rows
      | elex        | bumge | rescharge   |
      | B_EINKAUF-1 | 3     | ZUS_CH_E-1A |
      | B_EINKAUF-2 | 3     | ZUS_CH_E-2A |
      | EINK        | 3     |             |
    Then table has values
      | elex        | bumge | entmge | chentmge |
      | EINKAUF-1   |     2 |      0 |        0 |
      | EINKAUF-2   |     1 |      0 |        0 |
      | B_EINKAUF-1 |     3 |      0 |        0 |
      | B_EINKAUF-2 |     3 |      0 |        0 |
      | EINK        |     3 |      0 |        0 |
    And I save the current editor

    # Material entnehmen
    Given I open an editor "Materialentnahme2" for tip command "Fbuchung" and arguments ""
    And I set fields
      | auftrag     | ZUSM_001  |
      | gmgevorschl | 1         |
      | bem         | ZusMat-02 |
    And I press button "stllad"
    Then the table has 2 rows
    And I append rows
      | elex        | bumge | rescharge   |
      | B_EINKAUF-1 | 4     | ZUS_CH_E-1B |
      | B_EINKAUF-2 | 4     | ZUS_CH_E-2B |
      | EINK        | 4     |             |
    Then table has values
      | elex        | bumge | entmge | chentmge |
      | EINKAUF-1   |     2 |      2 |        2 |
      | EINKAUF-2   |     1 |      1 |        1 |
      | B_EINKAUF-1 |     4 |      3 |        0 |
      | B_EINKAUF-2 |     4 |      3 |        0 |
      | EINK        |     4 |      3 |        3 |
    And I save the current editor

    # Material entnehmen
    Given I open an editor "Materialentnahme3" for tip command "Fbuchung" and arguments ""
    And I set fields
      | auftrag     | ZUSM_001  |
      | gmgevorschl | 1         |
      | bem         | ZusMat-03 |
    And I press button "stllad"
    Then the table has 2 rows
    And I append rows
      | elex        | bumge | rescharge   |
      | B_EINKAUF-1 | 3     | ZUS_CH_E-1A |
      | B_EINKAUF-2 | 3     | ZUS_CH_E-2A |
      | EINK        | 3     |             |
      | B_EINKAUF-1 | 2     | ZUS_CH_E-1B |
      | B_EINKAUF-2 | 2     | ZUS_CH_E-2B |
      | EINK        | 2     |             |
    Then table has values
      | elex        | bumge | entmge | chentmge |
      | EINKAUF-1   |     2 |      4 |        4 |
      | EINKAUF-2   |     1 |      2 |        2 |
      | B_EINKAUF-1 |     3 |      7 |        3 |
      | B_EINKAUF-2 |     3 |      7 |        3 |
      | EINK        |     3 |      7 |        7 |
      | B_EINKAUF-1 |     2 |     10 |        4 |
      | B_EINKAUF-2 |     2 |     10 |        4 |
      | EINK        |     2 |     10 |       10 |
    And I save the current editor

    # Materialrückgabe
    Given I open an editor "Materialentnahme4" for tip command "Fbuchung" and arguments ""
    And I set fields
      | auftrag     | ZUSM_001  |
      | gmgevorschl | -1        |
      | bem         | ZusMat-04 |
    And I press button "stllad"
    Then the table has 5 rows
    Then table has values
      | !row                 | elex        | bumge | entmge | chentmge |
      | $,,elex==EINKAUF-1   | EINKAUF-1   |    -2 |      6 |        6 |
      | $,,elex==EINKAUF-2   | EINKAUF-2   |    -1 |      3 |        3 |
      | $,,elex==EINK        | EINK        |     0 |     12 |       12 |
      | $,,elex==B_EINKAUF-1 | B_EINKAUF-1 |     0 |     12 |        0 |
      | $,,elex==B_EINKAUF-2 | B_EINKAUF-2 |     0 |     12 |        0 |
    And I modify table
        | !row                | rescharge    | bumge |
        | elex=='EINK'        | !dontChange  | -1    |
        | elex=='B_EINKAUF-1' | ZUS_CH_E-1A  | -1    |
        | elex=='B_EINKAUF-2' | ZUS_CH_E-2A  | -1    |
    Then table has values
      | !row                 | elex        | bumge | entmge | chentmge |
      | $,,elex==EINKAUF-1   | EINKAUF-1   |    -2 |      6 |        6 |
      | $,,elex==EINKAUF-2   | EINKAUF-2   |    -1 |      3 |        3 |
      | $,,elex==EINK        | EINK        |    -1 |     12 |       12 |
      | $,,elex==B_EINKAUF-1 | B_EINKAUF-1 |    -1 |     12 |        6 |
      | $,,elex==B_EINKAUF-2 | B_EINKAUF-2 |    -1 |     12 |        6 |
    And I save the current editor

    # Material entnehmen
    Given I open an editor "Materialentnahme5" for tip command "Fbuchung" and arguments ""
    And I set fields
      | auftrag     | ZUSM_001  |
      | gmgevorschl | 1         |
      | bem         | ZusMat-05 |
    And I press button "stllad"
    Then the table has 2 rows
    And I append rows
      | elex        | bumge | rescharge   |
      | B_EINKAUF-1 | 2     |             |
      | B_EINKAUF-2 | 3     |             |
      | EINK        | 4     |             |
      | B_EINKAUF-1 | 1     |             |
      | B_EINKAUF-2 | 3     |             |
      | EINK        | 1     |             |
    Then table has values
      | elex        | bumge | entmge | chentmge |
      | EINKAUF-1   |     2 |      4 |        4 |
      | EINKAUF-2   |     1 |      2 |        2 |
      | B_EINKAUF-1 |     2 |     11 |        0 |
      | B_EINKAUF-2 |     3 |     11 |        0 |
      | EINK        |     4 |     11 |       11 |
      | B_EINKAUF-1 |     1 |     13 |        2 |
      | B_EINKAUF-2 |     3 |     14 |        3 |
      | EINK        |     1 |     15 |       15 |
    And I save the current editor

    And I wait 1 time units to move the time forward

    # Rückmeldung5 stornieren
    Given I open an editor "Materialentnahme5_Storno" from table "(Workorder):(CompletionConfirmations)" with command "REVERSAL" for search criteria "$,,such=ZUSM_001;bem=ZusMat-05;@richtung=rückwärts;@ablageart=abgelegt;@maxtreffer=1"
    And I save the current editor

    # Material entnehmen
    Given I open an editor "Materialentnahme6" for tip command "Fbuchung" and arguments ""
    And I set fields
      | auftrag     | ZUSM_001  |
      | gmgevorschl | 6         |
      | bem         | ZusMat-06 |
    And I press button "stllad"
    Then the table has 2 rows
    And I append rows
      | elex        | bumge | rescharge   | kompeig |
      | B_EINKAUF-1 | 9     |             |         |
      | B_EINKAUF-2 | 8     |             |         |
      | EINK        | 7     |             | Koppel  |
      | B_EINKAUF-1 | 6     | ZUS_CH_E-1A |         |
      | B_EINKAUF-2 | 5     |             | Koppel  |
      | EINK        | 4     |             |         |
      | B_EINKAUF-2 | 3     | ZUS_CH_E-2B | Koppel  |
      | EINK        | 2     |             | Koppel  |
      | B_EINKAUF-1 | 1     | ZUS_CH_E-1B | Koppel  |
    Then table has values
      | elex        | bumge | entmge | chentmge |
      | EINKAUF-1   |    12 |      4 |        4 |
      | EINKAUF-2   |     6 |      2 |        2 |
      | B_EINKAUF-1 |     9 |     11 |        0 |
      | B_EINKAUF-2 |     8 |     11 |        0 |
      | EINK        |     7 |      0 |        0 |
      | B_EINKAUF-1 |     6 |     20 |        5 |
      | B_EINKAUF-2 |     5 |      0 |        0 |
      | EINK        |     4 |     11 |       11 |
      | B_EINKAUF-2 |     3 |      5 |        5 |
      | EINK        |     2 |      7 |        7 |
      | B_EINKAUF-1 |     1 |      0 |        0 |

    And I save the current editor

    And I wait 1 time units to move the time forward

    # Rückmeldung6 stornieren
    Given I open an editor "Materialentnahme6_Storno" from table "(Workorder):(CompletionConfirmations)" with command "REVERSAL" for search criteria "$,,such=ZUSM_001;bem=ZusMat-06;@richtung=rückwärts;@ablageart=abgelegt;@maxtreffer=1"
    And I save the current editor

    And I wait 1 time units to move the time forward

    # Materialrückgabe
    Given I open an editor "Materialentnahme7" for tip command "Fbuchung" and arguments ""
    And I set fields
      | auftrag     | ZUSM_001  |
      | gmgevorschl | -2        |
      | bem         | ZusMat-07 |
    And I press button "stllad"
    Then the table has 8 rows
    Then table has values
      | elex        | bumge | entmge | chentmge |       kompeig |
      | EINKAUF-1   |    -4 |      4 |        4 |               |
      | EINKAUF-2   |    -2 |      2 |        2 |               |
      | EINK        |     0 |     11 |       11 |               |
      | EINK        |     0 |      0 |        0 | Koppelprodukt |
      | B_EINKAUF-1 |     0 |     11 |        0 |               |
      | B_EINKAUF-1 |     0 |      0 |        0 | Koppelprodukt |
      | B_EINKAUF-2 |     0 |     11 |        0 |               |
      | B_EINKAUF-2 |     0 |      0 |        0 | Koppelprodukt |
    And I set field "bumge" to "-1" in row 3
    And I set field "rescharge" to "ZUS_CH_E-1A" in row 5
    And I set field "bumge" to "-3" in row 5
    And I set field "rescharge" to "ZUS_CH_E-2A" in row 7
    And I set field "bumge" to "-2" in row 7
    Then table has values
      | elex        | bumge | entmge | chentmge |       kompeig |
      | EINKAUF-1   |    -4 |      4 |        4 |               |
      | EINKAUF-2   |    -2 |      2 |        2 |               |
      | EINK        |    -1 |     11 |       11 |               |
      | EINK        |     0 |      0 |        0 | Koppelprodukt |
      | B_EINKAUF-1 |    -3 |     11 |        5 |               |
      | B_EINKAUF-1 |     0 |      0 |        0 | Koppelprodukt |
      | B_EINKAUF-2 |    -2 |     11 |        5 |               |
      | B_EINKAUF-2 |     0 |      0 |        0 | Koppelprodukt |
    And I save the current editor

    # Rückmeldungen mit zusätzlichem Material buchen
    # BA abschließen
    Given I open an editor "Rückmeldung3" from table "(Workorder):(WorkOrders)" with command "DONE" for record "ZUSM_001"
    And I set field "sofort" to "ja"
    And I set field "gut" to "ja"
    And I set field "manrest" to "ja"
    And I save the current editor

