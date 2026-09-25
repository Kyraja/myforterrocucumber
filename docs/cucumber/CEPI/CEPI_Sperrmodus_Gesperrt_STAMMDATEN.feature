@persistent
Feature: CEPI_Sperrmodus_Gesperrt_STAMMDATEN.feature

# *****************************************************************************
#  Name             : CEPI_Sperrmodus_Gesperrt_STAMMDATEN
#  Autor            : lschneider
#  Verantwortlich   : bheim
#  Kontrolle        : dglintz
#  Jira-Issue       : FDA-1308
#  Funktion         : Testet das Verhalten von gesperrten Artikeln in den
#                     Stammdaten, sowie Aendern einer gesperrten Zusatzposition
#
# *****************************************************************************

  Scenario: 01 Gesperrter Artikel kann in die Stammstueckliste eines Artikels eingetragen werden

    Given I open an editor "FLGESPERRT" from table "(Part):(Product)" with command "STORE" for record "FLGESPERRT"
    And I set fields
      | such     | FLGESPERRT                |
      | namebspr | FL mit gesperrtem Artikel |
      | bsart    | Eigenfertigung            |
    And I delete all rows
    And I append rows
      | elex        | elanzahl    |
      | EK-GESPERRT | 1           |
      | A MONTAGE1  | !dontChange |
    And I save the current editor


  Scenario: 02 Gesperrter Setartikel kann in die Stammstueckliste eines Artikels eingetragen werden

# Gesperrten Setartikel anlegen
    Given I open an editor "SETSPERR" from table "(Part):(Product)" with command "STORE" for record "SETSPERR"
    And I set fields
      | such                  | SETSPERR               |
      | namebspr              | gesperrter Setartikel  |
      | sperrkonfigurationneu | Standard-Artikelsperre |
      | bsart                 | Eigenfertigung         |
      | earta                 | über Stückliste        |
    And I delete all rows
    And I append rows
      | elex  | elanzahl |
      | FEDER | 1        |
      | MINE  | 1        |
    And I save the current editor

# gesperrter Setartikel kann in Fertigungsliste eingetragen werden
    Given I open an editor "BG-SETSPERR" from table "(Part):(Product)" with command "STORE" for record "BG-SETSPERR"
    And I set fields
      | such     | BG-SETSPERR                  |
      | namebspr | BG mit gesperrtem Setartikel |
      | bsart    | Eigenfertigung               |
    And I delete all rows
    And I append rows
      | elex       | elanzahl    |
      | SETSPERR   | 1           |
      | A MONTAGE1 | !dontChange |
    And I save the current editor


  Scenario: 03 Setartikel mit gesperrter Set-Komponente kann in die Stammstueckliste eines Artikels eingetragen werden

# Setartikel mit gesperrter Komponente anlegen
    Given I open an editor "SET-KOMPSPERR" from table "(Part):(Product)" with command "STORE" for record "SET-KOMPSPERR"
    And I set fields
      | such     | SET-KOMPSPERR                |
      | namebspr | Set mit gesperrte Komponente |
      | bsart    | Eigenfertigung               |
      | earta    | über Stückliste              |
    And I delete all rows
    And I append rows
      | elex          | elanzahl |
      | EK-GESPERRT   | 1        |
      | EK-OHNESPERRE | 1        |
    And I save the current editor

# Setartikel mit gesperrter Komponente kann in Fertigungsliste eingetragen werden
    Given I open an editor "BG-SETSPERR2" from table "(Part):(Product)" with command "STORE" for record "BG-SETSPERR2"
    And I set fields
      | such     | BG-SETSPERR2                    |
      | namebspr | BG m. gesperrter Set-Komponente |
      | bsart    | Eigenfertigung                  |
    And I delete all rows
    And I append rows
      | elex         | elanzahl    |
      | SET-KOMPSPER | 1           |
      | A MONTAGE1   | !dontChange |
    And I save the current editor


  Scenario: 04 Ein gesperrter Artikel kann nicht als Nachfolgeartikels gesetzt werden

    Given I open an editor "AUSLAUF" from table "(Part):(Product)" with command "NEW" for record ""
    And I set fields
      | such     | AUSLAUF                      |
      | namebspr | Artikel mit Nachfolgeartikel |
# 4806 de |Objekt ist gesperrt.
    And setting field "nachfolgeartikel" to "EK-GESPERRT" throws the exception "1361"
    And I close the current editor


  Scenario: 05 Gesperrter Artikel kann in neue und bestehende Fertigungsliste eingetragen werden, Maske

    Given I open an editor "FLGESPERRT" from table "(ProductionList):(ProductionList)" with command "NEW" for record ""
    And I set field "such" to "FLGESPERRT"
    And I delete all rows
    And I append rows
      | elex        | elanzahl |
      | EK-GESPERRT | 1        |
    And I save the current editor

    And I switch the current editor to editor "FLGESPERRT" with command "UPDATE"
    And I append rows
      | elex        | elanzahl |
      | VK-GESPERRT | 2        |
    And I save the current editor


  Scenario: 06 Gesperrter Artikel kann in neue und bestehende Dienstleistungs-Stammstueckliste eingetragen werden

    Given I open an editor "DL-07" from table "(Part):(Service)" with command "NEW" for record ""
    And I set field "such" to "DL-07"
    And I delete all rows
    And I append rows
      | elex        | elanzahl |
      | EK-GESPERRT | 2        |
    And I save the current editor

    And I switch the current editor to editor "DL-07" with command "UPDATE"
    And I set field "such" to "DL-07"
    And I append rows
      | elex        | elanzahl |
      | VK-GESPERRT | 2        |
    And I save the current editor


  Scenario Outline: Nur Zusatzposition vom Typ AU/BE-Position koennen gesperrt werden; beim Aendern des Typs wird Sperre entfernt

    Given I open an editor "ZUSATZ-GESPERRT" from table "(Part):(SupplementaryItem)" with command "UPDATE" for record "ZUSATZ-GESPERRT"
    Then field "zptyp" has value "AU/BE-Position,BV"
    Then field "sperrkonfigurationneu" has value "Standard-Zusatzpositionssperre"
    And I set field "zptyp" to "<zptyp>"
    Then field "sperrkonfigurationneu" is not modifiable
    Then field "sperrkonfigurationneu" has value ""
    And I close the current editor

    Examples:
      | zptyp                        |
      | Zwischensumme                |
      | Gesamtsumme                  |
      | USt/VSt-Position (zuzüglich) |
      | USt/VSt-Position (inklusive) |
      | Prozentposition              |
      | neutrale Position            |
      | Mindestbestellwertposition   |
      | Materialzuschlag             |
      | Trennposition                |
      | Endsumme                     |
      | Nettosummenposition          |
      | Text                         |
      | Seite                        |
      | Absatz                       |
