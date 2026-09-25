# *****************************************************************************
# Name             : storno_reihenfolge.feature
# Autor            : lschneider/amk
# Verantwortlich   : amk
# Kontrolle        : drpf
# Funktion         : Prozesstest Storno von Rückmeldungen bei mehreren Arbeitsgängen zum Material
# Jira-Issue       : FDA-3251
# *****************************************************************************
@persistent
Feature: storno_reihenfolge.feature

  Scenario Outline: Baugruppen mit einer bzw. mehreren Komponenten und mehreren Arbeitsgängen anlegen
    Given I open an editor "<such>" from table "(Part):(Product)" with command "STORE" for record "<such>"
    And I set fields
      | such      | <such>         |
      | namebspr  | <namebspr>     |
      | dispoa    | <dispoa>       |
      | bsart     | Eigenfertigung |
      | ekbewverf | <ekbewverf>    |
      | gemein    | <gemein>       |
      | wgruppe   | <wgruppe>      |
      | erlgrp    | <erlgrp>       |
    And I delete all rows
    And I append rows
      | elex     | anzahl     |
      | <elex1>  | <anzahl1>  |
      | <elex2>  | <anzahl2>  |
      | <elex3>  | <anzahl3>  |
      | <elex4>  | <anzahl4>  |
      | <elex5>  | <anzahl5>  |
      | <elex6>  | <anzahl6>  |
      | <elex7>  | <anzahl7>  |
      | <elex8>  | <anzahl8>  |
      | <elex9>  | <anzahl9>  |
      | <elex10> | <anzahl10> |
    And I save the current editor

    Examples:
      | such        | namebspr               | dispoa         | ekbewverf | gemein   | wgruppe | erlgrp | elex1      | anzahl1 | elex2      | anzahl2 | elex3      | anzahl3 | elex4      | anzahl4 | elex5      | anzahl5 | elex6      | anzahl6 | elex7      | anzahl7 | elex8      | anzahl8 | elex9      | anzahl9 | elex10     | anzahl10 |
      | BG-STORNO   | Baugruppe für Storno   | bedarfsbezogen | 6         | GK2.14.3 | WG-FE   | PG-UE  | EK1-BEDARF | 1       | A AG-LOHN1 | 1       | A AG-LOHN2 | 1       | A AG-LOHN3 | 1       |            |         |            |         |            |         |            |         |            |         |            |          |
      | BG2-STORNO  | Baugruppe für Storno2  | bedarfsbezogen | 6         | GK2.14.3 | WG-FE   | PG-UE  | EK1-BEDARF | 1       | A AG-LOHN1 | 1       | A AG-LOHN2 | 1       | A AG-LOHN3 | 1       | A AG1      | 1       |            |         |            |         |            |         |            |         |            |          |
      | BG3-STORNO  | Baugruppe für Storno3  | bedarfsbezogen | 6         | GK2.14.3 | WG-FE   | PG-UE  | EK1-BEDARF | 1       | A AG-LOHN1 | 1       | EK2-BEDARF | 1       | A AG-LOHN2 | 1       | A AG-LOHN3 | 1       |            |         |            |         |            |         |            |         |            |          |
      | BG4-STORNO  | Baugruppe für Storno4  | bedarfsbezogen | 6         | GK2.14.3 | WG-FE   | PG-UE  | EK1-BEDARF | 1       | A AG-LOHN1 | 1       | A AG-LOHN2 | 1       | EK2-BEDARF | 1       | A AG-LOHN3 | 1       |            |         |            |         |            |         |            |         |            |          |
      | BG5-STORNO  | Baugruppe für Storno5  | bedarfsbezogen | 6         | GK2.14.3 | WG-FE   | PG-UE  | EK1-BEDARF | 1       | A AG-LOHN1 | 1       | EK2-BEDARF | 1       | A AG-LOHN2 | 1       | EK1-BEDARF | 1       | A AG-LOHN3 | 1       | EK2-BEDARF | 1       | A AG-LOHN3 | 1       | EK1-BEDARF | 1       | A AG-LOHN3 | 1        |
      | BG6-STORNO  | Baugruppe für Storno6  | bedarfsbezogen | 6         | GK2.14.3 | WG-FE   | PG-UE  | EK1-BEDARF | 1       | A AG-LOHN1 | 1       | A AG-LOHN2 | 1       | A AG-LOHN3 | 1       | EK2-BEDARF | 2       | A AG-LOHN3 | 1       | A AG BOHR  | 1       | EK1-BEDARF | 3       | EK2-BEDARF | 1       | A AG DREH  | 1        |
      | BG7-STORNO  | Baugruppe für Storno7  | bedarfsbezogen | 6         | GK2.14.3 | WG-FE   | PG-UE  | A AG-LOHN1 | 1       | EK1-BEDARF | 1       | A AG-LOHN2 | 1       | A AG-LOHN3 | 1       | EK2-BEDARF | 2       | A AG-LOHN3 | 1       | A AG BOHR  | 1       | EK1-BEDARF | 3       | EK2-BEDARF | 1       | A AG DREH  | 1        |
      | BG8-STORNO  | Baugruppe für Storno8  | bedarfsbezogen | 6         | GK2.14.3 | WG-FE   | PG-UE  | EK1-BEDARF | 1       | EK2-BEDARF | 2       | A AG-LOHN1 | 1       |            |         |            |         |            |         |            |         |            |         |            |         |            |          |
      | BG9-STORNO  | Baugruppe für Storno9  | bedarfsbezogen | 6         | GK2.14.3 | WG-FE   | PG-UE  | EK1-BEDARF | 1       | A AG-LOHN1 | 1       | A AG-LOHN2 | 1       |            |         |            |         |            |         |            |         |            |         |            |         |            |          |
      | BG10-STORNO | Baugruppe für Storno10 | bedarfsbezogen | 6         | GK2.14.3 | WG-FE   | PG-UE  | EK1-BEDARF | 1       | A AG-LOHN1 | 1       | EK2-BEDARF | 1       | A AG-LOHN2 | 1       |            |         |            |         |            |         |            |         |            |         |            |          |
      | BG11-STORNO | Baugruppe für Storno11 | bedarfsbezogen | 6         | GK2.14.3 | WG-FE   | PG-UE  | EK1-BEDARF | 1       | A AG-LOHN1 | 1       | EK2-BEDARF | 1       | A AG-LOHN2 | 1       | EK1-BEDARF_RD | 1       | A AG-LOHN3 | 1       | EK2-BEDARF_RD | 1       | A AG-LOHN3 | 1       | EK3-BEDARF_RD | 1       | A AG-LOHN3 | 1        |

  # ## Scenarios autorm=ja ###
  Scenario: Konfiguration autorm=ja
    Given I open an editor "Konfiguration" from table "(Company):(Configuration)" with command "UPDATE" for record "0k"
    And I set fields
      | autorm | ja |
    And I save the current editor

  Scenario: Fall_1 Rueckmeldung mit Entnahme stornieren. Bebuchter Nachfolger. Nachfolger hat daduch eine zu hohe autom. gebuchte Menge, weil darueber nichts entnommen wurde.
    Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
    And I append rows
      | artikel    | mge | mfreig | bisuch  |
      | BG2-STORNO | 10  | ja     | FALL_1_ |
    And I press button "freig" to open a subeditor for "freigeben"
    And I close the current subeditor to switch back to the parent editor
    And I close the current editor
    # Rückmeldung auf alle Arbeitsscheine, RM1 und RM3 buchen Material, RM2 nicht
    Given I open an editor "RM_AS1-1" from table "(Workorder):(WorkOrders)" with command "DONE" for record "FALL_1_001"
    And I set field "sofort" to "ja"
    And I set field "gutmge" to "4" in row 1
    And I save the current editor
    Given I open an editor "RM_AS2-1" from table "(Workorder):(WorkOrders)" with command "DONE" for record "FALL_1_002"
    And I set field "sofort" to "ja"
    And I set field "gutmge" to "5" in row 1
    And I save the current editor
    Given I open an editor "RM_AS3-1" from table "(Workorder):(WorkOrders)" with command "DONE" for record "FALL_1_003"
    And I set field "sofort" to "ja"
    And I set field "gutmge" to "5" in row 1
    And I save the current editor
    # Storno RM1-1 und RM2-1 bringen Fehler, RM3-1 darf storniert werden.
    Then opening an editor from table "(Workorder):(CompletionConfirmations)" with command "REVERSAL" for record from editor "RM_AS1-1" throws the exception "9503"
    # beschriebener, zu pruefender Fall
    Then opening an editor from table "(Workorder):(CompletionConfirmations)" with command "REVERSAL" for record from editor "RM_AS2-1" throws the exception "9503"
    Given I switch the current editor to editor "RM_AS3-1" with command "REVERSAL"
    And I close the current editor
    # Betriebsauftrag löschen
    Given I open an editor "BA_FALL_1" from table "(Workorder):(WorkOrders)" with command "UPDATE" for record "FALL_1_000"
    And I respond with answer "JA" to the dialog with id "1483"
    And I set field "status" to "s"
    And I save the current editor

  Scenario: Fall_2 Rueckmeldung mit Entnahme stornieren. Kein bebuchter Nachfolger. Vorgaenger hat daduch eine zu hohe autom. gebuchte Menge, weil darueber nichts entnommen wurde.
    Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
    And I append rows
      | artikel    | mge | mfreig | bisuch  |
      | BG2-STORNO | 10  | ja     | FALL_2_ |
    And I press button "freig" to open a subeditor for "freigeben"
    And I close the current subeditor to switch back to the parent editor
    And I close the current editor
    # Rückmeldung auf alle Arbeitsscheine, RM1 und RM3 buchen Material, RM2 nicht
    Given I open an editor "RM_AS1-1" from table "(Workorder):(WorkOrders)" with command "DONE" for record "FALL_2_001"
    And I set field "sofort" to "ja"
    And I set field "gutmge" to "4" in row 1
    And I save the current editor
    Given I open an editor "RM_AS3-1" from table "(Workorder):(WorkOrders)" with command "DONE" for record "FALL_2_003"
    And I set field "sofort" to "ja"
    And I set field "gutmge" to "5" in row 1
    And I save the current editor
    Given I open an editor "RM_AS2-1" from table "(Workorder):(WorkOrders)" with command "DONE" for record "FALL_2_002"
    And I set field "sofort" to "ja"
    And I set field "gutmge" to "5" in row 1
    And I save the current editor
    # Storno RM1-1 und RM3-1 bringen Fehler, RM2-1 darf storniert werden
    Then opening an editor from table "(Workorder):(CompletionConfirmations)" with command "REVERSAL" for record from editor "RM_AS1-1" throws the exception "9503"
    # beschriebener, zu pruefender Fall
    Then opening an editor from table "(Workorder):(CompletionConfirmations)" with command "REVERSAL" for record from editor "RM_AS3-1" throws the exception "9503"
    Given I switch the current editor to editor "RM_AS2-1" with command "REVERSAL"
    And I close the current editor
    # Betriebsauftrag löschen
    Given I open an editor "BA_FALL_2" from table "(Workorder):(WorkOrders)" with command "UPDATE" for record "FALL_2_000"
    And I respond with answer "JA" to the dialog with id "1483"
    And I set field "status" to "s"
    And I save the current editor

  Scenario: Fall_3 Rueckmeldung ohne Entnahme stornieren. Keine bebuchten Nachfolger. AS hat daduch eine zu hohe autom. gebuchte Menge.
    Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
    And I append rows
      | artikel    | mge | mfreig | bisuch  |
      | BG2-STORNO | 10  | ja     | FALL_3_ |
    And I press button "freig" to open a subeditor for "freigeben"
    And I close the current subeditor to switch back to the parent editor
    And I close the current editor
    # Rückmeldung auf alle Arbeitsscheine, RM1 und RM3 buchen Material, RM2 nicht
    Given I open an editor "RM_AS1-1" from table "(Workorder):(WorkOrders)" with command "DONE" for record "FALL_3_001"
    And I set field "sofort" to "ja"
    And I set field "gutmge" to "4" in row 1
    And I save the current editor
    Given I open an editor "RM_AS2-1" from table "(Workorder):(WorkOrders)" with command "DONE" for record "FALL_3_002"
    And I set field "sofort" to "ja"
    And I set field "gutmge" to "2" in row 1
    And I save the current editor
    Given I open an editor "RM_AS2-2" from table "(Workorder):(WorkOrders)" with command "DONE" for record "FALL_3_002"
    And I set field "sofort" to "ja"
    And I set field "gutmge" to "2" in row 1
    And I save the current editor
    Given I open an editor "RM_AS2-3" from table "(Workorder):(WorkOrders)" with command "DONE" for record "FALL_3_002"
    And I set field "sofort" to "ja"
    And I set field "gutmge" to "2" in row 1
    And I save the current editor
    # Storno RM1-1, RM2-1 und RM2-2 bringen Fehler, RM2-3 darf storniert werden
    Then opening an editor from table "(Workorder):(CompletionConfirmations)" with command "REVERSAL" for record from editor "RM_AS1-1" throws the exception "9503"
    # beschriebener, zu pruefender Fall
    Then opening an editor from table "(Workorder):(CompletionConfirmations)" with command "REVERSAL" for record from editor "RM_AS2-1" throws the exception "9503"
    Then opening an editor from table "(Workorder):(CompletionConfirmations)" with command "REVERSAL" for record from editor "RM_AS2-2" throws the exception "9503"
    Given I switch the current editor to editor "RM_AS2-3" with command "REVERSAL"
    And I close the current editor
    # Betriebsauftrag löschen
    Given I open an editor "BA_FALL_3" from table "(Workorder):(WorkOrders)" with command "UPDATE" for record "FALL_3_000"
    And I respond with answer "JA" to the dialog with id "1483"
    And I set field "status" to "s"
    And I save the current editor

  Scenario: Fall_4 Rueckmeldung ohne Entnahme stornieren. Keine bebuchten Nachfolger. AS hat daduch eine zu hohe autom. gebuchte Menge.
    Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
    And I append rows
      | artikel    | mge | mfreig | bisuch  |
      | BG2-STORNO | 10  | ja     | FALL_4_ |
    And I press button "freig" to open a subeditor for "freigeben"
    And I close the current subeditor to switch back to the parent editor
    And I close the current editor
    # Rückmeldung auf alle Arbeitsscheine, RM1 und RM3 buchen Material, RM2 nicht
    Given I open an editor "RM_AS1-1" from table "(Workorder):(WorkOrders)" with command "DONE" for record "FALL_4_001"
    And I set field "sofort" to "ja"
    And I set field "gutmge" to "4" in row 1
    And I save the current editor
    Given I open an editor "RM_AS2-1" from table "(Workorder):(WorkOrders)" with command "DONE" for record "FALL_4_002"
    And I set field "sofort" to "ja"
    And I set field "gutmge" to "1" in row 1
    And I save the current editor
    Given I open an editor "RM_AS2-2" from table "(Workorder):(WorkOrders)" with command "DONE" for record "FALL_4_002"
    And I set field "sofort" to "ja"
    And I set field "gutmge" to "2" in row 1
    And I save the current editor
    Given I open an editor "RM_AS2-3" from table "(Workorder):(WorkOrders)" with command "DONE" for record "FALL_4_002"
    And I set field "sofort" to "ja"
    And I set field "gutmge" to "2" in row 1
    And I save the current editor
    # Storno RM1-1, RM2-1 und RM2-2 bringen Fehler, RM2-3 darf storniert werden
    Then opening an editor from table "(Workorder):(CompletionConfirmations)" with command "REVERSAL" for record from editor "RM_AS1-1" throws the exception "9503"
    # beschriebener, zu pruefender Fall
    Then opening an editor from table "(Workorder):(CompletionConfirmations)" with command "REVERSAL" for record from editor "RM_AS2-1" throws the exception "9503"
    Then opening an editor from table "(Workorder):(CompletionConfirmations)" with command "REVERSAL" for record from editor "RM_AS2-2" throws the exception "9503"
    Given I switch the current editor to editor "RM_AS2-3" with command "REVERSAL"
    And I close the current editor
    # Betriebsauftrag löschen
    Given I open an editor "BA_FALL_4" from table "(Workorder):(WorkOrders)" with command "UPDATE" for record "FALL_4_000"
    And I respond with answer "JA" to the dialog with id "1483"
    And I set field "status" to "s"
    And I save the current editor

  Scenario: Fall_5 Rueckmeldung mit Entnahme stornieren. Bebuchte Nachfolger ohne Entnahmen. AS hat daduch eine zu hohe autom. gebuchte Menge.
    Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
    And I append rows
      | artikel    | mge | mfreig | bisuch  |
      | BG2-STORNO | 10  | ja     | FALL_5_ |
    And I press button "freig" to open a subeditor for "freigeben"
    And I close the current subeditor to switch back to the parent editor
    And I close the current editor
    # Rückmeldung auf alle Arbeitsscheine, RM1 und RM3 buchen Material, RM2 nicht
    Given I open an editor "RM_AS1-1" from table "(Workorder):(WorkOrders)" with command "DONE" for record "FALL_5_001"
    And I set field "sofort" to "ja"
    And I set field "gutmge" to "2" in row 1
    And I save the current editor
    Given I open an editor "RM_AS2-1" from table "(Workorder):(WorkOrders)" with command "DONE" for record "FALL_5_002"
    And I set field "sofort" to "ja"
    And I set field "gutmge" to "3" in row 1
    And I save the current editor
    Given I open an editor "RM_AS3-1" from table "(Workorder):(WorkOrders)" with command "DONE" for record "FALL_5_003"
    And I set field "sofort" to "ja"
    And I set field "gutmge" to "3" in row 1
    And I save the current editor
    Given I open an editor "RM_AS4-1" from table "(Workorder):(WorkOrders)" with command "DONE" for record "FALL_5_004"
    And I set field "sofort" to "ja"
    And I set field "gutmge" to "3" in row 1
    And I save the current editor
    # Storno RM1-1 und RM2-1 bringen Fehler, RM3-1 und RM4-1 dürfen storniert werden
    Then opening an editor from table "(Workorder):(CompletionConfirmations)" with command "REVERSAL" for record from editor "RM_AS1-1" throws the exception "9503"
    # beschriebener, zu pruefender Fall
    Then opening an editor from table "(Workorder):(CompletionConfirmations)" with command "REVERSAL" for record from editor "RM_AS2-1" throws the exception "9503"
    Given I switch the current editor to editor "RM_AS3-1" with command "REVERSAL"
    And I close the current editor
    Given I switch the current editor to editor "RM_AS4-1" with command "REVERSAL"
    And I close the current editor
    # Betriebsauftrag löschen
    Given I open an editor "BA_FALL_5" from table "(Workorder):(WorkOrders)" with command "UPDATE" for record "FALL_5_000"
    And I respond with answer "JA" to the dialog with id "345"
    And I set field "status" to "s"
    And I save the current editor

  Scenario: Fall_6 Rueckmeldung mit Entnahme stornieren. Bebuchte Nachfolger ohne Entnahmen. AS hat daduch eine zu hohe autom. gebuchte Menge.
    Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
    And I append rows
      | artikel    | mge | mfreig | bisuch  |
      | BG2-STORNO | 10  | ja     | FALL_6_ |
    And I press button "freig" to open a subeditor for "freigeben"
    And I close the current subeditor to switch back to the parent editor
    And I close the current editor
    # Rückmeldung auf alle Arbeitsscheine, RM1 und RM3 buchen Material, RM2 nicht
    Given I open an editor "RM_AS1-1" from table "(Workorder):(WorkOrders)" with command "DONE" for record "FALL_6_001"
    And I set field "sofort" to "ja"
    And I set field "gutmge" to "2" in row 1
    And I save the current editor
    Given I open an editor "RM_AS3-1" from table "(Workorder):(WorkOrders)" with command "DONE" for record "FALL_6_003"
    And I set field "sofort" to "ja"
    And I set field "gutmge" to "3" in row 1
    And I save the current editor
    Given I open an editor "RM_AS2-1" from table "(Workorder):(WorkOrders)" with command "DONE" for record "FALL_6_002"
    And I set field "sofort" to "ja"
    And I set field "gutmge" to "3" in row 1
    And I save the current editor
    Given I open an editor "RM_AS4-1" from table "(Workorder):(WorkOrders)" with command "DONE" for record "FALL_6_004"
    And I set field "sofort" to "ja"
    And I set field "gutmge" to "3" in row 1
    And I save the current editor
    # Storno RM1-1 und RM3-1 bringen Fehler, RM2-1 und RM4-1 dürfen storniert werden
    Then opening an editor from table "(Workorder):(CompletionConfirmations)" with command "REVERSAL" for record from editor "RM_AS1-1" throws the exception "9503"
    # beschriebener, zu pruefender Fall
    Then opening an editor from table "(Workorder):(CompletionConfirmations)" with command "REVERSAL" for record from editor "RM_AS3-1" throws the exception "9503"
    Given I switch the current editor to editor "RM_AS2-1" with command "REVERSAL"
    And I close the current editor
    Given I switch the current editor to editor "RM_AS4-1" with command "REVERSAL"
    And I close the current editor
    # Betriebsauftrag löschen
    Given I open an editor "BA_FALL_6" from table "(Workorder):(WorkOrders)" with command "UPDATE" for record "FALL_6_000"
    And I respond with answer "JA" to the dialog with id "345"
    And I set field "status" to "s"
    And I save the current editor

  Scenario: Fall_7 Rueckmeldung mit Entnahme stornieren. Bebuchte Nachfolger ohne Entnahmen. AS hat keine zu hohe autom. gebuchte Menge.
    Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
    And I append rows
      | artikel    | mge | mfreig | bisuch  |
      | BG2-STORNO | 10  | ja     | FALL_7_ |
    And I press button "freig" to open a subeditor for "freigeben"
    And I close the current subeditor to switch back to the parent editor
    And I close the current editor
    # Rückmeldung auf alle Arbeitsscheine, RM1 und RM3 buchen Material, RM2 nicht
    Given I open an editor "RM_AS1-1" from table "(Workorder):(WorkOrders)" with command "DONE" for record "FALL_7_001"
    And I set field "sofort" to "ja"
    And I set field "gutmge" to "4" in row 1
    And I save the current editor
    Given I open an editor "RM_AS1-2" from table "(Workorder):(WorkOrders)" with command "DONE" for record "FALL_7_001"
    And I set field "sofort" to "ja"
    And I set field "gutmge" to "4" in row 1
    And I save the current editor
    Given I open an editor "RM_AS2-1" from table "(Workorder):(WorkOrders)" with command "DONE" for record "FALL_7_002"
    And I set field "sofort" to "ja"
    And I set field "gutmge" to "4" in row 1
    And I save the current editor
    # Alle Rueckmeldungen duerfen stroniert werden
    Given I switch the current editor to editor "RM_AS1-1" with command "REVERSAL"
    And I close the current editor
    Given I switch the current editor to editor "RM_AS1-2" with command "REVERSAL"
    And I close the current editor
    Given I switch the current editor to editor "RM_AS2-1" with command "REVERSAL"
    And I close the current editor
    # Betriebsauftrag löschen
    Given I open an editor "BA_FALL_7" from table "(Workorder):(WorkOrders)" with command "UPDATE" for record "FALL_7_000"
    And I respond with answer "JA" to the dialog with id "1483"
    And I set field "status" to "s"
    And I save the current editor

  Scenario: Fall_8 Rueckmeldung mit Entnahme stornieren. Bebuchte Nachfolger ohne Entnahmen. AS hat keine zu hohe autom. gebuchte Menge.
    Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
    And I append rows
      | artikel    | mge | mfreig | bisuch  |
      | BG2-STORNO | 10  | ja     | FALL_8_ |
    And I press button "freig" to open a subeditor for "freigeben"
    And I close the current subeditor to switch back to the parent editor
    And I close the current editor
    # Rückmeldung auf alle Arbeitsscheine, RM1 und RM3 buchen Material, RM2 nicht
    Given I open an editor "RM_AS1-1" from table "(Workorder):(WorkOrders)" with command "DONE" for record "FALL_8_001"
    And I set field "sofort" to "ja"
    And I set field "gutmge" to "4" in row 1
    And I save the current editor
    Given I open an editor "RM_AS2-1" from table "(Workorder):(WorkOrders)" with command "DONE" for record "FALL_8_002"
    And I set field "sofort" to "ja"
    And I set field "gutmge" to "2" in row 1
    And I save the current editor
    Given I open an editor "RM_AS2-2" from table "(Workorder):(WorkOrders)" with command "DONE" for record "FALL_8_002"
    And I set field "sofort" to "ja"
    And I set field "gutmge" to "2" in row 1
    And I save the current editor
    Given I open an editor "RM_AS2-3" from table "(Workorder):(WorkOrders)" with command "DONE" for record "FALL_8_002"
    And I set field "sofort" to "ja"
    And I set field "gutmge" to "2" in row 1
    And I save the current editor
    Given I open an editor "RM_AS3-1" from table "(Workorder):(WorkOrders)" with command "DONE" for record "FALL_8_003"
    And I set field "sofort" to "ja"
    And I set field "gutmge" to "4" in row 1
    And I save the current editor
    # Storno RM1-1, RM2-1 und RM2-2 bringen Fehler, RM2-3 und RM3-1 duerfen storniert werden
    Then opening an editor from table "(Workorder):(CompletionConfirmations)" with command "REVERSAL" for record from editor "RM_AS1-1" throws the exception "9503"
    Then opening an editor from table "(Workorder):(CompletionConfirmations)" with command "REVERSAL" for record from editor "RM_AS2-1" throws the exception "9503"
    Then opening an editor from table "(Workorder):(CompletionConfirmations)" with command "REVERSAL" for record from editor "RM_AS2-2" throws the exception "9503"
    Given I switch the current editor to editor "RM_AS2-3" with command "REVERSAL"
    And I close the current editor
    Given I switch the current editor to editor "RM_AS3-1" with command "REVERSAL"
    And I close the current editor
    # Betriebsauftrag löschen
    Given I open an editor "BA_FALL_8" from table "(Workorder):(WorkOrders)" with command "UPDATE" for record "FALL_8_000"
    And I respond with answer "JA" to the dialog with id "1483"
    And I set field "status" to "s"
    And I save the current editor

  Scenario: Fall_9A Rueckbau mit Entnahme auf 2. AG stornieren (entspr. Rueckmeldung). Rückbau müsste auch 1. AG bebuchen, hat aber nur eine Entnahme für den 2. AG in der Tabelle.
    Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
    And I append rows
      | artikel    | mge | mfreig | bisuch   |
      | BG5-STORNO | 10  | ja     | FALL_9A_ |
    And I press button "freig" to open a subeditor for "freigeben"
    And I close the current subeditor to switch back to the parent editor
    And I close the current editor
    # Rückmeldung auf alle Arbeitsscheine, RM1 und RM3 buchen Material, RM2 nicht
    Given I open an editor "RM_AS1-1" from table "(Workorder):(WorkOrders)" with command "DONE" for record "FALL_9A_001"
    And I set field "sofort" to "ja"
    And I set field "gutmge" to "5" in row 1
    And I save the current editor
    Given I open an editor "RM_AS2-1" from table "(Workorder):(WorkOrders)" with command "DONE" for record "FALL_9A_002"
    And I set field "sofort" to "ja"
    And I set field "gutmge" to "5" in row 1
    And I save the current editor
    Given I open an editor "RB_AS2-1" from table "(Workorder):(WorkOrders)" with command "RETURN" for record "FALL_9A_002"
    And I set field "sofort" to "ja"
    And I set field "gutmge" to "-1" in row 1
    And I save the current editor
    Given I open an editor "RB_AS1-1" from table "(Workorder):(WorkOrders)" with command "RETURN" for record "FALL_9A_001"
    And I set field "sofort" to "ja"
    And I set field "gutmge" to "-5" in row 1
    And I save the current editor
    # Storno RB_AS2-1 bringen Fehler, da in der RM nur die Zeile für AG2 steht. Da retrograd gebucht wird, muss aber auch von AG! Material entnommen werden.
    Then opening an editor from table "(Workorder):(CompletionConfirmations)" with command "REVERSAL" for record from editor "RB_AS2-1" throws the exception "9503"
    # Betriebsauftrag löschen
    Given I open an editor "BA_FALL_9" from table "(Workorder):(WorkOrders)" with command "UPDATE" for record "FALL_9A_000"
    And I respond with answer "JA" to the dialog with id "1483"
    And I set field "status" to "s"
    And I save the current editor

  Scenario: Fall_9B Rueckcbau mit Entnahme auf letzten AG stornieren.
    Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
    And I append rows
      | artikel    | mge | mfreig | bisuch   |
      | BG4-STORNO | 10  | ja     | FALL_9B_ |
    And I press button "freig" to open a subeditor for "freigeben"
    And I close the current subeditor to switch back to the parent editor
    And I close the current editor
    # Rückmeldung auf alle Arbeitsscheine, RM1 und RM3 buchen Material, RM2 nicht
    Given I open an editor "RM_AS3-1" from table "(Workorder):(WorkOrders)" with command "DONE" for record "FALL_9B_003"
    And I set field "sofort" to "ja"
    And I set field "gutmge" to "5" in row 1
    And I save the current editor
    Given I open an editor "RB_AS3-1" from table "(Workorder):(WorkOrders)" with command "RETURN" for record "FALL_9B_003"
    And I set field "sofort" to "ja"
    And I set field "gutmge" to "-1" in row 1
    And I save the current editor
    Given I open an editor "RB_AS3-2" from table "(Workorder):(WorkOrders)" with command "RETURN" for record "FALL_9B_003"
    And I set field "sofort" to "ja"
    And I set field "gutmge" to "-3" in row 1
    And I save the current editor
    # Storno RB_AS3-1 bringen Fehler ist erlaubt
    Given I switch the current editor to editor "RB_AS3-1" with command "REVERSAL"
    And I save the current editor
    Given I switch the current editor to editor "RB_AS3-2" with command "REVERSAL"
    And I save the current editor
    # Betriebsauftrag löschen
    Given I open an editor "BA_FALL_9B" from table "(Workorder):(WorkOrders)" with command "UPDATE" for record "FALL_9B_000"
    And I respond with answer "JA" to the dialog with id "345"
    And I set field "status" to "s"
    And I save the current editor

  Scenario: Fall_10A Rueckmeldung mit Entnahme stornieren. Unbebuchter Vorgaenger.
    Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
    And I append rows
      | artikel    | mge | mfreig | bisuch    |
      | BG2-STORNO | 10  | ja     | FALL_10A_ |
    And I press button "freig" to open a subeditor for "freigeben"
    And I close the current subeditor to switch back to the parent editor
    And I close the current editor
    # Rückmeldung auf Arbeitsschein, RM1 und RM3 buchen Material, RM2 wird nicht bebucht.
    Given I open an editor "RM_AS1-1" from table "(Workorder):(WorkOrders)" with command "DONE" for record "FALL_10A_001"
    And I set field "sofort" to "ja"
    And I set field "gutmge" to "4" in row 1
    And I save the current editor
    Given I open an editor "RM_AS3-1" from table "(Workorder):(WorkOrders)" with command "DONE" for record "FALL_10A_003"
    And I set field "sofort" to "ja"
    And I set field "gutmge" to "4" in row 1
    And I save the current editor
    # Storno RM_AS3-1 darf storniert werden.
    Given I switch the current editor to editor "RM_AS3-1" with command "REVERSAL"
    And I save the current editor
    # Betriebsauftrag löschen
    Given I open an editor "BA_FALL_10A" from table "(Workorder):(WorkOrders)" with command "UPDATE" for record "FALL_10A_000"
    And I respond with answer "JA" to the dialog with id "1483"
    And I set field "status" to "s"
    And I save the current editor

  Scenario: Fall_10B Rueckmeldung ohne Entnahme stornieren. Unbebuchter Nachfolger.
    Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
    And I append rows
      | artikel    | mge | mfreig | bisuch    |
      | BG2-STORNO | 10  | ja     | FALL_10B_ |
    And I press button "freig" to open a subeditor for "freigeben"
    And I close the current subeditor to switch back to the parent editor
    And I close the current editor
    # Rückmeldung auf Arbeitsschein, RM2 bucht Material, RM1 nicht
    Given I open an editor "RM_AS2-1" from table "(Workorder):(WorkOrders)" with command "DONE" for record "FALL_10B_002"
    And I set field "sofort" to "ja"
    And I set field "gutmge" to "14" in row 1
    And I save the current editor
    Given I open an editor "RM_AS1-1" from table "(Workorder):(WorkOrders)" with command "DONE" for record "FALL_10B_001"
    And I set field "sofort" to "ja"
    And I set field "gutmge" to "4" in row 1
    And I save the current editor
    # Storno RM_AS1-1 darf storniert werden.
    Given I switch the current editor to editor "RM_AS1-1" with command "REVERSAL"
    And I save the current editor
    # Storno RM_AS2-1 darf jetzt auch storniert werden.
    Given I switch the current editor to editor "RM_AS2-1" with command "REVERSAL"
    And I save the current editor
    # Betriebsauftrag löschen
    Given I open an editor "BA_FALL_10B" from table "(Workorder):(WorkOrders)" with command "UPDATE" for record "FALL_10B_000"
    And I respond with answer "JA" to the dialog with id "345"
    And I set field "status" to "s"
    And I save the current editor

  # ---------------------------------------------------------------------------------
  # Storno auf STL mit mehreren Baugruppen
  # ---------------------------------------------------------------------------------
  Scenario: Fall_10C Rueckmeldung mit Entnahme stornieren. Keine Entnahme auf Vorgaenger AS. STL: TE - AG - TE -AG -AG
    Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
    And I append rows
      | artikel    | mge | mfreig | bisuch    |
      | BG3-STORNO | 10  | ja     | FALL_101_ |
    And I press button "freig" to open a subeditor for "freigeben"
    And I close the current subeditor to switch back to the parent editor
    And I close the current editor
    # Rückmeldung auf alle Arbeitsscheine, RM1 und RM3 buchen Material, RM2 nicht
    Given I open an editor "RM_AS1-1" from table "(Workorder):(WorkOrders)" with command "DONE" for record "FALL_101_001"
    And I set field "sofort" to "ja"
    And I set field "gutmge" to "4" in row 1
    And I save the current editor
    Given I open an editor "RM_AS2-1" from table "(Workorder):(WorkOrders)" with command "DONE" for record "FALL_101_002"
    And I set field "sofort" to "ja"
    And I set field "gutmge" to "4" in row 1
    And I save the current editor
    # Storno RM1-1 bringt Fehler, RM2-1 darf storniert werden
    Then opening an editor from table "(Workorder):(CompletionConfirmations)" with command "REVERSAL" for record from editor "RM_AS1-1" throws the exception "9503"
    Given I switch the current editor to editor "RM_AS2-1" with command "REVERSAL"
    And I close the current editor
    # Betriebsauftrag löschen
    Given I open an editor "BA_FALL_101" from table "(Workorder):(WorkOrders)" with command "UPDATE" for record "FALL_101_000"
    And I respond with answer "JA" to the dialog with id "1483"
    And I set field "status" to "s"
    And I save the current editor

  Scenario: Fall_11A wie Fall_10C, aber mit geaenderter STL: TE- AG - AG - TE - AG
    Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
    And I append rows
      | artikel    | mge | mfreig | bisuch    |
      | BG4-STORNO | 10  | ja     | FALL_11A_ |
    And I press button "freig" to open a subeditor for "freigeben"
    And I close the current subeditor to switch back to the parent editor
    And I close the current editor
    # Rückmeldung auf alle Arbeitsscheine, RM1 und RM3 buchen Material, RM2 nicht
    Given I open an editor "RM_AS1-1" from table "(Workorder):(WorkOrders)" with command "DONE" for record "FALL_11A_001"
    And I set field "sofort" to "ja"
    And I set field "gutmge" to "4" in row 1
    And I save the current editor
    Given I open an editor "RM_AS3-1" from table "(Workorder):(WorkOrders)" with command "DONE" for record "FALL_11A_003"
    And I set field "sofort" to "ja"
    And I set field "gutmge" to "4" in row 1
    And I save the current editor
    # Storno RM1-1 bringt Fehler, RM2-1 darf storniert werden
    Then opening an editor from table "(Workorder):(CompletionConfirmations)" with command "REVERSAL" for record from editor "RM_AS1-1" throws the exception "9503"
    Given I switch the current editor to editor "RM_AS3-1" with command "REVERSAL"
    And I close the current editor
    # Betriebsauftrag löschen
    Given I open an editor "BA_FALL_101" from table "(Workorder):(WorkOrders)" with command "UPDATE" for record "FALL_11A_000"
    And I respond with answer "JA" to the dialog with id "345"
    And I set field "status" to "s"
    And I save the current editor

  Scenario: Fall_11B: Test auf Pruefung der Vorgaenger. STL: TE- AG - TE - AG - TE - AG - TE - AG - TE - AG
    Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
    And I append rows
      | artikel    | mge | mfreig | bisuch    |
      | BG5-STORNO | 10  | ja     | FALL_11B_ |
    And I press button "freig" to open a subeditor for "freigeben"
    And I close the current subeditor to switch back to the parent editor
    And I close the current editor
    # Rückmeldung auf alle Arbeitsscheine, RM1 und RM3 buchen Material, RM2 nicht
    Given I open an editor "RM_AS1-1" from table "(Workorder):(WorkOrders)" with command "DONE" for record "FALL_11B_001"
    And I set field "sofort" to "ja"
    And I set field "gutmge" to "4" in row 1
    And I save the current editor
    Given I open an editor "RM_AS4-1" from table "(Workorder):(WorkOrders)" with command "DONE" for record "FALL_11B_004"
    And I set field "sofort" to "ja"
    And I set field "gutmge" to "5" in row 1
    And I save the current editor
    # Storno RM1-1 bringt Fehler, RM2-1 darf storniert werden
    Then opening an editor from table "(Workorder):(CompletionConfirmations)" with command "REVERSAL" for record from editor "RM_AS1-1" throws the exception "9503"
    Given I switch the current editor to editor "RM_AS4-1" with command "REVERSAL"
    And I close the current editor
    # Betriebsauftrag löschen
    Given I open an editor "BA_FALL_102" from table "(Workorder):(WorkOrders)" with command "UPDATE" for record "FALL_11B_000"
    And I respond with answer "JA" to the dialog with id "1483"
    And I set field "status" to "s"
    And I save the current editor

  Scenario: Fall_12: Test auf Pruefung der Vorgaenger mit amge und pverlust. STL: TE- AG - AG - AG - TE - AG - AG - TE - TE - AG
    Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
    And I append rows
      | artikel    | mge | mfreig | bisuch   |
      | BG6-STORNO | 10  | ja     | FALL_11_ |
    And I press button "freig" to open a subeditor for "freigeben"
    And I close the current subeditor to switch back to the parent editor
    And I close the current editor
    # Offene Mengen Material und Arbeitsgänge prüfen
    Given I open an editor "Betriebsauftrag" from table "(Workorder):(WorkOrders)" with command "UPDATE" for record "FALL_11_000"
    And I press button "absteig" to open a subeditor for "AFL"
    And I set field "amge" to "1" in row 1
    And I set field "pverlust" to "1" in row 1
    And I set field "pverlust" to "2" in row 2
    And I set field "pverlust" to "3" in row 3
    And I set field "pverlust" to "4" in row 4
    And I set field "amge" to "5" in row 5
    And I set field "pverlust" to "5" in row 5
    And I set field "pverlust" to "6" in row 6
    And I set field "pverlust" to "7" in row 7
    And I set field "amge" to "8" in row 8
    And I set field "pverlust" to "8" in row 8
    And I set field "amge" to "9" in row 9
    And I set field "pverlust" to "9" in row 9
    And I set field "pverlust" to "10" in row 10
    And I save the current editor
    And I switch the current editor to editor "Betriebsauftrag"
    And I save the current editor
    # Rückmeldung auf alle Arbeitsscheine
    Given I open an editor "RM_AS1" from table "(Workorder):(WorkOrders)" with command "DONE" for record "FALL_11_001"
    And I set field "sofort" to "ja"
    And I set field "gutmge" to "1" in row 1
    And I save the current editor
    Given I open an editor "RM_AS2" from table "(Workorder):(WorkOrders)" with command "DONE" for record "FALL_11_002"
    And I set field "sofort" to "ja"
    And I set field "gutmge" to "2" in row 1
    And I save the current editor
    Given I open an editor "RM_AS3" from table "(Workorder):(WorkOrders)" with command "DONE" for record "FALL_11_003"
    And I set field "sofort" to "ja"
    And I set field "gutmge" to "3" in row 1
    And I save the current editor
    Given I open an editor "RM_AS4" from table "(Workorder):(WorkOrders)" with command "DONE" for record "FALL_11_004"
    And I set field "sofort" to "ja"
    And I set field "gutmge" to "4" in row 1
    And I save the current editor
    Given I open an editor "RM_AS5" from table "(Workorder):(WorkOrders)" with command "DONE" for record "FALL_11_005"
    And I set field "sofort" to "ja"
    And I set field "gutmge" to "5" in row 1
    And I save the current editor
    Given I open an editor "RM_AS6" from table "(Workorder):(WorkOrders)" with command "DONE" for record "FALL_11_006"
    And I set field "sofort" to "ja"
    And I set field "gutmge" to "6" in row 1
    And I save the current editor
    # Storno RM-AS6 bis RM-AS1 darf wieder storniert werden
    Given I switch the current editor to editor "RM_AS6" with command "REVERSAL"
    And I save the current editor
    Given I switch the current editor to editor "RM_AS5" with command "REVERSAL"
    And I save the current editor
    Given I switch the current editor to editor "RM_AS4" with command "REVERSAL"
    And I save the current editor
    Given I switch the current editor to editor "RM_AS3" with command "REVERSAL"
    And I save the current editor
    Given I switch the current editor to editor "RM_AS2" with command "REVERSAL"
    And I save the current editor
    Given I switch the current editor to editor "RM_AS1" with command "REVERSAL"
    And I save the current editor
    # Betriebsauftrag löschen
    Given I open an editor "BA_FALL_11" from table "(Workorder):(WorkOrders)" with command "UPDATE" for record "FALL_11_000"
    And I respond with answer "JA" to the dialog with id "345"
    And I set field "status" to "s"
    And I save the current editor


  Scenario: Fall_13: Test auf Pruefung der Vorgaenger Entnahmen. STL: TE- AG - TE - AG
    Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
    And I append rows
      | artikel     | mge | mfreig | bisuch   |
      | BG10-STORNO | 60  | ja     | FALL_13_ |
    And I press button "freig" to open a subeditor for "freigeben"
    And I close the current subeditor to switch back to the parent editor
    And I close the current editor
    # Rückmeldung auf alle Arbeitsscheine
    Given I open an editor "RM_AS1-1" from table "(Workorder):(WorkOrders)" with command "DONE" for record "FALL_13_001"
    And I set field "sofort" to "ja"
    And I set field "gutmge" to "20" in row 1
    And I save the current editor
    Given I open an editor "RM_AS1-2" from table "(Workorder):(WorkOrders)" with command "DONE" for record "FALL_13_001"
    And I set field "sofort" to "ja"
    And I set field "gutmge" to "25" in row 1
    And I save the current editor
    Given I open an editor "RM_AS2-1" from table "(Workorder):(WorkOrders)" with command "DONE" for record "FALL_13_002"
    And I set field "sofort" to "ja"
    And I set field "gutmge" to "20" in row 1
    And I save the current editor
    Given I open an editor "RM_AS2-2" from table "(Workorder):(WorkOrders)" with command "DONE" for record "FALL_13_002"
    And I set field "sofort" to "ja"
    And I set field "gutmge" to "35" in row 1
    And I save the current editor
    # Storno RM_AS2-1 bringt Fehler, RM_AS2-2 darf storniert werden
    Then opening an editor from table "(Workorder):(CompletionConfirmations)" with command "REVERSAL" for record from editor "RM_AS2-1" throws the exception "9503"
    Given I switch the current editor to editor "RM_AS2-2" with command "REVERSAL"
    And I close the current editor
    # Betriebsauftrag löschen
    Given I open an editor "BA_FALL_13" from table "(Workorder):(WorkOrders)" with command "UPDATE" for record "FALL_13_000"
    And I respond with answer "JA" to the dialog with id "345"
    And I set field "status" to "s"
    And I save the current editor


  Scenario: Fall_14: Fertigungsvorschlag fuer BG11-STORNO mit Menge 100 anlegen und freigeben
    Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
    And I append rows
      | artikel     | mge | mfreig | bisuch |
      | BG11-STORNO | 100 | ja     | RUND_  |
    And I press button "freig" to open a subeditor for "freigeben"
    And I close the current subeditor to switch back to the parent editor
    And I close the current editor

    # Rueckmeldung fuer jeden der 5 Arbeitsgaenge erstellen
    # Rueckmeldung auf Arbeitsschein 1 (A AG-LOHN1)
    Given I open an editor "RM_AS1" from table "(Workorder):(WorkOrders)" with command "DONE" for record "RUND_001"
    And I set field "sofort" to "ja"
    And I set field "gutmge" to "10" in row 1
    And I save the current editor
    # Rueckmeldung auf Arbeitsschein 2 (A AG-LOHN2)
    Given I open an editor "RM_AS2" from table "(Workorder):(WorkOrders)" with command "DONE" for record "RUND_002"
    And I set field "sofort" to "ja"
    And I set field "gutmge" to "20" in row 1
    And I save the current editor
    # Rueckmeldung auf Arbeitsschein 3 (A AG-LOHN3, 1. Vorkommen)
    Given I open an editor "RM_AS3" from table "(Workorder):(WorkOrders)" with command "DONE" for record "RUND_003"
    And I set field "sofort" to "ja"
    And I set field "gutmge" to "30" in row 1
    And I save the current editor
    # Rueckmeldung auf Arbeitsschein 4 (A AG-LOHN3, 2. Vorkommen)
    Given I open an editor "RM_AS4" from table "(Workorder):(WorkOrders)" with command "DONE" for record "RUND_004"
    And I set field "sofort" to "ja"
    And I set field "gutmge" to "40" in row 1
    And I save the current editor
    # Rueckmeldung auf Arbeitsschein 5 (A AG-LOHN3, 3. Vorkommen)
    Given I open an editor "RM_AS5" from table "(Workorder):(WorkOrders)" with command "DONE" for record "RUND_005"
    And I set field "sofort" to "ja"
    And I set field "gutmge" to "50" in row 1
    And I save the current editor

    # Rueckmeldungen in umgekehrter Reihenfolge stornieren (AS5 -> AS4 -> AS3 -> AS2 -> AS1)
    # Storno Rueckmeldung Arbeitsschein 5 (letzter Arbeitsgang zuerst)
    Given I switch the current editor to editor "RM_AS5" with command "REVERSAL"
    And I save the current editor
    # Storno Rueckmeldung Arbeitsschein 4
    Given I switch the current editor to editor "RM_AS4" with command "REVERSAL"
    And I save the current editor
    # Storno Rueckmeldung Arbeitsschein 3
    Given I switch the current editor to editor "RM_AS3" with command "REVERSAL"
    And I save the current editor
    # Storno Rueckmeldung Arbeitsschein 2
    Given I switch the current editor to editor "RM_AS2" with command "REVERSAL"
    And I save the current editor
    # Storno Rueckmeldung Arbeitsschein 1 (erster Arbeitsgang zuletzt)
    Given I switch the current editor to editor "RM_AS1" with command "REVERSAL"
    And I save the current editor


  Scenario: 01 Rueckmeldung darf nicht storniert werden, wenn Gutmenge Folgearbeitsgänge größer/gleich Stornomenge, autorm=ja
    Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
    And I append rows
      | artikel   | mge | mfreig | bisuch |
      | BG-STORNO | 10  | ja     | HINW1_ |
    And I press button "freig" to open a subeditor for "freigeben"
    And I close the current subeditor to switch back to the parent editor
    And I close the current editor
    # Rückmeldung auf Arbeitsscheine 1 und 3, RM1 und RM2 buchen Material, RM3 nicht
    Given I open an editor "RM_AS1-1" from table "(Workorder):(WorkOrders)" with command "DONE" for record "HINW1_001"
    And I set field "sofort" to "ja"
    And I set field "gutmge" to "3" in row 1
    And I save the current editor
    Given I open an editor "RM_AS1-2" from table "(Workorder):(WorkOrders)" with command "DONE" for record "HINW1_001"
    And I set field "sofort" to "ja"
    And I set field "gutmge" to "2" in row 1
    And I save the current editor
    Given I open an editor "RM_AS3-1" from table "(Workorder):(WorkOrders)" with command "DONE" for record "HINW1_003"
    And I set field "sofort" to "ja"
    And I set field "gutmge" to "4" in row 1
    And I save the current editor
    # Storno RM_AS1-1 und RM_AS1-2 bringen Fehler, RM_AS3-1 bringt keinen Fehler
    Then opening an editor from table "(Workorder):(CompletionConfirmations)" with command "REVERSAL" for record from editor "RM_AS1-1" throws the exception "9503"
    Then opening an editor from table "(Workorder):(CompletionConfirmations)" with command "REVERSAL" for record from editor "RM_AS1-2" throws the exception "9503"
    Given I switch the current editor to editor "RM_AS3-1" with command "REVERSAL"
    And I close the current editor
    # Betriebsauftrag löschen
    Given I open an editor "BA_HINW1" from table "(Workorder):(WorkOrders)" with command "UPDATE" for record "HINW1_000"
    And I respond with answer "JA" to the dialog with id "1483"
    And I set field "status" to "s"
    And I save the current editor

  Scenario: 02 Arbeitsgang darf nicht storniert werden, wenn Gutmenge Folgearbeitsgänge größer/gleich Stornomenge, Rückmeldung auf BA, autorm=ja
    Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
    And I append rows
      | artikel   | mge | mfreig | bisuch |
      | BG-STORNO | 10  | ja     | HINW2_ |
    And I press button "freig" to open a subeditor for "freigeben"
    And I close the current subeditor to switch back to the parent editor
    And I close the current editor
    # Rückmeldung auf ersten und zweiten Arbeitsschein, Rückmeldung auf BA
    Given I open an editor "RM_AS1-1" from table "(Workorder):(WorkOrders)" with command "DONE" for record "HINW2_001"
    And I set field "sofort" to "ja"
    And I set field "gutmge" to "2" in row 1
    And I save the current editor
    Given I open an editor "RM_AS2-1" from table "(Workorder):(WorkOrders)" with command "DONE" for record "HINW2_002"
    And I set field "sofort" to "ja"
    And I set field "gutmge" to "1" in row 1
    And I save the current editor
    Given I open an editor "RM_BA-1" from table "(Workorder):(WorkOrders)" with command "DONE" for record "HINW2_000"
    And I set field "sofort" to "ja"
    And I set field "mgr" to "103"
    And I set field "gutmge" to "3" in row 1
    And I save the current editor
    # Storno RM1 bringt Fehler
    Then opening an editor from table "(Workorder):(CompletionConfirmations)" with command "REVERSAL" for record from editor "RM_AS1-1" throws the exception "9503"
    # Betriebsauftrag löschen
    Given I open an editor "BA_HINW2" from table "(Workorder):(WorkOrders)" with command "UPDATE" for record "HINW2_000"
    And I respond with answer "JA" to the dialog with id "345"
    And I set field "status" to "s"
    And I save the current editor

  Scenario: 03 Arbeitsgang darf storniert werden, wenn Gutmenge Folgearbeitsgänge kleiner Stornomenge, autorm=ja
    Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
    And I append rows
      | artikel   | mge | mfreig | bisuch |
      | BG-STORNO | 10  | ja     | HINW3_ |
    And I press button "freig" to open a subeditor for "freigeben"
    And I close the current subeditor to switch back to the parent editor
    And I close the current editor
    # Rückmeldung auf ersten AS, zwei Rückmeldungen auf zweiten AS, eine Rückmeldung auf dritten AS
    Given I open an editor "RM_AS1-1" from table "(Workorder):(WorkOrders)" with command "DONE" for record "HINW3_001"
    And I set field "sofort" to "ja"
    And I set field "gutmge" to "4" in row 1
    And I save the current editor
    Given I open an editor "RM_AS2-1" from table "(Workorder):(WorkOrders)" with command "DONE" for record "HINW3_002"
    And I set field "sofort" to "ja"
    And I set field "gutmge" to "2" in row 1
    And I save the current editor
    Given I open an editor "RM_AS2-2" from table "(Workorder):(WorkOrders)" with command "DONE" for record "HINW3_002"
    And I set field "sofort" to "ja"
    And I set field "gutmge" to "2" in row 1
    And I save the current editor
    Given I open an editor "RM_AS3-1" from table "(Workorder):(WorkOrders)" with command "DONE" for record "HINW3_003"
    And I set field "sofort" to "ja"
    And I set field "gutmge" to "2" in row 1
    And I save the current editor
    # Storno RM1 bringt Fehler, da gebuchte Menge < Stornomenge
    Then opening an editor from table "(Workorder):(CompletionConfirmations)" with command "REVERSAL" for record from editor "RM_AS1-1" throws the exception "9503"
    # Storno RM2_1 oder RM2_2 wäre möglich, da gebuchte Menge > Stornomenge, aber da nicht bekannt ist, ob auf den AS tatsächlich Menge entnommen wurde, geht es nicht!
    Then opening an editor from table "(Workorder):(CompletionConfirmations)" with command "REVERSAL" for record from editor "RM_AS2-1" throws the exception "9503"
    Then opening an editor from table "(Workorder):(CompletionConfirmations)" with command "REVERSAL" for record from editor "RM_AS2-2" throws the exception "9503"
    # Storno RM3_1 ist möglich, da letzte Buchung
    Given I switch the current editor to editor "RM_AS3-1" with command "REVERSAL"
    And I save the current editor
    # Betriebsauftrag löschen
    Given I open an editor "BA_HINW3" from table "(Workorder):(WorkOrders)" with command "UPDATE" for record "HINW3_000"
    And I respond with answer "JA" to the dialog with id "1483"
    And I set field "status" to "s"
    And I save the current editor

  Scenario: 04 Arbeitsgang darf storniert werden, wenn Gutmenge Folgearbeitsgänge kleiner Stornomenge, keine Buchung auf AS1, autorm=ja
    Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
    And I append rows
      | artikel   | mge | mfreig | bisuch |
      | BG-STORNO | 10  | ja     | HINW4_ |
    And I press button "freig" to open a subeditor for "freigeben"
    And I close the current subeditor to switch back to the parent editor
    And I close the current editor
    # Teilrückmeldungen auf zweiten Arbeitsschein und Rückmeldung auf dritten Arbeitsschein, Materialbuchung durch Rückmeldung auf letzten AG
    Given I open an editor "RM_AS2-1" from table "(Workorder):(WorkOrders)" with command "DONE" for record "HINW4_002"
    And I set field "sofort" to "ja"
    And I set field "gutmge" to "1" in row 1
    And I save the current editor
    Given I open an editor "RM_AS2-2" from table "(Workorder):(WorkOrders)" with command "DONE" for record "HINW4_002"
    And I set field "sofort" to "ja"
    And I set field "gutmge" to "2" in row 1
    And I save the current editor
    Given I open an editor "RM_AS2-3" from table "(Workorder):(WorkOrders)" with command "DONE" for record "HINW4_002"
    And I set field "sofort" to "ja"
    And I set field "gutmge" to "3" in row 1
    And I save the current editor
    Given I open an editor "RM_AS3-1" from table "(Workorder):(WorkOrders)" with command "DONE" for record "HINW4_003"
    And I set field "sofort" to "ja"
    And I set field "gutmge" to "4" in row 1
    And I save the current editor
    # Storno RM_AS2-1 möglich, da gebuchte Menge > Stornomenge
    Given I switch the current editor to editor "RM_AS2-1" with command "REVERSAL"
    And I close the current editor
    # Storno RM_AS2-2 möglich, da gebuchte Menge > Stornomenge
    Given I switch the current editor to editor "RM_AS2-2" with command "REVERSAL"
    And I close the current editor
    # Storno RM_AS2-3 nicht möglich, da gebuchte Menge < Stornomenge
    Then opening an editor from table "(Workorder):(CompletionConfirmations)" with command "REVERSAL" for record from editor "RM_AS2-3" throws the exception "9503"
    # Betriebsauftrag löschen
    Given I open an editor "BA_HINW4" from table "(Workorder):(WorkOrders)" with command "UPDATE" for record "HINW4_000"
    And I respond with answer "JA" to the dialog with id "1483"
    And I set field "status" to "s"
    And I save the current editor

  Scenario: 05 Rueckbau Arbeitsschein 1 wenn Arbeitsschein 2 schon bebucht wurde, Beleg und gebuchte Mengen pruefen
    Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
    And I append rows
      | artikel    | mge | mfreig | bisuch  |
      | BG3-STORNO | 100 | ja     | TESTRB_ |
    And I press button "freig" to open a subeditor for "freigeben"
    And I close the current subeditor to switch back to the parent editor
    And I close the current editor
    # Teilrueckmeldung auf Arbeitsscheine 1 und 2
    Given I open an editor "RM_AS1-1" from table "(Workorder):(WorkOrders)" with command "DONE" for record "TESTRB_001"
    And I set field "sofort" to "ja"
    And I set field "gutmge" to "50" in row 1
    And I save the current editor
    Given I open an editor "RM_AS2-1" from table "(Workorder):(WorkOrders)" with command "DONE" for record "TESTRB_002"
    And I set field "sofort" to "ja"
    And I set field "gutmge" to "50" in row 1
    And I save the current editor
    Given I open an editor "RM_AS1-2" from table "(Workorder):(WorkOrders)" with command "DONE" for record "TESTRB_001"
    And I set field "sofort" to "ja"
    And I set field "gutmge" to "10" in row 1
    And I save the current editor
    # Storno zweite RM auf Arbeitsschein 1 mit Menge 10
    Given I open an editor "Storno_RM_AS1-1" from table "(Workorder):(CompletionConfirmations)" with command "REVERSAL" for record from editor "RM_AS1-2"
    And I save the current editor
    # Rueckbau Arbeitsschein 2 Menge 10
    Given I open an editor "RB_AS2-1" from table "(Workorder):(WorkOrders)" with command "RETURN" for record "TESTRB_002"
    And I set field "sofort" to "ja"
    And I set field "gutmge" to "-10" in row 1
    And I save the current editor
    # Rueckbau Arbeitsschein 1 Menge 50, Material kann nur fuer 10 rueckgebaut werden, da AS 2 schon bebucht
    Given I open an editor "RB_AS1-1" from table "(Workorder):(WorkOrders)" with command "RETURN" for record "TESTRB_001"
    And I set field "sofort" to "ja"
    And I set field "gutmge" to "-50" in row 1
    And I save the current editor
    # Buchung Material pruefen
    Given I open the infosystem "LJ"
    And I set field "beleg" to "nummer" from editor "RB_AS1-1"
    And I set field "richtung" to "rückwärts"
    And I press start
    Then table has values
      | art        | zmge | amge | detursache                   |
      | EK1-BEDARF |      | -10  | Rückbau Fertigung            |
      | EK1-BEDARF |      | -10  | Storno-Rückmeldung Fertigung |
      | EK1-BEDARF |      | 10   | Rückmeldung Fertigung        |
      | EK1-BEDARF |      | 50   | Rückmeldung Fertigung        |
    And I close the current editor
    # Storno Rueckbau Arbeitsschein 1
    Given I open an editor "Storno_RB_AS1-1" from table "(Workorder):(CompletionConfirmations)" with command "REVERSAL" for record from editor "RB_AS1-1"
    And I save the current editor
    # Buchung Material pruefen
    Given I open the infosystem "LJ"
    And I set field "beleg" to "nummer" from editor "RB_AS1-1"
    And I set field "richtung" to "rückwärts"
    And I press start
    Then table has values
      | art        | zmge | amge | detursache               |
      | EK1-BEDARF |      | 10   | Storno-Rückbau Fertigung |
    And I close the current editor

  Scenario: 06 Aufbau wie 05 dann alle Rueckmeldungen und Rueckbauten stornieren, offene Mengen pruefen, wenn alles auf Anfang
    Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
    And I append rows
      | artikel    | mge | mfreig | bisuch  |
      | BG3-STORNO | 100 | ja     | STORNO_ |
    And I press button "freig" to open a subeditor for "freigeben"
    And I close the current subeditor to switch back to the parent editor
    And I close the current editor
    # Teilrueckmeldung auf Arbeitsscheine 1 und 2
    Given I open an editor "RM02_AS1-1" from table "(Workorder):(WorkOrders)" with command "DONE" for record "STORNO_001"
    And I set field "sofort" to "ja"
    And I set field "gutmge" to "50" in row 1
    And I save the current editor
    Given I open an editor "RM02_AS2" from table "(Workorder):(WorkOrders)" with command "DONE" for record "STORNO_002"
    And I set field "sofort" to "ja"
    And I set field "gutmge" to "50" in row 1
    And I save the current editor
    Given I open an editor "RM02_AS1-2" from table "(Workorder):(WorkOrders)" with command "DONE" for record "STORNO_001"
    And I set field "sofort" to "ja"
    And I set field "gutmge" to "10" in row 1
    And I save the current editor
    # Storno zweite RM auf Arbeitsschein 1 mit Menge 10
    Given I open an editor "Storno_RM02_AS1" from table "(Workorder):(CompletionConfirmations)" with command "REVERSAL" for record from editor "RM02_AS1-2"
    And I save the current editor
    # Rueckbau Arbeitsschein 2 Menge 10
    Given I open an editor "RB_AS2" from table "(Workorder):(WorkOrders)" with command "RETURN" for record "STORNO_002"
    And I set field "sofort" to "ja"
    And I set field "gutmge" to "-10" in row 1
    And I save the current editor
    # Rueckbau Arbeitsschein 1 Menge 50
    Given I open an editor "RB_AS1" from table "(Workorder):(WorkOrders)" with command "RETURN" for record "STORNO_001"
    And I set field "sofort" to "ja"
    And I set field "gutmge" to "-50" in row 1
    And I save the current editor
    # Storno Rueckbau Arbeitsschein 2 (Fall_9)
    Then opening an editor from table "(Workorder):(CompletionConfirmations)" with command "REVERSAL" for record from editor "RB_AS2" throws the exception "9503"
    # Storno Rueckbau Arbeitsschein 1
    Given I open an editor "Storno_RB_AS1" from table "(Workorder):(CompletionConfirmations)" with command "REVERSAL" for record from editor "RB_AS1"
    And I save the current editor
    # Storno Rueckbau Arbeitsschein 2
    Given I open an editor "Storno_RB_AS2" from table "(Workorder):(CompletionConfirmations)" with command "REVERSAL" for record from editor "RB_AS2"
    And I save the current editor
    # Storno Rückmeldung Arbeitsschein 2
    Given I open an editor "Storno_RM02_AS2" from table "(Workorder):(CompletionConfirmations)" with command "REVERSAL" for record from editor "RM02_AS2"
    And I save the current editor
    # Storno Rückmeldung Arbeitsschein 1
    Given I open an editor "Storno_RM02_AS1" from table "(Workorder):(CompletionConfirmations)" with command "REVERSAL" for record from editor "RM02_AS1-1"
    And I save the current editor
    # offene Mengen pruefen
    Given I open an editor "Betriebsauftrag" from table "(Workorder):(WorkOrders)" with command "VIEW" for record "STORNO_000"
    And I press button "absteig" to open a subeditor for "AFL"
    Then table has values
      | elex       | limge | frgmge |
      | EK1-BEDARF | 100   | 100    |
      | A AG-LOHN1 | 100   | 100    |
      | EK2-BEDARF | 100   | 100    |
      | A AG-LOHN2 | 100   | 100    |
    And I close the current subeditor to switch back to the parent editor
    And I close the current editor

  Scenario: 07A Rueckmeldung darf storniert werden, wenn nur manuell entnommen wurde, autorm=ja
    # UA-737: RM kann nicht storniert werden (... da bereits eine weitere Buchung auf einen nachfolgenden Beleg erfolgt ist.)
    Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
    And I append rows
      | artikel    | mge | mfreig |
      | BG7-STORNO | 3   | ja     |
    And I press button "absteig" to open a subeditor for "AFL" in row 1
    And I press button "setmanbu"
    And I save the current editor
    And I switch the current editor to editor "fvor"
    And I set field "bisuch" to "MANENT1_" in row 1
    And I press button "freig" to open a subeditor for "freigeben"
    And I close the current subeditor to switch back to the parent editor
    And I close the current editor
    # Rückmeldung auf Arbeitsscheine 1 und 3, RM1 und RM2 buchen Material, RM3 nicht
    Given I open an editor "RM_AS1-1" from table "(Workorder):(WorkOrders)" with command "DONE" for record "MANENT1_001"
    And I set field "sofort" to "ja"
    And I set field "gutmge" to "3" in row 1
    And I save the current editor
    Given I open an editor "RM_AS2-1" from table "(Workorder):(WorkOrders)" with command "DONE" for record "MANENT1_002"
    And I set field "sofort" to "ja"
    And I set field "gutmge" to "2" in row 1
    And I set field "verlust" to "1" in row 1
    And I save the current editor
    Given I open an editor "RM_AS3-1" from table "(Workorder):(WorkOrders)" with command "DONE" for record "MANENT1_003"
    And I set field "sofort" to "ja"
    And I set field "gutmge" to "3" in row 1
    And I save the current editor
    # Storno RM_AS3-1 bringt keinen Fehler
    Given I switch the current editor to editor "RM_AS3-1" with command "REVERSAL"
    And I close the current editor

  Scenario: 07B Rueckmeldung darf storniert werden, wenn nur manuell entnommen wurde, autorm=ja
    # UA-1192: RM kann nicht storniert werden (... da bereits eine weitere Buchung auf einen nachfolgenden Beleg erfolgt ist.)
    Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
    And I append rows
      | artikel    | mge | mfreig |
      | BG9-STORNO | 10  | ja     |
    And I press button "absteig" to open a subeditor for "AFL" in row 1
    And I press button "setmanbu"
    And I save the current editor
    And I switch the current editor to editor "fvor"
    And I set field "bisuch" to "MANENT2_" in row 1
    And I press button "freig" to open a subeditor for "freigeben"
    And I close the current subeditor to switch back to the parent editor
    And I close the current editor
    # Erste Manuelle Entnahme auf AS1
    Given I open an editor "FBU1_AS1" for tip command "Fbuchung" and arguments ""
    And I set field "auftrag" to "MANENT2_001"
    And I set field "gmgevorschl" to "1"
    And I press button "stllad"
    And I save the current editor
    # Erste Rückmeldung auf AS1
    Given I open an editor "RM1_AS1" from table "(Workorder):(WorkOrders)" with command "DONE" for record "MANENT2_001"
    And I set field "sofort" to "ja"
    And I set field "gutmge" to "1" in row 1
    And I save the current editor
    # Zweite Manuelle Entnahme auf AS1
    Given I open an editor "FBU2_AS1" for tip command "Fbuchung" and arguments ""
    And I set field "auftrag" to "MANENT2_001"
    And I set field "gmgevorschl" to "1"
    And I press button "stllad"
    And I save the current editor
    # Zweite Rückmeldung auf AS1
    Given I open an editor "RM2_AS1" from table "(Workorder):(WorkOrders)" with command "DONE" for record "MANENT2_001"
    And I set field "sofort" to "ja"
    And I set field "gutmge" to "1" in row 1
    And I save the current editor
    # Rückmeldung auf A22
    Given I open an editor "RM1_AS2" from table "(Workorder):(WorkOrders)" with command "DONE" for record "MANENT2_002"
    And I set field "sofort" to "ja"
    And I set field "gutmge" to "1" in row 1
    And I save the current editor
    # Storno RM1_AS1 bringt keinen Fehler
    Given I switch the current editor to editor "RM1_AS1" with command "REVERSAL"
    And I close the current editor


  Scenario: 07C Rueckmeldung darf storniert werden, wenn nur manuell entnommen wurde, autorm=ja
    # ABS-29548: Storno Auftragszeit/Kurzläufer scheitert, wenn Material komplett manuell entnommen wird
    Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
    And I append rows
      | artikel   | mge | mfreig |
      | BG-STORNO | 10  | ja     |
    And I press button "absteig" to open a subeditor for "AFL" in row 1
    And I press button "setmanbu"
    And I save the current editor
    And I switch the current editor to editor "fvor"
    And I set field "bisuch" to "MANENT3_" in row 1
    And I press button "freig" to open a subeditor for "freigeben"
    And I close the current subeditor to switch back to the parent editor
    And I close the current editor
    # Erste Manuelle Entnahme auf AS1
    Given I open an editor "FBU1_AS1" for tip command "Fbuchung" and arguments ""
    And I set field "auftrag" to "MANENT3_001"
    And I set field "gmgevorschl" to "1"
    And I press button "stllad"
    And I save the current editor
    # Erste Rückmeldung auf AS3 ueber RM
    Given I open an editor "RM1_AS3" from table "(Workorder):(WorkOrders)" with command "DONE" for record "MANENT3_003"
    And I set field "sofort" to "ja"
    And I set field "gutmge" to "1" in row 1
    And I save the current editor
    # Storno RM1_AS3 bringt keinen Fehler
    Given I switch the current editor to editor "RM1_AS3" with command "REVERSAL"
    And I save the current editor
    # Zweite Rückmeldung auf AS3 ueber BDE
    Given I open an editor "KURZ1_AS3" from table "(PDC):(ShortProductionOrder)" with command "NEW" for record ""
    And I set field "ma" to "Karl"
    And I set fields
      | asma    | MANENT3_003 |
      | anfdat  |        .    |
      | anfzeit |        9:00 |
      | istmge  |        10   |
      | sofort  |        ja   |
    And I save the current editor
    # Storno KURZ1_AS3 bringt keinen Fehler
    Given I switch the current editor to editor "KURZ1_AS3" with command "REVERSAL"
    And I save the current editor


  Scenario: 08 Beim stornieren des Rueckbaus auf einen letzten Arbeitsschein pruefen, ob auf den BA schon mehr rueckgemeldet wurde
    # Fertigungsvorschlag anlegen und freigeben
    Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
    And I append rows
      | artikel    | netmge | bisuch  | mfreig |
      | BG8-STORNO | 10     | FALL08_ | ja     |
    And I press button "freig" to open a subeditor for "BA_freigeben"
    And I close the current editor
    And I switch the current editor to editor "fvor"
    And I save the current editor
    # Rückmeldung auf letzten Arbeitsgang mit Gutmenge 5
    Given I open an editor "RM1_AS1" from table "(Workorder):(WorkOrders)" with command "DONE" for record "FALL08_001"
    And I set field "sofort" to "ja"
    And I modify table
      | gutmge | !row |
      | 5      | 1    |
    And I save the current editor
    # Rückmeldung auf Betriebsauftrag mit Gutmenge 8
    Given I open an editor "RM1_BA" from table "(Workorder):(WorkOrders)" with command "DONE" for record "FALL08_000"
    And I set field "mgr" to "112"
    And I set field "sofort" to "ja"
    And I modify table
      | gutmge | !row |
      | 8      | 1    |
    And I save the current editor
    # Rückbau auf letzten Arbeitsgang mit Gutmenge -2
    Given I open an editor "RB1_AS1" from table "(Workorder):(WorkOrders)" with command "RETURN" for record "FALL08_001"
    And I set field "sofort" to "ja"
    And I modify table
      | gutmge | !row |
      | -2     | 1    |
    And I save the current editor
    # Rückbau auf Betriebsauftrag mit Gutmenge -4
    Given I open an editor "RB1_BA" from table "(Workorder):(WorkOrders)" with command "RETURN" for record "FALL08_000"
    And I set field "mgr" to "112"
    And I set field "sofort" to "ja"
    And I modify table
      | gutmge | !row |
      | -4     | 1    |
    And I save the current editor
    # Rückbau auf letzten Arbeitsschein stornieren bringt Fehler
    # Rückmeldung kann nicht storniert werden da bereits eine weitere Buchung auf den letzten Arbeitsschein/Betriebsauftrag erfolgt ist.
    Then opening an editor from table "(Workorder):(CompletionConfirmations)" with command "REVERSAL" for record from editor "RB1_AS1" throws the exception "9503"
    And I close the current editor

  Scenario: 09 Beim stornieren des Rueckbaus auf einen letzten Arbeitsschein pruefen, ob der Storno moeglich ist
    # Fertigungsvorschlag anlegen und freigeben
    Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
    And I append rows
      | artikel    | netmge | bisuch  | mfreig |
      | BG8-STORNO | 10     | FALL09_ | ja     |
    And I press button "freig" to open a subeditor for "BA_freigeben"
    And I close the current editor
    And I switch the current editor to editor "fvor"
    And I save the current editor
    # Rückmeldung auf letzten Arbeitsgang mit Gutmenge 2
    Given I open an editor "RM1_AS1" from table "(Workorder):(WorkOrders)" with command "DONE" for record "FALL09_001"
    And I set field "sofort" to "ja"
    And I modify table
      | gutmge | !row |
      | 2      | 1    |
    And I save the current editor
    # Rückmeldung auf Betriebsauftrag mit Gutmenge 3
    Given I open an editor "RM1_BA" from table "(Workorder):(WorkOrders)" with command "DONE" for record "FALL09_000"
    And I set field "mgr" to "112"
    And I set field "sofort" to "ja"
    And I modify table
      | gutmge | !row |
      | 3      | 1    |
    And I save the current editor
    # Rückmeldung auf letzten Arbeitsgang mit Gutmenge 2
    Given I open an editor "RM2_AS1" from table "(Workorder):(WorkOrders)" with command "DONE" for record "FALL09_001"
    And I set field "sofort" to "ja"
    And I modify table
      | gutmge | !row |
      | 2      | 1    |
    And I save the current editor
    # Rückbau auf letzten Arbeitsgang mit Gutmenge -2
    Given I open an editor "RB1_AS1" from table "(Workorder):(WorkOrders)" with command "RETURN" for record "FALL09_001"
    And I set field "sofort" to "1"
    And I modify table
      | gutmge | !row |
      | -2     | 1    |
    And I save the current editor
    # Rückbau auf Betriebsauftrag mit Gutmenge -3
    Given I open an editor "RB1_BA" from table "(Workorder):(WorkOrders)" with command "RETURN" for record "FALL09_000"
    And I set field "mgr" to "112"
    And I set field "sofort" to "1"
    And I modify table
      | gutmge | !row |
      | -3     | 1    |
    And I save the current editor
    # Rückbau auf letzten Arbeitsschein stornieren
    Given opening an editor from table "(Workorder):(CompletionConfirmations)" with command "REVERSAL" for record from editor "RB1_AS1" throws the exception "9503"
    And I close the current editor

  Scenario: 10 Arbeitsgang darf nicht storniert werden, wenn bereits ein Rückbau auf den AG erfolgt ist (rueckmge <> 0)
    Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
    And I append rows
      | artikel   | mge | mfreig | bisuch  |
      | BG-STORNO | 10  | ja     | FALL10_ |
    And I press button "freig" to open a subeditor for "freigeben"
    And I close the current subeditor to switch back to the parent editor
    And I close the current editor
    # Teilrückmeldungen auf BA
    Given I open an editor "RM_BA-1" from table "(Workorder):(WorkOrders)" with command "DONE" for record "FALL10_000"
    And I set field "mgr" to "101"
    And I set field "sofort" to "ja"
    And I set field "gutmge" to "3" in row 1
    And I save the current editor
    # Teilrückmeldungen auf letzten AS (BA Gutmenge + 1)
    Given I open an editor "RM_AS3-1" from table "(Workorder):(WorkOrders)" with command "DONE" for record "FALL10_003"
    And I set field "sofort" to "ja"
    And I set field "gutmge" to "4" in row 1
    And I save the current editor
    # Rückbau AS3 mit Gutmenge -1, Gutmenge AS3 == Gutmenge BA
    Given I open an editor "RB_AS3-1" from table "(Workorder):(WorkOrders)" with command "RETURN" for record "FALL10_003"
    And I set field "sofort" to "ja"
    And I set field "gutmge" to "-1" in row 1
    And I save the current editor
    # Rückbau AS3 mit Gutmenge -1, jetzt ist Gutmenge AS3 < Gutmenge BA
    Given I open an editor "RB_AS3-2" from table "(Workorder):(WorkOrders)" with command "RETURN" for record "FALL10_003"
    And I set field "sofort" to "ja"
    And I set field "gutmge" to "-1" in row 1
    And I save the current editor
    Then opening an editor from table "(Workorder):(CompletionConfirmations)" with command "REVERSAL" for record from editor "RM_AS3-1" throws the exception "2199"

    # Betriebsauftrag löschen
    Given I open an editor "BA_FALL10" from table "(Workorder):(WorkOrders)" with command "UPDATE" for record "FALL10_000"
    And I respond with answer "JA" to the dialog with id "345"
    And I set field "status" to "s"
    And I save the current editor


  Scenario: 11 Rückmeldung kann storniert werden, wenn das Material nur manuell entnommen wird. Buchung über BDE.
  # ABS-31013: Stornieren einer RM mit manueller Entnahme führt zur Diag
    Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
    And I append rows
      | artikel    | mge | mfreig |
      | BG9-STORNO | 11  | ja     |
    And I press button "absteig" to open a subeditor for "AFL" in row 1
    And I press button "setmanbu"
    And I save the current editor
    And I switch the current editor to editor "fvor"
    And I set field "bisuch" to "FALL11_" in row 1
    And I press button "freig" to open a subeditor for "freigeben"
    And I close the current subeditor to switch back to the parent editor
    And I close the current editor

    # Rückmeldung auf AS1
    Given I open an editor "KurzlAS1" from table "(PDC):(ShortProductionOrder)" with command "NEW" for record ""
    And I set fields
      | asma    | FALL11_001 |
      | ma      | Karl       |
      | anfdat  | .          |
      | anfzeit | 9:00       |
      | istmge  | 3          |
      | sofort  | ja         |
    And I save the current editor

    # Rückmeldung auf AS2
    Given I open an editor "KurzlAS2" from table "(PDC):(ShortProductionOrder)" with command "NEW" for record ""
    And I set fields
      | asma    | FALL11_002 |
      | ma      | Karl       |
      | anfdat  | .          |
      | anfzeit | 13:00      |
      | istmge  | 3          |
      | sofort  | ja         |
    And I save the current editor

    # Storno KurzlAS2 bringt keinen Diag
    Given I switch the current editor to editor "KurzlAS2" with command "REVERSAL"
    And I save the current editor

    # weiter Rückmeldung auf AS2
    Given I open an editor "KurzlAS2.2" from table "(PDC):(ShortProductionOrder)" with command "NEW" for record ""
    And I set fields
      | asma    | FALL11_002 |
      | ma      | Karl       |
      | anfdat  | .          |
      | anfzeit | 13:30      |
      | istmge  | 4          |
      | sofort  | ja         |
    And I save the current editor

    # Rückmeldung auf den BA
    Given I open an editor "KurzlBA" from table "(PDC):(ShortProductionOrder)" with command "NEW" for record ""
    And I set fields
      | asma    | FALL11_000 |
      | ma      | Karl       |
      | mgr     | 101         |
      | anfdat  | .          |
      | anfzeit | 15:00      |
      | istmge  | 5          |
      | sofort  | ja         |
    And I save the current editor

    # Storno KurzlBA bringt keinen Diag
    Given I switch the current editor to editor "KurzlBA" with command "REVERSAL"
    And I save the current editor


  # #############################
  # ### Scenarios autorm=nein ###
  # #############################
  Scenario: Konfiguration autorm=nein
    Given I open an editor "Konfiguration" from table "(Company):(Configuration)" with command "UPDATE" for record "0k"
    And I set fields
      | autorm | nein |
    And I save the current editor

  Scenario: 105 Arbeitsgang darf storniert werden, wenn letzter AS oder BA nicht bebucht sind, autorm=nein
    Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
    And I append rows
      | artikel    | mge | mfreig | bisuch |
      | BG2-STORNO | 10  | ja     | HINW5_ |
    And I press button "freig" to open a subeditor for "freigeben"
    And I close the current subeditor to switch back to the parent editor
    And I close the current editor
    # Rückmeldung auf Arbeitsscheine 2 und 3, keine Materialbuchung
    Given I open an editor "RM_AS2-1" from table "(Workorder):(WorkOrders)" with command "DONE" for record "HINW5_002"
    And I set field "sofort" to "ja"
    And I set field "gutmge" to "5" in row 1
    And I save the current editor
    Given I open an editor "RM_AS3-1" from table "(Workorder):(WorkOrders)" with command "DONE" for record "HINW5_003"
    And I set field "sofort" to "ja"
    And I set field "gutmge" to "2" in row 1
    And I save the current editor
    # Storno RM1 und RM2 möglich
    Given I switch the current editor to editor "RM_AS2-1" with command "REVERSAL"
    And I save the current editor
    Given I switch the current editor to editor "RM_AS3-1" with command "REVERSAL"
    And I save the current editor
    # Betriebsauftrag löschen
    Given I open an editor "BA_HINW5" from table "(Workorder):(WorkOrders)" with command "UPDATE" for record "HINW5_000"
    And I respond with answer "JA" to the dialog with id "345"
    And I set field "status" to "s"
    And I save the current editor

  Scenario: 106 Arbeitsgang darf nicht storniert werden, wenn letzter AG bebucht ist, autorm=nein
    Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
    And I append rows
      | artikel   | mge | mfreig | bisuch |
      | BG-STORNO | 15  | ja     | HINW6_ |
    And I press button "freig" to open a subeditor for "freigeben"
    And I close the current subeditor to switch back to the parent editor
    And I close the current editor
    # Rückmeldungen auf Arbeitsgänge 1, 2 und 3, Materialbuchung bei Rückmeldung1
    Given I open an editor "RM_AS1-1" from table "(Workorder):(WorkOrders)" with command "DONE" for record "HINW6_001"
    And I set field "sofort" to "ja"
    And I set field "gutmge" to "5" in row 1
    And I save the current editor
    Given I open an editor "RM_AS2-1" from table "(Workorder):(WorkOrders)" with command "DONE" for record "HINW6_002"
    And I set field "sofort" to "ja"
    And I set field "gutmge" to "5" in row 1
    And I save the current editor
    Given I open an editor "RM_AS2-2" from table "(Workorder):(WorkOrders)" with command "DONE" for record "HINW6_002"
    And I set field "sofort" to "ja"
    And I set field "gutmge" to "5" in row 1
    And I save the current editor
    Given I open an editor "RM_AS3-1" from table "(Workorder):(WorkOrders)" with command "DONE" for record "HINW6_003"
    And I set field "sofort" to "ja"
    And I set field "gutmge" to "5" in row 1
    And I save the current editor
    # Storno RM1, RM2_1 und RM2_2 ist möglich
    Given I switch the current editor to editor "RM_AS1-1" with command "REVERSAL"
    And I save the current editor
    Given I switch the current editor to editor "RM_AS2-1" with command "REVERSAL"
    And I save the current editor
    Given I switch the current editor to editor "RM_AS2-2" with command "REVERSAL"
    And I save the current editor
    # Betriebsauftrag löschen
    Given I open an editor "BA_HINW6" from table "(Workorder):(WorkOrders)" with command "UPDATE" for record "HINW6_000"
    And I respond with answer "JA" to the dialog with id "345"
    And I set field "status" to "s"
    And I save the current editor

  Scenario: 107 Arbeitsgang darf nicht storniert werden, wenn BA bebucht ist, autorm=nein
    Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
    And I append rows
      | artikel   | mge | mfreig | bisuch |
      | BG-STORNO | 15  | ja     | HINW7_ |
    And I press button "freig" to open a subeditor for "freigeben"
    And I close the current subeditor to switch back to the parent editor
    And I close the current editor
    # Rückmeldung auf Arbeitsgänge 1, 2 und BA
    Given I open an editor "RM_AS1-1" from table "(Workorder):(WorkOrders)" with command "DONE" for record "HINW7_001"
    And I set field "sofort" to "ja"
    And I set field "gutmge" to "5" in row 1
    And I save the current editor
    Given I open an editor "RM_AS2-1" from table "(Workorder):(WorkOrders)" with command "DONE" for record "HINW7_002"
    And I set field "sofort" to "ja"
    And I set field "gutmge" to "5" in row 1
    And I save the current editor
    Given I open an editor "RM_AS2-2" from table "(Workorder):(WorkOrders)" with command "DONE" for record "HINW7_002"
    And I set field "sofort" to "ja"
    And I set field "gutmge" to "5" in row 1
    And I save the current editor
    Given I open an editor "RM_BA-1" from table "(Workorder):(WorkOrders)" with command "DONE" for record "HINW7_000"
    And I set field "sofort" to "ja"
    And I set field "mgr" to "103"
    And I set field "gutmge" to "5" in row 1
    And I save the current editor
    # Storno RM1 RM2_1 und RM2_2 ist möglich
    Given I switch the current editor to editor "RM_AS1-1" with command "REVERSAL"
    And I save the current editor
    Given I switch the current editor to editor "RM_AS2-1" with command "REVERSAL"
    And I save the current editor
    Given I switch the current editor to editor "RM_AS2-2" with command "REVERSAL"
    And I save the current editor
    # Betriebsauftrag löschen
    Given I open an editor "BA_HINW7" from table "(Workorder):(WorkOrders)" with command "UPDATE" for record "HINW7_000"
    And I respond with answer "JA" to the dialog with id "345"
    And I set field "status" to "s"
    And I save the current editor


  Scenario: 111 Rückmeldung kann storniert werden, wenn das Material nur manuell entnommen wird. Buchung über BDE.
  # ABS-31013: Stornieren einer RM mit manueller Entnahme führt zur Diag
    Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
    And I append rows
      | artikel    | mge | mfreig |
      | BG9-STORNO | 111 | ja     |
    And I press button "absteig" to open a subeditor for "AFL" in row 1
    And I press button "setmanbu"
    And I save the current editor
    And I switch the current editor to editor "fvor"
    And I set field "bisuch" to "FALL111_" in row 1
    And I press button "freig" to open a subeditor for "freigeben"
    And I close the current subeditor to switch back to the parent editor
    And I close the current editor

    # Rückmeldung auf AS1
    Given I open an editor "KurzlAS1" from table "(PDC):(ShortProductionOrder)" with command "NEW" for record ""
    And I set fields
      | asma    | FALL111_001 |
      | ma      | Karl        |
      | anfdat  | .           |
      | anfzeit | 9:00        |
      | istmge  | 3           |
      | sofort  | ja          |
    And I save the current editor

    # Rückmeldung auf AS2
    Given I open an editor "KurzlAS2" from table "(PDC):(ShortProductionOrder)" with command "NEW" for record ""
    And I set fields
      | asma    | FALL111_002 |
      | ma      | Karl        |
      | anfdat  | .           |
      | anfzeit | 13:00       |
      | istmge  | 3           |
      | sofort  | ja          |
    And I save the current editor

    # Storno KurzlAS2 bringt keinen Diag
    Given I switch the current editor to editor "KurzlAS2" with command "REVERSAL"
    And I save the current editor

    # weiter Rückmeldung auf AS2
    Given I open an editor "KurzlAS2.2" from table "(PDC):(ShortProductionOrder)" with command "NEW" for record ""
    And I set fields
      | asma    | FALL111_002 |
      | ma      | Karl        |
      | anfdat  | .           |
      | anfzeit | 13:30       |
      | istmge  | 4           |
      | sofort  | ja          |
    And I save the current editor

    # Rückmeldung auf den BA
    Given I open an editor "KurzlBA" from table "(PDC):(ShortProductionOrder)" with command "NEW" for record ""
    And I set fields
      | asma    | FALL111_000 |
      | ma      | Karl        |
      | mgr     | 101         |
      | anfdat  | .           |
      | anfzeit | 15:00       |
      | istmge  | 5           |
      | sofort  | ja          |
    And I save the current editor

    # Storno KurzlBA bringt keinen Diag
    Given I switch the current editor to editor "KurzlBA" with command "REVERSAL"
    And I save the current editor


  # ## Ende - Konfigurationseinstellung wieder zurücksetzen ###
  # ## Scenarios autorm=ja ###
  Scenario: Konfiguration autorm=ja
    Given I open an editor "Konfiguration" from table "(Company):(Configuration)" with command "UPDATE" for record "0k"
    And I set fields
      | autorm | ja |
    And I save the current editor

  # ###############################
  # ## Korrekturen (zu Anfragen) ##
  # ###############################
  Scenario: KOR01 Rueckmeldung mit krummen Mengen kann storniert werden (FDA-6357)
    Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
    And I append rows
      | artikel   | mge | mfreig |
      | BG-BEDARF | 10  | ja     |
    And I press button "absteig" to open a subeditor for "AFL" in row !lastRow
    And I set field "elanzahl" to "0.0196" in row 1
    And I save the current editor
    And I switch the current editor to editor "fvor"
    And I set field "bisuch" to "KOR01_" in row 1
    And I press button "freig" to open a subeditor for "BA_freigeben"
    And I close the current subeditor to switch back to the parent editor
    And I close the current editor
    # Rückmeldung auf Arbeitsschein 2
    Given I open an editor "RM1_AS2" from table "(Workorder):(WorkOrders)" with command "DONE" for record "KOR01_002"
    And I set field "sofort" to "ja"
    And I set field "gutmge" to "3" in row 1
    And I save the current editor
    # Storno RM1_AS2 bringt keinen Fehler
    Given I switch the current editor to editor "RM1_AS2" with command "REVERSAL"
    And I close the current editor
    # Betriebsauftrag löschen
    Given I open an editor "BA_KOR01" from table "(Workorder):(WorkOrders)" with command "UPDATE" for record "KOR01_000"
    And I respond with answer "JA" to the dialog with id "345"
    And I set field "status" to "s"
    And I save the current editor
