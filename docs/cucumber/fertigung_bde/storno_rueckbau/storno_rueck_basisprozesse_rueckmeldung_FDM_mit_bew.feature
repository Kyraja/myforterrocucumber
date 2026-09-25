@persistent
Feature: storno_rueck_rueckmeldung_basisprozesse_FDM_mit_bew.feature

  Background:
    And I set the fake date to "03.07.2002"

  # Stammdaten werden in der Version 2016r4n16 angelegt und basieren auf basis_stammdaten.feature
  # Bewertungsverfahren: Vorgangspreis (Abgang) und Preis des Zugangs (Zugang)


# **********************************************************************************
#  Name             : storno_rueck_rueckmeldung_basisprozesse_FDM_mit_bew
#  Autor            : lschneider und bschiga
#  Verantwortlich   : amk
#  Kontrolle        : drpf
#  Funktion         : Prozesse Teil 2 nach Upgrade auf Version 2019 oder höher
#
# **********************************************************************************
# FDA-1746


  Scenario: 01 Rückmeldungen auf ersten und zweiten Arbeitsschein buchen, schließen BA ab, vor Upgrade Rückmeldungen auf ersten und zweiten Arbeitsschein gebucht

    Given I'm logged in with password "annette"
    And I enable the flag 71
    And I execute FOP "RMKOP.REP"
    And I disable the flag 71
    Given I'm logged in with password "sy"

# Rückmeldungen aus 2016 prüfen
    Given I open an editor "Rückmeldung1_AS1" from table "(Workorder):(CompletionConfirmations)" with command "VIEW" for search criteria "$,,such=RFV01_001;@richtung=rückwärts;@maxordtreffer=1;@ablageart=abgelegt"
    Then table has values
      | artikel      | mge | gutmge | bumge | rueckmge | restmge | limgev | limgen |
      | UP_BG-BEDARF | 50  | 30     | 30    | 0        | 30      | 0      | 0      |
      | EK1-BEDARF   | 30  | 0      | 30    | 0        | 30      | 50     | 20     |
    And I close the current editor

    Given I open an editor "Rückmeldung1_AS2" from table "(Workorder):(CompletionConfirmations)" with command "VIEW" for search criteria "$,,such=RFV01_002;@richtung=rückwärts;@maxordtreffer=1;@ablageart=abgelegt"
    Then table has values
      | artikel      | mge | gutmge | bumge | rueckmge | restmge | limgev | limgen |
      | UP_BG-BEDARF | 50  | 25     | 25    | 0        | 25      | 0      | 0      |
      | EK2-BEDARF   | 25  | 0      | 25    | 0        | 25      | 50     | 25     |
    And I close the current editor

  # Rückmeldungen auf ersten und zweiten Arbeitsschein buchen, schließen BA ab
    Given I open an editor "Rückmeldung2_AS1" from table "(Workorder):(WorkOrders)" with command "DONE" for record "RFV01_001"
    And I set fields
      | mzeit  | 3  |
      | bzeit  | 3  |
      | sofort | ja |
    And I set field "gutmge" to "20" in row 1
    And I save the current editor

    Given I open an editor "Rückmeldung2_AS2" from table "(Workorder):(WorkOrders)" with command "DONE" for record "RFV01_002"
    And I set fields
      | mzeit  | 6  |
      | bzeit  | 6  |
      | sofort | ja |
    And I set field "gutmge" to "25" in row 1
    And I save the current editor

  # Lagerjournal prüfen
    Given I open the infosystem "LJ"
    And I set fields
      | beleg  | !Rückmeldung1_AS1^barmex |
      | adatum | -250                     |
      | edatum | .                        |
    And I press start
    Then table has values
      | art        | detursache            | amge | zmge | rueckmge | restmge | vorgang^id           |
      | EK1-BEDARF |                       | 30   |      | 0        | 30      | !Rückmeldung1_AS1^id |
      | EK1-BEDARF | Rückmeldung Fertigung | 20   |      | 0        | 20      | !Rückmeldung2_AS1^id |
    And I set fields
      | beleg | !Rückmeldung1_AS2^barmex |
    And I press start
    Then table has values
      | art          | detursache            | amge | zmge | rueckmge | restmge | vorgang^id           |
      | EK2-BEDARF   |                       | 25   |      | 0        | 25      | !Rückmeldung1_AS2^id |
      | UP_BG-BEDARF |                       |      | 25   | 0        | 25      | !Rückmeldung1_AS2^id |
      | EK2-BEDARF   | Rückmeldung Fertigung | 25   |      | 0        | 25      | !Rückmeldung2_AS2^id |
      | UP_BG-BEDARF | Rückmeldung Fertigung |      | 25   | 0        | 25      | !Rückmeldung2_AS2^id |
    And I close the current editor


  Scenario: 02 Rückmeldungen stornieren, vor Upgrade Rückmeldungen auf ersten und zweiten Arbeitsschein

  
  # Rückmeldungen aus 2016 öffnen
    Given I open an editor "Rückmeldung1_AS1" from table "(Workorder):(CompletionConfirmations)" with command "VIEW" for search criteria "$,,such=RFV02_001;@richtung=rückwärts;@maxordtreffer=1;@ablageart=abgelegt"
    And I close the current editor

    Given I open an editor "Rückmeldung1_AS2" from table "(Workorder):(CompletionConfirmations)" with command "VIEW" for search criteria "$,,such=RFV02_002;@richtung=rückwärts;@maxordtreffer=1;@ablageart=abgelegt"
    And I close the current editor

  # Storno der Rückmeldungen aus 2016
    Given I open an editor "STORNO_RM1_AS1" from table "(Workorder):(CompletionConfirmations)" with command "REVERSAL" for record from editor "Rückmeldung1_AS1"
    And I save the current editor

    Given I open an editor "STORNO_RM1_AS2" from table "(Workorder):(CompletionConfirmations)" with command "REVERSAL" for record from editor "Rückmeldung1_AS2"
    And I save the current editor
 

  # Rückmeldungen auf ersten und zweiten Arbeitsschein buchen, schließen BA ab
    Given I open an editor "Rückmeldung2_AS1" from table "(Workorder):(WorkOrders)" with command "DONE" for record "RFV02_001"
    And I set fields
      | mzeit  | 3  |
      | bzeit  | 3  |
      | sofort | ja |
      | gut    | ja |
    And I save the current editor


    Given I open an editor "Rückmeldung2_AS2" from table "(Workorder):(WorkOrders)" with command "DONE" for record "RFV02_002"
    And I set fields
      | mzeit  | 6  |
      | bzeit  | 6  |
      | sofort | ja |
      | gut    | ja |
    And I save the current editor


  # Lagerjournal prüfen
    Given I open the infosystem "LJ"
    And I set fields
      | beleg  | !Rückmeldung1_AS1^barmex |
      | adatum | -250                     |
      | edatum | .                        |
    And I press start
    Then table has values
      | art        | detursache                   | amge | zmge | rueckmge | restmge | vorgang^id           |
      | EK1-BEDARF |                              | 30   |      | 30       | 0       | !Rückmeldung1_AS1^id |
      | EK1-BEDARF | Storno-Rückmeldung Fertigung | -30  |      | -30      | 0       | !STORNO_RM1_AS1^id   |
      | EK1-BEDARF | Rückmeldung Fertigung        | 50   |      | 0        | 50      | !Rückmeldung2_AS1^id |
    And I set fields
      | beleg | !Rückmeldung1_AS2^barmex |
    And I press start
    Then table has values
      | art          | detursache                   | amge | zmge | rueckmge | restmge | vorgang^id           |
      | EK2-BEDARF   |                              | 25   |      | 25       | 0       | !Rückmeldung1_AS2^id |
      | UP_BG-BEDARF |                              |      | 25   | 25       | 0       | !Rückmeldung1_AS2^id |
      | EK2-BEDARF   | Storno-Rückmeldung Fertigung | -25  |      | -25      | 0       | !STORNO_RM1_AS2^id   |
      | UP_BG-BEDARF | Storno-Rückmeldung Fertigung |      | -25  | -25      | 0       | !STORNO_RM1_AS2^id   |
      | EK2-BEDARF   | Rückmeldung Fertigung        | 50   |      | 0        | 50      | !Rückmeldung2_AS2^id |
      | UP_BG-BEDARF | Rückmeldung Fertigung        |      | 50   | 0        | 50      | !Rückmeldung2_AS2^id |
    And I close the current editor


  Scenario: 03 Rückbau auf ersten und zweiten Arbeitsschein, vor Upgrade Rückmeldungen auf ersten und zweiten Arbeitsschein


  # Rückmeldungen aus 2016 öffnen
    Given I open an editor "Rückmeldung1_AS1" from table "(Workorder):(CompletionConfirmations)" with command "VIEW" for search criteria "$,,such=RFV03_001;@richtung=rückwärts;@maxordtreffer=1;@ablageart=abgelegt"
    And I close the current editor

    Given I open an editor "Rückmeldung1_AS2" from table "(Workorder):(CompletionConfirmations)" with command "VIEW" for search criteria "$,,such=RFV03_002;@richtung=rückwärts;@maxordtreffer=1;@ablageart=abgelegt"
    And I close the current editor

  # Rückbau auf ersten und zweiten Arbeitsschein mit positiven Zeiten buchen, Belege prüfen
  # Dadurch, dass auf AS2 nur 25 gebucht wurden, werden beim Rückbau auf AS1 zuerst nur 5 Stück rückgebaut
    Given I open an editor "RUECK_RM_AS1" from table "(Workorder):(WorkOrders)" with command "RETURN" for record "RFV03_001"
    And I set fields
      | mzeit  | 2  |
      | bzeit  | 2  |
      | sofort | ja |
    And I set field "gutmge" to "-10" in row 1
    And I save the current editor

    Given I open an editor "RUECK_RM_AS1" from table "(Workorder):(CompletionConfirmations)" with command "VIEW" for record "$,,such=RFV03_001;@richtung=rückwärts;@ablageart=abgelegt;@maxordtreffer=1"
    Then fields have values
      | typa279 | Rückbau auf Betriebsauftrag |
    Then table has values
      | artikel      | mge | gutmge | bumge | rueckmge | restmge | limgev | limgen |
      | UP_BG-BEDARF | 20  | -10    | -10   | 0        | -10     | 25     | 25     |
      | EK1-BEDARF   | -5  | 0      | -5    | -5       | 0       | 20     | 25     |
    And I close the current editor


    Given I open an editor "RUECK_RM_AS2" from table "(Workorder):(WorkOrders)" with command "RETURN" for record "RFV03_002"
    And I set fields
      | mzeit  | 2  |
      | bzeit  | 2  |
      | sofort | ja |
    And I set field "gutmge" to "-10" in row 1
    And I save the current editor


  # Lagerbewegungsjournal prüfen
    Given I open the infosystem "LJ"
    And I set fields
      | beleg  | !Rückmeldung1_AS1^barmex |
      | adatum | -250                     |
      | edatum | .                        |
    And I press start
    Then table has values
      | art        | detursache        | amge | zmge | rueckmge | restmge | vorgang^id           |
      | EK1-BEDARF |                   | 30   |      | 10       | 20      | !Rückmeldung1_AS1^id |
      | EK1-BEDARF | Rückbau Fertigung | -5   |      | -5       | 0       | !RUECK_RM_AS1^id     |
    And I set fields
      | beleg | !Rückmeldung1_AS2^barmex |
    And I press start
    Then table has values
      | art          | detursache        | amge | zmge | rueckmge | restmge | vorgang^id           |
      | EK2-BEDARF   |                   | 25   |      | 10       | 15      | !Rückmeldung1_AS2^id |
      | UP_BG-BEDARF |                   |      | 25   | 10       | 15      | !Rückmeldung1_AS2^id |
      | EK2-BEDARF   | Rückbau Fertigung | -10  |      | -10      | 0       | !RUECK_RM_AS2^id     |
      | EK1-BEDARF   | Rückbau Fertigung | -5   |      | -5       | 0       | !RUECK_RM_AS2^id     |
      | UP_BG-BEDARF | Rückbau Fertigung |      | -10  | -10      | 0       | !RUECK_RM_AS2^id     |
    And I close the current editor

  # BA abschließen
    Given I open an editor "Rückmeldung2_AS1" from table "(Workorder):(WorkOrders)" with command "DONE" for record "RFV03_001"
    And I set fields
      | mzeit  | 6  |
      | bzeit  | 6  |
      | sofort | ja |
      | gut    | ja |
    And I save the current editor

    Given I open an editor "Rückmeldung2_AS2" from table "(Workorder):(WorkOrders)" with command "DONE" for record "RFV03_002"
    And I set fields
      | mzeit  | 6  |
      | bzeit  | 6  |
      | sofort | ja |
      | gut    | ja |
    And I save the current editor


  Scenario: 04 Rückbau stornieren und Rückbau auf ersten und zweiten Arbeitsschein buchen, vor Upgrade Rückmeldungen und Rückbau Gutmenge auf ersten und zweiten Arbeitsschein

  # Rückbau aus 2016 öffnen
    Given I open an editor "Rückbau1_AS1" from table "(Workorder):(CompletionConfirmations)" with command "VIEW" for search criteria "$,,such=RFV04_001;@richtung=rückwärts;@maxordtreffer=1;@ablageart=abgelegt"
    And I close the current editor

    Given I open an editor "Rückbau1_AS2" from table "(Workorder):(CompletionConfirmations)" with command "VIEW" for search criteria "$,,such=RFV04_002;@richtung=rückwärts;@maxordtreffer=1;@ablageart=abgelegt"
    And I close the current editor

  # Rückbau aus Version 2016 stornieren ist nicht möglich (negative Menge in Rückmeldung)
  # 2199 de |Storno dieses Belegs nicht möglich, Material wurde bereits rückgebucht.
    Then opening an editor from table "(Workorder):(CompletionConfirmations)" with command "REVERSAL" for record from editor "Rückbau1_AS1" throws the exception "2199"

    Then opening an editor from table "(Workorder):(CompletionConfirmations)" with command "REVERSAL" for record from editor "Rückbau1_AS2" throws the exception "2199"

  # weiteren Rückbau buchen, auf AS1 und AS2
    Given I open an editor "RUECK_RM_AS1" from table "(Workorder):(WorkOrders)" with command "RETURN" for record "RFV04_001"
    And I set fields
      | mzeit  | 2  |
      | bzeit  | 2  |
      | sofort | ja |
    And I set field "gutmge" to "-10" in row 1
    And I save the current editor

    Given I open an editor "RUECK_RM_AS2" from table "(Workorder):(WorkOrders)" with command "RETURN" for record "RFV04_002"
    And I set fields
      | mzeit  | 2  |
      | bzeit  | 2  |
      | sofort | ja |
    And I set field "gutmge" to "-10" in row 1
    And I save the current editor


  Scenario: 05 Rückbau über beide Rückmeldungen pro Arbeitsschein, vor Upgrade je zwei Rückmeldungen auf ersten und zweiten Arbeitsschein


  # Rückmeldungen aus 2016 öffnen
    Given I open an editor "Rückmeldung1_AS1" from table "(Workorder):(CompletionConfirmations)" with command "VIEW" for search criteria "$,,such=RFV05_001;bem=RFV05_001_1;@richtung=rückwärts;@maxordtreffer=1;@ablageart=abgelegt"
    And I close the current editor

    Given I open an editor "Rückmeldung2_AS1" from table "(Workorder):(CompletionConfirmations)" with command "VIEW" for search criteria "$,,such=RFV05_002;bem=RFV05_002_1;@richtung=rückwärts;@maxordtreffer=1;@ablageart=abgelegt"
    And I close the current editor

    Given I open an editor "Rückmeldung1_AS2" from table "(Workorder):(CompletionConfirmations)" with command "VIEW" for search criteria "$,,such=RFV05_001;bem=RFV05_001_2;@richtung=rückwärts;@maxordtreffer=1;@ablageart=abgelegt"
    And I close the current editor

    Given I open an editor "Rückmeldung2_AS2" from table "(Workorder):(CompletionConfirmations)" with command "VIEW" for search criteria "$,,such=RFV05_002;bem=RFV05_002_2;@richtung=rückwärts;@maxordtreffer=1;@ablageart=abgelegt"
    And I close the current editor

  # Rückbau, der beide Rückmeldungen je Arbeitsschein betrifft
  # Rückbau Arbeitsschein 2
    Given I open an editor "RUECK_AS2" from table "(Workorder):(WorkOrders)" with command "RETURN" for record "RFV05_002"
    And I set fields
      | mzeit  | 2  |
      | bzeit  | 2  |
      | sofort | ja |
    And I set field "gutmge" to "-20" in row 1
    And I save the current editor

  # Rückbau Arbeitsschein 1
    Given I open an editor "RUECK_AS1" from table "(Workorder):(WorkOrders)" with command "RETURN" for record "RFV05_001"
    And I set fields
      | mzeit  | 2  |
      | bzeit  | 2  |
      | sofort | ja |
    And I set field "gutmge" to "-30" in row 1
    And I save the current editor


  Scenario: 06 Storno und Rückbau auf ersten und Rückmeldungen auf ersten Arbeitsschein buchen Koppelprodukt, nach Upgrade Rückbau und Storno Rückmeldungen mit Koppelprodukt


  # Rückmeldungen aus 2016 öffnen
    Given I open an editor "Rückmeldung1_AS1" from table "(Workorder):(CompletionConfirmations)" with command "VIEW" for search criteria "$,,such=RFV06_001;bem=RFV06_001_1;@richtung=rückwärts;@maxordtreffer=1;@ablageart=abgelegt"
    And I close the current editor

    Given I open an editor "Rückmeldung2_AS1" from table "(Workorder):(CompletionConfirmations)" with command "VIEW" for search criteria "$,,such=RFV06_001;bem=RFV06_001_2;@richtung=rückwärts;@maxordtreffer=1;@ablageart=abgelegt"
    And I close the current editor

  # Storno der zweiten Rückmeldung auf AS1
    Given I open an editor "STORNO_RM2_AS1" from table "(Workorder):(CompletionConfirmations)" with command "REVERSAL" for record from editor "Rückmeldung2_AS1"
    Then the table has 3 rows
    Then table has values
      | artikel      | ikompeig     | mge | gutmge |
      | UP_BG-KOPPEL |              | 10  | -20    |
      | EK1-BEDARF   |              | -20 | 0      |
      | KOPPELPROD   | icon:combine | -20 | 0      |
    And I save the current editor


  # Rückbau auf Arbeitsschein 1, Belege prüfen
    Given I open an editor "RUECK_RM1_AS1" from table "(Workorder):(WorkOrders)" with command "RETURN" for record "RFV06_001"
    And I set fields
      | mzeit  | 2  |
      | bzeit  | 2  |
      | sofort | ja |
    And I set field "gutmge" to "-5" in row 1
    And I save the current editor


    # Lagerbewegungsjournal prüfen
    Given I open the infosystem "LJ"
    And I set fields
      | beleg  | !Rückmeldung1_AS1^barmex |
      | adatum | -250                     |
      | edatum | .                        |
    And I press start
    Then table has values
      | art        | detursache                   | amge | zmge | rueckmge | restmge | vorgang^id           |
      | EK1-BEDARF |                              | 20   |      | 5        | 15      | !Rückmeldung1_AS1^id |
      | KOPPELPROD |                              |      | 20   | 5        | 15      | !Rückmeldung1_AS1^id |
      | EK1-BEDARF |                              | 20   |      | 20       | 0       | !Rückmeldung2_AS1^id |
      | KOPPELPROD |                              |      | 20   | 20       | 0       | !Rückmeldung2_AS1^id |
      | KOPPELPROD | Storno-Rückmeldung Fertigung |      | -20  | -20      | 0       | !STORNO_RM2_AS1^id   |
      | EK1-BEDARF | Storno-Rückmeldung Fertigung | -20  |      | -20      | 0       | !STORNO_RM2_AS1^id   |
      | KOPPELPROD | Rückbau Fertigung            |      | -5   | -5       | 0       | !RUECK_RM1_AS1^id    |
      | EK1-BEDARF | Rückbau Fertigung            | -5   |      | -5       | 0       | !RUECK_RM1_AS1^id    |
    And I close the current editor


## Scenario 07 entfällt ##


  Scenario: 08 Rückgaben von Stücklistenmaterial über Rückmeldung auf ersten und zweiten Arbeitsschein buchen, nach Upgrade Storno der Rückgaben

  # Rückgaben und Rückmeldungen aus 2016 öffnen
    Given I open an editor "Rückmeldung1_AS1" from table "(Workorder):(CompletionConfirmations)" with command "VIEW" for search criteria "$,,such=RFV08_001;bem=Rückmeldung;@richtung=rückwärts;@maxordtreffer=1;@ablageart=abgelegt"
    And I close the current editor

    Given I open an editor "Rückmeldung1_AS2" from table "(Workorder):(CompletionConfirmations)" with command "VIEW" for search criteria "$,,such=RFV08_002;bem=Rückmeldung;@richtung=rückwärts;@maxordtreffer=1;@ablageart=abgelegt"
    And I close the current editor

    Given I open an editor "Rückbau1_AS1" from table "(Workorder):(CompletionConfirmations)" with command "VIEW" for search criteria "$,,such=RFV08_001;bem=Rückbau Fertigung;@richtung=rückwärts;@maxordtreffer=1;@ablageart=abgelegt"
    And I close the current editor

    Given I open an editor "Rückbau1_AS2" from table "(Workorder):(CompletionConfirmations)" with command "VIEW" for search criteria "$,,such=RFV08_002;bem=Rückbau Fertigung;@richtung=rückwärts;@maxordtreffer=1;@ablageart=abgelegt"
    And I close the current editor

  # Rückbau Arbeitsschein 2 stornieren nicht möglich, da es alte Rückmeldung mit negativen Mengen ist
  #  2199 de   |Storno dieses Belegs nicht möglich, Material wurde bereits rückgebucht.
    Then opening an editor from table "(Workorder):(CompletionConfirmations)" with command "REVERSAL" for record from editor "Rückbau1_AS2" throws the exception "2199"

  # Rückbau Arbeitsschein 1 stornieren nicht möglich, da es alte Rückmeldung mit negativen Mengen ist
 #  2199 de   |Storno dieses Belegs nicht möglich, Material wurde bereits rückgebucht.
    Then opening an editor from table "(Workorder):(CompletionConfirmations)" with command "REVERSAL" for record from editor "Rückbau1_AS1" throws the exception "2199"


  # Rückmeldungen auf ersten und zweiten Arbeitsschein buchen, schließen BA ab
    Given I open an editor "Rückmeldung2_AS1" from table "(Workorder):(WorkOrders)" with command "DONE" for record "RFV08_001"
    And I set fields
      | mzeit  | 3  |
      | bzeit  | 3  |
      | sofort | ja |
      | gut    | ja |
    And I save the current editor


    Given I open an editor "Rückmeldung2_AS2" from table "(Workorder):(WorkOrders)" with command "DONE" for record "RFV08_002"
    And I set fields
      | mzeit  | 6  |
      | bzeit  | 6  |
      | sofort | ja |
      | gut    | ja |
    And I save the current editor


  Scenario: 09 Storno der Rückgaben über Rückmeldung von Material, das vorher nicht entnommen wurde, nicht möglich, vor Upgrade Buchen der Rückgaben

  # Rückgabebelege aus 2016 öffnen
    Given I open an editor "Rückgabe1_AS1" from table "(Workorder):(CompletionConfirmations)" with command "VIEW" for search criteria "$,,such=RFV09_001;bem=RFV09_001_1;@richtung=rückwärts;@maxordtreffer=1;@ablageart=abgelegt"
    And I close the current editor

    Given I open an editor "Rückgabe2_AS1" from table "(Workorder):(CompletionConfirmations)" with command "VIEW" for search criteria "$,,such=RFV09_001;bem=RFV09_001_2;@richtung=rückwärts;@maxordtreffer=1;@ablageart=abgelegt"
    And I close the current editor

    Given I open an editor "Rückgabe1_AS2" from table "(Workorder):(CompletionConfirmations)" with command "VIEW" for search criteria "$,,such=RFV09_002;bem=RFV09_002_1;@richtung=rückwärts;@maxordtreffer=1;@ablageart=abgelegt"
    And I close the current editor

    Given I open an editor "Rückgabe2_AS2" from table "(Workorder):(CompletionConfirmations)" with command "VIEW" for search criteria "$,,such=RFV09_002;bem=RFV09_002_2;@richtung=rückwärts;@maxordtreffer=1;@ablageart=abgelegt"
    And I close the current editor

  # Rückgaben Arbeitsschein 1 stornieren ist nicht möglich
  #  2199 de   |Storno dieses Belegs nicht möglich, Material wurde bereits rückgebucht.
    Then opening an editor from table "(Workorder):(CompletionConfirmations)" with command "REVERSAL" for record from editor "Rückgabe1_AS1" throws the exception "2199"
    
  # 9453 de |Rückmeldung ist zu alt. Storno nicht möglich, da Daten fehlen. Bitte Kommando Rückbau verwenden.
    Then opening an editor from table "(Workorder):(CompletionConfirmations)" with command "REVERSAL" for record from editor "Rückgabe2_AS1" throws the exception "9453"


  # Rückgaben Arbeitsschein 2 stornieren ist nicht möglich
    #  2199 de   |Storno dieses Belegs nicht möglich, Material wurde bereits rückgebucht.
    Then opening an editor from table "(Workorder):(CompletionConfirmations)" with command "REVERSAL" for record from editor "Rückgabe1_AS2" throws the exception "2199"

    Then opening an editor from table "(Workorder):(CompletionConfirmations)" with command "REVERSAL" for record from editor "Rückgabe2_AS2" throws the exception "2199"

  # Rückmeldungen auf ersten und zweiten Arbeitsschein buchen, schließen BA ab
    Given I open an editor "Rückmeldung2_AS1" from table "(Workorder):(WorkOrders)" with command "DONE" for record "RFV09_001"
    And I set fields
      | mzeit  | 3  |
      | bzeit  | 3  |
      | sofort | ja |
      | gut    | ja |
    And I save the current editor


    Given I open an editor "Rückmeldung2_AS2" from table "(Workorder):(WorkOrders)" with command "DONE" for record "RFV09_002"
    And I set fields
      | mzeit  | 6  |
      | bzeit  | 6  |
      | sofort | ja |
      | gut    | ja |
    And I save the current editor


  Scenario: 10 Storno der Rückmeldungen mit Ausschuss auf ersten und zweiten Arbeitsschein, vor Upgrade Rückmeldungen mit Ausschuss

  # Rückmeldungen aus 2016 öffnen
    Given I open an editor "Rückmeldung1_AS1" from table "(Workorder):(CompletionConfirmations)" with command "VIEW" for search criteria "$,,such=RFV10_001;@richtung=rückwärts;@maxordtreffer=1;@ablageart=abgelegt"
    And I close the current editor

    Given I open an editor "Rückmeldung1_AS2" from table "(Workorder):(CompletionConfirmations)" with command "VIEW" for search criteria "$,,such=RFV10_002;@richtung=rückwärts;@maxordtreffer=1;@ablageart=abgelegt"
    And I close the current editor

  # Rückmeldungen mit Ausschuss stornieren
    Given I open an editor "STORNO_RM1_AS2" from table "(Workorder):(CompletionConfirmations)" with command "REVERSAL" for record from editor "Rückmeldung1_AS2"
    And I save the current editor

    Given I open an editor "STORNO_RM1_AS1" from table "(Workorder):(CompletionConfirmations)" with command "REVERSAL" for record from editor "Rückmeldung1_AS1"
    And I save the current editor


  Scenario: 11 Storno von gemischten Belegen, vor Upgrade Rückbau mit Entnahme Zusatzmaterial über Rückmeldung auf ersten und zweiten Arbeitsschein


  # Rückgaben aus 2016 öffnen
    Given I open an editor "Rückbau1_AS1" from table "(Workorder):(CompletionConfirmations)" with command "VIEW" for search criteria "$,,such=RFV11_001;@richtung=rückwärts;@maxordtreffer=1;@ablageart=abgelegt"
    And I close the current editor

    Given I open an editor "Rückbau1_AS2" from table "(Workorder):(CompletionConfirmations)" with command "VIEW" for search criteria "$,,such=RFV11_002;@richtung=rückwärts;@maxordtreffer=1;@ablageart=abgelegt"
    And I close the current editor

  # Storno der Rückbauten führt zu Fehlermeldung
  # 2199 de |Storno dieses Belegs nicht möglich, Material wurde bereits rückgebucht.
    Given opening an editor from table "(Workorder):(CompletionConfirmations)" with command "REVERSAL" for record from editor "Rückbau1_AS2" throws the exception "2199"
    And I close the current editor

    Given opening an editor from table "(Workorder):(CompletionConfirmations)" with command "REVERSAL" for record from editor "Rückbau1_AS1" throws the exception "2199"
    And I close the current editor

  # Rückmeldungen auf ersten und zweiten Arbeitsschein buchen, schließen BA ab
    Given I open an editor "Rückmeldung2_AS1" from table "(Workorder):(WorkOrders)" with command "DONE" for record "RFV11_001"
    And I set fields
      | mzeit  | 3  |
      | bzeit  | 3  |
      | sofort | ja |
      | gut    | ja |
    And I save the current editor


    Given I open an editor "Rückmeldung2_AS2" from table "(Workorder):(WorkOrders)" with command "DONE" for record "RFV11_002"
    And I set fields
      | mzeit  | 6  |
      | bzeit  | 6  |
      | sofort | ja |
      | gut    | ja |
    And I save the current editor


  Scenario: 12 Storno Rückmeldung auf AS2 und weitere Rückgabe auf AS1 bei BA mit Löschschutz, vor Upgrade Rückmeldung Gesamtmemgen und Rückbau auf ersten Arbeitsschein


  # Rückmeldungen und Rückbauten aus 2016 öffnen

    Given I open an editor "Rückmeldung1_AS1" from table "(Workorder):(CompletionConfirmations)" with command "VIEW" for search criteria "$,,such=RFV12_001;bem=RFV12_001_1;@richtung=rückwärts;@maxordtreffer=1;@ablageart=abgelegt"
    And I close the current editor

    Given I open an editor "Rückmeldung1_AS2" from table "(Workorder):(CompletionConfirmations)" with command "VIEW" for search criteria "$,,such=RFV12_002;bem=RFV12_002_1;@richtung=rückwärts;@maxordtreffer=1;@ablageart=abgelegt"
    And I close the current editor

    Given I open an editor "Rückmeldung2_AS2" from table "(Workorder):(CompletionConfirmations)" with command "VIEW" for search criteria "$,,such=RFV12_002;bem=RFV12_002_2;@richtung=rückwärts;@maxordtreffer=1;@ablageart=abgelegt"
    And I close the current editor
    
  # Rückgaben aus 2016 öffnen
    Given I open an editor "Rückbau1_AS1" from table "(Workorder):(CompletionConfirmations)" with command "VIEW" for search criteria "$,,such=RFV12_001;bem=`;@richtung=rückwärts;@maxordtreffer=1;@ablageart=abgelegt"
    And I close the current editor

    
  # Storno Rückmeldung 1 Arbeitsschein 2
  ##  9503 de   |Rückmeldung kann nicht storniert werden da bereits eine weitere Buchung auf den letzten Arbeitsschein/Betriebsauftrag erfolgt ist.
    Given opening an editor from table "(Workorder):(CompletionConfirmations)" with command "REVERSAL" for record from editor "Rückmeldung1_AS2" throws the exception "9503"
    And I close the current editor
  
  
  # Storno Rückmeldung 2 Arbeitsschein 2
    Given I open an editor "STORNO_RM2_AS2" from table "(Workorder):(CompletionConfirmations)" with command "REVERSAL" for record from editor "Rückmeldung2_AS2"
    And I save the current editor
  
  
  # Storno Rückmeldung 1 Arbeitsschein 1
   #  2199 de   |Storno dieses Belegs nicht möglich, Material wurde bereits rückgebucht.
    Given opening an editor from table "(Workorder):(CompletionConfirmations)" with command "REVERSAL" for record from editor "Rückmeldung1_AS1" throws the exception "2199"
    And I close the current editor

   # weiterer Rückbau auf Arbeitsschein 1
    Given I open an editor "RUECK_RM1_AS1" from table "(Workorder):(WorkOrders)" with command "RETURN" for record "RFV12_001"
    And I set fields
      | mzeit  | 2  |
      | bzeit  | 2  |
      | sofort | ja |
    And I set field "gutmge" to "-2" in row 1
    And I save the current editor


# Offene Mengen in Reservierung prüfen
## AS 2 war überbucht, limge 30 ist korrekt, trotz Storno 35
    Given I open an editor "Betriebsauftrag" from table "(Workorder):(WorkOrders)" with command "VIEW" for search criteria "$,,such=RFV12_000;@richtung=rückwärts;@maxtreffer=1"
    And I press button "absteig" to open a subeditor for "AFL12"
    Then table has values
      | elex       | limge | frgmge | !row |
      | EK1-BEDARF | 7     | 7      | 1    |
      | A AG-LOHN1 | 7     | 7      | 2    |
      | EK2-BEDARF | 30    | 30     | 3    |
      | A AG-LOHN2 | 30    | 30     | 4    |
    And I close the current subeditor to switch back to the parent editor
    And I close the current editor


  Scenario: 13 Ungebuchte Rückmeldung auf ersten und zweiten Arbeitsschein, nach Upgrade Rückmeldungen buchen und Storno der Rückmeldungen


# Rückmeldungen buchen
    Given I open an editor "Rückmeldung1_AS1" from table "(Workorder):(WorkOrders)" with command "TRANSFER" for record "RFV13_001"
    And I save the current editor

    Given I open an editor "Rückmeldung1_AS2" from table "(Workorder):(WorkOrders)" with command "TRANSFER" for record "RFV13_002"
    And I save the current editor
    
# Storno Rückmeldung Arbeitsschein 2
    Given I open an editor "STORNO_RM1_AS2" from table "(Workorder):(CompletionConfirmations)" with command "REVERSAL" for record from editor "Rückmeldung1_AS2"
    And I save the current editor

 
 # Belege prüfen
 # Rückmeldung Arbeitsschein 1
    Given I switch the current editor to editor "Rückmeldung1_AS1" with command "VIEW"
    Then table has values
      | artikel      | mge | gutmge | bumge | rueckmge | restmge | limgev | limgen |
      | UP_BG-BEDARF | 50  | 25     | 25    | 0        | 25      | 0      | 0      |
      | EK1-BEDARF   | 25  | 0      | 25    | 0        | 25      | 50     | 25     |
    And I close the current editor
    
 # Rückmeldung und Storno-Rückmeldung Arbeitsschein 2
    Given I switch the current editor to editor "STORNO_RM1_AS2" with command "VIEW"
    Then fields have values
      | typa279              | Storno-Rückmeldung   |
      | stornopartnervorg^id | !Rückmeldung1_AS2^id |
    Then table has values
      | artikel      | mge | gutmge | bumge | rueckmge | restmge | limgev | limgen |
      | UP_BG-BEDARF | 25  | -25    | -25   | 0        | -25     | 25     | 0      |
      | EK2-BEDARF   | -25 | 0      | -25   | 0        | -25     | 25     | 50     |
    And I close the current editor

    And I switch the current editor to editor "Rückmeldung1_AS2" with command "VIEW"
    Then fields have values
      | typa279              | Stornierte Rückmeldung |
      | stornopartnervorg^id | !STORNO_RM1_AS2^id     |
    Then table has values
      | artikel      | mge | gutmge | bumge | rueckmge | restmge | limgev | limgen |
      | UP_BG-BEDARF | 50  | 25     | 25    | 0        | 25      | 0      | 25     |
      | EK2-BEDARF   | 25  | 0      | 25    | 0        | 25      | 50     | 25     |
    And I close the current editor


  Scenario: 14 Ungebuchte Rückmeldung auf ersten und zweiten Arbeitsschein, nach Upgrade Rückmeldungen buchen und Rückbau


# Rückmeldungen buchen
    Given I open an editor "Rückmeldung1_AS1" from table "(Workorder):(WorkOrders)" with command "TRANSFER" for record "RFV14_001"
    And I save the current editor

    Given I open an editor "Rückmeldung1_AS2" from table "(Workorder):(WorkOrders)" with command "TRANSFER" for record "RFV14_002"
    And I save the current editor


# Rückbau auf Arbeitsschein 2, Belege prüfen
    Given I open an editor "RUECK_RM1_AS2" from table "(Workorder):(WorkOrders)" with command "RETURN" for record "RFV14_002"
    And I set fields
      | mzeit  | 2  |
      | bzeit  | 2  |
      | sofort | ja |
    And I set field "gutmge" to "-5" in row 1
    And I save the current editor
    
# Rückbau auf Arbeitsschein 1, Belege prüfen
    Given I open an editor "RUECK_RM1_AS1" from table "(Workorder):(WorkOrders)" with command "RETURN" for record "RFV14_001"
    And I set fields
      | mzeit  | 2  |
      | bzeit  | 2  |
      | sofort | ja |
    And I set field "gutmge" to "-5" in row 1
    And I save the current editor


  # Belege prüfen
 # Rückbau und Rückmeldung Arbeitsschein 1
    Given I switch the current editor to editor "RUECK_RM1_AS1" with command "VIEW"
    Then fields have values
      | typa279 | Rückbau auf Betriebsauftrag |
    Then table has values
      | artikel      | mge | gutmge | bumge | rueckmge | restmge | limgev | limgen |
      | UP_BG-BEDARF | 25  | -5     | -5    | 0        | -5      | 20     | 20     |
      | EK1-BEDARF   | -5  | 0      | -5    | -5       | 0       | 25     | 30     |
    And I close the current editor

    Given I switch the current editor to editor "Rückmeldung1_AS1" with command "VIEW"
    Then fields have values
      | typa279 | Rückmeldung |
    Then table has values
      | artikel      | mge | gutmge | bumge | rueckmge | restmge | limgev | limgen |
      | UP_BG-BEDARF | 50  | 25     | 25    | 0        | 25      | 0      | 0      |
      | EK1-BEDARF   | 25  | 0      | 25    | 5        | 20      | 50     | 25     |
    And I close the current editor
    
 # Rückbau und Rückmeldung Arbeitsschein 2
    Given I switch the current editor to editor "RUECK_RM1_AS2" with command "VIEW"
    Then fields have values
      | typa279 | Rückbau auf Betriebsauftrag |
    Then table has values
      | artikel      | mge | gutmge | bumge | rueckmge | restmge | limgev | limgen |
      | UP_BG-BEDARF | 25  | -5     | -5    | -5       | 0       | 25     | 20     |
      | EK2-BEDARF   | -5  | 0      | -5    | -5       | 0       | 25     | 30     |
    And I close the current editor

    And I switch the current editor to editor "Rückmeldung1_AS2" with command "VIEW"
    Then fields have values
      | typa279 | Rückmeldung |
    Then table has values
      | artikel      | mge | gutmge | bumge | rueckmge | restmge | limgev | limgen |
      | UP_BG-BEDARF | 50  | 25     | 25    | 5        | 20      | 0      | 25     |
      | EK2-BEDARF   | 25  | 0      | 25    | 5        | 20      | 50     | 25     |
    And I close the current editor


  Scenario: 15 Ungebuchter Rückbau mit Materialentnahme auf ersten und zweiten Arbeitsschein, nach Upgrade Rückbau buchen nicht möglich

# Rückbau buchen nicht möglich, da gemischte Vorzeichen
# 11120   |In einer Rückmeldung sind nur positive Mengen zulässig.
    Given I open an editor "Rückgabe1_AS1" from table "(Workorder):(WorkOrders)" with command "TRANSFER" for record "RFV15_001"
    Then saving the current editor throws the exception "11120"
    And I close the current editor

    Given I open an editor "Rückgabe1_AS2" from table "(Workorder):(WorkOrders)" with command "TRANSFER" for record "RFV15_002"
    Then saving the current editor throws the exception "11120"
    And I close the current editor

## es bleiben ungebuchte Belege ##


  Scenario: 16 Rückmeldung auf ersten und zweiten Arbeitsschein buchen, nach Upgrade Rückgabe auf Betriebsauftrag

# Rückbau auf Betriebsauftrag nicht möglich, da Rückmeldungen auf Arbeitsschein
# 1395 de   |Die zurückzubuchende Menge ist größer als die ursprünglich zurückgemeldete Menge.
    Given I open an editor "RUECK_BA" from table "(Workorder):(WorkOrders)" with command "RETURN" for record "RFV16_000"
    And I set fields
      | mzeit  | 2  |
      | bzeit  | 2  |
      | sofort | ja |
    Then setting field "gutmge" to "-5" in row 1 throws the exception "1395"
    And I close the current editor
    
# Rückmeldungen auf ersten und zweiten Arbeitsschein buchen, schließen BA ab
    Given I open an editor "Rückmeldung2_AS1" from table "(Workorder):(WorkOrders)" with command "DONE" for record "RFV16_001"
    And I set fields
      | mzeit  | 3  |
      | bzeit  | 3  |
      | sofort | ja |
      | gut    | ja |
    And I save the current editor


    Given I open an editor "Rückmeldung2_AS2" from table "(Workorder):(WorkOrders)" with command "DONE" for record "RFV16_002"
    And I set fields
      | mzeit  | 6  |
      | bzeit  | 6  |
      | sofort | ja |
      | gut    | ja |
    And I save the current editor


  Scenario: 17 Rückmeldung auf Betriebsauftrag buchen, nach Upgrade Storno Rückmeldung


# Rückmeldung aus 2016 öffnen

    Given I open an editor "Rückmeldung1_BA" from table "(Workorder):(CompletionConfirmations)" with command "VIEW" for search criteria "$,,such=RFV17_000;@richtung=rückwärts;@maxordtreffer=1;@ablageart=abgelegt"
    And I close the current editor
    
# Storno Rückmeldung BA
    Given I open an editor "STORNO_RM1_BA" from table "(Workorder):(CompletionConfirmations)" with command "REVERSAL" for record from editor "Rückmeldung1_BA"
    And I save the current editor



#Scenario: 18 Rückmeldung auf Betriebsauftrag buchen, nach Upgrade Rückbau auf BA
## entfällt, wird von Scenario 20 abgedeckt ##


  Scenario: 19 Rückmeldung und Rückbau auf Betriebsauftrag, nach Upgrade Storno des Rückbaus

# Rückbau aus 2016 öffnen

    Given I open an editor "Rückbau1_BA" from table "(Workorder):(CompletionConfirmations)" with command "VIEW" for search criteria "$,,such=RFV19_000;@richtung=rückwärts;@maxordtreffer=1;@ablageart=abgelegt"
    And I close the current editor
    
# Storno Rückbau BA nicht möglich da Beleg Typ Rückmeldung und negative Mengen
# 2199 Storno dieses Belegs nicht möglich, Material wurde bereits rückgebucht.
    Given opening an editor from table "(Workorder):(CompletionConfirmations)" with command "REVERSAL" for record from editor "Rückbau1_BA" throws the exception "2199"
    And I close the current editor


# Rückmeldungen auf ersten und zweiten Arbeitsschein buchen, schließen BA ab
    Given I open an editor "Rückmeldung2_AS1" from table "(Workorder):(WorkOrders)" with command "DONE" for record "RFV19_001"
    And I set fields
      | mzeit  | 3  |
      | bzeit  | 3  |
      | sofort | ja |
      | gut    | ja |
    And I save the current editor


    Given I open an editor "Rückmeldung2_AS2" from table "(Workorder):(WorkOrders)" with command "DONE" for record "RFV19_002"
    And I set fields
      | mzeit  | 6  |
      | bzeit  | 6  |
      | sofort | ja |
      | gut    | ja |
    And I save the current editor


  Scenario: 20 Rückmeldungen auf Betriebsauftrag, nach Upgrade Rückbau über beide Rückmeldungen

# Rückbau auf BA, Menge höher als einzelne rückgemeldete Menge
    Given I open an editor "RUECK_BA" from table "(Workorder):(WorkOrders)" with command "RETURN" for record "RFV20_000"
    And I set fields
      | sofort | ja  |
      | mgr    | 103 |
    And I set field "gutmge" to "-25" in row 1
    And I save the current editor

# weiterer Rückbau auf BA, Menge wird geprüft, Gesamtmenge wird berücksichtigt, anstatt einzelne rückgemeldete Menge
    Given I open an editor "RUECK_BA" from table "(Workorder):(WorkOrders)" with command "RETURN" for record "RFV20_000"
    And I set fields
      | sofort | ja  |
      | mgr    | 103 |
   # 1395 de   |Die zurückzubuchende Menge ist größer als die ursprünglich zurückgemeldete Menge.
    Then setting field "gutmge" to "-20" in row 1 throws the exception "1395"
    # zulässige Menge rückbauen
    And I set field "gutmge" to "-15" in row 1
    And I save the current editor


  Scenario: 21 Rückmeldungen auf ersten und zweiten Arbeitsschein buchen, schließen BA ab, nach Upgrade Rückbau und Storno auf abgelegt


# Storno Rückmeldung2 AS2 abgelegt
    Given I open an editor "STORNO_RM2_AS2" from table "(Workorder):(CompletionConfirmations)" with command "REVERSAL" for search criteria "$,,such=RFV21_002;bem=RFV21_002_2;@ablageart=abgelegt;@richtung=rückwärts;@maxtreffer=1"
    And I save the current editor
 
 # Rückbau auf abgelegten FV, AS2
    And I wait 1 time units to move the time forward
    Given I open an editor "RückgabeAS2_abgelegt" from table "(Workorder):(CompletionConfirmations)" with command "COPY" for search criteria "$,,such=RFV21_002;bem=RFV21_002_1;@ablageart=abgelegt;@richtung=rückwärts;@maxtreffer=1"
    And I set field "bem" to "RückgabeAS2_abgelegt"
    And I set field "gutmge" to "-10" in row 1
 #And I set field "mge" to "0" in row 2
    And I set field "mge" to "-10" in row 3
    And I save the current editor


  Scenario: 22 Rückmeldungen auf Betriebsauftrag buchen, schließen BA ab, nach Upgrade Rückbau und Storno auf abgelegt

# Storno Rückmeldung2 BA abgelegt
    Given I open an editor "STORNO_RM2_BA" from table "(Workorder):(CompletionConfirmations)" with command "REVERSAL" for search criteria "$,,such=RFV22_000;bem=RFV22_000_2;@ablageart=abgelegt;@richtung=rückwärts;@maxtreffer=1"
    And I save the current editor


# Rückbau auf abgelegten BA
    And I wait 1 time units to move the time forward
    Given I open an editor "RückgabeBA_abgelegt" from table "(Workorder):(CompletionConfirmations)" with command "COPY" for search criteria "$,,such=RFV22_000;bem=RFV22_000_1;@ablageart=abgelegt;@richtung=rückwärts;@maxtreffer=1"
    And I set field "bem" to "RückgabeBA_abgelegt"
    And I set field "gutmge" to "-10" in row 1
    And I set field "mge" to "-10" in row 2
    And I set field "mge" to "-10" in row 3
    And I save the current editor


  Scenario: 23 Gutmenge umlagern, ausliefern, nach Upgrade Rückbau von Ursprungsplatz
 
# Rückbau von Ursprungsplatz, mit Materialfluss, Bewertung vorher aktiv

    Given I open an editor "RUECK_RM1_AS2" from table "(Workorder):(WorkOrders)" with command "RETURN" for record "RFV23_002"
    And I set fields
      | mzeit  | 2  |
      | bzeit  | 2  |
      | sofort | ja |
    And I set field "gutmge" to "-20" in row 1
    And I save the current editor

    

