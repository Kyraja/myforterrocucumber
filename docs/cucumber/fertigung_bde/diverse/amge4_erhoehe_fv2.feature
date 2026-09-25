# *****************************************************************************
#  Name             : amge4_erhoehe_fv2.feature
#  Autor            : drpf
#  Verantwortlich   : drpf
#  Kontrolle        : amk
#  Funktion         : Testet Erhöhen der Fertigmenge eines bebuchten Fertigunsvorschlages
#                     über die Funktion Menge reduzieren in der Rückmeldung.
#                     Einmal FV mit 2 Arbeitsgängen mit Anfahrmenge.
#                     Einmal FV mit 2 Arbeitsgängen mit Anfahrmenge und pverlust.
#                     Dazu ein Vergleichs-FV mit der "reduzierten" Nettomenge als Freigabemenge,
#                     der dann genauso bebucht wird. Weerte sollten am Ende gleich sein.
#  Jira-Issue       : FDA-1978
# *****************************************************************************
@persistent
Feature: amge4_erhoehe_fv2.feature

  Scenario Outline: 4.1 Artikel für Test 1
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
      | MISC4.1 | Bruttobedarf manbu=n, BA=AS | EK1-BEDARF | 1       | A AG-LOHN1 | 5     | EK2-BEDARF | 2       | A AG-LOHN1 | 3     |

  Scenario: 4.1 Fertigungsvorschlag erstellen und freigeben
    Given I open an editor "fvor_MISC4.1" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
    And I append rows
      | artikel | netmge | bisuch   | mfreig |
      | MISC4.1 | 50     | amge4.1_ | ja     |
    And I press button "freig" to open a subeditor for "BA_freigeben"
    And I close the current editor
    And I switch the current editor to editor "fvor_MISC4.1"
    And I save the current editor
    And I close the current editor

  Scenario: 4.1 Fertigunsvorschlag prüfen, noch nicht bebucht
    # Mengen in Fertigungsvorschlag pruefen
    Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "VIEW" for record ""
    And I set field "artikel" to "MISC4.1"
    And I press button "ladetab"
    Then table has values
      | mge | netmge | limge | netlimge | frgmge | netfrgmge | !row |
      | 58  | 50     | 58    | 50       | 58     | 50        | 1    |
    And I close the current editor

  Scenario Outline: 4.1 Werte in BA und AS prüfen
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
      | amge4.1_000 | 58  | 50      | 8           | 0       | 0        | 8    | 0          | 0                 |
      | amge4.1_002 | 53  | 50      | 3           | 0       | 0        | 3    | 0          | 0                 |
      | amge4.1_001 | 58  | 53      | 5           | 0       | 0        | 5    | 0          | 0                 |

  Scenario: 4.1 Rückmeldung 1 auf AS1
    Given I open an editor "Rückmeldung1" from table "(Workorder):(WorkOrders)" with command "DONE" for record "amge4.1_001"
    And I set field "sofort" to "1"
    And I set field "mgr" to "101"
    And I set field "gutmge" to "20" in row 1
    And I set field "verlustmge" to "4" in row 1
    And I save the current editor
    And I close the current editor

  Scenario: 4.1 Fertigunsvorschlag prüfen, nach Rückmeldung 1
    # Mengen in Fertigungsvorschlag pruefen
    Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "VIEW" for record ""
    And I set field "artikel" to "MISC4.1"
    And I press button "ladetab"
    Then table has values
      | mge | netmge | limge | netlimge | frgmge | netfrgmge | !row |
      | 58  | 50     | 58    | 50       | 58     | 50        | 1    |
    And I close the current editor

  Scenario Outline: 4.1 Werte in BA und AS prüfen, nach Rückmeldung 1
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
      | amge4.1_000 | 58  | 50      | 8           | 0       | 0        | 8    | 0          | 0                 |
      | amge4.1_002 | 53  | 50      | 3           | 0       | 0        | 3    | 0          | 0                 |
      | amge4.1_001 | 34  | 53      | 5           | 20      | 4        | 5    | 0          | 0                 |

  Scenario: 4.1 Rückmeldung 2 auf AS2
    Given I open an editor "Rückmeldung2" from table "(Workorder):(WorkOrders)" with command "DONE" for record "amge4.1_002"
    And I set field "sofort" to "1"
    And I set field "mgr" to "101"
    And I set field "gutmge" to "15" in row 1
    And I set field "verlustmge" to "1" in row 1
    And I save the current editor
    And I close the current editor

  Scenario: 4.1 Fertigunsvorschlag prüfen, nach Rückmeldung 2
    # Mengen in Fertigungsvorschlag pruefen
    Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "VIEW" for record ""
    And I set field "artikel" to "MISC4.1"
    And I press button "ladetab"
    Then table has values
      | mge | netmge | limge | netlimge | frgmge | netfrgmge | !row |
      | 58  | 50     | 42    | 35       | 42     | 35        | 1    |
    And I close the current editor

  Scenario Outline: 4.1 Werte in BA und AS prüfen, nach Rückmeldung 2
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
      | amge4.1_000 | 42  | 50      | 8           | 0       | 0        | 8    | 15         | 1                 |
      | amge4.1_002 | 37  | 50      | 3           | 15      | 1        | 3    | 0          | 0                 |
      | amge4.1_001 | 34  | 53      | 5           | 20      | 4        | 5    | 16         | 0                 |

  Scenario: 4.1 AFL Kopf prüfen (Skipfelder)
    Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "VIEW" for record ""
    And I set field "artikel" to "MISC4.1"
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

  Scenario: 4.1 Rückmeldung 3 auf BA
    Given I open an editor "Rückmeldung3" from table "(Workorder):(WorkOrders)" with command "DONE" for record "amge4.1_000"
    And I set field "sofort" to "1"
    And I set field "mgr" to "101"
    And I set field "gutmge" to "0" in row 1
    And I set field "verlustmge" to "5" in row 1
    And I save the current editor
    And I close the current editor

  Scenario: 4.1 Fertigunsvorschlag prüfen, nach Rückmeldung 3
    # Mengen in Fertigungsvorschlag pruefen
    Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "VIEW" for record ""
    And I set field "artikel" to "MISC4.1"
    And I press button "ladetab"
    Then table has values
      | mge | netmge | limge | netlimge | frgmge | netfrgmge | !row |
      | 58  | 50     | 38    | 35       | 38     | 35        | 1    |
    And I close the current editor

  Scenario Outline: 4.1 Werte in BA und AS prüfen, nach Rückmeldung 3
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
      | amge4.1_000 | 38  | 50      | 8           | 0       | 5        | 8    | 15         | 1                 |
      | amge4.1_002 | 35  | 50      | 3           | 15      | 1        | 3    | 0          | 5                 |
      | amge4.1_001 | 36  | 53      | 5           | 20      | 4        | 5    | 20         | 2                 |

  Scenario: 4.1 AFL Kopf prüfen (Skipfelder)
    Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "VIEW" for record ""
    And I set field "artikel" to "MISC4.1"
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
  Scenario: 4.1 Rückmeldung reduz auf AS1
    Given I open an editor "Rückmeldung_reduzier" from table "(Workorder):(WorkOrders)" with command "DONE" for record "amge4.1_001"
    And I set field "sofort" to "1"
    And I set field "mgr" to "101"
    And I set field "mgereduzieren" to "1"
    And I set field "gutmge" to "34" in row 1
    And I save the current editor
    And I close the current editor

  Scenario: 4.1 Fertigunsvorschlag prüfen, nach Rückmeldung reduz
    # Mengen in Fertigungsvorschlag pruefen
    Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "VIEW" for record ""
    And I set field "artikel" to "MISC4.1"
    And I press button "ladetab"
    Then table has values
      | mge | netmge | limge | netlimge | frgmge | netfrgmge | !row |
      | 59  | 51     | 44    | 36       | 44     | 36        | 1    |
    And I close the current editor

  Scenario Outline: 4.1 Werte in BA und AS prüfen, nach Rückmeldung reduz
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
      | such        | mge | egutmge | everlustmge | rgutmge | rverlust | amge | gutmgeauto | gutmgeautoverlust | status |
      | amge4.1_000 | 39  | 51      | 8           | 0       | 5        | 8    | 15         | 1                 |        |
      | amge4.1_002 | 36  | 51      | 3           | 15      | 1        | 3    | 0          | 5                 |        |
      | amge4.1_001 | 0   | 54      | 5           | 54      | 4        | 5    | 20         | 2                 | -      |

  Scenario: 4.1 FV Kopf prüfen
    Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "VIEW" for record ""
    And I set field "artikel" to "MISC4.1"
    And I press button "ladetab"
    # Werte mge und geamge werden im FV nicht angepasst.
    Then field "geamge" has value "8" in row 1
    Then field "pverlust" has value "0" in row 1
    Then field "mge" has value "59" in row 1
    Then field "netmge" has value "51" in row 1
    Then field "limge" has value "44" in row 1
    Then field "netlimge" has value "36" in row 1
    # AFL anzeigen und pruefen
    And I press button "absteig" to open a subeditor for "AFL" in row 1
    Then field "blimge" has value "44"
    Then field "bfrgmge" has value "44"
    Then field "netblimge" has value "36"
    Then field "netbfrgmge" has value "36"
    Then field "netbgmge" has value "51"
    Then table has values
      | elex       | mge | limge | frgmge | amge |
      | EK1-BEDARF | 59  | 0     | 0      | 0    |
      | A AG-LOHN1 | 59  | 0     | 0      | 5    |
      | EK2-BEDARF | 108 | 72    | 72     | 0    |
      | A AG-LOHN1 | 54  | 36    | 36     | 3    |
    And I close the current editor
    And I switch the current editor to editor "fvor"
    And I close the current editor

  # +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
  # Nächstes Szenario
  # Selbes Szenario wie 4.1 nur mit pverlust, da dieser Auswirkungen auf die Gesamtanfahrmenge hat.
  # +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
  Scenario Outline: 4.2 Artikel für Test 2
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
      | MISC4.2  | Bruttobedarf manbu=n, BA=AS | EK1-BEDARF | 1       | A AG-LOHN1 | 5     | 1         | EK2-BEDARF | 2       | A AG-LOHN1 | 3     | 1         |
      | MISC4.2C | Bruttobedarf manbu=n, BA=AS | EK1-BEDARF | 1       | A AG-LOHN1 | 5     | 1         | EK2-BEDARF | 2       | A AG-LOHN1 | 3     | 1         |

  Scenario: 4.2 Fertigungsvorschlag erstellen und freigeben
    Given I open an editor "fvor_MISC4.2" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
    And I append rows
      | artikel  | netmge | bisuch    | mfreig |
      | MISC4.2  | 50     | amge4.2_  | ja     |
      | MISC4.2C | 56.48  | amge4.2C_ | ja     |
    And I press button "freig" to open a subeditor for "BA_freigeben"
    And I close the current editor
    And I switch the current editor to editor "fvor_MISC4.2"
    And I save the current editor
    And I close the current editor

  Scenario: 4.2 Fertigunsvorschlag prüfen, noch nicht bebucht
    # Mengen in Fertigungsvorschlag pruefen
    Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "VIEW" for record ""
    And I set field "artikel" to "MISC4.2"
    And I press button "ladetab"
    Then table has values
      | mge    | netmge | limge  | netlimge | frgmge | netfrgmge | !row |
      | 59.046 | 50     | 59.046 | 50       | 59.046 | 50        | 1    |
    And I close the current editor

  Scenario Outline: 4.2 Werte in BA und AS prüfen
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
      | amge4.2_001 | 59.046 | 53.506  | 5.54        | 0       | 0        | 5    | 0          | 0                 |
      | amge4.2_002 | 53.506 | 50.001  | 3.505       | 0       | 0        | 3    | 0          | 0                 |
      | amge4.2_000 | 59.046 | 50      | 9.046       | 0       | 0        | 8.03 | 0          | 0                 |

  Scenario: 4.2 Rückmeldung 1 auf AS1
    Given I open an editor "Rückmeldung1" from table "(Workorder):(WorkOrders)" with command "DONE" for record "amge4.2_001"
    And I set field "sofort" to "1"
    And I set field "mgr" to "101"
    And I set field "gutmge" to "20" in row 1
    And I set field "verlustmge" to "4" in row 1
    And I save the current editor
    And I close the current editor

  Scenario: 4.2 Fertigunsvorschlag prüfen, nach Rückmeldung 1
    # Mengen in Fertigungsvorschlag pruefen
    Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "VIEW" for record ""
    And I set field "artikel" to "MISC4.2"
    And I press button "ladetab"
    Then table has values
      | mge    | netmge | limge  | netlimge | frgmge | netfrgmge | !row |
      | 59.046 | 50     | 59.046 | 50       | 59.046 | 50        | 1    |
    And I close the current editor

  Scenario Outline: 4.2 Werte in BA und AS prüfen, nach Rückmeldung 1
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
      | amge4.2_000 | 59.046 | 50      | 9.046       | 0       | 0        | 8.03 | 0          | 0                 |
      | amge4.2_002 | 53.506 | 50.001  | 3.505       | 0       | 0        | 3    | 0          | 0                 |
      | amge4.2_001 | 35.046 | 53.506  | 5.54        | 20      | 4        | 5    | 0          | 0                 |

  Scenario: 4.2 Rückmeldung 2 auf AS2
    Given I open an editor "Rückmeldung2" from table "(Workorder):(WorkOrders)" with command "DONE" for record "amge4.2_002"
    And I set field "sofort" to "1"
    And I set field "mgr" to "101"
    And I set field "gutmge" to "15" in row 1
    And I set field "verlustmge" to "1" in row 1
    And I save the current editor
    And I close the current editor

  Scenario: 4.2 Fertigunsvorschlag prüfen, nach Rückmeldung 2
    # Mengen in Fertigungsvorschlag pruefen
    Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "VIEW" for record ""
    And I set field "artikel" to "MISC4.2"
    And I press button "ladetab"
    Then table has values
      | mge    | netmge | limge  | netlimge | frgmge | netfrgmge | !row |
      | 59.046 | 50     | 43.046 | 35       | 43.046 | 35        | 1    |
    And I close the current editor

  Scenario Outline: 4.2 Werte in AS1 prüfen, nach Rückmeldung 2
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
      | amge4.2_000 | 43.046 | 50      | 9.046       | 0       | 0        | 8.03 | 15         | 1                 |
      | amge4.2_002 | 37.506 | 50.001  | 3.505       | 15      | 1        | 3    | 0          | 0                 |
      | amge4.2_001 | 35.046 | 53.506  | 5.54        | 20      | 4        | 5    | 16         | 0                 |

  Scenario: 4.2 Rückmeldung 3 auf BA
    Given I open an editor "Rückmeldung3" from table "(Workorder):(WorkOrders)" with command "DONE" for record "amge4.2_000"
    And I set field "sofort" to "1"
    And I set field "mgr" to "101"
    And I set field "gutmge" to "0" in row 1
    And I set field "verlustmge" to "5" in row 1
    And I save the current editor
    And I close the current editor

  Scenario: 4.2 Fertigunsvorschlag prüfen, nach Rückmeldung 3
    # Mengen in Fertigungsvorschlag pruefen
    Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "VIEW" for record ""
    And I set field "artikel" to "MISC4.2"
    And I press button "ladetab"
    Then table has values
      | mge    | netmge | limge  | netlimge | frgmge | netfrgmge | !row |
      | 59.046 | 50     | 39.046 | 35       | 39.046 | 35        | 1    |
    And I close the current editor

  Scenario Outline: 4.2 Werte in AS1 prüfen, nach Rückmeldung 3
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
      | amge4.2_000 | 39.046 | 50      | 9.046       | 0       | 5        | 8.03 | 15         | 1                 |
      | amge4.2_002 | 35.001 | 50.001  | 3.505       | 15      | 1        | 3    | 0          | 5                 |
      | amge4.2_001 | 36.541 | 53.506  | 5.54        | 20      | 4        | 5    | 20         | 1.495             |

  # Bebuchen des Vergleichs-FV
  Scenario: 4.2 Rückmeldung reduz auf AS1
    Given I open an editor "Rückmeldung_C" from table "(Workorder):(WorkOrders)" with command "DONE" for record "amge4.2C_001"
    And I set field "sofort" to "1"
    And I set field "mgr" to "101"
    And I set field "gutmge" to "55" in row 1
    And I set field "verlustmge" to "4" in row 1
    And I save the current editor
    And I close the current editor
    Given I open an editor "Rückmeldung_C" from table "(Workorder):(WorkOrders)" with command "DONE" for record "amge4.2C_002"
    And I set field "sofort" to "1"
    And I set field "mgr" to "101"
    And I set field "gutmge" to "15" in row 1
    And I set field "verlustmge" to "1" in row 1
    And I save the current editor
    And I close the current editor
    Given I open an editor "Rückmeldung_C" from table "(Workorder):(WorkOrders)" with command "DONE" for record "amge4.2C_000"
    And I set field "sofort" to "1"
    And I set field "mgr" to "101"
    And I set field "gutmge" to "0" in row 1
    And I set field "verlustmge" to "5" in row 1
    And I save the current editor
    And I close the current editor

  # Reduzieren AS1
  Scenario: 4.2 Rückmeldung reduz auf AS1
    Given I open an editor "Rückmeldung_reduz" from table "(Workorder):(WorkOrders)" with command "DONE" for record "amge4.2_001"
    And I set field "sofort" to "1"
    And I set field "mgr" to "101"
    And I set field "mgereduzieren" to "1"
    And I set field "gutmge" to "35" in row 1
    And I save the current editor
    And I close the current editor

  Scenario: 4.2 Fertigunsvorschlag prüfen, nach Rückmeldung reduz
    # Mengen in Fertigungsvorschlag pruefen
    Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "VIEW" for record ""
    And I set field "artikel" to "MISC4.2"
    And I press button "ladetab"
    Then table has values
      | mge    | netmge | limge  | netlimge | frgmge | netfrgmge | !row |
      | 65.656 | 56.479 | 45.555 | 41.479   | 45.555 | 41.479    | 1    |
    And I close the current editor
    # Zum Vergleich der nicht reduzierte, der beim Anlegen bereits die niedrieger Menge hatte
    Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "VIEW" for record ""
    And I set field "artikel" to "MISC4.2C"
    And I press button "ladetab"
    Then table has values
      | mge    | netmge | limge  | netlimge | frgmge | netfrgmge | !row |
      | 65.657 | 56.48  | 45.657 | 41.48    | 45.657 | 41.48     | 1    |
    And I close the current editor

  # Hier werden die Werte der Arbeitscheine ausgegeben. amge4.2_ ist der reduzierte FV, amge4.2C ist der Vergleichs-FV
  # Die Werte der Zeilen mit gleicher Nummer am Ende (_000, usw.) sollten, bis auf Rundungsdifferenzen, identisch sein.
  # mge von AS amge4.2_001 ist 0 aufgrund des gesetzten Statusflags.
  Scenario Outline: 4.2 Werte in BA und AS prüfen, nach Rückmeldung reduz
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
      | AMGE4.2_000  | 45.656 | 56.479  | 9.177       | 0       | 5        | 8.03 | 15         | 1                 |        |
      | AMGE4.2_002  | 41.479 | 56.479  | 3.57        | 15      | 1        | 3    | 0          | 5                 |        |
      | AMGE4.2_001  | 0      | 60.049  | 5.607       | 55      | 4        | 5    | 20         | 1.43              | -      |
      | AMGE4.2C_000 | 45.657 | 56.48   | 9.177       | 0       | 5        | 8.03 | 15         | 1                 |        |
      | AMGE4.2C_002 | 41.48  | 56.48   | 3.57        | 15      | 1        | 3    | 0          | 5                 |        |
      | AMGE4.2C_001 | 8.087  | 60.05   | 5.607       | 55      | 4        | 5    | 20         | 1.43              |        |

  Scenario: 4.2 FV Kopf prüfen
    Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "VIEW" for record ""
    And I set field "artikel" to "MISC4.2"
    And I press button "ladetab"
    # Werte mge und geamge werden im FV nicht angepasst.
    Then field "geamge" has value "8.03" in row 1
    Then field "pverlust" has value "1.99" in row 1
    Then field "mge" has value "65.656" in row 1
    Then field "netmge" has value "56.479" in row 1
    Then field "limge" has value "45.555" in row 1
    Then field "netlimge" has value "41.479" in row 1
    # AFL anzeigen und pruefen
    And I press button "absteig" to open a subeditor for "AFL" in row 1
    Then field "blimge" has value "45.555"
    Then field "bfrgmge" has value "45.555"
    Then field "netblimge" has value "41.479"
    Then field "netbfrgmge" has value "41.479"
    Then field "netbgmge" has value "56.479"
    Then table has values
      | elex       | mge     | limge  | frgmge | amge |
      | EK1-BEDARF | 65.656  | 0      | 0      | 0    |
      | A AG-LOHN1 | 65.656  | 0      | 0      | 5    |
      | EK2-BEDARF | 120.098 | 82.958 | 82.958 | 0    |
      | A AG-LOHN1 | 60.049  | 41.479 | 41.479 | 3    |
    And I close the current editor
    And I switch the current editor to editor "fvor"
    And I close the current editor

  Scenario: 4.2 c FV Kopf prüfen im Vergleich
    Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "VIEW" for record ""
    And I set field "artikel" to "MISC4.2C"
    And I press button "ladetab"
    # Werte mge und geamge werden im FV nicht angepasst.
    Then field "geamge" has value "8.03" in row 1
    Then field "pverlust" has value "1.99" in row 1
    Then field "mge" has value "65.657" in row 1
    Then field "netmge" has value "56.48" in row 1
    Then field "limge" has value "45.657" in row 1
    Then field "netlimge" has value "41.48" in row 1
    # AFL anzeigen und pruefen
    And I press button "absteig" to open a subeditor for "AFL" in row 1
    Then field "blimge" has value "45.657"
    Then field "bfrgmge" has value "45.657"
    Then field "netblimge" has value "41.48"
    Then field "netbfrgmge" has value "41.48"
    Then field "netbgmge" has value "56.48"
    Then table has values
      | elex       | mge    | limge | frgmge | amge |
      | EK1-BEDARF | 65.657 | 8.087 | 8.087  | 0    |
      | A AG-LOHN1 | 65.657 | 8.087 | 8.087  | 5    |
      | EK2-BEDARF | 120.1  | 82.96 | 82.96  | 0    |
      | A AG-LOHN1 | 60.05  | 41.48 | 41.48  | 3    |
    And I close the current editor
    And I switch the current editor to editor "fvor"
    And I close the current editor
