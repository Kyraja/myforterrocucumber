@persistent
Feature: CEPI_Sperrmodus_Gesperrt_SERVICE_DL.feature

  Background:
    Given I set the fake date to "03.02.1995"

# *****************************************************************************
#  Name             : CEPI_Sperrmodus_Gesperrt_SERVICE_DL
#  Autor            : lschneider
#  Verantwortlich   : bheim
#  Kontrolle        : bschiga
#  Funktion         : Testet das Verhalten gesperrter Artikel im Bereich Service
#
# *****************************************************************************


  Scenario: 01 Artikel mit Sperrkonfiguration Gesperrt kann in neue Dienstleistungsstückliste eingetragen werden

    Given I open an editor "DL-Stückliste" from table "(ServiceProduct):(ServiceBillOfMaterials)" with command "NEW" for record ""
    And I create a new row at the end of the table
    And I set field "elex" to "EK-GESPERRT" in row 1
    And I close the current editor


  Scenario: 02 Artikel mit Sperrkonfiguration Gesperrt kann in vorhandene Dienstleistungsstückliste eingetragen werden

    Given I open an editor "DL-Stückliste" from table "(ServiceProduct):(ServiceBillOfMaterials)" with command "STORE" for record "DL-02"
    And I set field "such" to "DL-02"
    And I set field "dienstl" to "DL-OHNESPERRE"
    And I set field "elex" to "EK-OHNESPERRE" in row 1
    And I set field "elanzahl" to "1" in row 1
    And I save the current editor

    And I switch the current editor to editor "DL-Stückliste" with command "UPDATE"
    And I create a new row at the end of the table
    And I set field "elex" to "EK-GESPERRT" in row 1
    And I close the current editor


# CEPI-238
  Scenario: 03 Im Serviceauftrag wird eine DL-Stückliste mit einem Artikel Sperrkonfiguration Gesperrt aufgelöst, der Vorgang kann trotzdem gespeichert werden

# Serviceprodukt anlegen
    Given I open an editor "Serviceprodukt" from table "(ServiceProduct):(ServiceProduct)" with command "NEW" for record ""
    And I set field "such" to "SPROD-03"
    And I set field "artikel" to "S-GESPERRT"
    And I press button "stlanlegen" to open a subeditor for "Stückliste"
    And I save the current editor
    And I switch the current editor to editor "Serviceprodukt"
    And I save the current editor

# Dienstleistungsstückliste
    Given I open an editor "DL-Stückliste" from table "(ServiceProduct):(ServiceBillOfMaterials)" with command "NEW" for record ""
    And I set fields
      | such    | STUECKL-03         |
      | dienstl | DL-OHNESPERRE      |
      | artikel | S-GESPERRT         |
      | serprod | !Serviceprodukt^id |
    And I append rows
      | elex          | elanzahl |
      | EK-OHNESPERRE | 1        |
      | EK-GESPERRT   | 2        |
    And I save the current editor

# Serviceauftrag anlegen
    Given I open an editor "Serviceauftrag" from table "(Sales):(ServiceOrder)" with command "NEW" for record ""
    And I set field "kunde" to "PFISCHER"
    And I set field "vserprod" to id from editor "Serviceprodukt"
    And I modify table
      | artikel       | mge | zzvon | zzbis | !row |
      | DL-OHNESPERRE | 1   | 8     | 12    | +1   |
    Then the table has 3 rows
    Then field "artikel^such" has value "EK-GESPERRT" in row 3
    And I close the current editor


  Scenario: 04 Ein Serviceauftrag mit einem Ersatzteil mit Sperrkonfiguration Gesperrt kann trotzdem gespeichert werden

# Serviceprodukt anlegen
    Given I open an editor "Serviceprodukt" from table "(ServiceProduct):(ServiceProduct)" with command "NEW" for record ""
    And I set field "such" to "SPROD-05"
    And I set field "artikel" to "S-OHNESPERRE"
    And I press button "stlanlegen" to open a subeditor for "Stückliste"
    And I save the current editor
    And I switch the current editor to editor "Serviceprodukt"
    And I save the current editor

# Dienstleistungsstückliste
    Given I open an editor "DL-Stückliste" from table "(ServiceProduct):(ServiceBillOfMaterials)" with command "NEW" for record ""
    And I set fields
      | such    | STUECKL-05         |
      | dienstl | DL-OHNESPERRE      |
      | artikel | S-OHNESPERRE       |
      | serprod | !Serviceprodukt^id |
    And I create a new row at the end of the table
    And I set field "elex" to "EK-OHNESPERRE" in row 1
    And I set field "elanzahl" to "1" in row 1
    And I save the current editor

# Serviceauftrag anlegen
    Given I open an editor "Serviceauftrag" from table "(Sales):(ServiceOrder)" with command "NEW" for record ""
    And I set field "kunde" to "PFISCHER"
    And I create a new row at the end of the table
    And I set field "vserprod" to id from editor "Serviceprodukt"
    And I create a new row at the end of the table
    And I set field "artikel" to "S-OHNESPERRE" in row 1
    And I set field "mge" to "1" in row 1
    And I create a new row at the end of the table
    And I set field "artikel" to "DL-OHNESPERRE" in row 2
    Then the table has 4 rows
    And I create a new row at the end of the table
    And I set field "artikel" to "EK-GESPERRT" in row !lastRow
    Then field "artikel" is not empty in row !lastRow
    And I close the current editor


  Scenario: 05 Serviceprodukt mit Artikel Sperrkonfiguration Gesperrt kann in Serviceauftrag zugeordnet werden

# Serviceprodukt anlegen
    Given I open an editor "Serviceprodukt" from table "(ServiceProduct):(ServiceProduct)" with command "NEW" for record ""
    And I set field "such" to "SPROD-06"
    And I set field "artikel" to "S-OHNESPERRE"
    And I press button "stlanlegen" to open a subeditor for "Stückliste"
    And I create a new row at the end of the table
    And I set field "elex" to "EK-GESPERRT" in row !lastRow
    And I set field "elanzahl" to "1" in row !lastRow
    And I save the current editor
    And I switch the current editor to editor "Serviceprodukt"
    And I save the current editor

# Serviceauftrag anlegen
    Given I open an editor "Serviceauftrag" from table "(Sales):(ServiceOrder)" with command "NEW" for record ""
    And I set field "kunde" to "PFISCHER"
    And I create a new row at the end of the table
    And I set field "vserprod" to id from editor "Serviceprodukt"
    And I set field "artikel" to "S-OHNESPERRE" in row 1
    And I set field "mge" to "1" in row 1
    And I save the current editor

# Serviceauftrag abschließen
    Given I open an editor "Lieferschein" from table "(Sales):(ServiceOrder)" with command "DELIVERY" for record "BPFISCHER"
    And I set field "mge" to "1" in row 1
    And I set field "ueb" to "ja"
    And I save the current editor


# CEPI-238
  Scenario: 06 Serviceauftrag mit Dienstleistung Sperrkonfiguration Gesperrt kann trotzdem gespeichert werden

# Serviceprodukt anlegen
    Given I open an editor "Serviceprodukt" from table "(ServiceProduct):(ServiceProduct)" with command "NEW" for record ""
    And I set field "such" to "SPROD-07"
    And I set field "artikel" to "S-OHNESPERRE"
    And I press button "stlanlegen" to open a subeditor for "Stückliste"
    And I save the current editor
    And I switch the current editor to editor "Serviceprodukt"
    And I save the current editor

# Dienstleistungsstückliste
    Given I open an editor "DL-Stückliste" from table "(ServiceProduct):(ServiceBillOfMaterials)" with command "NEW" for record ""
    And I set fields
      | such    | STUECKL-07         |
      | dienstl | DL-GESPERRT        |
      | artikel | S-OHNESPERRE       |
      | serprod | !Serviceprodukt^id |
    And I create a new row at the end of the table
    And I set field "elex" to "EK-OHNESPERRE" in row 1
    And I set field "elanzahl" to "2" in row 1
    And I save the current editor

# Serviceauftrag anlegen
    Given I open an editor "Serviceauftrag" from table "(Sales):(ServiceOrder)" with command "NEW" for record ""
    And I set field "kunde" to "PFISCHER"
    And I create a new row at the end of the table
    And I set field "vserprod" to id from editor "Serviceprodukt"
    And I set field "artikel" to "S-OHNESPERRE" in row 1
    And I set field "mge" to "1" in row 1
    And I create a new row at the end of the table
    Then setting field "artikel" to "DL-GESPERRT" in row 2 throws the exception "1361"
    Then field "artikel" is empty in row 2
    And I close the current editor


  Scenario: 07 Fehlermeldung bei Servicerückmeldung für zusätzliches Material mit Sperrkonfiguration Gesperrt

# Serviceprodukt anlegen
    Given I open an editor "Serviceprodukt" from table "(ServiceProduct):(ServiceProduct)" with command "NEW" for record ""
    And I set field "such" to "SPROD-08"
    And I set field "artikel" to "S-OHNESPERRE"
    And I press button "stlanlegen" to open a subeditor for "Stückliste"
    And I save the current editor
    And I switch the current editor to editor "Serviceprodukt"
    And I save the current editor

# Dienstleistungsstückliste
    Given I open an editor "DL-Stückliste" from table "(ServiceProduct):(ServiceBillOfMaterials)" with command "NEW" for record ""
    And I set fields
      | such    | STUECKL-08         |
      | dienstl | DL-OHNESPERRE      |
      | artikel | S-OHNESPERRE       |
      | serprod | !Serviceprodukt^id |
    And I create a new row at the end of the table
    And I set field "elex" to "EK-OHNESPERRE" in row 1
    And I set field "elanzahl" to "2" in row 1
    And I save the current editor

# Serviceauftrag anlegen
    Given I open an editor "Serviceauftrag" from table "(Sales):(ServiceOrder)" with command "NEW" for record ""
    And I set field "kunde" to "PFISCHER"
    And I create a new row at the end of the table
    And I set field "vserprod" to id from editor "Serviceprodukt"
    And I set field "artikel" to "S-OHNESPERRE" in row 1
    And I set field "mge" to "1" in row 1
    And I create a new row at the end of the table
    And I set field "artikel" to "DL-OHNESPERRE" in row 2
    And I set field "mge" to "1" in row 2
    And I set field "zzvon" to "10:00" in row 2
    And I set field "zzbis" to "12:00" in row 2
    And I create a new row at the end of the table
    Then setting field "artikel" to "DL-GESPERRT" in row !lastRow throws the exception "1361"
    Then field "artikel" is empty in row !lastRow
    And I set field "artikel" to "DL-KOMPSPERRE" in row !lastRow
# DL-KOMPSPERRE ist kein Set darum im VK kein box_red icon auch wenn Komponente gesperrt sind
    And I set field "mge" to "1" in row !lastRow
    And I set field "zzvon" to "10:00" in row !lastRow
    And I set field "zzbis" to "12:00" in row !lastRow
    And I save the current editor

# Rückmeldung mit gesperrtem, zusätzlichen Material
    Given I open an editor "Rückmeldung" from table "(ServiceReservation):(EngineerCompletionConfirmations)" with command "NEW" for record ""
    And I set field "servau" to id from editor "Serviceauftrag"
    And I press button "ladetab"
    Then the table has 4 rows
    And I create a new row at the end of the table
# 4806 de |Objekt ist gesperrt.
    And setting field "artikel" to "EK-GESPERRT" in row !lastRow throws the exception "1361"
    And I close the current editor

# Serviceauftrag abschließen
    Given I open an editor "Lieferschein" from table "(Sales):(ServiceOrder)" with command "DELIVERY" for record "BPFISCHER"
    And I set field "mge" to "1" in row 1
    And I set field "ueb" to "ja"
    And I save the current editor


  Scenario: 08 Dienstleistung mit Sperrkonfiguration Gesperrt wird aus Reparaturauftrag nicht in Rechnung übernommen

# Serviceprodukt anlegen
    Given I open an editor "Serviceprodukt" from table "(ServiceProduct):(ServiceProduct)" with command "NEW" for record ""
    And I set field "such" to "SPROD-09"
    And I set field "artikel" to "S-OHNESPERRE"
    And I press button "stlanlegen" to open a subeditor for "Stückliste"
    And I create a new row at the end of the table
    And I set field "elex" to "EK-GESPERRT" in row !lastRow
    And I set field "elanzahl" to "1" in row !lastRow
    And I save the current editor
    And I switch the current editor to editor "Serviceprodukt"
    And I save the current editor

# Dienstleistungsstückliste
    Given I open an editor "DL-Stückliste" from table "(ServiceProduct):(ServiceBillOfMaterials)" with command "NEW" for record ""
    And I set fields
      | such    | STUECKL-09         |
      | dienstl | DL-OHNESPERRE      |
      | artikel | S-OHNESPERRE       |
      | serprod | !Serviceprodukt^id |
    And I create a new row at the end of the table
    And I set field "elex" to "EK-OHNESPERRE" in row !lastRow
    And I set field "elanzahl" to "2" in row !lastRow
    And I save the current editor

# Reparaturauftrag
    Given I open an editor "Reparaturauftrag" from table "(Sales):(RepairOrder)" with command "NEW" for record ""
    And I set field "kunde" to "PFISCHER"
    And I set field "vserprod" to id from editor "Serviceprodukt"
    And I append rows
      | artikel       | mge |
      | DL-OHNESPERRE | 1   |
      | DL-KOMPSPERRE | 1   |
# DL-KOMPSPERRE ist kein Set darum im VK kein box_red icon auch wenn Komponente gesperrt sind
    And I save the current editor

# Repararturauftrag mit Rechnung abschließen, der gesperrte Artikel wird nicht übernommen
    And I switch the current editor to editor "Reparaturauftrag" with command "UPDATE"
    And I press button "reanlegen" to open a subeditor for "Rechnung"
    Then the table has 2 rows
    Then table has values
      | artikel       | ofmge |
      | DL-OHNESPERRE | 1     |
      | DL-KOMPSPERRE | 1     |
    And I set field "mge" to "1" in row 1
    And I set field "mge" to "1" in row 2
    And I set field "ueb" to "ja"
    And I set field "budat" to "."
    And I save the current editor


# CEPI-234
  Scenario: 09 Erstellen eines Reparaturauftrags mit Artikel Obkjektstatus Gesperrt in DL-Fertigungsliste möglich

# Serviceprodukt anlegen
    Given I open an editor "Serviceprodukt" from table "(ServiceProduct):(ServiceProduct)" with command "NEW" for record ""
    And I set field "such" to "SPROD-10"
    And I set field "artikel" to "S-OHNESPERRE"
    And I press button "stlanlegen" to open a subeditor for "Stückliste"
    And I save the current editor
    And I switch the current editor to editor "Serviceprodukt"
    And I save the current editor

# Dienstleistung mit gesperrtem Artikel in Stückliste
    Given I open an editor "Dienstleistung" from table "(Part):(Service)" with command "STORE" for record "DL-10"
    And I set field "such" to "DL-10"
    And I create a new row at the end of the table
    And I set field "elex" to "EK-GESPERRT" in row 1
    And I set field "elanzahl" to "1" in row 1
    And I create a new row at the end of the table
    And I set field "elex" to "A MONTAGE1" in row 2
    And I set field "lge" to "10" in row 2
    And I set field "breite" to "30" in row 2
    And I save the current editor

# Reparaturauftrag
    Given I open an editor "Reparaturauftrag" from table "(Sales):(RepairOrder)" with command "NEW" for record ""
    And I set field "kunde" to "PFISCHER"
    And I create a new row at the end of the table
    And I set field "vserprod" to id from editor "Serviceprodukt"
    And I set field "artikel" to "S-OHNESPERRE" in row 1
    And I create a new row at the end of the table
    And I set field "artikel" to "DL-10" in row 2
    And I set field "mge" to "1" in row 2
    And I press button "absteig" to open a subeditor for "Fertigungsliste" in row 2
    Then the table has 2 rows
    Then field "elex" has value "EK-GESPERRT" in row 1
    Then field "elex" has value "A MONTAGE1" in row 2
    And I close the current editor
    And I switch the current editor to editor "Reparaturauftrag"
    And I save the current editor


  Scenario: 10 Artikel mit Objesktatus Gesperrt kann in Kostenvoranschlag zu Reparaturauftrag eingetragen werden

# Serviceprodukt anlegen
    Given I open an editor "Serviceprodukt" from table "(ServiceProduct):(ServiceProduct)" with command "NEW" for record ""
    And I set field "such" to "SPROD-11"
    And I set field "artikel" to "S-OHNESPERRE"
    And I press button "stlanlegen" to open a subeditor for "Stückliste"
    And I save the current editor
    And I switch the current editor to editor "Serviceprodukt"
    And I save the current editor

# Reparaturauftrag
    Given I open an editor "Reparaturauftrag" from table "(Sales):(RepairOrder)" with command "NEW" for record ""
    And I set field "kunde" to "PFISCHER"
    And I create a new row at the end of the table
    And I set field "vserprod" to id from editor "Serviceprodukt"
    And I set field "artikel" to "S-OHNESPERRE" in row 1
    And I create a new row at the end of the table
    And I set field "artikel" to "DL-OHNESPERRE" in row 2
    And I set field "mge" to "1" in row 2
    And I press button "kostenvorb" to open a subeditor for "Kostenvoranschlag"
    And I create a new row at the end of the table
    And I set field "artikel" to "EK-GESPERRT" in row !lastRow
    And I set field "mge" to "1" in row !lastRow
    And I save the current editor
    And I switch the current editor to editor "Reparaturauftrag"
    And I save the current editor
