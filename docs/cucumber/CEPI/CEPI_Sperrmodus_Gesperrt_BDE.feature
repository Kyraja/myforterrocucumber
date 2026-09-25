# *****************************************************************************
#  Name             : CEPI_Sperrmodus_restriktiv_BDE
#  Autor            : amk
#  Verantwortlich   : amk
#  Kontrolle        : drpf
#  Jira-Issue       : FDA-1269
#  Funktion         : Testet das Erfassen, Ändern und Buchen von Auftragszeit
#                     und Kurzläufer mit gesperrtem Artikel Fertigteil
#
# *****************************************************************************
@persistent
Feature: CEPI_Sperrmodus_restriktiv_BDE

  Scenario: N00 Vorbereitung fuer Testszenarien. Bebuchbare Objekte anlegen.

# SWITCH-Artikel leere Sperre
    Given I open an editor "Artikel-switch" from table "(Part):(Product)" with command "UPDATE" for record "VK-SWITCH"
    And I set field "sperrkonfigurationneu" to ""
    And I save the current editor

# Fertigungsvorschlag anlegen
    Given I open an editor "fvanlegen" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
    And I append rows
      | artikel   | mge | mfreig | bisuch |
      | VK-SWITCH | 100 | ja     | BDE_   |
    And I press button "freig" to open a subeditor for "fertigung"
    And I close the current subeditor to switch back to the parent editor
    And I close the current editor

# Switch-Artikel sperren
    Given I open an editor "Artikel-switch" from table "(Part):(Product)" with command "UPDATE" for record "VK-SWITCH"
    And I set field "sperrkonfigurationneu" to "Standard-Artikelsperre"
    And I save the current editor

# Mitarbeiter und Schichtplan anlegen
    Given I open an editor "mitarbeiter" from table "(Employee):(Employee)" with command "NEW" for record ""
    And I set fields
      | such  | BDE_MA |
      | splan | 303    |
      | lohn  | 1      |
    And I save the current editor

# Personalzeit und Auftragszeit erstellen
    Given I open an editor "Personalzeit" from table "(PDC):(TimeAndLaborData)" with command "NEW" for record ""
    And I set field "ma" to id from editor "mitarbeiter"
    And I set fields
      | anfdat  | .    |
      | anfzeit | 8:00 |
    And I save the current editor

############### Erfassen eines BDE Obejkts ######################
  Scenario: N01 In eine Auftragszeit für einen Betriebsauftrag/Arbeitsschein mit gesperrtem Fertigteil wird eine positive Gutmenge eingetragen
# Erwartetes Ergebnis: Beim Eintragen einer positiven Gutmenge kommt eine Fehlermeldung

    Given I open an editor "Auftragszeit" from table "(PDC):(OrderTime)" with command "NEW" for record ""
    And I set field "ma" to id from editor "mitarbeiter"
    And I set fields
      | asma    | BDE_000 |
      | mgr     | 101     |
      | anfdat  | .       |
      | anfzeit | 9:00    |
      | enddat  | .       |
      | endzeit | 9:45    |
# 10343 de      |Das Fertigteil ist gesperrt. Keine Zugangsbuchung möglich.
    Then setting field "istmge" to "1" throws the exception "10343"
    And I close the current editor


  Scenario: N02 In eine Auftragszeit für einen Betriebsauftrag/Arbeitsschein mit gesperrtem Fertigteil wird eine negative Gutmenge eingetragen.
# Erwartetes Ergebnis: Beim Eintragen einer negativen Gutmenge kommt keine Fehlermeldung

    Given I open an editor "Auftragszeit" from table "(PDC):(OrderTime)" with command "NEW" for record ""
    And I set field "ma" to id from editor "mitarbeiter"
    And I set fields
      | asma    | BDE_000 |
      | mgr     | 101     |
      | anfdat  | .       |
      | anfzeit | 9:00    |
      | enddat  | .       |
      | endzeit | 9:45    |
      | istmge  | -2      |
    And I save the current editor


  Scenario: N03 In eine Auftragszeit für einen Betriebsauftrag/Arbeitsschein mit gesperrtem Fertigteil wird ein negativer Ausschuss eingetragen.
# Erwartetes Ergebnis: Beim Eintragen eines negativen Ausschusses kommt keine Fehlermeldung

    Given I open an editor "Auftragszeit" from table "(PDC):(OrderTime)" with command "NEW" for record ""
    And I set field "ma" to id from editor "mitarbeiter"
    And I set fields
      | asma    | BDE_000 |
      | mgr     | 101     |
      | anfdat  | .       |
      | anfzeit | 10:00   |
      | enddat  | .       |
      | endzeit | 10:15   |
      | ausmge  | -3      |
    And I save the current editor


  Scenario: N04 In einen Kurzläufer für einen Betriebsauftrag/Arbeitsschein mit gesperrtem Fertigteil wird eine positive Gutmenge eingetragen.
# Erwartetes Ergebnis: Beim Eintragen einer positiven Gutmenge kommt eine Fehlermeldung

    Given I open an editor "Kurzläufer" from table "(PDC):(ShortProductionOrder)" with command "NEW" for record ""
    And I set field "ma" to id from editor "mitarbeiter"
    And I set fields
      | asma    | BDE_000 |
      | mgr     | 101     |
      | anfdat  | .       |
      | anfzeit | 10:16   |
# 10343 de      |Das Fertigteil ist gesperrt. Keine Zugangsbuchung möglich.
    Then setting field "istmge" to "4" throws the exception "10343"
    And I close the current editor


  Scenario: N05 In einen Kurzläufer für einen Betriebsauftrag/Arbeitsschein mit gesperrtem Fertigteil wird eine negative Gutmenge eingetragen.
# Erwartetes Ergebnis: Beim Eintragen einer negativen Gutmenge kommt keine Fehlermeldung

    Given I open an editor "Auftragszeit" from table "(PDC):(ShortProductionOrder)" with command "NEW" for record ""
    And I set field "ma" to id from editor "mitarbeiter"
    And I set fields
      | asma    | BDE_000 |
      | mgr     | 101     |
      | anfdat  | .       |
      | anfzeit | 10:20   |
      | istmge  | -5      |
    And I save the current editor


  Scenario: N06 In einen Kurzläufer für einen Betriebsauftrag/Arbeitsschein mit gesperrtem Fertigteil wird ein negativer Aussschuss eingetragen.
# Erwartetes Ergebnis: Beim Eintragen eines negativen Ausschusses kommt keine Fehlermeldung

    Given I open an editor "Auftragszeit" from table "(PDC):(ShortProductionOrder)" with command "NEW" for record ""
    And I set field "ma" to id from editor "mitarbeiter"
    And I set fields
      | asma    | BDE_000 |
      | mgr     | 101     |
      | anfdat  | .       |
      | anfzeit | 10:30   |
      | ausmge  | -6      |
    And I save the current editor


############### Ändern eines BDE Obejkts ######################
  Scenario: C00 Vorbereitung fuer Testszenarien. Bebuchbare Objekte anlegen.
# SWITCH-Artikel leere Sperre
    Given I open an editor "Artikel-switch" from table "(Part):(Product)" with command "UPDATE" for record "VK-SWITCH"
    And I set field "sperrkonfigurationneu" to ""
    And I save the current editor

    Given I open an editor "AZNeu" from table "(PDC):(OrderTime)" with command "NEW" for record ""
    And I set field "ma" to id from editor "mitarbeiter"
    And I set fields
      | asma    | BDE_000 |
      | mgr     | 101     |
      | anfdat  | .       |
      | anfzeit | 11:00   |
      | enddat  | .       |
      | endzeit | 11:15   |
      | istmge  | 1       |
    And I save the current editor

    Given I open an editor "KZNeu" from table "(PDC):(ShortProductionOrder)" with command "NEW" for record ""
    And I set field "ma" to id from editor "mitarbeiter"
    And I set fields
      | asma    | BDE_000 |
      | mgr     | 101     |
      | anfdat  | .       |
      | anfzeit | 11:20   |
      | istmge  | 4       |
    And I save the current editor

# Switch-Artikel sperren
    Given I open an editor "Artikel-switch" from table "(Part):(Product)" with command "UPDATE" for record "VK-SWITCH"
    And I set field "sperrkonfigurationneu" to "Standard-Artikelsperre"
    And I save the current editor

  Scenario: C01 Auftragszeit mit positiver Gutmenge wird mit ändern aufgerufen und gespeichert. Das Fertigteil wurde nach der Erfassung gesperrt.
# Erwartetes Ergebnis: Beim Speichern kommt eine Fehlermeldung

    Given I open an editor "AZChange" from table "(PDC):(OrderTime)" with command "UPDATE" for record from editor "AZNeu"
    And I set field "bem" to "Test Szenario C01"
# 10343 de      |Das Fertigteil ist gesperrt. Keine Zugangsbuchung möglich.
    Then saving the current editor throws the exception "10343"
    And I close the current editor


  Scenario: C02 Kurzläufer mit positiver Gutmenge wird mit ändern aufgerufen und gespeichert. Das Fertigteil wurde nach der Erfassung gesperrt.
# Erwartetes Ergebnis: Beim Speichern kommt eine Fehlermeldung

    Given I open an editor "KZChange" from table "(PDC):(ShortProductionOrder)" with command "UPDATE" for record from editor "KZNeu"
# 10343 de      |Das Fertigteil ist gesperrt. Keine Zugangsbuchung möglich.
    Then saving the current editor throws the exception "10343"
    And I close the current editor


############### Übertragen eines BDE Obejkts ######################
  Scenario: T01 Auftragszeit mit positiver Gutmenge wird mit ändern aufgerufen und das Feld "Beleg buchen" wird gesetzt. Das Fertigteil wurde nach der Erfassung gesperrt.
# Erwartetes Ergebnis: Beim Setzen des Flags kommt eine Fehlermeldung

    Given I open an editor "AZChangeT" from table "(PDC):(OrderTime)" with command "UPDATE" for record from editor "AZNeu"
# 10343 de      |Das Fertigteil ist gesperrt. Keine Zugangsbuchung möglich.
    Then setting field "sofort" to "ja" throws the exception "10343"
    And I close the current editor


  Scenario: T02 Kurzläufer mit positiver Gutmenge wird mit ändern aufgerufen und das Feld "Beleg buchen" wird gesetzt. Das Fertigteil wurde nach der Erfassung gesperrt.
# Erwartetes Ergebnis: Beim Setzen des Flags kommt eine Fehlermeldung

    Given I open an editor "KZChangeT" from table "(PDC):(ShortProductionOrder)" with command "UPDATE" for record from editor "KZNeu"
# 10343 de      |Das Fertigteil ist gesperrt. Keine Zugangsbuchung möglich.
    Then setting field "sofort" to "ja" throws the exception "10343"
    And I close the current editor


  Scenario: T03 Auftragszeit mit positiver Gutmenge wird über das Kommando übertragen gebucht. Das Fertigteil wurde nach der Erfassung gesperrt.
# Erwartetes Ergebnis: Beim Buchen kommt eine Fehlermeldung. Die Auftragszeit wird nicht gebucht.

    Given I open an editor "AZChangeT" from table "(PDC):(OrderTime)" with command "TRANSFER" for record from editor "AZNeu"
# 10343 de      |Das Fertigteil ist gesperrt. Keine Zugangsbuchung möglich.
    Then saving the current editor throws the exception "10343"
    And I close the current editor


  Scenario: T04 Kurzläufer mit positiver Gutmenge wird über das Kommando übertragen gebucht. Das Fertigteil wurde nach der Erfassung gesperrt.
# Erwartetes Ergebnis: Beim Buchen kommt eine Fehlermeldung. Der Kurzläufer wird nicht gebucht.

    Given I open an editor "KZChangeT" from table "(PDC):(ShortProductionOrder)" with command "TRANSFER" for record from editor "KZNeu"
# 10343 de      |Das Fertigteil ist gesperrt. Keine Zugangsbuchung möglich.
    Then saving the current editor throws the exception "10343"
    And I close the current editor
