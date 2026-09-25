@persistent
Feature: doppel_art_fv.feature

  Background:
    And I set the fake date to "03.02.1995"

# *****************************************************************************
#  Name             : doppel_art_fv
#  Autor            : drpf
#  Verantwortlich   : drpf
#  Kontrolle        : amk
#  Funktion         : Testet offene Fertigungsvorschlag 
#                     mit dem selben Artikel in zwei Arbeitsgaengen.
#                     Da Zuordnung beim Rueckbau nicht korrekt, DIag beim Storno.
#                     Erster Storno der Rückmeldung nur zur Absicherung, dass dieser funktioniert.
#                     Zwei Testfaelle mit unterschiedlicher Stueckliste. Ergab unterschiedliche Fehler, durch gleiche Ursache.
#  Diag             : 524603
# *****************************************************************************

  Scenario: Arbeitsgang
    Given I open an editor "montieren1" from table "(Operation):(Operation)" with command "STORE" for record ""
    And I set fields
      | such     | montieren1 |
      | namebspr | montieren1 |
      | mgr      | 112        |
      | aschein  | ja         |
    And I save the current editor

    Given I open an editor "montieren2" from table "(Operation):(Operation)" with command "STORE" for record ""
    And I set fields
      | such     | montieren2 |
      | namebspr | montieren2 |
      | mgr      | 112        |
      | aschein  | ja         |
    And I save the current editor

  Scenario: Artikel
# Schraube (Einkauf)
    Given I open an editor "schraube" from table "(Part):(Product)" with command "STORE" for record ""
    And I set fields
      | such     | Schraube |
      | namebspr | Schraube |
    And I save the current editor

# Unterlegscheibe (Einkauf)
    Given I open an editor "unterlegscheibe" from table "(Part):(Product)" with command "STORE" for record ""
    And I set fields
      | such     | Unterlegscheibe |
      | namebspr | Unterlegscheibe |
    And I save the current editor

# Kunst (Fertigteil)
    Given I open an editor "<such>" from table "(Part):(Product)" with command "STORE" for record ""
    And I set fields
      | such     | Kunst          |
      | namebspr | Kunst          |
      | bsart    | Eigenfertigung |
    And I delete all rows
    And I append rows
      | elex            | anzahl |
      | Unterlegscheibe | 1      |
      | Schraube        | 1      |
      | A montieren1    | 1      |
      | Unterlegscheibe | 2      |
      | Schraube        | 3      |
      | A montieren2    | 1      |
    And I save the current editor

  Scenario: Testfall
# Fertigungsvorschlag anlegen und freigeben
    Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
    And I append rows
      | artikel | netmge | bisuch  | mfreig |
      | kunst   | 100    | doppel_ | ja     |
    And I press button "freig" to open a subeditor for "BA_freigeben"
    And I close the current editor
    And I switch the current editor to editor "fvor"
    And I save the current editor
    And I close the current editor

# Rückmeldung erzeugen
    Given I open an editor "Rückmeldung1" from table "(Workorder):(WorkOrders)" with command "DONE" for record "doppel_000"
    And I set field "sofort" to "1"
    And I set field "mgr" to "101"
    And I set field "gutmge" to "40" in row 1
    And I save the current editor
    And I close the current editor

# Rückmeldung stornieren
    Given I open an editor "Storno1" via ID from editor "Rückmeldung1" from field "id" in row 0 for table "(Workorder):(CompletionConfirmations)" with command "REVERSAL"
    And I save the current editor

# zweite Rückmeldung erzeugen
    Given I open an editor "Rückmeldung2" from table "(Workorder):(WorkOrders)" with command "DONE" for record "doppel_000"
    And I set field "sofort" to "1"
    And I set field "mgr" to "101"
    And I set field "gutmge" to "30" in row 1
    And I save the current editor
    And I close the current editor

# Rückbau
    Given I open an editor "Rückbau1" from table "(Workorder):(WorkOrders)" with command "RETURN" for record "doppel_000"
    And I set field "sofort" to "ja"
    And I set field "mgr" to "101"
    And I set field "gutmge" to "-10" in row 1
    And I save the current editor

# Rückbau stornieren
    Given I open an editor "Storno2" via ID from editor "Rückbau1" from field "id" in row 0 for table "(Workorder):(CompletionConfirmations)" with command "REVERSAL"
    And I save the current editor

  Scenario: Artikel zwei
# Schraube (Einkauf)
    Given I open an editor "schraube2" from table "(Part):(Product)" with command "STORE" for record ""
    And I set fields
      | such     | Schraube2 |
      | namebspr | Schraube2 |
    And I save the current editor

# Kunst (Fertigteil)
    Given I open an editor "<such>" from table "(Part):(Product)" with command "STORE" for record ""
    And I set fields
      | such     | Kunst2         |
      | namebspr | Kunst2         |
      | bsart    | Eigenfertigung |
    And I delete all rows
    And I append rows
      | elex         | anzahl |
      | Schraube     | 1      |
      | A montieren1 | 1      |
      | Schraube     | 1      |
      | A montieren2 | 1      |
    And I save the current editor

  Scenario: Testfall zwei
# Fertigungsvorschlag anlegen und freigeben
    Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
    And I append rows
      | artikel | netmge | bisuch   | mfreig |
      | kunst2  | 100    | doppel2_ | ja     |
    And I press button "freig" to open a subeditor for "BA_freigeben"
    And I close the current editor
    And I switch the current editor to editor "fvor"
    And I save the current editor
    And I close the current editor

# Rückmeldung erzeugen
    Given I open an editor "Rückmeldung1" from table "(Workorder):(WorkOrders)" with command "DONE" for record "doppel2_000"
    And I set field "sofort" to "1"
    And I set field "mgr" to "101"
    And I set field "gutmge" to "40" in row 1
    And I save the current editor
    And I close the current editor

# Rückmeldung stornieren
    Given I open an editor "Storno1" via ID from editor "Rückmeldung1" from field "id" in row 0 for table "(Workorder):(CompletionConfirmations)" with command "REVERSAL"
    And I save the current editor

# zweite Rückmeldung erzeugen
    Given I open an editor "Rückmeldung2" from table "(Workorder):(WorkOrders)" with command "DONE" for record "doppel2_000"
    And I set field "sofort" to "1"
    And I set field "mgr" to "101"
    And I set field "gutmge" to "30" in row 1
    And I save the current editor
    And I close the current editor

# Rückbau
    Given I open an editor "Rückbau1" from table "(Workorder):(WorkOrders)" with command "RETURN" for record "doppel2_000"
    And I set field "sofort" to "ja"
    And I set field "mgr" to "101"
    And I set field "gutmge" to "-10" in row 1
    And I save the current editor

# Rückbau stornieren
    Given I open an editor "Storno2" via ID from editor "Rückbau1" from field "id" in row 0 for table "(Workorder):(CompletionConfirmations)" with command "REVERSAL"
    And I save the current editor
