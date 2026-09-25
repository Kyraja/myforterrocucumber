@persistent
Feature: bde.feature

  Background:
    And I set the fake date to "03.02.1995"
    Given I enable the flag 39

  # *****************************************************************************
  # Name             : bde
  # Autor            : amk
  # Verantwortlich   : amk
  # Kontrolle        : drpf
  # Funktion         : Diverse Einzeltests im Bereich BDE
  # ref              : ref_bde_cu
  #
  # *****************************************************************************
  #
  # FDA-5280: Auftragszeit/Kurzläufer kann nicht gebucht werden, wenn Nachfolger den BA reduziert hat.
  Scenario: 01 Kurzlaeufer buchen, wenn Nachfolger den BA reduziert hat
    # Mitarbeiter und Schichtplan anlegen
    Given I open an editor "mitarbeiter" from table "(Employee):(Employee)" with command "STORE" for record "BDE_MA"
    And I set fields
      | such  | KAI |
      | splan | 303 |
      | lohn  | 1   |
    And I save the current editor
    # Fertigungsvorschlag anlegen, freigeben und eine Rückmeldung buchen
    Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
    And I append rows
      | artikel | mge | mfreig | bisuch   | binoloe |
      | V3      | 100 | ja     | FDA5280_ | ja      |
    And I press button "freig" to open a subeditor for "BA_freigeben"
    And I close the current editor
    And I switch the current editor to editor "fvor"
    And I save the current editor
    # Kurzläufer auf Arbeitsschein 1
    Given I open an editor "Kurzläufer001" from table "(PDC):(ShortProductionOrder)" with command "NEW" for record ""
    And I set fields
      | ma            | KAI         |
      | asma          | FDA5280_001 |
      | anfdat        | .           |
      | anfzeit       | .           |
      | istzeit       | 2           |
      | mzeit         | 1           |
      | istmge        | 54          |
      | ausmge        | 7           |
      | mgereduzieren | ja          |
    And I save the current editor
    # Kurzläufer auf Arbeitsschein 3
    Given I open an editor "Kurzläufer003" from table "(PDC):(ShortProductionOrder)" with command "NEW" for record ""
    And I set fields
      | ma            | KAI         |
      | asma          | FDA5280_003 |
      | anfdat        | .           |
      | anfzeit       | .           |
      | istzeit       | 2           |
      | mzeit         | 1           |
      | istmge        | 50          |
      | ausmge        | 4           |
      | mgereduzieren | ja          |
    And I save the current editor
    # Kurzläufer auf Arbeitsschein 2
    Given I open an editor "Kurzläufer002" from table "(PDC):(ShortProductionOrder)" with command "NEW" for record ""
    And I set fields
      | ma      | KAI         |
      | asma    | FDA5280_002 |
      | anfdat  | .           |
      | anfzeit | .           |
      | istzeit | 2           |
      | mzeit   | 1           |
      | istmge  | 54          |
      | ausmge  | 0           |
      | sofort  | ja          |
    And I save the current editor

  Scenario: 02 Ueber Kurzlaeufer Menge erhoehen ist erlaubt
    # Fertigungsvorschlag anlegen, freigeben und eine Rückmeldung buchen
    Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
    And I append rows
      | artikel | mge | mfreig | bisuch | binoloe |
      | V3      | 100 | ja     | BDEUP_ | ja      |
    And I press button "freig" to open a subeditor for "BA_freigeben"
    And I close the current editor
    And I switch the current editor to editor "fvor"
    And I save the current editor
    # Kurzläufer auf Arbeitsschein 1
    Given I open an editor "Kurzläufer001" from table "(PDC):(ShortProductionOrder)" with command "NEW" for record ""
    And I set fields
      | ma            | KAI       |
      | asma          | BDEUP_001 |
      | anfdat        | .         |
      | anfzeit       | .         |
      | istzeit       | 2         |
      | mzeit         | 1         |
      | istmge        | 54        |
      | ausmge        | 7         |
      | mgereduzieren | ja        |
    And I save the current editor
    # Kurzläufer auf Arbeitsschein 3
    Given I open an editor "Kurzläufer003" from table "(PDC):(ShortProductionOrder)" with command "NEW" for record ""
    And I set fields
      | ma            | KAI       |
      | asma          | BDEUP_003 |
      | anfdat        | .         |
      | anfzeit       | .         |
      | istzeit       | 2         |
      | mzeit         | 1         |
      | istmge        | 50        |
      | ausmge        | 4         |
      | mgereduzieren | ja        |
    And I save the current editor
    # Kurzläufer auf Arbeitsschein 2
    Given I open an editor "Kurzläufer002" from table "(PDC):(ShortProductionOrder)" with command "NEW" for record ""
    And I set fields
      | ma      | KAI       |
      | asma    | BDEUP_002 |
      | anfdat  | .         |
      | anfzeit | .         |
      | istzeit | 2         |
      | mzeit   | 1         |
      | istmge  | 55        |
      | ausmge  | 0         |
      | sofort  | ja        |
    And I save the current editor

  # FDA-1781: Übertragen von BDE-Objekt prüft Mengen falls BA Status gesetzt und Gut
  Scenario: 03 Menge reduzieren ueber bereits gefertigte und reduzierte Gutmenge fuehrt zur Fehlermeldung beim uebertragen
    # Fertigungsvorschlag anlegen, freigeben und eine Rückmeldung buchen
    Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
    And I append rows
      | artikel | mge | mfreig | bisuch  | binoloe |
      | V3      | 100 | ja     | BDRDZ1_ | ja      |
    And I press button "freig" to open a subeditor for "BA_freigeben"
    And I close the current editor
    And I switch the current editor to editor "fvor"
    And I save the current editor
    # Kurzläufer auf Arbeitsschein 1
    Given I open an editor "Kurzläufer001" from table "(PDC):(ShortProductionOrder)" with command "NEW" for record ""
    And I set fields
      | ma      | KAI        |
      | asma    | BDRDZ1_001 |
      | anfdat  | .          |
      | anfzeit | .          |
      | istzeit | 2          |
      | mzeit   | 1          |
      | istmge  | 30         |
      | ausmge  | 0          |
      | sofort  | nein       |
    And I save the current editor
    # Kurzläufer auf Arbeitsschein 3
    Given I open an editor "Kurzläufer002" from table "(PDC):(ShortProductionOrder)" with command "NEW" for record ""
    And I set fields
      | ma            | KAI        |
      | asma          | BDRDZ1_002 |
      | anfdat        | .          |
      | anfzeit       | .          |
      | istzeit       | 2          |
      | mzeit         | 1          |
      | istmge        | 29         |
      | ausmge        | 0          |
      | mgereduzieren | ja         |
    And I save the current editor
    # Kurzläufer 1 übertragen -> Fehlermeldung
    Given I open an editor "Trans_Kurzl_002" from table "(PDC):(ShortProductionOrder)" with command "TRANSFER" for record from editor "Kurzläufer001"
    Then saving the current editor throws the exception "Fertigungsmenge wurde bereits auf 29,000 reduziert. Eine Erhöhung ist nicht möglich."
    And I close the current editor
    # Arbeitsschein 1 pruefen
    Given I open an editor "SC3_AS01_PRUEF" from table "(Workorder):(WorkOrders)" with command "VIEW" for record "BDRDZ1_001"
    Then field "rgutmge" has value "0"
    And field "rverlust" has value "0"
    And field "gutmgeauto" has value "29"
    And field "status" has value "-"
    And I close the current editor
    # Arbeitsschein 2 pruefen
    Given I open an editor "SC3_AS02_PRUEF" from table "(Workorder):(WorkOrders)" with command "VIEW" for record "BDRDZ1_002"
    And field "rgutmge" has value "29"
    And field "rverlust" has value "0"
    And field "gutmgeauto" has value "0"
    And field "status" has value "-"
    And I close the current editor


Scenario: 04 Auftragszeit kann geloescht werden, wenn nur angestempelt wurde und keine Endezeit vorhanden ist

Given I create a work order "BA04" for Product "BG1" with quantity "10" and search word "BA04_"

# Mitarbeiter und Schichtplan anlegen
Given I open an editor "mitarbeiter" from table "(Employee):(Employee)" with command "STORE" for record "BDE_MA_1"
And I set fields
    | such  | BDE_MA_1  |
    | splan | 303       |
    | lohn  | 1         |
And I save the current editor

Given I open the infosystem "WORKLIST"
And I set fields
    | mitarb  | BDE_MA_1    |
    | mgr     | 101         |
And I press start
And I press button "tproduktion" in row 1
And I close the current editor

Given I open an editor "Auftragszeit04" from table "(PDC):(OrderTime)" with command "VIEW" for search criteria "$,,ma==BDE_MA_1;@richtung=rückwärts;@maxordtreffer=1"
Then field "endzeit" is empty
And I close the current editor

Given I open an editor "Auftragszeit04" from table "(PDC):(OrderTime)" with command "DELETE" for record from editor "Auftragszeit04"
# 826 Wirklich loeschen?
And I respond with answer "ja" to the dialog with id "826"
And I save the current editor


Scenario: 05 Personalzeit kann nur geloescht werden, wenn es keine oder nur stornierte Auftragszeiten dazu gibt

# automatisches Auftragsende in der Konfiguration aktivieren
Given I open an editor "Konfiguration" from table "(Company):(Configuration)" with command "UPDATE" for record "0k"
And I set field "autobd" to "ja"
And I save the current editor

Given I open an editor "Personalzeit05" from table "(PDC):(TimeAndLaborData)" with command "NEW" for record ""
And I set fields
    | ma        | BDE_MA_1  |
    | anfdat    | .         |
    | anfzeit   | 8:00      |
    | enddat    | .         |
    | endzeit   | 16:00     |
And I save the current editor

# Arbeitsschein aus Scenario 04 oeffnen, um auf Nummer zugreifen zu koennen
Given I open an editor "AS" from table "(Workorder):(WorkOrders)" with command "VIEW" for search criteria "$,,such=BA04_001;@richtung=rückwärts;@maxordtreffer=1"
And I close the current editor

# Auftragszeit anlegen, Endezeit noch offen lassen
Given I open an editor "Auftragszeit05" from table "(PDC):(OrderTime)" with command "NEW" for record ""
And I set fields
    | ma        | BDE_MA_1      |
    | asma      | !AS^nummer    |
    | anfdat    | .             |
    | anfzeit   | 10:00         |
And I save the current editor

# Personalzeit loeschen nicht moeglich
Given I open an editor "Personalzeit_loeschen" from table "(PDC):(TimeAndLaborData)" with command "DELETE" for record from editor "Personalzeit05"
# 7905  Auftragszeit für diesen Zeitraum vorhanden. Löschen nicht möglich.
Then saving the current editor throws the exception "7905"
And I close the current editor

# in der angestempelten Auftragszeit Endezeit eintragen, noch nicht buchen
Given I open an editor "Auftragszeit05" from table "(PDC):(OrderTime)" with command "UPDATE" for record from editor "Auftragszeit05"
And I set field "endzeit" to "10:45"
And I save the current editor

# Personalzeit loeschen nicht moeglich
Given I open an editor "Personalzeit_loeschen" from table "(PDC):(TimeAndLaborData)" with command "DELETE" for record from editor "Personalzeit05"
# 7905  Auftragszeit für diesen Zeitraum vorhanden. Löschen nicht möglich.
Then saving the current editor throws the exception "7905"
And I close the current editor

# Auftragszeit buchen
Given I open an editor "Auftragszeit05" from table "(PDC):(OrderTime)" with command "UPDATE" for record from editor "Auftragszeit05"
And I set field "sofort" to "ja"
And I save the current editor

# Personalzeit loeschen nicht moeglich
Given I open an editor "Personalzeit_loeschen" from table "(PDC):(TimeAndLaborData)" with command "DELETE" for record from editor "Personalzeit05"
# 7905  Auftragszeit für diesen Zeitraum vorhanden. Löschen nicht möglich.
Then saving the current editor throws the exception "7905"
And I close the current editor

# Auftragszeit stornieren
Given I open an editor "Auftragszeit05" from table "(PDC):(OrderTime)" with command "REVERSAL" for record from editor "Auftragszeit05"
And I save the current editor

# Personalzeit loeschen moeglich
Given I open an editor "Personalzeit_loeschen" from table "(PDC):(TimeAndLaborData)" with command "DELETE" for record from editor "Personalzeit05"
# 826 Wirklich loeschen?
And I respond with answer "ja" to the dialog with id "826"
And I save the current editor

# automatisches Auftragsende in der Konfiguration wieder abschalten
Given I open an editor "Konfiguration" from table "(Company):(Configuration)" with command "UPDATE" for record "0k"
And I set field "autobd" to "nein"
And I save the current editor


Scenario: 06 Personalzeit kann immer geloescht werden, wenn automatisches Auftragsende in der Konfiguration NICHT aktiviert ist

Given I open an editor "Personalzeit06" from table "(PDC):(TimeAndLaborData)" with command "NEW" for record ""
And I set fields
    | ma        | BDE_MA_1  |
    | anfdat    | .         |
    | anfzeit   | 8:00      |
    | enddat    | .         |
    | endzeit   | 16:00     |
And I save the current editor

# Arbeitsschein aus Scenario 04 oeffnen, um auf Nummer zugreifen zu koennen
Given I open an editor "AS" from table "(Workorder):(WorkOrders)" with command "VIEW" for search criteria "$,,such=BA04_001;@richtung=rückwärts;@maxordtreffer=1"
And I close the current editor

# Auftragszeit anlegen, noch nicht buchen
Given I open an editor "Auftragszeit06" from table "(PDC):(OrderTime)" with command "NEW" for record ""
And I set fields
    | ma        | BDE_MA_1      |
    | asma      | !AS^nummer    |
    | anfdat    | .             |
    | anfzeit   | 11:00         |
    | enddat    | .             |
    | endzeit   | 11:30         |
And I save the current editor

# Personalzeit loeschen moeglich
Given I open an editor "Personalzeit_loeschen" from table "(PDC):(TimeAndLaborData)" with command "DELETE" for record from editor "Personalzeit06"
# 826 Wirklich loeschen?
And I respond with answer "ja" to the dialog with id "826"
And I save the current editor

# neue Personalzeit anlegen
Given I open an editor "Personalzeit06A" from table "(PDC):(TimeAndLaborData)" with command "NEW" for record ""
And I set fields
    | ma        | BDE_MA_1  |
    | anfdat    | .         |
    | anfzeit   | 12:00     |
    | enddat    | .         |
    | endzeit   | 20:00     |
And I save the current editor

# Arbeitsschein aus Scenario 04 oeffnen, um auf Nummer zugreifen zu koennen
Given I open an editor "AS" from table "(Workorder):(WorkOrders)" with command "VIEW" for search criteria "$,,such=BA04_001;@richtung=rückwärts;@maxordtreffer=1"
And I close the current editor

# Auftragszeit anlegen und buchen
Given I open an editor "Auftragszeit06A" from table "(PDC):(OrderTime)" with command "NEW" for record ""
And I set fields
    | ma        | BDE_MA_1      |
    | asma      | !AS^nummer    |
    | anfdat    | .             |
    | anfzeit   | 13:00         |
    | enddat    | .             |
    | endzeit   | 13:30         |
    | sofort    | ja            |
And I save the current editor

# Personalzeit loeschen moeglich
Given I open an editor "Personalzeit_loeschen" from table "(PDC):(TimeAndLaborData)" with command "DELETE" for record from editor "Personalzeit06A"
# 826 Wirklich loeschen?
And I respond with answer "ja" to the dialog with id "826"
And I save the current editor

# -------------------------------------------------------------------------------------------------------------- #
  Scenario Outline: Baugruppen Für Scenario 07 anlegen
    Given I open an editor "BGSC07" from table "(Part):(Product)" with command "STORE" for record "BGSC07"
    And I set fields
      | such      | <such>         |
      | namebspr  | <namebspr>     |
      | bsart     | Eigenfertigung |
    And I delete all rows
    And I append rows
      | elex    | anzahl    |
      | <elex1> | <anzahl1> |
      | <elex2> | <anzahl2> |
      | <elex3> | <anzahl3> |
    And I save the current editor
    Examples:
      | such   | namebspr              | elex1 | anzahl1 | elex2       | anzahl2 | elex3     | anzahl3 |
      | BGSC07 | Baugruppe Scenario 07 | EINK  | 1       | A AG-NOMANZ | 1       | A AG-NOGR | 1       |


Scenario: 07 FDA-1199 Konfigurierbar: Ist-Zeit des Werkers und Maschinenzeit
    # Felder manz, grgr, grgrruesten prüfen, ob sie richtig gesetzt wurden
    Given I open an editor "BGSC07" from table "(Part):(Product)" with command "VIEW" for record "BGSC07"
    Then field "manz" has value "0" in row 2
    And  field "grgr" has value "1" in row 2
    And  field "grgrruesten" has value "3" in row 2
    Then field "manz" has value "1" in row 3
    And  field "grgr" has value "0" in row 3
    And  field "grgrruesten" has value "0" in row 3
    And I close the current editor

    # Fertigungsvorschlag anlegen und freigeben
    Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
    And I append rows
      | artikel | mge | mfreig | bisuch  |
      | BGSC07  | 100 | ja     | BGSC07_ |
    And I press button "freig" to open a subeditor for "BA_freigeben"
    And I close the current editor
    And I switch the current editor to editor "fvor"
    And I save the current editor

    # Auftragszeit anlegen, nicht buchen, mzeit setzen, obwohl manz=0 => Hinweismeldung
    Given I open an editor "Auftragszeit07" from table "(PDC):(OrderTime)" with command "NEW" for record ""
    And I set fields
        | ma        | BDE_MA_1      |
        | asma      | BGSC07_001    |
        | anfdat    | .             |
        | anfzeit   | 7:30          |
        | enddat    | .             |
        | endzeit   | 11:30         |
        | automzeit | ja            |
    Then field "mzeit" has value "0"
    And I set field "mzeit" to "1.30"
    And I save the current editor

    # Kurzläufer anlegen, nicht buchen, istzeit setzen, obwohl grgr und grgrruesten=0 => Hinweismeldung
    Given I open an editor "Kurzläufer07" from table "(PDC):(ShortProductionOrder)" with command "NEW" for record ""
    And I set fields
      | ma            | BDE_MA_1    |
      | asma          | BGSC07_002  |
      | anfdat        | .           |
      | anfzeit       | .           |
    Then field "istzeit" has value "0"
    And I set field "istzeit" to "1.40"
    And I save the current editor


Scenario: 08 Feld tcharge testen
#ABS-895: BDE kennt tcharge und kann neue Chargen anlegen

Given I create a work order "WOBDE8" for Product "V1" with quantity "8" and search word "WOBDE8_"

Given I create a Lot "BDE8CH1" for Product "V1"

# Auftragszeit anlegen, vorhandene Charge eintragen
Given I open an editor "Auftragszeit08" from table "(PDC):(OrderTime)" with command "NEW" for record ""
Then field "tcharge" is not modifiable
And I set fields
    | ma        | BDE_MA_1      |
And I set field "asma" to "WOBDE8_001"
Then field "tcharge" is modifiable
And I set fields
    | anfdat    | .             |
    | anfzeit   | 08:00         |
    | charge    | BDE8CH1       |
Then field "tcharge" has value "BDE8CH1"
And I save the current editor

# Kurzläufer anlegen, neue Charge erzeugen dutrch Eintrag in das Feld tcharge
Given I open an editor "Kurzläufer08" from table "(PDC):(ShortProductionOrder)" with command "NEW" for record ""
Then field "tcharge" is not modifiable
And I set fields
    | ma        | BDE_MA_1      |
And I set field "asma" to "WOBDE8_001"
Then field "tcharge" is modifiable
And I set fields
  | anfdat        | .           |
  | anfzeit       | .           |
  | istzeit       | 0.8         |
  | tcharge       | BDE8CH2     |
And I save the current editor

# Prüfen, ob die neue Charge angelegt wurde
Given I open an editor "LOT8PRUF" from table "(Lots):(Lots)" with command "VIEW" for search criteria "$,,exnum=BDE8CH2;@maxtreffer=1;@ablageart=lebendig"
Then field "exnum" has value "BDE8CH2"
Then field "artikel" has value "V1"
And I close the current editor
