# *****************************************************************************
#  Name             : amge2_erhoehe_fv.feature
#  Autor            : drpf
#  Verantwortlich   : drpf
#  Kontrolle        : amk
#  Funktion         : Testet Erhöhen der Fertigmenge eines bebuchten Fertigunsvorschlages
#                     über die Funktion Menge reduzieren in der Rückmeldung.
#                     FV mit 3 Arbeitsgängen mit Anfahrmenge und pverlust.
#  Jira-Issue       : FDA-1978
# *****************************************************************************
@persistent
Feature: amge2_erhoehe_fv.feature

  Scenario Outline: 2.1 Testartikel
    Given I open an editor "<such>" from table "(Part):(Product)" with command "STORE" for record "<such>"
    And I set fields
      | such      | <such>          |
      | namebspr  | <namebspr>      |
      | dispoa    | auftragsbezogen |
      | bsart     | Eigenfertigung  |
      | gemein    | GK2.14.3        |
      | chverfolgung | Chargenverfolgung              |
      | wgruppe   | 55              |
      | erlgrp    | 66              |
    And I delete all rows
    And I append rows
      | elex    | anzahl    | amge    | pverlust    |
      | <elex1> | <anzahl1> |         |             |
      | <ag1>   | 1         | <amge1> | <pverlust1> |
      | <elex2> | <anzahl2> |         |             |
      | <ag2>   | 1         | <amge2> | <pverlust2> |
      | <elex3> | <anzahl3> |         |             |
      | <ag3>   | 1         | <amge3> | <pverlust3> |
    And I save the current editor

    Examples:
      | such    | namebspr                    | elex1      | anzahl1 | ag1        | amge1 | pverlust1 | elex2      | anzahl2 | ag2        | amge2 | pverlust2 | elex3      | anzahl3 | ag3        | amge3 | pverlust3 |
      | MISC2.1 | Bruttobedarf manbu=n, BA=AS | EK1-BEDARF | 1       | A AG-LOHN1 | 1     | 10        | EK2-BEDARF | 2       | A AG-LOHN2 | 2     | 10        | EK3-BEDARF | 3       | A AG-LOHN3 | 3     | 10        |

  Scenario: 2.1 Test aus ref_fert_bbe
    Given I open an editor "fvor_MISC2.1" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
    And I append rows
      | artikel | netmge | bisuch   | mfreig |
      | MISC2.1 | 30     | amge2.2_ | ja     |
    And I press button "freig" to open a subeditor for "BA_freigeben"
    And I close the current editor
    And I switch the current editor to editor "fvor_MISC2.1"
    And I save the current editor
    And I close the current editor
    # Mengen in Fertigungsvorschlag ausgeben als Referenzwert
    Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "VIEW" for record ""
    And I set field "artikel" to "MISC2.1"
    And I press button "ladetab"
    Then table has values
      | mge    | netmge | limge  | netlimge | frgmge | netfrgmge | !row |
      | 48.078 | 30     | 48.078 | 30       | 48.078 | 30        | 1    |
    And I close the current editor

  # Mengen aus Betriebsauftrag und Arbeitscheine ausgeben als Referenzwert
  Scenario Outline: 2.1 Referenzwerte
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
    And I close the current editor

    Examples:
      | such        | mge    | egutmge | everlustmge | rgutmge | rverlust | amge  | gutmgeauto | gutmgeautoverlust |
      | amge2.2_000 | 48.078 | 30      | 18.078      | 0       | 0        | 6.926 | 0          | 0                 |
      | amge2.2_003 | 36.333 | 30      | 6.333       | 0       | 0        | 3     | 0          | 0                 |
      | amge2.2_002 | 42.37  | 36.333  | 6.037       | 0       | 0        | 2     | 0          | 0                 |
      | amge2.2_001 | 48.078 | 42.37   | 5.708       | 0       | 0        | 1     | 0          | 0                 |

  # Erste Rückmeldung, auf Arbeitschein 1
  Scenario: 2.1 erste Rückmeldung
    Given I open an editor "Rückmeldung1" from table "(Workorder):(WorkOrders)" with command "DONE" for record "amge2.2_001"
    And I set field "sofort" to "1"
    And I set field "mgr" to "101"
    And I set field "gutmge" to "20" in row 1
    And I set field "verlustmge" to "5" in row 1
    And I save the current editor
    And I close the current editor
    Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "VIEW" for record ""
    And I set field "artikel" to "MISC2.1"
    And I press button "ladetab"
    Then table has values
      | mge    | netmge | limge  | netlimge | frgmge | netfrgmge | !row |
      | 48.078 | 30     | 48.078 | 30       | 48.078 | 30        | 1    |
    And I close the current editor

  Scenario Outline: 
    # Mengen aus Betriebsauftrag und Arbeitscheine prüfen. Nur die Werte im ersten Arbeitschein sind verändert.
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
      | such        | mge    | egutmge | everlustmge | rgutmge | rverlust | amge  | gutmgeauto | gutmgeautoverlust |
      | amge2.2_000 | 48.078 | 30      | 18.078      | 0       | 0        | 6.926 | 0          | 0                 |
      | amge2.2_003 | 36.333 | 30      | 6.333       | 0       | 0        | 3     | 0          | 0                 |
      | amge2.2_002 | 42.37  | 36.333  | 6.037       | 0       | 0        | 2     | 0          | 0                 |
      | amge2.2_001 | 23.078 | 42.37   | 5.708       | 20      | 5        | 1     | 0          | 0                 |

  Scenario: 2.1 zweite Rückmeldung
    # Zweite Rückmeldung, auf Arbeitschein 2
    Given I open an editor "Rückmeldung2" from table "(Workorder):(WorkOrders)" with command "DONE" for record "amge2.2_002"
    And I set field "sofort" to "1"
    And I set field "mgr" to "101"
    And I set field "gutmge" to "15" in row 1
    And I set field "verlustmge" to "3" in row 1
    And I save the current editor
    And I close the current editor
    Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "VIEW" for record ""
    And I set field "artikel" to "MISC2.1"
    And I press button "ladetab"
    Then table has values
      | mge    | netmge | limge  | netlimge | frgmge | netfrgmge | !row |
      | 48.078 | 30     | 48.078 | 30       | 48.078 | 30        | 1    |
    And I close the current editor

  Scenario Outline: 
    # Mengen aus Betriebsauftrag und Arbeitscheine prüfen. Nur die Werte im ersten (gutmgeauto)
    # und zweiten Arbeitschein sind verändert.
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
      | such        | mge    | egutmge | everlustmge | rgutmge | rverlust | amge  | gutmgeauto | gutmgeautoverlust |
      | amge2.2_000 | 48.078 | 30      | 18.078      | 0       | 0        | 6.926 | 0          | 0                 |
      | amge2.2_003 | 36.333 | 30      | 6.333       | 0       | 0        | 3     | 0          | 0                 |
      | amge2.2_002 | 24.37  | 36.333  | 6.037       | 15      | 3        | 2     | 0          | 0                 |
      | amge2.2_001 | 23.078 | 42.37   | 5.708       | 20      | 5        | 1     | 18         | 0                 |

  Scenario: 2.1 dritte Rückmeldung
    # Dritte Rückmeldung, auf Arbeitschein 3
    Given I open an editor "Rückmeldung3" from table "(Workorder):(WorkOrders)" with command "DONE" for record "amge2.2_003"
    And I set field "sofort" to "1"
    And I set field "mgr" to "101"
    And I set field "gutmge" to "10" in row 1
    And I set field "verlustmge" to "1" in row 1
    And I save the current editor
    And I close the current editor
    Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "VIEW" for record ""
    And I set field "artikel" to "MISC2.1"
    And I press button "ladetab"
    Then table has values
      | mge    | netmge | limge  | netlimge | frgmge | netfrgmge | !row |
      | 48.078 | 30     | 37.078 | 20       | 37.078 | 20        | 1    |
    And I close the current editor

  Scenario Outline: 
    # Mengen aus Betriebsauftrag und Arbeitscheine prüfen. Nur die Werte im zweiten (gutmgeauto)
    # und dritten Arbeitschein und Betriebsauftrag sind verändert.
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
      | such        | mge    | egutmge | everlustmge | rgutmge | rverlust | amge  | gutmgeauto | gutmgeautoverlust |
      | amge2.2_000 | 37.078 | 30      | 18.078      | 0       | 0        | 6.926 | 10         | 1                 |
      | amge2.2_003 | 25.333 | 30      | 6.333       | 10      | 1        | 3     | 0          | 0                 |
      | amge2.2_002 | 24.37  | 36.333  | 6.037       | 15      | 3        | 2     | 11         | 0                 |
      | amge2.2_001 | 23.078 | 42.37   | 5.708       | 20      | 5        | 1     | 18         | 0                 |

  # BA steht für sich und wird zwar durch den letzten Arbeitschein mit Gutmenge bebucht, aber nicht mit Verlust.
  Scenario: 2.1 vierte Rückmeldung
    # Vierte Rückmeldung, auf Betriebsauftrag
    Given I open an editor "Rückmeldung4" from table "(Workorder):(WorkOrders)" with command "DONE" for record "amge2.2_000"
    And I set field "sofort" to "1"
    And I set field "mgr" to "101"
    And I set field "gutmge" to "5" in row 1
    And I set field "verlustmge" to "7" in row 1
    And I save the current editor
    And I close the current editor
    Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "VIEW" for record ""
    And I set field "artikel" to "MISC2.1"
    And I press button "ladetab"
    Then table has values
      # netlimge und netfrgmge bleiben bei 20, da über den letzten BA schon 10 gut gebucht wurden.
      # Als Verlust wird die Differenz zum letzten AS gebucht: 7 - 1 = 6
      # frgmge und limge reduzieren sich auf 31.078, da insgesamt 10 + 6 gebucht wurden.
      | mge    | netmge | limge  | netlimge | frgmge | netfrgmge | !row |
      | 48.078 | 30     | 31.078 | 20       | 31.078 | 20        | 1    |
    And I close the current editor

  Scenario Outline: 
    # Mengen aus Betriebsauftrag und Arbeitscheine prüfen.
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
      | such        | mge    | egutmge | everlustmge | rgutmge | rverlust | amge  | gutmgeauto | gutmgeautoverlust |
      | amge2.2_000 | 31.078 | 30      | 18.078      | 5       | 7        | 6.926 | 10         | 1                 |
      | amge2.2_003 | 20     | 30      | 6.333       | 10      | 1        | 3     | 5          | 7                 |
      | amge2.2_002 | 23.037 | 36.333  | 6.037       | 15      | 3        | 2     | 17         | 0.667             |
      | amge2.2_001 | 23.745 | 42.37   | 5.708       | 20      | 5        | 1     | 20         | 0.667             |

  # Auf den BA wurden 5 gut gebucht, auf den letzten Arbeitsschein AS3 10. Es gilt die maximale Gutmenge, also 10.
  # Auf den Ba wurden 7 Verlust gebucht, auf den letzten Arbeitsschein AS3  1. Auch hier gilt das Maximum, also 7.
  # Die Summe daraus (10 + 7) ist die gutmgeauto in AS2!
  Scenario: 2.1 Menge über AFL reduzieren
    Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "UPDATE" for record ""
    And I set field "artikel" to "MISC2.1"
    And I press button "ladetab"
    Then table has values
      | mge    | netmge | limge  | netlimge | frgmge | netfrgmge | geamge | pverlust | !row |
      | 48.078 | 30     | 31.078 | 20       | 31.078 | 20        | 6.926  | 27.1     | 1    |
    # AFL
    And I press button "absteig" to open a subeditor for "AFL" in row 1
    Then field "bgmge" has value "48.078"
    Then field "blimge" has value "31.078"
    Then field "geamge" has value "6.926"
    Then field "pverlust" has value "27.1"
    Then field "netbgmge" has value "30"
    Then field "netblimge" has value "20"
    And I set field "netbgmge" to "70"
    And I set field "netbfrgmge" to "60"
    And I save the current editor
    And I close the current editor
    And I switch the current editor to editor "fvor"
    And I save the current editor
    And I close the current editor
    # Mengen in Fertigungsvorschlag erneut pruefen, durch Anzeigen der AFL in Aendern koennen sich Mengen aendern
    Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "VIEW" for record ""
    And I set field "artikel" to "MISC2.1"
    And I press button "ladetab"
    Then table has values
      | mge     | netmge | limge  | netlimge | frgmge | netfrgmge | geamge | pverlust | !row |
      | 102.948 | 70     | 85.948 | 60       | 85.948 | 60        | 6.926  | 27.1     | 1    |
    And I close the current editor

  Scenario Outline: 
    # Mengen aus Betriebsauftrag und Arbeitscheine prüfen.
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
      | such        | mge    | egutmge | everlustmge | rgutmge | rverlust | amge  | gutmgeauto | gutmgeautoverlust |
      | amge2.2_000 | 85.948 | 70      | 32.948      | 5       | 7        | 6.926 | 10         | 1                 |
      | amge2.2_003 | 63.778 | 70      | 10.778      | 10      | 1        | 3     | 5          | 7                 |
      | amge2.2_002 | 71.753 | 80.778  | 10.975      | 15      | 3        | 2     | 17         | 0                 |
      | amge2.2_001 | 77.948 | 91.753  | 11.195      | 20      | 5        | 1     | 20         | 0                 |
