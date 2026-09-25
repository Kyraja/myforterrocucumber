# *****************************************************************************
#  Name             : amge3_verlust_ba.feature
#  Autor            : drpf
#  Verantwortlich   : drpf
#  Kontrolle        : amk
#  Funktion         : Reduktion der Fertigmenge, Auf BA ist nur Ausschus gebucht.
#  Jira-Issue       : FDA-1978
# *****************************************************************************
@persistent
Feature: amge3_verlust_ba.feature

  Scenario Outline: 3.1 Artikel für Test 1
    Given I open an editor "<such>" from table "(Part):(Product)" with command "STORE" for record "<such>"
    And I set fields
      | such     | <such>          |
      | namebspr | <namebspr>      |
      | dispoa   | auftragsbezogen |
      | bsart    | Eigenfertigung  |
      | gemein   | GK2.14.3        |
      | wgruppe  | 55              |
      | erlgrp   | 66              |
    And I delete all rows
    And I append rows
      | elex    | anzahl    | amge    |
      | <elex1> | <anzahl1> |         |
      | <ag1>   | 1         | <amge1> |
      | <elex2> | <anzahl2> |         |
      | <ag2>   | 1         | <amge2> |
    And I save the current editor

    Examples:
      | such    | namebspr                    | elex1      | anzahl1 | ag1        | amge1 | elex2      | anzahl2 | ag2        | amge2 |
      | MISC3.1 | Bruttobedarf manbu=n, BA=AS | EK1-BEDARF | 1       | A AG-LOHN1 | 5     | EK2-BEDARF | 2       | A AG-LOHN1 | 3     |

  Scenario: 3.1 Fertigungsvorschlag erstellen und freigeben
    Given I open an editor "fvor_MISC3.1" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
    And I append rows
      | artikel | netmge | bisuch   | mfreig |
      | MISC3.1 | 50     | amge3.1_ | ja     |
    And I press button "freig" to open a subeditor for "BA_freigeben"
    And I close the current editor
    And I switch the current editor to editor "fvor_MISC3.1"
    And I save the current editor
    And I close the current editor

  Scenario: 3.1 Fertigunsvorschlag prüfen, noch nicht bebucht
    # Mengen in Fertigungsvorschlag pruefen
    Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "VIEW" for record ""
    And I set field "artikel" to "MISC3.1"
    And I press button "ladetab"
    Then table has values
      | mge | netmge | limge | netlimge | frgmge | netfrgmge | !row |
      | 58  | 50     | 58    | 50       | 58     | 50        | 1    |
    And I close the current editor

  Scenario Outline: 3.1 Werte in BA und AS prüfen
    Given I open an editor "BAAS" from table "(Workorder):(WorkOrders)" with command "VIEW" for record "<such>"
    Then fields have values
      | mge               | <mge>               |
      | egutmge           | <egutmge>           |
      | everlustmge       | <everlustmge>       |
      | rgutmge           | <rgutmge>           |
      | rverlust          | <rverlust>          |
      | amge              | <amge>              |
      | gutmgeauto        | <gutmgeauto>        |
      | gutmgeautoverlust | <gutmgeautoverlust> |
    And I save the current editor

    Examples:
      | such        | mge | egutmge | everlustmge | rgutmge | rverlust | amge | gutmgeauto | gutmgeautoverlust |
      | amge3.1_001 | 58  | 53      | 5           | 0       | 0        | 5    | 0          | 0                 |
      | amge3.1_002 | 53  | 50      | 3           | 0       | 0        | 3    | 0          | 0                 |
      | amge3.1_000 | 58  | 50      | 8           | 0       | 0        | 8    | 0          | 0                 |

  Scenario: 3.1 Rückmeldung 1 auf AS1
    Given I open an editor "Rückmeldung1" from table "(Workorder):(WorkOrders)" with command "DONE" for record "amge3.1_001"
    And I set field "sofort" to "1"
    And I set field "mgr" to "101"
    And I set field "gutmge" to "20" in row 1
    And I set field "verlustmge" to "4" in row 1
    And I save the current editor
    And I close the current editor

  Scenario: 3.1 Fertigunsvorschlag prüfen, nach Rückmeldung 1
    # Mengen in Fertigungsvorschlag pruefen
    Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "VIEW" for record ""
    And I set field "artikel" to "MISC3.1"
    And I press button "ladetab"
    Then table has values
      | mge | netmge | limge | netlimge | frgmge | netfrgmge | !row |
      | 58  | 50     | 58    | 50       | 58     | 50        | 1    |
    And I close the current editor

  Scenario Outline: 3.1 Werte in BA und AS prüfen, nach Rückmeldung 1
    Given I open an editor "BAAS" from table "(Workorder):(WorkOrders)" with command "VIEW" for record "<such>"
    Then fields have values
      | mge               | <mge>               |
      | egutmge           | <egutmge>           |
      | everlustmge       | <everlustmge>       |
      | rgutmge           | <rgutmge>           |
      | rverlust          | <rverlust>          |
      | amge              | <amge>              |
      | gutmgeauto        | <gutmgeauto>        |
      | gutmgeautoverlust | <gutmgeautoverlust> |
    And I save the current editor

    Examples:
      | such        | mge | egutmge | everlustmge | rgutmge | rverlust | amge | gutmgeauto | gutmgeautoverlust |
      | amge3.1_001 | 34  | 53      | 5           | 20      | 4        | 5    | 0          | 0                 |
      | amge3.1_002 | 53  | 50      | 3           | 0       | 0        | 3    | 0          | 0                 |
      | amge3.1_000 | 58  | 50      | 8           | 0       | 0        | 8    | 0          | 0                 |

  Scenario: 3.1 Rückmeldung 2 auf AS2
    Given I open an editor "Rückmeldung2" from table "(Workorder):(WorkOrders)" with command "DONE" for record "amge3.1_002"
    And I set field "sofort" to "1"
    And I set field "mgr" to "101"
    And I set field "gutmge" to "15" in row 1
    And I set field "verlustmge" to "1" in row 1
    And I save the current editor
    And I close the current editor

  Scenario: 3.1 Fertigunsvorschlag prüfen, nach Rückmeldung 2
    # Mengen in Fertigungsvorschlag pruefen
    Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "VIEW" for record ""
    And I set field "artikel" to "MISC3.1"
    And I press button "ladetab"
    Then table has values
      | mge | netmge | limge | netlimge | frgmge | netfrgmge | !row |
      | 58  | 50     | 42    | 35       | 42     | 35        | 1    |
    And I close the current editor

  Scenario Outline: 3.1 Werte in BA und AS prüfen, nach Rückmeldung 2
    Given I open an editor "BAAS" from table "(Workorder):(WorkOrders)" with command "VIEW" for record "<such>"
    Then fields have values
      | mge               | <mge>               |
      | egutmge           | <egutmge>           |
      | everlustmge       | <everlustmge>       |
      | rgutmge           | <rgutmge>           |
      | rverlust          | <rverlust>          |
      | amge              | <amge>              |
      | gutmgeauto        | <gutmgeauto>        |
      | gutmgeautoverlust | <gutmgeautoverlust> |
    And I save the current editor

    Examples:
      | such        | mge | egutmge | everlustmge | rgutmge | rverlust | amge | gutmgeauto | gutmgeautoverlust |
      | amge3.1_001 | 34  | 53      | 5           | 20      | 4        | 5    | 16         | 0                 |
      | amge3.1_002 | 37  | 50      | 3           | 15      | 1        | 3    | 0          | 0                 |
      | amge3.1_000 | 42  | 50      | 8           | 0       | 0        | 8    | 15         | 1                 |

  Scenario: 3.1 AFL Kopf prüfen (Skipfelder)
    Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "VIEW" for record ""
    And I set field "artikel" to "MISC3.1"
    And I press button "ladetab"
    # Werte mge und geamge werden im FV nicht angepasst.
    Then field "geamge" has value "8" in row 1
    Then field "pverlust" has value "0" in row 1
    Then field "mge" has value "58" in row 1
    Then field "netmge" has value "50" in row 1
    Then field "limge" has value "42" in row 1
    Then field "netlimge" has value "35" in row 1
    And I close the current editor
    And I switch the current editor to editor "fvor"
    And I close the current editor

  Scenario: 3.1 Rückmeldung 3 auf BA
    Given I open an editor "Rückmeldung3" from table "(Workorder):(WorkOrders)" with command "DONE" for record "amge3.1_000"
    And I set field "sofort" to "1"
    And I set field "mgr" to "101"
    And I set field "gutmge" to "0" in row 1
    And I set field "verlustmge" to "5" in row 1
    And I save the current editor
    And I close the current editor

  Scenario: 3.1 Fertigunsvorschlag prüfen, nach Rückmeldung 3
    # Mengen in Fertigungsvorschlag pruefen
    Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "VIEW" for record ""
    And I set field "artikel" to "MISC3.1"
    And I press button "ladetab"
    Then table has values
      | mge | netmge | limge | netlimge | frgmge | netfrgmge | !row |
      | 58  | 50     | 38    | 35       | 38     | 35        | 1    |
    And I close the current editor

  Scenario Outline: 3.1 Werte in BA und AS prüfen, nach Rückmeldung 3
    Given I open an editor "BAAS" from table "(Workorder):(WorkOrders)" with command "VIEW" for record "<such>"
    Then fields have values
      | mge               | <mge>               |
      | egutmge           | <egutmge>           |
      | everlustmge       | <everlustmge>       |
      | rgutmge           | <rgutmge>           |
      | rverlust          | <rverlust>          |
      | amge              | <amge>              |
      | gutmgeauto        | <gutmgeauto>        |
      | gutmgeautoverlust | <gutmgeautoverlust> |
    And I save the current editor

    Examples:
      | such        | mge | egutmge | everlustmge | rgutmge | rverlust | amge | gutmgeauto | gutmgeautoverlust |
      | amge3.1_001 | 36  | 53      | 5           | 20      | 4        | 5    | 20         | 2                 |
      | amge3.1_002 | 35  | 50      | 3           | 15      | 1        | 3    | 0          | 5                 |
      | amge3.1_000 | 38  | 50      | 8           | 0       | 5        | 8    | 15         | 1                 |

  Scenario: 3.1 AFL Kopf prüfen (Skipfelder)
    Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "VIEW" for record ""
    And I set field "artikel" to "MISC3.1"
    And I press button "ladetab"
    # Werte mge und geamge werden im FV nicht angepasst.
    Then field "geamge" has value "8" in row 1
    Then field "pverlust" has value "0" in row 1
    Then field "mge" has value "58" in row 1
    Then field "netmge" has value "50" in row 1
    Then field "limge" has value "38" in row 1
    Then field "netlimge" has value "35" in row 1
    # AFL anzeigen und pruefen
    And I press button "absteig" to open a subeditor for "AFL" in row 1
    Then field "blimge" has value "38"
    Then field "bfrgmge" has value "38"
    Then field "netblimge" has value "35"
    Then field "netbfrgmge" has value "35"
    Then field "netbgmge" has value "50"
    Then table has values
      | elex       | mge | limge | frgmge | amge |
      | EK1-BEDARF | 58  | 36    | 36     | 0    |
      | A AG-LOHN1 | 58  | 36    | 36     | 5    |
      | EK2-BEDARF | 106 | 70    | 70     | 0    |
      | A AG-LOHN1 | 53  | 35    | 35     | 3    |
    And I close the current editor
    And I switch the current editor to editor "fvor"
    And I close the current editor

  # Reduzieren AS1
  Scenario: 3.1 Rückmeldung reduz auf AS1
    Given I open an editor "Rückmeldung_reduz" from table "(Workorder):(WorkOrders)" with command "DONE" for record "amge3.1_001"
    And I set field "sofort" to "1"
    And I set field "mgr" to "101"
    And I set field "mgereduzieren" to "1"
    And I set field "gutmge" to "25" in row 1
    And I save the current editor
    And I close the current editor

  Scenario: 3.1 Fertigunsvorschlag prüfen, nach Rückmeldung reduz
    # Mengen in Fertigungsvorschlag pruefen
    Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "VIEW" for record ""
    And I set field "artikel" to "MISC3.1"
    And I press button "ladetab"
    Then table has values
      | mge | netmge | limge | netlimge | frgmge | netfrgmge | !row |
      | 50  | 42     | 35    | 27       | 35     | 27        | 1    |
    And I close the current editor

  Scenario Outline: 3.1 Werte in BA und AS prüfen, nach Rückmeldung reduz
    Given I open an editor "BAAS" from table "(Workorder):(WorkOrders)" with command "VIEW" for record "<such>"
    Then fields have values
      | mge               | <mge>               |
      | egutmge           | <egutmge>           |
      | everlustmge       | <everlustmge>       |
      | rgutmge           | <rgutmge>           |
      | rverlust          | <rverlust>          |
      | amge              | <amge>              |
      | gutmgeauto        | <gutmgeauto>        |
      | gutmgeautoverlust | <gutmgeautoverlust> |
    And I save the current editor

    Examples:
      | such        | mge | egutmge | everlustmge | rgutmge | rverlust | amge | gutmgeauto | gutmgeautoverlust |
      | amge3.1_000 | 30  | 42      | 8           | 0       | 5        | 8    | 15         | 1                 |
      | amge3.1_002 | 27  | 42      | 3           | 15      | 1        | 3    | 0          | 5                 |
      | amge3.1_001 | 0   | 45      | 5           | 45      | 4        | 5    | 20         | 2                 |

  Scenario: 3.1 FV Kopf prüfen
    Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "VIEW" for record ""
    And I set field "artikel" to "MISC3.1"
    And I press button "ladetab"
    # Werte mge und geamge werden im FV nicht angepasst.
    Then field "geamge" has value "8" in row 1
    Then field "pverlust" has value "0" in row 1
    Then field "mge" has value "50" in row 1
    Then field "netmge" has value "42" in row 1
    Then field "limge" has value "35" in row 1
    Then field "netlimge" has value "27" in row 1
    # AFL anzeigen und pruefen
    And I press button "absteig" to open a subeditor for "AFL" in row 1
    Then field "blimge" has value "35"
    Then field "bfrgmge" has value "35"
    Then field "netblimge" has value "27"
    Then field "netbfrgmge" has value "27"
    Then field "netbgmge" has value "42"
    Then table has values
      | elex       | mge | limge | frgmge | amge |
      | EK1-BEDARF | 50  | 0     | 0      | 0    |
      | A AG-LOHN1 | 50  | 0     | 0      | 5    |
      | EK2-BEDARF | 90  | 54    | 54     | 0    |
      | A AG-LOHN1 | 45  | 27    | 27     | 3    |
    And I close the current editor
    And I switch the current editor to editor "fvor"
    And I close the current editor

  # +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
  # Nächstes Szenario
  # Selbes Szenario wie 3.1 nur mit pverlust, da dieser Auswirkungen auf die Gesamtanfahrmenge hat.
  # +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
  Scenario Outline: 3.2 Artikel für Test 2
    Given I open an editor "<such>" from table "(Part):(Product)" with command "STORE" for record "<such>"
    And I set fields
      | such     | <such>          |
      | namebspr | <namebspr>      |
      | dispoa   | auftragsbezogen |
      | bsart    | Eigenfertigung  |
      | gemein   | GK2.14.3        |
      | wgruppe  | 55              |
      | erlgrp   | 66              |
    And I delete all rows
    And I append rows
      | elex    | anzahl    | amge    | pverlust    |
      | <elex1> | <anzahl1> |         |             |
      | <ag1>   | 1         | <amge1> | <pverlust1> |
      | <elex2> | <anzahl2> |         |             |
      | <ag2>   | 1         | <amge2> | <pverlust2> |
    And I save the current editor

    Examples:
      | such     | namebspr                    | elex1      | anzahl1 | ag1        | amge1 | pverlust1 | elex2      | anzahl2 | ag2        | amge2 | pverlust2 |
      | MISC3.2  | Bruttobedarf manbu=n, BA=AS | EK1-BEDARF | 1       | A AG-LOHN1 | 5     | 1         | EK2-BEDARF | 2       | A AG-LOHN1 | 3     | 1         |
      | MISC3.2C | Bruttobedarf manbu=n, BA=AS | EK1-BEDARF | 1       | A AG-LOHN1 | 5     | 1         | EK2-BEDARF | 2       | A AG-LOHN1 | 3     | 1         |

  Scenario: 3.2 Fertigungsvorschlag erstellen und freigeben
    Given I open an editor "fvor_MISC3.2" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
    And I append rows
      | artikel  | netmge | bisuch    | mfreig |
      | MISC3.2  | 50     | amge3.2_  | ja     |
      | MISC3.2C | 46.58  | amge3.2C_ | ja     |
    And I press button "freig" to open a subeditor for "BA_freigeben"
    And I close the current editor
    And I switch the current editor to editor "fvor_MISC3.2"
    And I save the current editor
    And I close the current editor

  Scenario: 3.2 Fertigunsvorschlag prüfen, noch nicht bebucht
    # Mengen in Fertigungsvorschlag pruefen
    Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "VIEW" for record ""
    And I set field "artikel" to "MISC3.2"
    And I press button "ladetab"
    Then table has values
      | mge    | netmge | limge  | netlimge | frgmge | netfrgmge | !row |
      | 59.046 | 50     | 59.046 | 50       | 59.046 | 50        | 1    |
    And I close the current editor

  Scenario Outline: 3.2 Werte in BA und AS prüfen
    Given I open an editor "BAAS" from table "(Workorder):(WorkOrders)" with command "VIEW" for record "<such>"
    Then fields have values
      | mge               | <mge>               |
      | egutmge           | <egutmge>           |
      | everlustmge       | <everlustmge>       |
      | rgutmge           | <rgutmge>           |
      | rverlust          | <rverlust>          |
      | amge              | <amge>              |
      | gutmgeauto        | <gutmgeauto>        |
      | gutmgeautoverlust | <gutmgeautoverlust> |
    And I save the current editor

    Examples:
      | such        | mge    | egutmge | everlustmge | rgutmge | rverlust | amge | gutmgeauto | gutmgeautoverlust |
      | amge3.2_001 | 59.046 | 53.506  | 5.54        | 0       | 0        | 5    | 0          | 0                 |
      | amge3.2_002 | 53.506 | 50.001  | 3.505       | 0       | 0        | 3    | 0          | 0                 |
      | amge3.2_000 | 59.046 | 50      | 9.046       | 0       | 0        | 8.03 | 0          | 0                 |

  Scenario: 3.2 Rückmeldung 1 auf AS1
    Given I open an editor "Rückmeldung1" from table "(Workorder):(WorkOrders)" with command "DONE" for record "amge3.2_001"
    And I set field "sofort" to "1"
    And I set field "mgr" to "101"
    And I set field "gutmge" to "20" in row 1
    And I set field "verlustmge" to "4" in row 1
    And I save the current editor
    And I close the current editor

  Scenario: 3.2 Fertigunsvorschlag prüfen, nach Rückmeldung 1
    # Mengen in Fertigungsvorschlag pruefen
    Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "VIEW" for record ""
    And I set field "artikel" to "MISC3.2"
    And I press button "ladetab"
    Then table has values
      | mge    | netmge | limge  | netlimge | frgmge | netfrgmge | !row |
      | 59.046 | 50     | 59.046 | 50       | 59.046 | 50        | 1    |
    And I close the current editor

  Scenario Outline: 3.2 Werte in BA und AS prüfen, nach Rückmeldung 1
    Given I open an editor "BAAS" from table "(Workorder):(WorkOrders)" with command "VIEW" for record "<such>"
    Then fields have values
      | mge               | <mge>               |
      | egutmge           | <egutmge>           |
      | everlustmge       | <everlustmge>       |
      | rgutmge           | <rgutmge>           |
      | rverlust          | <rverlust>          |
      | amge              | <amge>              |
      | gutmgeauto        | <gutmgeauto>        |
      | gutmgeautoverlust | <gutmgeautoverlust> |
    And I save the current editor

    Examples:
      | such        | mge    | egutmge | everlustmge | rgutmge | rverlust | amge | gutmgeauto | gutmgeautoverlust |
      | amge3.2_000 | 59.046 | 50      | 9.046       | 0       | 0        | 8.03 | 0          | 0                 |
      | amge3.2_002 | 53.506 | 50.001  | 3.505       | 0       | 0        | 3    | 0          | 0                 |
      | amge3.2_001 | 35.046 | 53.506  | 5.54        | 20      | 4        | 5    | 0          | 0                 |

  Scenario: 3.2 Rückmeldung 2 auf AS2
    Given I open an editor "Rückmeldung2" from table "(Workorder):(WorkOrders)" with command "DONE" for record "amge3.2_002"
    And I set field "sofort" to "1"
    And I set field "mgr" to "101"
    And I set field "gutmge" to "15" in row 1
    And I set field "verlustmge" to "1" in row 1
    And I save the current editor
    And I close the current editor

  Scenario: 3.2 Fertigunsvorschlag prüfen, nach Rückmeldung 2
    # Mengen in Fertigungsvorschlag pruefen
    Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "VIEW" for record ""
    And I set field "artikel" to "MISC3.2"
    And I press button "ladetab"
    Then table has values
      | mge    | netmge | limge  | netlimge | frgmge | netfrgmge | !row |
      | 59.046 | 50     | 43.046 | 35       | 43.046 | 35        | 1    |
    And I close the current editor

  Scenario: 3.2 Werte in AS1 prüfen, nach Rückmeldung 2
    Given I open an editor "BAAS" from table "(Workorder):(WorkOrders)" with command "VIEW" for record " amge3.2_001"
    Then fields have values
      | mge               | 35.046 |
      | egutmge           | 53.506 |
      | everlustmge       | 5.54   |
      | rgutmge           | 20     |
      | rverlust          | 4      |
      | amge              | 5      |
      | gutmgeauto        | 16     |
      | gutmgeautoverlust | 0      |
    And I close the current editor

  Scenario: 3.2 Werte in AS2 prüfen, nach Rückmeldung 2
    Given I open an editor "BAAS" from table "(Workorder):(WorkOrders)" with command "VIEW" for record " amge3.2_002"
    Then fields have values
      | mge               | 37.506 |
      | egutmge           | 50.001 |
      | everlustmge       | 3.505  |
      | rgutmge           | 15     |
      | rverlust          | 1      |
      | amge              | 3      |
      | gutmgeauto        | 0      |
      | gutmgeautoverlust | 0      |
    And I close the current editor

  Scenario: 3.2 Werte in BA prüfen, nach Rückmeldung 2
    Given I open an editor "BAAS" from table "(Workorder):(WorkOrders)" with command "VIEW" for record " amge3.2_000"
    Then fields have values
      | mge               | 43.046 |
      | egutmge           | 50     |
      | everlustmge       | 9.046  |
      | rgutmge           | 0      |
      | rverlust          | 0      |
      | amge              | 8.03   |
      | gutmgeauto        | 15     |
      | gutmgeautoverlust | 1      |
    And I close the current editor

  Scenario: 3.2 Rückmeldung 3 auf BA
    Given I open an editor "Rückmeldung3" from table "(Workorder):(WorkOrders)" with command "DONE" for record "amge3.2_000"
    And I set field "sofort" to "1"
    And I set field "mgr" to "101"
    And I set field "gutmge" to "0" in row 1
    And I set field "verlustmge" to "5" in row 1
    And I save the current editor
    And I close the current editor

  Scenario: 3.2 Fertigunsvorschlag prüfen, nach Rückmeldung 3
    # Mengen in Fertigungsvorschlag pruefen
    Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "VIEW" for record ""
    And I set field "artikel" to "MISC3.2"
    And I press button "ladetab"
    Then table has values
      | mge    | netmge | limge  | netlimge | frgmge | netfrgmge | !row |
      | 59.046 | 50     | 39.046 | 35       | 39.046 | 35        | 1    |
    And I close the current editor

  Scenario: 3.2 Werte in AS1 prüfen, nach Rückmeldung 3
    Given I open an editor "BAAS" from table "(Workorder):(WorkOrders)" with command "VIEW" for record " amge3.2_001"
    Then fields have values
      | mge               | 36.541 |
      | egutmge           | 53.506 |
      | everlustmge       | 5.54   |
      | rgutmge           | 20     |
      | rverlust          | 4      |
      | amge              | 5      |
      | gutmgeauto        | 20     |
      | gutmgeautoverlust | 1.495  |
    And I close the current editor

  Scenario: 3.2 Werte in AS2 prüfen, nach Rückmeldung 3
    Given I open an editor "BAAS" from table "(Workorder):(WorkOrders)" with command "VIEW" for record " amge3.2_002"
    Then fields have values
      | mge               | 35.001 |
      | egutmge           | 50.001 |
      | everlustmge       | 3.505  |
      | rgutmge           | 15     |
      | rverlust          | 1      |
      | amge              | 3      |
      | gutmgeauto        | 0      |
      | gutmgeautoverlust | 5      |
    And I close the current editor

  Scenario: 3.2 Werte in BA prüfen, nach Rückmeldung 3
    Given I open an editor "BAAS" from table "(Workorder):(WorkOrders)" with command "VIEW" for record " amge3.2_000"
    Then fields have values
      | mge               | 39.046 |
      | egutmge           | 50     |
      | everlustmge       | 9.046  |
      | rgutmge           | 0      |
      | rverlust          | 5      |
      | amge              | 8.03   |
      | gutmgeauto        | 15     |
      | gutmgeautoverlust | 1      |
    And I close the current editor

  Scenario: 3.2 Rückmeldung 4 auf AS1
    Given I open an editor "Rückmeldung4" from table "(Workorder):(WorkOrders)" with command "DONE" for record "amge3.2_001"
    And I set field "sofort" to "1"
    And I set field "mgr" to "101"
    And I set field "gutmge" to "25" in row 1
    And I save the current editor
    And I close the current editor

  Scenario: 3.2 Fertigunsvorschlag prüfen, nach Rückmeldung 4
    # Mengen in Fertigungsvorschlag pruefen
    Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "VIEW" for record ""
    And I set field "artikel" to "MISC3.2"
    And I press button "ladetab"
    Then table has values
      | mge    | netmge | limge  | netlimge | frgmge | netfrgmge | !row |
      | 59.046 | 50     | 39.046 | 35       | 39.046 | 35        | 1    |
    And I close the current editor

  Scenario Outline: 3.2 Werte in BA und AS prüfen, nach Rückmeldung 4
    Given I open an editor "BAAS" from table "(Workorder):(WorkOrders)" with command "VIEW" for record "<such>"
    Then fields have values
      | mge               | <mge>               |
      | egutmge           | <egutmge>           |
      | everlustmge       | <everlustmge>       |
      | rgutmge           | <rgutmge>           |
      | rverlust          | <rverlust>          |
      | amge              | <amge>              |
      | gutmgeauto        | <gutmgeauto>        |
      | gutmgeautoverlust | <gutmgeautoverlust> |
    And I save the current editor

    Examples:
      | such        | mge    | egutmge | everlustmge | rgutmge | rverlust | amge | gutmgeauto | gutmgeautoverlust |
      | amge3.2_000 | 39.046 | 50      | 9.046       | 0       | 5        | 8.03 | 15         | 1                 |
      | amge3.2_002 | 35.001 | 50.001  | 3.505       | 15      | 1        | 3    | 0          | 5                 |
      | amge3.2_001 | 11.541 | 53.506  | 5.54        | 45      | 4        | 5    | 20         | 1.495             |

  # Bebuchen des Vergleichs-FV
  Scenario: 3.2 Rückmeldung reduz auf AS1
    Given I open an editor "Rückmeldung_C" from table "(Workorder):(WorkOrders)" with command "DONE" for record "amge3.2C_001"
    And I set field "sofort" to "1"
    And I set field "mgr" to "101"
    And I set field "gutmge" to "45" in row 1
    And I set field "verlustmge" to "4" in row 1
    And I save the current editor
    And I close the current editor
    Given I open an editor "Rückmeldung_C" from table "(Workorder):(WorkOrders)" with command "DONE" for record "amge3.2C_002"
    And I set field "sofort" to "1"
    And I set field "mgr" to "101"
    And I set field "gutmge" to "15" in row 1
    And I set field "verlustmge" to "1" in row 1
    And I save the current editor
    And I close the current editor
    Given I open an editor "Rückmeldung_C" from table "(Workorder):(WorkOrders)" with command "DONE" for record "amge3.2C_000"
    And I set field "sofort" to "1"
    And I set field "mgr" to "101"
    And I set field "gutmge" to "0" in row 1
    And I set field "verlustmge" to "5" in row 1
    And I save the current editor
    And I close the current editor

  # Reduzieren AS1
  Scenario: 3.2 Rückmeldung reduz auf AS1
    Given I open an editor "Rückmeldung_reduz" from table "(Workorder):(WorkOrders)" with command "DONE" for record "amge3.2_001"
    And I set field "sofort" to "1"
    And I set field "mgr" to "101"
    And I set field "mgereduzieren" to "1"
    And I set field "gutmge" to "0" in row 1
    And I save the current editor
    And I close the current editor

  Scenario: 3.2 Fertigunsvorschlag prüfen, nach Rückmeldung reduz
    # Mengen in Fertigungsvorschlag pruefen
    Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "VIEW" for record ""
    And I set field "artikel" to "MISC3.2"
    And I press button "ladetab"
    Then table has values
      | mge    | netmge | limge  | netlimge | frgmge | netfrgmge | !row |
      | 55.555 | 46.579 | 35.454 | 31.579   | 35.454 | 31.579    | 1    |
    And I close the current editor
    # Zum Vergleich der nicht reduzierte, der beim Anlegen bereits die niedrieger Menge hatte
    Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "VIEW" for record ""
    And I set field "artikel" to "MISC3.2C"
    And I press button "ladetab"
    Then table has values
      | mge    | netmge | limge  | netlimge | frgmge | netfrgmge | !row |
      | 55.556 | 46.58  | 35.556 | 31.58    | 35.556 | 31.58     | 1    |
    And I close the current editor

  # Hier werden die Werte der Arbeitscheine ausgegeben. amge3.2_ ist der reduzierte FV, amge3.2C ist der Vergleichs-FV
  # Die Werte der Zeilen mit gleicher Nummer am Ende (_000, usw.) sollten, bis auf Rundungsdifferenzen, identisch sein.
  # mge von AS amge3.2_001 ist 0 aufgrund des gesetzten Statusflags.
  Scenario Outline: 3.2 Werte in BA und AS prüfen, nach Rückmeldung reduz
    Given I open an editor "BAAS" from table "(Workorder):(WorkOrders)" with command "VIEW" for record "<such>"
    Then fields have values
      | mge               | <mge>               |
      | egutmge           | <egutmge>           |
      | everlustmge       | <everlustmge>       |
      | rgutmge           | <rgutmge>           |
      | rverlust          | <rverlust>          |
      | amge              | <amge>              |
      | gutmgeauto        | <gutmgeauto>        |
      | gutmgeautoverlust | <gutmgeautoverlust> |
      | status            | <status>            |
    And I save the current editor

    Examples:
      | such         | mge    | egutmge | everlustmge | rgutmge | rverlust | amge | gutmgeauto | gutmgeautoverlust | status |
      | AMGE3.2_000  | 35.555 | 46.579  | 8.976       | 0       | 5        | 8.03 | 15         | 1                 |        |
      | AMGE3.2_002  | 31.579 | 46.579  | 3.47        | 15      | 1        | 3    | 0          | 5                 |        |
      | AMGE3.2_001  | 0      | 50.049  | 5.506       | 45      | 4        | 5    | 20         | 1.53              | -      |
      | AMGE3.2C_000 | 35.556 | 46.58   | 8.976       | 0       | 5        | 8.03 | 15         | 1                 |        |
      | AMGE3.2C_002 | 31.58  | 46.58   | 3.47        | 15      | 1        | 3    | 0          | 5                 |        |
      | AMGE3.2C_001 | 8.086  | 50.05   | 5.506       | 45      | 4        | 5    | 20         | 1.53              |        |

  Scenario: 3.1 FV Kopf prüfen
    Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "VIEW" for record ""
    And I set field "artikel" to "MISC3.2"
    And I press button "ladetab"
    # Werte mge und geamge werden im FV nicht angepasst.
    Then field "geamge" has value "8.03" in row 1
    Then field "pverlust" has value "1.99" in row 1
    Then field "mge" has value "55.555" in row 1
    Then field "netmge" has value "46.579" in row 1
    Then field "limge" has value "35.454" in row 1
    Then field "netlimge" has value "31.579" in row 1
    # AFL anzeigen und pruefen
    And I press button "absteig" to open a subeditor for "AFL" in row 1
    Then field "blimge" has value "35.454"
    Then field "bfrgmge" has value "35.454"
    Then field "netblimge" has value "31.579"
    Then field "netbfrgmge" has value "31.579"
    Then field "netbgmge" has value "46.579"
    Then table has values
      | elex       | mge     | limge  | frgmge | amge |
      | EK1-BEDARF | 55.555  | 0      | 0      | 0    |
      | A AG-LOHN1 | 55.555  | 0      | 0      | 5    |
      | EK2-BEDARF | 100.098 | 63.158 | 63.158 | 0    |
      | A AG-LOHN1 | 50.049  | 31.579 | 31.579 | 3    |
    And I close the current editor
    And I switch the current editor to editor "fvor"
    And I close the current editor

  Scenario: 3.1 FV Kopf prüfen im Vergleich
    Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "VIEW" for record ""
    And I set field "artikel" to "MISC3.2C"
    And I press button "ladetab"
    # Werte mge und geamge werden im FV nicht angepasst.
    Then field "geamge" has value "8.03" in row 1
    Then field "pverlust" has value "1.99" in row 1
    Then field "mge" has value "55.556" in row 1
    Then field "netmge" has value "46.58" in row 1
    Then field "limge" has value "35.556" in row 1
    Then field "netlimge" has value "31.58" in row 1
    # AFL anzeigen und pruefen
    And I press button "absteig" to open a subeditor for "AFL" in row 1
    Then field "blimge" has value "35.556"
    Then field "bfrgmge" has value "35.556"
    Then field "netblimge" has value "31.58"
    Then field "netbfrgmge" has value "31.58"
    Then field "netbgmge" has value "46.58"
    Then table has values
      | elex       | mge    | limge | frgmge | amge |
      | EK1-BEDARF | 55.556 | 8.086 | 8.086  | 0    |
      | A AG-LOHN1 | 55.556 | 8.086 | 8.086  | 5    |
      | EK2-BEDARF | 100.1  | 63.16 | 63.16  | 0    |
      | A AG-LOHN1 | 50.05  | 31.58 | 31.58  | 3    |
    And I close the current editor
    And I switch the current editor to editor "fvor"
    And I close the current editor
