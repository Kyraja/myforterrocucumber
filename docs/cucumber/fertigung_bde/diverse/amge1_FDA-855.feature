# *****************************************************************************
#  Name             : amge
#  Autor            : drpf
#  Verantwortlich   : drpf
#  Kontrolle        : amk
#  Funktion         : Prozesstest mit Anfahrmenge
#                     Es wird ein Fv mit Anfahrmenge im zweiten Arbeitsgang freigegeben
#                     und mit reduzierenden Rückmeldungen bebucht. Dabei werden auch ungeplante Ausschüsse gebucht.
#                     Nach reduzieren des zweiten Artbeitsgang, muss die Gutmenge der reduzierten entsprechen.
#                     Die Anfahrmenge wurde bereits gebucht und darf nicht weiter beachtet werden.
#  Jira-Issue       : FDA-855
# *****************************************************************************
@persistent
Feature: amge.feature

  Scenario Outline: 1.1 Artikel für Test 1
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
      | elex    | anzahl | amge    |
      | <elex1> | 1      |         |
      | <ag1>   | 1      | 0       |
      | <elex2> | 1      |         |
      | <ag2>   | 1      | <amge2> |
      | <elex3> | 1      |         |
      | <ag3>   | 1      | 0       |
    And I save the current editor

    Examples:
      | such    | namebspr                    | elex1      | ag1   | elex2      | ag2   | amge2 | elex3      | ag3   |
      | MISC1.1 | Bruttobedarf manbu=n, BA=AS | EK1-BEDARF | A AG1 | EK2-BEDARF | A AG2 | 3     | EK3-BEDARF | A AG3 |

  Scenario: 1.1 Fertigungsvorschlag erstellen und freigeben
    Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
    And I append rows
      | artikel | netmge | bisuch  | mfreig |
      | MISC1.1 | 100    | amge1.1 | ja     |
    And I press button "freig" to open a subeditor for "BA_freigeben"
    And I close the current editor
    And I switch the current editor to editor "fvor"
    And I save the current editor
    And I close the current editor

  Scenario: 1.1 Rückmeldung 1 mit Reduktion auf AS1
    Given I open an editor "Rückmeldung1" from table "(Workorder):(WorkOrders)" with command "DONE" for record "amge1.1001"
    And I set field "sofort" to "1"
    And I set field "mgereduzieren" to "1"
    And I set field "gutmge" to "95" in row 1
    And I set field "verlustmge" to "5" in row 1
    And I save the current editor
    And I close the current editor

  Scenario Outline: 1.1 Werte in BA und AS prüfen, nach Rückmeldung 1
    Given I open an editor "BAAS" from table "(Workorder):(WorkOrders)" with command "VIEW" for record "<such>"
    Then fields have values
      | mge         | <mge>         |
      | egutmge     | <egutmge>     |
      | everlustmge | <everlustmge> |
      | rgutmge     | <rgutmge>     |
      | rverlust    | <rverlust>    |
      | amge        | <amge>        |
      | status      | <status>      |
    And I save the current editor

    Examples:
      | such       | mge | egutmge | everlustmge | rgutmge | rverlust | amge | status |
      | amge1.1000 | 95  | 92      | 3           | 0       | 0        | 3    |        |
      | amge1.1003 | 92  | 92      | 0           | 0       | 0        | 0    |        |
      | amge1.1002 | 95  | 92      | 3           | 0       | 0        | 3    |        |
      | amge1.1001 | 0   | 95      | 0           | 95      | 5        | 0    | -      |

  Scenario: 1.1 Fertigungsvorschlag anzeigen, Mengen prüfen, AFL aufrufen und Mengen prüfen nach Rückmeldung 1
    Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "VIEW" for record ""
    And I set field "artikel" to "MISC1.1"
    And I press button "ladetab"
    Then field "netmge" has value "92" in row 1
    Then field "mge" has value "95" in row 1
    # AFL anzeigen und pruefen
    And I press button "absteig" to open a subeditor for "AFL" in row 1
    Then field "blimge" has value "95"
    Then field "bfrgmge" has value "95"
    Then field "netblimge" has value "92"
    Then field "netbfrgmge" has value "92"
    Then table has values
      | elex       | limge | frgmge | amge |
      | EK1-BEDARF | 0     | 0      | 0    |
      | A AG1      | 0     | 0      | 0    |
      | EK2-BEDARF | 95    | 95     | 0    |
      | A AG2      | 95    | 95     | 3    |
      | EK3-BEDARF | 92    | 92     | 0    |
      | A AG3      | 92    | 92     | 0    |
    And I close the current editor
    And I switch the current editor to editor "fvor"
    And I close the current editor

  Scenario: 1.1 Rückmeldung 2 mit Reduktion auf AS2
    Given I open an editor "Rückmeldung2" from table "(Workorder):(WorkOrders)" with command "DONE" for record "amge1.1002"
    And I set field "sofort" to "1"
    And I set field "mgereduzieren" to "1"
    And I set field "gutmge" to "85" in row 1
    And I set field "verlustmge" to "10" in row 1
    And I save the current editor
    And I close the current editor

  Scenario Outline: 1 Werte in BA und AS prüfen, nach Rückmeldung 2
    Given I open an editor "BAAS" from table "(Workorder):(WorkOrders)" with command "VIEW" for record "<such>"
    Then fields have values
      | mge         | <mge>         |
      | egutmge     | <egutmge>     |
      | everlustmge | <everlustmge> |
      | rgutmge     | <rgutmge>     |
      | rverlust    | <rverlust>    |
      | amge        | <amge>        |
      | status      | <status>      |
    And I save the current editor

    Examples:
      | such       | mge | egutmge | everlustmge | rgutmge | rverlust | amge | status |
      | amge1.1000 | 88  | 85      | 3           | 0       | 0        | 3    |        |
      | amge1.1003 | 85  | 85      | 0           | 0       | 0        | 0    |        |
      | amge1.1002 | 0   | 85      | 3           | 85      | 10       | 3    | -      |
      | amge1.1001 | 0   | 88      | 0           | 95      | 5        | 0    | -      |

  Scenario: 1.1 Fertigungsvorschlag anzeigen, Mengen prüfen, AFL aufrufen und Mengen prüfen nach Rückmeldung 2
    Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "VIEW" for record ""
    And I set field "artikel" to "MISC1.1"
    And I press button "ladetab"
    Then field "netmge" has value "85" in row 1
    Then field "mge" has value "88" in row 1
    # AFL anzeigen und pruefen
    And I press button "absteig" to open a subeditor for "AFL" in row 1
    Then field "blimge" has value "88"
    Then field "bfrgmge" has value "88"
    Then field "netblimge" has value "85"
    Then field "netbfrgmge" has value "85"
    Then table has values
      | elex       | limge | frgmge | amge |
      | EK1-BEDARF | 0     | 0      | 0    |
      | A AG1      | 0     | 0      | 0    |
      | EK2-BEDARF | 0     | 0      | 0    |
      | A AG2      | 0     | 0      | 3    |
      | EK3-BEDARF | 85    | 85     | 0    |
      | A AG3      | 85    | 85     | 0    |
    And I close the current editor
    And I switch the current editor to editor "fvor"
    And I close the current editor

  Scenario: 1.1 Fertingungsvorschläge mit Ändern aufrufen und speichern, da dabei Werte neu berechnet werden.
    Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "UPDATE" for record ""
    And I set field "artikel" to "MISC1.1"
    And I press button "ladetab"
    Then field "netmge" has value "85" in row 1
    Then field "mge" has value "88" in row 1
    And I save the current editor
    And I close the current editor

  Scenario: 1.1 Fertingungsvorschläge und AFL erneut prüfen, es darf sich nichts verändert hebn.
    Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "VIEW" for record ""
    And I set field "artikel" to "MISC1.1"
    And I press button "ladetab"
    Then field "netmge" has value "85" in row 1
    Then field "mge" has value "88" in row 1
    # AFL anzeigen und pruefen
    And I press button "absteig" to open a subeditor for "AFL" in row 1
    Then field "blimge" has value "88"
    Then field "bfrgmge" has value "88"
    Then field "netblimge" has value "85"
    Then field "netbfrgmge" has value "85"
    Then field "netbgmge" has value "85"
    Then table has values
      | elex       | limge | frgmge | amge |
      | EK1-BEDARF | 0     | 0      | 0    |
      | A AG1      | 0     | 0      | 0    |
      | EK2-BEDARF | 0     | 0      | 0    |
      | A AG2      | 0     | 0      | 3    |
      | EK3-BEDARF | 85    | 85     | 0    |
      | A AG3      | 85    | 85     | 0    |
    And I close the current editor
    And I switch the current editor to editor "fvor"
    And I close the current editor

  Scenario: 1.1 Zweite Rückmeldung stornieren, um das Verhalten festzuhalten.
    Given I open an editor "Storno1" via ID from editor "Rückmeldung2" from field "id" in row 0 for table "(Workorder):(CompletionConfirmations)" with command "REVERSAL"
    And I save the current editor

  Scenario Outline: 1 Werte in BA und AS prüfen, nach stornieren der Rückmeldung 2
    Given I open an editor "BAAS" from table "(Workorder):(WorkOrders)" with command "VIEW" for record "<such>"
    Then fields have values
      | mge         | <mge>         |
      | egutmge     | <egutmge>     |
      | everlustmge | <everlustmge> |
      | rgutmge     | <rgutmge>     |
      | rverlust    | <rverlust>    |
      | amge        | <amge>        |
      | status      | <status>      |
    And I save the current editor

    Examples:
      | such       | mge | egutmge | everlustmge | rgutmge | rverlust | amge | status |
      | amge1.1000 | 88  | 85      | 3           | 0       | 0        | 3    |        |
      | amge1.1003 | 85  | 85      | 0           | 0       | 0        | 0    |        |
      | amge1.1002 | 88  | 85      | 3           | 0       | 0        | 3    |        |
      | amge1.1001 | 0   | 88      | 0           | 95      | 5        | 0    | -      |

  Scenario: 1.1 Fertigungsvorschlag anzeigen, Mengen prüfen, AFL aufrufen und Mengen prüfen nach stornieren der Rückmeldung 2
    Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "VIEW" for record ""
    And I set field "artikel" to "MISC1.1"
    And I press button "ladetab"
    Then field "netmge" has value "85" in row 1
    Then field "mge" has value "88" in row 1
    # AFL anzeigen und pruefen
    And I press button "absteig" to open a subeditor for "AFL" in row 1
    Then field "blimge" has value "88"
    Then field "bfrgmge" has value "88"
    Then field "netblimge" has value "85"
    Then field "netbfrgmge" has value "85"
    Then table has values
      | elex       | limge | frgmge | amge |
      | EK1-BEDARF | -7    | 0      | 0    |
      | A AG1      | -7    | 0      | 0    |
      | EK2-BEDARF | 88    | 88     | 0    |
      | A AG2      | 88    | 88     | 3    |
      | EK3-BEDARF | 85    | 85     | 0    |
      | A AG3      | 85    | 85     | 0    |
    And I close the current editor
    And I switch the current editor to editor "fvor"
    And I close the current editor

  Scenario: 1.1 Erste Rückmeldung stornieren, um das Verhalten festzuhalten.
    Given I open an editor "Storno2" via ID from editor "Rückmeldung1" from field "id" in row 0 for table "(Workorder):(CompletionConfirmations)" with command "REVERSAL"
    And I save the current editor

  Scenario Outline: 1 Werte in BA und AS prüfen, nach stornieren der Rückmeldung 1
    Given I open an editor "BAAS" from table "(Workorder):(WorkOrders)" with command "VIEW" for record "<such>"
    Then fields have values
      | mge         | <mge>         |
      | egutmge     | <egutmge>     |
      | everlustmge | <everlustmge> |
      | rgutmge     | <rgutmge>     |
      | rverlust    | <rverlust>    |
      | amge        | <amge>        |
      | status      | <status>      |
    And I save the current editor

    Examples:
      | such       | mge | egutmge | everlustmge | rgutmge | rverlust | amge | status |
      | amge1.1000 | 88  | 85      | 3           | 0       | 0        | 3    |        |
      | amge1.1003 | 85  | 85      | 0           | 0       | 0        | 0    |        |
      | amge1.1002 | 88  | 85      | 3           | 0       | 0        | 3    |        |
      | amge1.1001 | 88  | 88      | 0           | 0       | 0        | 0    |        |

  Scenario: 1.1 Fertigungsvorschlag anzeigen, Mengen prüfen, AFL aufrufen und Mengen prüfen nach stornieren der Rückmeldung 1
    Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "VIEW" for record ""
    And I set field "artikel" to "MISC1.1"
    And I press button "ladetab"
    Then field "netmge" has value "85" in row 1
    Then field "mge" has value "88" in row 1
    # AFL anzeigen und pruefen
    And I press button "absteig" to open a subeditor for "AFL" in row 1
    Then field "blimge" has value "88"
    Then field "bfrgmge" has value "88"
    Then field "netblimge" has value "85"
    Then field "netbfrgmge" has value "85"
    Then table has values
      | elex       | limge | frgmge | amge |
      | EK1-BEDARF | 88    | 88     | 0    |
      | A AG1      | 88    | 88     | 0    |
      | EK2-BEDARF | 88    | 88     | 0    |
      | A AG2      | 88    | 88     | 3    |
      | EK3-BEDARF | 85    | 85     | 0    |
      | A AG3      | 85    | 85     | 0    |
    And I close the current editor
    And I switch the current editor to editor "fvor"
    And I close the current editor
